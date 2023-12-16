local slots = [];
local slot_id = 0;
local holdedRender = ItemRender(0, 0, 600, 600, "");
local holding = false;
local slotPointer = null;
local cursorOffX = 0;
local cursorOffY = 0;

local playerItemsInBasket = [];
local npcItemsInBasket = [];

class TradeSlot
{
    id = null;

    pos = null;
    size = null;
    regularTex = null;
    hoverTex = null;
    equippedTex = null;
    equippedHoverTex = null;

    background = null;
    render = null;
    amountDraw = null;

    baseX = null;
    baseY = null;

    enabled = null;
    hovered = null;

    amount = null;
    instance = null;
    originalAmount = null;
    originalId = null;
    amountEnabled = null;

    constructor(x, y, width, height)
    {
        regularTex = "INVENTORY_SLOT.TGA";
        hoverTex = "INV_SLOT_HIGHLIGHTED.TGA";
        equippedTex = "INV_SLOT_EQUIPPED.TGA";
        equippedHoverTex = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";

        pos = { x = x, y = y };
        size = { width = width, height = height };

        background = Texture(x, y, width, height, regularTex);
        amountDraw = Draw(x, y, "x1");
        render = ItemRender(x, y, width, height, "");
        render.lightingswell = true;

        setPosition(x, y);
        amountDraw.text = "";

        baseX = x;
        baseY = y;

        enabled = false;
        hovered = false;
        amountEnabled = true;

        amount = 0;
        originalAmount = 0;
        instance = "";

        id = slot_id;
        originalId = slot_id;
        slot_id++;
        slots.append(this);
        rehover();
    }

    function enable(val)
    {
        background.visible = val;

        if (amountEnabled)
            amountDraw.visible = val;

        render.visible = val;
        enabled = val;
    }

    function move(x, y)
    {
        pos.x += x;
        pos.y += y;
        background.setPosition(pos.x, pos.y);
        amountDraw.setPosition(pos.x, pos.y);
    }

    function setPosition(x, y)
    {
        pos.x = x;
        pos.y = y;
        background.setPosition(pos.x, pos.y);
        amountDraw.setPosition(pos.x + size.width - amountDraw.width - 10, pos.y + size.height - amountDraw.height - 10);
        render.setPosition(pos.x, pos.y);
    }

    function updateSlot(inst, aMount)
    {
        if (inst != "")
        {
            instance = inst;
        }

        if (aMount > originalAmount)
        {
            originalAmount = aMount;
        }

        render.instance = inst;
        amount = aMount;

        if (amount > 1)
            amountDraw.text = "x" + amount;
        else
            amountDraw.text = "";

        setPosition(pos.x, pos.y);
    }

    function hover()
    {
        if (hovered) return;

        if (render.instance == Player.eqWeapon || render.instance == Player.eqWeapon2h || render.instance == Player.eqArmor)
        {
            if (id < 108 && id >= 18)
                background.file = equippedHoverTex;
            else
                background.file = hoverTex;
        }
        else
        {
            background.file = hoverTex;
        }

        hovered = true;
    }

    function unhover()
    {
        if (!hovered) return;

        if (render.instance == Player.eqWeapon || render.instance == Player.eqWeapon2h || render.instance == Player.eqArmor)
        {
            if (id < 108 && id >= 18)
                background.file = equippedTex;
            else
                background.file = regularTex;
        }
        else
        {
            background.file = regularTex;
        }

        hovered = false;
    }

    function rehover()
    {
        hover();
        unhover();
    }
}

local doubleClick = false;
local clickTime = 0;
local clickId = -1;

function handleSlotClick(slot)
{
    local curs = getCursorPosition();
    cursorOffX = curs.x - slot.pos.x;
    cursorOffY = curs.y - slot.pos.y;

    holdedRender.instance = slot.render.instance;
    holdedRender.setPosition(curs.x - cursorOffX, curs.y - cursorOffY);
    holdedRender.visible = true;

    slotPointer = slot;
    holding = true;
}

function tradeClick(key)
{
    if (key != MOUSE_LMB) return;

    foreach(v in slots)
    {
        if (inSquare(getCursorPosition(), v.pos, v.size) && v.enabled)
        {
            return handleSlotClick(v);
        }
    }
}

