local PlayerLib = {}
PlayerLib.shadows = {}
PlayerLib.sprite = nil
PlayerLib.name = "Chara"
PlayerLib.lv = 1
PlayerLib.maxhp = 20
PlayerLib.hp = 20
PlayerLib.kr = 0
PlayerLib.soulMode = 1
PlayerLib.canMove = true
PlayerLib.speed = 2
PlayerLib.hurting = false
PlayerLib.hurtingTime = 1
PlayerLib.isMoving = false
PlayerLib.soul_variables = {
    red = {
        rotated = false
    },
    orange = {
        direction = "idle",
        shadows = {},
        time = 0
    },
    blue = {
        gravity = 0.15,
        glide = 1,
        maxspeed = 5,
        currentspd = 0,
        angle = 0,
        canjump = false,
        jumping = true,
        slamming = false,
        direction = "down",
        platforms = {},
        iscolliding = false,

        slamhp = 0,
        slaminvtime = 0,
    }
}

function PlayerLib.Init(tab)
    local args = (tab or {})

    PlayerLib.sprite = sprites.CreateSprite(args.path or "Soul Library Sprites/spr_default_heart.png", 15)
    PlayerLib.name = args.name or "Chara"
    PlayerLib.lv = args.lv or 1
    PlayerLib.maxhp = args.maxhp or 20
    PlayerLib.hp = args.hp or 20

    return PlayerLib
end

function PlayerLib.Hurt(damage, time, sound)
    if (sound) then
        audio.PlaySound("snd_phurt.wav", 1, false)
    end
    if (PlayerLib.hp + PlayerLib.kr - damage > 0) then
        if (PlayerLib.kr > 0 and PlayerLib.hp == 1) then
            PlayerLib.kr = PlayerLib.kr - damage
        else
            PlayerLib.hp = PlayerLib.hp - damage
        end
        PlayerLib.hurtingTime = time or 60
        PlayerLib.hurting = true
    else
        PlayerLib.kr = 0
        PlayerLib.hp = 0
    end
end

function PlayerLib.Heal(value, sound)
    if (PlayerLib.hp + value + PlayerLib.kr > PlayerLib.maxhp) then
        PlayerLib.hp = PlayerLib.maxhp
        PlayerLib.kr = math.max(0, PlayerLib.maxhp - PlayerLib.hp - value)
    else
        PlayerLib.hp = PlayerLib.hp + value
    end
    local s = sound or true
    if (s) then
        audio.PlaySound("snd_heal.wav", 1, false)
    end
end

function PlayerLib.SetSoul(number, args)
    PlayerLib.soulMode = number
    local vars = PlayerLib.soul_variables
    local args = (args or {})
    local Player = PlayerLib.sprite

    audio.PlaySound("snd_ding.wav", 1, false)
    if (number == 1) then
        Player:Set("Soul Library Sprites/spr_default_heart.png")
        Player.color = {1, 0, 0, 1}

        vars.red.rotated = (args.rotated or false)
    elseif (number == 2) then
        Player:Set("Soul Library Sprites/spr_default_heart.png")
        Player.color = {1, 0.5, 0, 1}
    elseif (number == 3) then
        Player:Set("Soul Library Sprites/spr_default_heart.png")
        Player.rotation = 180
        Player.color = {1, 1, 0, 1}
    elseif (number == 6) then
        Player:Set("Soul Library Sprites/spr_default_heart.png")
        Player.color = {0, 0, 1, 1}
        vars.blue.direction = (args.direction or "down")
    end

    local shadow = sprites.CreateSprite(PlayerLib.sprite.path, 14.9)
    shadow.color = Player.color
    shadow.alpha = 0.5
    shadow:MoveTo(Player:GetPosition())
    tween.CreateTween(
        function (value)
            shadow.xscale = value
            shadow.yscale = value
        end,
        "Quad", "Out", 1, 2, 30
    )
    table.insert(PlayerLib.shadows, shadow)
end

