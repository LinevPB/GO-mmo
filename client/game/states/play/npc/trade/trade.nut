local mainWindow = null;
local tradeEnabled = false;

function isTradeEnabled()
{
    return tradeEnabled;
}

function initNpcTrade()
{
    mainWindow = Window(0, 0, 8192, 8192, "SR_BLANK.TGA");
    mainWindow.setBackgroundColor(10, 10, 25);
    mainWindow.setCover("MENU_INGAME.TGA");

    local playerInv = initPlayerWindow();
    local npcInv = initNpcWindow();

    mainWindow.attach(playerInv);
    mainWindow.attach(npcInv);

    initPlayerSlots();
    initNpcSlots();
}

function enableNpcTrade(val)
{
    setFreeze(val);
    disableControls(val);
    ///////

    setCursorVisible(val);
    mainWindow.enable(val);
    enablePlayerWindow(val);
    enableNpcWindow(val);

    if (val == true)
    {
        tradeEnabled = true;
        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);

        return;
    }

    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    tradeEnabled = false;
}
