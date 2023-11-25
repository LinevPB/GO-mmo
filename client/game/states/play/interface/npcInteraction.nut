local npc_list = [];
info_draw <- Draw(0, 0, "Press (CTRL) to interact");
local dialog_draw = Draw(0, 0, "");
local turning = false;
local turned = false;
local unturning = false;
local unturned = false;
local superf = -1;
local superTexture = Texture(0, 0, 8192, 8192, "SR_BLANK.TGA");
superTexture.setColor(0, 0, 0);
superTexture.alpha = 0;
superTexture.visible = false;
local mealpha = 0;
local interacting = false;
HERO <- heroId;
BOT <- -1;
local in_dial = false;
distance_draw <- 8000;

local ambient_draws = [];

function shide_ambient()
{
    foreach(v in ambient_draws) {
        v.hide_ambient();
    }

    ambient_draws.clear();
}

function timer_ambient(l)
{
    ambient_draws.append(l);
    setTimer(shide_ambient, 1000, 1);
}

class NPC
{
    npc = null;
    nickname = null;
    draw = null;
    pos = null;
    instance = null;
    event = null;
    holder = null;
    sound = null;
    ambient_draw = null;
    animation = null;
    angle = null;

    constructor(name, x, y, z, ang)
    {
        npc = createNpc(name);
        draw = Draw3d(x, y + 75, z);
        ambient_draw = Draw3d(x, y+100, z);
        pos = { x = x, y = y, z = z };
        instance = "PC_HERO";
        nickname = name;
        angle = ang;

        npc_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        setPlayerAngle(npc, angle);
        draw.setWorldPosition(pos.x, pos.y + 100, pos.z);
        ambient_draw.setWorldPosition(pos.x, pos.y + 140, pos.z)
    }

    function interact()
    {
        if (event != null) {
            begin_interact();
            return;
        }

        play_ambient_dialog();
    }

    function set_ambient(l)
    {
        sound = Sound(l);
    }

    function play_ambient_dialog()
    {
        if (ambient_draw.visible) return;

        sound.play();
        ambient_draw.visible = true;
        ambient_draw.insertText("Get out of here!");
        timer_ambient(this);
    }

    function hide_ambient()
    {
        if (ambient_draw == null) return;
        ambient_draw.visible = false;
        ambient_draw.removeText(0);
    }

    function start()
    {
        if (event != null) {
            event();
        }
    }

    function setInteraction(int)
    {
        event = int;
    }

    function playAni(id)
    {
        animation = id;
    }
}

function eventfocus(focusid, previd)
{
    foreach(v in npc_list) {
        if (v.npc == focusid) {
            if (!info_draw.visible)
                info_draw.visible = true;
                BOT = v;
                HERO = heroId;
        } else if (focusid == -1) {
            if (info_draw.visible) {
                info_draw.visible = false;
                BOT = -1;
                HERO = -1;
            }
        }
    }
}
addEventHandler("onFocus", eventfocus);

local con = 8192-6300-500;
local numerdraw = [
    Draw(8192/2, 6550, "1. "),
    Draw(8192/2, 6850, "2. "),
    Draw(8192/2, 6850, "3. "),
    Draw(8192/2, 6850, "4. "),
    Draw(8192/2, 6850, "5. ")
];

local intWindow = Window(0, 6500, 8192, 8192 - 6500, "SR_BLANK.TGA");
local dialogOpt = [
    Button(8192/2 - 1000, 100, 8000/2, 300, "NONE", "Pokaz mi swoje towary", "NONE"),
    Button(8192/2 - 1000, 400, 8000/2, 300, "NONE", "Co tam", "NONE"),
    Button(8192/2 - 1000, 700, 8000/2, 300, "NONE", "Poboczne", "NONE"),
    Button(8192/2 - 1000, 1000, 8000/2, 300, "NONE", "Zagrajmy", "NONE"),
    Button(8192/2 - 1000, 1300, 8000/2, 300, "NONE", "Bywaj", "NONE")
];
intWindow.attach(dialogOpt[0]);
intWindow.attach(dialogOpt[1]);
intWindow.attach(dialogOpt[2]);
intWindow.attach(dialogOpt[3]);
intWindow.attach(dialogOpt[4]);
local cover1 = Texture(0, 0, 8192, con, "SR_BLANK.TGA");
cover1.setColor(0, 0, 0);
local cover2 = Texture(0, 6300+500, 8192, con, "SR_BLANK.TGA");
cover2.setColor(0, 0, 0);

