Inventory <- {};
Inventory.MAX_COLUMN <- 3;
Inventory.MAX_ROW <- 7;
Inventory.SIZE <- 600;
Inventory.MAX_ITEMS <- 90;
Inventory.width <- 8192 / 2;
Inventory.height <- 8192;
Inventory.invEnabled <- false;

local mainMenu = null;
invY <- 600;
local slotMenu = null;
local slotMenuButtons = {
    useButton = null,
    dropButton = null
};
local slotHolder = null;
local slotIdHolder = null;
local isClicked = false;
local renderOffsetX = 0;
local renderOffsetY = 0;
local clickTick = 0;

local slotId = -1;
local holdedRender = null;
local slotPointer = false;

local lastCamPos = null;
local lastCamRot = null;

function getMainMenu()
{
    return mainMenu;
}

Inventory.Init <- function()
{
    setupInventoryMenu();

    setupCoverTextures();

    setupCharacterSetup();

    setupItemSlider();

    setupInventorySlots();
    initializeInventorySlots();

    lastCamPos = Camera.getPosition();
    lastCamRot = Camera.getRotation();
}

function setupInventoryMenu()
{
    mainMenu = Window(0, invY - 200, Inventory.width, Inventory.height, "WINDOW_BACKGROUND_SF.TGA");

    slotMenu = Window(0, invY, 1000, 500, "WINDOW_BACKGROUND.TGA");

    slotMenuButtons.useButton = Button(0, 0, 1000, 250, "BUTTON_BACKGROUND.TGA", lang["INV_USE"][Player.lang], "BUTTON_BACKGROUND.TGA");
    slotMenuButtons.useButton.setBackgroundRegularColor(200, 20, 20);
    slotMenuButtons.useButton.setBackgroundHoverColor(150, 20, 20);
    slotMenu.attach(slotMenuButtons.useButton);

    slotMenuButtons.dropButton = Button(0, 250, 1000, 250, "BUTTON_BACKGROUND.TGA", lang["INV_DROP"][Player.lang], "BUTTON_BACKGROUND.TGA");
    slotMenuButtons.dropButton.setBackgroundRegularColor(200, 20, 20);
    slotMenuButtons.dropButton.setBackgroundHoverColor(150, 20, 20);
    slotMenu.attach(slotMenuButtons.dropButton);

    slotMenuButtons.useButton.rehover();
    slotMenuButtons.dropButton.rehover();

    holdedRender = ItemRender(5000, 0, 600, 600, "");
}

