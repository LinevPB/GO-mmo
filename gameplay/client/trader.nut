/// DIAL OPT 1
function DIALOG_MILKO_1_1()
{
    play_gest(HERO);
    update_dialog("Where can I get apple tobbaco?");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_1_2);
}

function DIALOG_MILKO_1_2()
{
    play_gest(BOT);
    update_dialog("I shall give you two portions. It is up to you, in your wisdom, to do with them whatever you want");
    play_sound("DIA_ABUYIN_WOHER_13_01.WAV");

    next_dial(DIALOG_MILKO_1_3);
}

function DIALOG_MILKO_1_3()
{
    play_gest(BOT);
    update_dialog("If you crave more then direct your steps to Zuris - the master of portions. He produces this tobbaco and he sells it too.");
    play_sound("DIA_ABUYIN_WOHER_13_02.WAV");

    next_dial(DIALOG_MILKO_1_4);
}

function DIALOG_MILKO_1_4()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
}

// DIAL OPT 2
function DIALOG_MILKO_2_1()
{
    play_gest(HERO);
    update_dialog("Show me your goods");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_2_2);
}

function DIALOG_MILKO_2_2()
{
    play_gest(BOT);
    update_dialog("Choose yourself");
    play_sound("DIA_ABUYIN_WOHER_13_01.WAV");

    next_dial(DIALOG_MILKO_2_3);
}

function DIALOG_MILKO_2_3()
{
    show_dialog_menu(BOT.holder);
    open_shop(Shop.Milko);
}

// DIAL OPT 3
function DIALOG_MILKO_3_1()
{
    play_gest(HERO);
    update_dialog("What can you tell me about pirates?");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_3_2);
}

function DIALOG_MILKO_3_2()
{
    play_gest(BOT);
    update_dialog("I dont know anything!");
    play_sound("DIA_ABUYIN_WOHER_13_01.WAV");

    next_dial(DIALOG_MILKO_3_3);
}

function DIALOG_MILKO_3_3()
{
    finish_dial();
    show_dialog_menu([
        {
            text = "(Propose gold)",
            event = DIALOG_MILKO_3_1_A_1
        },
        {
            text = "(Threaten)",
            event = DIALOG_MILKO_3_1_B_1
        },
        {
            text = "Okay, nevermind.",
            event = DIALOG_MILKO_3_1_C_1
        },
    ]);
}

// DIAL OPT 3_1_A
function DIALOG_MILKO_3_1_A_1()
{
    play_gest(HERO);
    update_dialog("I'll give you 20 gold");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_3_1_A_2);
}

function DIALOG_MILKO_3_1_A_2()
{
    play_gest(BOT);
    update_dialog("Now you are talking!");
    play_sound("DIA_ABUYIN_WOHER_13_01.WAV");

    next_dial(DIALOG_MILKO_3_1_A_3);
}

function DIALOG_MILKO_3_1_A_3()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
}

// DIAL OPT 3_1_B
function DIALOG_MILKO_3_1_B_1()
{
    play_gest(HERO);
    update_dialog("Tell me or I'll..");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_3_1_B_2);
}

function DIALOG_MILKO_3_1_B_2()
{
    play_gest(BOT);
    update_dialog("Or you'll what?");
    play_sound("DIA_ABUYIN_WOHER_13_01.WAV");

    next_dial(DIALOG_MILKO_3_1_B_3);
}

function DIALOG_MILKO_3_1_B_3()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
}

// DIAL OPT 3_1_C
function DIALOG_MILKO_3_1_C_1()
{
    play_gest(HERO);
    update_dialog("Nevermind..");
    play_sound("DIA_ABUYIN_WOHER_15_00.WAV");

    next_dial(DIALOG_MILKO_3_1_C_2);
}

function DIALOG_MILKO_3_1_C_2()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
}

/// DIAL OPT 4
function DIALOG_MILKO_4_1()
{
    play_gest(HERO);
    update_dialog("We'll meet again");
    play_sound("DIA_GORNOW_SEEYOU_15_00.WAV");

    next_dial(DIALOG_MILKO_4_2);
}

function DIALOG_MILKO_4_2()
{
    start_exiting();
}

function initTrader()
{
    local npc = NPC(lang["TRADER"][Player.lang], 887.266, 247.734, 1057.5, 180.003);
    npc.spawn();

    equipItem(npc.npc, Items.id("ItAr_Vlk_H"));
    setPlayerVisual(npc.npc, BodyModel[0], 3, HeadModel[1], 12);
    npc.playAni("S_HGUARD")

    npc.draw.setLineText(2, lang["TRADER"][Player.lang]);
    npc.draw.setLineText(3, "Milko");
    npc.draw.setLineColor(2, 220, 240, 250);
    npc.draw.setLineColor(3, 160, 160, 255);

    npc.holder = [
        {
            text = "Where can I get apple tobbaco?",
            event = DIALOG_MILKO_1_1
        },
        {
            text = "Show me your goods",
            event = DIALOG_MILKO_2_1
        },
        {
            text = "What do you know about pirates?",
            event = DIALOG_MILKO_3_1
        },
        {
            text = "See you",
            event = DIALOG_MILKO_4_1
        }
    ];

    npc.event = function() {
        show_dialog_menu(npc.holder);
    };
}