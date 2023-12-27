Player <- {
    id = 0,
    gameState = GameState.UNKNOWN,
    canProceed = false,

    helper = createNpc("Helper"),
    bodyModel = ["Hum_Body_Naked0","Hum_Body_Babe0"],
    headModel = ["Hum_Head_FatBald","Hum_Head_Fighter","Hum_Head_Pony","Hum_Head_Bald","Hum_Head_Thief","Hum_Head_Psionic","Hum_Head_Babe"],
    cBodyModel = 0,
    cBodyTexture = 1,
    cHeadModel = 6,
    cHeadTexture = 108,
    music = Sound("muzyka.wav"),
    lang = "pl",
    charSlot = -1,
    eqArmor = "",
    eqWeapon = "",
    eqWeapon2h = "",
    items = [],
    gold = 3000000,
    level = 0,
    experience = 0,
    qa = ["", "", "", "", "", ""],
    desc = "",
    overlay = "NORMAL",
    fat = 0
};

ITEM_CHANGE <- false;

Player.updateVisual <- function(id = -1)
{
    if (id == -1) id = heroId;
    setPlayerVisual(id, Player.bodyModel[Player.cBodyModel], Player.cBodyTexture, Player.headModel[Player.cHeadModel], Player.cHeadTexture);
}

Player.manageItem <- function(act, instance, amount, slot)
{
    if (act == 0 || act == 1)
    {
        if (act == 0)
        {
            foreach(v in Player.items)
            {
                if (v.instance.toupper() == instance.toupper())
                {
                    v.amount = amount;
                    return;
                }
            }
        }
        Player.items.append({instance = instance, amount = amount, slot = slot });
    }
    else
    {
        foreach(i, v in Player.items)
        {
            if (v.instance.toupper() != instance.toupper())
            {
                continue;
            }

            if (act == 2)
            {
                v.amount = amount;
                ITEM_CHANGE = true;
                break;
            }

            if (act == 3)
            {
                for(local i = 0; i < 6; i++)
                {
                    if (v.instance.toupper() == Player.qa[i])
                    {
                        invUnequip(i + 4, v.instance.toupper());
                    }
                }

                RemoveInvSlot(v.instance);
                Player.items.remove(i);
                ITEM_CHANGE = true;
                return;
            }
        }
    }
}

function getUniqueItemsAmount()
{
    return Player.items.len();
}

Player.updateEquipped <- function(weapon, armor, ranged, helpers = Player.helper)
{
    if (armor != Player.eqArmor) {
        if (armor == "-1") {
            unequipItem(helpers, Items.id(Player.eqArmor));
            unequipItem(heroId, Items.id(Player.eqArmor));
        }
        Player.eqArmor = armor;
        equipItem(helpers, Items.id(armor));
        equipItem(heroId, Items.id(armor));
    }

    if (weapon != Player.eqWeapon) {
        if (weapon == "-1") {
            unequipItem(helpers, Items.id(Player.eqWeapon));
            unequipItem(heroId, Items.id(Player.eqWeapon));
        }
        Player.eqWeapon = weapon;
        setPlayerDexterity(helpers, 300);
        setPlayerStrength(helpers, 300);
        equipItem(helpers, Items.id(weapon));
        equipItem(heroId, Items.id(weapon));
    }

    if (ranged != Player.eqWeapon2h) {
        if (ranged == "-1") {
            unequipItem(helpers, Items.id(Player.eqWeapon2h));
            unequipItem(heroId, Items.id(Player.eqWeapon2h));
        }
        Player.eqWeapon2h = ranged;
        setPlayerDexterity(helpers, 300);
        setPlayerStrength(helpers, 300);
        equipItem(helpers, Items.id(ranged));
        equipItem(heroId, Items.id(ranged));
    }
}

Player.refreshEq <- function(id)
{
    switch(id) {
        case 2:
            sendPacket(PacketType.EQUIP_MELEE, Player.eqWeapon);
        break;

        case 4:
            sendPacket(PacketType.EQUIP_RANGED, Player.eqWeapon2h)
        break;

        case 16:
            sendPacket(PacketType.EQUIP_ARMOR, Player.eqArmor);
        break;
    }
}

Player.refreshQA <- function(id)
{
    switch(id) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            sendPacket(PacketType.UPDATE_QA, id, Player.qa[id-1]);
        break;
    }
}

Player.moveItems <- function(id1, id2)
{
    sendPacket(PacketType.MOVE_ITEMS, id1, id2);

    local holder = -1;

    foreach (v in Player.items)
    {
        if (v.slot == id1)
        {
            if (holder == -1)
            {
                holder = v.slot;
                v.slot = id2;
            }
            else
            {
                v.slot = holder;
            }
        }
        else if (v.slot == id2)
        {
            if (holder == -1)
            {
                holder = v.slot;
                v.slot = id1;
            }
            else
            {
                v.slot = holder;
            }
        }
    }

    updateInvEqColor();
}

function getItemAmount(instance)
{
    foreach(v in Player.items) {
        if (v.instance.toupper() == instance.toupper())
        {
            return v.amount;
        }
    }
}

function getItemPrice(instance)
{
    if (instance == "") return 0;

    local item = ServerItems.find(instance);

    return item.price;
}

function findItemBySlot(slot)
{
    foreach (item in Player.items) {
        if (item.slot == slot) {
            return item;
        }
    }

    return -1;
}

function findPositionBySlot(item)
{
    foreach(i, v in Player.items) {
        if (v.slot == item) return i;
    }

    return -1;
}

Player.addExperience <- function(val)
{
    Player.experience += val;
    STATS_AWAITING = true;
}

Player.addLevel <- function(val)
{
    Player.level += val;
    STATS_AWAITING = true;
}