function enableBoxHelper(slotId, pointerId, instance)
{
    TradeBox.Enable(true);
    TradeBox.SetHold({ type = 1, id = slotId, pointerId = pointerId, instance = instance });
    TradeBox.SetItemName(ServerItems.getName(instance)[Player.lang]);
    TradeBox.Select();
}

function findFirstFree(id)
{
    foreach(i, v in slots)
    {
        if (i > 18) return -1;

        if (v.amount == 0)
        {
            if ((v.id < 8 && id > 18 && id < 108))
            {
                return v.id;
            }
            else if (v.id >= 8 && v.id < 18 && id >= 108)
            {
                return v.id;
            }
        }
    }
}

function handleDoubleClick(pId)
{
    if (!doubleClick)
    {
        doubleClick = true;
        clickTime = getTickCount();
        clickId = pId;
    }
    else
    {
        doubleClick = false;
        clickTime = getTickCount();

        if (getTickCount() - clickTime < 300)
        {
            if (clickId == pId)
            {
                local firstFind = findFirstFree(pId);
                if (firstFind == -1) return;

                enableBoxHelper(firstFind, pId, slotPointer.render.instance);
                clickId = -1;
                return;
            }
        }
        else
        {
            clickId = -1;
            return handleDoubleClick(pId);
        }
    }
}

function handleSlotRelease(slot)
{
    holdedRender.visible = false;
    holding = false;

    if (slot == -1)
    {
        if (slotPointer.id < 18)
        {
            slotPointer.updateSlot("", 0);
            slotPointer = null;
            return;
        }
    }

    handleDoubleClick(slotPointer.id);

    if (holdedRender.instance == Player.eqWeapon || holdedRender.instance == Player.eqWeapon2h || holdedRender.instance == Player.eqArmor)
    {
        if (slotPointer.id < 108 && (slotPointer.id <= 8 && slotPointer.id > 18)) return;
    }

    if (slot.id == slotPointer.id || slotPointer.render.instance == "") return;

    if (slot.id < 8) // jesli przeniesiemy na sloty wymiany gracza
    {
        if (slotPointer.id < 8) // jesli przeniesiemy ze slotu wymiany gracza
        {
            local tempInst = slot.render.instance;
            local tempAmount = slot.amount;
            local tempId = slot.originalId;

            slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
            slot.originalId = slotPointer.originalId;

            slotPointer.updateSlot(tempInst, tempAmount);
            slotPointer.originalId = tempId;
        }
        else if (slotPointer.id < 18) // jesli przeniesiemy ze slotu wymiany npc
        {
            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id <= 107) // jesli przeniesiemy z ekwipunku gracza
        {
            if (slotPointer.amount == 1)
            {
                slot.updateSlot(slotPointer.render.instance, 1);
                slot.originalId = slotPointer.id;
                slotPointer.updateSlot("", 0);
            }
            else
            {
                enableBoxHelper(slot.id, slotPointer.id, slotPointer.render.instance);
            }
        }
    }
    else if (slot.id < 18) // jesli przeniesiemy na sloty wymiany npc
    {
        if (slotPointer.id > 107) // jesli przeniesiemy z ekwipunku npc
        {
            enableBoxHelper(slot.id, slotPointer.id, slotPointer.render.instance);
            //slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
        }
        else if (slotPointer.id < 18 && slotPointer.id > 7) // jesli przeniesiemy ze slotu wymiany npc
        {
            if (slot.render.instance == "")
            {
                slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
                slotPointer.updateSlot("", 0);
            }
            else
            {
                local tempInst = slot.render.instance;
                local tempAmount = slot.amount;
                local tempId = slot.originalId;

                slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
                slot.originalId = slotPointer.originalId;

                slotPointer.updateSlot(tempInst, tempAmount);
                slotPointer.originalId = tempId;
            }
        }
        else if (slotPointer.id < 8) // jesli przeniesiemy ze slotu wymiany gracza
        {
            //slotPointer.updateSlot("", 0);
        }
    }
    else // jesli nie przeniesiemy na zadne ze slotow wymiany
    {
        if (slotPointer.id < 8) // jesli przenosimy ze slotu wymiany gracza
        {
            foreach(v in slots)
            {
                if (v.id == slotPointer.originalId)
                {
                    local tempAmount = slotPointer.amount + v.amount;
                    if (tempAmount > v.originalAmount)
                    {
                        tempAmount = v.originalAmount;
                    }

                    v.updateSlot(slotPointer.render.instance, tempAmount);
                    break;
                }
            }

            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id < 18) // jesli prenosimy ze slot wymiany npc
        {
            slotPointer.updateSlot("", 0);
        }
    }

    slotPointer = null;
}

