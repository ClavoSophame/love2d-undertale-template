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

local Arena = battle.mainarena
local Player = battle.Player

Arena:Resize(155, 130)
Player.sprite:MoveTo(320, 320)

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

function wave.update(dt)
    mask:Follow(Arena.black)

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        if (obj.logic) then
            obj:logic(dt)
        end
    end
end

function wave.draw()
end

return wave