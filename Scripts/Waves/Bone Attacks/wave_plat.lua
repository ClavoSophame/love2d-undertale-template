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
Player.SetSoul(6)

local pf = battle.Player.BluePlatform(320, 335, 29.9)
pf["Mode"]="Move"
pf.color = {0, 1, 0}
pf:Scale(0.05, 1)
pf.time = 0
pf.logic = function(self)
    self.time = self.time + 1
    self.velocity.x = 0.5 * math.sin(math.rad(self.time))

    if (self.time == 30) then
        --self:Delete()
    end
end
table.insert(wave.objects, pf)

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

function wave.update(dt)
    mask:Follow(Arena.black)

    local v = Player.soul_variables
    print(
        v.blue.canjump, v.blue.iscolliding, v.blue.jumping
    )

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