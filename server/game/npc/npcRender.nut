function onTickNpc()
{
    local npcs = getNpcs();

    foreach(v in npcs)
    {
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

            if (v.focusId != -1)
            {
                v.setAngleAtFocus();
            }
            else
            {
                local offsetAngle = (angle-v.angle) / v.streamedPlayers.len();
                if (absolute(offsetAngle) > 1)
                {
                    v.angle += offsetAngle;
                }
            }

            // update npc position
            local offsetX = ((posX - v.pos.x) / v.streamedPlayers.len());
            local offsetY = ((posY - v.pos.y) / v.streamedPlayers.len());
            local offsetZ = ((posZ - v.pos.z) / v.streamedPlayers.len());

            if (absolute(offsetX) > 10)
            {
                v.pos.x += offsetX;
            }

            if (absolute(offsetY) > 10)
            {
                v.pos.y += offsetY;
            }

            if (absolute(offsetZ) > 10)
            {
                v.pos.z += offsetZ;
            }

            sendPlayerPacket(pid, PacketType.NPC_SET_COORDS, v.id, v.pos.x, v.pos.y, v.pos.z, v.angle);
            return;
        }
    }
}