local pvennoposx, pvennoposy = 0, 0
function PlayerLib.Movement(dt)
    if (PlayerLib.sprite) then
        local mode = PlayerLib.soulMode
        local vars = PlayerLib.soul_variables
        local angle = math.rad(PlayerLib.sprite.rotation)
        local Player = PlayerLib.sprite
        if (keyboard.GetState("cancel") > 0) then
            PlayerLib.speed = 1
        else
            PlayerLib.speed = 2
        end
        if (mode == 1) then
            if (PlayerLib.canMove) then
                if (vars.red.rotated) then
                    if (keyboard.GetState("up") > 0) then
                        Player:Move(PlayerLib.speed * math.sin(angle), -PlayerLib.speed * math.cos(angle))
                    end
                    if (keyboard.GetState("down") > 0) then
                        Player:Move(-PlayerLib.speed * math.sin(angle), PlayerLib.speed * math.cos(angle))
                    end
                    if (keyboard.GetState("left") > 0) then
                        Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("right") > 0) then
                        Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                    end
                else
                    if (keyboard.GetState("up") > 0) then
                        Player:Move(0, -PlayerLib.speed)
                    end
                    if (keyboard.GetState("down") > 0) then
                        Player:Move(0, PlayerLib.speed)
                    end
                    if (keyboard.GetState("left") > 0) then
                        Player:Move(-PlayerLib.speed, 0)
                    end
                    if (keyboard.GetState("right") > 0) then
                        Player:Move(PlayerLib.speed, 0)
                    end
                end
            end
        elseif (mode == 2) then
            if (PlayerLib.canMove) then
                if (keyboard.GetState("up") > 0) then
                    if (keyboard.GetState("left") > 0) then
                        vars.orange.direction = "upleft"
                    elseif (keyboard.GetState("right") > 0) then
                        vars.orange.direction = "upright"
                    else
                        vars.orange.direction = "up"
                    end
                end
                if (keyboard.GetState("down") > 0) then
                    if (keyboard.GetState("left") > 0) then
                        vars.orange.direction = "downleft"
                    elseif (keyboard.GetState("right") > 0) then
                        vars.orange.direction = "downright"
                    else
                        vars.orange.direction = "down"
                    end
                end
                if (keyboard.GetState("left") > 0) then
                    if (keyboard.GetState("up") > 0) then
                        vars.orange.direction = "upleft"
                    elseif (keyboard.GetState("down") > 0) then
                        vars.orange.direction = "downleft"
                    else
                        vars.orange.direction = "left"
                    end
                end
                if (keyboard.GetState("right") > 0) then
                    if (keyboard.GetState("up") > 0) then
                        vars.orange.direction = "upright"
                    elseif (keyboard.GetState("down") > 0) then
                        vars.orange.direction = "downright"
                    else
                        vars.orange.direction = "right"
                    end
                end
                if (vars.orange.direction == "up") then
                    Player:Move(PlayerLib.speed * math.sin(angle), -PlayerLib.speed * math.cos(angle))
                elseif (vars.orange.direction == "down") then
                    Player:Move(-PlayerLib.speed * math.sin(angle), PlayerLib.speed * math.cos(angle))
                elseif (vars.orange.direction == "left") then
                    Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                elseif (vars.orange.direction == "right") then
                    Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                elseif (vars.orange.direction == "upleft") then
                    Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.cos(angle))
                elseif (vars.orange.direction == "upright") then
                    Player:Move(PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.cos(angle))
                elseif (vars.orange.direction == "downleft") then
                    Player:Move(-PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.cos(angle))
                elseif (vars.orange.direction == "downright") then
                    Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.cos(angle))
                end
            end
        elseif (mode == 3) then
            if (PlayerLib.canMove) then
                if (keyboard.GetState("up") > 0) then
                    Player:Move(PlayerLib.speed * math.sin(angle), -PlayerLib.speed * math.cos(angle))
                end
                if (keyboard.GetState("down") > 0) then
                    Player:Move(-PlayerLib.speed * math.sin(angle), PlayerLib.speed * math.cos(angle))
                end
                if (keyboard.GetState("left") > 0) then
                    Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                end
                if (keyboard.GetState("right") > 0) then
                    Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                end
            end
            if (keyboard.GetState("confirm") == 1) then
                local bullet = sprites.CreateSprite("Soul Library Sprites/spr_bullet.png", 15)
                bullet:MoveTo(Player:GetPosition())
                bullet.rotation = Player.rotation
                bullet.speed = 5
                bullet:Set("bullet")
                bullet:Move(bullet.speed * math.cos(angle), bullet.speed * math.sin(angle))
                audio.PlaySound("snd_bullet.wav", 1, false)
            end
        elseif (mode == 6) then
            local _vars = vars.blue
            if (PlayerLib.canMove) then
                if (_vars.direction == "down") then
                    if (keyboard.GetState("left") > 0) then
                        Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("right") > 0) then
                        Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                    end
                    if (_vars.canjump or _vars.iscolliding) then
                        if (math.abs(_vars.currentspd) < 10) then _vars.currentspd = 0 end
                        if (_vars.slamming) then
                            _vars.slamming = false
                            audio.PlaySound("snd_slam.wav")
                            PlayerLib.Hurt(_vars.slamhp, _vars.slaminvtime)
                            _CAMERA_:shake(5, 10)
                        end
                    end
                    if (keyboard.GetState("up") >= 1 and _vars.canjump) then
                        _vars.currentspd = _vars.maxspeed
                        _vars.canjump = false
                        _vars.jumping = true
                    end
                    if (_vars.jumping) then
                        if (keyboard.GetState("up") >= 1) then
                            _vars.currentspd = _vars.currentspd - _vars.gravity
                        else
                            if (_vars.currentspd > _vars.glide) then
                                _vars.currentspd = _vars.glide
                            end
                            _vars.jumping = false
                        end
                    else
                        _vars.currentspd = _vars.currentspd - _vars.gravity
                    end
                    Player:Move(_vars.currentspd * math.sin(angle), -_vars.currentspd * math.cos(angle))
                elseif (_vars.direction == "up") then
                    if (keyboard.GetState("left") > 0) then
                        Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("right") > 0) then
                        Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                    end
                    if (_vars.canjump or _vars.iscolliding) then
                        if (math.abs(_vars.currentspd) < 10) then _vars.currentspd = 0 end
                        if (_vars.slamming) then
                            _vars.slamming = false
                            audio.PlaySound("snd_slam.wav")
                            PlayerLib.Hurt(_vars.slamhp, _vars.slaminvtime)
                            _CAMERA_:shake(5, 10)
                        end
                    end
                    if (keyboard.GetState("down") >= 1 and _vars.canjump) then
                        _vars.currentspd = _vars.maxspeed
                        _vars.canjump = false
                        _vars.jumping = true
                    end
                    if (_vars.jumping) then
                        if (keyboard.GetState("down") >= 1) then
                            _vars.currentspd = _vars.currentspd - _vars.gravity
                        else
                            if (_vars.currentspd > _vars.glide) then
                                _vars.currentspd = _vars.glide
                            end
                            _vars.jumping = false
                        end
                    else
                        _vars.currentspd = _vars.currentspd - _vars.gravity
                    end
                    Player:Move(_vars.currentspd * math.sin(angle), -_vars.currentspd * math.cos(angle))
                elseif (_vars.direction == "left") then
                    if (keyboard.GetState("up") > 0) then
                        Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("down") > 0) then
                        Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                    end
                    if (_vars.canjump or _vars.iscolliding) then
                        if (math.abs(_vars.currentspd) < 10) then _vars.currentspd = 0 end
                        if (_vars.slamming) then
                            _vars.slamming = false
                            audio.PlaySound("snd_slam.wav")
                            PlayerLib.Hurt(_vars.slamhp, _vars.slaminvtime)
                            _CAMERA_:shake(5, 10)
                        end
                    end
                    if (keyboard.GetState("right") >= 1 and _vars.canjump) then
                        _vars.currentspd = _vars.maxspeed
                        _vars.canjump = false
                        _vars.jumping = true
                    end
                    if (_vars.jumping) then
                        if (keyboard.GetState("right") >= 1) then
                            _vars.currentspd = _vars.currentspd - _vars.gravity
                        else
                            if (_vars.currentspd > _vars.glide) then
                                _vars.currentspd = _vars.glide
                            end
                            _vars.jumping = false
                        end
                    else
                        _vars.currentspd = _vars.currentspd - _vars.gravity
                    end
                    Player:Move(_vars.currentspd * math.sin(angle), -_vars.currentspd * math.cos(angle))
                elseif (_vars.direction == "right") then
                    if (keyboard.GetState("up") > 0) then
                        Player:Move(PlayerLib.speed * math.cos(angle), PlayerLib.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("down") > 0) then
                        Player:Move(-PlayerLib.speed * math.cos(angle), -PlayerLib.speed * math.sin(angle))
                    end
                    if (_vars.canjump or _vars.iscolliding) then
                        if (math.abs(_vars.currentspd) < 10) then _vars.currentspd = 0 end
                        if (_vars.slamming) then
                            _vars.slamming = false
                            audio.PlaySound("snd_slam.wav")
                            PlayerLib.Hurt(_vars.slamhp, _vars.slaminvtime)
                            _CAMERA_:shake(5, 10)
                        end
                    end
                    if (keyboard.GetState("left") >= 1 and _vars.canjump) then
                        _vars.currentspd = _vars.maxspeed
                        _vars.canjump = false
                        _vars.jumping = true
                    end
                    if (_vars.jumping) then
                        if (keyboard.GetState("left") >= 1) then
                            _vars.currentspd = _vars.currentspd - _vars.gravity
                        else
                            if (_vars.currentspd > _vars.glide) then
                                _vars.currentspd = _vars.glide
                            end
                            _vars.jumping = false
                        end
                    else
                        _vars.currentspd = _vars.currentspd - _vars.gravity
                    end
                    Player:Move(_vars.currentspd * math.sin(angle), -_vars.currentspd * math.cos(angle))
                end
            end
        end
    end
