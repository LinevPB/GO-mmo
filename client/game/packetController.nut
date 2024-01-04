local function onPacket(packet) {
    local packetType = packet.readInt8();
    local data = decode(packet.readString());

    switch(packetType)
    {
        case PacketType.LOGIN:
            switch(data[0])
            {
                case 1:
                    authResult(1);
                    ChangeGameState(GameState.CHARACTER_SELECTION);
                    break;
                default: authResult(2); break;
            }
        break;

        case PacketType.REGISTER:
            switch(data[0])
            {
                case 1:
                    authResult(3);
                    ChangeGameState(GameState.CHARACTER_SELECTION);
                    break;
                case 0: authResult(4); break;
                case -1: authResult(5); break;
                case -2: authResult(6); break;
                default: authResult(7); break;
            }
        break;

        case PacketType.CHARACTERS_RECEIVE:
            loadCharacter(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13]);
        break;

        case PacketType.CHARACTERS_FINISHED:
            if(data[0] == 1)
            {
                moveCameraToNPC();



                ///////////////


                ///// DEBUG


                /////////

                if (DEBUG) debug_funcx();
            }
        break;

        case PacketType.CHARACTERS_SELECT:
            if (data[0] == -1) return;
            setupPlayer(data[2], data[3], data[4], data[5], data[6]);
            for(local i = 0; i < 6; i++)
            {
                Player.qa[i] = data[i+10];
            }
            ChangeGameState(GameState.PLAY);
        break;

        case PacketType.CHARACTERS_CREATE:
            Player.charSlot = data[0];
            ChangeGameState(GameState.CHARACTER_CREATION);
        break;

        case PacketType.CHARACTER_CREATION_CONFIRM:
            setupPlayer(data[2], data[3], data[4], data[5], data[6]);
            for(local i = 0; i < 6; i++)
            {
                Player.qa[i] = "";
            }
            ChangeGameState(GameState.CHARACTER_SELECTION);
        break;

        case PacketType.CHARACTER_CREATION_BACK:
            ChangeGameState(GameState.CHARACTER_SELECTION);
        break;

        case PacketType.CHAT_MESSAGE:
            if (Player.gameState == GameState.PLAY)
            {
                onMessage(data);
            }
        break;

        case PacketType.CHAT_CLEAR_MESSAGE:
            if (Player.gameState == GameState.PLAY)
            {
                onClearMessage(data);
            }
        break;

        case PacketType.CHAT_OOC:
            if (Player.gameState == GameState.PLAY)
            {
                onMessageOOC(data);
            }
        break;

        case PacketType.CHAT_CRY:
            if (Player.gameState == GameState.PLAY)
            {
                onMessageCry(data);
            }
        break;

        case PacketType.UPDATE_ITEM:
            Player.manageItem(data[0], data[1], data[2], data[3]);
        break;

        case PacketType.UPDATE_LEVEL:
            Player.level = data[0];
        break;

        case PacketType.UPDATE_EXPERIENCE:
            Player.experience = data[0];
        break;

        case PacketType.UPDATE_GOLD:
            Player.gold = data[0];
        break;

        case PacketType.TRADE_RESULT:
            handleTradeResult(data);
        break;

        case PacketType.NPC_SPAWN:
            handleNpcSpawn(data);
        break;

        case PacketType.NPC_PLAY_ANI:
            handleNpcAnimation(data);
        break;

        case PacketType.NPC_COORDS:
            handleNpcCoords(data);
        break;

        case PacketType.NPC_SET_COORDS:
            setNpcCoords(data);
        break;

        case PacketType.NPC_UPDATE_HEALTH:
            handleNpcSetHealth(data[0], data[1]);
        break;

        case PacketType.NPC_UPDATE_MAX_HEALTH:
            handleNpcSetMaxHealth(data[0], data[1]);
        break;

        case PacketType.NPC_DIE:
            handleNpcDeath(data[0]);
        break;

        case PacketType.ADD_EXPERIENCE:
            local text = lang["ADD_EXPERIENCE"][Player.lang];
            notify(text + "" + data[0]);
        break;

        case PacketType.ADD_GOLD:
            local text = lang["ADD_GOLD"][Player.lang];
            notify(text + "" + data[0]);
        break;

        case PacketType.LEVEL_UP:
            local text = lang["LEVEL_UP"][Player.lang];
            levelUp_notify(text);
        break;

        case PacketType.NPC_RESPAWN:
            handleNpcRespawn(data[0], Vec3(data[1], data[2], data[3]), data[4]);
        break;

        case PacketType.PLAYER_DIE:
            handlePlayerDeath(data[0], data[1]);
        break;

        case PacketType.PLAYER_RESPAWN:
            handlePlayerRespawn(data[0]);
        break;

        case PacketType.SPAWN_GROUND_ITEM:
            handleSpawnGroundItem(data[0], Vec3(data[1], data[2], data[3]), data[4], data[5]);
        break;

        case PacketType.REMOVE_GROUND_ITEM:
            handleRemoveGroundItem(data[0]);
        break;

        case PacketType.UPDATE_DESC:
            Player.desc = data[0];
            updateCharacterDesc();
        break;

        case PacketType.GIVE_ITEM_NOTIFY:
            notify(data[1] + "x " + ServerItems.find(data[0]).name[Player.lang]);
        break;

        case PacketType.ASK_FOR_REMEMBERED:
            handleRemembered(data[0], data[1]);
        break;
    }
}
addEventHandler("onPacket", onPacket);
