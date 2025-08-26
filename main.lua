-- Libraries
global = require("Scripts.Libraries.GlobalVariables")
maths = require("Scripts.Libraries.Utils.Mathematics")
collisions = require("Scripts.Libraries.Collisions")
keyboard = require("Scripts.Libraries.Keyboard")
masks = require("Scripts.Libraries.MaskManager")
audio = require("Scripts.Libraries.AudioManager")
layers = require("Scripts.Libraries.Utils.Layers")
sprites = require("Scripts.Libraries.SpritesManager")
typers = require("Scripts.Libraries.TyperManager")
scenes = require("Scripts.Libraries.SceneManager")
tween = require("Scripts.Libraries.Tween")
localize = require("Localization.en")
require("Localization.LOCALIZE")

-- Canvas setup
CANVAS = love.graphics.newCanvas(
    love.graphics.getWidth(),
    love.graphics.getHeight(),
    nil,
    {
        format = "stencil",
        readable = true
    }
)
CANVAS:setFilter("nearest", "nearest")
local INTERMEDIATE_CANVAS = love.graphics.newCanvas(
    love.graphics.getWidth(),
    love.graphics.getHeight(),
    nil,
    {
        format = "stencil",
        readable = true
    }
)
INTERMEDIATE_CANVAS:setFilter("nearest", "nearest")

-- Global variables
global:SetVariable("FPS", 60)
global:SetVariable("ScreenShaders", {})
global:SetVariable("LAYER", 30)
global:SetVariable("EncounterNobody", false)
local reset_room = "scene_logo"

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
local frameTime = 1 / global:GetVariable("FPS")
local startTime

-- Main Love2D callbacks
function love.load()
    -- System setup
    if (not _RELEASED) then
        if (love.system.getOS() == "Windows") then
            local handle = io.popen("chcp 65001", "r")
            handle:close()
        end
    end

    -- Initialization
    startTime = love.timer.getTime()
    math.randomseed(os.time())
    love.graphics.setBackgroundColor(0, 0, 0)

    --[[if (love.system.openURL) then
        if (love.system.getOS() == "Windows") then
            os.execute("start \"\" \"" .. love.filesystem.getSaveDirectory() .. "/testplaceholder\"")
        else
            love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/testplaceholder")
        end
    end]]

    -- Scene loading
    local success, err = pcall(function()
        scenes.switchTo("scene_logo") -- Start with the logo scene.
        reset_room = "scene_logo" -- Which room will the player switch to after pressed f2.
    end)

    if (not success) then
        error(err)
    end
end

function love.update(dt)

    -- These are the libraries' update functions.
    keyboard.Update()
    sprites.Update(dt)
    typers.Update()
    tween.Update(dt)
    if (scenes.current) then
        if (scenes.current.update) then
            scenes.current.update(dt)
        end
    end
    _CAMERA_:update(dt)

    -- The following code is used to limit the frame rate of the game.
    frameTime = 1 / global:GetVariable("FPS")
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
    if CANVAS:getWidth() ~= w or CANVAS:getHeight() ~= h then
        CANVAS = love.graphics.newCanvas(w - draw_x * 2, h - draw_y)
    end
end

function love.draw()
    screen_w, screen_h = love.graphics.getDimensions()
    scale = math.min(screen_w / 640, screen_h / 480)
    draw_x = math.floor((screen_w - 640 * scale) * 0.5 + 0.5)  -- 四舍五入到整数
    draw_y = math.floor((screen_h - 480 * scale) * 0.5 + 0.5)

    love.graphics.setCanvas({CANVAS, stencil = true})
    love.graphics.clear(true, true, true)

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

        local shaders = global:GetVariable("ScreenShaders") or {}

        if (#shaders > 0) then
            local source = CANVAS
            local target = INTERMEDIATE_CANVAS

            for _, shader in ipairs(shaders) do
                love.graphics.setCanvas(target)
                love.graphics.clear()

                love.graphics.setShader(shader)
                love.graphics.draw(source)
                love.graphics.setShader()

                source, target = target, source
            end

            love.graphics.setCanvas()
            love.graphics.draw(source)
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
        scale = math.min(love.graphics.getWidth() / LOGICAL_WIDTH, love.graphics.getHeight() / LOGICAL_HEIGHT)
    end
    if (key == "f2") then
        _CAMERA_:setPosition(0, 0)
        scenes.switchTo(reset_room)
    end

end

-- This function is called when the game is closed.
-- It is used to clear any resources used by the game.
-- It is also used to save any data needed by the game.
function love.quit()
end