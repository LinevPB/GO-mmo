local mainWindow = null;
local tradeEnabled = false;
local tradeButton = null;
local exitButton = null;

function isTradeEnabled()
{
    return tradeEnabled;
}

function initNpcTrade()
{
    mainWindow = Window(0, 0, 8192, 8192, "BACKGROUND_BORDERLESS.TGA");

    local playerInv = initPlayerWindow();
    local npcInv = initNpcWindow();

    mainWindow.attach(playerInv);
    mainWindow.attach(npcInv);

    tradeButton = Button(2800 + 296, 6500 + 196, 1000, 400, "BUTTON_BACKGROUND.TGA", lang["TRADE"][Player.lang], "BUTTON_BG.TGA");
    tradeButton.setBackgroundRegularColor(200, 20, 20);
    tradeButton.setBackgroundHoverColor(150, 20, 20);

    exitButton = Button(2800 + 296, 7100 + 196, 1000, 400, "BUTTON_BACKGROUND.TGA", lang["EXIT"][Player.lang], "BUTTON_BG.TGA");
    exitButton.setBackgroundRegularColor(200, 20, 20);
    exitButton.setBackgroundHoverColor(150, 20, 20);

    mainWindow.attach(tradeButton);
    mainWindow.attach(exitButton);

    initPlayerSlots();
    initNpcSlots();
    initTradeShowcase();
    TradeBox.Init();
    initTradeNotify();
}

function enableNpcTrade(val, soft = false)
{
    if (!soft)
    {
        setFreeze(val);
        disableControls(val);

        if (val == true)
            setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
        else
            setHudMode(HUD_ALL, HUD_MODE_DEFAULT);

        setCursorVisible(val);
    }
    else
    {
        setCursorVisible(soft);
    }
    ///////

    mainWindow.enable(val);
    enablePlayerWindow(val);
    enableNpcWindow(val);

    if (TradeBox.IsEnabled() && val == false)
    {
        TradeBox.Enable(false);
    }

    tradeEnabled = val;

    if (val == false)
    {
        clearNpcBasket();
        clearPlayerBasket();
        clearNpcInventory();

        if (Showcase.IsEnabled())
        {
            Showcase.Enable(false);
        }

        enableTradeShowcase(false);
    }
}

function tradeButtonHandler(id)
{
    if (id == TradeBox.GetCancelBtn())
    {
        TradeBox.Enable(false);
    }

    if (id == TradeBox.GetOkBtn())
    {
        return tradeConfirmBox();
    }

    if (id == tradeButton.id)
    {
        // handle player basket
        local playerBasket = getPlayerBasketItems();
        local npcBasket = getNpcBasketItems();

        local transformPlayer = [];
        foreach(v in playerBasket)
        {
            transformPlayer.append(v.instance);
            transformPlayer.append(v.amount);
        }

        if (transformPlayer.len() == 0)
        {
            transformPlayer = [0];
        }

        sendArray(PacketType.TRADE_PLAYER_BASKET, transformPlayer);

        // handle npc basket
        local transformNpc = [];
        foreach(v in npcBasket)
        {
            transformNpc.append(v.instance);
            transformNpc.append(v.amount);
        }

        if (transformNpc.len() == 0)
        {
            transformNpc = [0];
        }

        sendArray(PacketType.TRADE_NPC_BASKET, transformNpc);
    }
    else if (id == exitButton.id)
    {
        enableNpcTrade(false, true);
    }
}

function calcGoldAmount(val = false)
{
    if (val == false) val = Player.gold;
    local res = "";
    local temp = val + "";
    while(temp.len() > 3) {
        res = "," + temp.slice(temp.len() - 3, temp.len()) + res;
        temp = temp.slice(0, temp.len() - 3);
    }
    res = temp + res;

    return res;
}

function tradeRender()
{
    tradeNotifyRender();

    if (!isTradeEnabled()) return;

    tradeSlotRender();
}

function tradeKey(key)
{
    if (!tradeEnabled) return;
    if (key != KEY_RETURN) return;
    if (!TradeBox.IsEnabled()) return;

    tradeConfirmBox();
}

function handleTradeResult(data)
{
    if (data[0] == 0)
    {
        tradeNotify(lang["TRADE_LITTLE_ORES"][Player.lang]);
        return;
    }

    clearPlayerBasket();
    clearNpcBasket();
    refreshPlayerSlots();
    tradeNotify(lang["TRADE_SUCCESS"][Player.lang]);
}