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
    dead = null;
    drops = null;
    goldReward = null;
    expReward = null;

    constructor(npcName, v3pos, npcAngle, inst)
    {
        id = npc_id;
        npc_id++;

        name = npcName;
        pos = v3pos;
        originalPos = Vec3(v3pos.x, v3pos.y, v3pos.z);
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
        dead = false;
        drops = [];
        goldReward = 0;
        expReward = 0;

        npc_list.append(this);
    }

    function setExpReward(val)
    {
        expReward = val;
    }

    function hasDrops()
    {
        if (drops.len() > 0)
        {
            return true;
        }

        return false;
    }

    function setGoldReward(am)
    {
        goldReward = am;
    }

    function addDrop(instance, amount)
    {
        drops.append({instance = instance, amount = amount});
    }

    function getDrops()
    {
        return drops;
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
        dead = true;

        foreach(v in getPlayers())
        {
            sendPlayerPacket(v.id, PacketType.NPC_DIE, id);
        }

        setTimer(respawnNpc, 1000 * respawnTime, 1, id);
    }

    function setRespawnTime(time)
    {
        respawnTime = time;
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
    npc.pos = Vec3(npc.originalPos.x, npc.originalPos.y, npc.originalPos.z);
    npc.angle = npc.originalAngle;

    foreach(v in getPlayers())
    {
        sendPlayerPacket(v.id, PacketType.NPC_RESPAWN, npc_id, npc.pos.x, npc.pos.y, npc.pos.z, npc.angle);
    }

    npc.setHealth(npc.getMaxHealth());
    npc.playAni("S_RUN");
    npc.dead = false;
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

function onKillEnemy(player, enemy)
{
    player.addExperience(enemy.expReward);

    if (enemy.hasDrops())
    {
        foreach(v in enemy.getDrops())
        {
            handleSpawnGround(enemy.pos, v.instance, v.amount);
        }
    }

    if (enemy.goldReward > 0)
    {
        player.addGold(enemy.goldReward);
    }
}

function handleNpcDamage(pid, npc_id)
{
    foreach(v in getNpcs())
    {
        if (v.id == npc_id)
        {
            if (v.dead) continue;

            local player = findPlayer(pid);
            local calcHealth = v.getHealth() - 20;

            if (calcHealth < 1)
            {
                calcHealth = 0;
                v.die();
                onKillEnemy(player, v);
            }

            v.setHealth(calcHealth);

            return;
        }
    }
}