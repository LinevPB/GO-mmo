function onInit()
{
    // setPlayerStrength(heroId, 2000);
    // giveItem(heroId, Items.id("ITMW_ADDON_HACKER_1H_01"), 1);
    // giveItem(heroId, Items.id("ITMW_ADDON_HACKER_1H_02"), 1);
    // giveItem(heroId, Items.id("ITMW_1H_SPHAGA"), 1);
    // giveItem(heroId, Items.id("ITMW_DARKSAGA_SWORD_2x2_01"), 1);
    // giveItem(heroId, Items.id("ITMW_DARKSAGA_SWORD_2x2_02"), 1);
    // giveItem(heroId, Items.id("ITMW_DARKSAGA_SWORD_2x2_03"), 1);
    // giveItem(heroId, Items.id("ITMW_DARKSAGA_SWORD_2x2_04"), 1);
    // giveItem(heroId, Items.id("ITMW_DARKSAGA_SWORD_2x2_05"), 1);

    // return;
    initUI();
    initNotifications();

    ChangeGameState(GameState.LOGIN);

    if (DEBUG) {
        debug_func();
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onInit", onInit);