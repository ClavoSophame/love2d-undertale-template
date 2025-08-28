return {
    EncounterText = "* [pattern:chinese]你什么都没遭遇到！",
    Enemies = {
        Poseur = {
            Name = "[preset=chinese]颇似儿",
            Actions = {
                "[preset=chd]查看", "[preset=chd]欣赏"
            }
        },
        TheOther = {
            Name = "[preset=chinese]敌人名称",
            Actions = {
                "[preset=chd]查看", "[preset=chd]欣赏"
            }
        },
    },
    Items = {
        Chocolate = "[preset=chinese]巧克力",
        End = "[preset=chinese]我是你的老婆"
    },
    ItemsPage = "[preset=chd]第  页[font=determination_mono.ttf][scale=1][offsetX=-82]",
    Spare = "[preset=chinese]饶恕",
    Flee = "[preset=chinese]逃跑",

    FleeTexts = {
        "* [pattern:chinese]你逃出了战斗。\n[pattern:english]* [pattern:chinese]你感到神清气爽。"
    },

    Act11 = {
        "* [pattern:chinese]颇似儿[pattern:english] - 1 [pattern:chinese]攻[pattern:english] 99 [pattern:chinese]防[wait:30][pattern:english] \n* [pattern:chinese]默认敌人.", 
        "[colorHEX:9900ff]* [pattern:chinese]承载着温暖的回忆..."
    },
    Act12 = {
        "* [pattern:chinese]你和颇似儿一起摆姿势。\n[pattern:english][colorHEX:00ffff]* [pattern:chinese]时间似乎静止在了这一刻...", 
        "* [pattern:chinese]享受这段时光吧！"
    },
    Act21 = {
        "* [pattern:chinese]敌人名称[pattern:english] - 1 [pattern:chinese]攻[pattern:english] 99 [pattern:chinese]防[wait:30][pattern:english] \n* [pattern:chinese]默认敌人的朋友.", 
        "[colorHEX:9900ff]* [pattern:chinese]也承载着温暖的回忆..."
    },
    Act22 = {
        "* [pattern:chinese]你和不知名的敌人一起摆姿势。\n[pattern:english][colorHEX:00ffff]* [pattern:chinese]时间似乎静止在了这一刻...", 
        "[colorHEX:99ff99]* [pattern:chinese]享受这段时光吧！！！"
    },

    GameoverText = {
        "[voice:v_fluffybuns.wav][speed:0.5]* [pattern:chinese]我们的命运\n  都寄托于你...",
        "[voice:v_fluffybuns.wav][speed:0.5]* %s!\n* [pattern:chinese]保持你的决心.",
    }
}
