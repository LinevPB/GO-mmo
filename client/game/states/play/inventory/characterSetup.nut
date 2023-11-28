local x1 = 0;
local y1 = 0;
local w1 = 0;
local calw1 = 0;

local labs = [];
local labs_title = [];

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

        v.enable(true);
    }
}

function disableCharacterSetup()
{
    foreach(v in labs_title)
    {
        v.visible = false;
    }

    foreach(v in labs)
    {
        v.enable(false);
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
    x1 = MAX_COLUMN * SIZE + 600;
    y1 = SIZE + 350;
    w1 = 8192/2 - MAX_COLUMN*SIZE - SIZE - 96;
    calw1 = (w1-SIZE-100-SIZE)/2;

    labs_title.append(Draw(x1, y1, "Weapons"));
    labs.append(InventorySlot(x1 + calw1, y1 + labs_title[0].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + labs_title[0].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

        labs_title.append(Draw(x1, y1, "Armor"));
    labs.append(InventorySlot(x1 + calw1, y1 + 1000 + labs_title[1].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 1000 + labs_title[1].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

    labs_title.append(Draw(x1, y1, "Quick access"));
    labs.append(InventorySlot(x1 + calw1, y1 + 2000 + labs_title[2].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 2000 + labs_title[2].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1, y1 + 2800 + labs_title[2].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
    labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 2800 + labs_title[2].height + 50,
        SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

        ///
    characterMenu = Window(MAX_COLUMN * SIZE + 600 - 36, SIZE + 250, wW - MAX_COLUMN*SIZE - SIZE - 92, MAX_ROW * SIZE - 250, "LOG_PAPER.TGA");

    getMainMenu().attach(characterMenu);
}

function handleCharacterEqRelease()
{

}