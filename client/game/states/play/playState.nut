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
    Inventory.Init();
    disableLogicalKey(GAME_INVENTORY, true);
    // setPlayerPosition(heroId, 0, 300, 0);
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
}

function onMessage(data)
{
    Chat.Add([data[0], data[1], data[2], data[3]], data[4]);
}

function onRenderP(currentTime, lastTime)
{
    npcInteractionHandler();
    enemyRender();
}

local function onplaykey(key)
{
    if (!Inventory.IsEnabled()) {
        if (key == KEY_T) {
            Chat.EnableInput(true);
        }

        if (key == KEY_RETURN ) {
            Chat.Send();
        }

        if (key == KEY_ESCAPE) {
            Chat.EnableInput(false);
        }
    }

    if (key == KEY_TAB || key == KEY_I) {
        if (Chat.IsEnabled()) return;

        if (Inventory.IsEnabled()) {
            Inventory.Enable(false);
        } else {
            Inventory.Enable(true);
        }
    }

    if (key == KEY_ESCAPE && Inventory.IsEnabled()) {
        Inventory.Enable(false);
    }

    if (key == KEY_Z) {
        exitGame();
    }

    if (key == KEY_X) {
        sendPacket(PacketType.TEST, 0);
    }
    if (key == KEY_V) {
        local pos = getPlayerAngle(heroId);
        print(pos);
    }
}

addEventHandler("onKey", onplaykey);