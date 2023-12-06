local npc_list = [];
local enemy_list = [];
local npc_id = 512;

enum AiType
{
    MONSTER = 0
}

class Npc
{
    id = null;
    name = null;
    pos = null;
    instance = null;
    animation = null;
    angle = null;
    oneTimeAni = null;
    timer = null;
    focusId = null;
    streamedPlayers = null;
    pause = null;
    movementSpeed = null;
    health = null;
    max_health = null;
    damage = null;
    respawnTime = null;
    level = null;
    originalPos = null;
    originalAngle = null;

    constructor(npcName, v3pos, npcAngle, inst)
    {
        id = npc_id;
        npc_id++;

        name = npcName;
        pos = v3pos;
        originalPos = v3pos;
        angle = npcAngle;
        originalAngle = npcAngle;
        instance = inst;
        //animation = "T_STAND_2_JUMP";
        //animation = "S_RUNL";
        //animation = "S_FISTRUNL";
        //animation = "T_WARN";
        animation = "S_RUN";

        focusId = -1;
        streamedPlayers = [];
        pause = -1;
        movementSpeed = 1;
        respawnTime = 10;
        level = 0;

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

    function playOneTimeAni(id)
    {
        oneTimeAni = id;
    }

    function clearOneTimeAni()
    {
        oneTimeAni = null;
    }

    function setCoords(vec, angl)
    {
        pos = vec;
        angle = angl;
    }

    function setAi(ai_id)
    {
        switch(ai_id)
        {
            case AiType.MONSTER:
                timer = setTimer(monster_ai, 500, 0, this);
            break;
        }
    }

    function cancelAi()
    {
        killTimer(timer);
        timer = null;
    }

    function focusPlayer(pid)
    {
        focusId = pid;
        setAngleAtFocus();
    }

    function setAngleAtFocus()
    {
        if (focusId == -1) return;

        local ePos = getPlayerPosition(focusId);
        angle = getVectorAngle(pos.x, pos.z, ePos.x, ePos.z);
    }

    function updatePlayers(packetType, val)
    {
        foreach(v in getPlayers())
        {
            sendPlayerPacket(v.id, packetType, id, val);
        }
    }

    function setHealth(val)
    {
        health = val;
        updatePlayers(PacketType.NPC_UPDATE_HEALTH, health);
    }

    function setMaxHealth(val)
    {
        max_health = val;
        updatePlayers(PacketType.NPC_UPDATE_MAX_HEALTH, max_health);
    }

    function getHealth()
    {
        return health;
    }

    function getMaxHealth()
    {
        return max_health;
    }

    function setDamage(val)
    {
        damage = val;
    }

    function setLevel(val)
    {
        level = val;
    }

    function die()
    {
        health = 0;

        foreach(v in getPlayers())
        {
            sendPlayerPacket(v.id, PacketType.NPC_DIE, id);
        }

        setTimer(respawnNpc, 1000 * respawnTime, 1, id);
    }
}

function findGlobalNpc(npc_id)
{
    foreach(v in npc_list)
    {
        if (v.id == npc_id) return v;
    }
}

function respawnNpc(npc_id)
{
    local npc = findGlobalNpc(npc_id);
    npc.pos = npc.originalPos;
    npc.angle = npc.originalAngle;

    foreach(v in getPlayers())
    {
        sendPlayerPacket(v.id, PacketType.NPC_RESPAWN, npc_id, npc.pos.x, npc.pos.y, npc.pos.z, npc.angle);
    }

    npc.setHealth(npc.getMaxHealth());
}

function initNpcs()
{
    local pos = [
        { x = -4810.47, y = -297.969, z = -2276.41, angle = 293.966 },
        { x = -4672.89, y = -301.719, z = -2337.5, angle = 293.966 },
        { x = -4144.45, y = -285.156, z = -2602.27, angle = 228.821 },
        { x = -4056.48, y = -273.281, z = -2525.08, angle = 228.821 },
        { x = -3843.2, y = -197.891, z = -1970.31, angle = 158.667 },
        { x = -3879.77, y = -196.719, z = -1877.03, angle = 158.667 },
        { x = -4059.06, y = -163.359, z = -1307.42, angle = 173.274 },
        { x = -4071.48, y = -172.031, z = -1210.31, angle = 177.476 },
        { x = -3790.08, y = -111.562, z = -910.625, angle = 249.91 },
        { x = -3697.19, y = -111.562, z = -876.484, angle = 249.91 },
        { x = -3212.19, y = -72.7344, z = -409.766, angle = 168.368 },
        { x = -3242.19, y = -102.812, z = -264.609, angle = 168.368 },
        { x = -3120.94, y = -144.375, z = 252.812, angle = 243.505 },
        { x = -3004.53, y = -143.125, z = 311.094, angle = 243.505 },
        { x = -2107.97, y = -58.5156, z = 691.172, angle = 292.439 }
    ];

    foreach(v in pos)
    {
        local npc = Npc("Scavenger", Vec3(v.x, v.y, v.z), v.angle, "SCAVENGER");
        npc.setAi(AiType.MONSTER);
        npc.setMaxHealth(100);
        npc.setHealth(100);
        npc.setDamage(10);
        npc.setLevel(2);

        npc.movementSpeed = 1;
    }
}

function spawnNpcs(pid)
{
    foreach(v in npc_list)
    {
        sendPlayerPacket(pid, PacketType.NPC_SPAWN, v.id, v.name, v.pos.x, v.pos.y, v.pos.z, v.angle, v.instance, v.health, v.max_health, v.level);
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

function handleNpcDamage(pid, npc_id)
{
    foreach(v in getNpcs())
    {
        if (v.id == npc_id)
        {
            local player = findPlayer(pid);

            v.setHealth(v.getHealth() - 20);

            if (v.getHealth() <= 0)
            {
                v.die();
                player.addExperience(20);
            }
        }
    }
}