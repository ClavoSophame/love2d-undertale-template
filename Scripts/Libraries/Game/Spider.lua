-- This is where we init the encounter.
-- All the encounter data is stored here.
local encounter = {

    -- This is your encounter text, which will be displayed at the main ARENA.
    EncounterText = "* [fontIndex:2][pattern:chinese]闻起来像蜘蛛。",

    -- These are variables that player can get when they win the battle.
    Gold = 0,
    Exp = 0,

    -- This table is for the enemy data.
    -- You can add as many enemies as you want, but the first one will be the one that is displayed first.
    Enemies = {
        {
            name = "[preset=chinese]蜘蛛",
            defensetext = "MISS",
            misstext = "MISS",
            exp = 1,
            gold = 1,
            maxhp = 1,
            hp = 1,
            maxdamage = 999,

            killable = true,
            canspare = true,
            dead = false,

            actions = {
                "[preset=chinese][offsetX=4]查看"
            },
            position = {
                x = 320,
                y = 160
            }
        }
    },

    -- This is the table that contains your inventory.
    Inventory = {
        Pattern = 1, -- Pattern 2 is not available yet.
        NoDelete = false,

        -- Your items go here.
        Items = {
            "[preset=chinese][red]Chocolate",
            "[brown]Chocolate", "I'm end",
            "[purple]Chocolate", "I'm end"
        }
    },

    -- The default state of the encounter.
    STATE = "DEFENDING",

    -- This is the table that contains your player data.
    Player = {
        shadows = {},
        sprite = sprites.CreateSprite("Soul Library Sprites/spr_default_heart.png", 15),
        name = "Chara",
        lv = 1,
        maxhp = 20,
        hp = 20,
        soulMode = 1,
        canMove = true,

        -- Don't touch these below.
        -- They are used for the player movement and hurt system.
        speed = 2,
        hurting = false,
        hurtingTime = 1,
        isMoving = false,

        -- This is the table that contains your player actions.
        soul_variables = {
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

                canjump = false,
                jumping = true,

                direction = "down"
            }
        }
    },

    -- And don't touch this one...
    -- This controls whether you can win the encounter or not.
    -- If you set this to true, you will win the encounter no matter what.
    -- So the battle will end immediately.
    WIN = false
}

-- This is the function that will be called when the player is hurt.
-- It will take the damage and the time it will take to recover from the hurt.
function encounter.Player.Hurt(damage, time, sound)
    if (encounter.Player.hp - damage > 0) then
        encounter.Player.hp = encounter.Player.hp - damage
        encounter.Player.hurtingTime = time
        encounter.Player.hurting = true
        if (sound) then
            audio.PlaySound("snd_phurt.wav", 1, false)
        end
    else
        encounter.Player.hp = 0
    end
end

-- This is the function that will be called when the player is healed.
-- It will take the value of the heal and the sound that will be played.
function encounter.Player.Heal(value, sound)
    if (encounter.Player.hp + value > encounter.Player.maxhp) then
        encounter.Player.hp = encounter.Player.maxhp
    else
        encounter.Player.hp = encounter.Player.hp + value
    end
    local s = sound or true
    if (s) then
        audio.PlaySound("snd_heal.wav", 1, false)
    end
end

-- This is the function that will be called when the player's soul needs to be changed.
-- It will take the number of the soul and the arguments that will be passed to it.
function encounter.Player.SetSoul(number, ...)
    local Player = encounter.Player.sprite
    encounter.Player.soulMode = number
    local args = ({...} or {})

    audio.PlaySound("snd_ding.wav", 1, false)
    if (number == 1) then
        Player:Set("Soul Library Sprites/spr_default_heart.png")
        Player.color = {1, 0, 0, 1}
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
    end

    local shadow = sprites.CreateSprite(encounter.Player.sprite.path, 14.9)
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
    table.insert(encounter.Player.shadows, shadow)
end

