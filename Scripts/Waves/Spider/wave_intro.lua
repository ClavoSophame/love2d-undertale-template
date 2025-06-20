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
battle.Player.sprite:MoveTo(320, 320)
tween.CreateTween(
    function (value)
        battle.mainarena.width = value
    end,
    "Bounce", "Out", 565, 155, 60
)

local time = 0
local spiderSpr = "Attacks/Muffet/spr_spiderbullet1_0.png"
local donutSpr = "Attacks/Muffet/spr_donutbullet_0.png"
local BreadSpr = "Attacks/Muffet/spr_croissantl_0.png"

local TWOFINALY = 320

function wave.update(dt)
    mask:Follow(battle.mainarena.black)

    time = time + 1
    if (time % 30 == 0 and time <= 240) then
        local up_spider = sprites.CreateSprite(spiderSpr, global:GetVariable("LAYER"))
        up_spider._case = math.random(1, 2)
        up_spider._time = 0
        up_spider._f = math.random(4, 8)
        up_spider:SetStencils({mask})
        up_spider.isBullet = true

        up_spider._line = sprites.CreateSprite("px.png", global:GetVariable("LAYER") - 0.001)
        up_spider._line.color = {1, 0, 1}
        up_spider._line.ypivot = 0
        up_spider._line:SetStencils({mask})

        if (up_spider._case == 1) then up_spider.velocity.x = 3 up_spider.x = 200
        else up_spider.velocity.x = -3 up_spider.x = 440 end

        up_spider.logic = function(self)
            self._time = self._time + 1
            up_spider._f = up_spider._f - 0.15
            up_spider.velocity.y = up_spider._f
            up_spider._line.x = self.x
            up_spider._line.y = 240
            up_spider._line.yscale = up_spider.y - 240

            if (up_spider.y < 240) then
                up_spider._line:Destroy()
                up_spider:Destroy()
                for i = #wave.objects, 1, -1
                do
                    if (wave.objects[i] == up_spider) then
                        table.remove(wave.objects, i)
                        break
                    end
                end
            end
        end
        table.insert(wave.objects, up_spider)
    end

    if (time >= 240) then
        TWOFINALY = 60 * math.sin(time / 20)
    end
    if (time >= 270 and time <= 900 and time % 30 == 0) then
        local up_spider = sprites.CreateSprite(spiderSpr, global:GetVariable("LAYER"))
        up_spider._time = 0
        up_spider:SetStencils({mask})
        up_spider.isBullet = true

        up_spider._line = sprites.CreateSprite("px.png", global:GetVariable("LAYER") - 0.001)
        up_spider._line.color = {1, 0, 1}
        up_spider._line.ypivot = 0
        up_spider._line:SetStencils({mask})

        up_spider.velocity.x = 4
        up_spider.x = 200

        local down_spider = sprites.CreateSprite(spiderSpr, global:GetVariable("LAYER"))
        down_spider._time = 0
        down_spider:SetStencils({mask})
        down_spider.isBullet = true

        down_spider._line = sprites.CreateSprite("px.png", global:GetVariable("LAYER") - 0.001)
        down_spider._line.color = {1, 0, 1}
        down_spider._line.ypivot = 0
        down_spider._line:SetStencils({mask})

        down_spider.velocity.x = -4
        down_spider.x = 440

        up_spider.logic = function(self)
            self._time = self._time + 1
            up_spider.y = 320 + TWOFINALY
            up_spider._line.x = self.x
            up_spider._line.y = 240
            up_spider._line.yscale = up_spider.y - 240

            if (up_spider.y < 240) then
                up_spider._line:Destroy()
                up_spider:Destroy()
                for i = #wave.objects, 1, -1
                do
                    if (wave.objects[i] == up_spider) then
                        table.remove(wave.objects, i)
                        break
                    end
                end
            end
        end

        down_spider.logic = function(self)
            self._time = self._time + 1
            down_spider.y = 320 - TWOFINALY
            down_spider._line.x = self.x
            down_spider._line.y = 240
            down_spider._line.yscale = down_spider.y - 240

            if (down_spider.y < 240) then
                down_spider._line:Destroy()
                down_spider:Destroy()
                for i = #wave.objects, 1, -1
                do
                    if (wave.objects[i] == down_spider) then
                        table.remove(wave.objects, i)
                        break
                    end
                end
            end
        end

        table.insert(wave.objects, up_spider)
        table.insert(wave.objects, down_spider)
    end

    if (time == 1000) then
        EndWave()
        return
    end

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        obj:logic()
    end
end

function wave.draw()
end

return wave