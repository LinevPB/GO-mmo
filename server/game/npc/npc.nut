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
    oneTimeAni = null;
    timer = null;
    focusId = null;
    streamedPlayers = null;
    pause = null;
    movementSpeed = null;

    constructor(npcName, v3pos, npcAngle, inst)
    {
        id = npc_id;
        npc_id++;

        name = npcName;
        pos = v3pos;
        angle = npcAngle;
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
            case 0:
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
}

function initNpcs()
{
    local xd = Npc("Scavenger", Vec3(2209, 247, -1586), 158, "SCAVENGER");
    xd.setAi(0);
    xd.movementSpeed = 5;
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