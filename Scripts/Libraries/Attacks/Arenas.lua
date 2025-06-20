local arenas = {
    shells = {}
}

local functions = {
    Resize = function(shell, width, height)
        local w = (width >= 16) and width or 16
        local h = (height >= 16) and height or 16
        shell.width = w
        shell.height = h
    end,
    MoveTo = function(shell, x, y)
        shell.x = x
        shell.y = y
    end,
    MoveToAndResize = function(shell, x, y, width, height)
        shell:MoveTo(x, y)
        shell:Resize(width, height)
    end,
    RotateTo = function(shell, rotation)
        shell.rotation = rotation
    end,
    Destroy = function(shell)
        for i = #arenas.shells, 1, -1
        do
            if (arenas.shells[i] == shell) then
                shell = arenas.shells[i]
                shell.isactive = false
                shell.iscolliding = false
                shell.white:Destroy()
                shell.black:Destroy()
                table.remove(arenas.shells, i)
            end
        end
    end,
}
functions.__index = functions

local function smooth_value(value, target, speed)
    if (value > target) then
        return math.max(value - speed, target)
    elseif (value < target) then
        return math.min(value + speed, target)
    else
        return value
    end
end

local function check_amount()
    local amount = 0
    for i = 1, #arenas.shells
    do
        if (arenas.shells[i].containing) then
            amount = amount + 1
        end
    end
    return amount
end

local function check_nearest()
    local distance = math.huge
    local nearest

    for i = 1, #arenas.shells
    do
        local shell = arenas.shells[i]
        if (shell.isactive and shell.mode == "plus") then
            if (shell.shape == "rectangle") then
                local dx, dy = battle.Player.sprite.x - shell.black.x, battle.Player.sprite.y - shell.black.y
                local sin, cos = math.sin(math.rad(shell.black.rotation)), math.cos(math.rad(shell.black.rotation))
                local w, h = shell.width, shell.height
                local vx, vy = 0, 0

                vx = maths.Clamp(dx * cos + dy * sin, -w / 2 + 8, w / 2 - 8)
                vy = maths.Clamp(dy * cos - dx * sin, -h / 2 + 8, h / 2 - 8)

                local dist = math.sqrt(math.pow(vx - (dx * cos + dy * sin), 2) + math.pow(vy - (dy * cos - dx * sin), 2))
                if (dist < distance) then
                    distance = dist
                    nearest = shell
                end
            elseif (shell.shape == "circle") then
                local dx, dy = battle.Player.sprite.x - shell.black.x, battle.Player.sprite.y - shell.black.y
                local sin, cos = math.sin(math.rad(shell.black.rotation)), math.cos(math.rad(shell.black.rotation))
                local w, h = shell.width, shell.height
                local a, b = w / 2 - 8, h / 2 - 8
                local rx, ry = dx * cos + dy * sin, dy * cos - dx * sin
                local vx, vy = 0, 0

                local relangle = maths.Direction(shell.black.x, shell.black.y, battle.Player.sprite.x, battle.Player.sprite.y, 0)
                local nsin, ncos = math.cos(math.rad(relangle)), math.sin(math.rad(relangle))
                vx = maths.Clamp(rx, -a * ncos, a * ncos)
                vy = maths.Clamp(ry, -b * nsin, b * nsin)
                local dist = math.sqrt(math.pow(vx - rx, 2) + math.pow(vy - ry, 2))
                if (dist < distance) then
                    distance = dist
                    nearest = shell
                end
            end
        end
    end

    return nearest
end

function arenas.Init()
    local shell = {}
    shell.isactive = true
    shell.iscolliding = true
    shell.containing = true
    shell.shape = ("rectangle")
    shell.mode = ("plus")
    shell.x = 320
    shell.y = 320
    shell.width = 565
    shell.height = 130
    shell.rotation = 0

    shell.white = sprites.CreateSprite("Shapes/rectangle.png", 10)
    shell.white:MoveTo(320, 320)
    shell.white:Scale((565 + 10) / 100, (130 + 10) / 100)
    shell.white.rotation = 0
    shell.black = sprites.CreateSprite("Shapes/rectangle.png", 11)
    shell.black:MoveTo(320, 320)
    shell.black:Scale((565) / 100, (130) / 100)
    shell.black.rotation = 0
    shell.black.color = {0, 0, 0}

    setmetatable(shell, functions)
    table.insert(arenas.shells, shell)
    return shell
end

