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
    local username = data[0];
    local pass = data[1];
    local remember = data[2];

    local result = logIn(username, pass);

    if (!result)
        return loginFailed(pid, "Player " + username + " failed to log in.");

    loginSuccessful(pid, username, "Player " + username + " logged in.", result);
    ChangeGameState(pid, GameState.CHARACTER_SELECTION);

    if (remember == 1)
    {
        local uid = getPlayerUID(pid);
        mysql.squery("UPDATE `unique_ids` SET `remember` = '" + remember + "', `remember_name` = '" + username + "' WHERE `uid`='" + uid + "'");
    }
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
            loginHandler(pid, [data[0], data[1], data[3]]);
            break;
    }
}

function messageHandler(pid, data)
{
    local sid = data[0];
    local message = data[1];
    local nickname = findPlayer(sid).charName;

    handleChatMessage(pid, nickname, message);

    console.log(nickname + ": " + message);
}

function charactersHandler(pid, data)
{
    local temp = findPlayer(pid);
    if (temp.logged)
    {
        local result = mysql.gquery("SELECT id, pid, name, bodyModel, bodyTex, headModel, headTex, eqArmor, eqWeapon, slotId, eqWeapon2h, level, fat FROM characters WHERE pid='" + temp.dbId + "'");
        if (result[0] != null)
        {
            foreach(i, v in result)
            {
                if (v[1].tointeger() != temp.dbId) continue;

                sendPlayerPacket(pid, PacketType.CHARACTERS_RECEIVE, i, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12]);
            }

            temp.char_amount = result.len();
        }
        else
        {
            temp.char_amount = 0;
        }

        sendPlayerPacket(pid, PacketType.CHARACTERS_FINISHED, 1);
        ChangeGameState(pid, GameState.CHARACTER_SELECTION);
    }
}

function selectHandler(pid, data)
{
    local slotId = data[0]; // 7

    local temp = findPlayer(pid);

    local result = mysql.gquery("SELECT id, pid, name, bodyModel, bodyTex, headModel, headTex, slotId, eqArmor, eqWeapon, eqWeapon2h, level, exp, health, max_health, mana, max_mana, strength, dexterity, skill_1h, skill_2h, skill_bow, skill_cbow, magic_circle, gold, x, y, z, qa1, qa2, qa3, qa4, qa5, qa6, char_desc, fat, overlay, skill_points FROM characters WHERE slotId='" + slotId + "' AND pid='" + temp.dbId + "'");
    local v = result[0];

    if (v == null) return sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, -1);

    setupChar(pid, v[2], v[9], v[8], v[9], v[10], v[0], v[35], v[36]);
    sendPlayerPacket(pid, PacketType.CHARACTERS_SELECT, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[8], v[9], v[7], v[28], v[29], v[30], v[31], v[32], v[33]);
    setPlayerVisual(pid, BodyModel[v[3]], v[4], HeadModel[v[5]], v[6]);

    updatePlayer(pid, v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18], v[19], v[20], v[21], v[22], v[23], v[24], v[34], v[37]);
    setPlayerPosition(pid, v[25], v[26], v[27]);
    spawnPlayer(pid);
    ChangeGameState(pid, GameState.PLAY);
}

function createHandler(pid, data)
{
    local player = findPlayer(pid);

    sendPlayerPacket(pid, PacketType.CHARACTERS_CREATE, player.char_amount);
    ChangeGameState(pid, GameState.CHARACTER_CREATION);
}

function setupChar(pid, name, charSlot, eqArmor, eqWeapon, eqWeapon2h, charId, fat, overlay)
{
    local temp = findPlayer(pid);
    setPlayerName(pid, name);

    temp.charName = name;
    temp.charSlot = charSlot;
    temp.charId = charId;
    LoadItems(pid, charId);
    EquipArmor(pid, eqArmor);
    EquipWeapon(pid, eqWeapon);
    EquipWeapon2h(pid, eqWeapon2h);
    temp.setFatness(fat);
    temp.setOverlay(overlay);
}

function creationConfirmHandler(pid, data)
{
    local name = data[0];
    name = filter_sql(name);

    if (name.len() > 20 || name.len() < 3) return;

    local bodyMod = data[1];
    local bodyTex = data[2];
    local headMod = data[3];
    local headTex = data[4];
    local slotId = data[5];
    local fat = data[6];
    local overlay = getOverlayId(data[7]);
    local player = findPlayer(pid);
    local dbId = player.dbId;

    local result = mysql.squery("INSERT INTO `characters` (`id`, `pid`, `slotId`, `name`, `bodyModel`, `bodyTex`, `headModel`, `headTex`, `eqWeapon`, `eqArmor`, `fat`, `overlay`, `x`, `y`, `z`) VALUES (NULL,'" +
    dbId + "','" + slotId + "','" + name + "','" + bodyMod + "','" + bodyTex + "','" + headMod + "','" + headTex + "','-1', '-1', '" + fat + "', '" + overlay + "', '-93537.2', '302.344', '-116443')");
    local result1 = mysql.gquery("SELECT id FROM characters WHERE pid='" + dbId + "' AND slotId='" + slotId + "'");
    player.charId = result1[0];
    player.charName = name;

    sendPlayerPacket(pid, PacketType.CHARACTER_CREATION_CONFIRM, slotId, dbId, name, bodyMod, bodyTex, headMod, headTex, fat, overlay);

    ChangeGameState(pid, GameState.CHARACTER_SELECTION);
    setupChar(pid, name, slotId, "-1", "-1", "-1", result1[0], fat, overlay);
    setPlayerVisual(pid, BodyModel[bodyMod], bodyTex, HeadModel[headMod], headTex);
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

    if (player.tradeNpcItems.len() == 0 && player.tradePlayerItems.len() == 0)
    {
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

    val = filter_sql(val);

    if (val.len() > 128)
    {
        val = val.slice(0, 127);
    }

    player.setDescription(val);
}

function handleRemembered(pid)
{
    local uid = getPlayerUID(pid);
    local result = mysql.gquery("SELECT remember, remember_name FROM unique_ids WHERE uid='" + uid + "'");

    if (result[0] == null) return;

    sendPlayerPacket(pid, PacketType.ASK_FOR_REMEMBERED, result[0][1], result[0][0]);
}


function handlePlayerDamage(pid, kid, desc)
{
    cancelEvent();
}
addEventHandler("onPlayerHit", handlePlayerDamage);

function playPlayerAnimation(pid, anim)
{
    foreach(v in ANIMS)
    {
        if (v.name != anim) continue;

        playAni(pid, v.instance);

        return;
    }
}