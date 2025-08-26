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
    "[space:2, 0][fontSize:16][colorHEX:000000][font:Papyrus.ttf]WHAT ABOUT\nCOLORFUL BULLETS.",
    "[noskip][function:startbattle][next]"
}, {220, 80}, 200, {200, 100}, "manual")
pst:ShowBubble("left", 0.5)
battle.Player.sprite:MoveTo(320, 320)
battle.mainarena:Resize(155, 130)

-- This is the mask1 stencil.
-- args: shape, x, y, width, height, rotation, id
local mask1 = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

-- This is how we init a shader.
local shader = love.graphics.newShader("Scripts/Shaders/gradient")
local invert = love.graphics.newShader("Scripts/Shaders/invert")

-- You need to send the colors to the shader.
shader:send("color_tl", {1, 0, 0, 1})
shader:send("color_tr", {0, 0, 1, 1})
shader:send("color_br", {0, 1, 0, 1})
shader:send("color_bl", {1, 1, 0, 1})

local variable = 0
function wave.update(dt)

    -- You need to make sure to update the mask1 stencil.
    mask1.x = battle.mainarena.black.x
    mask1.y = battle.mainarena.black.y
    mask1.w = battle.mainarena.black.width * battle.mainarena.black.xscale
    mask1.h = battle.mainarena.black.height * battle.mainarena.black.yscale
    mask1.r = battle.mainarena.black.rotation

    if (stb) then
        variable = variable + 1

        if (variable % 10 == 0) then
            local bul = sprites.CreateSprite("bullet.png", global:GetVariable("LAYER"))
            bul.y = math.random(240, 400)

            -- This is how we use stencils to make a bullet only appear in a certain area.
            -- We use the mask1 stencil here, which is a rectangle that following the main arena.
            bul:SetStencils({mask1})

            -- This is how we set the shader to the bullet.
            bul:SetShaders({shader})

            local rand = math.random(1, 2)
            if (rand == 1) then
                bul.x = 220
                bul.velocity.x = 2
            elseif (rand == 2) then
                bul.x = 420
                bul.velocity.x = -2
            end
            bul._tpo = rand
            bul.isBullet = true

            bul.logic = function(self)
                if ((self._tpo == 1 and self.x >= 420) or (self._tpo == 2 and self.x <= 220)) then
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