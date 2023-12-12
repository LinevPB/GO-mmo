local gid = 0;
local ground_items = [];

class GroundItem
{
    id = null;
    pos = null;
    instance = null;
    amount = null;
    constructor(aPos, aInstance, aAmount = 1)
    {
        pos = aPos;
        instance = aInstance;
        amount = aAmount;

        id = gid;
        gid++;

        ground_items.append(this);
    }
}

function addGroundItem(pos, instance)
{
    local item = GroundItem(pos, instance);
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

            ground_items.remove(i);
            return;
        }
    }
}