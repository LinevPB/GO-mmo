Inventory <- {};
Inventory.MAX_COLUMN <- 3;
Inventory.MAX_ROW <- 7;
Inventory.SIZE <- 600;
Inventory.MAX_ITEMS <- 90;
Inventory.width <- 8192 / 2;
Inventory.height <- 8192;
Inventory.invEnabled <- false;

local mainMenu = null;
local slotMenu = null;
local slotMenuButtons = {
    useButton = null,
    dropButton = null
};
local isClicked = false;

function getMainMenu()
{
    return mainMenu;
}

Inventory.Init <- function()
{
    setupInventoryMenu();

    setupInventorySlots();

    setupCharacterSetup();

    setupStatistics();

    setupCoverTextures();

    setupDrawsPositions();

    initializeInventorySlots();

    setupItemSlider();

    initializeItemRenders();
}

function setupInventoryMenu()
{
    mainMenu = Window(0, 0, Inventory.width, Inventory.height, "SR_BLANK.TGA");
    mainMenu.background.texture.setColor(10, 10, 10);

    slotMenu = Window(0, 0, 1000, 500, "SR_BLANK.TGA");
    slotMenu.background.texture.setColor(10, 10, 90);

    slotMenuButtons.useButton = Button(0, 0, 1000, 250, "SR_BLANK.TGA", "Use", "INV_TITEL.TGA");
    slotMenuButtons.useButton.setBackgroundRegularColor(10, 10, 90);
    slotMenuButtons.useButton.setBackgroundHoverColor(255, 255, 255);
    slotMenu.attach(slotMenuButtons.useButton);

    slotMenuButtons.dropButton = Button(0, 250, 1000, 250, "SR_BLANK.TGA", "Drop", "INV_TITEL.TGA");
    slotMenuButtons.dropButton.setBackgroundRegularColor(10, 10, 90);
    slotMenuButtons.dropButton.setBackgroundHoverColor(255, 255, 255);
    slotMenu.attach(slotMenuButtons.dropButton);
}

Inventory.Enable <- function(val)
{
    setFreeze(val);
    Camera.movementEnabled = !val;
    disableControls(val);
    setCursorVisible(val);
    mainMenu.enable(val);
    setCoverTexturesVisibility(val);
    Inventory.invEnabled = val;

    enableStatistics(val);

    if (val == true)
    {
        foreach (v in Player.items)
        {
            getItemSlots()[v.slot].setRender(v.instance, v.amount);
            getItemSlots()[v.slot].setAlpha(true);
        }

        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
        Camera.setPosition(37900, 4680, 44440);
        Camera.setRotation(0, 30, 0);

        enableCharacterSetup();
        enableCover();

        updateDraws();
        updateGoldDraws();
        updateInvEqColor();

        onSlidePlay(getItemSlider());
    }
    else
    {
        for (local i = 0; i < Inventory.MAX_ITEMS; i++)
        {
            getItemSlots()[i].setRender("", 0);
        }

        foreach (v in getItemSlots())
        {
            v.enable(false);
        }

        setHudMode(HUD_ALL, HUD_MODE_DEFAULT);

        disableCharacterSetup();
        disableCover();
    }
}

Inventory.IsEnabled <- function()
{
    return Inventory.invEnabled;
}

function invHover(el)
{
    if (isClicked) return;

    showcaseHover(el);
    onElementRender(el);
}

function invUnhover(el)
{
    showcaseUnhover(el);
}

local renderOffsetX = 0;
local renderOffsetY = 0;
local clickTick = 0;

local slotId = -1;
local holdedRender = ItemRender(5000, 0, 600, 600, "");
local slotPointer = false;

function playClickButtonHandler(id) // click
{
    if (!Inventory.invEnabled) return;
    local temp = null;

    foreach(i, v in getItemSlots())
    {
        if (v.btn.id == id)
        {
            temp = v;
            slotId = i;
            break;
        }
    }

    if (temp == null)
    {
        temp = findLab(id);
    }

    if (temp == null)
    {
        return;
    }

    holdedRender.instance = temp.render.instance;
    holdedRender.visible = true;

    local curs = getCursorPosition();
    renderOffsetX = curs.x - temp.btn.pos.x;
    renderOffsetY = curs.y - temp.btn.pos.y;

    isClicked = true;
    clickTick = 0;
    handleShowcaseClick(id);
    onElementRender(temp.btn)

    slotPointer = temp;

    return;
}

function handleSlotMenu(id, pointer)
{
    if (clickTick < 400 && !slotMenu.enabled)
    {
        local curs = getCursorPosition();

        getItemMenu().frozen = true;
        slotMenu.enable(true);
        slotMenu.setPosition(curs.x, curs.y);
    }
    else
    {
        slotMenu.enable(false);
        getItemMenu().frozen = false;
    }
}

function rawOnClick(key)
{
    if (!slotMenu.enabled)
    {
        return;
    }

    if (!inSquare(getCursorPosition(), slotMenu.pos, slotMenu.size) && !inSquare(getCursorPosition(), getItemMenu().pos, getItemMenu().size))
    {
        slotMenu.enable(false);
        getItemMenu().frozen = false;
        return;
    }
}

function INVplayButtonHandler(id) // release
{
    if (!Inventory.invEnabled) return;
    if (!isClicked) return;

    holdedRender.visible = false;
    isClicked = false;

    local temp = null;
    local found = -1;

    foreach(i, v in getCharacterLabs())
    {
        if (inSquare(getCursorPosition(), v.btn.pos, v.btn.size) && v.instance != "" && v.instance != null)
        {
            temp = v;
            found = i;
            break;
        }

        if (!slotPointer)
        {
            continue;
        }

        if (v.btn.id != slotPointer.btn.id)
        {
            continue;
        }

        if (!inSquare(getCursorPosition(), v.btn.pos, v.btn.size))
        {
            v.render.instance = "";
            slotPointer = false;

            return invUnequip(i, holdedRender.instance);
        }

        slotPointer = false;
        break;
    }

    foreach(i, v in getItemSlots())
    {
        if (!inSquare(getCursorPosition(), v.btn.pos, v.btn.size))
        {
            continue;
        }

        if (slotId != i)
        {
            moveItems(v, i, slotPointer, slotId);
        }
        else
        {
            handleSlotMenu(slotId, slotPointer);
        }

        slotPointer = null;
        slotId = -1;

        return;
    }

    if (temp == null)
    {
        return;
    }

    if (!temp.btn.enabled)
    {
        return;
    }

    slotPointer = false;

    if (invEquip(found, holdedRender.instance))
    {
        temp.render.instance = holdedRender.instance;
    }
}

function onElementRender(el)
{
    handleItemMenuRender();

    if (!Inventory.invEnabled) return;

    showcaseRender();

    if (isClicked)
    {
        local curs = getCursorPosition();

        holdedRender.setPosition(curs.x - renderOffsetX, curs.y - renderOffsetY);
        clickTick += 20;
    }
}