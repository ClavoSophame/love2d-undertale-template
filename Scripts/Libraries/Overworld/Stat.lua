local stat = {
    page = "NONE",
    inbutton = 1,
    initem = 1,
    initemc = 1,
    incell = 1,
    interact = 0,
    under = false,
    blocks = {},
    temps = {},
    heart = nil,

    statpage = nil,
    itempage = nil,
}
local OPENED_ARC = false
local spidermoving = false
local spidertime = 0
local spidertext = nil
local spiderencounter = false

local function TPos(x, y)
    return _CAMERA_.x + x, _CAMERA_.y + y
end

function drawredSpider()
    spidertext = typers.DrawText("[preset=chinese][offsetX=20][red]蜘蛛", {TPos(312, 344)}, 10004)
end

function runSpider()
    spidermoving = true
end

function encounterSpider()
    spiderencounter = true
    local bg = sprites.CreateSprite("bg.png", 2000000)
    bg:Scale(99, 99)
    bg:MoveTo(TPos(320, 240))
    stat.interact = 3
end

-- ITEMs = 335 * 350
-- STAT  = 335 * 410
-- CELL  = 335 * 255

function RemoveBlocks()
    stat.heart:Destroy()
    for i = #stat.blocks, 1, -1
    do
        local block = stat.blocks[i]
        if (block.white and block.black) then
            block.white:Destroy()
            block.black:Destroy()
        else
            block:Destroy()
        end
        table.remove(stat.blocks, i)
    end
    stat.page = "NONE"
    stat.interact = 0

    stat.initem = 1
    stat.initemc = 1
    stat.inbutton = 1
end

local function RemoveBlock(block)
    for k, v in pairs(stat.blocks)
    do
        if (v == block) then
            if (block.white and block.black) then
                block.white:Destroy()
                block.black:Destroy()
            else
                block:Destroy()
            end
            table.remove(stat.blocks, k)
        end
    end
end

local function CreateBlock(x, y, w, h, r)
    local block = {}

    block.white = sprites.CreateSprite("px.png", 10000)
    block.black = sprites.CreateSprite("px.png", 10001)
    block.black.color = {0, 0, 0}

    block.white:Scale(w + 10, h + 10)
    block.black:Scale(w, h)

    block.white:MoveTo(x, y)
    block.black:MoveTo(x, y)

    table.insert(stat.blocks, block)
    return block
end

local function DrawText(text, x, y)
    local sentence = typers.DrawText(text, {x, y}, 10002)
    table.insert(stat.blocks, sentence)
    return sentence
end

