local groundItems = [];
local giId = 0;

class GroundItem
{
    id = null;
    vob = null;
    pos = null;
    instance = null;
    itemDraw = null;
    amount = null;

    constructor(vid, apos, ainstance, aAmount = 1)
    {
        pos = apos;
        instance = ainstance;

        local item = ServerItems.find(instance);

        vob = Mob("ITMI_JEWELERYCHEST.3DS");
        vob.ignoredByTraceRay = true;
        vob.castDynShadow = false;

        itemDraw = Draw3d(pos.x, pos.y, pos.z);
        itemDraw.insertText("");
        itemDraw.insertText("");
        itemDraw.insertText(item.name[Player.lang]);
        itemDraw.setLineColor(2, 160, 160, 255);
        itemDraw.visible = true;

        if (vid == -1)
        {
            id = giId;
        }
        else
        {
            id = vid;
        }
        giId--;
        amount = aAmount;

        groundItems.append(this);
    }

    function spawn()
    {
        vob.addToWorld();
        vob.setPosition(pos.x, pos.y, pos.z);
        vob.floor();
    }

    function unspawn()
    {
        itemDraw.visible = false;
        vob.removeFromWorld();
    }
}

function getGroundItems()
{
    return groundItems;
}

function handleSpawnGroundItem(id, pos, instance)
{
    local temp = GroundItem(id, pos, instance);
    temp.spawn();
}

function handleRemoveGroundItem(id)
{
    foreach(i, v in groundItems)
    {
        if (v.id == id)
        {
            v.unspawn();
            groundItems.remove(i);
            return;
        }
    }
}

function handleTakeItem(id)
{
    sendPacket(PacketType.PICKUP_ITEM, id);
    playAni(heroId, "T_IGET_2_STAND");
}

function gi_render()
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

function gi_key(key)
{
    if (key == KEY_X)
    {
        sendPacket(PacketType.QUEST, 1);
    }

    if (key == KEY_LCONTROL)
    {
        local foc = getFocusVob();
        foreach(v in groundItems)
        {
            if (v.vob.ptr == foc)
            {
                handleTakeItem(v.id);
                return;
            }
        }
    }
}
