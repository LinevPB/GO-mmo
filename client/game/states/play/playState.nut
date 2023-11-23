local npc_list = [];
local info_draw = Draw(0, 0, "Press (CTRL) to interact");
local fid = -1;

class NPC
{
    npc = null;
    nickname = null;
    draw = null;
    pos = null;
    instance = null;

    constructor(name, x, y, z)
    {
        npc = createNpc(name);
        draw = Draw3d(x, y + 75, z);
        pos = { x = x, y = y, z = z };
        instance = "PC_HERO";
        nickname = name;

        npc_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
    }
}

function eventfocus(focusid, previd)
{
    foreach(v in npc_list) {
        if (v.npc == focusid) {
            if (!v.draw.visible)
                v.draw.visible = true;
                info_draw.visible = true;
                fid = v;
        } else {
            if (v.draw.visible) {
                v.draw.visible = false;
                info_draw.visible = false;
                fid = -1;
            }
        }
    }
}
addEventHandler("onFocus", eventfocus);

local npc = NPC("Zbigniew Ziobro", 0, 300, 0);
local npc1 = NPC("Zbigniew Ziobro 2", 0, 300, 0);

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
    setPlayerPosition(heroId, 0, 300, 0);
    info_draw.setPosition(8192 / 2 - info_draw.width / 2, 8192 - info_draw.height - 100);
    info_draw.setColor(220, 210, 189);

    npc.spawn();
    npc.draw.insertText("Zawsze dziewica");
    npc.draw.insertText("Zbigniew Ziobro");
    npc.draw.setLineColor(0, 255, 100, 255);

    //npc1.spawn();
    npc1.draw.insertText("Zawsze dziewica");
}

function onMessage(data)
{
    Chat.Add([data[0], data[1], data[2], data[3]], data[4]);
}

function onRenderP(currentTime, lastTime)
{
}

local intWindow = Window(0, 6000, 8192, 8192, "SR_BLANK.TGA");
local dialogOpt = [
    Button(0, 500, 8000/2, 300, "NONE", "1. Pokaz mi swoje towary", "NONE"),
    Button(0, 800, 8000/2, 300, "NONE", "2. Bywaj", "NONE")
];
intWindow.attach(dialogOpt[0]);
intWindow.attach(dialogOpt[1]);

function interact(fid)
{
    setFreeze(true);
    disableControls(true);
    setCursorVisible(true);
    setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
    Chat.Enable(false);
    // setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    Chat.Add([255, 255, 0, "You started interacting with "], fid.nickname);
    Camera.setMode("CamModDialog", [getPlayerPtr(fid.npc), getPlayerPtr(heroId)]);

    dialogOpt[0].centered = false;
    dialogOpt[1].centered = false;

    intWindow.setColorForAllButtons(0, 100, 200);
    intWindow.setHoverColorForAllButtons(200, 200, 255);
    intWindow.setBackgroundColor(60, 40, 20);

    intWindow.enable(true);
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
        local pos = getPlayerPosition(heroId);
    }

    if (key == KEY_LCONTROL) {
        if (fid == -1) return;
        interact(fid);
    }
}

addEventHandler("onKey", onplaykey);