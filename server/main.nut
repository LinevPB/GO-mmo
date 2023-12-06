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
    if (player.gameState != GameState.PLAY) return;

    local pos = getPlayerPosition(pid);
    mysql.squery("UPDATE `characters` SET `x` = '" + pos.x + "', `y` = '" + pos.y + "', `z` = '" + pos.z + "' WHERE `id`='" + player.charId + "'");

    removePlayer(player);
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