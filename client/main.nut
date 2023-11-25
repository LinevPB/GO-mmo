function onInit()
{
    initUI();
    initNotifications();
    ChangeGameState(GameState.LOGIN);
    if (DEBUG) {
        debug_func();
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onInit", onInit);