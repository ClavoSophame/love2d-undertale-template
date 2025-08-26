local SCENE = {}

local posx, posy = unpack(global:GetVariable("PlayerPosition"))
local player = battle.Player.sprite

local heart = sprites.CreateSprite("Soul Library Sprites/spr_default_heart.png", 0)
heart:MoveTo(posx, posy)
heart.color = player.color
local time = 0
local shards = {}

local gameover = sprites.CreateSprite("UI/Battle Screen/spr_gameoverbg_0.png", 5)
gameover.y = 120
gameover.alpha = 0
local mus, ins

local leaving = false
function LeaveScene()
    leaving = true
    ins:VolumeTransition(1, 0, 1.4)
end

function SCENE.load()
end

function SCENE.update(dt)
    time = time + 1
    if (time == 60) then
        audio.PlaySound("snd_heartbreak_0.wav")
        heart:Set("Soul Library Sprites/spr_heartbreak_0.png")
    elseif (time == 120) then
        audio.PlaySound("snd_heartbreak_1.wav")
        for i = 1, 8
        do
            local f = math.random(0, 3)
            local shard = sprites.CreateSprite("UI/Battle Screen/Shards/spr_heartshards_" .. f .. ".png", 10)
            shard.xspeed = math.random(-40, 40)
            shard.yspeed = -math.random(50)
            shard.gravity = 1.5
            shard:SetAnimation(
                {
                    "UI/Battle Screen/Shards/spr_heartshards_0.png", 
                    "UI/Battle Screen/Shards/spr_heartshards_1.png", 
                    "UI/Battle Screen/Shards/spr_heartshards_2.png", 
                    "UI/Battle Screen/Shards/spr_heartshards_3.png"
                }, 10
            )
            shard.animation.index = f + 1
            shard:MoveTo(posx, posy)
            shard.color = player.color
            table.insert(shards, shard)
        end
        heart:Destroy()
    end
    if (time == 180) then
        mus, ins = audio.PlayMusic("mus_gameover.ogg", 0, false)
        ins:VolumeTransition(0, 1, 1.4)
    end
    if (time >= 180 and time <= 280) then
        gameover.alpha = gameover.alpha + 0.01
    end
    if (time == 240) then
        typers.CreateText({
            "[voice:v_fluffybuns.wav][speed:0.5]* Our fate rests\n  upon you...",
            "[voice:v_fluffybuns.wav][speed:0.5]* Chara!\n* Stay determined.",
            "[noskip][function:LeaveScene]"
        }, {120, 300}, 15, {0, 0}, "manual")
    end

    if (leaving) then
        gameover.alpha = gameover.alpha - 0.01

        if (gameover.alpha <= 0) then
            DATA.savedpos = true
            scenes.switchTo("Overworld/" .. global:GetVariable("ROOM"))
        end
    end

    for i = #shards, 1, -1
    do
        local s = shards[i]
        if (s.isactive) then
            s.yspeed = s.yspeed + s.gravity
            s:Move(s.xspeed / 10, s.yspeed / 10)

            if (s.y > 500) then
                s:Destroy()
                table.remove(shards, i)
            end
        end
    end
end

function SCENE.draw()
end

function SCENE.clear()
    battle = nil
    layers.clear()
    --love.audio.stop()
    audio.ClearAll()
end

return SCENE