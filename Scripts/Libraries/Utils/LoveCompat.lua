local love_compat = {}

local major, minor, revision = love.getVersion()
local version_num = major * 10000 + minor * 100 + revision
love_compat.version = {major = major, minor = minor, revision = revision, num = version_num}
local V11 = 11000  -- LÖVE 11.0
local V113 = 11030  -- LÖVE 11.3
local V114 = 11040  -- LÖVE 11.4

local function needs_compat(min_version)
    return version_num < min_version
end

if (needs_compat(V113)) then
    if (not love.filesystem.createDirectory) then
        love.filesystem.createDirectory = function(dir)
            local success, err = pcall(function()
                local marker = dir .. "/.dir_marker"
                love.filesystem.write(marker, "")
                love.filesystem.remove(marker)
            end)
            return success
        end
    end
end

if (needs_compat(V114)) then
    local originalGetDirectoryItems = love.filesystem.getDirectoryItems
    love.filesystem.getDirectoryItems = function(dir, recursive)
        if (not recursive) then
            return originalGetDirectoryItems(dir)
        end

        local items = {}
        local function scan(path)
            local files = originalGetDirectoryItems(path)
            for _, file in ipairs(files) do
                local fullpath = path .. "/" .. file
                table.insert(items, fullpath)
                local info = love.filesystem.getInfo(fullpath)
                if info and info.type == "directory" then
                    scan(fullpath)
                end
            end
        end
        scan(dir)
        return items
    end
end

if needs_compat(V113) then
    local originalNewCanvas = love.graphics.newCanvas
    love.graphics.newCanvas = function(width, height, settings)
        if (type(settings) == "table") then
            return originalNewCanvas(width, height)
        end
        return originalNewCanvas(width, height, settings)
    end
end

if needs_compat(V11) then
    if (not love.window.getDPIScale) then
        love.window.getDPIScale = function()
            return 1
        end
    end
end

if needs_compat(V113) then
    if (not love.math.compress) then
        love.math.compress = function(data, format, level)
            error("love.math.compress not supported in this LÖVE version")
        end
    end

    if (not love.math.decompress) then
        love.math.decompress = function(data, format)
            error("love.math.decompress not supported in this LÖVE version")
        end
    end
end

function love_compat.isSupported(feature)
    local features = {
        ["filesystem.createDirectory"] = version_num >= V113,
        ["filesystem.getDirectoryItems.recursive"] = version_num >= V114,
        ["graphics.newCanvas.settings"] = version_num >= V113,
        ["window.getDPIScale"] = version_num >= V11,
        ["math.compress"] = version_num >= V113,
        ["math.decompress"] = version_num >= V113
    }

    return features[feature] or false
end

function love_compat.getVersion()
    return love_compat.version
end

function love_compat.printReport()
    print("=== LÖVE Compatibility Report ===")
    print(string.format("Running LÖVE version: %d.%d.%d", major, minor, revision))
    print("\nSupported features:")
    for feature, supported in pairs({
        ["createDirectory"] = love_compat.isSupported("filesystem.createDirectory"),
        ["recursive directory listing"] = love_compat.isSupported("filesystem.getDirectoryItems.recursive"),
        ["canvas settings"] = love_compat.isSupported("graphics.newCanvas.settings"),
        ["DPI scale"] = love_compat.isSupported("window.getDPIScale"),
        ["data compression"] = love_compat.isSupported("math.compress")
    }) do
        print(string.format("  %-25s: %s", feature, supported and "YES" or "NO"))
    end
end

return love_compat