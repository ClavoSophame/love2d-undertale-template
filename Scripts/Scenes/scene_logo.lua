local SCENE = {}

local logo = sprites.CreateSprite("Logo.png", 0)
audio.PlaySound("mus_intro.ogg")

local license = typers.DrawText("[scale=0.5][spaceX=-8][red]UNDERTALE  ©2015 Toby Fox", {5, 445}, 1)
local license2 = typers.DrawText("[scale=0.5][spaceX=-8][purple]SOULENGINE ©2025 Clavo Sophame", {5, 460}, 1)
local version = typers.DrawText("[scale=0.5][spaceX=-8]v2.3.4-[yellow]stable", {-90, 460}, 1)
local length = version:GetLettersSize()
version.x = 640 - length - 5

local time = 0
local text_alpha = 0

function SCENE.load()
end

function SCENE.update(dt)
    if (keyboard.GetState("confirm") == 1) then
        scenes.switchTo("scene_battle")
    end

    time = time + 1
    if (time % 60 == 0 and time >= 180) then
        text_alpha = 1 - text_alpha
    end
end

local tfont = love.graphics.newFont("Resources/Fonts/determination_mono.ttf", 13)
tfont:setFilter("nearest", "nearest")
function SCENE.draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1, text_alpha)
    love.graphics.setFont(tfont)
    love.graphics.print("[Press z or enter]", 240, 320)
    love.graphics.pop()
end

function SCENE.clear()
    layers.clear()
    love.audio.stop()
    audio.ClearAll()
end

return SCENE