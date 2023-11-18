class Player
{
    constructor()
    {

    }
}

function initPlayState()
{
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;

    Chat.Init();
    Chat.Enable(true);
}