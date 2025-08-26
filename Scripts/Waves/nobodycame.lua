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

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)
battle.Player.sprite.alpha = 0
battle.Player.canMove = false
local encounterTyper = typers.CreateText({
    "[scale:0.5]* [pattern:chinese][fontIndex:2][scale:1]但是谁也没有来。",
    "[noskip][function:ChangeScene|" .. DATA.room .. "][next]"
}, {60, 270}, 13, {400, 150}, "manual")

function wave.update(dt)
    mask:Follow(battle.mainarena.black)
end

function wave.draw()
end

return wave