end

function PlayerLib.BluePlatform(x, y, layer)
    local platform = sprites.CreateSprite("Soul Library Sprites/platform.png", layer)
    platform:MoveTo(x, y)
    platform.__line = sprites.CreateSprite("Soul Library Sprites/platformline.png", layer + 0.0001)
    platform.__line:MoveTo(99999, 99999)
    platform.__line.alpha = 1

    platform.Delete = function (self)
        PlayerLib.soul_variables.blue.iscolliding = false
        for i, p in pairs(PlayerLib.soul_variables.blue.platforms)
        do
            if (p == self) then
                self.__line:Destroy()
                self:Destroy()
                table.remove(PlayerLib.soul_variables.blue.platforms, i)
            end
        end
    end

    table.insert(PlayerLib.soul_variables.blue.platforms, platform)
    return platform
end

function PlayerLib.BlueSlam(direction, angle, hp, invtime)
    local vars = PlayerLib.soul_variables.blue
    vars.slamming = true
    vars.canjump = false
    vars.direction = direction or "down"
    PlayerLib.sprite.rotation = angle
    vars.currentspd = -15
    vars.slamhp = hp or 0
    vars.slaminvtime = invtime or 0
end

function PlayerLib.BlueSlamAuto(angle, hp, invtime)
    local vars = PlayerLib.soul_variables.blue
    vars.slamming = true
    if (angle < 315 and angle <= 45) then vars.direction = "down" end
    if (angle > 45 and angle <= 135) then vars.direction = "left" end
    if (angle > 135 and angle <= 225) then vars.direction = "up" end
    if (angle > 225 and angle <= 315) then vars.direction = "right" end
    PlayerLib.sprite.rotation = angle
    vars.canjump = false
    vars.currentspd = -15
    vars.slamhp = hp or 0
    vars.slaminvtime = invtime or 0