function stat:Update(dt)

    Player = DATA.player
    stat.items = DATA.player.items
    stat.cells = DATA.player.cells
    stat.getcell = DATA.player.getcell

    if (stat.page == "IDLE") then
        if (keyboard.GetState("down") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.inbutton = math.min(stat.inbutton + 1, 3)
            if (not stat.getcell) then stat.inbutton = math.min(stat.inbutton, 2) end
        elseif (keyboard.GetState("up") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.inbutton = math.max(stat.inbutton - 1, 1)
        end
        stat.heart:MoveTo(TPos(65, 208 + (stat.inbutton - 1) * 35))
    end
    if (stat.page == "ITEM") then
        if (keyboard.GetState("down") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.initem = math.min(stat.initem + 1, #stat.items)
        elseif (keyboard.GetState("up") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.initem = math.max(stat.initem - 1, 1)
        end
        stat.heart:MoveTo(TPos(212, 88 + (stat.initem - 1) * 35))
    end
    if (stat.page == "ITEMC") then
        if (keyboard.GetState("right") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.initemc = math.min(stat.initemc + 1, 3)
        elseif (keyboard.GetState("left") == 1) then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.initemc = math.max(stat.initemc - 1, 1)
        end
        stat.heart:MoveTo(TPos(212 + (stat.initemc - 1) * 95, 378))
    end
    if (stat.page == "STAT") then
        
    end

    if (keyboard.GetState("menu") == 1 and stat.interact == 0) then
        if (stat.page == "NONE") then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.page = "IDLE"
            stat.interact = 1
            stat.inbutton = 1
            stat.heart = sprites.CreateSprite("Soul Library Sprites/spr_default_heart.png", 10003)
            stat.heart.color = {1, 0, 0}
            stat.heart:MoveTo(TPos(65, 208))
            stat.heart:Scale(1, 1)

            local x, y = TPos(100, 240)
            local dy = 134
            CreateBlock(x, y, 132, 138, 0)
            if (not stat.under) then
                CreateBlock(x, y - dy, 132, 100, 0)

                local info_name = DrawText("[spaceX=-2]" .. Player.name, TPos(43, 60))
                local info_lv = DrawText("LV  " .. Player.lv, TPos(45, 105 - 3))
                info_lv.font = "Crypt Of Tomorrow.ttf"
                info_lv.fontsize = 16
                info_lv:Reparse()
                local info_hp = DrawText("HP  " .. Player.hp .. "/" .. Player.maxhp, TPos(45, 123 - 3))
                info_hp.font = "Crypt Of Tomorrow.ttf"
                info_hp.fontsize = 16
                info_hp:Reparse()
                local info_gold = DrawText("G   [offsetX=2]" .. Player.gold, TPos(45, 140 - 3))
                info_gold.font = "Crypt Of Tomorrow.ttf"
                info_gold.fontsize = 16
                info_gold:Reparse()

                local items = DrawText("[preset=chinese]物品", TPos(110, 190))
                local state = DrawText("[preset=chinese]状态", TPos(110, 225))
                local cells = DrawText("[preset=chinese]电话", TPos(110, 260))

                if (#stat.items == 0) then items.color = {.5, .5, .5} items:Reparse() end
                if (#stat.cells == 0) then cells.color = {.5, .5, .5} cells:Reparse() end
                if (not stat.getcell) then RemoveBlock(cells) end
            else
                CreateBlock(x, y + dy, 132, 100, 0)
            end
        elseif (stat.page == "IDLE") then
            stat.page = "NONE"
            stat.interact = 0
            RemoveBlocks()
        end
    end
    if (keyboard.GetState("confirm") == 1) then
        if (stat.page == "ITEMC") then
            -- use the item.
            local x, y = TPos(320, 400)
            CreateBlock(x, y, 575, 140, 0)
            local item = stat.items[stat.initem]
            stat:UseItem(item, stat.initemc)
            stat.interact = 2
            stat.heart.alpha = 0
            stat.itempage.white:Destroy()
            stat.itempage.black:Destroy()
            for i = #stat.temps, 1, -1
            do
                local temp = stat.temps[i]
                temp:Destroy()
                table.remove(stat.temps, i)
            end
            stat.page = "ITEMD"
        end
        if (stat.page == "ITEM") then
            stat.page = "ITEMC"
        end
        if (stat.page == "IDLE") then
            audio.PlaySound("snd_menu_1.wav", 1)
            if (stat.inbutton == 1 and #stat.items > 0) then -- item page.
                stat.page = "ITEM"
                local x, y = TPos(360, 230)
                stat.itempage = CreateBlock(x, y, 335, 350, 0)

                for i = 1, #stat.items
                do
                    stat.temps[i] = DrawText(stat.items[i], x - 150, y - 160 + (i - 1) * 35)
                end
                stat.temps[#stat.temps + 1] = DrawText("[preset=chinese][offsetX=20]使用  查看  丢弃", x - 150, y + 130)
            elseif (stat.inbutton == 2) then -- stat page.
                stat.page = "STAT"
                local x, y = TPos(365, 260)
                stat.heart.alpha = 0
                stat.statpage = CreateBlock(x, y, 335, 410, 0)

                local atkspace, defspace = "    ", "    "
                if (Player.atk > 9) then atkspace = atkspace:sub(1, -2) end
                if (Player.watk > 9) then atkspace = atkspace:sub(1, -2) end
                if (Player.def > 9) then defspace = defspace:sub(1, -2) end
                if (Player.edef > 9) then defspace = defspace:sub(1, -2) end

                stat.temps[#stat.temps + 1] = DrawText("\"" .. Player.name .. "\"", x - 150, y - 180)
                stat.temps[#stat.temps + 1] = DrawText("LV " .. Player.lv, x - 150, y - 120)
                stat.temps[#stat.temps + 1] = DrawText("HP " .. Player.hp .. "/" .. Player.maxhp, x - 150, y - 90)
                stat.temps[#stat.temps + 1] = DrawText("AT " .. Player.atk .. "(" .. Player.watk .. ")" .. atkspace .. "EXP:0", x - 150, y - 20)
                stat.temps[#stat.temps + 1] = DrawText("DF " .. Player.def ..  "(" .. Player.edef .. ")" .. defspace .. "NEXT:10", x - 150, y + 10)
                stat.temps[#stat.temps + 1] = DrawText("[preset=chinese][offsetX=0]武器： " .. Player.weapon, x - 150, y + 70)
                stat.temps[#stat.temps + 1] = DrawText("[preset=chinese][offsetX=0]防具： " .. Player.armor, x - 150, y + 100)
                stat.temps[#stat.temps + 1] = DrawText("[preset=chinese][offsetX=0]金钱：[font=determination_mono.ttf][scale=1]" .. Player.gold, x - 150, y + 150)
            elseif (stat.inbutton == 3 and #stat.cells > 0) then
                stat.page = "CELL"
            end
        end
    end
    if (keyboard.GetState("cancel") == 1) then
        if (stat.page == "IDLE") then
            stat.page = "NONE"
            stat.interact = 0
            RemoveBlocks()
        elseif (stat.page == "ITEM" or stat.page == "STAT" or stat.page == "CELL") then
            stat.initem = 1
            audio.PlaySound("snd_menu_0.wav", 1)
            if (stat.page == "STAT") then
                stat.statpage.white:Destroy()
                stat.statpage.black:Destroy()
                for i = #stat.temps, 1, -1
                do
                    local temp = stat.temps[i]
                    temp:Destroy()
                    table.remove(stat.temps, i)
                end
            elseif (stat.page == "ITEM") then
                stat.itempage.white:Destroy()
                stat.itempage.black:Destroy()
                for i = #stat.temps, 1, -1
                do
                    local temp = stat.temps[i]
                    temp:Destroy()
                    table.remove(stat.temps, i)
                end
            end
            stat.page = "IDLE"
            stat.heart.alpha = 1
        elseif (stat.page == "ITEMC") then
            audio.PlaySound("snd_menu_0.wav", 1)
            stat.page = "ITEM"
            stat.initemc = 1
        end
    end



    -- 此处为拓展区域。
    if (OPENED_ARC) then
        stat.interact = 2
        if (keyboard.GetState("cancel") == 1) then
            OPENED_ARC = false
            stat.page = "NONE"
            stat.interact = 0
            RemoveBlocks()
        end
    end

    if (spidermoving) then
        spidertime = spidertime + 1
        if (spidertime == 10) then
            tween.CreateTween(
                function (value)
                    spidertext.x = value
                end,
                "Back", "In", spidertext.x, _CAMERA_.x + 1200, 120
            )
        elseif (spidertime == 121) then
            spidertext:Destroy()
            spidermoving = false
            spidertime = 0
        end
    end

    if (spiderencounter) then
        spidertime = spidertime + 1
        if (spidertime == 60) then
            scenes.switchTo("scene_battle_spider")
        end
    end
end

function stat:UseItem(item, choice)
    print(item, choice)
    if (item == "[preset=chinese][offsetX=20]甜甜圈") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你吃了甜甜圈。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]吃了。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了甜甜圈。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]一个甜甜圈有什么好查看的？",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了甜甜圈。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]对的，就是扔了。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        end
    elseif (item == "[preset=chinese][offsetX=20]神秘小礼物") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你打开了神秘小礼物。",
                "* [fontIndex:2][pattern:chinese]里面有一个神秘的东西。",
                "* [fontIndex:2][pattern:chinese]噢，看起来是另一个小礼物！",
                "* [fontIndex:2][pattern:chinese]（你得到了神秘小小礼物。）",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
            table.insert(stat.items, "[preset=chinese][offsetX=20]神秘小小礼物")
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了神秘小礼物。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]打开它，看看里面有什么吧。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了神秘小礼物。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]但是小礼物又回去了！",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        end
    elseif (item == "[preset=chinese][offsetX=20]神秘小小礼物") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你打开了神秘小小礼物。",
                "* [fontIndex:2][pattern:chinese]噢，你被开了。",
                "* [fontIndex:2][pattern:chinese]（你得知你现在位于[fontIndex:1][pattern:english]" .. global:GetVariable("ROOM") .. "[fontIndex:2][pattern:chinese]房间中）",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了神秘小小礼物。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]打开它，看看里面有什么吧。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了神秘小小礼物。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]但是小礼物又回去了！",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        end
    elseif (item == "[preset=chinese][offsetX=20]安黛因的信") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你尝试打开安黛因的信。",
                "* [fontIndex:2][pattern:chinese]封的太死了，你打不开。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了安黛因的信。",
                "* [fontIndex:2][pattern:chinese][voice:v_flowey.wav]嘿！[wait:30]看什么呢！？",
                "* [fontIndex:2][pattern:chinese]你吓得连忙把信放回包里。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了安黛因的信。",
                "[colorHEX:9900ff]* [fontIndex:2][pattern:chinese]信又跟了回去！",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        end
    elseif (item == "[preset=chinese][offsetX=20]铁壶") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你打开了铁壶。",
                "* [fontIndex:2][pattern:chinese][sound:snd_doghurt1.wav]嘭[sound:snd_slice.wav]啪[sound:snd_save.wav]嘭[sound:snd_menu_0.wav]啪[sound:snd_levelup.wav][sound:snd_ding.wav]！[sound:snd_dimbox.wav]霹[sound:snd_bomb.wav]雳[sound:snd_drumroll.wav]乓[sound:snd_icespell.ogg]啷[sound:snd_notice.wav][sound:snd_mysterygo.wav]！[sound:snd_mtt_burst.wav]呜[sound:snd_saber3.wav]呜[sound:snd_spawn_0.wav]渣[sound:snd_snowgrave.ogg]渣[sound:snd_warning_0.wav]！",
                "* [fontIndex:2][pattern:chinese]啊，多么好听的音乐啊。",
                "* [fontIndex:2][pattern:chinese]（你吓得赶紧把铁壶扔了。）",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
            global:SetVariable("KEY", true)
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了铁壶。",
                "* [fontIndex:2][pattern:chinese]这位铁壶看起来是一名音乐家。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了铁壶。",
                "[sound:snd_doghurt1.wav]* [fontIndex:2][pattern:chinese]看来音乐剧到此结束了。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        end
    elseif (item == "[preset=chinese][offsetX=20]别欺负我") then
        if  (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你打开了别欺负我纸条。",
                "* [fontIndex:2][pattern:chinese]这是什么？[wait:30][fontIndex:1][pattern:english]end[fontIndex:2][pattern:chinese]？",
                "* [fontIndex:2][pattern:chinese][colorHEX:99ff99]捏一下。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
            table.insert(stat.items, "[preset=chinese][offsetX=20]欺负一下")
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了别欺负我纸条。",
                "* [fontIndex:2][pattern:chinese]上面写着：[wait:30][fontIndex:1][pattern:english]end[fontIndex:2][pattern:chinese]。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了别欺负我纸条。",
                "[colorHEX:ffff99]* [fontIndex:2][pattern:chinese]欺负人可是不对的。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        end
    elseif (item == "[preset=chinese][offsetX=20]欺负一下") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你打开了欺负一下纸条。",
                "* [fontIndex:2][pattern:chinese][colorHEX:ffff33][effect:shake, 1]你真该死啊。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了欺负一下纸条。",
                "* [fontIndex:2][pattern:chinese]上面写着：[wait:30][fontIndex:1][pattern:english]end[fontIndex:2][pattern:chinese]。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了欺负一下纸条。",
                "[colorHEX:ffff99]* [fontIndex:2][pattern:chinese]欺负人可是不对的。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        end
    elseif (item == "[preset=chinese][offsetX=20]传单") then
        if (choice == 1) then
            OPENED_ARC = true
            RemoveBlocks()
            stat.page = "ARCPAGE"
            local poseur = sprites.CreateSprite("poseur.png", 20000 - 1)
            poseur:MoveTo(TPos(320, 240))
            stat.blocks[#stat.blocks + 1] = poseur
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了传单。",
                "* [fontIndex:2][pattern:chinese]是关于前五个丢失的孩子的。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "[colorHEX:ffff33]* [fontIndex:2][pattern:chinese]为了正义，请不要放弃。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        end
    elseif (item == "[preset=chinese][offsetX=20]吃我") then
        if  (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]这么想被吃就乖乖下肚。",
                "* [fontIndex:2][pattern:chinese]（血量回满了。）",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
            Player.hp = Player.maxhp
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你查看了吃我。",
                "* [fontIndex:2][pattern:chinese]上面写着：[wait:30][fontIndex:1][pattern:english]eat me[fontIndex:2][pattern:chinese]。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif  (choice == 3) then
            local t = typers.CreateText({
                "[colorHEX:ff0000]* [fontIndex:2][pattern:chinese]你丢弃了吃我。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        end
    elseif (item == "[preset=chinese][offsetX=20][red]蜘蛛") then
        if (choice == 1) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你从背包中拿出了[colorHEX:ff0000]蜘蛛[function:drawredSpider][colorHEX:ffffff]。",
                "[noskip][function:RemoveBlocks][function:runSpider][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        elseif (choice == 2) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]蜘蛛[wait:30] - 也许是大螃蟹。",
                "* [fontIndex:2][pattern:chinese]总的来讲，我怕蜘蛛。",
                "[noskip][function:RemoveBlocks][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
        elseif (choice == 3) then
            local t = typers.CreateText({
                "* [fontIndex:2][pattern:chinese]你丢弃了蜘蛛。",
                "* [fontIndex:2][pattern:chinese]但是什么都没发生。",
                "[noskip][sound:snd_phurt.wav][function:RemoveBlocks][function:encounterSpider][next]"
            }, {TPos(60, 400 - 55)}, 10004, {0, 0}, "manual")
            table.remove(stat.items, stat.initem)
        end
    else
        print("Undefined item:", item)
    end
end

return stat