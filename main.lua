-- Libraries
global = require("Scripts.Libraries.GlobalVariables")
maths = require("Scripts.Libraries.Utils.Mathematics")
keyboard = require("Scripts.Libraries.Keyboard")
masks = require("Scripts.Libraries.MaskManager")
audio = require("Scripts.Libraries.AudioManager")
layers = require("Scripts.Libraries.Utils.Layers")
sprites = require("Scripts.Libraries.SpritesManager")
typers = require("Scripts.Libraries.TyperManager")
scenes = require("Scripts.Libraries.SceneManager")
tween = require("Scripts.Libraries.Tween")
windows = require("Scripts.Libraries.Utils.Windows")

-- Canvas setup
CANVAS = love.graphics.newCanvas(
    love.graphics.getWidth() * 1,
    love.graphics.getHeight() * 1,
    nil,
    {
        format = "stencil",
        readable = true
    }
)
CANVAS:setFilter("nearest", "nearest")
local CANVAS_USE_SHADER = false
local CANVAS_SHADER = nil

-- Global variables
global:SetVariable("LAYER", 30)
global:SetVariable("OverworldInited", false)

-- Display configuration
LOGICAL_WIDTH, LOGICAL_HEIGHT = 640, 480
local Camera = require("Scripts.Libraries.Utils.Camera")
_CAMERA_ = Camera:new(0, 0, 1, 1, 0)

-- Screen variables
screen_w, screen_h = love.graphics.getDimensions()
scale = math.min(screen_w / 640, screen_h / 480)
draw_x = math.floor((screen_w - 640 * scale) * 0.5 + 0.5)
draw_y = math.floor((screen_h - 480 * scale) * 0.5 + 0.5)

-- Frame rate control
local desiredFPS = 60
local frameTime = 1 / desiredFPS
local startTime

-- Main Love2D callbacks
function love.load()
    -- System setup
    if love.system.getOS() == "Windows" then
        local handle = io.popen("chcp 65001", "r")
        handle:close()
    end
    
    -- Initialization
    startTime = love.timer.getTime()
    math.randomseed(os.time())
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Scene loading
    local success, err = pcall(function()
        scenes.switchTo("Overworld/scene_ow_ruins_0") -- Start with the logo scene.
    end)
    
    if (not success) then
        print("Error loading scene: " .. err)
    end
end

function love.update(dt)

    -- These are the libraries' update functions.
    keyboard.Update()
    sprites.Update(dt)
    typers.Update()
    tween.Update(dt)
    _CAMERA_:update(dt)

    if (scenes.current) then
        if (scenes.current.update) then
            scenes.current.update(dt)
        end
    end

    -- The following code is used to limit the frame rate of the game.
    local endTime = love.timer.getTime()
    local elapsedTime = endTime - startTime
    if (elapsedTime < frameTime) then
        local sleepTime = frameTime - elapsedTime
        love.timer.sleep(sleepTime - 0.001)
        while (love.timer.getTime() - startTime < frameTime) do end
    end
    startTime = love.timer.getTime()

    -- The following code is used to update the audio manager.
    audio.Update()

end

function love.resize(w, h)
    if CANVAS:getWidth() < w or CANVAS:getHeight() < h then
        CANVAS = love.graphics.newCanvas(w - draw_x * 2, h - draw_y)
    end
end

function love.draw()
    screen_w, screen_h = love.graphics.getDimensions()
    scale = math.min(screen_w / 640, screen_h / 480)
    draw_x = math.floor((screen_w - 640 * scale) * 0.5 + 0.5)  -- 四舍五入到整数
    draw_y = math.floor((screen_h - 480 * scale) * 0.5 + 0.5)

    love.graphics.setCanvas({CANVAS, stencil = true})
    love.graphics.clear(true, true)

    love.graphics.push()

        love.graphics.scale(scale, scale)

        _CAMERA_:apply()
        love.graphics.setColor(1, 1, 1)

        if (scenes.current) then
            if (not scenes.current.PRIORITY) then
                if scenes.current and scenes.current.draw then
                    scenes.current.draw()
                end
                layers.sort()
            else
                layers.sort()
                if scenes.current and scenes.current.draw then
                    scenes.current.draw()
                end
            end
        end

        _CAMERA_:reset()

    love.graphics.pop()

    love.graphics.push()

        love.graphics.setCanvas()
        love.graphics.translate(draw_x, draw_y)
        love.graphics.setColor(1, 1, 1)
        
        if (CANVAS_USE_SHADER and CANVAS_SHADER) then
            love.graphics.setShader(CANVAS_SHADER)
            love.graphics.draw(CANVAS)
            love.graphics.setShader()
        else
            love.graphics.draw(CANVAS)
        end

    love.graphics.pop()
end


function love.keypressed(key)

    -- This is the main key pressed function.
    -- It is called when a key is pressed.
    -- However, we already have a key pressed function in the keyboard library.
    if (scenes.current) then
        if (scenes.current.keypressed) then
            scenes.current.keypressed(key)
        end
    end
    if (key == "f4") then
        love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
        scale = math.min(love.graphics.getWidth() / 640, love.graphics.getHeight() / 480)
    end
    if (key == "f2") then
        scenes.switchTo("scene_logo")
    end

end

-- This function is called when the game is closed.
-- It is used to clear any resources used by the game.
-- It is also used to save any data needed by the game.
function love.quit()
end