Inventory.Enable <- function(val, soft = false)
{
    mainMenu.enable(val);
    Inventory.invEnabled = val;

    if (val == true)
    {
        lastCamPos = Camera.getPosition();
        lastCamRot = Camera.getRotation();

        Camera.setPosition(37900, 4680, 44440);
        Camera.setRotation(0, 30, 0);

        enableCharacterSetup();
        enableCover();

        foreach (v in Player.items)
        {
            getItemSlots()[v.slot].setRender(v.instance, v.amount);
        }

        updateDraws();
        updateGoldDraws();
        updateInvEqColor();

        onInvSlide(getItemSlider());
    }
    else
    {
        Camera.setPosition(lastCamPos.x, lastCamPos.y, lastCamPos.z);
        Camera.setRotation(lastCamRot.x, lastCamRot.y, lastCamRot.z);

        for (local i = 0; i < Inventory.MAX_ITEMS; i++)
        {
            getItemSlots()[i].setRender("", 0);
        }

        foreach (v in getItemSlots())
        {
            v.enable(false);
        }

        disableCharacterSetup();
        disableCover();

        if (isClicked)
        {
            holdedRender.visible = false;
            isClicked = false;
        }
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

function playClickButtonHandler(id) // click
{
    if (!Inventory.invEnabled) return;
    if (TradeBox.IsEnabled()) return;

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

    if (!slotMenu.enabled)
    {
        slotHolder = temp;
        slotIdHolder = slotId;
    }

    return;
}

function handleSlotMenu(id, pointer)
{
    if (!(clickTick < 300 && !slotMenu.enabled && pointer.instance != "" && pointer.instance != null))
    {
        slotMenu.enable(false);
        getItemMenu().frozen = false;
        slotHolder = null;
        slotIdHolder = null;
    }
}

local alreadyClicked = false;
local alreadyHolder = null;
local lastClickTick = 300;

function rawOnRelease(key)
{
    if (TradeBox.IsEnabled()) return;
    if (slotMenu.enabled) return;

    local curs = getCursorPosition();

    if (key == MOUSE_BUTTONLEFT)
    {
        local temp = null;
        foreach(i, v in getItemSlots())
        {
            if (!inSquare(curs, v.btn.pos, v.btn.size))
            {
                continue;
            }
            temp = v;
        }

        if (temp == null) return;

        if (alreadyClicked && !(getTickCount() - lastClickTick > 400 || alreadyHolder != temp))
        {
            handleUseItem(temp);
            alreadyClicked = false;
            alreadyHolder = null;

            return;
        }

        alreadyClicked = true;
        alreadyHolder = temp;
        lastClickTick = getTickCount();

        return;
    }

    if (key != MOUSE_BUTTONRIGHT) return;

    foreach(i, v in getItemSlots())
    {
        if (!inSquare(curs, v.btn.pos, v.btn.size))
        {
            continue;
        }

        if (v.instance == "")
        {
            return;
        }

        slotHolder = v;
        slotIdHolder = i;

        getItemMenu().frozen = true;
        slotMenu.enable(true);
        slotMenu.setPosition(curs.x, curs.y);

        local item = Daedalus.instance(slotHolder.render.instance);
        if (item.mainflag == 32 || item.mainflag == 128)
        {
            slotMenuButtons.useButton.changeText(lang["INV_USE"][Player.lang]);
        }
        else if (item.mainflag == 2 || item.mainflag == 4 || item.mainflag == 16)
        {
            if (slotHolder.render.instance.toupper() == Player.eqWeapon || slotHolder.render.instance.toupper() == Player.eqWeapon2h || slotHolder.render.instance.toupper() == Player.eqArmor)
            {
                slotMenuButtons.useButton.changeText(lang["INV_UNEQUIP"][Player.lang]);
            }
            else
            {
                slotMenuButtons.useButton.changeText(lang["INV_EQUIP"][Player.lang]);
            }
        }
        else
        {
            slotMenuButtons.useButton.changeText(lang["INV_NONUSABLE"][Player.lang]);
        }

        v.btn.unhover();

        return;
    }
}

function rawOnClick(key)
{
    if (TradeBox.IsEnabled()) return;

    if (!slotMenu.enabled) return;

    if (!inSquare(getCursorPosition(), slotMenu.pos, slotMenu.size))
    {
        slotMenu.enable(false);
        getItemMenu().frozen = false;
        return;
    }
}

function handleUseItem(slot)
{
    local item = Daedalus.instance(slot.instance);
    if (item.mainflag == 32 || item.mainflag == 128)
    {
        sendPacket(PacketType.USE_ITEM, slot.instance, 1);
    }
    else if (item.mainflag == 2 || item.mainflag == 4 || item.mainflag == 16)
    {
        if (slot.instance.toupper() == Player.eqWeapon || slot.instance.toupper() == Player.eqWeapon2h || slot.instance.toupper() == Player.eqArmor)
        {
            foreach(i, v in getCharacterLabs())
            {
                if (v.render.instance == slot.instance)
                {
                    v.render.instance = "";
                    return invUnequip(i, slot.instance);
                }
            }
        }
        else
        {
            local found = 0;
            switch (item.mainflag)
            {
                case 2:
                    found = 0;
                break;

                case 4:
                    found = 1;
                break;

                case 16:
                    found = 2;
                break;
            }
            if (invEquip(found, slot.instance))
            {
                getCharacterLabs()[found].render.instance = slot.instance;
            }
        }
    }
    else
    {
        //slotMenuButtons.useButton.changeText("Non usable");
    }
}

function findSlot(instance)
{
    foreach(v in getItemSlots())
    {
        if (!v.render)
        {
            continue;
        }

        if (v.render.instance == instance)
        {
            return v;
        }
    }
    return null;
}

function sendDrop(inst, val)
{
    sendPacket(PacketType.DROP_ITEM, inst, val);

    TradeBox.Enable(false);
}

function INVplayButtonHandler(id) // release
{
    if (id == TradeBox.GetCancelBtn())
    {
        return TradeBox.Enable(false);
    }

    if (id == TradeBox.GetOkBtn())
    {
        local temp = TradeBox.GetHold();
        local val = TradeBox.GetValue();
        if (val == "")
        {
            return TradeBox.Enable(false);
        }

        return sendDrop(temp.instance, val.tointeger());
    }

    if (id == slotMenuButtons.useButton.id)
    {
        if (!inSquare(getCursorPosition(), getItemMenu().pos, getItemMenu().size))
        {
            slotMenu.enable(false);
            getItemMenu().frozen = false;
        }

        handleUseItem(slotHolder);
    }
    else if (id == slotMenuButtons.dropButton.id)
    {
        if (!inSquare(getCursorPosition(), getItemMenu().pos, getItemMenu().size))
        {
            slotMenu.enable(false);
            getItemMenu().frozen = false;
        }

        handleDropItem(slotHolder);
    }

    if (!Inventory.invEnabled) return;
    if (!isClicked) return;

    holdedRender.visible = false;
    isClicked = false;

    local temp = null;
    local found = -1;

    foreach(i, v in getCharacterLabs())
    {
        if (inSquare(getCursorPosition(), v.btn.pos, v.btn.size))
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

        if (inSquare(getCursorPosition(), v.btn.pos, v.btn.size))
        {
            slotPointer = false;
            break;
        }
        else if (i < 4)
        {
            v.render.instance = "";
            slotPointer = false;

            invUnequip(i, holdedRender.instance);
        }
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
            handleSlotMenu(slotIdHolder, slotHolder);
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

    local item = ServerItems.find(holdedRender.instance);
    switch(item.type)
    {
        case ItemType.FOOD:
        case ItemType.POTION:
            if (found < 4) return;

            local enu = -1;

            foreach(i, v in getCharacterLabs())
            {
                if (v.render.instance == holdedRender.instance)
                {
                    enu = i;
                    v.render.instance = "";
                    invUnequip(i, holdedRender.instance);
                }
            }

            if (temp.render.instance != "")
            {
                if (enu != -1)
                {
                    print(enu);
                    getCharacterLabs()[enu].render.instance = temp.render.instance;
                    invEquip(enu, temp.render.instance);
                }
            }

            temp.render.instance = holdedRender.instance;
            invEquip(found, holdedRender.instance);
            slotId = -1;

        break;
    }
}


function onElementRender(el)
{
    if (!Inventory.IsEnabled()) return;
    if (TradeBox.IsEnabled()) return;

    if (ITEM_CHANGE)
    {
        foreach (v in Player.items)
        {
            if (v.amount <= 0)
            {
                getItemSlots()[v.slot].setRender("", 0);
            }
            else
            {
                getItemSlots()[v.slot].setRender(v.instance, v.amount);
            }
        }
        ITEM_CHANGE = false;
    }

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

function handleDropItem(slot)
{
    TradeBox.Enable(true);
    TradeBox.SetHold({ instance = slot.instance });
    TradeBox.SetItemName(ServerItems.getName(slot.instance)[Player.lang]);
    TradeBox.Select();

    return;
}

function rawOnKey(key)
{
    if (!Inventory.invEnabled) return;
    if (!TradeBox.IsEnabled()) return;
    if (key != KEY_RETURN) return;

    INVplayButtonHandler(TradeBox.GetOkBtn());
}