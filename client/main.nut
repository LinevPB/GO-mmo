function onInit()
{
    initUI();
    initNotifications();

    ChangeGameState(GameState.LOGIN);

    if (DEBUG) {
        debug_func();
        setTimer(RunDebug, 500, 1);
    }
}
addEventHandler("onInit", onInit);

local groundItems = [];
local giId = 0;
class GroundItem
{
    id = null;
    vob = null;
    pos = null;
    itemDraw = null;

    constructor(instance)
    {
        vob = Mob("ITMI_JEWELERYCHEST.3DS");
        vob.ignoredByTraceRay = true;
        vob.castDynShadow = false;
        itemDraw = Draw3d(0, 300, 0);
        itemDraw.insertText("");
        itemDraw.insertText("");
        itemDraw.insertText("Zbroja gubernatora");
        itemDraw.setLineColor(2, 160, 160, 255);
        itemDraw.visible = true;

        id = giId;
        giId++;

        groundItems.append(this);
    }

    function spawn()
    {
        vob.addToWorld();
        vob.setPosition(0, 300, 0);
        vob.floor();
    }

    function unspawn()
    {
        vob.removeFromWorld();
    }
}

local function gi_render()
{
    local foc = getFocusVob();
    if (foc == null) return;

    foreach(v in groundItems)
    {
        if (foc == v.vob.ptr)
        {
            v.itemDraw.setLineText(0, lang["CTRL"][Player.lang]);
            v.itemDraw.setLineText(1, lang["TAKE"][Player.lang]);
        }
        else
        {
            v.itemDraw.setLineText(0, "");
            v.itemDraw.setLineText(1, "");
        }
    }
}
addEventHandler("onRender", gi_render);

local function gi_key(key)
{
    if (key == KEY_X)
    {
        local temp = GroundItem("ITAR_GOVERNOR");
        temp.spawn();
    }

    if (key == KEY_LCONTROL)
    {
        local foc = getFocusVob();
        foreach(v in groundItems)
        {
            if (v.vob.ptr == foc)
            {
                sendPacket(PacketType.PICKUP_ITEM, v.id);
                playAni(heroId, "T_IGET_2_STAND");
                return;
            }
        }
    }
}
addEventHandler("onKey", gi_key);
