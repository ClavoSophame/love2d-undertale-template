print(global:GetSaveVariable("Overworld"))

DATA = DATA or global:GetSaveVariable("Overworld") or
{
    time = 0,
    room_name = "--",
    room = "Overworld/scene_ow_ruins_0",
    marker = 2,
    position = {0, 0},
    direction = "down",
    savedpos = false,

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
    },
    chest2 = {
        "[preset=chinese][yellow]看不见我"
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