local gid = 0;
local ground_items = [];

class GroundItem
{
    id = null;
    pos = null;
    instance = null;
    amount = null;
    timer = null;
    constructor(aPos, aInstance, aAmount = 1)
    {
        pos = aPos;
        instance = aInstance;
        amount = aAmount;

        id = gid;
        gid++;

        timer = setTimer(killGroundItem, 60 * 1000, 1, id);

        ground_items.append(this);
    }
}

function addGroundItem(pos, instance, amount)
{
    local item = GroundItem(pos, instance, amount);
    return item;
}

function getGroundItem(id)
{
    foreach(v in ground_items)
    {
        if (v.id == id)
        {
            return v;
        }
    }
}

function killGroundItem(id)
{
    deleteGroundItem(id);
}

function deleteGroundItem(id)
{
    foreach(i, v in ground_items)
    {
        if (v.id == id)
        {
            foreach(k in getPlayers())
            {
                sendPlayerPacket(k.id, PacketType.REMOVE_GROUND_ITEM, id);
            }

            if (v.timer != null)
            {
                killTimer(v.timer);
                v.timer = null;
            }

            ground_items.remove(i);
            return;
        }
    }
}