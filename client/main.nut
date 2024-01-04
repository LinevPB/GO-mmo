function onInit()
{
    initUI();
    initNotifications();

    ChangeGameState(GameState.LOGIN);

    // Sky.setPlanetColor(PLANET_MOON, 220, 140, 20, 200);
    // Sky.setPlanetColor(PLANET_SUN, 220, 140, 20, 200);
    // Sky.setCloudsColor(220, 140, 20);
    // Sky.setLightingColor(255, 140, 20);
    // Sky.setFogColor(0, 220, 140, 20);

    if (DEBUG)
    {
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onInit", onInit);
