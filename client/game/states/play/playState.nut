local actionType = 0;

function initPlayState()
{
    actionType = 0;

    enable_NicknameId(false);
    enableEvent_RenderFocus(true);
    setHudMode(HUD_FOCUS_NAME, HUD_MODE_HIDDEN);
    setHudMode(HUD_FOCUS_BAR, HUD_MODE_HIDDEN);
    Player.music.stop();
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;
    Chat.Init();
    Showcase.Init();
    Inventory.Init();
    setupStatistics();
    initSettings();
    EscMenu.Init();
    initInterface();
    initPlayerInteraction();

    disableLogicalKey(GAME_END, true);
    disableLogicalKey(GAME_INVENTORY, true);
    disableLogicalKey(GAME_SCREEN_STATUS, true);
    disableLogicalKey(GAME_SCREEN_MAP, true);
    disableLogicalKey(GAME_SCREEN_LOG, true);

    initInteraction();
    initNpcs();
    setPlayerStrength(heroId, 100);

    Player.refreshEq(2);
    Player.refreshEq(4);
    Player.refreshEq(16);

    initQA();
    initMap();
    initNpcTrade();

    initFaction();
    initPlayerList();
    initHelp();

    helperAction(true);
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
    //startBuffs();
}

function onClearMessage(data)
{
    Chat.Add([data[0], data[1], data[2], data[3]]);
}

function onMessageOOC(data)
{
    Chat.Add([data[0], data[1], data[2], "(OOC) " + data[3] + ": "], data[4]);
}

function onMessageCry(data)
{
    Chat.Add([data[0], data[1], data[2], data[3] + " krzyczy " + data[4]]);
}

function onSlidePlay(el)
{
    onInvSlide(el);
    onTradeSlide(el);
    onSettingsSlide(el);
}

function onRenderP(currentTime, lastTime)
{
    globalNpcRender();
    handleQARender();
    npcInteractionHandler();
    mapRender();
    tradeRender();
    gi_render();
    statisticsRender();
    escMenuRender();
    invRender();
}

function getActionType()
{
    return actionType;
}

function handleAction(key)
{
    if (key == KEY_Z && DEBUG)
    {
        exitGame();
    }

    switch(actionType)
    {
        // free gaming :)
        case 0:
            freeAction(key);
        break;

        // chat opened
        case 1:
            chatAction(key);
        break;

        // escape menu opened :)
        case 2:
            rawOnKey(key);
            escMenuAction(key);
        break;

        // npc interaction
        case 3:
            interactionAction(key);
        break;

        case 5:
            animListKey(key);
        break;

        case 6:
            playerInteractionKey(key);
        break;

    }
}
addEventHandler("onKey", handleAction);

function resetAction()
{
    actionType = 0;
}

function helperAction(val = false)
{
    enableQA(val);
    Chat.Enable(val);
    enableTimeDraws(val);
}

function launchFree()
{
    actionType = 0;
    helperAction(true);
}

function setActionType(typ)
{
    actionType = typ;
}

function freeAction(key)
{
    switch(key)
    {
        case KEY_T:
            actionType = 1;
            Chat.EnableInput(true);
        break;

        case KEY_V:
            sendPacket(PacketType.TEST, 0);
        break;

        case KEY_C:
            actionType = 2;
            helperAction();
            EscMenu.Enable(true, 3);
        break;

        case KEY_TAB:
        case KEY_I:
            actionType = 2;
            helperAction();
            EscMenu.Enable(true, 2);
        break;

        case KEY_M:
            actionType = 2;
            helperAction();
            EscMenu.Enable(true, 1);
        break;

        case KEY_LCONTROL:
            gi_key();
            local result = focusInteract_NPC();
            if (result == true)
            {
                actionType = 3;
                return;
            }

            focusInteract_Player();
        break;

        case KEY_ESCAPE:
            actionType = 2;
            helperAction();
            EscMenu.Enable(true);
        break;

        default:
            handleQAKey(key);
        break;
    }
}


function chatAction(key)
{
    switch(key)
    {
        case KEY_RETURN:
            resetAction();
            Chat.Send();
        break;

        case KEY_ESCAPE:
            resetAction();
            Chat.EnableInput(false);
        break;
    }
}

function inventoryAction(key)
{
    switch(key)
    {
        case KEY_TAB:
        case KEY_I:
            escMenuAction(KEY_ESCAPE);
        break;
    }
}

function mapAction(key)
{
    switch(key)
    {
        case KEY_M:
            escMenuAction(KEY_ESCAPE);
        break;
    }
}

function statisticsAction(key)
{
    switch(key)
    {
        case KEY_C:
            if (!statsCanUseKeys() && getCurrentSubmenu() == 3)
            {
                statsCannotUseKeys(key);
                return;
            }

            escMenuAction(KEY_ESCAPE);
        break;
    }
}

function settingsAction(key)
{

}

function escMenuAction(key)
{
    switch(key)
    {
        case KEY_ESCAPE:
        // case KEY_X:
            if (!statsCanUseKeys() && getCurrentSubmenu() == 3)
            {
                statsCannotUseKeys(key);
                return;
            }

            resetAction();
            EscMenu.Enable(false);

            helperAction(true);
            return;
        break;
    }

    local submenu = getCurrentSubmenu();
    switch(submenu)
    {
        case -1: // no submenu

        break;

        case 1: // map
            mapAction(key)
        break;

        case 2: // eq
            inventoryAction(key);
        break;

        case 3: // stats
            statisticsAction(key);
        break;

        case 4: // settings
            settingsAction(key);
        break;
    }
}

function interactionAction(key)
{
    if (isTradeEnabled())
    {
        return tradeKey(key);
    }

    switch(key)
    {
        case KEY_SPACE:
            skip_dial();
        break;

        case KEY_1:
            check_dialog(0);
        break;

        case KEY_2:
            check_dialog(1);
        break;

        case KEY_3:
            check_dialog(2);
        break;

        case KEY_4:
            check_dialog(3);
        break;

        case KEY_5:
            check_dialog(4);
        break;
    }
}

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

    if (isSecMenuEnabled())
    {
        return secMenuBtnPress(id);
    }

    if (isPlayerListEnabled())
    {
        return playerListBtn(id);
    }

    if (isAnimListEnabled())
    {
        return animListBtn(id);
    }

    if (isPlayerInteractionEnabled())
    {
        return playerInteractionBtn(id);
    }

    npcButtonHandler(id);
}

function onClickPlay(key)
{
    tradeClick(key);
    escMenuClickPress(key);
    animMouseClick(key);
}

function onReleasePlay(key)
{
    tradeRelease(key);
    escMenuClickRelease(key);
    animMouseRelease(key);
}

function handlePlayerRespawn(id)
{
    playAni(id, "S_RUN");
    // cancel anim
    if (id == heroId)
    {
        setFreeze(false);
    }
}

function handlePlayerDeath(id, sec)
{
    playAni(id, "T_DEADB");
    // play anim
    if (id == heroId)
    {
        setFreeze(true);
        startDeathDraw(sec);
    }
}

