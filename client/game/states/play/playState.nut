local function onPacket(packet) {
    local packetType = packet.readInt8();
    switch(packetType) {
        case PacketType.CHAT_MESSAGE:
            local data = packet.readString();
            local decoded = decode(data);
            Chat.Add([decoded[0], decoded[1], decoded[2], decoded[3]], decoded[4]);
            break;
    }
}
addEventHandler("onPacket", onPacket);



class NPC
{
    id = null;
    npc = null;
    pos = null;
    spawned = null;

    constructor(name, x, y, z)
    {
        npc = createNpc("Mark");
        id = 0;
        pos = { x = x, y = y, z = z };
        spawned = false;
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
    }

    function spawn()
    {
        spawnNpc(npc, "PC_HERO");
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        spawned = true;
    }

    function unspawn()
    {
        unspawnNpc(npc);
        spawned = false;
    }

    function setPosition(x, y, z)
    {
        pos.x = x;
        pos.y = y;
        pos.z = z;
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
    }
}

local dasnpc = NPC("Mark", 0, 0, 0);
function initPlayState()
{
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;

    Chat.Init();
    Chat.Enable(true);

    local pos = getPlayerPosition(heroId);
    dasnpc.setPosition(pos.x, pos.y, pos.z);
    dasnpc.spawn();
}

local function onkey(key)
{
    if (key == KEY_Z) {
        dasnpc.spawn();
    }

    if (key == KEY_X) {
        dasnpc.unspawn();
    }

    if (key == KEY_V) {
        local pos = getPlayerPosition(heroId);
        dasnpc.setPosition(pos.x, pos.y, pos.z);
    }

    if (key == KEY_H) {
        Camera.setTargetPlayer(getPlayerIdByPtr(dasnpc));
    }
}
addEventHandler("onKey", onkey);