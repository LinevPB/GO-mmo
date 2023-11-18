local players = [];

class PlayerStructure
{
    id = null;
    logged = null;
    nickname = null;
    gameState = null;

    constructor(playerid)
    {
        gameState = GameState.UNKNOWN;
        id = playerid;
        logged = false;
        nickname = "";
    }

    function setNickname(nick)
    {
        nickname = nick;
    }

    function setStatus(val)
    {
        logged = val;
    }
}

function findPlayer(pid)
{
    foreach(v in players) {
        if (v.id == pid) return v;
    }

    return -1;
}

function getPlayers()
{
    return players;
}

function addPlayer(pStruct)
{
    return players.append(pStruct);
}

function removePlayer(pStruct)
{
    foreach(i, v in players) {
        if (v == pStruct) return players.remove(i);
    }
}

function removePlayerById(id)
{
    foreach(i, v in players) {
        if (v.id == id) return players.remove(i);
    }
}