local coverTex = null;
local QA_Slots = [];
local QA_Renders = [];
local QAF_Draws = [];
local QAA_Draws = [];

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

    coverTex = Texture(8192/2 - 1400, 8192-1000, 2800, 500, "SR_BLANK.TGA");
    coverTex.setColor(10, 10, 40);
    for(local i = 0;  i < 4; i++)
    {
        QA_Slots.append(Texture(coverTex.getPosition().x + 700 * i, coverTex.getPosition().y, 700, 500, "MENU_INGAME.TGA"));
        QA_Renders.append(ItemRender(QA_Slots[i].getPosition().x + 100, QA_Slots[i].getPosition().y, QA_Slots[i].getSize().width - 200, QA_Slots[i].getSize().height, Player.qa[i]));
        QAF_Draws.append(Draw(QA_Slots[i].getPosition().x, QA_Slots[i].getPosition().y, "F" + (i + 1)));
        QAA_Draws.append(Draw(QA_Slots[i].getPosition().x, QA_Slots[i].getPosition().y, ""));

        QAF_Draws[i].setPosition(QA_Slots[i].getPosition().x + 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAF_Draws[i].height - 5);
        QAF_Draws[i].setColor(240, 180, 50);

        QAA_Draws[i].setPosition(QA_Slots[i].getPosition().x + QA_Slots[i].getSize().width - QAA_Draws[i].width - 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAA_Draws[i].height - 20)
        QAA_Draws[i].setColor(240, 220, 180);
    }

    enableQA(true);
    initMap();

    initNpcTrade();
    //
}

function enableQA(val)
{
    coverTex.visible = val;
    for(local i = 0; i < 4; i++)
    {
        QA_Slots[i].visible = val;
        QA_Renders[i].visible = val;
        QAF_Draws[i].visible = val;
        QAA_Draws[i].visible = val;
    }
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

function handleQARender()
{
    for(local i = 0; i < 4; i++)
    {
        if (Player.qa[i] != QA_Renders[i].instance)
        {
            QA_Renders[i].instance = Player.qa[i];
        }

        foreach(v in Player.items)
        {
            if (v.instance.toupper() != QA_Renders[i].instance.toupper())
            {
                if (QA_Renders[i].instance == "")
                {
                    QAA_Draws[i].text = "";
                }
                continue;
            }

            if (v.amount <= 1)
            {
                QAA_Draws[i].text = "";
            }
            else
            {
                local item = Daedalus.instance(v.instance)
                if (item.mainflag == 2 || item.mainflag == 4)
                {
                    QAA_Draws[i].text = "";
                    continue;
                }

                QAA_Draws[i].text = "x" + v.amount;
                QAA_Draws[i].setPosition(QA_Slots[i].getPosition().x + QA_Slots[i].getSize().width - QAA_Draws[i].width - 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAA_Draws[i].height - 20)
            }
        }
    }
}

function onRenderP(currentTime, lastTime)
{
    handleQARender();
    npcInteractionHandler();
    enemyRender();
    mapRender();
    tradeRender();
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

    if (key == KEY_F1 && Player.qa[0] != "")
    {
        handleUseItem({instance = Player.qa[0]});
    }

    if (key == KEY_F2 && Player.qa[1] != "")
    {
        handleUseItem({instance = Player.qa[1]});
    }

    if (key == KEY_F3 && Player.qa[2] != "")
    {
        handleUseItem({instance = Player.qa[2]});
    }

    if (key == KEY_F4 && Player.qa[3] != "")
    {
        handleUseItem({instance = Player.qa[3]});
    }
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