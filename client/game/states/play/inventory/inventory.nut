Inventory <- {};
MAX_COLUMN <- 3;
MAX_ROW <- 7;
SIZE <- 600;
MAX_ITEMS <- 90;
wW <- 8192 / 2;
wH <- 8192;

local invEnabled = false;
local isClicked = false;

local mainMenu = null;
function getMainMenu()
{
    return mainMenu;
}

Inventory.Init <- function()
{
    setupInventoryMenu();

    setupCoverTextures();

    setupDrawsPositions();

    initializeInventorySlots();

    setupItemSlider();

    initializeItemRenders();
}

function setupInventoryMenu() {
    mainMenu = Window(0, 0, wW, wH, "SR_BLANK.TGA");
    mainMenu.background.texture.setColor(10, 10, 10);

    setupInventorySlots();

    setupCharacterSetup();

    setupStatistics();
}

Inventory.Enable <- function(val)
{
    setFreeze(val);
    Camera.movementEnabled = !val;
    disableControls(val);
    setCursorVisible(val);
    mainMenu.enable(val);
    setCoverTexturesVisibility(val);
    invEnabled = val;

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
        for (local i = 0; i < MAX_ITEMS; i++)
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
    return invEnabled;
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
    if (!invEnabled) return;
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

local itemChoiceTex = Texture(5000, 5000, 1000, 500, "SR_BLANK.TGA");

function handleSlotMenu(id, pointer)
{
    if (clickTick < 400)
    {
        getItemMenu().frozen = true;
        itemChoiceTex.visible = true;
        itemChoiceTex.setPosition(getCursorPosition().x, getCursorPosition().y);
    }
    else
    {
        getItemMenu().frozen = false;
    }
}

function INVplayButtonHandler(id) // release
{
    if (!invEnabled) return;
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

    if (!invEnabled) return;

    showcaseRender();

    if (isClicked)
    {
        local curs = getCursorPosition();

        holdedRender.setPosition(curs.x - renderOffsetX, curs.y - renderOffsetY);
        clickTick += 20;
    }
}