---@diagnostic disable: undefined-field, param-type-mismatch
-- Scene: Ruins
-- Handles the ruins area gameplay

local SCENE = {}
local sti = require("Scripts.Libraries.STI")
local love = require("love")

DATA = DATA or global:GetSaveVariable("Overworld") or
{
    time = 0,
    room_name = "--",
    room = "Overworld/scene_ow_ruins_0",
    marker = 1,
    player = {
        name = "Chara",
        lv = 1,
        maxhp = 20,
        hp = 20,

        gold = 0,
        exp = 0,

        atk = 0,
        watk = 0,
        def = 0,
        edef = 0,
        weapon = "[preset=chinese]木棍",
        armor = "[preset=chinese]绷带",

        items = {
            "[preset=chinese]神秘小礼物",
            "[preset=chinese]铁壶",
            "[preset=chinese]吃我",
            "[preset=chinese]安黛因的信",
            "[preset=chinese]传单",
            "[preset=chinese]别欺负我",
        },
        cells = {}
    },
    position = {0, 0},
    direction = "down",
    savedpos = false,
}
FLAG = FLAG or global:GetSaveVariable("Flag") or
{
    ruins_killed = 0,
    ruins_0 = {
        donut_chest = false,
        text_inst = false
    }
}
CHESTS = CHESTS or global:GetSaveVariable("Chests") or
{
    chest1 = {
        "[preset=chinese][red]蜘蛛",
    }
}
if (not global:GetSaveVariable("Overworld")) then
    global:SetSaveVariable("Overworld", DATA)
end
if (not global:GetSaveVariable("Flag")) then
    global:SetSaveVariable("Flag", FLAG)
end
if (not global:GetSaveVariable("Chests")) then
    global:SetSaveVariable("Chests", CHESTS)
end

local stat = require("Scripts.Libraries.Overworld.Stat")
local encounter = require("Scripts.Libraries.Overworld.EncounterStep")
encounter.Init(FLAG.ruins_killed, 240, 40, 3)
encounter.run = true

local function TPos(x, y)
    return _CAMERA_.x + x, _CAMERA_.y + y
end
local spidermoving = false
local spidertime = 0

-- Constants
local WARPSCREEN = sprites.CreateSprite("px.png", 100000)
WARPSCREEN:Scale(9999, 9999)
WARPSCREEN.color = {0, 0, 0}
WARPSCREEN:MoveTo(TPos(320, 240))
local DEBUG_MODE = true
local SCALE_FACTOR = 2
local PLAYER_SPEED = 200
local ANIMATION_FRAME_TIME = 0.16
local SCREEN_CENTER_X, SCREEN_CENTER_Y = 320, 240
local INBOX = false
local boxcolumn = 1
local boxrow = 1
local STARTSAVE = false
local SAVERESULT = 1
local TYPERCHOICING = false
local TYPERRESULT = 1
local TYPERHEART = sprites.CreateSprite("Soul Library Sprites/spr_default_heart.png", 10000)
TYPERHEART.alpha = 0
TYPERHEART.color = {1, 0, 0}
local finalInteractions = {
    currentObject = nil,
    currentId = 0,
    canInteract = false
}
local WARP = {
    warpping = false,
    target = "",
    warptime = 0
}
local boxwhite = sprites.CreateSprite("px.png", 9997)
boxwhite.alpha = 0
boxwhite:Scale(610, 450)
boxwhite:MoveTo(TPos(320, 240))
local boxblack = sprites.CreateSprite("px.png", 9998)
boxblack.alpha = 0
boxblack:Scale(600, 440)
boxblack:MoveTo(TPos(320, 240))
boxblack.color = {0, 0, 0}
local boxline = sprites.CreateSprite("px.png", 9999)
boxline:Scale(3, 300)
boxline.alpha = 0
local boxtitle = typers.DrawText("", {0, 0}, 10000)
local boxtexts = {
    inventory = {},
    box = {}
}
for i = 1, 8 do
    boxtexts.inventory[i] = typers.DrawText("", {0, 0}, 10000)
end
for i = 1, 10 do
    boxtexts.box[i] = typers.DrawText("", {0, 0}, 10000)
end

local main_typer
local block = {}
local w, h, x, dy = 580, 140, 320, 160
block.white = sprites.CreateSprite("px.png", 9997)
block.black = sprites.CreateSprite("px.png", 9998)
block.black.color = {0, 0, 0}
block.white:Scale(w + 10, h + 10)
block.black:Scale(w, h)
block.white:MoveTo(TPos(x, 240 + dy))
block.black:MoveTo(TPos(x, 240 + dy))
block.white.alpha = 0
block.black.alpha = 0

local saveb = {}
saveb.white = sprites.CreateSprite("px.png", 9997)
saveb.black = sprites.CreateSprite("px.png", 9998)
saveb.black.color = {0, 0, 0}
saveb.white:Scale(412 + 10, 162 + 10)
saveb.black:Scale(412, 162)
saveb.white:MoveTo(TPos(x, 240 + dy))
saveb.black:MoveTo(TPos(x, 240 + dy))
saveb.white.alpha = 0
saveb.black.alpha = 0
saveb.info = typers.DrawText("", {0, 0}, 10000)
saveb.room = typers.DrawText("", {0, 0}, 10000)
saveb.choe = typers.DrawText("", {0, 0}, 10000)

-- Physics world setup
local world = love.physics.newWorld(0, 0, true)

-- Game objects
local objects = {
    marks = {},
    chests = {},
    warps = {},
    walls = {},
    signs = {},
    saves = {},
    texts = {}
}
local ENCOUNTER = false
local ENCTIME = 0
local enc_animtime = 0

-- Player configuration
local exc = sprites.CreateSprite("Overworld/spr_exc.png", 12000)
exc:Scale(2, 2)
if (DATA.player.lv >= 10) then
    exc:Set("Overworld/spr_exc_f.png")
end
exc.alpha = 0

