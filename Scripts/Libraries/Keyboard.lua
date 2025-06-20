local Keyboard = {
    keys = {}, 
    binds = {},
    progresses = {},
    simulatedKeys = {},
    allowInput = true
}

-- 0, 1, 2, -1
for i = 97, 122, 1
do
    table.insert(Keyboard.keys, {id = string.char(i), state = 0, pressed = false, pressaux = false})
end
for i = 48, 57, 1
do
    table.insert(Keyboard.keys, {id = string.char(i), state = 0, pressed = false, pressaux = false})
end
for i = 1, 12
do
    table.insert(Keyboard.keys, {id = "f" .. i, state = 0, pressed = false, pressaux = false})
end
for i = 0, 9, 1
do
    table.insert(Keyboard.keys, {id = tostring(i), state = 0, pressed = false, pressaux = false})
    table.insert(Keyboard.keys, {id = "kp" .. tostring(i), state = 0, pressed = false, pressaux = false})
end

table.insert(Keyboard.keys, {id = "space", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "return", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "escape", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "backspace", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "tab", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "lshift", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "rshift", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "lctrl", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "rctrl", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "lalt", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "ralt", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "capslock", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "numlock", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "scrolllock", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "printscreen", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "pause", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "insert", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "delete", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "home", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "end", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "pageup", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "pagedown", state = 0, pressed = false, pressaux = false})

table.insert(Keyboard.keys, {id = "[", state = 0, pressed = false, pressaux = false})  -- [
table.insert(Keyboard.keys, {id = "]", state = 0, pressed = false, pressaux = false}) -- ]
table.insert(Keyboard.keys, {id = "\\", state = 0, pressed = false, pressaux = false})    -- \
table.insert(Keyboard.keys, {id = ";", state = 0, pressed = false, pressaux = false})   -- ;
table.insert(Keyboard.keys, {id = "'", state = 0, pressed = false, pressaux = false})   -- '
table.insert(Keyboard.keys, {id = ",", state = 0, pressed = false, pressaux = false})         -- ,
table.insert(Keyboard.keys, {id = ".", state = 0, pressed = false, pressaux = false})       -- .
table.insert(Keyboard.keys, {id = "/", state = 0, pressed = false, pressaux = false})        -- /
table.insert(Keyboard.keys, {id = "`", state = 0, pressed = false, pressaux = false})        -- `
table.insert(Keyboard.keys, {id = "-", state = 0, pressed = false, pressaux = false})       -- -
table.insert(Keyboard.keys, {id = "=", state = 0, pressed = false, pressaux = false})       -- =

table.insert(Keyboard.keys, {id = "up", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "down", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "left", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "right", state = 0, pressed = false, pressaux = false})

table.insert(Keyboard.keys, {id = "mouse1", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "mouse2", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "mouse3", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "mouse4", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "mouse5", state = 0, pressed = false, pressaux = false})

table.insert(Keyboard.keys, {id = "kp/", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "kp*", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "kp-", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "kp+", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "kp.", state = 0, pressed = false, pressaux = false})
table.insert(Keyboard.keys, {id = "kp=", state = 0, pressed = false, pressaux = false})

function Keyboard.Bind(name, ...)
    local keys = {...}
    Keyboard.binds[name] = {}

    local tab = Keyboard.binds[name]
    tab.keys = keys
    tab.state = 0
    tab.pressed = false
    tab.pressaux = false
end

Keyboard.Bind("shift", "lshift", "rshift")
Keyboard.Bind("ctrl", "lctrl", "rctrl")
Keyboard.Bind("alt", "lalt", "ralt")
Keyboard.Bind("confirm", "return", "z")
Keyboard.Bind("cancel", "x", "shift")
Keyboard.Bind("menu", "c", "ctrl")
Keyboard.Bind("arrows", "up", "down", "left", "right")

Keyboard.Bind("letter", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
Keyboard.Bind("number", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")


function Keyboard.SimulatePress(key)
    Keyboard.simulatedKeys[key] = {
        pressed = true,
        wasPressed = false
    }
end

function Keyboard.SimulateRelease(key)
    Keyboard.simulatedKeys[key] = {
        pressed = false,
        wasPressed = true
    }
end

function Keyboard.SimulateTap(key)
    Keyboard.SimulatePress(key)
end

function Keyboard.AllowPlayerInput(bool)
    Keyboard.allowInput = bool
end

function Keyboard.GetState(key)
    if (Keyboard.simulatedKeys[key]) then
        local simKey = Keyboard.simulatedKeys[key]
        if (simKey.pressed and not simKey.wasPressed) then
            return 1
        elseif (simKey.pressed and simKey.wasPressed) then
            return 2
        elseif (not simKey.pressed and simKey.wasPressed) then
            return -1
        else
            return 0
        end
    end

    if (Keyboard.allowInput) then
        for _, v in pairs(Keyboard.keys)
        do
            if (v.id == key:lower()) then
                return v.state
            end
        end
        if (Keyboard.binds[key]) then
            local anyPressed = false
            local allReleased = true
            local anyJustPressed = false
            local anyJustReleased = false
            for _, bindKey in pairs(Keyboard.binds[key].keys)
            do
                local state = Keyboard.GetState(bindKey)
                if (state == 1) then
                    anyJustPressed = true
                elseif (state == 2) then
                    anyPressed = true
                elseif (state == -1) then
                    anyJustReleased = true
                end
                if (state ~= -1) then
                    allReleased = false
                end
            end
            if (anyJustPressed) then
                return 1
            elseif (anyPressed) then
                return 2
            elseif (anyJustReleased) then
                return -1
            elseif (allReleased) then
                return 0
            else
                return 0
            end
        end
    end
    
    return 0
end

function Keyboard.GetMousePosition()
    local scale = math.min(love.graphics.getWidth() / 640, love.graphics.getHeight() / 480)
    local x, y = love.mouse.getPosition()
    if (scale ~= 1) then
        x = x - 240
    end
    return x / scale, y / scale
end

function Keyboard.ReturnLetter()
    local letter = ""
    local functionKeys = {
        "lshift", "rshift", "space", "lctrl", "rctrl", "lalt", "ralt", 
        "tab", "capslock", "enter", "esc", "backspace", "delete", 
        "insert", "home", "end", "pageup", "pagedown", "numlock",
        "scrolllock", "pause", "printscreen", "f1", "f2", "f3", "f4",
        "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12",
        "up", "down", "left", "right", "mouse1", "mouse2", "mouse3", "mouse4", "mouse5"
    }

    local isFunctionKey = {}
    for _, key in ipairs(functionKeys) do
        isFunctionKey[key] = true
    end

    local symbolMappings = {
        ["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%",
        ["6"] = "^", ["7"] = "&", ["8"] = "*", ["9"] = "(", ["0"] = ")",

        ["-"] = "_", ["="] = "+", ["["] = "{", ["]"] = "}", ["\\"] = "|",
        [";"] = ":", ["'"] = "\"", [","] = "<", ["."] = ">", ["/"] = "?",
        ["`"] = "~"
    }
    
    for _, v in pairs(Keyboard.keys) do
        if v.state == 1 and not isFunctionKey[v.id] then
            if string.match(v.id, "^[a-z]$") then
                letter = v.id
                if Keyboard.GetState("shift") >= 1 then
                    letter = string.upper(letter)
                end
                break
            elseif symbolMappings[v.id] then
                if Keyboard.GetState("shift") >= 1 then
                    letter = symbolMappings[v.id]
                else
                    letter = v.id
                end
                break
            end
        end
    end
    return letter
