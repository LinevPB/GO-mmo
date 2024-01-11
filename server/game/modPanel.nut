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