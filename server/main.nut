local enemy_list = [];

class Enemy
{
    nickname = null;
    pos = null;
    instance = null;
    animation = null;
    angle = null;

    constructor(name, x, y, z, ang, instan)
    {
        pos = { x = x, y = y, z = z };
        instance = instan;
        nickname = name;
        angle = ang;

        enemy_list.append(this);
    }

    function setPosition(x, y, z)
    {
        pos.x = x;
        pos.y = y;
        pos.z = z;
    }

    function setAngle(ang)
    {
        angle = ang;
    }

    function spawn()
    {
        setPosition(pos.x, pos.y, pos.z);
        setAngle(angle);
    }
}

function initEnemies()
{
    Enemy("Scavenger", 2209, 247, -1586, 158, "SCAVENGER");
}

function onPlayerJoin(pid)
{
    foreach(v in enemy_list)
    {
        sendPlayerPacket(pid, PacketType.SPAWN_ENEMIES, v.nickname, v.pos.x, v.pos.y, v.pos.z, v.angle, v.instance);
    }
}
addEventHandler("onPlayerJoin", onPlayerJoin);

function onInit()
{
    mysql.init();
    initEnemies();
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