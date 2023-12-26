function onInit()
{
    initUI();
    initNotifications();

    ChangeGameState(GameState.LOGIN);

    if (DEBUG)
    {
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onInit", onInit);
