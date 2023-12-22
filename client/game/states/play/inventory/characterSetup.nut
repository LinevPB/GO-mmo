local x1 = 0;
local y1 = 0;
local w1 = 0;
local calw1 = 0;

local labs = [];
local labs_title = [];
local qa_draws = [];

local weaponMenu = null;
local armorMenu = null;
local qaMenu = null;

function getCharacterLabs()
{
    return labs;
}

function enableCharacterSetup()
{
    weaponMenu.enable(true);
    armorMenu.enable(true);
    qaMenu.enable(true);

    for (local i = 0; i < labs_title.len(); i++)
    {
        labs_title[i].visible = true;
        labs_title[i].setPosition(x1 + w1/2 - labs_title[i].width / 2, labs_title[i].getPosition().y);
    }

    foreach(i, v in labs)
    {
        if (i == 0) v.setRender(Player.eqWeapon, 0);
        if (i == 1) v.setRender(Player.eqWeapon2h, 0);
        if (i == 2) v.setRender(Player.eqArmor, 0);
        if (i == 3) {}
        if (i == 4) v.setRender(Player.qa[0], 0);
        if (i == 5) v.setRender(Player.qa[1], 0);
        if (i == 6) v.setRender(Player.qa[2], 0);
        if (i == 7) v.setRender(Player.qa[3], 0);
        if (i == 8) v.setRender(Player.qa[4], 0);
        if (i == 9) v.setRender(Player.qa[5], 0);

        v.enable(true);

        if (i > 3)
        {
            qa_draws[i-4].setPosition(v.btn.pos.x + v.btn.size.width - qa_draws[i-4].width, v.btn.pos.y + v.btn.size.height - qa_draws[i-4].height);
            qa_draws[i-4].visible = true;
            qa_draws[i-4].setColor(240, 220, 180);
        }
    }
}

function disableCharacterSetup()
{
    foreach(v in labs_title)
    {
        v.visible = false;
    }

    foreach(i, v in labs)
    {
        v.enable(false);

        if (i > 3)
        {
            qa_draws[i-4].visible = false;
        }
    }

    weaponMenu.enable(false);
    armorMenu.enable(false);
    qaMenu.enable(false);
}

function findLab(id)
{
    foreach(v in labs)
    {
        if (v.btn.id == id)
        {
            return v;
        }
    }
}

function setupCharacterSetup()
{
    x1 = Inventory.MAX_COLUMN * Inventory.SIZE + 600;
    y1 = Inventory.SIZE + 100 + invY;
    w1 = 8192/2 - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 96;
    calw1 = (w1-Inventory.SIZE-100-Inventory.SIZE)/2;


    /// weapons
    weaponMenu = Window(Inventory.MAX_COLUMN * Inventory.SIZE + 600 - 36, invY + 600, Inventory.width - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 92, 1200, "WINDOW_BACKGROUND.TGA");

    labs_title.append(Draw(x1, weaponMenu.pos.y + 100, lang["INV_WEAPON"][Player.lang]));
    labs.append(InventorySlot(x1 + calw1, weaponMenu.pos.y + labs_title[0].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, weaponMenu.pos.y + labs_title[0].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

    /// armors
    armorMenu = Window(weaponMenu.pos.x, weaponMenu.pos.y + weaponMenu.size.height + 200, Inventory.width - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 92, 1200, "WINDOW_BACKGROUND.TGA");

    labs_title.append(Draw(x1, armorMenu.pos.y + 100, lang["INV_ARMOR"][Player.lang]));
    labs.append(InventorySlot(x1 + calw1, armorMenu.pos.y + labs_title[1].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, armorMenu.pos.y + labs_title[1].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

    /// quick access
    qaMenu = Window(armorMenu.pos.x, armorMenu.pos.y + armorMenu.size.height + 200, Inventory.width - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 92, 3000, "WINDOW_BACKGROUND.TGA");

    labs_title.append(Draw(x1, qaMenu.pos.y + 100, lang["INV_QA"][Player.lang]));
    labs.append(InventorySlot(x1 + calw1, qaMenu.pos.y + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, qaMenu.pos.y + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1, qaMenu.pos.y + 800 + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, qaMenu.pos.y + 800 + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1, qaMenu.pos.y + 1600 + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, qaMenu.pos.y + 1600 + labs_title[2].height + 200,
        Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT_EQUIPPED.TGA", "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

    for(local i = 1; i < 7; i++)
    {
        qa_draws.append(Draw(0, 0, "F"+i));
    }
}

function handleCharacterEqRelease()
{

}