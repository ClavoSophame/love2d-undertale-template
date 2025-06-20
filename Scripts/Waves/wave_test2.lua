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

local stb = false
function startbattle()
    stb = true
end

local pst = typers.CreateText({
    "[space:2, 0][fontSize:16][colorHEX:000000][font:Papyrus.ttf]PLEASE CONTROL\nYOUR BEHAVIOR.",
    "[noskip][function:startbattle][next]"
}, {220, 80}, 200, {200, 100}, "manual")
pst:ShowBubble("left", 0.5)
battle.Player.sprite:MoveTo(320, 320)
battle.mainarena:Resize(155, 130)

local mask1 = masks.New("rectangle", 320, 320, 155, 130, 30, 1)

local variable = 0
function wave.update(dt)
    if (stb) then
        variable = variable + 1

        if (variable % 6 == 0) then
            local bul = sprites.CreateSprite("bullet.png", global:GetVariable("LAYER"))
            bul.y = 0
            bul.x = math.random(220, 420)
            bul.isBullet = true

            local rand = math.random(1, 3)
            if (rand == 1) then
                bul.color = {1, .5, 0}
                bul['HurtMode'] = "orange"
            elseif (rand == 2) then
                bul.color = {0, 1, 0}
                bul['HurtMode'] = "green"
            elseif (rand == 3) then
                bul.color = {0, 1, 1}
                bul['HurtMode'] = "blue"
            end

            bul.logic = function(self)
                self.velocity.y = self.velocity.y + 0.1
                if (self.y > 490) then
                    self:Destroy()
                    for i = #wave.objects, 1, -1 do
                        if (wave.objects[i] == self) then
                            table.remove(wave.objects, i)
                            break
                        end
                    end
                end
            end

            table.insert(wave.objects, bul)
        end

        for i = #wave.objects, 1, -1 do
            local bul = wave.objects[i]
            if (bul.isactive) then
                bul:logic()
            end
        end

        if (variable > 400) then
            EndWave()
        end
    end
end

function wave.draw()
end

return wave