function tradeRelease(key)
{
    if (holding)
    {
        foreach(v in slots)
        {
            if (inSquare(getCursorPosition(), v.pos, v.size) && v.enabled)
            {
                return handleSlotRelease(v);
            }
        }

        return handleSlotRelease(-1);
    }
}

function tradeSlotRender()
{
    if (holding)
    {
        local curs = getCursorPosition();
        holdedRender.setPosition(curs.x - cursorOffX, curs.y - cursorOffY);
    }

    local basketValue = 0;
    local hovered = false;

    foreach(i, v in slots)
    {
        if (!v.enabled) continue;

        if (v.id < 8)
        {
            basketValue += getItemPrice(v.render.instance) * v.amount;
            if (v.id == 7)
            {
                updatePlayerBasketValue(basketValue);
                basketValue = 0;
            }
        }
        else if (v.id < 18)
        {
            basketValue += getItemPrice(v.render.instance) * v.amount;
            if (v.id == 17)
            {
                updateNpcBasketValue(basketValue);
                basketValue = null;
            }
        }

        if (v.render.instance == Player.eqArmor || v.render.instance == Player.eqWeapon || v.render.instance == Player.eqWeapon2h)
        {
            if (v.id <= 107 && v.id >= 18)
            {
                if (v.background.file != v.equippedTex && !v.hovered)
                {
                    v.rehover();
                }
            }
        }

        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            v.hover();

            if (v.render.instance != "")
            {
                if ((v.id < 108 && v.id >= 18) || v.id < 8)
                {
                    updateTradeShowcase(v.render.instance, v.amount);
                }
                else
                {
                    updateTradeShowcase(v.render.instance, 1);
                }

                hovered = true;

                if (!Showcase.IsEnabled())
                {
                    if (v.id < 18)
                        enableTradeShowcase(true, 1);
                    else
                        enableTradeShowcase(true, 0);
                }
            }
        }
        else
        {
            v.unhover();
        }
    }

    if ((Showcase.IsEnabled() && ((holding || TradeBox.IsEnabled()) || !hovered)) || (doubleClick && (getTickCount() - clickTime < 300)))
    {
        enableTradeShowcase(false);
    }

    updateTradeShowcasePosition(holding);
    tradePlayerRender();
}

function getPlayerBasket()
{
    local result = [];
    for (local i = 0; i < 8; i++)
    {
        if (slots[i].id == i)
        {
            result.append(slots[i]);
        }
    }

    return result;
}

function getNpcBasket()
{
    local result = [];
    for (local i = 8; i < 18; i++)
    {
        if (slots[i].id == i)
        {
            result.append(slots[i]);
        }
    }

    return result;
}

function tradeConfirmBox()
{
    local temp = TradeBox.GetHold();
    local val = TradeBox.GetValue();

    if (val == "")
    {
        return TradeBox.Enable(false);
    }

    val = val.tointeger();
    if (val < 1)
    {
        val = 1;
    }
    if (val > 999)
    {
        val = 999;
    }

    local slot = null;
    local pointer = null;

    foreach(v in slots)
    {
        if (v.id == temp.id)
        {
            slot = v;
        }

        if (v.id == temp.pointerId)
        {
            pointer = v;
        }

        if (slot != null && pointer != null) break;
    }


    if (pointer.id >= 18 && pointer.id <= 107)
    {
        if (pointer.amount < val)
        {
            val = pointer.amount;
        }

        local calcVal = pointer.amount - val;
        local tempInst = temp.instance;

        if (calcVal <= 0)
        {
            tempInst = "";
            calcVal = 0;
        }

        pointer.updateSlot(tempInst, calcVal);
    }

    if (slot.amount > 0)
    {
        val += slot.amount;

        if (val > pointer.originalAmount && pointer.id < 108)
        {
            val = pointer.originalAmount;
        }
    }

    slot.updateSlot(temp.instance, val);
    slot.originalId = pointer.id;

    TradeBox.Enable(false);
}