local player = {
    sprites = {
        up = {
            "Overworld/Frisk/spr_f_maincharau_0.png",
            "Overworld/Frisk/spr_f_maincharau_1.png",
            "Overworld/Frisk/spr_f_maincharau_2.png",
            "Overworld/Frisk/spr_f_maincharau_3.png",
        },
        down = {
            "Overworld/Frisk/spr_f_maincharad_0.png",
            "Overworld/Frisk/spr_f_maincharad_1.png",
            "Overworld/Frisk/spr_f_maincharad_2.png",
            "Overworld/Frisk/spr_f_maincharad_3.png",
        },
        left = {
            "Overworld/Frisk/spr_f_maincharal_0.png",
            "Overworld/Frisk/spr_f_maincharal_1.png",
            "Overworld/Frisk/spr_f_maincharal_0.png",
            "Overworld/Frisk/spr_f_maincharal_1.png",
        },
        right = {
            "Overworld/Frisk/spr_f_maincharar_0.png",
            "Overworld/Frisk/spr_f_maincharar_1.png",
            "Overworld/Frisk/spr_f_maincharar_0.png",
            "Overworld/Frisk/spr_f_maincharar_1.png",
        }
    },
    currentSprite = nil,
    direction = "right",
    animationFrame = 1,
    animationTime = 0,
    collision = {
        body = nil,
        shape = nil,
        fixture = nil
    }
}

-- Map configuration
local map = {
    instance = nil,
    x = 0,
    y = 0
}