function begin_interact()
{
    superf = BOT;
    superTexture.visible = true;
    turning = true;
    interacting = true;

    Chat.Enable(false);
    Camera.modeChangeEnabled = false;
    setFreeze(true);
    disableControls(true);
    setCursorVisible(true);
    setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
}

function setDialogOptVisible(id, val)
{
    dialogOpt[id].force_enable(val);
    numerdraw[id].visible = false;
}

function interact(fid)
{
    cover1.visible = true;
    cover2.visible = true;

    Camera.setMode("CamModDialog", [getPlayerPtr(fid.npc), getPlayerPtr(heroId)]);
    hideAllNames();

    intWindow.setColorForAllButtons(160, 160, 255);
    intWindow.setHoverColorForAllButtons(200, 200, 255);
    intWindow.setBackgroundColor(60, 40, 20);

    local pos = getPlayerPosition(heroId);
    local npos = getPlayerPosition(fid.npc);
    local angle = null;

    angle = getVectorAngle(pos.x, pos.z, npos.x, npos.z);
    setPlayerAngle(heroId, angle);

    angle = getVectorAngle(npos.x, npos.z, pos.x, pos.z);
    setPlayerAngle(fid.npc, angle);

    stopAni(fid.npc);
    stopFaceAni(fid.npc);
}

function begin_hiding()
{
    Camera.modeChangeEnabled = true;
    Camera.setMode("CAMMODNORMAL");
    cover1.visible = false;
    cover2.visible = false;
    hide_dialog_menu();
    update_dialog("");
    Chat.Enable(true);
    setCursorVisible(false);
    setPlayerAngle(BOT.npc, BOT.angle);
}

function end_interaction()
{
    stopAni(HERO);
    stopFaceAni(HERO);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    disableControls(false);
    interacting = false;
}

function show_dialog_menu(dialogs)
{
    intWindow.enable(true);
    setCursorVisible(true);

    for(local i = 0; i < 5; i++) {
        dialogOpt[i].centered = false;
        dialogOpt[i].align_left = true;
        dialogOpt[i].recolor();
        dialogOpt[i].setPosition(8192/2-1000, dialogOpt[i].pos.y);
        setDialogOptVisible(i, i < dialogs.len());
        if (i < dialogs.len()) {
            dialogOpt[i].draw.text = dialogs[i].text;
        }

        numerdraw[i].visible = i < dialogs.len();
        numerdraw[i].setColor(255, 255, 255);
        numerdraw[i].top();
        numerdraw[i].setPosition(dialogOpt[i].draw.getPosition().x - numerdraw[i].width, dialogOpt[i].draw.getPosition().y);
    }
}

function hide_dialog_menu()
{
    setCursorVisible(false);
    for(local i = 0; i < 5; i++) {
        numerdraw[i].visible = false;
        dialogOpt[i].force_enable(null);
    }
    intWindow.enable(false);
}

function update_dialog(text)
{
    dialog_draw.text = text;
    dialog_draw.setPosition(8192 / 2 - dialog_draw.width / 2, intWindow.pos.y - dialog_draw.height - 50);
    if (text == "")
        dialog_draw.visible = false;
    else {
        dialog_draw.visible = true;
        in_dial = true;
    }
}

function start_dialog()
{
    hide_dialog_menu();
}

function end_dialog()
{
    show_dialog_menu();
}

function check_dialog(id)
{
    if (BOT == -1) return;
    if (BOT.holder[id] == null) return;
    hide_dialog_menu();
    BOT.holder[id].event();
}

function playButtonHandler(id)
{
    if (Inventory.IsEnabled()) return INVplayButtonHandler(id);

    switch(id) {
        case dialogOpt[0].id:
            check_dialog(0);
        break;

        case dialogOpt[1].id:
            check_dialog(1);
        break;

        case dialogOpt[2].id:
            check_dialog(2);
        break;

        case dialogOpt[3].id:
            check_dialog(3);
        break;

        case dialogOpt[4].id:
            check_dialog(4);
        break;
    }
}

