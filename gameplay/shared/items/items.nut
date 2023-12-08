ItemType <-
{
    OTHER = 1, // other not usable items
    WEAPON = 2, // 1h melee and 2h melee weapon
    RANGED = 4, // bow and crossbow
    AMMO = 8, // ammunition used for ranged weapon eg. arrow and bolts
    ARMOR = 16, // player armor
    FOOD = 32,  // everything that player can eat or drink
    POTION = 128, // eg. health potion, mana potion, speed potion
    MAGIC = 512 // runes, do not confuse with scrolls
};

local item_table = [];
ServerItems <- {};

ServerItems.add <- function(item_struct)
{
    item_table.append(item_struct);
}

ServerItems.get <- function()
{
    return items;
}

ServerItems.find <- function(inst)
{
    foreach(v in item_table)
    {
        if ((v.instance).toupper() == (inst).toupper())
        {
            return v;
        }
    }

    return null;
}

ServerItems.getName <- function(inst)
{
    local temp = ServerItems.find(inst);

    if (temp != null)
    {
        return temp.name;
    }

    return null;
}

function handleWeaponInfo(item)
{
    local result = [];
    result.append("Level required: " + item.levelRequired);

    if (item.damage.physical > 0)
        result.append("Physical damage: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Magical damage: " + item.damage.magical);
    else
        result.append("");

    if (item.bonusStats.critical != null)
        result.append("Bonus critical: " + item.bonusStats.critical);
    else
        result.append("");

    return result;
}

function handleArmorInfo(item)
{
    local result = [];

    result.append("Level required: " + item.levelRequired);

    if (item.defence.physical > 0)
        result.append("Physical defence: " + item.defence.physical);
    else
        result.append("");

    if (item.defence.magical > 0)
        result.append("Magical defence: " + item.defence.magical);
    else
        result.append("");

    if (item.bonusStats.strength != null)
        result.append("Bonus strength: " + item.bonusStats.strength);
    else
        result.append("");

    return result;
}

function handleAmmoInfo(item)
{
    local result = [];

    result.append("Ammunition for ranged weapon");

    if (item.damage.physical > 0)
        result.append("Physical damage: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Magical damage: " + item.damage.magical);
    else
        result.append("");

    if (item.bonusStats.critical != null)
        result.append(item.bonusStats.critical);
    else
        result.append("");

    return result;
}

function handleMagicInfo(item)
{
    local result = [];

    if (item.magicLevelRequired == 0)
        result.append("Scroll")
    else
        result.append("Magic level required: " + item.magicLevelRequired);

    if (item.damage.physical > 0)
        result.append("Physical damage: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Magical damage: " + item.damage.magical);
    else
        result.append("");

    if (item.cost.mana > 0)
        result.append("Mana cost: " + item.cost.mana);
    else
        result.append("");

    return result;
}

function handleFoodInfo(item)
{
    local result = [];

    result.append("Consumable");
    result.append("");

    if (item.restores.health > 0)
        result.append("Restores health: " + item.restores.health);
    else
        result.append("");

    if (item.restores.mana > 0)
        result.append("Restores mana: " + item.restores.mana);
    else
        result.append("");

    return result;
}

function handlePotionInfo(item)
{
    local result = [];

    result.append("Consumable");
    result.append("");

    if (item.restores.health > 0)
        result.append("Restores health: " + item.restores.health);
    else
        result.append("");

    if (item.restores.mana > 0)
        result.append("Restores mana: " + item.restores.mana);
    else
        result.append("");

    return result;
}

function handleOtherInfo(item)
{
    local result = [];

    result.append("");
    result.append("");
    result.append("");
    result.append("Price: " + item.price);

    return result;
}