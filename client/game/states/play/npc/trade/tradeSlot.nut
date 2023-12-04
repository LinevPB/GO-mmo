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

    constructor(x, y, width, height)
    {
        regularTex = "INV_SLOT.TGA";
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

        render.instance = inst;

        if (amount > originalAmount)
        {
            originalAmount = amount;
        }

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
            background.file = equippedHoverTex;
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
            background.file = equippedTex;
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

    if (holdedRender.instance == Player.eqWeapon || holdedRender.instance == Player.eqWeapon2h || holdedRender.instance == Player.eqArmor) return;

    if (slot.id == slotPointer.id || slotPointer.render.instance == "") return;

    if (slot.id < 8) // jesli przeniesiemy na sloty wymiany gracza
    {
        if (slotPointer.id < 8) // jesli przeniesiemy ze slotu wymiany gracza
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
        else if (slotPointer.id < 18) // jesli przeniesiemy ze slotu wymiany npc
        {
            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id <= 107) // jesli przeniesiemy z ekwipunku gracza
        {
            TradeBox.Enable(true);
            TradeBox.SetHold({ id = slot.id, pointerId = slotPointer.id, instance = slotPointer.render.instance });
            TradeBox.SetItemName(ServerItems.getName(slotPointer.render.instance));
            TradeBox.Select();
        }
    }
    else if (slot.id < 18) // jesli przeniesiemy na sloty wymiany npc
    {
        if (slotPointer.id > 107) // jesli przeniesiemy z ekwipunku npc
        {
            TradeBox.Enable(true);
            TradeBox.SetHold({ id = slot.id, pointerId = slotPointer.id, instance = slotPointer.render.instance });
            TradeBox.SetItemName(ServerItems.getName(slotPointer.render.instance));
            TradeBox.Select();
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
                    v.updateSlot(slotPointer.render.instance, slotPointer.amount);
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
                updateTradeShowcase(v.render.instance)
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

    if (Showcase.IsEnabled() && ((holding || TradeBox.IsEnabled()) || !hovered))
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
    local val = TradeBox.GetValue().tointeger();

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
        local calcVal = pointer.amount - val;
        if (val <= 0)
        {
            pointer.updateSlot("", 0);
        }
        else
        {
            pointer.updateSlot(temp.instance, calcVal);
        }
    }

    slotPointer = pointer;
    slot.updateSlot(temp.instance, val);
    handleSlotRelease(slot);

    TradeBox.Enable(false);
}