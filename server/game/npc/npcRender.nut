function onTickNpc()
{
    local npcs = getNpcs();

    foreach(v in npcs)
    {
        local players = findNearbyPlayers(Vec3(v.pos.x, v.pos.y, v.pos.z), 10000, "HK.ZEN");
        //NPC_PLAY_ANI;
        foreach(k in players)
        {
            sendPlayerPacket(k, PacketType.NPC_PLAY_ANI, v.id, v.animation);
            sendPlayerPacket(k, PacketType.NPC_COORDS, v.id);
            sendPlayerPacket(k, PacketType.NPC_SET_COORDS, v.id, v.pos.x, v.pos.y, v.pos.z, v.angle);
        }
    }
}

function NPC_updateCoords(data)
{
    local posX = data[0];
    local posY = data[1];
    local posZ = data[2];
    local angle = data[3];

}