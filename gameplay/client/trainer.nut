/// DIAL OPT 1
function DIALOG_TRAINER_1_1()
{
    play_gest(HERO);
    update_dialog("Czy mo?esz mnie czego? nauczy??");
    play_sound("DIA_ADDON_BONES_TRAIN_15_00.WAV");

    next_dial(DIALOG_TRAINER_1_2);
}

function DIALOG_TRAINER_1_2()
{
    finish_dial();
    show_dialog_menu([
        {
            text = "+ 5 si?y",
            event = DIALOG_TRAINER_1_2_A_1
        },
        {
            text = "+ 10 si?y",
            event = DIALOG_TRAINER_1_2_B_1
        },
        {
            text = "+ 20 si?y",
            event = DIALOG_TRAINER_1_2_C_1
        },
    ]);
}

function DIALOG_TRAINER_1_2_A_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_STRENGTH, 5);
}

function DIALOG_TRAINER_1_2_B_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_STRENGTH, 10);
}

function DIALOG_TRAINER_1_2_C_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_STRENGTH, 20);
}

/// DIAL OPT 2
function DIALOG_TRAINER_2_1()
{
    play_gest(HERO);
    update_dialog("Czy mo?esz mnie czego? nauczy??");
    play_sound("DIA_ADDON_BONES_TRAIN_15_00.WAV");

    next_dial(DIALOG_TRAINER_2_2);
}

function DIALOG_TRAINER_2_2()
{
    finish_dial();
    show_dialog_menu([
        {
            text = "+ 5 zwinno?ci",
            event = DIALOG_TRAINER_2_2_A_1
        },
        {
            text = "+ 10 zwinno?ci",
            event = DIALOG_TRAINER_2_2_B_1
        },
        {
            text = "+ 20 zwinno?ci",
            event = DIALOG_TRAINER_2_2_C_1
        },
    ]);
}

function DIALOG_TRAINER_2_2_A_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_DEXTERITY, 5);
}

function DIALOG_TRAINER_2_2_B_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_DEXTERITY, 10);
}

function DIALOG_TRAINER_2_2_C_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_DEXTERITY, 20);
}

/// DIAL OPT 3
function DIALOG_TRAINER_3_1()
{
    play_gest(HERO);
    update_dialog("Czy mo?esz mnie czego? nauczy??");
    play_sound("DIA_ADDON_BONES_TRAIN_15_00.WAV");

    next_dial(DIALOG_TRAINER_3_2);
}

function DIALOG_TRAINER_3_2()
{
    finish_dial();
    show_dialog_menu([
        {
            text = "+ 5 hp",
            event = DIALOG_TRAINER_3_2_A_1
        },
        {
            text = "+ 10 hp",
            event = DIALOG_TRAINER_3_2_B_1
        },
        {
            text = "+ 20 hp",
            event = DIALOG_TRAINER_3_2_C_1
        },
    ]);
}

function DIALOG_TRAINER_3_2_A_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_HEALTH, 5);
}

function DIALOG_TRAINER_3_2_B_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_HEALTH, 10);
}

function DIALOG_TRAINER_3_2_C_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_HEALTH, 20);
}

/// DIAL OPT 4
function DIALOG_TRAINER_4_1()
{
    play_gest(HERO);
    update_dialog("Czy mo?esz mnie czego? nauczy??");
    play_sound("DIA_ADDON_BONES_TRAIN_15_00.WAV");

    next_dial(DIALOG_TRAINER_4_2);
}

function DIALOG_TRAINER_4_2()
{
    finish_dial();
    show_dialog_menu([
        {
            text = "+ 5 walki 1h",
            event = DIALOG_TRAINER_4_2_A_1
        },
        {
            text = "+ 10 walki 1h",
            event = DIALOG_TRAINER_4_2_B_1
        },
        {
            text = "+ 20 walki 1h",
            event = DIALOG_TRAINER_4_2_C_1
        },
    ]);
}

function DIALOG_TRAINER_4_2_A_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_1H, 5);
}

function DIALOG_TRAINER_4_2_B_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_1H, 10);
}

function DIALOG_TRAINER_4_2_C_1()
{
    finish_dial();
    show_dialog_menu(BOT.holder);
    sendPacket(PacketType.LEARN_1H, 20);
}

// DIALOG OPT 5
function DIALOG_TRAINER_5_1()
{
    play_gest(HERO);
    update_dialog("Jeszcze si? spotkamy");
    play_sound("DIA_GORNOW_SEEYOU_15_00.WAV");

    next_dial(DIALOG_TRAINER_5_2);
}

function DIALOG_TRAINER_5_2()
{
    start_exiting();
}

function initTrainer()
{
    local npc = NPC(lang["TRAINER"][Player.lang], -93537.2, 302.344, -116443, 136.579);
    npc.spawn();

    equipItem(npc.npc, Items.id("ITAR_SMITH"));
    setPlayerVisual(npc.npc, BodyModel[0], 2, HeadModel[3], 17);
    npc.playAni("S_HGUARD")

    npc.draw.setLineText(2, lang["TRAINER"][Player.lang]);
    npc.draw.setLineText(3, "Hukacz");
    npc.draw.setLineColor(2, 220, 240, 250);
    npc.draw.setLineColor(3, 160, 160, 255);

    npc.holder = [
        {
            text = "Chc? trenowa? si??",
            event = DIALOG_TRAINER_1_1
        },
        {
            text = "Chc? trenowa? zwinno??",
            event = DIALOG_TRAINER_2_1
        },
        {
            text = "Chc? trenowa? ?ycie xD",
            event = DIALOG_TRAINER_3_1
        },
        {
            text = "Chc? trenowa? walke 1h",
            event = DIALOG_TRAINER_4_1
        },
        {
            text = "Nara",
            event = DIALOG_TRAINER_5_1
        }
    ];

    npc.event = function() {
        show_dialog_menu(npc.holder);
    };
}