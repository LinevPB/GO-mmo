function initPlayState()
{
    enable_NicknameId(false);
    enableEvent_RenderFocus(true);
    setHudMode(HUD_FOCUS_NAME, HUD_MODE_HIDDEN);
    Player.music.stop();
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;
    Chat.Init();
    Chat.Enable(true);
    Showcase.Init();
    Inventory.Init();
    disableLogicalKey(GAME_INVENTORY, true);
    setPlayerPosition(Player.helper, 38086, 4681, 44551);
    setPlayerAngle(Player.helper, 250);
    Sky.setPlanetColor(PLANET_MOON, 220, 140, 20, 200);
    Sky.setPlanetColor(PLANET_SUN, 220, 140, 20, 200);
    Sky.setCloudsColor(220, 140, 20);
    Sky.setLightingColor(255, 140, 20);
    Sky.setFogColor(0, 220, 140, 20);

    initInteraction();
    initNpcs();
    setPlayerStrength(heroId, 100);
    applyPlayerOverlay(heroId, Mds.id("HUMANS_SPRINT.MDS"));
    Player.refreshEq(2);
    Player.refreshEq(4);
    Player.refreshEq(16);

    initQA();
    enableQA(true);

    initMap();
    initNpcTrade();
}

function loopedStorm()
{
    addEffect(heroId, "Spellfx_Thunderstorm");
    addEffect(heroId, "Spellfx_Thunderstorm");
    addEffect(heroId, "Spellfx_Thunderstorm");
}

function endBuffs()
{
    setFreeze(false);
    addEffect(heroId, "Spellfx_Fireswordblack");
    addEffect(heroId, "Spellfx_Lightstar_Orange");
    setTimer(loopedStorm, 4000, 3);
}

function BuffTimer()
{
    playAni(heroId, "T_SUMSHOOT_2_STAND");
    addEffect(heroId, "Spellfx_Thunderstorm");
    setTimer(endBuffs, 500, 1);
}

function startBuffs()
{
    addEffect(heroId, "Spellfx_Thunderstorm_Flash");
    addEffect(heroId, "Spellfx_Summonguardian");
    addEffect(heroId, "Spellfx_Innoseye");
    addEffect(heroId, "Spellfx_Weakglimmer_Yellow");
    setFreeze(true);
    playAni(heroId, "T_MAGRUN_2_SUMSHOOT");
    setTimer(BuffTimer, 1000, 1);
}

function onMessage(data)
{
    Chat.Add([data[0], data[1], data[2], data[3]], data[4]);
    startBuffs();
}

function onSlidePlay(el)
{
    onInvSlide(el);
    onTradeSlide(el);
}

function onRenderP(currentTime, lastTime)
{
    handleQARender();
    npcInteractionHandler();
    mapRender();
    tradeRender();
}

local function onplaykey(key)
{
    tradeKey(key);
    if (!Inventory.IsEnabled())
    {
        if (key == KEY_T)
        {
            Chat.EnableInput(true);
        }

        if (key == KEY_RETURN)
        {
            Chat.Send();
        }

        if (key == KEY_ESCAPE)
        {
            Chat.EnableInput(false);
        }
    }

    if (key == KEY_TAB || key == KEY_I)
    {
        if (Chat.IsEnabled()) return;

        if (Inventory.IsEnabled())
        {
            enableQA(true);
            Inventory.Enable(false);
        }
        else
        {
            enableQA(false);
            Inventory.Enable(true);
        }
    }

    if (key == KEY_ESCAPE && Inventory.IsEnabled())
    {
        Inventory.Enable(false);
        enableQA(true);
    }

    if (key == KEY_Z)
    {
        exitGame();
    }

    if (key == KEY_X)
    {
        sendPacket(PacketType.TEST, 0);
    }

    if (key == KEY_V)
    {
        local pos = getPlayerAngle(heroId);
        print(pos);
    }


    if (Inventory.IsEnabled() || Chat.IsEnabled())
    {
        return;
    }
    else {
        mapKey(key);
    }

    handleQAKey(key);
}
addEventHandler("onKey", onplaykey);

function playButtonHandler(id)
{
    if (Inventory.IsEnabled())
    {
        return INVplayButtonHandler(id);
    }

    if (isTradeEnabled())
    {
        return tradeButtonHandler(id);
    }

    npcButtonHandler(id);
}

function onClickPlay(key)
{
    tradeClick(key);
}

function onReleasePlay(key)
{
    tradeRelease(key);
}