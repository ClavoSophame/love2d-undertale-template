local SCENE = {}
SCENE.PRIORITY = false

-- All the libraries are loaded here.
if (not global:GetVariable("EncounterNobody")) then
    battle = require("Scripts.Libraries.Game.EncounterOW")
    battle.nextwave = "wave_test2"
else
    battle = require("Scripts.Libraries.Game.NobodyCame")
    battle.nextwave = "nobodycame"
end
arenas = require("Scripts.Libraries.Attacks.Arenas")
blasters = require("Scripts.Libraries.Attacks.GasterBlaster")
collisions = require("Scripts.Libraries.Collisions")
battle.mainarena = arenas.Init()
battle.mainarena.iscolliding = false
battle.Player.sprite.color = {1, 0, 0}
battle.wave = nil
global:SetVariable("PlayerPosition", {0, 0})
_CAMERA_:setPosition(0, 0)
levelData = {
    { lv = 1,  hp = 20,  at = 10,  df = 10,  nextExp = 10,   totalExp = 0      },
    { lv = 2,  hp = 24,  at = 12,  df = 10,  nextExp = 20,   totalExp = 10     },
    { lv = 3,  hp = 28,  at = 14,  df = 10,  nextExp = 40,   totalExp = 30     },
    { lv = 4,  hp = 32,  at = 16,  df = 10,  nextExp = 50,   totalExp = 70     },
    { lv = 5,  hp = 36,  at = 18,  df = 11,  nextExp = 80,   totalExp = 120    },
    { lv = 6,  hp = 40,  at = 20,  df = 11,  nextExp = 100,  totalExp = 200    },
    { lv = 7,  hp = 44,  at = 22,  df = 11,  nextExp = 200,  totalExp = 300    },
    { lv = 8,  hp = 48,  at = 24,  df = 11,  nextExp = 300,  totalExp = 500    },
    { lv = 9,  hp = 52,  at = 26,  df = 12,  nextExp = 400,  totalExp = 800    },
    { lv = 10, hp = 56,  at = 28,  df = 12,  nextExp = 500,  totalExp = 1200   },
    { lv = 11, hp = 60,  at = 30,  df = 12,  nextExp = 800,  totalExp = 1700   },
    { lv = 12, hp = 64,  at = 32,  df = 12,  nextExp = 1000, totalExp = 2500   },
    { lv = 13, hp = 68,  at = 34,  df = 13,  nextExp = 1500, totalExp = 3500   },
    { lv = 14, hp = 72,  at = 36,  df = 13,  nextExp = 2000, totalExp = 5000   },
    { lv = 15, hp = 76,  at = 38,  df = 13,  nextExp = 3000, totalExp = 7000   },
    { lv = 16, hp = 80,  at = 40,  df = 13,  nextExp = 5000, totalExp = 10000  },
    { lv = 17, hp = 84,  at = 42,  df = 14,  nextExp = 10000,totalExp = 15000  },
    { lv = 18, hp = 88,  at = 44,  df = 14,  nextExp = 25000,totalExp = 25000  },
    { lv = 19, hp = 92,  at = 46,  df = 14,  nextExp = 49999,totalExp = 50000  },
    { lv = 20, hp = 99,  at = 48,  df = 14,  nextExp = nil,  totalExp = 99999  }
}

-- This is where the background UI is loaded.
local encounterTyper = typers.CreateText(battle.EncounterText, {60, 270}, 13, {400, 150}, "none")
local background = sprites.CreateSprite("px.png", -1000)
--background.color = {0.2, 0, 0.5}
background.color = {0, 0, 0}
background:Scale(640, 480)

-- This is where the real UI is loaded.
local UI = {}
UI.Buttons = {}
local fight = sprites.CreateSprite("UI/Battle Screen/spr_fightbt_0.png", 0)
fight:MoveTo(85, 480 - 27)
local act = sprites.CreateSprite("UI/Battle Screen/spr_actbt_center_0.png", 0)
act:MoveTo(240, 480 - 27)
local item = sprites.CreateSprite("UI/Battle Screen/spr_itembt_0.png", 0)
item:MoveTo(400, 480 - 27)
local mercy = sprites.CreateSprite("UI/Battle Screen/spr_sparebt_0.png", 0)
mercy:MoveTo(555, 480 - 27)
table.insert(UI.Buttons, fight)
table.insert(UI.Buttons, act)
table.insert(UI.Buttons, item)
table.insert(UI.Buttons, mercy)

local inButton = 1
local inSelect = 1
local actionSelect = 1
local currentPage = 1

local name = typers.DrawText(battle.Player.name, {30, 400}, 1)
name.font = "Mars Needs Cunnilingus.ttf"
name.fontsize = 24
name:Reparse()

local len, _ = name:GetLettersSize()
local lv = typers.DrawText("Lv[spaceX=0]  " .. battle.Player.lv, {name.x + len + 28, 400}, 1)
lv.font = "Mars Needs Cunnilingus.ttf"
lv.fontsize = 24
lv:Reparse()

