local spawnedPlayers = [];

class SpawnedPlayer
{
    id = null;
    name = null;
    draw = null;

    constructor(ind, nam)
    {
        id = ind;
        name = nam;
        draw = Draw3d(0, 0, 0);
        draw.insertText(nam);
        draw.visible = true;
    }

    function updateDrawPosition(x, y, z)
    {
        local pos = draw.getWorldPosition();

        if (pos.x != x || pos.z != z || pos.y != y)
        {
            draw.setWorldPosition(x, y + 120, z);
        }
    }

    function changeName(val)
    {
        if (val == name) return;

        draw.setLineText(0, val);
        name = val;
    }
}

function handlePlayerSpawn(id = -1)
{
    if (id == -1) id = heroId;

    local struct = SpawnedPlayer(id, getPlayerName(id));
    spawnedPlayers.append(struct);
}
addEventHandler("onPlayerSpawn", handlePlayerSpawn);
addEventHandler("onInit", handlePlayerSpawn);

function handlePlayerUnspawn(id)
{
    foreach(i, v in spawnedPlayers)
    {
        if (v.id != id) continue;

        spawnedPlayers.remove(i);
        break;
    }
}
addEventHandler("onPlayerDestroy", handlePlayerUnspawn);


function playersNameRender()
{
    foreach(v in spawnedPlayers)
    {
        local pos = getPlayerPosition(v.id);

        v.updateDrawPosition(pos.x, pos.y, pos.z);
        v.changeName(getPlayerName(v.id));
    }
}