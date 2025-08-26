local typers = {
    instances = {}
}

local functions = {
    Reset = function(typer)
        for j = #typer.letters, 1, -1
        do
            local letter = typer.letters[j]
            if (letter and letter.isactive) then
                letter.isactive = false
                table.remove(typer.letters, j)
            end
        end
        typer.cantype = true
        typer.time = 4
        typer.sleep = 4
        typer.interval = 4
        typer.counter = 1

        typer.canskip = true
        typer.skipping = false
        typer.skipcount = 1
        typer.scale = 1

        -- resource.
        typer.fonts = {"determination_mono.ttf", "simsun.ttc"}
        typer.currentfont = 1
        typer.fontsize = {26, 13}
        typer.color = {1, 1, 1}
        typer.alpha = 1
        typer.positions = {
            main = {0, 0},     -- This is the main position where the letters will be drawn.
            spacing = {0, 5},  -- This is the spacing between each letter.
            offset = {
                {0, 0}, {0, 2}
            },   -- This is the offset between the main position and the current letter(Based on which font is used).
            withFont = {0, 0}  -- When the font is loaded, this is the y position of the font.
        }
        typer.texturelen = {0, 0}

        typer.canvoice = true
        typer.voices = {
            "v_monster.wav"
        }
        typer.effect = {
            name = "",
            intensity = 0
        }
        typer.shadow.use = false
    end,
    GetLettersSize = function(typer)
        return unpack(typer.texturelen)
    end,
    ShowBubble = function(typer, direction, position)
        typer.bubble.main_rect_h.alpha = 1
        typer.bubble.main_rect_v.alpha = 1
        typer.bubble.tail.alpha = 1
        typer.bubble.corner_ul.alpha = 1
        typer.bubble.corner_ur.alpha = 1
        typer.bubble.corner_dl.alpha = 1
        typer.bubble.corner_dr.alpha = 1

        local target = typer.bubble
        local tail = target.tail
        if (direction:lower() == "left") then
            tail:MoveTo(
                target.main_rect_h.x - 0,
                target.main_rect_h.y + (position * target.main_rect_h.yscale)
            )
        elseif (direction:lower() == "right") then
            tail.rotation = 180
            tail:MoveTo(
                target.main_rect_h.x + target.main_rect_h.xscale,
                target.main_rect_h.y + (position * target.main_rect_h.yscale)
            )
        elseif (direction:lower() == "up") then
            tail.rotation = 90
            tail:MoveTo(
                target.main_rect_h.x + (position * target.main_rect_h.xscale),
                target.main_rect_h.y - 20
            )
        elseif (direction:lower() == "down") then
            tail.rotation = -90
            tail:MoveTo(
                target.main_rect_h.x + (position * target.main_rect_h.xscale),
                target.main_rect_h.y + target.main_rect_h.yscale + 20
            )
        else
            error("Invalid direction for typers: " .. tostring(direction))
        end
    end,
    HideBubble = function(typer)
        typer.bubble.main_rect_h.alpha = 0
        typer.bubble.main_rect_v.alpha = 0
        typer.bubble.tail.alpha = 0
        typer.bubble.corner_ul.alpha = 0
        typer.bubble.corner_ur.alpha = 0
        typer.bubble.corner_dl.alpha = 0
        typer.bubble.corner_dr.alpha = 0
    end,
    SetText = function(typer, texts, instant)
        typer:Reset()
        typer.sentence = 1
        if (type(texts) == "string") then
            typer.sentences = {texts}
        elseif (type(texts) == "table") then
            typer.sentences = texts
        end
        if (instant) then
            typer.skipping = true
            typer.skipcount = typer.sentences[1]:len()
        end
    end,
    Destroy = function(typer)
        for k, typa in pairs(layers.objects)
        do
            if (typa == typer) then
                table.remove(layers.objects, k)
            end
        end
        for i = #typers.instances, 1, -1
        do
            if (typers.instances[i] == typer) then
                for j = #typer.letters, 1, -1
                do
                    local letter = typer.letters[j]
                    if (letter and letter.isactive) then
                        letter.isactive = false
                        table.remove(typer.letters, j)
                    end
                end
                typer.bubble.main_rect_h:Remove()
                typer.bubble.main_rect_v:Remove()
                typer.bubble.tail:Remove()
                typer.bubble.corner_ul:Remove()
                typer.bubble.corner_ur:Remove()
                typer.bubble.corner_dl:Remove()
                typer.bubble.corner_dr:Remove()

                typer.letters = {}
                typer.isactive = false
                typer.cantype = false
                typer.time = 0
                typer.sentence = 0
                typer.sleep = 0
                typer.interval = 0
                table.remove(typers.instances, i)
            end
        end
        for i = #layers.objects, 1, -1
        do
            if (layers.objects[i] == typer) then
                table.remove(layers.objects, i)
            end
        end
    end,
    Remove = function(typer)
        typer:Destroy()
    end
}
functions.__index = functions

