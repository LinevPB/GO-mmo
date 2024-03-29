local function onPacket(pid, packet)
{
    local packetType = packet.readInt8();
    local readPacket = packet.readString();
    local data = decode(readPacket);

    switch(packetType)
    {
        case PacketType.LOGIN:
            loginHandler(pid, data);
        break;

        case PacketType.REGISTER:
            registerHandler(pid, data);
        break;

        case PacketType.CHAT_MESSAGE:
            messageHandler(pid, data);
        break;

        case PacketType.CHARACTERS_QUERY:
            charactersHandler(pid, data);
        break;

        case PacketType.CHARACTERS_SELECT:
            selectHandler(pid, data);
        break;

        case PacketType.CHARACTERS_CREATE:
            createHandler(pid, data);
        break;

        case PacketType.CHARACTER_CREATION_CONFIRM:
            creationConfirmHandler(pid, data);
        break;

        case PacketType.CHARACTER_CREATION_BACK:
            sendPlayerPacket(pid, PacketType.CHARACTER_CREATION_BACK, 1);
        break;

        case PacketType.MOVE_ITEMS:
            MoveItems(pid, data[0], data[1]);
        break;

        case PacketType.EQUIP_ARMOR:
            EquipArmor(pid, data[0]);
        break;

        case PacketType.EQUIP_MELEE:
            EquipWeapon(pid, data[0]);
        break;

        case PacketType.EQUIP_RANGED:
            EquipWeapon2h(pid, data[0]);
        break;

        case PacketType.USE_ITEM:
            UseItem(pid, data[0], data[1]);
        break;

        case PacketType.OPEN_ITEM:
            OpenItem(pid, data[0], data[1]);
        break;

        case PacketType.DROP_ITEM:
            DropItem(pid, data[0], data[1]);
        break;

        case PacketType.UPDATE_QA:
            ManageQA(pid, data[0], data[1]);
        break;

        case PacketType.TRADE_PLAYER_BASKET:
            local transform = (data[0] == 0) ? data : transformTradeBasket(data);
            handleTrade(pid, transform, 0);
        break;

        case PacketType.TRADE_NPC_BASKET:
            local transform = (data[0] == 0) ? data : transformTradeBasket(data);
            handleTrade(pid, transform, 1);
        break;

        case PacketType.NPC_COORDS:
            NPC_updateCoords(pid, data);
        break;

        case PacketType.NPC_DAMAGE:
            handleNpcDamage(pid, data[0]);
        break;

        case PacketType.PICKUP_ITEM:
            handlePickUp(pid, data);
        break;

        case PacketType.SAVE_DESC:
            saveDescription(pid, data[0]);
        break;

        case PacketType.DAMAGE_DO:
            handlePlayerDamage(pid, data[0], data[1], data[2]);
        break;

        case PacketType.LOG_OUT:
            removePlayerById(pid);
        break;

        case PacketType.ASK_FOR_REMEMBERED:
            handleRemembered(pid);
        break;

        case PacketType.LEARN_STRENGTH:
            learnStrength(pid, data[0]);
        break;

        case PacketType.LEARN_DEXTERITY:
            learnDexterity(pid, data[0]);
        break;

        case PacketType.LEARN_HEALTH:
            learnHealth(pid, data[0]);
        break;

        case PacketType.LEARN_MANA:
            learnMana(pid, data[0]);
        break;

        case PacketType.LEARN_1H:
            learnSkillWeapon(pid, 0, data[0]);
        break;

        case PacketType.LEARN_2H:
            learnSkillWeapon(pid, 1, data[0]);
        break;

        case PacketType.LEARN_BOW:
            learnSkillWeapon(pid, 2, data[0]);
        break;

        case PacketType.LEARN_CROSSBOW:
            learnSkillWeapon(pid, 3, data[0]);
        break;

        case PacketType.KICK:
            tryKick(pid, data[0]);
        break;

        case PacketType.BAN:
            tryBan(pid, data[0]);
        break;

        case PacketType.PLAYER_PLAYANI:
            playPlayerAnimation(pid, data[0]);
        break;

        case PacketType.TEST:
            local pos = getPlayerPosition(pid);
            local angle = getPlayerAngle(pid);
            local res = "{ x = " + pos.x + ", y = " + pos.y + ", z = " + pos.z + ", angle = " + angle + " },";
            local myfile = file("pos.txt", "r+");
            local xd = myfile.read("a");
            myfile.close();
            myfile = file("pos.txt", "w+");
            res += "\n" + xd;
            myfile.write(res);
            myfile.close();
        break;
    }
}
addEventHandler("onPacket", onPacket);
