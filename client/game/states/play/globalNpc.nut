local npc_list = [];

class GlobalNpc
{
    id = null;
    npc = null;
    name = null;
    pos = null;
    angle = null;
    instance = null;

    constructor(npcId, npcName, posX, posY, posZ, npcAngle, npcInst)
    {
        id = npcId;
        name = npcName;
        pos = { x = posX, y = posY, z = posZ };
        angle = npcAngle;
        instance = npcInst;

        npc = createNpc(name);
        npc_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        setPlayerAngle(npc, angle);
    }

    function playAnim(aniId)
    {
        playAni(npc, aniId);
    }

    function playAnimId(aniId)
    {
        playAniId(npc, aniId);
    }

    function setPosition(x, y, z)
    {
        pos = { x = x, y = y, z = z};
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
    }

    function setAngle(ang)
    {
        angle = ang;
        setPlayerAngle(npc, angle);
    }
}

function handleNpcSpawn(data)
{
    local id = data[0];
    local name = data[1];
    local posX = data[2];
    local posY = data[3];
    local posZ = data[4];
    local angle = data[5];
    local instance = data[6];

    local npc = GlobalNpc(id, name, posX, posY, posZ, angle, instance);
    npc.spawn();
}

function setNpcCoords(data)
{
    local id = data[0];
    local posX = data[1];
    local posY = data[2];
    local posZ = data[3];
    local angle = data[4];

    local npc = findNpc(id);
    npc.setPosition(posX, posY, posZ);
    npc.setAngle(angle);
}

function findNpc(id)
{
    foreach(v in npc_list)
    {
        if (v.id == id) return v;
    }

    return null;
}

function handleNpcCoords(data)
{
    local id = data[0];
    local npc = findNpc(id);
    if (npc == null) return;

    sendPacket(PacketType.NPC_COORDS, npc.pos.x, npc.pos.y, npc.pos.z, npc.angle);
}

function handleNpcAnimation(data)
{
    local id = data[0];
    local aniId = data[1];

    foreach(v in npc_list)
    {
        if (id == v.id)
        {
            return v.playAnim(aniId);
        }
    }
}