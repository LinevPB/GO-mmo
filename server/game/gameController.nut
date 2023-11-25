function ChangeGameState(pid, state)
{
    switch(state) {
        case GameState.LOGIN:
            findPlayer(pid).gameState = GameState.LOGIN;
            break;

        case GameState.PLAY:
            findPlayer(pid).gameState = GameState.PLAY;
            break;

        case GameState.CHARACTER_SELECTION:
            findPlayer(pid).gameState = GameState.CHARACTER_SELECTION;
            break;

        case GameState.CHARACTER_CREATION:
            findPlayer(pid).gameState = GameState.CHARACTER_CREATION;
            break;
    }
}

local function onConnect(pid)
{
    ChangeGameState(pid, GameState.LOGIN);
}
addEventHandler("onConnect", onConnect);

function loginHandler(pid, data)
{
    local result = logIn(data[0], data[1]);
    if (!result)
        return loginFailed(pid, "Player " + data[0] + " failed to log in.");

    loginSuccessful(pid, data[0], "Player " + data[0] + " logged in.", result);
    ChangeGameState(pid, GameState.CHARACTER_SELECTION);
}

function registerHandler(pid, data)
{
    local result = signUp(data[0], data[1], data[2]);
    switch(result) {
        case 0:
            registerFailed(pid, 0, "Account " + data[0] + " already exists.");
            break;

        case -1:
            registerFailed(pid, -1, "Passwords for " + data[0] + " are not the same.");
            break;

        case -2:
            registerFailed(pid, -2);
            break;

        case -3:
            registerFailed(pid, -3, "Unknow error for " + data[0] + " account.");
            break;

        default:
            registerSuccessful(pid, data[0], "Player " + data[0] + " signed up.", result);
            ChangeGameState(pid, GameState.CHARACTER_SELECTION);
            break;
    }
}

function messageHandler(pid, data)
{
    local sid = data[0];
    local message = data[1];
    local nickname = findPlayer(sid).charName;

    foreach(player in getPlayers()) {
        if (player.logged) {
            sendMessage(player.id, 25, 250, 50, nickname, message)
        }
    }

    console.log(nickname + ": " + message);
}

function charactersHandler(pid, data)
{
    local temp = findPlayer(pid);
    if (temp.logged) {
        local result = mysql.gquery("SELECT id, pid, name, bodyModel, bodyTex, headModel, headTex, eqArmor, eqWeapon, slotId, eqWeapon2h FROM characters WHERE pid='" + temp.dbId + "'");
        if (result[0] != null) {
            foreach(i, v in result) {
                if (v[1].tointeger() != temp.dbId) continue;
                sendPlayerPacket(pid, PacketType.CHARACTERS_RECEIVE, i, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10]);
            }
        }

        sendPlayerPacket(pid, PacketType.CHARACTERS_FINISHED, 1);
    }
}

function selectHandler(pid, data)
{
    local charId = data[0];
    local temp = findPlayer(pid);
    temp.charId = charId;

    local result = mysql.gquery("SELECT id, pid, name, bodyModel, bodyTex, headModel, headTex, slotId, eqArmor, eqWeapon, eqWeapon2h FROM characters WHERE id='" + charId + "'");
    local v = result[0];

    if (v[1] != temp.dbId) return sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, -1);

    setupChar(pid, v[2], v[9], v[8], v[9], v[10], charId);
    sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[8], v[9], v[7]);
}

function createHandler(pid, data)
{
    sendPlayerPacket(pid, PacketType.CHARACTERS_CREATE, data[0]);
}

function setupChar(pid, name, charSlot, eqArmor, eqWeapon, eqWeapon2h, charId)
{
    local temp = findPlayer(pid);
    temp.charName = name;
    temp.charSlot = charSlot;
    LoadItems(pid, charId);
    EquipArmor(pid, eqArmor);
    EquipWeapon(pid, eqWeapon);
    EquipWeapon2h(pid, eqWeapon2h);
}

function creationConfirmHandler(pid, data)
{
    local name = data[0];
    local bodyMod = data[1];
    local bodyTex = data[2];
    local headMod = data[3];
    local headTex = data[4];
    local slotId = data[5];
    local player = findPlayer(pid);
    local dbId = player.dbId;

    local result = mysql.squery("INSERT INTO `characters` (`id`, `pid`, `slotId`, `name`, `bodyModel`, `bodyTex`, `headModel`, `headTex`, `eqWeapon`, `eqArmor`) VALUES (NULL,'" +
    dbId + "','" + slotId + "','" + name + "','" + bodyMod + "','" + bodyTex + "','" + headMod + "','" + headTex + "','-1', '-1')");
    local result1 = mysql.gquery("SELECT id FROM characters WHERE pid='" + dbId + "' AND slotId='" + slotId + "'");
    player.charId = result1[0];
    player.charName = name;

    sendPlayerPacket(pid, PacketType.CHARACTER_CREATION_CONFIRM, slotId, dbId, name, bodyMod, bodyTex, headMod, headTex);

    setupChar(pid, name, slotId, "-1", "-1", "-1", result1[0]);
}

local function onPacket(pid, packet)
{
    local packetType = packet.readInt8();
    local data = decode(packet.readString());

    switch(packetType) {
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

        case PacketType.QUEST:
            GiveItem(pid, "ItMw_1H_Common_01", 1, false, 3);
        break;

        case PacketType.TEST:
            print("called");
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