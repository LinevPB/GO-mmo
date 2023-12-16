function initPlayState()
{
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
    Chat.Enable(true);
    Showcase.Init();
    Inventory.Init();
    setupStatistics();
    initSettings();
    EscMenu.Init();
    initDeathDraw();
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
    //startBuffs();
}

function onSlidePlay(el)
{
    onInvSlide(el);
    onTradeSlide(el);
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
}

local isInAction = false;
local actionType = 0;

function handleAction(key)
{
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

        // inventory opened
        case 2:
            inventoryAction(key);
        break;

        // map opened
        case 3:
            mapAction(key);
        break;

        // npc interaction
        case 4:
            interactionAction(key);
        break;

        // escape menu opened :)
        case 5:
            escMenuAction(key);
        break;
    }
}
addEventHandler("onKey", handleAction);

function resetAction()
{
    actionType = 0;
}

function freeAction(key)
{
    switch(key)
    {
        case KEY_T:
            actionType = 1;
            Chat.EnableInput(true);
        break;

        case KEY_TAB:
        case KEY_I:
            actionType = 2;
            enableQA(false);
            Inventory.Enable(true);
        break;

        case KEY_M:
            actionType = 3;
            enableMap(true);
        break;

        case KEY_LCONTROL:
            gi_key();
            local result = focusInteract_NPC();
            if (result == true)
            {
                actionType = 4;
            }
        break;

        case KEY_X:
            actionType = 5;
            enableQA(false);
            EscMenu.Enable(true);
        break;

        case KEY_Z:
            exitGame();
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
        case KEY_ESCAPE:
            resetAction();
            Inventory.Enable(false);
            enableQA(true);
        break;
    }
}

function mapAction(key)
{
    switch(key)
    {
        case KEY_M:
            resetAction();
            enableMap(false);
        break;
    }
}

function escMenuAction(key)
{
    switch(key)
    {
        case KEY_ESCAPE:
        case KEY_X:
            resetAction();
            EscMenu.Enable(false);
            enableQA(true);
        break;
    }
}

function interactionAction(key)
{
    tradeKey(key);

    switch(key)
    {
        case KEY_SPACE:
            skip_dial();
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

    npcButtonHandler(id);
}

function onClickPlay(key)
{
    tradeClick(key);
    escMenuClickPress(key);
}

function onReleasePlay(key)
{
    tradeRelease(key);
    escMenuClickRelease(key);
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