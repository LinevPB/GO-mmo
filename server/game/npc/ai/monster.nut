local warn_distance = 1000;
local rush_distance = 600;
local attack_distance = 200;

function monster_ai(npc)
{
    if (npc.dead) return;

    local players = npc.streamedPlayers;
    local dist = warn_distance;
    local idToFocus = -1;

    foreach(v in players)
    {
        local player = findPlayer(v);
        if (player == -1) continue;
        if (player.dead) continue;

        local pos = getPlayerPosition(v);
        local calcDist = getDistance3d(npc.pos.x, npc.pos.y, npc.pos.z, pos.x, pos.y, pos.z);

        if (calcDist < dist)
        {
            dist = calcDist;
            idToFocus = v;
        }
    }

    if (idToFocus != -1)
    {
        npc.focusPlayer(idToFocus);
    }

    if (players.len() == 0 || (dist >= warn_distance && npc.focusId != -1))
    {
        npc.playAni("S_RUN");

        npc.focusId = -1;
        return;
    }

    if (dist < attack_distance)
    {
        return monster_attack(npc);
    }

    if (dist < rush_distance)
    {
        return monster_rush(npc);
    }

    if (dist < warn_distance)
    {
        return monster_warn(npc);
    }
}

function monster_warn(npc)
{
    npc.playAni("T_WARN");
}

function monster_rush(npc)
{
    npc.playAni("S_FISTRUNL");
}

function monster_attack(npc)
{
    if (npc.pause == -1)
    {
        npc.playAni("S_FISTATTACK");
        npc.pause = 3; // each 1 is 500ms
        HitPlayer(npc.focusId, 500);
    }
    else
    {
        npc.playAni("S_RUN");
        npc.pause -= 1;
    }

    if (npc.pause == 1)
    {
        npc.pause = -1;
    }
}