function arenas.NewArena(x, y, w, h, r, shape, mode)
    local shell = {}
    shell.isactive = true
    shell.iscolliding = true
    shell.containing = true
    shell.shape = (shape or "rectangle")
    shell.mode = (mode or "plus")
    shell.x = x
    shell.y = y
    shell.width = w
    shell.height = h
    shell.rotation = r

    shell.white = sprites.CreateSprite("Shapes/" .. shape .. ".png", 10)
    shell.white:MoveTo(x, y)
    shell.white:Scale((w + 10) / 100, (h + 10) / 100)
    shell.white.rotation = r
    shell.black = sprites.CreateSprite("Shapes/" .. shape .. ".png", 11)
    shell.black:MoveTo(x, y)
    shell.black:Scale(w / 100, h / 100)
    shell.black.rotation = r
    shell.black.color = {0, 0, 0}

    setmetatable(shell, functions)
    table.insert(arenas.shells, shell)
    return shell
end

function arenas.Update()
    for i = #arenas.shells, 1, -1
    do
        local shell = arenas.shells[i]
        if (shell.isactive) then
            shell.white.x = smooth_value(shell.white.x, shell.x, 15)
            shell.white.y = smooth_value(shell.white.y, shell.y, 15)
            shell.white.xscale = smooth_value(shell.white.xscale, (shell.width + 10) / 100, 0.15)
            shell.white.yscale = smooth_value(shell.white.yscale, (shell.height + 10) / 100, 0.15)
            shell.white.rotation = smooth_value(shell.white.rotation, shell.rotation, 15)
            shell.black.x = smooth_value(shell.black.x, shell.x, 15)
            shell.black.y = smooth_value(shell.black.y, shell.y, 15)
            shell.black.xscale = smooth_value(shell.black.xscale, (shell.width) / 100, 0.15)
            shell.black.yscale = smooth_value(shell.black.yscale, (shell.height) / 100, 0.15)
            shell.black.rotation = smooth_value(shell.black.rotation, shell.rotation, 15)

            if (shell.iscolliding) then
                local dx, dy = battle.Player.sprite.x - shell.x, battle.Player.sprite.y - shell.y
                local sin, cos = math.sin(math.rad(shell.black.rotation)), math.cos(math.rad(shell.black.rotation))
                local w, h = shell.width, shell.height
                if (shell.mode == "plus") then
                    if (shell.shape == "rectangle") then
                        if (dx * cos + dy * sin > -w / 2 + 8 and dx * cos + dy * sin < w / 2 - 8 and
                            dx * -sin + dy * cos > -h / 2 + 8 and dx * -sin + dy * cos < h / 2 - 8
                        ) then
                            shell.containing = true

                            if (battle.Player.soulMode == 6) then
                                local _vars = battle.Player.soul_variables.blue
                                _vars.canjump = false
                            end
                        else
                            shell.containing = false

                            if (battle.Player.soulMode == 6) then
                                
                                local angle_diff = math.abs(shell.rotation - battle.Player.sprite.rotation)
                                if (angle_diff > 180) then
                                    angle_diff = 360 - angle_diff
                                end

                                local _vars = battle.Player.soul_variables.blue
                                if (_vars.direction == "down") then
                                    if (shell.rotation > -45 and shell.rotation < 45) then
                                        _vars.canjump = true
                                        print("canjump")
                                    end
                                end
                            end
                        end

                        local Player = battle.Player.sprite
                        if (check_amount() < 1 and check_nearest() == shell) then
                            -- right
                            while ((Player.x - shell.black.x) * cos + (Player.y - shell.black.y) * sin > w / 2 - 8) do
                                Player:Move(-cos, -sin)
                            end
                            -- left
                            while ((Player.x - shell.black.x) * cos + (Player.y - shell.black.y) * sin < -w / 2 + 8) do
                                Player:Move(cos, sin)
                            end
                            -- up
                            while ((Player.y - shell.black.y) * cos + (Player.x - shell.black.x) * -sin < -h / 2 + 8) do
                                Player:Move(-sin, cos)
                            end
                            -- down
                            while ((Player.y - shell.black.y) * cos + (Player.x - shell.black.x) * -sin > h / 2 - 8) do
                                Player:Move(sin, -cos)
                            end
                        end
                    elseif (shell.shape == "circle") then
                        local rx, ry = dx * cos + dy * sin, -dx * sin + dy * cos
                        local a, b = w / 2 - 8, h / 2 - 8
                        if (rx ^ 2 / (a ^ 2) + ry ^ 2 / (b ^ 2) < 1) then
                            shell.containing = true
                        else
                            shell.containing = false
                        end
                    end
                end
            end
        end
    end
end

function arenas.clear()
    for i = #arenas.shells, 2, -1
    do
        local shell = arenas.shells[i]
        shell.isactive = false
        shell.white:Remove()
        shell.black:Remove()
        table.remove(arenas.shells, i)
    end
end

return arenas