local SCENE = {}
local shader = love.graphics.newShader("Scripts/Shaders/gradient")
shader:send("color_tl", {1, 0, 0, 1})
shader:send("color_tr", {0, 0, 1, 1})
shader:send("color_br", {0, 1, 0, 1})
shader:send("color_bl", {1, 1, 0, 1})

local blurshader = love.graphics.newShader("Scripts/Shaders/blur")
blurshader:send("radius", 1)
blurshader:send("direction", {1, 0})

local frame = 0
local bul = sprites.CreateSprite("poseur.png", 10)
bul.color = {1, 1, 0}

tween.CreateTween(
    function(value) bul.rotation = value bul.x = value end,
    "back", "inout", 0, 360, 120
)
local volume = 0.5
function SCENE.load()
    rainbgm = audio.PlayMusic("Weather/mus_rain.ogg", 1, true)
end

local rains = {}
function SCENE.update(dt)
    frame = frame + 1
    if (volume < 1) then
        volume = volume + 0.01
        rainbgm:setVolume(volume)
    end

    if (frame % 1 == 0) then
        local rain = sprites.CreateSprite("px.png", 11)
        rain:Scale(2, math.random(10, 15))
        rain.color = {0, 1, 1}
        rain.alpha = 0.5
        rain:MoveTo(math.random(3, 640 + 150), -20)
        rain.rotation = 20
        table.insert(rains, rain)
    end

    if (frame == 160) then
        bul:Dust(true)
    end

    for i = #rains, 1, -1
    do
        local rain = rains[i]
        if (rain.isactive) then
            rain:Move(
                -rain.yscale * math.sin(math.rad(rain.rotation)),
                rain.yscale * math.cos(math.rad(rain.rotation))
            )
            if (rain.y >= love.graphics.getHeight() + rain.height) then
                rain:Destroy()
                table.remove(rains, i)
            end
        end
    end
end

function SCENE.draw()
end

function SCENE.clear()
    layers.clear()
    love.audio.stop()
end

return SCENE