-- This is the function that will be called whether the player can move and how should they move.
-- pvennoposx and pvennoposy are used to check if the player is moving or not.
local pvennoposx, pvennoposy = 0, 0
function encounter.Player.Movement(dt)
    local Player
    if (encounter.Player.sprite) then
        Player = encounter.Player.sprite
        local mode = encounter.Player.soulMode
        local vars = encounter.Player.soul_variables
        local angle = math.rad(Player.rotation)
        if (keyboard.GetState("cancel") > 0) then
            Player.speed = 1
        else
            Player.speed = 2
        end
        if (mode == 1) then -- The red soul, also known as the "default" soul.
            if (encounter.Player.canMove) then
                if (keyboard.GetState("up") > 0) then
                    Player:Move(Player.speed * math.sin(angle), -Player.speed * math.cos(angle))
                end
                if (keyboard.GetState("down") > 0) then
                    Player:Move(-Player.speed * math.sin(angle), Player.speed * math.cos(angle))
                end
                if (keyboard.GetState("left") > 0) then
                    Player:Move(-Player.speed * math.cos(angle), -Player.speed * math.sin(angle))
                end
                if (keyboard.GetState("right") > 0) then
                    Player:Move(Player.speed * math.cos(angle), Player.speed * math.sin(angle))
                end
            end
        elseif (mode == 2) then -- The orange soul, when it starts moving, it will automatically move and will never stop.
            if (encounter.Player.canMove) then
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
                    Player:Move(Player.speed * math.sin(angle), -Player.speed * math.cos(angle))
                elseif (vars.orange.direction == "down") then
                    Player:Move(-Player.speed * math.sin(angle), Player.speed * math.cos(angle))
                elseif (vars.orange.direction == "left") then
                    Player:Move(-Player.speed * math.cos(angle), -Player.speed * math.sin(angle))
                elseif (vars.orange.direction == "right") then
                    Player:Move(Player.speed * math.cos(angle), Player.speed * math.sin(angle))
                elseif (vars.orange.direction == "upleft") then
                    Player:Move(-Player.speed * math.cos(angle), -Player.speed * math.cos(angle))
                elseif (vars.orange.direction == "upright") then
                    Player:Move(Player.speed * math.cos(angle), -Player.speed * math.cos(angle))
                elseif (vars.orange.direction == "downleft") then
                    Player:Move(-Player.speed * math.cos(angle), Player.speed * math.cos(angle))
                elseif (vars.orange.direction == "downright") then
                    Player:Move(Player.speed * math.cos(angle), Player.speed * math.cos(angle))
                end
            end
        elseif (mode == 3) then -- The yellow soul, which can shoot bullets.
            if (encounter.Player.canMove) then
                if (keyboard.GetState("up") > 0) then
                    Player:Move(Player.speed * math.sin(angle), -Player.speed * math.cos(angle))
                end
                if (keyboard.GetState("down") > 0) then
                    Player:Move(-Player.speed * math.sin(angle), Player.speed * math.cos(angle))
                end
                if (keyboard.GetState("left") > 0) then
                    Player:Move(-Player.speed * math.cos(angle), -Player.speed * math.sin(angle))
                end
                if (keyboard.GetState("right") > 0) then
                    Player:Move(Player.speed * math.cos(angle), Player.speed * math.sin(angle))
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
        elseif (mode == 6) then -- The blue soul, which affected by the gravity.
            local _vars = vars.blue
            if (encounter.Player.canMove) then
                if (_vars.direction == "down" or _vars.direction == "up") then
                    if (keyboard.GetState("left") > 0) then
                        Player:Move(-Player.speed * math.cos(angle), -Player.speed * math.sin(angle))
                    end
                    if (keyboard.GetState("right") > 0) then
                        Player:Move(Player.speed * math.cos(angle), Player.speed * math.sin(angle))
                    end
                    if (_vars.direction == "down") then -- 3, 3, 4
                        if (_vars.canjump) then
                            _vars.currentspd = 0
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
                                _vars.currentspd = _vars.glide
                                _vars.jumping = false
                            end
                        else
                            _vars.currentspd = _vars.currentspd - _vars.gravity
                        end
                        Player:Move(-_vars.currentspd * math.sin(math.rad(angle)), -_vars.currentspd * math.cos(math.rad(angle)))
                    end
                end
            end
        end
    end
end

-- This is the function that will be called when the player is updated.
-- It will check if the player is moving or not and if they are hurting or not.
function encounter.Player.Update(dt)
    if (encounter.Player.hurting) then
        encounter.Player.hurtingTime = encounter.Player.hurtingTime - 1
        if (encounter.Player.hurtingTime <= 0) then
            encounter.Player.hurting = false
            encounter.Player.hurtingTime = 60
        else
            if (encounter.Player.hurtingTime % 10 == 0) then
                encounter.Player.sprite.alpha = 0.4
            elseif (encounter.Player.hurtingTime % 10 == 5) then
                encounter.Player.sprite.alpha = 1
            end
        end
    end
    if (pvennoposx ~= encounter.Player.sprite.x or pvennoposy ~= encounter.Player.sprite.y) then
        encounter.Player.isMoving = true
        pvennoposx = encounter.Player.sprite.x
        pvennoposy = encounter.Player.sprite.y
    else
        encounter.Player.isMoving = false
    end

    if (encounter.Player.soulMode) then
        local mode = encounter.Player.soulMode
        local Player = encounter.Player.sprite
        local vars = encounter.Player.soul_variables
        if (mode == 2) then
            local _vars = vars.orange
            _vars.time = _vars.time + 1
            if (_vars.time % 3 == 0) then
                local shadow = sprites.CreateSprite(encounter.Player.sprite.path, 14.9)
                shadow.rotation = Player.rotation
                shadow.color = Player.color
                shadow.alpha = 0.5
                shadow:MoveTo(Player:GetPosition())
                table.insert(_vars.shadows, shadow)
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

    for i = #encounter.Player.shadows, 1, -1 do
        local shadow = encounter.Player.shadows[i]
        if (shadow) then
            shadow.alpha = shadow.alpha - 0.03
            shadow:MoveTo(encounter.Player.sprite:GetPosition())
            if (shadow.alpha <= 0) then
                shadow:Destroy()
                table.remove(encounter.Player.shadows, i)
            end
        end
    end
end

return encounter