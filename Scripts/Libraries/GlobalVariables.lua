local globals = {}

function globals:SetVariable(name, value)
    globals[name] = value
end

function globals:GetVariable(name)
    return globals[name]
end

function globals:EnsureVariable(name, value)
    if (globals:GetVariable(name) == nil) then
        globals:SetVariable(name, value)
        return value
    else
        return globals:GetVariable(name)
    end
end

function globals:SetSaveVariable(name, value)
    if (not love.filesystem.getInfo("save")) then
        love.filesystem.createDirectory("save")
    end

    local value_str
    if (type(value) == "table") then
        local json = require("Scripts.Libraries.Utils.dkjson")
        value_str = json.encode(value, {indent = true})
    else
        value_str = tostring(value)
    end

    local success, error = love.filesystem.write("save/" .. name, value_str)
    if (not success) then
        print("Failed to save variable: " .. error)
        return false
    end
    return true
end

function globals:GetSaveVariable(name)
    local file_info = love.filesystem.getInfo("save/" .. name)
    if (not file_info) then
        print("Save file does not exist: save/" .. name)
        return nil
    end

    local value_str, error = love.filesystem.read("save/" .. name)
    if (not value_str) then
        print("Failed to read save file: " .. error)
        return nil
    end

    local success, value = pcall(function()
        local json = require("Scripts.Libraries.Utils.dkjson")
        return json.decode(value_str)
    end)
    
    if (value) then
        return value
    else
        return value_str
    end
end

function globals:EnsureSaveVariable(name, value)
    if (globals:GetSaveVariable(name) == nil) then
        globals:SetSaveVariable(name, value)
        return value
    else
        return globals:GetSaveVariable(name)
    end
end

function globals:DeleteSaveVariable(name)
    local file_path = "save/" .. name
    local file_info = love.filesystem.getInfo(file_path)

    if not file_info then
        print("Save file does not exist: " .. file_path)
        return false
    end

    local success, error = love.filesystem.remove(file_path)
    if not success then
        print("Failed to delete save file: " .. error)
        return false
    end

    return true
end

return globals