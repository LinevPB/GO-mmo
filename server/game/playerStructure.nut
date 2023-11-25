local players = [];

class PlayerStructure
{
    id = null;
    dbId = null;
    logged = null;
    nickname = null;
    gameState = null;

    charId = null;
    charSlot = null;
    charName = null;

    items = null;
    eqArmor = null;
    eqWeapon = null;
    eqWeapon2h = null;

    constructor(playerid)
    {
        gameState = GameState.UNKNOWN;
        id = playerid;
        logged = false;
        nickname = "";
        dbId = null;
        charId = null;
        charSlot = null;
        charName = null;
        items = [];
        eqArmor = null;
        eqWeapon = null;
        eqWeapon2h = null;
    }

    function addItem(instance, amount, loading = false, slot = -1)
    {
        if (amount <= 0) return;
        foreach(v in items) {
            if (v.instance == instance) {
                v.amount += amount;
                sendPlayerPacket(id, PacketType.UPDATE_ITEM, 0, instance, v.amount, v.slot);
                return {val = true, instance = v.instance, amount = v.amount, slot = v.slot};
            }
        }

        if (slot == -1) {
            local marked = false;
            for(local i = 0; i < 90; i++) {
                foreach(v in items) {
                    if (v.slot == i) marked = true;
                }
                if (!marked) {
                    items.append({instance = instance, amount = amount, slot = i});
                    slot = i;
                    marked = false;
                    break;
                }
                if (marked && i < 90) {
                    marked = false;
                }
            }

            if (!marked) sendPlayerPacket(id, PacketType.UPDATE_ITEM, 1, instance, amount, slot); return true;
        } else {
            items.append({instance = instance, amount = amount, slot = slot});
            sendPlayerPacket(id, PacketType.UPDATE_ITEM, 1, instance, amount, slot);
            return {val = true, instance = instance, amount = amount, slot = slot};
        }

        return {val = false };
    }

    function removeItem(instance, amount)
    {
        foreach(i, v in items) {
            if (v.instance == instance) {
                v.amount -= amount;
                if (v.amount <= 0) {
                    v.amount = 0;
                    sendPlayerPacket(id, PacketType.UPDATE_ITEM, 3, v.instance, v.amount, v.slot);
                    return items.remove(i);
                }
                sendPlayerPacket(id, PacketType.UPDATE_ITEM, 2, v.instance, v.amount, v.slot);
                return v;
            }
        }
    }

    function getItems()
    {
        return items;
    }

    function setNickname(nick)
    {
        nickname = nick;
    }

    function setStatus(val)
    {
        logged = val;
    }
}

function findPlayer(pid)
{
    foreach(v in players) {
        if (v.id == pid) return v;
    }

    return -1;
}

function getPlayers()
{
    return players;
}

function addPlayer(pStruct)
{
    return players.append(pStruct);
}

function removePlayer(pStruct)
{
    foreach(i, v in players) {
        if (v == pStruct) return players.remove(i);
    }
}

function removePlayerById(id)
{
    foreach(i, v in players) {
        if (v.id == id) return players.remove(i);
    }
}

function GiveItem(pid, instance, amount, loading = false, slot = -1)
{
    local player = findPlayer(pid);
    local item = player.addItem(instance, amount, loading, slot);
    if (loading == true)
        return giveItem(pid, Items.id(instance), amount);

    if (item.val == true)
        mysql.squery("INSERT INTO `items` (`id`, `instance`, `amount`, `slot`, `owner`) VALUES (NULL, '" + item.instance + "', '" + item.amount + "', '" + item.slot + "', '" + player.charId + "')");
    else
        mysql.squery("UPDATE `items` SET `amount` = '" + item.amount + "' WHERE `owner`=" + player.charId + "' AND `instance`='" + item.instance + "'");
}

function RemoveItem(pid, instance, amount)
{
    local item = Player.removeItem(instance, amount);
    mysql.squery("UPDATE `items` SET `amount` = '" + item.amount + "' WHERE `owner`=" + findPlayer(pid).charId + "' AND `instance`='" + item.instance + "'");
}

function LoadItems(pid, heroId)
{
    local result = mysql.gquery("SELECT `instance`, `amount`, `slot` FROM `items` WHERE `owner`='" + heroId + "'");
    if (result[0] == null) return;

    foreach(v in result) {
        GiveItem(pid, v[0], v[1], true, v[2]);
    }
}

