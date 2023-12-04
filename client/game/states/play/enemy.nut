local enemy_list = [];
local MIN_ENEMY_DISTANCE = 400;
local MAX_ENEMY_DISTANCE = 1500;
local ATTACK_COOLDOWN = 1000;
local MOVEMENT_COOLDOWN = 2000;  // Cooldown for randomizing movement in milliseconds
local OBSTACLE_CHECK_DISTANCE = 100;  // Distance to check for obstacles

function RandomizeMovement(enemy)
{
    local randomAngle = rand() % 360;
    setPlayerAngle(enemy.npc, randomAngle);
}

function Enemy_AI()
{
    local currentTime = getTickCount();

    foreach(enemy in enemy_list)
    {
        if (isPlayerDead(enemy.npc) || isPlayerDead(heroId)) continue;

        local hPos = getPlayerPosition(heroId);
        local ePos = getPlayerPosition(enemy.npc);
        local dist = getDistance3d(hPos.x, hPos.y, hPos.z, ePos.x, ePos.y, ePos.z);

        // Randomize movement when not in attack range
        if (dist < MAX_ENEMY_DISTANCE && currentTime - enemy.lastMovementTime > MOVEMENT_COOLDOWN)
        {
            RandomizeMovement(enemy);
            enemy.lastMovementTime = currentTime;
            continue;
        }

        // Set angle to face the player
        local angle = getVectorAngle(ePos.x, ePos.z, hPos.x, hPos.z);
        setPlayerAngle(enemy.npc, angle);

        if (dist <= MIN_ENEMY_DISTANCE && currentTime - enemy.lastAttackTime > ATTACK_COOLDOWN)
        {
            playAni(enemy.npc, "S_FISTATTACK");
            enemy.lastAttackTime = currentTime;
        }
        else
        {
            if (checkObstacleInPath(hPos, ePos))
            {
                RandomizeMovement(enemy);
            }
            else
            {
                playAni(enemy.npc, "S_FISTRUNL");
            }
        }
    }
}

function checkObstacleInPath(heroPos, enemyPos)
{
    local delta = getDistance3d(heroPos.x, heroPos.y, heroPos.z, enemyPos.x, enemyPos.y, enemyPos.z);

    if (delta < OBSTACLE_CHECK_DISTANCE)
        return true;

    return false;
}

local timer = setTimer(Enemy_AI, 500, 0);

class Enemy
{
    npc = null;
    nickname = null;
    draw = null;
    pos = null;
    instance = null;
    animation = null;
    angle = null;
    attacking = null;
    lastAttackTime = null;
    lastMovementTime = null;
    healthTex = null;
    healthTexCover = null;
    dyingTimer = null;

    constructor(name, x, y, z, ang)
    {
        npc = createNpc(name);
        draw = Draw3d(x, y + 75, z);
        pos = { x = x, y = y, z = z };
        instance = "PC_HERO";
        nickname = name;
        angle = ang;
        attacking = false;
        draw.insertText("Lv. 40")
        draw.insertText(name);
        draw.setLineColor(0, 255, 0, 0);

        lastAttackTime = 0;
        lastMovementTime = 0;
        healthTex = Texture(0, 0, 1000, 100, "SR_BLANK.TGA");
        healthTexCover = Texture(0, 0, 1000, 100, "MENU_CHOICE_BACK.TGA");
        healthTex.setColor(255, 0, 0);
        healthTex.visible = false;
        healthTexCover.visible = false;
        dyingTimer = -1;

        enemy_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        setPlayerAngle(npc, angle);
        setPlayerMaxHealth(npc, 40);
        setPlayerHealth(npc, 40);
        draw.setWorldPosition(pos.x, pos.y + 100, pos.z);
    }
}

function spawnEnemy(nickname, x, y, z, angle, instance)
{
    local npc = Enemy(nickname, x, y, z, angle);
    npc.instance = instance;
    npc.spawn();
}

local anyId = -1;

local function eventfocus1(focusid, previd)
{
    foreach(v in enemy_list)
    {
        if (v.npc == focusid)
        {
            if (isPlayerDead(focusid))
            {
                if (!info_draw.visible)
                {
                    info_draw.visible = true;
                }
                anyId = v;
            }
        }
        else if (focusid == -1)
        {
            if (info_draw.visible)
            {
                info_draw.visible = false;
            }
            anyId = -1;
        }
    }
}
addEventHandler("onFocus", eventfocus1);

function enemyRender()
{
    local pos = getPlayerPosition(heroId);
    foreach(v in enemy_list)
    {
        if (isPlayerDead(v.npc))
        {
            if (v.dyingTimer == -1)
            {
                v.dyingTimer = 2000.0;
            }
            else
            {
                v.dyingTimer -= 20;
                if (v.dyingTimer < 0)
                {
                    v.dyingTimer = 0;
                }
                setPlayerVisualAlpha(v.npc, v.dyingTimer / 2000.0);
            }
        }

        local npos = getPlayerPosition(v.npc);
        if (isPlayerDead(v.npc))
        {
            if (v.healthTex.visible || v.healthTexCover.visible)
            {
                v.healthTex.visible = false;
                v.healthTexCover.visible = false;
                v.draw.setLineColor(0, 180, 180, 180);
                v.draw.setLineColor(1, 180, 180, 180);
                continue;
            }
            continue;
        }

        if (getDistance2d(pos.x, pos.z, npos.x, npos.z) < distance_draw)
        {
            v.draw.visible = true;
            v.draw.setWorldPosition(npos.x, npos.y + 120, npos.z);
            local dpos = v.draw.getPosition();
            v.healthTex.setPosition(dpos.x + v.draw.width / 2 - 500, dpos.y - v.draw.height / 2 - 100);
            v.healthTexCover.setPosition(dpos.x + v.draw.width / 2 - 500, dpos.y - v.draw.height / 2 - 100);
            local calc = getPlayerHealth(v.npc).tofloat()/getPlayerMaxHealth(v.npc).tofloat();
            v.healthTex.setSize(1000 * calc, 100)
            v.healthTex.visible = true;
            v.healthTexCover.visible = true;

            if (!isPlayerDead(v.npc))
            {
                v.draw.setLineColor(0, 255, 0, 0);
                v.draw.setLineColor(1, 255, 200, 200);
            }
        }

        if (getDistance2d(pos.x, pos.z, npos.x, npos.z) >= distance_draw && v.draw.visible == true)
        {
            v.draw.visible = false;
            v.healthTex.visible = false;
            v.healthTexCover.visible = false;
        }
    }
}

local function onplayerkey1(key)
{
    if (key == KEY_LCONTROL)
    {
        if (anyId != -1)
        {
            if (!isPlayerDead(anyId.npc)) return;
            playAni(heroId, "T_PLUNDER");
            sendPacket(PacketType.QUEST, 1);
            Chat.Add("You found: ", [255, 220, 180, "Sword x1"]);
        }
    }
}
addEventHandler("onKey", onplayerkey1);

function onHit(killerid, playerid, description)
{
    //addEffect(killerid, "Spellfx_Deathball");
}
addEventHandler("onPlayerHit", onHit);

function onPlayerDead(id)
{
    foreach(v in enemy_list)
    {
        if (v.npc == id)
        {
            Player.addExperience(40);
        }
    }
}
addEventHandler("onPlayerDead", onPlayerDead);