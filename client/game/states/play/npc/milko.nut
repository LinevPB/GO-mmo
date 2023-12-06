local OPT_1_01 = Sound("DIA_ABUYIN_WOHER_15_00.WAV");
local OPT_1_02 = Sound("DIA_ABUYIN_WOHER_13_01.WAV");
local OPT_1_03 = Sound("DIA_ABUYIN_WOHER_13_02.WAV");

local OPT_5_01 = Sound("DIA_GORNOW_SEEYOU_15_00.WAV");

/// DIAL OPT 1
function DIALOG_MILKO_1()
{
    play_gest(HERO);
    update_dialog("Where can I get apple tobbaco?");
    OPT_1_01.play();

    next_dial(DIALOG_MILKO_1_2, OPT_1_01.playingTime);
}

function DIALOG_MILKO_1_2()
{
    OPT_1_01.stop();
    play_gest(BOT);
    update_dialog("I shall give you two portions. It is up to you, in your wisdom, to do with them whatever you want");
    OPT_1_02.play();

    next_dial(DIALOG_MILKO_1_3, OPT_1_02.playingTime);
}

function DIALOG_MILKO_1_3()
{
    OPT_1_02.stop();
    play_gest(BOT);
    update_dialog("If you crave more then direct your steps to Zuris - the master of portions. He produces this tobbaco and he sells it too.");
    OPT_1_03.play();

    next_dial(DIALOG_MILKO_1_4, OPT_1_03.playingTime);
}

function DIALOG_MILKO_1_4()
{
    OPT_1_03.stop();
    finish_dial();
}

/// DIAL OPT 5
function DIALOG_MILKO_5()
{
    play_gest(HERO);
    update_dialog("We'll meet again");
    OPT_5_01.play();

    next_dial(DIALOG_MILKO_5_2, OPT_5_01.playingTime);
}

function DIALOG_MILKO_5_2()
{
    OPT_5_01.stop();
    start_exiting();
}

function initMilko()
{
    local npc = NPC("Zbysiu", 887.266, 247.734, 1057.5, 180.003);
    npc.spawn();

    equipItem(npc.npc, Items.id("ItAr_Vlk_H"));
    setPlayerVisual(npc.npc, Player.bodyModel[0], 3, Player.headModel[1], 12);
    npc.playAni("S_HGUARD")

    npc.draw.insertText("Trader");
    npc.draw.insertText("Milko");
    npc.draw.setLineColor(0, 100, 255, 100);

    npc.holder = [
        {
            text = "Where can I get apple tobbaco?",
            event = DIALOG_MILKO_1
        },
        {
            text = "See you",
            event = DIALOG_MILKO_5
        }
    ];

    npc.event = function() {
        show_dialog_menu(npc.holder);
    };
}