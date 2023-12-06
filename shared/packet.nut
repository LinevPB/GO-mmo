enum PacketType {
    LOGIN = 0,
    REGISTER = 1,
    CHAT_MESSAGE = 2,
    CHARACTERS_QUERY = 3,
    CHARACTERS_RECEIVE = 4,
    CHARACTERS_FINISHED = 5,
    CHARACTERS_SELECT = 6,
    CHARACTERS_CREATE = 7,
    CHARACTER_CREATION_CONFIRM = 8,
    CHARACTER_CREATION_BACK = 9,
    UPDATE_ITEM = 10,
    MOVE_ITEMS = 11,
    EQUIP_ARMOR = 12,
    EQUIP_MELEE = 13,
    EQUIP_RANGED = 14,
    TEST = 15,
    TEST_PACKET = 16,
    QUEST = 17,
    UPDATE_LEVEL = 18,
    UPDATE_EXPERIENCE = 19,
    UPDATE_GOLD = 20,
    USE_ITEM = 21,
    DROP_ITEM = 22,
    UPDATE_QA = 23,
    TRADE_PLAYER_BASKET = 24,
    TRADE_NPC_BASKET = 25,
    TRADE_RESULT = 26,
    ENEMY_SPAWN = 27,
    NPC_SPAWN = 28,
    NPC_PLAY_ANI = 29,
    NPC_COORDS = 30,
    NPC_SET_COORDS = 31,
    NPC_DAMAGE = 32,
    NPC_UPDATE_HEALTH = 33,
    NPC_UPDATE_MAX_HEALTH = 34,
    NPC_DIE = 35,
    ADD_EXPERIENCE = 36,
    LEVEL_UP = 37,
    NPC_RESPAWN = 38
};

function encode(args)
{
    local result = "";

    foreach (val in args) {
        local typeIdentifier = "";
        local valueStr = val.tostring();

        switch (typeof val)
        {
            case "string": typeIdentifier = "s"; break;
            case "integer": typeIdentifier = "i"; break;
            case "float": typeIdentifier = "f"; break;
            case "bool": typeIdentifier = "b"; break;
            default: break;
        }
        if (typeIdentifier == "s" && valueStr.len() == 0)
        {
            valueStr = "e";
            typeIdentifier = "e";
        }

        result += format("%s%d:%s:", typeIdentifier, valueStr.len(), valueStr);
    }

    // Remove the trailing colon
    if (result.len() > 0)
    {
        result = result.slice(0, result.len() - 1);
    }

    return result;
}

function decode(encodedString)
{
    local result = [];
    local currentIndex = 0;

    while (currentIndex < encodedString.len() - 1) {
        local vartype = encodedString[currentIndex].tochar();
        currentIndex += 1; // Skip the type and the following ':'

        local colonIndex = encodedString.find(":", currentIndex);
        if (colonIndex != null)
        {
            local varlength = encodedString.slice(currentIndex, colonIndex).tointeger();
            currentIndex = colonIndex + 1;
            local varvalue = encodedString.slice(currentIndex, currentIndex + varlength);
            currentIndex += varlength + 1;

            switch (vartype)
            {
                case "i": varvalue = varvalue.tointeger(); break;
                case "f": varvalue = varvalue.tofloat(); break;
                case "b": "true" ? varvalue = true : varvalue = false; break;
                case "e": varvalue = ""; break;
                default: break;
            }

            result.append(varvalue);
        }
    }

    return result;
}

local function createPacket(packetType, arg)
{
    local packet = Packet();
    packet.writeInt8(packetType);
    packet.writeString(arg);

    return packet;
}

function sendPacket(packetType, ...)
{
    local packet = createPacket(packetType, encode(vargv));
    packet.send(RELIABLE_ORDERED);
}

function sendArray(packetType, arr)
{
    local packet = createPacket(packetType, encode(arr));
    packet.send(RELIABLE_ORDERED);
}

function sendPlayerPacket(pid, packetType, ...)
{
    local packet = createPacket(packetType, encode(vargv));
    packet.send(pid, RELIABLE_ORDERED);
}