local functions_instant = {
    GetLettersSize = function(typer)
        local width = 0
        local maxHeight = 0

        for _, piece in ipairs(typer.parsed) do
            local fontkey = piece.font .. "_" .. piece.size
            local font = typer.fontCache and typer.fontCache[fontkey]
            if not font then
                font = love.graphics.newFont("Resources/Fonts/" .. piece.font, piece.size)
                font:setFilter("nearest", "nearest")
                if typer.fontCache then
                    typer.fontCache[fontkey] = font
                end
            end
            width = width + font:getWidth(piece.char) + (typer.charspacing or 0)
            maxHeight = math.max(maxHeight, font:getHeight())
        end

        return width, maxHeight
    end,
    SetText = function(typer, text)
        typer.defaultFont = "determination_mono.ttf"
        typer.defaultSize = 26
        typer.charspacing = 0
        typer.offset = {0, 0}
        typer.alpha = 1
        typer.color = {1, 1, 1}
        if type(text) ~= "string" then
            text = tostring(text)
        end
        typer.rawtext = text
        typer:Reparse()
    end,
    Destroy = function(typer)
        for k, typa in pairs(layers.objects)
        do
            if (typa == typer) then
                table.remove(layers.objects, k)
            end
        end
        for i = #typers.instances, 1, -1
        do
            if (typers.instances[i] == typer) then
                typer.text = ""
                if (typer.cachedFont) then
                    typer.cachedFont:release()
                end
                table.remove(typers.instances, i)
                typer = nil
            end
        end
        for i = #layers.objects, 1, -1
        do
            if (layers.objects[i] == typer) then
                table.remove(layers.objects, i)
            end
        end
    end,
    Remove = function(typer)
        typer:Destroy()
    end
}
functions_instant.__index = functions_instant

local function ByteLength(b)
    local d = 1
    if (b) then
        if b > 239 then
            d = 4
        elseif b > 223 then
            d = 3
        elseif b > 128 then
            d = 2
        else
            d = 1
        end
    end
    return d
end

function typers.SpawnBubble(x, y, w, h, layer)
    local bubble = {}

    local offsetX, offsetY = -10, 10

    bubble.main_rect_h = sprites.CreateSprite("px.png", layer)
    bubble.main_rect_h:MoveTo(x + offsetX, y + offsetY)
    bubble.main_rect_h:Scale(w, h - 40)
    bubble.main_rect_h.alpha = 0
    bubble.main_rect_h:Pivot(0, 0)
    bubble.main_rect_v = sprites.CreateSprite("px.png", layer)
    bubble.main_rect_v:MoveTo(
        bubble.main_rect_h.x + bubble.main_rect_h.xscale / 2,
        bubble.main_rect_h.y + bubble.main_rect_h.yscale / 2
    )
    bubble.main_rect_v:Scale(w - 40, h)
    bubble.main_rect_v.alpha = 0
    bubble.tail = sprites.CreateSprite("Bubble/spr_bubbletail.png", layer)
    bubble.tail:MoveTo(x + offsetX, y)
    bubble.tail.alpha = 0

    bubble.corner_ul = sprites.CreateSprite("Bubble/spr_bubblecorner.png", layer)
    bubble.corner_ul:MoveTo(
        bubble.main_rect_h.x + 10,
        bubble.main_rect_h.y - 10
    )
    bubble.corner_ul.alpha = 0
    bubble.corner_ur = sprites.CreateSprite("Bubble/spr_bubblecorner.png", layer)
    bubble.corner_ur:MoveTo(
        bubble.main_rect_h.x + bubble.main_rect_h.xscale - 10,
        bubble.main_rect_h.y - 10
    )
    bubble.corner_ur.xscale = -1
    bubble.corner_ur.alpha = 0
    bubble.corner_dl = sprites.CreateSprite("Bubble/spr_bubblecorner.png", layer)
    bubble.corner_dl:MoveTo(
        bubble.main_rect_h.x + 10,
        bubble.main_rect_h.y + bubble.main_rect_h.yscale + 10
    )
    bubble.corner_dl.yscale = -1
    bubble.corner_dl.alpha = 0
    bubble.corner_dr = sprites.CreateSprite("Bubble/spr_bubblecorner.png", layer)
    bubble.corner_dr:MoveTo(
        bubble.main_rect_h.x + bubble.main_rect_h.xscale - 10,
        bubble.main_rect_h.y + bubble.main_rect_h.yscale + 10
    )
    bubble.corner_dr.xscale = -1
    bubble.corner_dr.yscale = -1
    bubble.corner_dr.alpha = 0

    return bubble
