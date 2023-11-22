function initPlayState()
{
    Player.music.stop();
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;

    Chat.Init();
    Chat.Enable(true);

    Inventory.Init();
    Inventory.Enable(true);

    setPlayerPosition(heroId, 0, 0, 0);
}

function onMessage(data)
{
    Chat.Add([data[0], data[1], data[2], data[3]], data[4]);
}

function onRenderP(currentTime, lastTime)
{
}

local function onkey(key)
{
    if (key == KEY_Z) {
        exitGame();
    }
    if (key == KEY_X) {
        Inventory.Enable(true);
    }
    if (key == KEY_V) {
        Inventory.Enable(false);
    }
}

addEventHandler("onKey", onkey);