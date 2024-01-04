ItemType <-
{
    OPENABLE = 0,
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

local function weaponInfoEnglish(item)
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

local function weaponInfoPolish(item)
{
    local result = [];

    result.append("Wymagany poziom: " + item.levelRequired);

    if (item.damage.physical > 0)
        result.append("Obra�enia fizyczne: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Obra�enia magiczne: " + item.damage.magical);
    else
        result.append("");

    if (item.bonusStats.critical != null)
        result.append("Bonus krytyczny: " + item.bonusStats.critical);
    else
        result.append("");

    return result;
}

function handleWeaponInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = weaponInfoEnglish(item);
        break;

        case "pl":
            result = weaponInfoPolish(item);
        break;
    }

    return result;
}

function armorInfoEnglish(item)
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

function armorInfoPolish(item)
{
    local result = [];

    result.append("Wymagany poziom: " + item.levelRequired);

    if (item.defence.physical > 0)
        result.append("Obrona fizyczna: " + item.defence.physical);
    else
        result.append("");

    if (item.defence.magical > 0)
        result.append("Obrona magiczna: " + item.defence.magical);
    else
        result.append("");

    if (item.bonusStats.strength != null)
        result.append("Bonus do si�y: " + item.bonusStats.strength);
    else
        result.append("");

    return result;
}

function handleArmorInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = armorInfoEnglish(item);
        break;

        case "pl":
            result = armorInfoPolish(item);
        break;
    }

    return result;
}

function ammoInfoEnglish(item)
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

function ammoInfoPolish(item)
{
    local result = [];

    result.append("Amunicja do broni dalekosi�nej");

    if (item.damage.physical > 0)
        result.append("Obra�enia fizyczne: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Obra�enia magiczne: " + item.damage.magical);
    else
        result.append("");

    if (item.bonusStats.critical != null)
        result.append(item.bonusStats.critical);
    else
        result.append("");

    return result;
}

function handleAmmoInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = ammoInfoEnglish(item);
        break;

        case "pl":
            result = ammoInfoPolish(item);
        break;
    }

    return result;
}

function magicInfoEnglish(item)
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

function magicInfoPolish(item)
{
    local result = [];

    if (item.magicLevelRequired == 0)
        result.append("Zw�j")
    else
        result.append("Wymagany kr�g magii: " + item.magicLevelRequired);

    if (item.damage.physical > 0)
        result.append("Obra�enia fizyczne: " + item.damage.physical);
    else
        result.append("");

    if (item.damage.magical > 0)
        result.append("Obra�enia magiczne: " + item.damage.magical);
    else
        result.append("");

    if (item.cost.mana > 0)
        result.append("Koszt many: " + item.cost.mana);
    else
        result.append("");

    return result;
}


function handleMagicInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = magicInfoEnglish(item);
        break;

        case "pl":
            result = magicInfoPolish(item);
        break;
    }

    return result;
}

function foodInfoEnglish(item)
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

function foodInfoPolish(item)
{
    local result = [];

    result.append("Mo�na spo�y�");
    result.append("");

    if (item.restores.health > 0)
        result.append("Odnawia �ycie: " + item.restores.health);
    else
        result.append("");

    if (item.restores.mana > 0)
        result.append("Odnawia man�: " + item.restores.mana);
    else
        result.append("");

    return result;
}

function handleFoodInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = foodInfoEnglish(item);
        break;

        case "pl":
            result = foodInfoPolish(item);
        break;
    }

    return result;
}

function potionInfoEnglish(item)
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

function potionInfoPolish(item)
{
    local result = [];

    result.append("Mo�na spo�y�");
    result.append("");

    if (item.restores.health > 0)
        result.append("Odnawia �ycie: " + item.restores.health);
    else
        result.append("");

    if (item.restores.mana > 0)
        result.append("Odnawia man�: " + item.restores.mana);
    else
        result.append("");

    return result;
}


function handlePotionInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = potionInfoEnglish(item);
        break;

        case "pl":
            result = potionInfoPolish(item);
        break;
    }

    return result;
}

function otherInfoEnglish(item)
{
    local result = [];

    result.append("");
    result.append("");
    result.append("");
    result.append("");

    return result;
}

function otherInfoPolish(item)
{
    local result = [];

    result.append("");
    result.append("");
    result.append("");
    result.append("");

    return result;
}

function handleOtherInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = otherInfoEnglish(item);
        break;

        case "pl":
            result = otherInfoPolish(item);
        break;
    }

    return result;
}

function openableInfoEnglish(item)
{
    local result = [];

    result.append("Can be opened");
    result.append("");
    result.append("");
    result.append("");

    return result;
}

function openableInfoPolish(item)
{
    local result = [];

    result.append("Można otworzyć");
    result.append("");
    result.append("");
    result.append("");

    return result;
}

function handleOpenableInfo(item, lang = "en")
{
    local result = null;

    switch(lang)
    {
        case "en":
            result = openableInfoEnglish(item);
        break;

        case "pl":
            result = openableInfoPolish(item);
        break;
    }

    return result;
}