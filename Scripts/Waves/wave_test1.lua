local wave = {
    ENDED = false,
    objects = {}
}

local function EndWave()
    wave.ENDED = true
    arenas.clear()
    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        obj:Destroy()
        table.remove(wave.objects, i)
    end
end

battle.Player.canMove = false
local stb = false
function startbattle()
    battle.Player.canMove = true
    stb = true
end

local pst = typers.CreateText({
    "[voice:v_papyrus.wav][space:2, 0][fontSize:16][colorHEX:000000][font:Papyrus.ttf]MOUSE POSITION\nTEST.",
    "[voice:v_papyrus.wav][space:2, 0][fontSize:16][colorHEX:000000][font:Papyrus.ttf]CAN YOU FIND\nTHE GREEN\nBULLET?",
    "[noskip][function:startbattle][next]"
}, {220, 80}, 200, {200, 100}, "manual")
pst:ShowBubble("left", 0.5)
battle.Player.sprite:MoveTo(320, 320)
battle.mainarena:RotateTo(30)
battle.mainarena:Resize(155, 130)

local mask1 = masks.New("rectangle", 320, 320, 155, 130, 30, 1)

-- This is the red bullet.
local bul = sprites.CreateSprite("bullet.png", 20)
bul.isBullet = true
bul:Scale(-4, 2)
bul.color = {1, 0, 0}
table.insert(wave.objects, bul)

-- This is the green bullet.
local bul1 = sprites.CreateSprite("bullet.png", 19)
bul1.isBullet = true
bul1:Scale(2, 2)
bul1.color = {0, 1, 0}
table.insert(wave.objects, bul1)

local variable = 0

function wave.update(dt)
    if (stb) then
        variable = variable + 1

        -- Please use this to make the bullets follow the mouse at ANY TIME.
        bul.x, bul.y = keyboard.GetMousePosition()

        -- So that's why you will see the red bullet turns green in fullscreen mode.
        -- It's because the mouse position is not changing.
        bul1.x, bul1.y = love.mouse.getPosition()

        if (variable > 400) then
            EndWave()
        end
    end
end

function wave.draw()
end

return wave