end

function typers.CreateText(sentences, position, layer, bubblesize, progressmode)
    local typer = {}

    typer.bubble = typers.SpawnBubble(position[1], position[2], bubblesize[1], bubblesize[2], layer - 0.00001)
    typer.letters = {}
    if (type(sentences) == "string") then
        typer.sentences = {sentences}
    elseif (type(sentences) == "table") then
        typer.sentences = sentences
    end
    typer.x = position[1]
    typer.y = position[2]
    typer.layer = layer or 0
    typer.bubblesize = (bubblesize or {0, 0})
    typer.progressmode = (progressmode or "none")
    typer.texturelen = {0, 0}

    typer.isactive = true
    typer.cantype = true
    typer.waitingforKey = false
    typer.KeyId = ""
    typer.time = 4
    typer.sentence = 1
    typer.sleep = 4
    typer.interval = 4
    typer.counter = 1
    typer.scale = 1

    typer.canskip = true
    typer.skipping = false
    typer.skipcount = 1
    typer.sentenceFinished = false
    typer.autoLefttime = 150
    typer.allowCtrlSkip = false

    -- resource.
    typer.fonts = {"determination_mono.ttf", "simsun.ttc"}
    typer.fontCache = {}
    typer.currentfont = 1
    typer.fontsize = {26, 13}
    typer.color = {1, 1, 1}
    typer.alpha = 1
    typer.positions = {
        main = {0, 0},     -- This is the main position where the letters will be drawn.
        spacing = {0, 5},  -- This is the spacing between each letter.
        offset = {
            {0, 0}, {0, 2}
        },   -- This is the offset between the main position and the current letter.
        withFont = {0, 0}  -- When the font is loaded, this is the y position of the font.
    }
    typer.canvoice = true
    typer.voices = {
        "v_monster.wav"
    }
    typer.shadow = {
        use = false,
        color = {0, 0, .3}
    }
    typer.effect = {
        name = "",
        intensity = 0
    }

    -- Callback functions.
    typer.OnComplete = function() end
    typer.OnUpdating = function() end

    local function getFont(fontname, size)
        local key = fontname .. "_" .. tostring(size)
        if (not typer.fontCache[key]) then
            local font = love.graphics.newFont("Resources/Fonts/" .. fontname, size)
            font:setFilter("nearest", "nearest")
            typer.fontCache[key] = font
        end
        return typer.fontCache[key]
    end

    function typer:Update()
        if (typer.isactive) then
            typer.time = typer.time + 1
            local sentence = typer.sentences[typer.sentence]

            if (typer.waitingforKey) then
                if (keyboard.GetState(typer.KeyId) == 1) then
                    typer.waitingforKey = false
                    typer.interval = typer.sleep
                end
            end

            if (typer.progressmode == "manual") then
                if (typer.canskip and not typer.skipping and not typer.waitingforKey) then
                    if (keyboard.GetState("cancel") == 1) then
                        typer.skipping = true
                        typer.skipcount = #sentence - typer.counter + 1
                    end
                    if (typer.allowCtrlSkip) then
                        if (keyboard.GetState("menu") >= 1) then
                            typer.skipping = true
                            typer.skipcount = #sentence - typer.counter + 1
                        end
                    end
                end
            end

            if (typer.time >= typer.interval and typer.counter <= sentence:len()) then
                local i = 1
                while (i <= typer.skipcount)
                do
                    typer.cantype = true
                    typer.interval = typer.sleep
                    local byte = string.byte(sentence, typer.counter)
                    local length = ByteLength(byte)
                    local letter = sentence:sub(typer.counter, typer.counter + length - 1)

                    while (letter == " ")
                    do
                        typer.counter = typer.counter + 1
                        byte = string.byte(sentence, typer.counter)
                        length = ByteLength(byte)
                        letter = sentence:sub(typer.counter, typer.counter + length - 1)

                        local font = love.graphics.newFont("Resources/Fonts/" .. typer.fonts[typer.currentfont], typer.fontsize[typer.currentfont])
                        local width = font:getWidth(" ")
                        typer.positions.main[1] = typer.positions.main[1] + width + typer.positions.spacing[1]
                    end
                    while (letter == "\n") do
                        typer.counter = typer.counter + 1
                        byte = string.byte(sentence, typer.counter)
                        length = ByteLength(byte)
                        letter = sentence:sub(typer.counter, typer.counter + length - 1)
                        typer.positions.main[1] = 0
                        local font = love.graphics.newFont("Resources/Fonts/" .. typer.fonts[typer.currentfont], typer.fontsize[typer.currentfont])
                        local height = font:getHeight()
                        typer.positions.main[2] = typer.positions.main[2] + (typer.positions.spacing[2] + typer.positions.offset[typer.currentfont][2] + height) * typer.scale
                    end

                    while (letter == "[")
                    do
                        local command_all, command_complex, command_head, command_body
                        command_all = sentence:sub(typer.counter + 1, sentence:find("]", typer.counter + 1) - 1)
                        if (command_all:find(":")) then
                            command_complex = true
                        end
                        if (command_complex) then
                            command_head = command_all:sub(1, command_all:find(":") - 1)
                            command_body = command_all:sub(command_all:find(":") + 1, command_all:len())
                            if (command_head == "colorRGB") then
                                local color_r, color_g, color_b
                                color_r = command_body:sub(1, command_body:find(",") - 1)
                                color_g = command_body:sub(command_body:find(",") + 1, command_body:find(",", command_body:find(",") + 1) - 1)
                                color_b = command_body:sub(command_body:find(",", color_r:len() + color_g:len() + 2) + 1)

                                typer.color = {tonumber(color_r), tonumber(color_g), tonumber(color_b)}
                            elseif (command_head == "colorHEX") then
                                local color_r, color_g, color_b
                                color_r = command_body:sub(1, 2)
                                color_g = command_body:sub(3, 4)
                                color_b = command_body:sub(5, 6)

                                typer.color = {tonumber("0x" .. color_r) / 255, tonumber("0x" .. color_g) / 255, tonumber("0x" .. color_b) / 255}
                            elseif (command_head == "fontIndex") then
                                typer.currentfont = tonumber(command_body)
                            elseif (command_head == "font") then
                                typer.fonts = {command_body}
                                typer.currentfont = 1
                            elseif (command_head == "fontSize") then
                                local index, size
                                if (command_body:find(",")) then
                                    index = command_body:sub(1, command_body:find(",") - 1)
                                    size = command_body:sub(command_body:find(",") + 1, -1)

                                    typer.fontsize[tonumber(index)] = tonumber(size)
                                else
                                    typer.fontsize[1] = tonumber(command_body)
                                end
                            elseif (command_head == "alpha") then
                                typer.alpha = tonumber(command_body)
                            elseif (command_head == "offset") then
                                local index, x, y
                                index = command_body:sub(1, command_body:find(",") - 1)
                                x = command_body:sub(index:len() + 2, command_body:find(",", index:len() + 2) - 1)
                                y = command_body:sub(command_body:find(",", index:len() + x:len() + 2) + 1, -1)

                                typer.positions.offset[tonumber(index)] = {tonumber(x), tonumber(y)}
                            elseif (command_head == "voice") then
                                typer.canvoice = true
                                typer.voices = {}
                                typer.voices[1] = command_body
                            elseif (command_head == "sound") then
                                local name, islooping = "", false
                                if (command_body:find(",")) then
                                    name = command_body:sub(1, command_body:find(",") - 1)
                                    islooping = command_body:sub(command_body:find(",") + 1, -1)
                                else
                                    name = command_body
                                end
                                audio.PlaySound(name, 1, islooping)
                            elseif (command_head == "space") then
                                local index, number
                                index = command_body:sub(1, command_body:find(",") - 1)
                                number = command_body:sub(command_body:find(",") + 1, -1)
                                typer.positions.spacing[tonumber(index)] = tonumber(number)
                            elseif (command_head == "wait") then
                                typer.time = 0
                                typer.interval = tonumber(command_body)
                                typer.cantype = false
                                typer.counter = typer.counter - 1
                            elseif (command_head == "waitALL") then
                                typer.time = 0
                                typer.sleep = tonumber(command_body)
                                typer.interval = tonumber(command_body)
                                typer.cantype = false
                                typer.counter = typer.counter - 1
                            elseif (command_head == "waitKEY") then
                                if (not typer.skipping) then
                                    local key = command_body
                                    typer.cantype = false
                                    typer.counter = typer.counter - 1
                                    typer.interval = 1/0
                                    typer.waitingforKey = true
                                    typer.KeyId = key
                                end
                            elseif (command_head == "scale") then
                                typer.scale = tonumber(command_body)
                            elseif (command_head == "speed") then
                                typer.sleep = 4 / tonumber(command_body)
                                typer.time = 0
                            elseif (command_head == "effect") then
                                typer.effect.name = command_body:sub(1, command_body:find(",") - 1)
                                typer.effect.intensity = tonumber(command_body:sub(command_body:find(",") + 1, -1))
                            elseif (command_head == "function") then
                                local name, params
                                if (command_body:find("|")) then
                                    name = command_body:sub(1, command_body:find("|") - 1)
                                    params = command_body:sub(command_body:find("|") + 1, -1)
                                    local func = _G[name]
                                    if (type(func) == "function") then
                                        local paramList = {}
                                        for param in string.gmatch(params, "[^,]+") do
                                            local num = tonumber(param)
                                            if (num) then
                                                table.insert(paramList, num)
                                            else
                                                table.insert(paramList, param)
                                            end
                                        end
                                        func(unpack(paramList))
                                    else
                                        print("Error: function " .. name .. " not found")
                                    end
                                else
                                    name = command_body
                                    local func = _G[name]
                                    if (type(func) == "function") then
                                        func()
                                    else
                                        print("Error: function " .. name .. " not found")
                                    end
                                end
                            elseif (command_head == "pattern") then
                                local pattern = command_body:lower()
                                if (pattern == "chinese") then
                                    typer.currentfont = 2
                                    typer.scale = 2
                                    typer.positions.spacing = {2, 0}
                                elseif (pattern == "english") then
                                    typer.currentfont = 1
                                    typer.scale = 1
                                    typer.positions.spacing = {0, 0}
                                end
                            elseif (command_head == "RESET") then
                                if (command_body == "color") then
                                    typer.color = {1, 1, 1}
                                elseif (command_body == "font") then
                                    typer.currentfont = 1
                                elseif (command_body == "fontSize") then
                                    typer.fontsize = {26, 13}
                                elseif (command_body == "alpha") then
                                    typer.alpha = 1
                                elseif (command_body == "position") then
                                    typer.positions.main = {0, 0}
                                end
                            else
                                break
                            end
                        else
                            if (command_all == "RESET") then
                                typer.color = {1, 1, 1}
                                typer.currentfont = 1
                                typer.fontsize = {26, 13}
                                typer.alpha = 1
                                typer.positions.main = {0, 0}
                            elseif (command_all == "skip" or command_all == "instant") then
                                typer.skipcount = #sentence - typer.counter
                                typer.skipping = true
                                typer.canskip = false
                            elseif (command_all == "shadow") then
                                typer.shadow.use = true
                            elseif (command_all == "noshadow") then
                                typer.shadow.use = false
                            elseif (command_all == "noskip") then
                                typer.canskip = false
                            elseif (command_all == "voice") then
                                typer.canvoice = true
                            elseif (command_all == "novoice") then
                                typer.canvoice = false
                            elseif (command_all == "canskip") then
                                typer.canskip = true
                            elseif (command_all == "next") then
                                if (typer.sentence < #typer.sentences) then
                                    typer.sentence = typer.sentence + 1
                                    typer:Reset()
                                else
                                    typer:Destroy()
                                end
                            else
                                break
                            end
                        end

                        typer.counter = typer.counter + command_all:len() + 2
                        byte = string.byte(sentence, typer.counter)
                        length = ByteLength(byte)
                        letter = sentence:sub(typer.counter, typer.counter + length - 1)
                    end

                    if (typer.cantype) then
                        if (typer.OnUpdating) then
                            typer.OnUpdating()
                        end
                        if (typer.canvoice and not typer.skipping) then
                            if (#typer.voices > 0) then
                                local randomVoice = math.random(1, #typer.voices)
                                audio.PlaySound("Voices/" .. typer.voices[randomVoice], 1, false)
                            end
                        end
                        local font = getFont(typer.fonts[typer.currentfont], typer.fontsize[typer.currentfont])
                        font:setFilter("nearest", "nearest")

                        local instance = {}
                        instance.shadow = typer.shadow.use
                        temptable = nil
                        instance.isactive = true
                        instance.time = 0

                        instance.position = {
                            main = {
                                x = typer.x + typer.positions.main[1] + typer.positions.offset[typer.currentfont][1] + typer.positions.withFont[1],
                                y = typer.y + typer.positions.main[2] + typer.positions.offset[typer.currentfont][2] + typer.positions.withFont[2]
                            },
                            effects = {
                                name = typer.effect.name,
                                intensity = typer.effect.intensity,
                                velocity = 0,
                                x = 0,
                                y = 0
                            }
                        }

                        local width = font:getWidth(letter)
                        local height = font:getHeight(letter)
                        if (typer.positions.main[1] + typer.positions.offset[typer.currentfont][1] + typer.positions.withFont[1] + width > typer.texturelen[1]) then
                            typer.texturelen[1] = instance.position.main.x - typer.x + width
                        end
                        if (typer.positions.main[2] + typer.positions.offset[typer.currentfont][2] + typer.positions.withFont[2] + height> typer.texturelen[2]) then
                            typer.texturelen[2] = instance.position.main.y - typer.y + height
                        end
                        instance.xscale = typer.scale
                        instance.yscale = typer.scale
                        instance.rotation = 0
                        instance.color = typer.color
                        instance.alpha_attached = 0
                        instance.font = font
                        instance.char = love.graphics.newText(font, letter)
                        table.insert(typer.letters, instance)
                        typer.positions.main[1] = typer.positions.main[1] + (width + typer.positions.offset[typer.currentfont][1] + typer.positions.spacing[1]) * typer.scale
                    end

                    typer.counter = typer.counter + length
                    typer.time = 0
                    i = i + 1
                end
            else
                typer.sentenceFinished = true
            end
            if (typer.counter > #sentence) then
                if (typer.progressmode == "manual") then
                    if (keyboard.GetState("return") == 1 or keyboard.GetState("z") == 1 or (keyboard.GetState("menu") >= 1 and typer.allowCtrlSkip)) then
                        if (typer.sentence < #typer.sentences) then
                            typer.sentence = typer.sentence + 1
                            typer:Reset()
                        else
                            if (typer.OnComplete) then
                                typer.OnComplete()
                            end
                            typer:Reset()
                            typer.isactive = false
                            typer:Destroy()
                        end
                    end
                elseif (typer.progressmode == "auto") then
                    typer.autoLefttime = typer.autoLefttime - 1
                    if (typer.autoLefttime <= 0) then
                        if (typer.sentence < #typer.sentences) then
                            typer.sentence = typer.sentence + 1
                            typer:Reset()
                        else
                            if (typer.OnComplete) then
                                typer.OnComplete()
                            end
                            typer:Reset()
                            typer.isactive = false
                            typer:Destroy()
                        end
                        typer.autoLefttime = 150
                    end
                end
            end
        end
    end

    function typer:Draw()
        if (typer.isactive) then
            for i = 1, #typer.letters do
                local letter = typer.letters[i]
                if (letter.isactive) then
                    letter.time = letter.time + 1
                    love.graphics.push()

                    if (letter.position.effects.name ~= "") then
                        if (letter.position.effects.name == "shake") then
                            letter.position.effects.x = letter.position.effects.intensity * math.random(-10, 10) / 10
                            letter.position.effects.y = letter.position.effects.intensity * math.random(-10, 10) / 10
                        elseif (letter.position.effects.name == "rotate") then
                            letter.position.effects.x = letter.position.effects.intensity * math.cos(math.rad(letter.time + i * 2.5) * 6)
                            letter.position.effects.y = letter.position.effects.intensity * math.sin(math.rad(letter.time + i * 2.5) * 6)
                        end
                    end

                    letter.color[4] = typer.alpha + letter.alpha_attached

                    local x = letter.position.main.x + letter.position.effects.x
                    local y = letter.position.main.y + letter.position.effects.y
                    local angle = math.rad(letter.rotation)
                    local sx, sy = letter.xscale, letter.yscale

                    local char = (letter.char)
                    love.graphics.setFont(letter.font)
                    if (letter.shadow) then
                        love.graphics.setColor(typer.shadow.color)
                        love.graphics.draw(
                            char,
                            x + 2, y + 2,
                            angle, sx, sy
                        )
                    end
                    love.graphics.setColor(letter.color)
                    love.graphics.draw(
                        char,
                        x, y,
                        angle, sx, sy
                    )

                    love.graphics.pop()
                end
            end
        end
    end

    setmetatable(typer, functions)
    table.insert(typers.instances, typer)
    table.insert(layers.objects, typer)
    return typer
end

function typers.DrawText(text, position, layer)
    local typer = {}

    typer.isactive = true
    if type(text) ~= "string" then
        text = tostring(text)
    end
    typer.rawtext = text
    typer.parsed = {}
    typer.x, typer.y = unpack(position)
    typer.layer = layer
    typer.defaultFont = "determination_mono.ttf"
    typer.defaultSize = 26
    typer.charspacing = 0
    typer.offset = {0, 0}
    typer.alpha = 1
    typer.color = {1, 1, 1}
    typer.font = typer.defaultFont
    typer.fontsize = typer.defaultSize
    typer.fontCache = {}
    typer.presets = {
        --selection = "[font=simsun.ttc,13][offsetX=-20][offsetY=3][scale=2][spaceX=10]",
        selection = function(state)
            state.font = "simsun.ttc"
            state.size = 13
            state.offset = {-20, 3}
            state.scale = 2
            state.spaceX = 10
            return state
        end,
    }

    local function getFont(fontname, size)
        local key = fontname .. "_" .. tostring(size)
        if not typer.fontCache[key] then
            local font = love.graphics.newFont("Resources/Fonts/" .. fontname, size)
            font:setFilter("nearest", "nearest")
            typer.fontCache[key] = font
        end
        return typer.fontCache[key]
    end

    local colors = {
        red = {1, 0, 0}, green = {0, 1, 0}, blue = {0, 0, 1},
        yellow = {1, 1, 0}, white = {1, 1, 1}, orange = {1, 0.5, 0},
        purple = {0.4, 0, 1}, cyan = {0, 1, 1}, pink = {1, 0, 1},
        black = {0, 0, 0}, brown = {0.5, 0.25, 0},
        grey = {0.5, 0.5, 0.5}, lightgrey = {0.75, 0.75, 0.75},
    }

    local function parseText()
        local i = 1
        local currentColor = typer.color
        local currentFont = typer.font or typer.defaultFont
        local currentSize = typer.fontsize or typer.defaultSize
        local currentScale = 1
        local currentOffsetX = 0
        local currentOffsetY = 0
        local prevCharWidth = 0

        while (i <= #typer.rawtext)
        do
            local tagStart, tagEnd, tag = typer.rawtext:find("%[(.-)%]", i)
            if (tagStart == i) then
                if (colors[tag]) then
                    currentColor = colors[tag]
                elseif (tag:sub(1, 5) == "font=") then
                    local fontName, size = tag:match("font=([^,%]]+),?(%d*)")
                    if (fontName) then
                        currentFont = fontName
                        currentSize = tonumber(size) or typer.defaultSize
                    end
                elseif (tag:sub(1, 6) == "scale=") then
                    local value = tag:match("scale=([%+%-]?%d+%.?%d*)")
                    currentScale = tonumber(value) or 1
                elseif (tag:sub(1, 7) == "spaceX=") then
                    local value = tag:match("spaceX=([%+%-]?%d+%.?%d*)")
                    typer.charspacing = tonumber(value) or 0
                elseif (tag:sub(1, 8) == "offsetX=") then
                    currentOffsetX = tonumber(tag:match("offsetX=([%-]?%d+)")) or 0
                elseif (tag:sub(1, 8) == "offsetY=") then
                    currentOffsetY = tonumber(tag:match("offsetY=([%-]?%d+)")) or 0
                elseif (tag:sub(1, 7) == "preset=") then
                    local presetKey = tag:match("preset=([%w_]+)")
                    if (presetKey == "chinese") then
                        currentFont = "simsun.ttc"
                        currentSize = 13
                        currentOffsetX = -20
                        currentOffsetY = 3
                        currentScale = 2
                        typer.charspacing = 10
                    elseif (presetKey == "chd") then
                        currentFont = "simsun.ttc"
                        currentSize = 13
                        currentOffsetX = 0
                        currentOffsetY = 3
                        currentScale = 2
                        typer.charspacing = 10
                    end
                end
                i = tagEnd + 1
            else
                local textEnd = tagStart and tagStart - 1 or #typer.rawtext
                while (i <= textEnd)
                do
                    local byte = typer.rawtext:byte(i)
                    local length = ByteLength(byte)
                    local char = typer.rawtext:sub(i, i + length - 1)

                    local font = getFont(currentFont, currentSize)
                    local width = font:getWidth(char)
                    if (length > 1) then width = width * 1.5 end
                    width = width * currentScale

                    table.insert(typer.parsed, {
                        char = char,
                        color = currentColor,
                        font = currentFont,
                        size = currentSize,
                        scale = currentScale,
                        spaceX = prevCharWidth + typer.charspacing,
                        spaceY = 0,
                        offsetX = currentOffsetX,
                        offsetY = currentOffsetY
                    })

                    prevCharWidth = width
                    i = i + length
                end
            end
        end
    end

    parseText()

    function typer:Update()
    end

    function typer:Reparse()
        self.parsed = {}
        parseText()
    end

    function typer:Draw()
        love.graphics.push()
        if (self.alpha > 1) then self.alpha = 1 end
        if (self.alpha < 0) then self.alpha = 0 end

        local cx = self.x + self.offset[1]
        for _, piece in ipairs(self.parsed)
        do
            local color = {piece.color[1], piece.color[2], piece.color[3], self.alpha}
            love.graphics.setColor(color)

            local font = getFont(piece.font, piece.size)
            love.graphics.setFont(font)
            local charWidth = font:getWidth(piece.char)

            if (ByteLength(piece.char:byte(1)) > 1) then
                charWidth = charWidth * 1.5
            end

            local tc = love.graphics.newText(font, piece.char)
            love.graphics.draw(tc, cx + (piece.offsetX or 0), self.y + (piece.offsetY or 0), 0, piece.scale, piece.scale)
            cx = cx + charWidth + self.charspacing
        end

        love.graphics.pop()
    end

    setmetatable(typer, {
        __index = functions_instant,
        __newindex = function(table, key, value)
            rawset(table, key, value)
            if (key == "rawtext") then
                table:Reparse()
            elseif (key == "color" or key == "alpha") then
                for _, piece in ipairs(table.parsed) do
                    if (key == "color") then
                        piece.color = value
                    end
                end
            end
        end
    })
    setmetatable(typer, functions_instant)
    table.insert(typers.instances, typer)
    table.insert(layers.objects, typer)
    return typer
end

function typers.Update()
    for _, v in pairs(typers.instances) do
        if (v.isactive) then
            v:Update()
        end
    end
end

function typers.Draw()
    for _, v in pairs(typers.instances) do
        v:Draw()
    end
end

function typers.clear()
    typers.instances = {}
end

return typers