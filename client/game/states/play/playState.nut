class Player
{
    constructor()
    {

    }
}

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

function initPlayState()
{
    disableControls(false);
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    Camera.movementEnabled = true;

    Chat.Init();
    Chat.Enable(true);
}