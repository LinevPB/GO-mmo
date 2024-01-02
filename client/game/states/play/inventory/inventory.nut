Inventory <- {};
Inventory.MAX_COLUMN <- 3;
Inventory.MAX_ROW <- 7;
Inventory.SIZE <- 600;
Inventory.MAX_ITEMS <- 90;
Inventory.width <- 8192 / 2;
Inventory.height <- 8192;
Inventory.invEnabled <- false;
invY <- 600;

local mainMenu = null;
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

local alreadyClicked = false;
local alreadyHolder = null;
local lastClickTick = 300;

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
    if (slotMenu.enabled) return;

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

function INVplayButtonHandler(id) // release
{
    switch(id)
    {
        case TradeBox.GetCancelBtn():
            TradeBox.Enable(false);
            return true;
        break;

        case TradeBox.GetOkBtn():
            local temp = TradeBox.GetHold();
            local val = TradeBox.GetValue();

            if (val == "")
            {
                TradeBox.Enable(false);
                return true;
            }

            sendDrop(temp.instance, val.tointeger());
            return true;
        break;

        case slotMenuButtons.useButton.id:
            handleUseItem(slotHolder);

            return true;
        break;

        case slotMenuButtons.dropButton.id:
            handleDropItem(slotHolder);

            return true;
        break;
    }

    return false;
}

function disableSlotMenu()
{
    slotMenu.enable(false);
    getItemMenu().frozen = false;
}

function handleSlotMenu(id, pointer)
{
    if (!(clickTick < 300 && !slotMenu.enabled && pointer.instance != "" && pointer.instance != null))
    {
        slotHolder = null;
        slotIdHolder = null;
    }
}

function rawOnRelease(key)
{
    if (TradeBox.IsEnabled()) return;

    switch(key)
    {
        case MOUSE_BUTTONLEFT:
            handleInvLeftClick();
            handleItemRelease();
        break;

        case MOUSE_BUTTONRIGHT:
            handleInvRightClick();
        break;
    }
}

function handleInvLeftClick()
{
    if (slotMenu.enabled)
    {
        disableSlotMenu();
        return;
    }

    local curs = getCursorPosition();
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

        if (holdedRender.visible)
        {
            holdedRender.visible = false;
        }

        return;
    }

    alreadyClicked = true;
    alreadyHolder = temp;
    lastClickTick = getTickCount();
}

function scanSetup()
{
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

        if (!slotPointer) continue;
        if (v.btn.id != slotPointer.btn.id) continue;

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

    return { temp = temp, found = found };
}

function scanSlots()
{
    local temp = null;
    local found = -1;

    foreach(i, v in getItemSlots())
    {
        if (!inSquare(getCursorPosition(), v.btn.pos, v.btn.size)) continue;

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

        break;
    }

    return { temp = temp, found = found };
}

function handleItemRelease()
{
    if (!isClicked) return;

    holdedRender.visible = false;
    isClicked = false;

    local result = scanSetup();

    if (result.temp == null)
    {
        result = scanSlots();
    }

    if (result.temp == null) return;
    if (!result.temp.btn.enabled) return;

    slotPointer = false;

    handleItemDropOnSetup(result.found, result.temp);
}

function helperEquip(id, inst, inst2)
{
    if ((inst != "" && inst != "-1"))
    {
        invUnequip(id, inst);
    }

    invEquip(id, inst2);
}

function handleItemDropOnSetup(found, temp)
{
    if (holdedRender.instance == "") return;

    local item = ServerItems.find(holdedRender.instance);
    switch(item.type)
    {
        case ItemType.WEAPON:
            if (found == 0)
            {
                helperEquip(found, Player.eqWeapon, temp.render.instance);
            }
            else if (found == 1)
            {
                helperEquip(found, Player.eqWeapon2h, temp.render.instance);
            }
        break;

        case ItemType.ARMOR:
            if (found != 2) return;

            helperEquip(found, Player.eqArmor, temp.render.instance);
        break;

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

function handleInvRightClick()
{
    if (slotMenu.enabled)
    {
        disableSlotMenu();
        return;
    }

    local curs = getCursorPosition();

    foreach(i, v in getItemSlots())
    {
        if (!inSquare(curs, v.btn.pos, v.btn.size)) continue;
        if (v.instance == "") return;

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

function handleItemChange()
{
    if (!ITEM_CHANGE) return;

    foreach (v in Player.items)
    {
        if (v.amount <= 0)
        {
            getItemSlots()[v.slot].setRender("", 0);
            continue;
        }

        getItemSlots()[v.slot].setRender(v.instance, v.amount);
    }

    ITEM_CHANGE = false;
}

function onElementRender(el)
{
    if (!Inventory.IsEnabled()) return;
    if (TradeBox.IsEnabled()) return;

    if (isClicked)
    {
        clickTick += 20;
    }

    handleItemChange();
    handleItemMenuRender();

    if (!Inventory.invEnabled) return;

    showcaseRender();
}

function handleHoldedRender()
{
    if (!isClicked || holdedRender == null) return;

    local curs = getCursorPosition();

    holdedRender.setPosition(curs.x - renderOffsetX, curs.y - renderOffsetY);
}
addEventHandler("onRender", handleHoldedRender);

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