function EquipArmor(pid, instance)
{
    if (instance == "") return UnequipArmor(pid);
    if (instance == -1) return;

    local player = findPlayer(pid);
    player.eqArmor = instance;
    equipItem(pid, Items.id(instance));

    mysql.squery("UPDATE `characters` SET `eqArmor` = '" + instance + "' WHERE `id`=" + player.charId);
}

function UnequipArmor(pid)
{
    local player = findPlayer(pid);
    if (player.eqArmor != null) unequipItem(pid, Items.id(player.eqArmor));
    player.eqArmor = null;

    mysql.squery("UPDATE `characters` SET `eqArmor` = '" + "-1" + "' WHERE `id`=" + player.charId);
}

function EquipWeapon(pid, instance)
{
    if (instance == "") return UnequipWeapon(pid);
    if (instance == -1) return;

    local player = findPlayer(pid);
    player.eqWeapon = instance;
    equipItem(pid, Items.id(instance));

    mysql.squery("UPDATE `characters` SET `eqWeapon` = '" + instance + "' WHERE `id`=" + player.charId);
}

function UnequipWeapon(pid)
{
    local player = findPlayer(pid);
    if (player.eqWeapon != null) unequipItem(pid, Items.id(player.eqWeapon));
    player.eqWeapon = null;

    mysql.squery("UPDATE `characters` SET `eqWeapon` = '" + "-1" + "' WHERE `id`=" + player.charId);
}

function EquipWeapon2h(pid, instance)
{
    if (instance == "") return UnequipWeapon2h(pid);
    if (instance == -1) return;

    local player = findPlayer(pid);
    player.eqWeapon2h = instance;
    equipItem(pid, Items.id(instance));

    mysql.squery("UPDATE `characters` SET `eqWeapon2h` = '" + instance + "' WHERE `id`=" + player.charId);
}

function UnequipWeapon2h(pid)
{
    local player = findPlayer(pid);
    if (player.eqWeapon2h != null) unequipItem(pid, Items.id(player.eqWeapon2h));
    player.eqWeapon2h = null;

    mysql.squery("UPDATE `characters` SET `eqWeapon2h` = '" + "-1" + "' WHERE `id`=" + player.charId);
}

function MoveItems(pid, fid1, fid2)
{
    if (fid1 == fid2) return;

    local player = findPlayer(pid);
    local id1 = mysql.gquery("SELECT id FROM items WHERE owner=" + player.charId + " AND slot=" + fid1);
    local id2 = mysql.gquery("SELECT id FROM items WHERE owner=" + player.charId + " AND slot=" + fid2);

    if (id1[0] == null && id2[0] != null) {
        mysql.squery("UPDATE `items` SET `slot` = '" + fid1 + "' WHERE `id`=" + id2[0][0]);
    }
    if (id1[0] != null && id2[0] == null) {
        mysql.squery("UPDATE `items` SET `slot` = '" + fid2 + "' WHERE `id`=" + id1[0][0]);
    }
    if (id1[0] != null && id2[0] != null) {
        mysql.squery("UPDATE `items` SET `slot` = '" + fid2 + "' WHERE `id`=" + id1[0][0]);
        mysql.squery("UPDATE `items` SET `slot` = '" + fid1 + "' WHERE `id`=" + id2[0][0]);
    }
    if (id1[0] == null && id2[0] == null) {
        print("???");
    }
}

// function SaveItems(pid, heroId)
// {
//     local player = findPlayer(pid);
//     local items = player.getItems();
//     local itemsDb = mysql.gquery("SELECT instance, amount FROM items WHERE owner=" + player.charId);
//     //mysql.squery("DELETE FROM items WHERE `owner`=" + findPlayer(pid).charId + "' AND `instance`='" + v.instance + "'");
//     local ids = [];
//     foreach(i, v in items) {
//         foreach(i, k in itemsDb) {
//             if (v.instance == k[0]) {
//                 if (v.amount == k[1]) continue;
//                 mysql.squery("UPDATE `items` SET `amount` = '" + v.amount + "' WHERE `owner`=" + findPlayer(pid).charId + "' AND `instance`='" + v.instance + "'");
//                 continue;
//             }
//         }
//         mysql.squery("INSERT INTO `items` (`id`, `instance`, `amount`, `owner`) VALUES (NULL, '" + v.instance + "', '" + v.amount + "', '" + player.charId + "')");
//     }
// }