end

function Keyboard.AutoPress(key, duration)
    local progress = {}
    progress.duration = (duration or 1)
    progress.key = key
    progress.timer = 0

    if (type(key) ~= "string") then
        print("Keyboard.AutoPress: key must be a string")
    end

    table.insert(Keyboard.progresses, progress)
    return progress
end

function Keyboard.Update()
    for _, v in pairs(Keyboard.keys)
    do
        if (type(v.id) == "string") then
            if (not string.find(v.id, "mouse")) then
                if (love.keyboard.isDown(v.id)) then
                    v.pressed = true
                else
                    v.pressed = false
                end
                if (v.pressed and v.pressed == v.pressaux) then
                    v.state = 2
                end
                if (not v.pressed and v.pressed == v.pressaux) then
                    v.state = 0
                end
                if (v.pressed ~= v.pressaux) then
                    if (v.pressed and not v.pressaux) then
                        v.state = 1
                    else
                        v.state = -1
                    end
                    v.pressaux = v.pressed
                end
            else
                if (love.mouse.isDown(v.id:sub(-1))) then
                    v.pressed = true
                else
                    v.pressed = false
                end
                if (v.pressed and v.pressed == v.pressaux) then
                    v.state = 2
                end
                if (not v.pressed and v.pressed == v.pressaux) then
                    v.state = 0
                end
                if (v.pressed ~= v.pressaux) then
                    if (v.pressed and not v.pressaux) then
                        v.state = 1
                    else
                        v.state = -1
                    end
                    v.pressaux = v.pressed
                end
            end
        end
    end

    for i = #Keyboard.progresses, 1, -1
    do
        local progress = Keyboard.progresses[i]
        if (progress.timer <= progress.duration) then
            if (progress.timer == 1) then
                Keyboard.SimulatePress(progress.key)
            end
        else
            Keyboard.SimulateRelease(progress.key)
            table.remove(Keyboard.progresses, i)
        end
        progress.timer = progress.timer + 1
    end
end

return Keyboard