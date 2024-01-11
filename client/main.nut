function onInit()
{
    initUI();
    initNotifications();
}
addEventHandler("onInit", onInit);


function onMainCreate(id)
{
    if (id != heroId) return;

    ChangeGameState(GameState.LOGIN);

    if (DEBUG)
    {
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onPlayerCreate", onMainCreate);


function onDamage(desc)
{
    cancelEvent();
}
addEventHandler("onDamage", onDamage);