local lenlv, _ = lv:GetLettersSize()
local hpname = sprites.CreateSprite("UI/Battle Screen/spr_hpname_0.png", 0)
hpname:MoveTo(math.max(255.5, lv.x + lenlv + 30), 411)
local maxhp = sprites.CreateSprite("px.png", 0)
maxhp:MoveTo(hpname.x + 20, 411)
maxhp.xpivot = 0
maxhp:Scale(maths.Clamp(battle.Player.maxhp * 1.21, 20 * 1.21, 99 * 1.21), 20)
maxhp.color = {1, 0, 0}
local hp = sprites.CreateSprite("px.png", 1)
hp:MoveTo(hpname.x + 20, 411)
hp.xpivot = 0
hp:Scale(maths.Clamp(battle.Player.hp * 1.21, 20 * 1.21, 99 * 1.21), 20)
hp.color = {1, 1, 0}
local hp_text = typers.DrawText(battle.Player.hp .. " / " .. battle.Player.maxhp, {maxhp.x + maxhp.xscale + 15, 400}, 1)
hp_text.font = "Mars Needs Cunnilingus.ttf"
hp_text.fontsize = 24
hp_text:Reparse()

local uiTexts = {}
local uiPoses = {}
local uiElements = {}

local fleeing = false
local fleetime = 0
local fleelegs
local attacking = false
local attacktime = 0

function uiTexts.clear()
    for i = #uiTexts, 1, -1
    do
        if (uiTexts[i].isactive) then
            uiTexts[i]:Destroy()
            for k, v in pairs(layers.objects)
            do
                if (v == uiTexts[i]) then
                    table.remove(layers.objects, k)
                end
            end
            table.remove(uiTexts, i)
        end
    end
end
function uiElements.clear()
    for i = #uiElements, 1, -1
    do
        if (uiElements[i].isactive) then
            uiElements[i]:Destroy()
            for k, v in pairs(layers.objects)
            do
                if (v == uiElements[i]) then
                    table.remove(layers.objects, k)
                end
            end
            table.remove(uiElements, i)
        end
    end
end
function uiPoses.clear()
    for i = #uiPoses, 1, -1
    do
        if (uiPoses[i].isactive) then
            uiPoses[i]:Destroy()
        end
        if (type(uiPoses[i]) == "table") then
            table.remove(uiPoses, i)
        end
    end
end

function SCENE.load()
end

function STATE(sname)
    if (battle) then
        battle.STATE = sname
    end
end

