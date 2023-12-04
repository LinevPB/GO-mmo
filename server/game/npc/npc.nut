local npc_list = [];
local enemy_list = [];
local npc_id = 512;

class Npc
{
    id = null;
    name = null;
    pos = null;
    instance = null;
    animation = null;
    angle = null;

    constructor(npcName, v3pos, npcAngle, inst)
    {
        id = npc_id;
        npc_id++;

        name = npcName;
        pos = v3pos;
        angle = npcAngle;
        instance = inst;
        animation = "T_STAND_2_JUMP"; // S_RUNL

        npc_list.append(this);
    }

    function setPosition(vec)
    {
        pos = vec;
    }

    function setAngle(ang)
    {
        angle = ang;
    }

    function spawn()
    {
        setPosition(pos);
        setAngle(angle);
    }

    function playAni(id)
    {
        animation = id;
    }

    function setCoords(vec, angl)
    {
        pos = vec;
        angle = angl;
    }
}

function initNpcs()
{
    Npc("Scavenger", Vec3(2209, 247, -1586), 158, "PC_HERO");
}

function spawnNpcs(pid)
{
    foreach(v in npc_list)
    {
        sendPlayerPacket(pid, PacketType.NPC_SPAWN, v.id, v.name, v.pos.x, v.pos.y, v.pos.z, v.angle, v.instance);
    }
}

function getNpcs()
{
    return npc_list;
}

function getEnemies()
{
    return enemy_list;
}