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
            registerSuccessful(pid, result, "Player " + data[0] + " signed up.");
            loginHandler(pid, [data[0], data[1]]);
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
        ChangeGameState(pid, GameState.PLAY);
    }
}

function selectHandler(pid, data)
{
    local charId = data[0];
    local temp = findPlayer(pid);
    temp.charId = charId;

    local result = mysql.gquery("SELECT id, pid, name, bodyModel, bodyTex, headModel, headTex, slotId, eqArmor, eqWeapon, eqWeapon2h, level, exp, health, max_health, mana, max_mana, strength, dexterity, skill_1h, skill_2h, skill_bow, skill_cbow, magic_circle, gold, x, y, z, qa1, qa2, qa3, qa4, qa5, qa6, char_desc FROM characters WHERE id='" + charId + "'");
    local v = result[0];

    if (v[1] != temp.dbId) return sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, -1);

    setupChar(pid, v[2], v[9], v[8], v[9], v[10], charId);
    sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[8], v[9], v[7], v[28], v[29], v[30], v[31], v[32], v[33]);
    updatePlayer(pid, v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18], v[19], v[20], v[21], v[22], v[23], v[24], v[34]);
    setPlayerPosition(pid, v[25], v[26], v[27]);
    spawnPlayer(pid);
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

function transformTradeBasket(data)
{
    if (data == 0) return data;

    local transform = [];
    local holdInst = "";

    foreach(i, v in data)
    {
        if ((i % 2) == 0)
        {
            holdInst = v;
            continue;
        }
        transform.append({instance = holdInst, amount = v});
    }

    return transform;
}

function finalizeTrade(pid)
{
    local player = findPlayer(pid);

    if (player.tradePrice > player.gold)
    {
        sendPlayerPacket(pid, PacketType.TRADE_RESULT, 0);
        return;
    }

    foreach(v in player.tradeNpcItems)
    {
        GiveItem(pid, v.instance, (v.amount).tointeger());
    }

    foreach(v in player.tradePlayerItems)
    {
        RemoveItem(pid, v.instance, (v.amount).tointeger());
    }

    local calcGold = player.gold - player.tradePrice;
    player.setGold(calcGold);

    player.tradePrice = 0;
    player.tradeNpcItems = [];
    player.tradePlayerItems = [];
    player.tradeReady = false;

    sendPlayerPacket(pid, PacketType.TRADE_RESULT, 1);
}

function handleTrade(pid, item_list, target)
{
    local player = findPlayer(pid);
    local totalPrice = 0;

    if (item_list[0] != 0)
    {
        foreach(v in item_list)
        {
            local item = ServerItems.find(v.instance);
            if (item == null)
            {
                print("ERROR ITEM NULL + " + v.instance + " : " + v.amount);
                continue;
            }

            local price = item.price * v.amount;
            totalPrice += price;
        }
    }
    else
    {
        item_list = [];
    }

    if (target == 0) // player items
    {
        player.tradePrice -= totalPrice;
        player.tradePlayerItems = item_list;
    }
    else if (target == 1) // what player wants to buy
    {
        player.tradePrice += totalPrice;
        player.tradeNpcItems = item_list;
    }

    if (!player.tradeReady)
    {
        player.tradeReady = true;
        return;
    }

    finalizeTrade(pid);
}

function handleSpawnGround(pos, instance, amount = 1)
{
    local item = addGroundItem(pos, instance, amount);

    foreach(v in getPlayers())
    {
        sendPlayerPacket(v.id, PacketType.SPAWN_GROUND_ITEM, item.id, item.pos.x, item.pos.y, item.pos.z, item.instance, item.amount);
    }
}

function handlePickUp(pid, data)
{
    local item = getGroundItem(data[0]);
    GiveItem(pid, item.instance, item.amount);
    deleteGroundItem(data[0]);
}

function saveDescription(pid, val)
{
    local player = findPlayer(pid);

    player.setDescription(val);
}