return {
    EncounterText = "* You encountered nothing!",
    Enemies = {
        Poseur = {
            Name = "Poseur",
            Actions = {
                "Check", "Appreciate"
            }
        },
        TheOther = {
            Name = "EnemyName",
            Actions = {
                "Check", "Appreciate"
            }
        },
    },
    Items = {
        Chocolate = "Chocolate",
        End = "I'm end"
    },
    ItemsPage = "PAGE",
    Spare = "Spare",
    Flee = "Flee",

    FleeTexts = {
        "* You fled from the battle.\n* You feel refreshed."
    },

    Act11 = {
        "* Poseur - 1 ATK 99 DEF[wait:30]\n* The default enemy.", 
        "[colorHEX:9900ff]* Carrying warm memories..."
    },
    Act12 = {
        "* You posed with Poseur.\n[colorHEX:00ffff]* Time seems to have frozen in\n  this moment...", 
        "* Enjoy the time!"
    },
    Act21 = {
        "* Posette - 1 ATK -1 DEF[wait:30]\n* Poseur's friend.",
        "[colorHEX:9900ff]* Carrying warm memories too..."
    },
    Act22 = {
        "* You posed with Posette.\n[colorHEX:00ffff]* Time seems to have frozen in\n  this moment...",
        "[colorHEX:11ff11]* Enjoy the time!!!"
    },

    GameoverText = {
        "[voice:v_fluffybuns.wav][speed:0.5]* Our fate rests\n  upon you...",
        "[voice:v_fluffybuns.wav][speed:0.5]* %s!\n* Stay determined.",
    }
}