end

function PlayerLib.BlueAngle(direction, angle)
    local vars = PlayerLib.soul_variables.blue
    vars.direction = direction or "down"
    PlayerLib.sprite.rotation = angle
end

function PlayerLib.BlueAngleAuto(angle)
    local vars = PlayerLib.soul_variables.blue
    if (angle < 315 and angle <= 45) then vars.direction = "down" end
    if (angle > 45 and angle <= 135) then vars.direction = "left" end
    if (angle > 135 and angle <= 225) then vars.direction = "up" end
    if (angle > 225 and angle <= 315) then vars.direction = "right" end
    PlayerLib.sprite.rotation = angle
end

local xprev, yprev
function PlayerLib.Update(dt)
    if (PlayerLib.hurting) then
        PlayerLib.hurtingTime = PlayerLib.hurtingTime - 1
        if (PlayerLib.hurtingTime <= 0) then
            PlayerLib.hurting = false
            PlayerLib.hurtingTime = 60
        else
            if (PlayerLib.hurtingTime % 10 == 0) then
                PlayerLib.sprite.alpha = 0.4
            elseif (PlayerLib.hurtingTime % 10 == 5) then
                PlayerLib.sprite.alpha = 1
            end
        end
    end
    if (PlayerLib.sprite) then
        if (pvennoposx ~= PlayerLib.sprite.x or pvennoposy ~= PlayerLib.sprite.y) then
            PlayerLib.isMoving = true
            pvennoposx = PlayerLib.sprite.x
            pvennoposy = PlayerLib.sprite.y
        else
            PlayerLib.isMoving = false
        end

        for i = #PlayerLib.shadows, 1, -1 do
            local shadow = PlayerLib.shadows[i]
            if (shadow) then
                shadow.alpha = shadow.alpha - 0.03
                shadow:MoveTo(PlayerLib.sprite:GetPosition())
                if (shadow.alpha <= 0) then
                    shadow:Destroy()
                    table.remove(PlayerLib.shadows, i)
                end
            end
        end
    end

    if (PlayerLib.soulMode) then
        local mode = PlayerLib.soulMode
        local vars = PlayerLib.soul_variables
        local Player = PlayerLib.sprite
        if (mode == 2) then
            local _vars = vars.orange
            _vars.time = _vars.time + 1
            if (_vars.time % 3 == 0) then
                local shadow = sprites.CreateSprite(Player.sprite.path, 14.9)
                shadow.rotation = Player.rotation
                shadow.color = Player.color
                shadow.alpha = 0.5
                shadow:MoveTo(Player:GetPosition())
                table.insert(_vars.shadows, shadow)
            end
        end
        if (mode) then
            for i = #vars.blue.platforms, 1, -1
            do
                local platform = vars.blue.platforms[i]
                platform.__line:MoveTo(platform:GetPosition())
                platform.__line.rotation = platform.rotation
                platform.__line.xscale = platform.xscale
                platform.__line.yscale = platform.yscale
                platform.__line:SetStencils(platform.stencils.sources)

                local coll1 = collisions.FollowShape(platform)
                coll1.w = coll1.w - 10
                coll1.h = coll1.h - 10
                coll1.y = coll1.y - 5
                local coll2 = collisions.FollowShape(battle.Player.sprite)

                if (collisions.RectangleWithRectangle(coll1, coll2)) then
                    if (platform.isactive) then
                        if (vars.blue.currentspd <= 0) then
                            vars.blue.iscolliding = true
                            vars.blue.canjump = true
                            Player:Move(0, -vars.blue.gravity)

                            local mode = platform["Mode"] or "Purple"
                            if (mode == "Move") then
                                Player:Move(platform.speed.x, platform.speed.y)
                            end

                            local cos, sin = math.cos(math.rad(platform.rotation)), math.sin(math.rad(platform.rotation))
                            local w, h = platform.width * platform.xscale, platform.height * platform.yscale
                            while (
                                (Player.y + 8 - platform.y) * cos - (Player.x - platform.x) * sin > h / 2 - 12 and
                                (Player.y - platform.y) * cos - (Player.x - platform.x) * sin < h / 2 - 12
                            ) do
                                Player:Move(sin, -cos)
                            end
                        else
                            vars.blue.iscolliding = false
                        end
                    end
                else
                    vars.blue.iscolliding = false
                end
            end
        end

        for i = #vars.orange.shadows, 1, -1 do
            local shadow = vars.orange.shadows[i]
            if (shadow) then
                shadow.alpha = shadow.alpha - 0.05
                if (shadow.alpha <= 0) then
                    shadow:Destroy()
                    table.remove(vars.orange.shadows, i)
                end
            end
        end
    end
end

return PlayerLib