-- This is where the waves are loaded.
local nextwaves = {"wave_test1", "wave_test2", "wave_test3", "wave_test4"}
local waveProgress = 1
local function DefenseEnding()
    print("defense ending")
    waveProgress = waveProgress + 1
    if (waveProgress > #nextwaves) then waveProgress = 1 end
    battle.nextwave = nextwaves[waveProgress]
end

local state_checker = battle.STATE
local function EnteringState(newstate, oldstate)
    if (newstate == "ACTIONSELECT") then
        battle.mainarena:Resize(565, 130)
        battle.mainarena:RotateTo(0)
        battle.mainarena.iscolliding = false
        if (not oldstate == "DEFENDING") then
            encounterTyper:SetText({battle.EncounterText})
        end
        inSelect = 1
        actionSelect = 1
    elseif (newstate == "DEFENDING") then
        encounterTyper:SetText({""})
        inSelect = 1
        actionSelect = 1
    end
end

local function BattleDialogue(texts, targetState)
    local tab, tstate
    if (type(texts) == "string") then
        tab = {texts}
    else
        tab = texts
    end
    if (type(targetState) == "string") then
        tstate = targetState
    else
        tstate = "ACTIONSELECT"
    end
    
    tab[#tab + 1] = "[noskip][function:STATE|" .. tstate .. "][next]"
    typers.CreateText(tab, {60, 270}, 12, {0, 0}, "manual")
end

-- This function is called when the player interacts with an enemy.
local function HandleActions(enemy_name, action)
    if (enemy_name == "Poseur") then
        if (action == "Check") then
            BattleDialogue({
                "* Poseur - 1 ATK 99 DEF[wait:30]\n* The default enemy.", 
                "[colorHEX:9900ff]* Carrying warm memories..."
            })
        elseif (action == "Appreciate") then
            BattleDialogue({
                "* You posed with Poseur.\n[colorHEX:00ffff]* Time seems to have frozen in\n  this moment...", 
                "* Enjoy the time!"
            })
        end
    elseif (enemy_name == "[preset=chinese]敌人名称") then
        if (action == "Check") then
            BattleDialogue({
                "* Posette - 1 ATK -1 DEF[wait:30]\n* Poseur's friend.",
                "[colorHEX:9900ff]* Carrying warm memories too..."
            })
        elseif (action == "Appreciate") then
            BattleDialogue({
                "* You posed with Posette.\n[colorHEX:00ffff]* Time seems to have frozen in\n  this moment...",
                "[colorHEX:11ff11]* Enjoy the time!!!"
            })
        end
    end
end

-- This function is called when the player interacts with an item.
local function HandleItems(itemID)
    local inventory = battle.Inventory
    local randomText = {
        "* It was very effective!",
        "* It was not very effective...",
        "* It was super effective!",
        "* It was not very effective\n  at all...",
        "* That was an amazing item!",
        "* An unforgettable item!",
    }

    -- Check if the item is consumed.
    BattleDialogue({
        "* You found an item...[wait:30]\n  [colorRGB:255, 255, 0]" .. itemID .. "!",
        randomText[math.random(1, #randomText)]
    })
end

-- What happens when the player selects the spare button.
local function HandleSpare()
    battle.STATE = "DEFENDING"
end

-- What happens when the player selects the flee button.
local function HandleFlee()
    love.audio.stop()
    fleeing = true
    fleetime = 0
    fleelegs = sprites.CreateSprite("UI/Battle Screen/SOUL/spr_heartgtfo_0.png", 14.99)
    fleelegs:MoveTo(battle.Player.sprite.x, battle.Player.sprite.y + 12)
    fleelegs:SetAnimation({
        "UI/Battle Screen/SOUL/spr_heartgtfo_1.png",
        "UI/Battle Screen/SOUL/spr_heartgtfo_0.png"
    }, 5)
    battle.Player.sprite.y = battle.Player.sprite.y - 8
    battle.Player.sprite.velocity.x = -1
    BattleDialogue({
        "* You fled from the battle.\n* You feel refreshed.",
        "[noskip][function:ChangeScene|" .. DATA.room .. "][next]"
    })
    audio.PlaySound("snd_flee.wav", 1, false)
end

function ChangeScene(scene)
    scenes.switchTo(scene)
end

-- This function is called when the player interacts with a bullet.
local function OnHit(Bullet)
    local mode = Bullet['HurtMode']
    if (mode == "normal" or type(mode) == "nil") then
        battle.Player.Hurt(1, 120, true)
    elseif (mode == "cyan" or mode == "blue") then
        if (battle.Player.isMoving) then
            battle.Player.Hurt(1, 0, true)
        end
    elseif (mode == "orange") then
        if (not battle.Player.isMoving) then
            battle.Player.Hurt(1, 0, true)
        end
    elseif (mode == "green") then
        battle.Player.Heal(1)
        Bullet:Destroy()
    end
end

local particles = {}
local particle_time = 0
function SCENE.update(dt)
    blasters:Update()

    particle_time = particle_time + 1
    if (particle_time == 1) then
        local mus, ins = audio.PlayMusic("mus_house1.ogg", 0, true)
        ins:VolumeTransition(0, 1, 2)
    end
    for i = #particles, 1, -1 do
        local particle = particles[i]
        if (particle.isactive) then
            particle.alpha = particle.alpha - 0.02
            particle.rotation = particle.rotation + 2
            if (particle.alpha <= 0) then
                particle:Destroy()
                table.remove(particles, i)
            end
        end
    end

    if (battle) then
        battle.Player.Update(dt)
        if (not battle.WIN) then
            if (fleeing) then
                fleelegs:MoveTo(battle.Player.sprite.x, battle.Player.sprite.y + 12)
            end
            local enemies = battle.Enemies
            local Player = battle.Player

            if (state_checker ~= battle.STATE) then
                EnteringState(battle.STATE, state_checker)
                state_checker = battle.STATE
            end
            if (hp_text) then
                maxhp.xscale = maths.Clamp(battle.Player.maxhp * 1.21, 20 * 1.21, 99 * 1.21)
                hp.xscale = (Player.hp / Player.maxhp) * maxhp.xscale
                hp_text:SetText(battle.Player.hp .. " / " .. battle.Player.maxhp)
                hp_text.x = math.max(maxhp.x + maxhp.xscale + 15, maxhp.x + hp.xscale + 15)
            end
            for i = 1, #UI.Buttons
            do
                local button = UI.Buttons[i]
                if (button.isactive) then
                    if (i == inButton) then
                        if (battle.STATE ~= "DEFENDING") then
                            button:Set(button.realName:sub(1, -2) .. "1.png")
                        else
                            button:Set(button.realName:sub(1, -2) .. "0.png")
                        end
                    else
                        button:Set(button.realName:sub(1, -2) .. "0.png")
                    end
                end
            end

            if (attacking) then
                attacktime = attacktime + 1
                local enemy = enemies[inSelect]
                if (attacktime == 70) then
                    local absLength = math.abs(uiElements[1].x - uiElements[2].x)
                    local damage = enemy.maxdamage
                    if (absLength > 5) then
                        damage = math.ceil(damage * 0.9 * (1 - absLength / 280))
                    end
                    if (damage >= 0) then
                        audio.PlaySound("snd_damage.wav", 1, false)
                        rhp = sprites.CreateSprite("px.png", 1)
                        rhp:Scale(enemy.hp * 100 / enemy.maxhp, 15)
                        rhp.color = {0, 1, 0}
                        rhp.xpivot = 0
                        rhp:MoveTo(enemy.position.x - 50, enemy.position.y + 40)
                        table.insert(uiElements, rhp)
                        rmhp = sprites.CreateSprite("px.png", 0)
                        rmhp:Scale(100, 15)
                        rmhp.color = {0.5, 0.5, 0.5}
                        rmhp.xpivot = 0
                        rmhp:MoveTo(enemy.position.x - 50, enemy.position.y + 40)
                        table.insert(uiElements, rmhp)
                        enemy.hp = math.max(0, enemy.hp - damage)
                        delta_hp = damage
                        hpt = typers.DrawText(damage, {enemy.position.x, 40}, 1)
                        hpt.font = "Hachicro.ttf"
                        hpt.color = {1, .2, .2}
                        hpt.jumpspeed = 3
                        hpt.gravity = 0.3
                        hpt.fontsize = 32
                        hpt:Reparse()

                        local w, h = hpt:GetLettersSize()
                        hpt.x = hpt.x - w / 2
                        bcg = sprites.CreateSprite("px.png", hpt.layer - 0.00001)
                        bcg:Scale(w + 3, h + 2)
                        bcg.color = {0, 0, 0}
                        bcg:MoveTo(hpt.x - 4, hpt.y + h / 2)
                        bcg.xpivot = 0

                        table.insert(uiElements, bcg)
                        table.insert(uiTexts, hpt)
                    else
                        hpt = typers.DrawText(enemy.defensetext, {enemy.position.x, 40}, 1)
                        hpt.font = "Hachicro.ttf"
                        hpt.jumpspeed = 3
                        hpt.gravity = 0.3
                        hpt.fontsize = 32
                        hpt:Reparse()

                        local w, h = hpt:GetLettersSize()
                        hpt.x = hpt.x - w / 2
                        bcg = sprites.CreateSprite("px.png", hpt.layer - 0.00001)
                        bcg:Scale(w + 3, h + 2)
                        bcg.color = {0, 0, 0}
                        bcg:MoveTo(hpt.x - 4, hpt.y + h / 2)
                        bcg.xpivot = 0

                        table.insert(uiElements, bcg)
                        table.insert(uiTexts, hpt)
                    end
                end
                if (attacktime > 70 and attacktime <= 100) then
                    if (hpt and bcg) then
                        if (hpt.y <= 40) then
                            local w, h = hpt:GetLettersSize()
                            hpt.y = hpt.y - hpt.jumpspeed
                            bcg.y = hpt.y + h / 2 - 2
                            hpt.jumpspeed = hpt.jumpspeed - hpt.gravity
                        end
                    end
                    if (rhp and rmhp) then
                        if (rhp.xscale > enemy.hp * 100 / enemy.maxhp) then
                            rhp.xscale = rhp.xscale - ((delta_hp + enemy.hp) * 100 / enemy.maxhp) / 30
                        end
                        if (rhp.xscale < 0) then
                            rhp.xscale = 0
                        end
                    end
                end
                if (attacktime == 130) then
                    for i = #enemies, 1, -1
                    do
                        local enem = enemies[i]
                        if (enem.hp <= 0 and enem.killable) then
                            enem.dead = true
                        end
                        if (enem.dead) then
                            if (enem.hp > 0) then
                                battle.Gold = battle.Gold + enem.gold
                                table.remove(enemies, i)
                                enem = nil
                            else
                                if (enem.killable) then
                                    battle.Gold = battle.Gold + enem.gold
                                    battle.Exp = battle.Exp + enem.exp
                                    FLAG.ruins_killed = FLAG.ruins_killed + 1
                                    table.remove(enemies, i)
                                    enem = nil
                                end
                            end
                        end
                    end
                end
                if (attacktime == 140) then
                    if (#enemies > 0) then
                        battle.STATE = "DEFENDING"
                        uiTexts.clear()
                        uiElements.clear()
                        attacking = false
                        attacktime = 0
                    else
                        love.audio.stop()
                        audio.ClearAll()
                        Player.sprite:MoveTo(9999, 9999)
                        uiElements.clear()
                        uiTexts.clear()
                        battle.STATE = "NONE"
                        battle.WIN = true
                        DATA.player.exp = DATA.player.exp + battle.Exp
                        DATA.player.gold = DATA.player.gold + battle.Gold
                        local oldLV = battle.Player.lv
                        local currentExp = DATA.player.exp
                        if (currentExp >= 99999) then
                            battle.Player.lv = 20
                        end
                        for i = #levelData, 1, -1 do
                            if (currentExp >= levelData[i].totalExp) then
                                battle.Player.lv = levelData[i].lv
                                battle.Player.maxhp = levelData[i].hp
                                DATA.player.atk = levelData[i].at
                                DATA.player.def = levelData[i].df
                                break
                            end
                        end
                        if (hp_text) then
                            maxhp.xscale = maths.Clamp(battle.Player.maxhp * 1.21, 20 * 1.21, 99 * 1.21)
                            hp.xscale = (Player.hp / Player.maxhp) * maxhp.xscale
                            lv:SetText("Lv[spaceX=0]  " .. Player.lv)
                            hp_text:SetText(battle.Player.hp .. " / " .. battle.Player.maxhp)
                            hp_text.x = math.max(maxhp.x + maxhp.xscale + 15, maxhp.x + hp.xscale + 15)
                        end
                        local victory_m = "* You WON![wait:10]\n* You earned " .. battle.Exp .. " XP and " .. battle.Gold .. " GOLD."
                        if (battle.Player.lv > oldLV) then
                            audio.PlaySound("snd_levelup.wav")
                            victory_m = victory_m .. "\n* Your LOVE increased."
                        end
                        BattleDialogue({
                            victory_m,
                            "[function:ChangeScene|" .. DATA.room .. "]"
                        })
                    end
                end
            end
            if (keyboard.GetState("confirm") == 1) then
                encounterTyper:SetText({""})
                if (battle.STATE == "ATTACKING") then
                    if (not attacking) then
                        attacking = true
                        uiElements[2].velocity.x = 0
                        audio.PlaySound("snd_slice.wav")
                        local slice = sprites.CreateSprite("UI/Battle Screen/Player Attack/spr_slice_o_0.png", 18)
                        slice:SetAnimation({
                            "UI/Battle Screen/Player Attack/spr_slice_o_1.png",
                            "UI/Battle Screen/Player Attack/spr_slice_o_2.png",
                            "UI/Battle Screen/Player Attack/spr_slice_o_3.png",
                            "UI/Battle Screen/Player Attack/spr_slice_o_4.png",
                            "UI/Battle Screen/Player Attack/spr_slice_o_5.png",
                        }, 10, "oneshot-empty")
                        slice:MoveTo(enemies[inSelect].position.x, enemies[inSelect].position.y)
                    end
                end
                if (battle.STATE == "ACTSELECTING") then
                    uiTexts.clear()
                    HandleActions(enemies[inSelect].name, enemies[inSelect].actions[actionSelect])
                    Player.sprite:MoveTo(9999, 9999)
                    battle.STATE = "DIALOGUERESULT"
                    audio.PlaySound("snd_menu_1.wav")
                end
                if (battle.STATE == "FIGHTMENU") then
                    uiTexts.clear()
                    uiElements.clear()
                    battle.STATE = "ATTACKING"
                    audio.PlaySound("snd_menu_1.wav")
                    Player.sprite:MoveTo(9999, 9999)
                    local target = sprites.CreateSprite("UI/Battle Screen/spr_target_0.png", 15)
                    target.y = 320
                    table.insert(uiElements, target)
                    local bar = sprites.CreateSprite("UI/Battle Screen/Player Attack/spr_targetchoice_0.png", 16)
                    bar.y = 320
                    bar:SetAnimation({
                        "UI/Battle Screen/Player Attack/spr_targetchoice_1.png", 
                        "UI/Battle Screen/Player Attack/spr_targetchoice_0.png"
                    }, 5)
                    local pos = math.random(1, 2)
                    if (pos == 1) then
                        bar.x = 320 + 280
                        bar.velocity.x = -6
                    else
                        bar.x = 320 - 280
                        bar.velocity.x = 6
                    end
                    bar.newPosvar = pos
                    table.insert(uiElements, bar)
                elseif (battle.STATE == "ACTMENU") then
                    uiTexts.clear()
                    uiElements.clear()
                    battle.STATE = "ACTSELECTING"
                    audio.PlaySound("snd_menu_1.wav")

                    local actions = enemies[inSelect].actions
                    local posx, posy = 80, 270
                    for i = 1, #actions
                    do
                        if (i <= 4) then
                            if (i % 2 == 1) then
                                posx = 80
                            else
                                posx = 330
                            end
                        end
                        local text = typers.DrawText("*", {posx, posy}, 14)
                        local action = typers.DrawText(actions[i], {posx + 30, posy}, 14)
                        text.color = action.color
                        if (i % 2 == 0) then
                            posy = posy + 35
                        end
                        table.insert(uiTexts, text)
                        table.insert(uiTexts, action)
                        table.insert(uiPoses, text)
                    end
                elseif (battle.STATE == "ITEMMENU") then
                    local inventory = battle.Inventory
                    HandleItems(inventory.Items[inSelect])
                    if (inventory.NoDelete) then
                        inventory.NoDelete = false
                    else
                        table.remove(inventory.Items, inSelect)
                    end
                    battle.STATE = "DIALOGUERESULT"
                    uiTexts.clear()
                    uiElements.clear()
                    audio.PlaySound("snd_menu_1.wav")
                    Player.sprite:MoveTo(9999, 9999)
                elseif (battle.STATE == "MERCYMENU") then
                    if (inSelect == 1) then
                        for k, v in pairs(enemies)
                        do
                            if (v.canspare) then
                                v.dead = true
                                battle.Gold = battle.Gold + v.gold
                                table.remove(enemies, k)
                            end
                        end
                        if (#enemies == 0) then
                            love.audio.stop()
                            audio.ClearAll()
                            Player.sprite:MoveTo(9999, 9999)
                            uiElements.clear()
                            uiTexts.clear()
                            battle.STATE = "NONE"
                            battle.WIN = true
                            DATA.player.exp = DATA.player.exp + battle.Exp
                            DATA.player.gold = DATA.player.gold + battle.Gold
                            local oldLV = battle.Player.lv
                            local currentExp = DATA.player.exp
                            if (currentExp >= 99999) then
                                battle.Player.lv = 20
                            end
                            for i = #levelData, 1, -1 do
                                if (currentExp >= levelData[i].totalExp) then
                                    battle.Player.lv = levelData[i].lv
                                    battle.Player.maxhp = levelData[i].hp
                                    DATA.player.atk = levelData[i].at
                                    DATA.player.def = levelData[i].df
                                    break
                                end
                            end
                            if (hp_text) then
                                maxhp.xscale = maths.Clamp(battle.Player.maxhp * 1.21, 20 * 1.21, 99 * 1.21)
                                hp.xscale = (Player.hp / Player.maxhp) * maxhp.xscale
                                lv:SetText("Lv[spaceX=0]  " .. Player.lv)
                                hp_text:SetText(battle.Player.hp .. " / " .. battle.Player.maxhp)
                                hp_text.x = math.max(maxhp.x + maxhp.xscale + 15, maxhp.x + hp.xscale + 15)
                            end
                            local victory_m = "* You WON![wait:10]\n* You earned " .. battle.Exp .. " XP and " .. battle.Gold .. " GOLD."
                            if (battle.Player.lv > oldLV) then
                                audio.PlaySound("snd_levelup.wav")
                                victory_m = victory_m .. "\n* Your LOVE increased."
                            end
                            BattleDialogue({
                                victory_m,
                                "[function:ChangeScene|" .. DATA.room .. "]"
                            })
                        else
                            HandleSpare()
                        end
                        uiElements.clear()
                        uiTexts.clear()
                    else
                        if (math.random() <= 0.6) then
                            battle.STATE = "FLEEING"
                            HandleFlee()
                            uiElements.clear()
                            uiTexts.clear()
                        else
                            uiElements.clear()
                            uiTexts.clear()
                            battle.STATE = "DEFENDING"
                        end
                    end
                end
                if (battle.STATE == "ACTIONSELECT") then
                    audio.PlaySound("snd_menu_1.wav")
                    if (inButton == 1) then
                        battle.STATE = "FIGHTMENU"

                        for i = 1, #enemies
                        do
                            if (not enemies[i].dead) then
                                local text = typers.DrawText("* " .. enemies[i].name, {80, 270 + 35 * (i - 1)}, 14)
                                if (enemies[i].canspare) then text.color = {1, 1, 0} text:Reparse() end
                                table.insert(uiTexts, text)
                                local maxhpbar = sprites.CreateSprite("px.png", 13)
                                maxhpbar.xpivot = 0
                                maxhpbar:Scale(100, 20)
                                maxhpbar:MoveTo(380, 288 + 35 * (i - 1))
                                maxhpbar.color = {1, 0, 0}
                                local hpbar = sprites.CreateSprite("px.png", 14)
                                hpbar.xpivot = 0
                                hpbar:Scale(enemies[i].hp / enemies[i].maxhp * 100, 20)
                                hpbar:MoveTo(380, 288 + 35 * (i - 1))
                                hpbar.color = {0, 1, 0}

                                table.insert(uiElements, maxhpbar)
                                table.insert(uiElements, hpbar)
                            end
                        end
                    elseif (inButton == 2) then
                        battle.STATE = "ACTMENU"

                        for i = 1, #enemies
                        do
                            if (not enemies[i].dead) then
                                local text = typers.DrawText("* " .. enemies[i].name, {80, 270 + 35 * (i - 1)}, 14)
                                if (enemies[i].canspare) then text.color = {1, 1, 0} text:Reparse() end
                                table.insert(uiTexts, text)
                            end
                        end
                    elseif (inButton == 3 and #battle.Inventory.Items > 0) then
                        battle.STATE = "ITEMMENU"

                        local inventory = battle.Inventory
                        local dx, dy = 0, 0
                        if (inventory.Pattern == 1) then
                            for i = 1, 4
                            do
                                if (inventory.Items[i]) then
                                    local text = typers.DrawText("* " .. inventory.Items[i], {80 + dx, 270 + dy}, 14)
                                    if (i == 2) then
                                        dx = 0
                                        dy = dy + 35
                                    elseif (i == 1 or i == 3) then
                                        dx = dx + 250
                                    end
                                    table.insert(uiTexts, text)
                                else
                                    local text = typers.DrawText("", {80 + dx, 270 + dy}, 14)
                                    if (i == 2) then
                                        dx = 0
                                        dy = dy + 35
                                    elseif (i == 1 or i == 3) then
                                        dx = dx + 250
                                    end
                                    table.insert(uiTexts, text)
                                end
                            end
                            local page = typers.DrawText("PAGE 1", {400, 340}, 14)
                            table.insert(uiTexts, page)
                        elseif (inventory.Pattern == 2) then
                            if (#inventory.Items > 3) then
                                for i = 1, math.min(3, #inventory.Items)
                                do
                                    local point = sprites.CreateSprite("px.png", 15)
                                    point:Scale(4, 4)
                                    point:MoveTo(580, 320 + 50 - (i - 1) * 12)
                                    table.insert(uiElements, point)
                                end
                            end
                            for i = 1, (#inventory.Items > 3 and 3 or #inventory.Items)
                            do
                                local text = typers.DrawText("* " .. inventory.Items[i], {80 + dx, 270 + dy}, 14)
                                dy = dy + 35
                                table.insert(uiTexts, text)
                            end
                        end
                    elseif (inButton == 4) then
                        battle.STATE = "MERCYMENU"

                        local text = typers.DrawText("* Spare", {80, 270}, 14)
                        local text1 = typers.DrawText("* Flee", {80, 305}, 14)
                        table.insert(uiTexts, text)
                        table.insert(uiTexts, text1)

                        for _, v in pairs(enemies)
                        do
                            if (v.canspare) then text.color = {1, 1, 0} text:Reparse() end
                        end
                    end
                end
            elseif (keyboard.GetState("cancel") == 1) then
                if (battle.STATE == "FIGHTMENU" or battle.STATE == "ACTMENU" or battle.STATE == "ITEMMENU" or battle.STATE == "MERCYMENU") then
                    uiTexts.clear()
                    uiElements.clear()
                    uiPoses.clear()
                    encounterTyper:SetText({battle.EncounterText})
                    battle.STATE = "ACTIONSELECT"
                end
                if (battle.STATE == "ACTSELECTING") then
                    battle.STATE = "ACTMENU"
                    uiTexts.clear()
                    uiElements.clear()
                    uiPoses.clear()
                    actionSelect = 1
                    for i = 1, #enemies
                    do
                        if (not enemies[i].dead) then
                            local text = typers.DrawText("* " .. enemies[i].name, {80, 270 + 35 * (i - 1)}, 14)
                            if (enemies[i].canspare) then text.color = {1, 1, 0} end
                            table.insert(uiTexts, text)
                        end
                    end
                end
            end

            if (battle.STATE == "DEFENDING") then
                if (encounterTyper.sentences[1] ~= "") then
                    encounterTyper:SetText({""})
                end
                global:SetVariable("LAYER", global:GetVariable("LAYER") + 0.0001)
                battle.wave = require("Scripts.Waves." .. battle.nextwave)
                if (battle.wave) then
                    battle.mainarena.iscolliding = true
                    if (not battle.wave.ENDED) then
                        battle.wave.update(dt)
                        battle.Player.Movement(dt)
                    else
                        battle.wave.ENDED = false
                        global:SetVariable("LAYER", 30)
                        package.loaded["Scripts.Waves." .. battle.nextwave] = nil
                        DefenseEnding()
                        battle.STATE = "ACTIONSELECT"
                    end
                end
            end
            arenas.Update()
            if (battle.STATE == "FIGHTMENU") then
                if (battle.Player.sprite.isactive) then
                    if (keyboard.GetState("up") == 1) then
                        inSelect = math.max(1, inSelect - 1)
                        audio.PlaySound("snd_menu_0.wav")
                    elseif (keyboard.GetState("down") == 1) then
                        inSelect = math.min(#enemies, inSelect + 1)
                        audio.PlaySound("snd_menu_0.wav")
                    end
                    local enemy_text = uiTexts[inSelect]
                    Player.sprite:MoveTo(60, enemy_text.y + 18)
                end
            end
            if (battle.STATE == "ATTACKING") then
                local enemy = enemies[inSelect]
                if (#uiElements > 0) then
                    local bar = uiElements[2]
                    if (not attacking) then
                        if (bar.newPosvar == 1) then
                            if (bar.x < 320 - 280) then
                                hpt = typers.DrawText(enemy.misstext, {enemy.position.x, 40}, 1)
                                hpt.font = "Hachicro.ttf"
                                hpt.jumpspeed = 3
                                hpt.gravity = 0.3
                                hpt.fontsize = 32
                                hpt:Reparse()
                                local w, h = hpt:GetLettersSize()
                                hpt.x = hpt.x - w / 2
                                bcg = sprites.CreateSprite("px.png", hpt.layer - 0.00001)
                                bcg:Scale(w + 3, h + 2)
                                bcg.color = {0, 0, 0}
                                bcg:MoveTo(hpt.x - 4, hpt.y + h / 2 - 2)
                                bcg.xpivot = 0

                                table.insert(uiElements, bcg)
                                table.insert(uiTexts, hpt)
                                attacking = true
                                attacktime = 110
                                bar.velocity.x = 0
                            end
                        else
                            if (bar.x > 320 + 280) then
                                hpt = typers.DrawText(enemy.misstext, {enemy.position.x, 40}, 1)
                                hpt.font = "Hachicro.ttf"
                                hpt.jumpspeed = 3
                                hpt.gravity = 0.3
                                hpt.fontsize = 32
                                hpt:Reparse()
                                local w, h = hpt:GetLettersSize()
                                hpt.x = hpt.x - w / 2
                                bcg = sprites.CreateSprite("px.png", hpt.layer - 0.00001)
                                bcg:Scale(w + 3, h + 2)
                                bcg.color = {0, 0, 0}
                                bcg:MoveTo(hpt.x - 4, hpt.y + h / 2 - 2)
                                bcg.xpivot = 0

                                table.insert(uiElements, bcg)
                                table.insert(uiTexts, hpt)
                                attacking = true
                                attacktime = 110
                                bar.velocity.x = 0
                            end
                        end
                    end
                end
            end
            if (battle.STATE == "ITEMMENU") then
                local inventory = battle.Inventory

                if (inventory.Pattern == 1) then
                    if (keyboard.GetState("right") == 1) then
                        audio.PlaySound("snd_menu_0.wav")
                        if (inSelect % 2 == 1) then
                            inSelect = math.min(#inventory.Items, inSelect + 1)
                        else
                            currentPage = math.min(currentPage + 1, math.ceil(#inventory.Items / 4))
                            for i = 1, 4
                            do
                                local t = uiTexts[i]
                                if (t.isactive) then
                                    if (inventory.Items[(currentPage - 1) * 4 + i]) then
                                        t.color = {1, 1, 1}
                                        t:SetText("* " .. inventory.Items[(currentPage - 1) * 4 + i])
                                    else
                                        t.color = {1, 1, 1}
                                        t:SetText("")
                                    end
                                end
                            end
                            uiTexts[5]:SetText("PAGE " .. currentPage)
                            inSelect = math.min(#inventory.Items, inSelect + 3)
                        end
                    end
                    if (keyboard.GetState("left") == 1) then
                        audio.PlaySound("snd_menu_0.wav")
                        if (inSelect % 2 == 0) then
                            inSelect = math.max(1, inSelect - 1)
                        else
                            currentPage = math.max(1, currentPage - 1)
                            for i = 1, 4
                            do
                                local t = uiTexts[i]
                                if (t.isactive) then
                                    if (inventory.Items[(currentPage - 1) * 4 + i]) then
                                        t.color = {1, 1, 1}
                                        t:SetText("* " .. inventory.Items[(currentPage - 1) * 4 + i])
                                    else
                                        t.color = {1, 1, 1}
                                        t:SetText("")
                                    end
                                end
                            end
                            uiTexts[5]:SetText("PAGE " .. currentPage)
                            inSelect = math.max(1, inSelect - 3)
                        end
                    end
                    if (keyboard.GetState("up") == 1) then
                        audio.PlaySound("snd_menu_0.wav")
                        inSelect = math.max(4 * (currentPage - 1) + 1, inSelect - 2)
                    end
                    if (keyboard.GetState("down") == 1) then
                        audio.PlaySound("snd_menu_0.wav")
                        inSelect = math.min(4 * (currentPage - 1) + 4, math.min(inSelect + 2, #inventory.Items))
                    end

                    local value = (inSelect % 4 == 0) and 4 or (inSelect % 4)
                    Player.sprite:MoveTo(uiTexts[value].x - 20, uiTexts[value].y + 18)
                end
            end
            if (battle.STATE == "MERCYMENU") then
                if (keyboard.GetState("up") == 1) then
                    inSelect = math.max(1, inSelect - 1)
                end
                if (keyboard.GetState("down") == 1) then
                    inSelect = math.min(#uiTexts, inSelect + 1)
                end
                Player.sprite:MoveTo(uiTexts[inSelect].x - 20, uiTexts[inSelect].y + 18)
            end
            if (battle.STATE == "ACTIONSELECT") then
                if (battle.Player.sprite.isactive) then
                    local button = UI.Buttons[inButton]
                    battle.Player.sprite.rotation = button.rotation
                    battle.Player.sprite:MoveTo(
                        button.x - 39 * math.cos(math.rad(button.rotation)),
                        button.y - 39 * math.sin(math.rad(button.rotation))
                    )
                end
                if (keyboard.GetState("left") == 1) then
                    inButton = inButton - 1
                    audio.PlaySound("snd_menu_0.wav")
                    if (inButton < 1) then inButton = #UI.Buttons end
                    if (inButton > #UI.Buttons) then inButton = 1 end
                elseif (keyboard.GetState("right") == 1) then
                    inButton = inButton + 1
                    audio.PlaySound("snd_menu_0.wav")
                    if (inButton < 1) then inButton = #UI.Buttons end
                    if (inButton > #UI.Buttons) then inButton = 1 end
                end
                
                local ma = battle.mainarena.black
                if (ma.xscale > 5.645 and ma.xscale < 5.655 and ma.yscale > 1.295 and ma.yscale < 1.305) then
                    if (encounterTyper.sentences[1] == "") then
                        encounterTyper:SetText({battle.EncounterText})
                    end
                end
            end
            if (battle.STATE == "ACTMENU") then
                if (keyboard.GetState("up") == 1) then
                    inSelect = math.max(1, inSelect - 1)
                    if (#enemies > 1) then audio.PlaySound("snd_menu_0.wav") end
                elseif (keyboard.GetState("down") == 1) then
                    inSelect = math.min(#enemies, inSelect + 1)
                    if (#enemies > 1) then audio.PlaySound("snd_menu_0.wav") end
                end
                Player.sprite:MoveTo(uiTexts[inSelect].x - 20, uiTexts[inSelect].y + 18)
            end
            if (battle.STATE == "ACTSELECTING") then
                local actions = enemies[inSelect].actions
                Player.sprite:MoveTo(uiPoses[actionSelect].x - 20, uiPoses[actionSelect].y + 18)
                if (keyboard.GetState("left") == 1) then
                    actionSelect = math.max(1, actionSelect - 1)
                    audio.PlaySound("snd_menu_0.wav")
                elseif (keyboard.GetState("right") == 1) then
                    actionSelect = math.min(#actions, actionSelect + 1)
                    audio.PlaySound("snd_menu_0.wav")
                elseif (keyboard.GetState("up") == 1) then
                    if (#actions > 2) then
                        actionSelect = math.max(1, actionSelect - 2)
                        audio.PlaySound("snd_menu_0.wav")
                    end
                elseif (keyboard.GetState("down") == 1) then
                    if (#actions > 2) then
                        actionSelect = math.min(#actions, actionSelect + 2)
                        audio.PlaySound("snd_menu_0.wav")
                    end
                end
            end

            for _, sprite in pairs(sprites.images)
            do
                if (sprite.isactive) then
                    if (sprite.isBullet) then
                        local col = collisions.FollowShape(sprite)
                        local plr = collisions.FollowShape(Player.sprite)
                        local res = collisions.RectangleWithPoint(col, plr)
                        if (res) then
                            if (not battle.Player.hurting) then
                                OnHit(sprite)
                            end
                        end
                    end
                end
            end

            global:SetVariable("PlayerPosition", {battle.Player.sprite.x, battle.Player.sprite.y})
            if (battle.Player.hp <= 0) then
                package.loaded["Scripts.Waves." .. battle.nextwave] = nil
                scenes.switchTo("scene_gameover")
            end
        end
    end
end

function SCENE.draw()
    if (battle.STATE == "DEFENDING") then
        if (battle.wave) then
            if (battle.wave.draw) then
                battle.wave.draw()
            end
        end
    end
end

function SCENE.clear()
    DATA.player.hp = battle.Player.hp
    DATA.player.maxhp = battle.Player.maxhp
    DATA.player.lv = battle.Player.lv
    DATA.player.items = battle.Inventory.Items

    package.loaded["Scripts.Libraries.Game.EncounterOW"] = nil
    package.loaded["Scripts.Libraries.Attacks.Arenas"] = nil
    package.loaded["Scripts.Waves." .. battle.nextwave] = nil

    tween.clear()
    blasters:clear()
    encounterTyper:Destroy()
    package.loaded["Scripts.Libraries.Attacks.GasterBlaster"] = nil
    layers.clear()
    masks.clear()
    love.audio.stop()
    audio.ClearAll()
end

return SCENE