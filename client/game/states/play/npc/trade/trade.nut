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
    mainWindow = Window(0, 0, 8192, 8192, "SR_BLANK.TGA");
    mainWindow.setBackgroundColor(10, 10, 20);
    mainWindow.setCover("MENU_INGAME.TGA");

    local playerInv = initPlayerWindow();
    local npcInv = initNpcWindow();

    mainWindow.attach(playerInv);
    mainWindow.attach(npcInv);

    tradeButton = Button(2800 + 296, 6500 + 196, 1000, 400, "MENU_CHOICE_BACK.TGA", lang["TRADE"][Player.lang], "INV_TITEL.TGA");
    exitButton = Button(2800 + 296, 7100 + 196, 1000, 400, "MENU_CHOICE_BACK.TGA", lang["EXIT"][Player.lang], "INV_TITEL.TGA");

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