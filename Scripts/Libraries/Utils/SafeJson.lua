local safejson = {}
safejson.json = require("Scripts.Libraries.Utils.dkjson")

safejson.config = {
    badwords = {
        ["eval"] = true,
        ["exec"] = true,
        ["execscript"] = true,  -- execScript → execscript
        ["function"] = true,    -- Function → function
        ["__proto__"] = true,
        ["constructor"] = true,
        ["prototype"] = true,
        ["settimeout"] = true,  -- setTimeout → settimeout
        ["setinterval"] = true, -- setInterval → setinterval
        ["window"] = true,
        ["document"] = true,
        ["global"] = true,
        ["process"] = true,
        ["import"] = true,
        ["require"] = true,
        ["XMLHttpRequest"] = true,
        ["fetch"] = true,
        ["WebSocket"] = true,
        ["localStorage"] = true,
        ["sessionStorage"] = true,
        ["alert"] = true,
        ["confirm"] = true,
        ["prompt"] = true,
        ["evalscript"] = true,  -- evalScript → evalscript

        ["script"] = true,
        ["iframe"] = true,
        ["onload"] = true,
        ["onerror"] = true,
        ["javascript:"] = true,
        ["os.execute"] = true,
        ["io.popen"] = true,
        ["\x00"] = true,    -- 空字符
        ["\\u0000"] = true  -- Unicode 空字符
    },
    max_depth = 100,
    max_items = 12000,
    max_string_length = 1e6,
    enable_precheck = true,
}

local error_types = {
    MALFORMED = 1,      -- JSON 格式错误
    UNSAFE_KEY = 2,     -- 危险键名
    CIRCULAR = 3,       -- 循环引用
    OVER_LIMIT = 4      -- 超出限制
}

local function precheck_json(str)
    if str:find("\\u[0-9a-fA-F][0-9a-fA-F]00") then  -- 检测可能的空字符变种
        return false, "Suspicious Unicode escape sequence"
    end
    if str:find("\\x[0-9a-fA-F][0-9a-fA-F]") and str:find("\\u[0-9a-fA-F]") then
        return false, "Mixed encoding detected"
    end
    if str:find("%[.-%].-:%[") then
        return false, "Array injection pattern detected"
    end
    return true
end

local function check_bom(str)
    if str:sub(1,3) == "\xEF\xBB\xBF" then
        return false, "BOM header detected"
    end
    return true
end

local function anti_tamper_check()
    if debug and debug.gethook then
        local hook = debug.gethook()
        if hook ~= nil then
            return false, "Debug hook detected"
        end
    end
    return true
end

local function check_resource_limits()
    if collectgarbage("count") > 100 * 1024 then
        return false, "Memory limit exceeded"
    end
    return true
end

local function check_object_safety(obj, path, visited, item_count, depth, config)
    path = path or ""
    visited = visited or {}
    item_count = item_count or 0
    depth = depth or 0

    if (visited[obj]) then
        return false, path .. " contains circular reference"
    end
    visited[obj] = true

    if (depth > config.max_depth) then
        return false, path .. " exceeds maximum depth"
    end
    if (item_count > config.max_items) then
        return false, path .. " exceeds maximum item count"
    end

    if (type(obj) == "number" and (obj ~= obj or math.abs(obj) == math.huge)) then
        return false, path .. " contains invalid number"
    end

    if (type(obj) == "table") then
        for k, v in pairs(obj) do
            item_count = item_count + 1
            if (item_count > config.max_items) then
                return false, path .. " exceeds maximum item count"
            end

            if (type(k) == "string" and config.badwords[k:lower()]) then
                return false, path .. " contains dangerous key: " .. k
            end

            if (type(v) == "string") then
                if (#v > config.max_string_length) then
                    return false, path .. " string too long"
                end
                local lower_v = v:lower()
                for word in pairs(config.badwords) do
                    if (lower_v:find(word, 1, true)) then
                        return false, path .. " contains dangerous value: " .. word
                    end
                end
            end

            local ok, err = check_object_safety(
                v,
                path .. (path == "" and "" or ".") .. tostring(k),
                visited,
                item_count,
                depth + 1,
                config
            )
            if (not ok) then return false, err end
        end
    end

    return true
end

function safejson.parse(jsonString, options)
    local ok, err = check_bom(jsonString)
    if not ok then return nil, err, error_types.MALFORMED end

    ok, err = anti_tamper_check()
    if not ok then return nil, err, error_types.UNSAFE_KEY end

    local config = setmetatable(options or {}, { __index = safejson.config })

    if config.enable_precheck and type(jsonString) == "string" then
        ok, err = precheck_json(jsonString)
        if not ok then return nil, err, error_types.MALFORMED end

        local max_precheck_length = math.min(#jsonString, config.max_string_length)
        local precheck_str = jsonString:sub(1, max_precheck_length):lower()
        for word in pairs(config.badwords) do
            if precheck_str:find(word, 1, true) then
                return nil, "Unsafe JSON detected (pre-check): " .. word, error_types.UNSAFE_KEY
            end
        end
    end

    local jsonData, _, err = safejson.json.decode(jsonString, 1, nil)
    if err then return nil, "JSON parsing error: " .. err, error_types.MALFORMED end

    ok, err = check_resource_limits()
    if not ok then return nil, err, error_types.OVER_LIMIT end

    local ok, safety_err = check_object_safety(jsonData, "", nil, 0, 0, config)
    if not ok then
        return nil, "Unsafe JSON structure: " .. safety_err,
               (safety_err:find("exceeds") and error_types.OVER_LIMIT or error_types.UNSAFE_KEY)
    end

    return jsonData
end

function safejson.encode(value)
    return safejson.json.encode(value)
end

return safejson