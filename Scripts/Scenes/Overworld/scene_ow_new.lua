-- This is a template for creating a new scene in the game.
-- You can use this as a starting point for your own scenes.
local SCENE = {}

--_CAMERA_:setBounds(280 - 320, 300 - 240, 280 + 320, 300 + 240)
local ow = require("Scripts.Libraries.Overworld.InitWorld")
ow.Init("Maps/ruins_0.lua", "scene_ow_new")
ow.DEBUG = true
print(ow.NAME)

-- This is a fake scene for testing purposes.
function SCENE.load()
    -- Load any resources needed for this scene here.
    -- For example, you might load images, sounds, etc.
end

local sign_checked = 1
-- This function is called to update the scene.
function SCENE.update(dt)
    -- Update any game logic for this scene here.
    -- For example, you might update animations, handle input, etc.

    ow.Update(dt)
    -- print(ow.char.currentSprite:GetPosition())

    -- Move the player to the mouse's position
    if (keyboard.GetState("space") == 1) then
        ow.char.collision.body:setPosition(keyboard.GetMousePosition())
    end

    if (ow.getInteractResult("save", 1)) then
        if (keyboard.GetState("confirm") == 1) then
            ow.SaveInteract(
                {
                    "[colorHEX:99ffff]* BAKABAKA",
                    "[colorHEX:99ff99]* Chiruno!--"
                },
                "Idk where"
            )
        end
    end

    if (ow.getInteractResult("chest", 1)) then
        if (keyboard.GetState("confirm") == 1) then
            ow.ChestInteract("chest1")
        end
    end
    if (ow.getInteractResult("chest", 2)) then
        if (keyboard.GetState("confirm") == 1) then
            ow.dialogNew({"* Don't touch that chest!"})
        end
    end
    if (ow.getInteractResult("sign", 1)) then
        if (keyboard.GetState("confirm") == 1) then
            if (sign_checked == 1) then
                ow.dialogNew({"* The sign reads:", "* 'Welcome to the Ruins'", "* 'Press Z to interact with\n  objects'"})
            end
            if (sign_checked == 2) then
                ow.dialogNew({"* The sign reads:", "* 'The Ruins are full of\n  puzzles'"})
            end
            if (sign_checked == 3) then
                ow.dialogNew({"* The sign reads:", "* 'Some puzzles are\n  optional'"})
            end
            if (sign_checked == 4) then
                ow.dialogNew({"* The sign reads:", "* 'Good luck on your\n  journey'"})
            end
            if (sign_checked > 4) then
                ow.dialogNew({"* Nothing useful here."})
            end
            sign_checked = sign_checked + 1
        end
    end

    if (ow.NEXTSTATE ~= nil) then
        ow.CSTATE = ow.NEXTSTATE
        ow.NEXTSTATE = nil
    end
end

-- This function is called to draw the scene.
-- It is called after the main game loop has finished updating.
function SCENE.draw()
    -- Draw the scene here.
    -- For example, you might draw images, text, etc.
    ow.Draw()
end

-- This function is called when the scene is switched away from.
function SCENE.clear()
    -- Clear any resources used by this scene here.
    -- For example, you might unload images, sounds, etc.
    package.loaded["Scripts.Libraries.Overworld.InitWorld"] = nil

    layers.clear()
    ow.Destroy()
end

-- Don't touch this(just one line).
return SCENE