local exiting = false;

function hideAllNames()
{
    foreach(v in npc_list) {
        if (v.draw.visible) v.draw.visible = false;
    }
}

function npcInteractionHandler()
{
    if (!interacting) {
        local pos = getPlayerPosition(heroId);
        foreach(v in npc_list) {
            local npos = getPlayerPosition(v.npc);
            if (getDistance2d(pos.x, pos.z, npos.x, npos.z) < distance_draw && v.draw.visible == false)  {
                v.draw.visible = true;
                v.draw.setWorldPosition(npos.x, npos.y + 120, npos.z);
                v.ambient_draw.setWorldPosition(npos.x, npos.y + 160, npos.z)
            }
            if (getDistance2d(pos.x, pos.z, npos.x, npos.z) >= distance_draw && v.draw.visible == true) v.draw.visible = false;
            if (v.animation != null) {
                if (getPlayerAni(v.npc) != v.animation) {
                    playAni(v.npc, v.animation);
                }
            }
        }

        return;
    }

    if (turning) {
        mealpha += 10;
        if (mealpha >= 255) {
            turning = false;
            turned = true;
            mealpha = 255;
        }
        superTexture.alpha = mealpha;
        return;
    }
    if (unturning) {
        mealpha -= 20;
        if (mealpha <= 0) {
            unturning = false;
            unturned = true;
            mealpha = 0;
        }
        superTexture.alpha = mealpha;
        return;
    }

    if (turned) {
        if (!exiting)  {
            interact(superf);
        }
        else begin_hiding();
        turned = false;
        unturning = true;
        return;
    }

    if (unturned) {
        if (exiting) {
            end_interaction();
            exiting = false;
        } else {
            BOT.start();
        }
        unturned = false;
        superTexture.visible = false;
        superf = -1;
        return;
    }
}

function start_exiting()
{
    in_dial = false;
    exiting = true;
    superTexture.visible = true;
    turning = true;
    hide_dialog_menu();
}

local timer = null;

function play_gest(who)
{
    stopAni(HERO);
    stopFaceAni(HERO);
    stopAni(BOT.npc);
    stopFaceAni(BOT.npc);

    if (who == HERO) {
        local pos = getPlayerPosition(BOT.npc);
        Camera.setPosition(pos.x, pos.y, pos.z);
        Camera.setMode("CamModDialog", [getPlayerPtr(heroId), getPlayerPtr(BOT.npc)]);
        playGesticulation(heroId);
    }

    if (who == BOT) {
        local pos = getPlayerPosition(heroId);
        Camera.setPosition(pos.x, pos.y, pos.z);
        Camera.setMode("CamModDialog", [getPlayerPtr(BOT.npc), getPlayerPtr(heroId)]);
        playGesticulation(BOT.npc);
    }
}

local dial_func = null;
local skipping = false;

function next_dial(func, time)
{
    dial_func = func;
    timer = setTimer(func, time.tointeger(), 1);
}

function skip_func()
{
    skipping = false;
    dial_func();
}

function skip()
{
    if (skipping) return;

    skipping = true;
    killTimer(timer);
    timer = setTimer(skip_func, 50, 1);
}

function finish_dial()
{
    stopAni(HERO);
    stopFaceAni(HERO);
    stopAni(BOT.npc);
    stopFaceAni(BOT.npc);

    in_dial = false;
    show_dialog_menu(BOT.holder);
}

function initInteraction()
{
    info_draw.setPosition(8192 / 2 - info_draw.width / 2, 8192 - info_draw.height - 100);
    info_draw.setColor(220, 210, 189);
}

local function onplayerkey(key)
{
    if (key == KEY_LCONTROL) {
        if (BOT == -1) return;
        if (interacting) return;
        BOT.interact();
    }

    if (key == KEY_SPACE && interacting && !exiting && BOT != -1 && in_dial) {
        skip();
    }
}
addEventHandler("onKey", onplayerkey);