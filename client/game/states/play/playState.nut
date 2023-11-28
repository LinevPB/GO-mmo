local coverTex = null;
local QA_Slot1 = null;
local QA_Slot2 = null;
local QA_Slot3 = null;
local QA_Slot4 = null;
local QA_Render1 = null;
local QA_Render2 = null;
local QA_Render3 = null;
local QA_Render4 = null;
local QA_Draw1 = null;
local QA_Draw2 = null;
local QA_Draw3 = null;
local QA_Draw4 = null;

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

    coverTex = Texture(8192/2 - 1000, 8192-1000, 2000, 500, "SR_BLANK.TGA");
    coverTex.setColor(10, 10, 40);
    QA_Slot1 = Texture(coverTex.getPosition().x, coverTex.getPosition().y, 500, 500, "MENU_INGAME.TGA");
    QA_Slot2 = Texture(coverTex.getPosition().x + 500, coverTex.getPosition().y, 500, 500, "MENU_INGAME.TGA");
    QA_Slot3 = Texture(coverTex.getPosition().x + 1000, coverTex.getPosition().y, 500, 500, "MENU_INGAME.TGA");
    QA_Slot4 = Texture(coverTex.getPosition().x + 1500, coverTex.getPosition().y, 500, 500, "MENU_INGAME.TGA");
    QA_Render1 = ItemRender(QA_Slot1.getPosition().x, QA_Slot1.getPosition().y, QA_Slot1.getSize().width, QA_Slot1.getSize().height, "ITFO_APPLE");
    QA_Render2 = ItemRender(QA_Slot2.getPosition().x, QA_Slot2.getPosition().y, QA_Slot2.getSize().width, QA_Slot2.getSize().height, "ITFO_APPLE");
    QA_Render3 = ItemRender(QA_Slot3.getPosition().x, QA_Slot3.getPosition().y, QA_Slot3.getSize().width, QA_Slot3.getSize().height, "ITFO_APPLE");
    QA_Render4 = ItemRender(QA_Slot4.getPosition().x, QA_Slot4.getPosition().y, QA_Slot4.getSize().width, QA_Slot4.getSize().height, "ITFO_APPLE");
    QA_Draw1 = Draw(QA_Slot1.getPosition().x, QA_Slot1.getPosition().y, "F1");
    QA_Draw2 = Draw(QA_Slot2.getPosition().x, QA_Slot2.getPosition().y, "F2");
    QA_Draw3 = Draw(QA_Slot3.getPosition().x, QA_Slot3.getPosition().y, "F3");
    QA_Draw4 = Draw(QA_Slot4.getPosition().x, QA_Slot4.getPosition().y, "F4");
    QA_Draw1.setPosition(QA_Slot1.getPosition().x + QA_Slot1.getSize().width - QA_Draw1.width -20, QA_Slot1.getPosition().y + QA_Slot1.getSize().height - QA_Draw1.height -20);
    QA_Draw2.setPosition(QA_Slot2.getPosition().x + QA_Slot2.getSize().width - QA_Draw1.width -20, QA_Slot2.getPosition().y + QA_Slot2.getSize().height - QA_Draw2.height -20);
    QA_Draw3.setPosition(QA_Slot3.getPosition().x + QA_Slot3.getSize().width - QA_Draw1.width -20, QA_Slot3.getPosition().y + QA_Slot3.getSize().height - QA_Draw3.height -20);
    QA_Draw4.setPosition(QA_Slot4.getPosition().x + QA_Slot4.getSize().width - QA_Draw1.width -20, QA_Slot4.getPosition().y + QA_Slot4.getSize().height - QA_Draw4.height -20);
    QA_Draw1.setColor(240, 220, 180);
    QA_Draw2.setColor(240, 220, 180);
    QA_Draw3.setColor(240, 220, 180);
    QA_Draw4.setColor(240, 220, 180);

    coverTex.visible = true;

    QA_Slot1.visible = true;
    QA_Render1.visible = true;
    QA_Draw1.visible = true;

    QA_Slot2.visible = true;
    QA_Render2.visible = true;
    QA_Draw2.visible = true;

    QA_Slot3.visible = true;
    QA_Render3.visible = true;
    QA_Draw3.visible = true;

    QA_Slot4.visible = true;
    QA_Render4.visible = true;
    QA_Draw4.visible = true;
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
            Inventory.Enable(false);
        }
        else
        {
            Inventory.Enable(true);
        }
    }

    if (key == KEY_ESCAPE && Inventory.IsEnabled())
    {
        Inventory.Enable(false);
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
}
addEventHandler("onKey", onplaykey);

function playButtonHandler(id)
{
    if (Inventory.IsEnabled())
    {
        return INVplayButtonHandler(id);
    }

    npcButtonHandler(id);
}