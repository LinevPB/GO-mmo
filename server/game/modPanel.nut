function tryKick(pid, tid)
{
    print("Player " + getPlayerName(pid) + " tries to kick " + getPlayerName(tid));
}

function tryBan(pid, tid)
{
    print("Player " + getPlayerName(pid) + " tries to ban " + getPlayerName(tid));
}

function setMod(pid, val)
{
    sendPlayerPacket(pid, PacketType.SET_MOD, val);
}

local mods = [
    "dc4a379d403b87f613cca83de6d17f9e6988e8c6"
];

function onPlayerJoin(pid)
{
    local addr = getPlayerSerial(pid);

    foreach(v in mods)
    {
        if (v != addr) continue;

        setMod(pid, true);
        break;
    }
}
addEventHandler("onPlayerJoin", onPlayerJoin);