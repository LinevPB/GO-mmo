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

function enemyRender()
{

}

function enemyPacket(data)
{

}