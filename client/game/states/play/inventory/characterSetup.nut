local x1 = 0;
local y1 = 0;
local w1 = 0;
local calw1 = 0;

local labs = [];
local labs_title = [];
local qa_draws = [];

local characterMenu = null;

function getCharacterLabs()
{
    return labs;
}

function getCharacterMenu()
{
    return characterMenu;
}

function enableCharacterSetup()
{
    for (local i = 0; i < labs_title.len(); i++)
    {
        labs_title[i].visible = true;
        labs_title[i].setPosition(x1 + w1/2 - labs_title[i].width / 2, y1 + 1000 * i);
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
    y1 = Inventory.SIZE + 350;
    w1 = 8192/2 - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 96;
    calw1 = (w1-Inventory.SIZE-100-Inventory.SIZE)/2;

    labs_title.append(Draw(x1, y1, "Weapons"));
    labs.append(InventorySlot(x1 + calw1, y1 + labs_title[0].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, y1 + labs_title[0].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

        labs_title.append(Draw(x1, y1, "Armor"));
    labs.append(InventorySlot(x1 + calw1, y1 + 1000 + labs_title[1].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, y1 + 1000 + labs_title[1].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

    labs_title.append(Draw(x1, y1, "Quick access"));
    labs.append(InventorySlot(x1 + calw1, y1 + 2000 + labs_title[2].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, y1 + 2000 + labs_title[2].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1, y1 + 2800 + labs_title[2].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + Inventory.SIZE + 100, y1 + 2800 + labs_title[2].height + 50,
        Inventory.SIZE, Inventory.SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

        ///
    characterMenu = Window(Inventory.MAX_COLUMN * Inventory.SIZE + 600 - 36, Inventory.SIZE + 250, Inventory.width - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 92, Inventory.MAX_ROW * Inventory.SIZE - 250, "SR_BLANK.TGA");
    characterMenu.setBackgroundColor(10, 10, 30);
    characterMenu.setCover("MENU_INGAME.TGA");
    getMainMenu().attach(characterMenu);

    for(local i = 1; i < 5; i++)
    {
        qa_draws.append(Draw(0, 0, "F"+i));
    }
}

function handleCharacterEqRelease()
{

}