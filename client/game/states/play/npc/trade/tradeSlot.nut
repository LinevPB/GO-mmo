local slots = [];
local slot_id = 0;
local holdedRender = ItemRender(0, 0, 600, 600, "");
local holding = false;
local slotPointer = null;
local cursorOffX = 0;
local cursorOffY = 0;

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

        id = slot_id;
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

    function updateSlot(instance, aMount)
    {
        render.instance = instance;
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
        if (slotPointer.id < 8) // jesli przeniesiemy ze slotu wymiany gracza na slot wymiany gracza
        {
            slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id < 18) // jesli przeniesiemy ze slotu wymiany npc
        {
            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id <= 107) // jesli przeniesiemy z ekwipunku gracza
        {
            slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
        }
    }
    else if (slot.id < 18) // jesli przeniesiemy na sloty wymiany npc
    {
        if (slotPointer.id > 107) // jesli przeniesiemy z ekwipunku npc
        {
            slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
        }
        else if (slotPointer.id < 18 && slotPointer.id > 7) // jesli przeniesiemy ze slotu wymiany npc na slot wymiany npc
        {
            slot.updateSlot(slotPointer.render.instance, slotPointer.amount);
            slotPointer.updateSlot("", 0);
        }
        else if (slotPointer.id < 8) // jesli przeniesiemy ze slotu wymiany gracza
        {
            slotPointer.updateSlot("", 0);
        }
    }
    else // jesli nie przeniesiemy na zadne ze slotow wymiany
    {
        if (slotPointer.id < 8) // jesli przenosimy ze slotu wymiany gracza
        {
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

function tradeRender()
{
    if (holding)
    {
        local curs = getCursorPosition();
        holdedRender.setPosition(curs.x - cursorOffX, curs.y - cursorOffY);
    }

    local basketValue = 0;

    foreach(v in slots)
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
            if (v.background.file != v.equippedTex && !v.hovered)
            {
                v.rehover();
            }
        }

        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            v.hover();
        }
        else
        {
            v.unhover();
        }
    }

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