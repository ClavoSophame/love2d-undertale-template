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

local bones = require("Scripts.Libraries.Attacks.Bones")
local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

battle.mainarena:Resize(155, 155)
battle.mainarena:MoveTo(320, 320 - 13)
battle.Player.sprite:MoveTo(320, 320)
battle.Player.SetSoul(6)

local time = 0
local p = 0
local p1 = 0
local pf = 0
function wave.update(dt)
    bones:Update()
    mask:Follow(battle.mainarena.black)

    time = time + 1
    if (time == 60) then
        local wall = bones:Wall(battle.mainarena, "Papyrus", 40, 30, 50, "up", 10, 13, {
            In = "BounceOut", Out = "BackIn",
            It = 30         , Ot  = 60
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
        local wall = bones:Wall(battle.mainarena, "Papyrus", 40, 30, 50, "down", 10, 13, {
            In = "BounceOut", Out = "BackIn",
            It = 30         , Ot  = 60
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
        local wall = bones:Wall(battle.mainarena, "Papyrus", 40, 30, 50, "left", 10, 13, {
            In = "BounceOut", Out = "BackIn",
            It = 30         , Ot  = 60
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
        local wall = bones:Wall(battle.mainarena, "Papyrus", 40, 30, 50, "right", 10, 13, {
            In = "BounceOut", Out = "BackIn",
            It = 30         , Ot  = 60
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
    end

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        obj:logic()
    end
end

function wave.draw()
end

return wave