-- Load map and initialize objects
local function initializeMap()
    global:SetVariable("ROOM", "scene_ow_ruins_0")
    map.instance = sti("Maps/ruins_0.lua", {"box2d"})
    map.instance.draw_objects = false
    map.instance:box2d_init(world)

    for _, layer in ipairs(map.instance.layers) do
        if (layer.name == "marks") then
            for _, obj in ipairs(layer.objects) do
                table.insert(objects.marks, {
                    x = obj.x,
                    y = obj.y,
                    direction = obj.properties.direction or "right",
                    id = obj.properties.id or 0
                })
            end
        elseif (layer.name == "chests") then
            for _, obj in ipairs(layer.objects) do

                local sprite = sprites.CreateSprite("Scene/Everywhere/spr_chestbox_0.png", 2000 + (obj.y + obj.height/2 + 120) * SCALE_FACTOR)
                sprite:MoveTo(
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 120) * SCALE_FACTOR
                )
                sprite:Scale(2, 2)
                local id = obj.properties.id or (#objects.chests + 1)
                table.insert(objects.chests, {
                    id = id,
                    give = (obj.properties.give or false)
                })

                local body = love.physics.newBody(world,
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                    "static")
                local shape = love.physics.newRectangleShape(
                    sprite.width * SCALE_FACTOR,
                    sprite.height / 2 * SCALE_FACTOR)
                local fixture = love.physics.newFixture(body, shape, 1)
                fixture:setUserData({type = "chest", object = obj, id = id})
            end
        elseif (layer.name == "warps") then
            for _, obj in ipairs(layer.objects) do
                local body = love.physics.newBody(world,
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                    "static")
                local shape = love.physics.newRectangleShape(
                    obj.width * SCALE_FACTOR,
                    obj.height / 2 * SCALE_FACTOR)
                local fixture = love.physics.newFixture(body, shape, 1)
                fixture:setUserData({type = "warp", object = obj})
                fixture:setSensor(true)

                table.insert(objects.warps, {
                    target = obj.properties.target
                })
            end
        elseif (layer.name == "walls") then
            for _, obj in ipairs(layer.objects) do
                local body = love.physics.newBody(world,
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 120) * SCALE_FACTOR,
                    "static")
                local shape = love.physics.newRectangleShape(
                    obj.width * SCALE_FACTOR,
                    obj.height * SCALE_FACTOR)
                local fixture = love.physics.newFixture(body, shape, 1)
                fixture:setUserData({type = "wall", object = obj})
            end
        elseif (layer.name == "signs") then
            for _, obj in ipairs(layer.objects) do
                local sprite = sprites.CreateSprite("Scene/Everywhere/spr_sign.png", 2000 + (obj.y + obj.height/2 + 120) * SCALE_FACTOR)
                sprite:MoveTo(
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 120) * SCALE_FACTOR
                )
                sprite:Scale(2, 2)
                local id = (obj.properties.id or #objects.signs + 1)
                table.insert(objects.signs, {
                    id = id,
                    triggered = 0
                })

                local body = love.physics.newBody(world,
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                    "static")
                local shape = love.physics.newRectangleShape(
                    sprite.width * SCALE_FACTOR,
                    sprite.height / 2 * SCALE_FACTOR)
                local fixture = love.physics.newFixture(body, shape, 1)
                fixture:setUserData({type = "sign", object = obj, id = id})
            end
        elseif (layer.name == "saves") then
            for _, obj in ipairs(layer.objects) do
                local sprite = sprites.CreateSprite("Scene/Everywhere/spr_savepoint_0.png", 2000 + (obj.y + obj.height/2 + 120) * SCALE_FACTOR)
                sprite:SetAnimation({
                    "Scene/Everywhere/spr_savepoint_1.png",
                    "Scene/Everywhere/spr_savepoint_0.png"
                }, 15)
                sprite:MoveTo(
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 120) * SCALE_FACTOR
                )
                sprite:Scale(2, 2)
                local id = (obj.properties.id or #objects.signs + 1)
                table.insert(objects.saves, {
                    id = id,
                    room = obj.properties.room,
                    triggered = 0,
                    position = {obj.properties.x, obj.properties.y}
                })

                local body = love.physics.newBody(world,
                    (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                    (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                    "static")
                local shape = love.physics.newRectangleShape(
                    sprite.width * SCALE_FACTOR,
                    sprite.height / 2 * SCALE_FACTOR)
                local fixture = love.physics.newFixture(body, shape, 1)
                fixture:setUserData({type = "save", object = obj, id = id})
            end
        elseif (layer.name == "texts") then
            for _, obj in ipairs(layer.objects) do
                local id = (obj.properties.id or #objects.signs + 1)
                table.insert(objects.texts, {
                    id = id
                })
                if (id == 1) then
                    if (not FLAG.ruins_0.text_inst) then
                        local body = love.physics.newBody(world,
                            (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                            (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                            "static")
                        local shape = love.physics.newRectangleShape(
                            obj.width * SCALE_FACTOR,
                            obj.height / 2 * SCALE_FACTOR)
                        local fixture = love.physics.newFixture(body, shape, 1)
                        fixture:setSensor(true)
                        fixture:setUserData({type = "text", object = obj, id = id})
                    end
                else
                    local body = love.physics.newBody(world,
                        (obj.x + obj.width/2 + 160) * SCALE_FACTOR,
                        (obj.y + obj.height/2 + 125) * SCALE_FACTOR,
                        "static")
                    local shape = love.physics.newRectangleShape(
                        obj.width * SCALE_FACTOR,
                        obj.height / 2 * SCALE_FACTOR)
                    local fixture = love.physics.newFixture(body, shape, 1)
                    fixture:setSensor(true)
                    fixture:setUserData({type = "text", object = obj, id = id})
                end
            end
        end
    end
end

local function findMarker(id)
    local res = 0
    for k, mark in pairs(objects.marks) do
        if mark.id == tonumber(id) then
            res = k
            break
        end
    end
    return res
end

function typer_makechoice()
    TYPERCHOICING = true
    TYPERRESULT = 1
    TYPERHEART.alpha = 1
    TYPERHEART.y = block.black.y + 30
end

-- Initialize player
local function initializePlayer()
    local startMark = objects.marks[findMarker(DATA.marker)]
    player.direction = startMark.direction
    local sx, sy = startMark.x, startMark.y

    if (DATA.savedpos) then
        sx, sy = unpack(DATA.position)
        player.direction = DATA.direction
    end

    player.currentSprite = sprites.CreateSprite(
        player.sprites[player.direction][1],
        1
    )
    player.currentSprite:Scale(SCALE_FACTOR, SCALE_FACTOR)

    -- Player collision setup
    player.collision.body = love.physics.newBody(
        world,
        sx * 2 + 320,
        sy * 2 + 240,
        "dynamic"
    )
    player.collision.shape = love.physics.newRectangleShape(40, 20)
    player.collision.fixture = love.physics.newFixture(
        player.collision.body,
        player.collision.shape,
        1
    )

    player.collision.body:setFixedRotation(true)
    player.collision.fixture:setRestitution(0)
    player.collision.fixture:setFriction(0.1)
    player.collision.fixture:setUserData({type = "player"})
end

function startSave(id)
    STARTSAVE = true
    block.white.alpha = 0
    block.black.alpha = 0
    saveb.white.alpha = 1
    saveb.black.alpha = 1
    TYPERHEART.alpha = 1

    saveb.white:MoveTo(TPos(320, 200))
    saveb.black:MoveTo(TPos(320, 200))
    TYPERHEART:MoveTo(TPos(150, 255))

    saveb.info.x, saveb.info.y = TPos(140, 135)
    local tm = global:GetSaveVariable("Overworld")
    local minutes = math.floor(tm.time / 60)
    local seconds = math.floor(tm.time % 60)
    saveb.info:SetText(string.format("Chara    LV " .. DATA.player.lv .. "    %02d:%02d", minutes, seconds))
    saveb.info:Reparse()

    saveb.room.x, saveb.room.y = TPos(120, 180)
    for _, save in ipairs(objects.saves)
    do
        if (save.id == id) then
            saveb.room:SetText("[preset=chinese][offsetX=20]" .. DATA.room_name)
        end
    end
    saveb.room:Reparse()

    saveb.choe.x, saveb.choe.y = TPos(145, 235)
    saveb.choe:SetText("[preset=chinese][offsetX=20]保存       返回")
    saveb.choe:Reparse()
end

function resetPlayer()
    stat.interact = 0
    block.white.alpha = 0
    block.black.alpha = 0

    finalInteractions.canInteract = true
end

-- Physics collision callback
local function beginContact(a, b, coll)
    local fixtureA, fixtureB = a, b
    local dataA = fixtureA:getUserData()
    local dataB = fixtureB:getUserData()

    if (dataA and dataA.type == "player" and dataB and dataB.type == "wall") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "wall") then
        if DEBUG_MODE then
            print("Player collided with wall")
        end
    end
    if (dataA and dataA.type == "player" and dataB and dataB.type == "chest") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "chest") then
        finalInteractions.canInteract = true
        finalInteractions.currentObject = "chest"
        if (dataA.type == "chest") then finalInteractions.currentId = dataA.id end
        if (dataB.type == "chest") then finalInteractions.currentId = dataB.id end
        if DEBUG_MODE then
            print("Player collided with CHEST")
            print(dataA.id or dataB.id)
        end
    end
    if (dataA and dataA.type == "player" and dataB and dataB.type == "sign") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "sign") then
        finalInteractions.currentObject = "sign"
        finalInteractions.canInteract = true
        if (dataA.type == "sign") then finalInteractions.currentId = dataA.id end
        if (dataB.type == "sign") then finalInteractions.currentId = dataB.id end
        if DEBUG_MODE then
            print("Player collided with sign")
            print(dataA.id or dataB.id)
        end
    end
    if (dataA and dataA.type == "player" and dataB and dataB.type == "warp") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "warp") then
        finalInteractions.currentObject = "warp"
        finalInteractions.canInteract = true
        if (dataA.type == "warp") then finalInteractions.currentId = dataA.id end
        if (dataB.type == "warp") then finalInteractions.currentId = dataB.id end
        if DEBUG_MODE then
            print("Player collided with warp")
        end
    end
    if (dataA and dataA.type == "player" and dataB and dataB.type == "save") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "save") then
        finalInteractions.currentObject = "save"
        finalInteractions.canInteract = true
        if (dataA.type == "save") then finalInteractions.currentId = dataA.id end
        if (dataB.type == "save") then finalInteractions.currentId = dataB.id end
        if DEBUG_MODE then
            print("Player collided with save")
            print(dataA.id or dataB.id)
        end
    end
    if (dataA and dataA.type == "player" and dataB and dataB.type == "text") or
       (dataB and dataB.type == "player" and dataA and dataA.type == "text") then
        finalInteractions.currentObject = "text"
        finalInteractions.canInteract = true
        if (dataA.type == "text") then finalInteractions.currentId = dataA.id end
        if (dataB.type == "text") then finalInteractions.currentId = dataB.id end
        if DEBUG_MODE then
            print("Player collided with text")
            print(dataA.id or dataB.id)
        end
    end
end

local function endContact(a, b, coll)
    local dataA = (a:getUserData() or {})
    local dataB = (b:getUserData() or {})

    -- 玩家离开牌子
    if (dataA.type == "player" and dataB.type == "sign") or
       (dataB.type == "player" and dataA.type == "sign") then
        finalInteractions.currentId = 0
        finalInteractions.currentObject = nil
        finalInteractions.canInteract = false
    end
    if (dataA.type == "player" and dataB.type == "chest") or
       (dataB.type == "player" and dataA.type == "chest") then
        finalInteractions.currentId = 0
        finalInteractions.currentObject = nil
        finalInteractions.canInteract = false
    end
    if (dataA.type == "player" and dataB.type == "save") or
       (dataB.type == "player" and dataA.type == "save") then
        finalInteractions.currentId = 0
        finalInteractions.currentObject = nil
        finalInteractions.canInteract = false
    end
    if (dataA.type == "player" and dataB.type == "text") or
       (dataB.type == "player" and dataA.type == "text") then
        finalInteractions.currentId = 0
        finalInteractions.currentObject = nil
        finalInteractions.canInteract = false
    end
end

-- Debug drawing for physics fixtures
local function drawFixture(fixture)
    if not fixture or not fixture:getShape() then return end

    local shape = fixture:getShape()
    local body = fixture:getBody()
    local shapeType = shape:getType()

    -- Draw fill
    love.graphics.setColor(1, 0, 0, 0.3)

    if shapeType == "polygon" then
        love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
    elseif shapeType == "circle" then
        love.graphics.circle("fill", body:getX(), body:getY(), shape:getRadius())
    elseif shapeType == "rectangle" then
        love.graphics.rectangle("fill",
            body:getX() - shape:getWidth()/2,
            body:getY() - shape:getHeight()/2,
            shape:getWidth(),
            shape:getHeight())
    else
        love.graphics.circle("fill", body:getX(), body:getY(), 5)
    end

    -- Draw outline
    love.graphics.setColor(1, 0.5, 0, 0.8)
    love.graphics.setLineWidth(2)

    if shapeType == "polygon" then
        love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
    elseif shapeType == "circle" then
        love.graphics.circle("line", body:getX(), body:getY(), shape:getRadius())
    elseif shapeType == "rectangle" then
        love.graphics.rectangle("line",
            body:getX() + shape:getWidth()/2,
            body:getY() - shape:getHeight()/2,
            shape:getWidth(),
            shape:getHeight())
    end

    love.graphics.setLineWidth(1)
end

-- Scene functions
function SCENE.load()
    initializeMap()
    initializePlayer()
    world:setCallbacks(beginContact, endContact)

    if DEBUG_MODE then
        for _, mark in ipairs(objects.marks) do
            print(string.format(
                "Mark ID: %d, Position: (%d, %d), Direction: %s",
                mark.id, mark.x, mark.y, mark.direction
            ))
        end
    end
end

function SCENE.update(dt)
    world:update(1/60)
    print(player.currentSprite.x, player.currentSprite.y)

    if (WARPSCREEN and stat.interact ~= 100) then
        WARPSCREEN.alpha = WARPSCREEN.alpha - 0.05
        WARPSCREEN:MoveTo(TPos(320, 240))
    end

    -- Update player position from physics body
    if (player.collision.body) then
        player.currentSprite.x = player.collision.body:getX()
        player.currentSprite.y = player.collision.body:getY() - 20
    end

    stat.under = (player.currentSprite.y - _CAMERA_.y) > 300
    DATA.time = DATA.time + dt

    if (stat.interact ~= 100) then
        _CAMERA_:setPosition(
            player.currentSprite.x - SCREEN_CENTER_X,
            player.currentSprite.y - SCREEN_CENTER_Y
        )
    end
    stat:Update(dt)

    if (map) then
        -- Update map position to follow player
        map.x = SCREEN_CENTER_X - player.currentSprite.x / 2
        map.y = SCREEN_CENTER_Y - player.currentSprite.y / 2
    end

    if (encounter.encountered or encounter.nobodycame) then
        stat.interact = 100
        enc_animtime = enc_animtime + 1
        if (enc_animtime == 1) then
            DATA.savedpos = true
            DATA.position = {
                (player.currentSprite.x - 320) / 2,
                (player.currentSprite.y - 220) / 2
            }
            DATA.direction = player.direction
            player.animationFrame = 1
            player.collision.body:setLinearVelocity(0, 0)
            exc:MoveTo(
                player.currentSprite.x,
                player.currentSprite.y - 40
            )
            WARPSCREEN:MoveTo(
                player.currentSprite.x,
                player.currentSprite.y
            )
            TYPERHEART:MoveTo(
                player.currentSprite.x,
                player.currentSprite.y
            )
            TYPERHEART.layer = 9999999
            exc.alpha = 1
        elseif (enc_animtime >= 60 and enc_animtime <= 90) then
            exc.alpha = 0
            if (enc_animtime % 5 == 0) then
                TYPERHEART.alpha = 1 - TYPERHEART.alpha
                WARPSCREEN.alpha = 1 - WARPSCREEN.alpha
                if (TYPERHEART.alpha == 0) then
                    audio.PlaySound("snd_tong.wav")
                end
            end
        end
        if (enc_animtime == 90) then
            tween.CreateTween(
                function (value)
                    TYPERHEART.x = value
                end,
                "linear", "", TYPERHEART.x, _CAMERA_.x + 87 - 39, 30
            )
            tween.CreateTween(
                function (value)
                    TYPERHEART.y = value
                end,
                "linear", "", TYPERHEART.y, _CAMERA_.y + 453, 30
            )
        end
        if (enc_animtime == 90 + 31) then
            scenes.switchTo("scene_battle_ow")
        end
    end

    if stat.interact == 0 then
        local vx, vy = 0, 0

        -- Handle input
        if (stat.interact == 0) then
            if keyboard.GetState("up") >= 1 then
                vy = -PLAYER_SPEED
                player.direction = "up"
            elseif keyboard.GetState("down") >= 1 then
                vy = PLAYER_SPEED
                player.direction = "down"
            end

            if keyboard.GetState("left") >= 1 then
                vx = -PLAYER_SPEED
                player.direction = "left"
            elseif keyboard.GetState("right") >= 1 then
                vx = PLAYER_SPEED
                player.direction = "right"
            end
        end

        player.collision.body:setLinearVelocity(vx, vy)

        -- Handle animation
        if vx ~= 0 or vy ~= 0 then
            player.animationTime = player.animationTime + dt
            if player.animationTime >= ANIMATION_FRAME_TIME then
                player.animationFrame = player.animationFrame % #player.sprites[player.direction] + 1
                player.animationTime = 0
            end
        else
            player.animationFrame = 1
        end

        if (finalInteractions.canInteract) then
            if (finalInteractions.currentObject ~= "warp") then
                if (finalInteractions.currentObject == "text") then
                    for _, text in ipairs(objects.texts)
                    do
                        if (finalInteractions.currentId == 1 and text.id == 1) then
                            if (not FLAG.ruins_0.text_inst) then
                                FLAG.ruins_0.text_inst = true
                                if (not stat.under) then dy = -150 end
                                if (stat.under) then dy = 150 end
                                block.white:MoveTo(TPos(x, 240 + dy))
                                block.black:MoveTo(TPos(x, 240 + dy))
                                main_typer = typers.CreateText({
                                    "* [fontIndex:2][pattern:chinese]你要出界了。",
                                    "[noskip][function:resetPlayer][next]"
                                }, {TPos(50, 240 + dy - 55)}, 9999, {0, 0}, "manual")
                                block.white.alpha = 1
                                block.black.alpha = 1
                                finalInteractions.canInteract = false
                                stat.interact = 2
                            end
                        end
                    end
                end
                if (keyboard.GetState("confirm") == 1) then
                    if (finalInteractions.currentObject == "sign") then -- 关于牌子的处理
                        if (not stat.under) then dy = -150 end
                        if (stat.under) then dy = 150 end
                        block.white:MoveTo(TPos(x, 240 + dy))
                        block.black:MoveTo(TPos(x, 240 + dy))
                        main_typer = typers.CreateText("", {TPos(50, 240 + dy - 55)}, 9999, {0, 0}, "manual")
                        block.white.alpha = 1
                        block.black.alpha = 1
                        finalInteractions.canInteract = false
                        stat.interact = 2

                        local id = finalInteractions.currentId
                        for _, sign in ipairs(objects.signs) do
                            if (sign.id == 1 and id == 1) then
                                sign.triggered = sign.triggered + 1
                                if (sign.triggered == 1) then
                                    main_typer:SetText({
                                        "* [pattern:chinese][fontIndex:2]哦！[pattern:english][fontIndex:1][space:2, 5] \n* [pattern:chinese][fontIndex:2]你是新来的吗？",
                                        "* [pattern:chinese][fontIndex:2]快过来。[pattern:english][fontIndex:1][space:2, 5] \n* [pattern:chinese][fontIndex:2]坐下跟我聊聊吧。",
                                        "[noskip][function:resetPlayer][next]"
                                    })
                                elseif (sign.triggered == 2) then
                                    main_typer:SetText({
                                        "* [pattern:chinese][fontIndex:2]哦！[pattern:english][fontIndex:1][space:2, 5] \n* [pattern:chinese][fontIndex:2]你这是第二次跟我说话了哦。",
                                        "* [pattern:chinese][fontIndex:2]乖。[pattern:english][fontIndex:1][space:2, 5] \n* [pattern:chinese][fontIndex:2]坐下跟我聊聊吧。",
                                        "[noskip][function:resetPlayer][next]"
                                    })
                                else
                                    main_typer:SetText({"* ......", "[noskip][function:resetPlayer][next]"})
                                end
                                break
                            end
                        end
                    elseif (finalInteractions.currentObject == "chest") then -- 关于箱子的处理
                        if (not stat.under) then dy = -150 end
                        if (stat.under) then dy = 150 end
                        block.white:MoveTo(TPos(x, 240 + dy))
                        block.black:MoveTo(TPos(x, 240 + dy))
                        main_typer = typers.CreateText("", {TPos(50, 240 + dy - 55)}, 9999, {0, 0}, "manual")
                        block.white.alpha = 1
                        block.black.alpha = 1
                        finalInteractions.canInteract = false
                        stat.interact = 2

                        local id = finalInteractions.currentId
                        for _, chest in ipairs(objects.chests) do
                            if (chest.id == 1 and id == 1) then
                                if (chest.give and not FLAG.ruins_0.donut_chest) then
                                    main_typer:SetText({
                                        "* [fontIndex:2][pattern:chinese]箱子里有一个甜甜圈。[fontIndex:1][pattern:english]",
                                        "[noskip][fontIndex:2][pattern:chinese]（拿走它吗？）\n\n          拿                     不拿[function:typer_makechoice]",
                                        "[noskip][function:resetPlayer][next]"
                                    })
                                else
                                    main_typer:SetText({
                                        "* [fontIndex:2][pattern:chinese]箱子是空的。[fontIndex:1][pattern:english]",
                                        "[noskip][function:resetPlayer][next]"
                                    })
                                end
                            elseif (chest.id == 2 and id == 2) then
                                main_typer:SetText({
                                    "* [fontIndex:2][pattern:chinese]（使用箱子？）\n\n             是                      否[function:typer_makechoice]",
                                    "[noskip][function:resetPlayer][next]"
                                })
                            end
                        end
                    elseif (finalInteractions.currentObject == "save") then
                        audio.PlaySound("snd_heal.wav")
                        DATA.player.hp = DATA.player.maxhp
                        if (not stat.under) then dy = -150 end
                        if (stat.under) then dy = 150 end
                        block.white:MoveTo(TPos(x, 240 + dy))
                        block.black:MoveTo(TPos(x, 240 + dy))
                        main_typer = typers.CreateText("", {TPos(50, 240 + dy - 55)}, 9999, {0, 0}, "manual")
                        block.white.alpha = 1
                        block.black.alpha = 1
                        finalInteractions.canInteract = false
                        stat.interact = 2

                        local id = finalInteractions.currentId
                        for _, save in ipairs(objects.saves) do
                            if (save.id == 1 and id == 1) then
                                save.triggered = save.triggered + 1
                                --[[if (save.triggered == 1) then
                                    main_typer:SetText({
                                        "* [pattern:chinese][fontIndex:2]你摸到了这个房间的第一个存档点。",
                                        "* [pattern:chinese][fontIndex:2]这使你充满了决心。",
                                        "[noskip][function:startSave|" .. id .. "][next]"
                                    })
                                elseif (save.triggered >= 2) then
                                    main_typer:SetText({
                                        "* [pattern:chinese][fontIndex:2]出于好奇，你又摸了一次。",
                                        "* [pattern:chinese][fontIndex:2]这又一次使你充满了决心。",
                                        "[noskip][function:startSave|" .. id .. "][next]"
                                    })
                                end]]

                                if (3 - FLAG.ruins_killed > 0) then
                                    main_typer:SetText({
                                        "[colorHEX:ff0000]* [pattern:chinese][fontIndex:2]还剩[pattern:english][fontIndex:1] " .. 3 - FLAG.ruins_killed ..  " [pattern:chinese][fontIndex:2]个。",
                                        "[noskip][function:startSave|" .. id .. "][next]"
                                    })
                                else
                                    main_typer:SetText({
                                        "[colorHEX:ff0000]* [pattern:chinese][fontIndex:2]决心。",
                                        "[noskip][function:startSave|" .. id .. "][next]"
                                    })
                                end

                            elseif (save.id == 2 and id == 2) then
                                save.triggered = save.triggered + 1
                                if (save.triggered >= 1) then
                                    main_typer:SetText({
                                        "* [pattern:chinese][fontIndex:2]你摸到了这个房间之外的存档点。",
                                        "* [pattern:chinese][fontIndex:2]这使你充满了决心。",
                                        "[noskip][function:startSave|" .. id .. "][next]"
                                    })
                                end
                            end
                        end
                    elseif (finalInteractions.currentObject == "text") then
                        if (not stat.under) then dy = -150 end
                        if (stat.under) then dy = 150 end
                        block.white:MoveTo(TPos(x, 240 + dy))
                        block.black:MoveTo(TPos(x, 240 + dy))
                        main_typer = typers.CreateText("", {TPos(50, 240 + dy - 55)}, 9999, {0, 0}, "manual")
                        block.white.alpha = 1
                        block.black.alpha = 1
                        finalInteractions.canInteract = false
                        stat.interact = 2

                        local id = finalInteractions.currentId
                        for _, text in ipairs(objects.texts) do
                            if (text.id == id and text.id == 2) then
                                main_typer:SetText({
                                    "* [pattern:chinese][fontIndex:2]你看到了一个牌子。",
                                    "[noskip][function:resetPlayer][next]"
                                })
                                break
                            end
                        end
                    end
                end
            else
                print(finalInteractions.currentObject)
                if (finalInteractions.currentObject == "warp") then -- 如果碰到了传送类型的
                    WARP.warpping = true
                    stat.interact = 3
                    WARPSCREEN:MoveTo(TPos(320, 240))
                    --scenes.switchTo("scene_battle") 
                end
            end
        end

        if (player.lastX == nil or player.lastY == nil) then
            player.lastX = player.collision.body:getX()
            player.lastY = player.collision.body:getY()
        end

        local px, py = player.collision.body:getX(), player.collision.body:getY()
        local moved = (math.abs(px - player.lastX) > 0.1) or (math.abs(py - player.lastY) > 0.1)
        if (moved) then
            player.lastX = px
            player.lastY = py
            encounter.Update()
        end
    else
        player.animationFrame = 1
        if (stat.interact ~= 100) then
            player.collision.body:setLinearVelocity(0, 0)
        end

        if (stat.interact == 3) then
            if (WARP.warpping) then
                WARP.warptime = WARP.warptime + 1
                WARPSCREEN.alpha = WARPSCREEN.alpha + 0.1
                if (WARP.warptime == 30) then
                    for _, warp in ipairs(objects.warps) do
                        if (warp.target) then
                            scenes.switchTo(warp.target)
                            break
                        end
                    end
                    -- scenes.switchTo()
                end
            end
        end
    end

    player.currentSprite:Set(player.sprites[player.direction][player.animationFrame])
    player.currentSprite.layer = 2000 + player.currentSprite.y

    if (INBOX) then
        stat.interact = 4
        if (keyboard.GetState("up") == 1) then
            boxrow = math.max(boxrow - 1, 1)
        elseif (keyboard.GetState("down") == 1) then
            if (boxcolumn == 1) then
                boxrow = math.min(boxrow + 1, #DATA.player.items)
                boxrow = math.max(boxrow, 1)
            else
                boxrow = math.min(boxrow + 1, #CHESTS.chest1)
                boxrow = math.max(boxrow, 1)
            end
        end
        if (keyboard.GetState("left") == 1) then
            boxcolumn = 1
            boxrow = math.min(boxrow, #DATA.player.items)
            boxrow = math.max(boxrow, 1)
        elseif (keyboard.GetState("right") == 1) then
            boxcolumn = 2
            boxrow = math.min(boxrow, #CHESTS.chest1)
            boxrow = math.max(boxrow, 1)
        end

        if (keyboard.GetState("confirm") == 1) then
            if (boxcolumn == 1) then
                if (boxrow <= #DATA.player.items and #CHESTS.chest1 < 10) then
                    local item = DATA.player.items[boxrow]
                    table.insert(CHESTS.chest1, item)
                    table.remove(DATA.player.items, boxrow)
                    if (item ~= "[preset=chinese][red]蜘蛛") then
                        for i = 1, 8 do
                            if (i <= #DATA.player.items) then
                                boxtexts.inventory[i]:SetText(
                                    DATA.player.items[i]
                                )
                            else
                                boxtexts.inventory[i]:SetText("")
                            end
                        end
                        for i = 1, 10 do
                            if (i <= #CHESTS.chest1) then
                                boxtexts.box[i]:SetText(
                                    CHESTS.chest1[i]
                                )
                            else
                                boxtexts.box[i]:SetText("")
                            end
                        end
                    else
                        spidermoving = true
                        keyboard.AllowPlayerInput(false)
                    end
                end
            elseif (boxcolumn == 2) then
                if (boxrow <= #CHESTS.chest1 and #DATA.player.items < 8) then
                    local item = CHESTS.chest1[boxrow]
                    table.insert(DATA.player.items, item)
                    table.remove(CHESTS.chest1, boxrow)
                    if (item ~= "[preset=chinese][red]蜘蛛") then
                        for i = 1, 8 do
                            if (i <= #DATA.player.items) then
                                boxtexts.inventory[i]:SetText(
                                    DATA.player.items[i]
                                )
                            else
                                boxtexts.inventory[i]:SetText("")
                            end
                        end
                        for i = 1, 10 do
                            if (i <= #CHESTS.chest1) then
                                boxtexts.box[i]:SetText(
                                    CHESTS.chest1[i]
                                )
                            else
                                boxtexts.box[i]:SetText("")
                            end
                        end
                    else
                        spidermoving = true
                        keyboard.AllowPlayerInput(false)
                    end
                end
            end
        end

        TYPERHEART:MoveTo(
            TPos(
                50 + 300 * (boxcolumn - 1),
                98 + 35 * (boxrow - 1)
            )
        )

        if (keyboard.GetState("cancel") == 1) then
            stat.interact = 0
            INBOX = false
            boxblack.alpha = 0
            boxwhite.alpha = 0
            boxline.alpha = 0
            boxrow = 1
            boxcolumn = 1
            TYPERHEART.alpha = 0

            for i = 1, #boxtexts.inventory do
                boxtexts.inventory[i]:SetText("")
            end
            boxtitle:SetText("")
            for  i = 1, #boxtexts.box do
                boxtexts.box[i]:SetText("")
            end
        end
    end

    if (spidermoving) then
        spidertime = spidertime + 1
        local typer
        if (boxcolumn == 2) then
            typer = boxtexts.box[boxrow]
            if (spidertime == 1) then
                local tx, ty = TPos(280, 0)
                tween.CreateTween(
                    function (value)
                        typer.x = value
                    end,
                    "Quad", "In", typer.x, tx, 60
                )
            elseif (spidertime == 90) then
                local tx, ty = TPos(0, 80 + 35 * (#DATA.player.items - 1))
                tween.CreateTween(
                    function (value)
                        typer.y = value
                    end,
                    "Back", "InOut", typer.y, ty, 150
                )
            elseif (spidertime == 240) then
                local tx, ty = TPos(90, 0)
                tween.CreateTween(
                    function (value)
                        typer.x = value
                    end,
                    "Quad", "In", typer.x, tx, 60
                )
            elseif (spidertime == 320) then
                boxtexts.inventory[#DATA.player.items]:SetText(
                    "[preset=chinese][red]蜘蛛"
                )

                for i = 1, 8 do
                    if (i <= #DATA.player.items) then
                        boxtexts.inventory[i]:SetText(
                            DATA.player.items[i]
                        )
                    else
                        boxtexts.inventory[i]:SetText("")
                    end
                    local x, y = TPos(90, 80 + 35 * (i - 1))
                    boxtexts.inventory[i].x = x
                    boxtexts.inventory[i].y = y
                end
                for i = 1, 10
                do
                    if (i <= #CHESTS.chest1) then
                        boxtexts.box[i]:SetText(
                            CHESTS.chest1[i]
                        )
                    else
                        boxtexts.box[i]:SetText("")
                    end
                    local x, y = TPos(390, 80 + 35 * (i - 1))
                    boxtexts.box[i].x = x
                    boxtexts.box[i].y = y
                end

                spidermoving = false
                keyboard.AllowPlayerInput(true)
                spidertime = 0
            end
        else
            typer = boxtexts.inventory[boxrow]
            if (spidertime == 1) then
                local tx, ty = TPos(280, 0)
                tween.CreateTween(
                    function (value)
                        typer.x = value
                    end,
                    "Quad", "In", typer.x, tx, 60
                )
            elseif (spidertime == 90) then
                local tx, ty = TPos(0, 80 + 35 * (#CHESTS.chest1 - 1))
                tween.CreateTween(
                    function (value)
                        typer.y = value
                    end,
                    "Back", "InOut", typer.y, ty, 150
                )
            elseif (spidertime == 240) then
                local tx, ty = TPos(390, 0)
                tween.CreateTween(
                    function (value)
                        typer.x = value
                    end,
                    "Quad", "In", typer.x, tx, 60
                )
            elseif (spidertime == 320) then
                boxtexts.box[#CHESTS.chest1]:SetText(
                    "[preset=chinese][red]蜘蛛"
                )

                for i = 1, 8 do
                    if (i <= #DATA.player.items) then
                        boxtexts.inventory[i]:SetText(
                            DATA.player.items[i]
                        )
                    else
                        boxtexts.inventory[i]:SetText("")
                    end
                    local x, y = TPos(90, 80 + 35 * (i - 1))
                    boxtexts.inventory[i].x = x
                    boxtexts.inventory[i].y = y
                end
                for i = 1, 10
                do
                    if (i <= #CHESTS.chest1) then
                        boxtexts.box[i]:SetText(
                            CHESTS.chest1[i]
                        )
                    else
                        boxtexts.box[i]:SetText("")
                    end
                    local x, y = TPos(390, 80 + 35 * (i - 1))
                    boxtexts.box[i].x = x
                    boxtexts.box[i].y = y
                end

                spidermoving = false
                keyboard.AllowPlayerInput(true)
                spidertime = 0
            end
        end
    end

    -- 额外逻辑
    for _, chest in ipairs(objects.chests) do
        if (chest.id == 1 and finalInteractions.currentId == 1) then
            if (TYPERCHOICING) then
                if (keyboard.GetState("right") == 1) then
                    TYPERRESULT = 2
                elseif (keyboard.GetState("left") == 1) then
                    TYPERRESULT = 1
                elseif (keyboard.GetState("up") >= 1) then
                    TYPERHEART.y = TYPERHEART.y - 2
                end
                local cx, cy = block.black.x, block.black.y
                TYPERHEART.x = cx - 190 + 220 * (TYPERRESULT - 1)

                if (TYPERHEART.y <= _CAMERA_.y - 8) then
                    TYPERHEART.alpha = 0
                    TYPERCHOICING = false
                    main_typer:SetText({
                        "* [fontIndex:2][pattern:chinese]嘿！[fontIndex:1][pattern:english][space:2, 5] \n* [fontIndex:2][pattern:chinese]给我回来！",
                        "[noskip][function:resetPlayer][next]"
                    })
                end

                if (keyboard.GetState("confirm") == 1) then
                    -- 如果拿了
                    TYPERCHOICING = false
                    TYPERHEART.alpha = 0
                    if (TYPERRESULT == 1) then
                        if (#DATA.player.items < 8) then
                            main_typer:SetText({
                                "[fontIndex:2][pattern:chinese]（你得到了甜甜圈。）",
                                "[noskip][function:resetPlayer][next]"
                            })
                            chest.give = false
                            FLAG.ruins_0.donut_chest = true
                            table.insert(DATA.player.items, "[preset=chinese][offsetX=20]甜甜圈")
                        else
                            main_typer:SetText({
                                "[fontIndex:2][pattern:chinese]（你带的东西太多了。）",
                                "[noskip][function:resetPlayer][next]"
                            })
                        end
                    else
                        -- 如果没拿
                        main_typer:SetText({
                            "* [fontIndex:2][pattern:chinese]你决定先不拿。",
                            "[noskip][function:resetPlayer][next]"
                        })
                    end
                end
            end
        elseif (chest.id == 2 and finalInteractions.currentId == 2) then
            if (TYPERCHOICING) then
                if (keyboard.GetState("right") == 1) then
                    TYPERRESULT = 2
                elseif (keyboard.GetState("left") == 1) then
                    TYPERRESULT = 1
                end
                local cx, cy = block.black.x, block.black.y
                TYPERHEART.x = cx - 160 + 230 * (TYPERRESULT - 1)

                if (keyboard.GetState("confirm") == 1) then
                    TYPERCHOICING = false
                    stat.interact = 4
                    if (TYPERRESULT == 2) then
                        TYPERHEART.alpha = 0
                    else
                        INBOX = true
                        boxblack.alpha = 1
                        boxwhite.alpha = 1
                        boxline.alpha = 1
                        boxblack:MoveTo(TPos(320, 240))
                        boxwhite:MoveTo(TPos(320, 240))
                        boxline:MoveTo(TPos(320, 240))
                        boxtitle:SetText("[preset=chinese][offsetX=20]物品栏              箱子")
                        boxtitle.x, boxtitle.y = TPos(100, 40)
                        for i = 1, 8 do
                            if (i <= #DATA.player.items) then
                                boxtexts.inventory[i]:SetText(
                                    DATA.player.items[i]
                                )
                            else
                                boxtexts.inventory[i]:SetText("")
                            end
                            local x, y = TPos(90, 80 + 35 * (i - 1))
                            boxtexts.inventory[i].x = x
                            boxtexts.inventory[i].y = y
                        end
                        for i = 1, 10
                        do
                            if (i <= #CHESTS.chest1) then
                                boxtexts.box[i]:SetText(
                                    CHESTS.chest1[i]
                                )
                            else
                                boxtexts.box[i]:SetText("")
                            end
                            local x, y = TPos(390, 80 + 35 * (i - 1))
                            boxtexts.box[i].x = x
                            boxtexts.box[i].y = y
                        end
                    end
                end
            end
        end
    end

    if (STARTSAVE) then
        TYPERHEART:MoveTo(TPos(150 + 180 * (SAVERESULT - 1), 255))

        if (keyboard.GetState("left") == 1) then
            SAVERESULT = 1
        elseif (keyboard.GetState("right") == 1) then
            SAVERESULT = 2
        elseif (keyboard.GetState("confirm") == 1) then
            if (SAVERESULT == 1) then
                if (TYPERHEART.alpha ~= 0) then
                    audio.PlaySound("snd_save.wav")
                    TYPERHEART.alpha = 0
                    local minutes = math.floor(DATA.time / 60)
                    local seconds = math.floor(DATA.time % 60)
                    saveb.info:SetText(string.format(DATA.player.name .. "    LV " .. DATA.player.lv .. "    %02d:%02d", minutes, seconds))
                    saveb.info.color = {1, 1, 0}
                    saveb.info:Reparse()
                    local id = finalInteractions.currentId
                    for _, save in ipairs(objects.saves) do
                        if (save.id == id) then
                            DATA.room_name = save.room
                            DATA.position = save.position
                            saveb.room:SetText("[preset=chinese][offsetX=20]" .. save.room)
                        end
                    end
                    saveb.room.color = {1, 1, 0}
                    saveb.room:Reparse()
                    saveb.choe:SetText("[preset=chinese][offsetX=20]保存成功。")
                    saveb.choe.color = {1, 1, 0}
                    saveb.choe:Reparse()
                    DATA.savedpos = true
                    global:SetSaveVariable("Flag", FLAG)
                    global:SetSaveVariable("Chests", CHESTS)
                    global:SetSaveVariable("Overworld", DATA)
                else
                    SAVERESULT = 1
                    STARTSAVE = false
                    saveb.info:SetText("")
                    saveb.room:SetText("")
                    saveb.choe:SetText("")
                    saveb.black.alpha = 0
                    saveb.white.alpha = 0
                    resetPlayer()
                end
            else
                SAVERESULT = 1
                STARTSAVE = false
                TYPERHEART.alpha = 0
                saveb.info:SetText("")
                saveb.room:SetText("")
                saveb.choe:SetText("")
                saveb.black.alpha = 0
                saveb.white.alpha = 0
                resetPlayer()
            end
        end
    end
end

function SCENE.draw()
    -- Draw map
    love.graphics.push()
        map.instance:draw(map.x, map.y, SCALE_FACTOR * scale, SCALE_FACTOR * scale)
    love.graphics.pop()

    -- Debug drawing
    if DEBUG_MODE then
        for _, body in pairs(world:getBodies()) do
            for _, fixture in pairs(body:getFixtures()) do
                drawFixture(fixture)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function SCENE.clear()
    -- Clean up resources
    package.loaded["Scripts.Libraries.Overworld.Stat"] = nil
    package.loaded["Scripts.Libraries.Overworld.EncounterStep"] = nil
    for _, body in ipairs(world:getBodies()) do
        body:destroy()
    end

    -- 2. 释放地图资源
    if map then
        map = nil
    end

    -- 3. 清除玩家物理体
    if char_coll and char_coll.body then
        char_coll.body:destroy()
        char_coll = nil
    end

    world = nil
    layers.clear()
end

return SCENE