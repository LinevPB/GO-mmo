local players = [];
RESPAWN_TIME <- 15;

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

    level = null;
    experience = null;
    skillPoints = null;
    health = null;
    max_health = null;
    mana = null;
    max_mana = null;
    strength = null;
    dexterity = null;
    skill_1h = null;
    skill_2h = null;
    skill_bow = null;
    skill_cbow = null;
    magic_circle = null;
    gold = null;
    tradeReady = null;
    tradePrice = null;
    tradePlayerItems = null;
    tradeNpcItems = null;
    dead = null;
    char_desc = null;
    char_amount = null;
    fat = null;
    overlay = null;

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
        tradeReady = false;

        level = null;
        experience = null;
        health = null;
        max_health = null;
        mana = null;
        max_mana = null;
        strength = null;
        dexterity = null;
        skill_1h = null;
        skill_2h = null;
        skill_bow = null;
        skill_cbow = null;
        magic_circle = null;
        gold = null;

        tradePrice = 0;
        tradePlayerItems = [];
        tradeNpcItems = [];
        dead = false;
        char_desc = "";
        char_amount = 0;
        overlay = "NORMAL";
        fat = 0.0;
        skillPoints = 0;
    }

    function addItem(instance, amount, loading = false, slot = -1)
    {
        if (amount <= 0) return;

        foreach(v in items)
        {
            if (v.instance.toupper() == instance.toupper())
            {
                v.amount += amount;
                sendPlayerPacket(id, PacketType.UPDATE_ITEM, 0, instance, v.amount, v.slot);
                return {val = false, instance = v.instance, amount = v.amount, slot = v.slot};
            }
        }

        if (slot == -1)
        {
            local marked = false;
            for(local i = 0; i < 90; i++)
            {
                foreach(v in items)
                {
                    if (v.slot == i)
                    {
                        marked = true;
                    }
                }

                if (!marked)
                {
                    items.append({instance = instance, amount = amount, slot = i});
                    slot = i;
                    marked = false;
                    sendPlayerPacket(id, PacketType.UPDATE_ITEM, 1, instance, amount, slot);
                    return {val = true, instance = instance, amount = amount, slot = slot}
                }

                if (marked && i < 90)
                {
                    marked = false;
                }
            }
        }
        else
        {
            items.append({instance = instance, amount = amount, slot = slot});
            sendPlayerPacket(id, PacketType.UPDATE_ITEM, 1, instance, amount, slot);
            return {val = true, instance = instance, amount = amount, slot = slot};
        }

        return;
    }

    function removeItem(instance, amount)
    {
        foreach(i, v in items)
        {
            if (v.instance.toupper() == instance.toupper())
            {
                local temp = v.amount;
                v.amount -= amount;

                if (v.amount <= 0)
                {
                    v.amount = 0;
                    sendPlayerPacket(id, PacketType.UPDATE_ITEM, 3, v.instance, v.amount, v.slot);

                    return { removed = true, more = items.remove(i), amount = temp };
                }

                sendPlayerPacket(id, PacketType.UPDATE_ITEM, 2, v.instance, v.amount, v.slot);

                return { removed = false, more = v, amount = amount };
            }
        }

        return { removed = 2137 };
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

    function setLevel(val, loading=false)
    {
        level = val;
        sendPlayerPacket(id, PacketType.UPDATE_LEVEL, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `level` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setExperience(val, loading=false)
    {
        experience = val;
        sendPlayerPacket(id, PacketType.UPDATE_EXPERIENCE, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `exp` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setSkillPoints(val, loading=false)
    {
        skillPoints = val;
        sendPlayerPacket(id, PacketType.UPDATE_SKILLPOINTS, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `skill_points` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setHealth(val, loading=false)
    {
        if (val > max_health) val = max_health;
        if (val < 1) val = 1;

        health = val;
        setPlayerHealth(id, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `health` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setMaxHealth(val, loading=false)
    {
        if (val < 1) val = 1;

        max_health = val;
        setPlayerMaxHealth(id, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `max_health` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setMana(val, loading=false)
    {
        if (val > max_mana) val = max_mana;
        mana = val;
        setPlayerMana(id, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `mana` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setMaxMana(val, loading=false)
    {
        max_mana = val;
        setPlayerMaxMana(id, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `max_mana` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setStrength(val, loading=false)
    {
        strength = val;
        setPlayerStrength(id, 1000);
        sendPlayerPacket(id, PacketType.UPDATE_STRENGTH, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `strength` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setDexterity(val, loading=false)
    {
        dexterity = val;
        setPlayerDexterity(id, 1000);
        sendPlayerPacket(id, PacketType.UPDATE_DEXTERITY, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `dexterity` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setSkill1h(val, loading=false)
    {
        skill_1h = val;
        setPlayerSkillWeapon(id, WEAPON_1H, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `skill_1h` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setSkill2h(val, loading=false)
    {
        skill_2h = val;
        setPlayerSkillWeapon(id, WEAPON_2H, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `skill_2h` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setSkillBow(val, loading=false)
    {
        skill_bow = val;
        setPlayerSkillWeapon(id, WEAPON_BOW, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `skill_bow` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setSkillCBow(val, loading=false)
    {
        skill_cbow = val;
        setPlayerSkillWeapon(id, WEAPON_CBOW, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `skill_cbow` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setMagicCircle(val, loading=false)
    {
        magic_circle = val;
        setPlayerMagicLevel(id, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `magic_circle` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setGold(val, loading=false)
    {
        gold = val;
        sendPlayerPacket(id, PacketType.UPDATE_GOLD, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `gold` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setFatness(val, loading=false)
    {
        fat = val;
        setPlayerFatness(id, val.tofloat());

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `fat` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setOverlay(val, loading=false)
    {
        overlay = getOverlayById(val);
        applyPlayerOverlay(id, Mds.id(overlay));

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `overlay` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function setDescription(val, loading = false)
    {
        char_desc = val;
        sendPlayerPacket(id, PacketType.UPDATE_DESC, val);

        if (loading == false)
            mysql.squery("UPDATE `characters` SET `char_desc` = '" + val + "' WHERE `id`='" + charId + "'");
    }

    function addGold(val)
    {
        setGold(gold + val);
        sendPlayerPacket(id, PacketType.ADD_GOLD, val);
    }

    function addExperience(val)
    {
        setExperience(experience + val);
        checkLevel();
        sendPlayerPacket(id, PacketType.ADD_EXPERIENCE, val);
    }

    function checkLevel()
    {
        if (experience >= calcNextLevelExperience(level))
        {
            setLevel(level + 1);
            sendPlayerPacket(id, PacketType.LEVEL_UP);
        }
    }

    function die()
    {
        dead = true;
        foreach(v in players)
        {
            sendPlayerPacket(v.id, PacketType.PLAYER_DIE, id, RESPAWN_TIME);
        }
        setTimer(respawnPlayer, RESPAWN_TIME * 1000, 1, id);
    }

    function respawn()
    {
        foreach(v in players)
        {
            sendPlayerPacket(v.id, PacketType.PLAYER_RESPAWN, id);
        }
        setPlayerPosition(id, 0, 300, 0);
        setHealth((max_health / 10).tointeger());

        dead = false;
    }

    function getHealth()
    {
        return health;
    }

    function getMana()
    {
        return mana;
    }

    function getSkillPoints()
    {
        return skillPoints;
    }
}

function respawnPlayer(pid)
{
    local player = findPlayer(pid);
    if (player == -1) return;

    player.respawn();
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

function updatePlayer(pid, level, exp, health, max_health, mana, max_mana, strength, dexterity, skill_1h, skill_2h, skill_bow, skill_cbow, magic_circle, gold, char_desc, sp)
{
    local player = findPlayer(pid);

    player.setLevel(level, true);
    player.setExperience(exp, true);
    player.setMaxHealth(max_health, true);
    player.setHealth(health, true);
    player.setMaxMana(max_mana, true);
    player.setMana(mana, true);
    player.setStrength(strength, true);
    player.setDexterity(dexterity, true);
    player.setSkill1h(skill_1h, true);
    player.setSkill2h(skill_2h, true);
    player.setSkillBow(skill_bow, true);
    player.setSkillCBow(skill_cbow, true);
    player.setMagicCircle(magic_circle, true);
    player.setGold(gold, true);
    player.setDescription(char_desc, true);
    player.setSkillPoints(sp, true);
}

function GiveItem(pid, instance, amount, loading = false, slot = -1)
{
    local player = findPlayer(pid);
    local item = player.addItem(instance, amount, loading, slot);

    giveItem(pid, Items.id(instance), amount);

    if (loading == true) return;

    sendPlayerPacket(pid, PacketType.GIVE_ITEM_NOTIFY, instance, amount);

    if (item.val == true)
        mysql.squery("INSERT INTO `items` (`id`, `instance`, `amount`, `slot`, `owner`) VALUES (NULL, '" + item.instance + "', '" + item.amount + "', '" + item.slot + "', '" + player.charId + "')");
    else {
        mysql.squery("UPDATE `items` SET `amount` = '" + item.amount + "' WHERE `owner`='" + player.charId + "' AND `instance`='" + item.instance + "'");
    }
}

function RemoveItem(pid, instance, amount)
{
    local player = findPlayer(pid);
    local item = player.removeItem(instance, amount);

    if (item.removed == 2137)
    {
        return console.error("Error " + pid + " " + instance + " " + amount);
    }

    removeItem(pid, Items.id(instance), amount);

    if (!item.removed)
        mysql.squery("UPDATE `items` SET `amount` = '" + item.more.amount + "' WHERE `owner`='" + findPlayer(pid).charId + "' AND `instance`='" + item.more.instance + "'");
    else
        mysql.squery("DELETE FROM `items` WHERE `owner`='" + player.charId + "' AND `instance`='" + item.more.instance + "'");

    return item;
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

    if (id1[0] == null && id2[0] != null)
    {
        foreach(v in player.items)
        {
            if (v.slot == fid2)
            {
                v.slot = fid1;
                break;
            }
        }

        mysql.squery("UPDATE `items` SET `slot` = '" + fid1 + "' WHERE `id`=" + id2[0][0]);
    }

    if (id1[0] != null && id2[0] == null)
    {
        foreach(v in player.items)
        {
            if (v.slot == fid1)
            {
                v.slot = fid2;
                break;
            }
        }

        mysql.squery("UPDATE `items` SET `slot` = '" + fid2 + "' WHERE `id`=" + id1[0][0]);
    }

    if (id1[0] != null && id2[0] != null)
    {
        local holderId = -1;

        foreach(v in player.items)
        {
            if (v.slot == fid1 && holderId == -1)
            {
                holderId = v.slot;
                v.slot = fid2;
            }

            if (v.slot == fid2 && holderId == -1)
            {
                holderId = v.slot;
                v.slot = fid1;
            }

            if (holderId != -1 && (v.slot == fid1 || v.slot == fid2))
            {
                v.slot = holderId;
                break;
            }
        }

        mysql.squery("UPDATE `items` SET `slot` = '" + fid2 + "' WHERE `id`=" + id1[0][0]);
        mysql.squery("UPDATE `items` SET `slot` = '" + fid1 + "' WHERE `id`=" + id2[0][0]);
    }
}

function UseItem(pid, instance, amount)
{
    local item = ServerItems.find(instance);
    local player = findPlayer(pid);

    if (item.restores)
    {
        if (item.restores.health)
        {
            player.setHealth(player.getHealth() + item.restores.health);
        }

        if (item.restores.mana)
        {
            player.setMana(player.getMana() + item.restores.mana);
        }
    }

    RemoveItem(pid, instance, amount);
}

function OpenItem(pid, instance, amount)
{
    RemoveItem(pid, instance, amount);

    local item = ServerItems.find(instance);
    local player = findPlayer(pid);

    foreach(v in item.box)
    {
        GiveItem(pid, v.instance, v.amount);
    }

    if (item.gold)
    {
        player.addGold(item.gold);
    }
}

function DropItem(pid, instance, amount)
{
    local item = RemoveItem(pid, instance, amount);
    local pos = getPlayerPosition(pid);

    handleSpawnGround(pos, item.more.instance, item.amount);
}

function ManageQA(pid, id, instance)
{
    local player = findPlayer(pid);
    mysql.squery("UPDATE `characters` SET `qa" + id + "` = '" + instance + "' WHERE `id`=" + player.charId);
}

function HitPlayer(pid, val)
{
    local player = findPlayer(pid);
    local calcHealth = player.health - val;

    if (calcHealth < 1)
    {
        calcHealth = 1;
        player.die();
    }

    player.setHealth(calcHealth);
}
