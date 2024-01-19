function onPlayerJoin(pid)
{
    spawnNpcs(pid);
}
addEventHandler("onPlayerJoin", onPlayerJoin);

function onInit()
{
    enableEvent_onTick(true);
    mysql.init();
    initNpcs();
}
addEventHandler("onInit", onInit);

function onDisconnect(pid, reason)
{
    local player = findPlayer(pid);
    if (player == -1) return;
    if (!player.logged) return;
    if (player.gameState == GameState.PLAY)
    {
        local pos = getPlayerPosition(pid);
        mysql.squery("UPDATE `characters` SET `x` = '" + pos.x + "', `y` = '" + pos.y + "', `z` = '" + pos.z + "' WHERE `id`='" + player.charId + "'");
    }

    removePlayerById(pid);

    foreach(v in getPlayers())
    {
        sendPlayerPacket(v.id, PacketType.PLAYER_DISCONNECT, pid);
    }
}
addEventHandler("onPlayerDisconnect", onDisconnect);

local lastTime = 0;
function onTick()
{
    lastTime++;

    if (lastTime < 8) return;

    onTickNpc();

    lastTime = 0;
}
addEventHandler("onTick", onTick);
