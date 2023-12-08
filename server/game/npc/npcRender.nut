local STREAMING_STUPID = false;

function onTickNpc()
{
    local npcs = getNpcs();

    foreach(v in npcs)
    {
        if (v.dead) continue;

        local players = findNearbyPlayers(Vec3(v.pos.x, v.pos.y, v.pos.z), 3500, "HK.ZEN");
        v.streamedPlayers = players;

        foreach(k in players)
        {
            if (v.oneTimeAni != null)
            {
                sendPlayerPacket(k, PacketType.NPC_PLAY_ANI, v.id, v.oneTimeAni, 1);
                v.clearOneTimeAni();
            }
            else
            {
                sendPlayerPacket(k, PacketType.NPC_PLAY_ANI, v.id, v.animation, 0);
            }

            sendPlayerPacket(k, PacketType.NPC_COORDS, v.id);
        }
    }
}

function NPC_updateCoords(pid, data)
{
    local id = data[0];
    local posX = data[1];
    local posY = data[2];
    local posZ = data[3];
    local angle = data[4];
    local minute = data[5];

    foreach(v in getNpcs())
    {
        if (v.id == id)
        {
            if (v.streamedPlayers.len() == 0) continue;

            if (STREAMING_STUPID)
            {
                local offsetX = ((posX - v.pos.x) / v.streamedPlayers.len());
                local offsetY = ((posY - v.pos.y) / v.streamedPlayers.len());
                local offsetZ = ((posZ - v.pos.z) / v.streamedPlayers.len());

                if (absolute(offsetX) > 10)
                {
                    v.pos.x += offsetX * v.movementSpeed;
                }

                if (absolute(offsetY) > 10)
                {
                    v.pos.y += offsetY * v.movementSpeed;
                }

                if (absolute(offsetZ) > 10)
                {
                    v.pos.z += offsetZ * v.movementSpeed;
                }
            }
            else
            {
                v.pos.x = posX;
                v.pos.y = posY;
                v.pos.z = posZ;

                if (pid == v.focusId)
                {
                    v.setAngleAtFocus();
                }
                else if (v.focusId == -1)
                {
                    v.angle = angle;
                }
            }

            sendPlayerPacket(pid, PacketType.NPC_SET_COORDS, v.id, v.pos.x, v.pos.y, v.pos.z, v.angle);
            return;
        }
    }
}