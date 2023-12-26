local slot_id = 0;
local slots = [];
local pressedHolder = null;

class charSlot
{
    basePos = null;
    id = null;
    tex = null;
    nameDraw = null;
    levelDraw = null;
    hovered = null;
    selected = null;
    enabled = null;
    struct = null;

    constructor(x, y, name, level)
    {
        basePos = { x = x, y = y };

        tex = Texture(x, y, 2400, 800, "TEXTBOX_BACKGROUND.TGA");
        nameDraw = Draw(x + 100, y + 100, name);
        nameDraw.setColor(200, 200, 255);
        levelDraw = Draw(x + 100, y + 100 + nameDraw.height + 100, "Level " + level);

        id = slot_id;
        slot_id++;

        hovered = false;
        selected = false;
        enabled = false;

        slots.append(this);
    }

    function enable(val)
    {
        tex.visible = val;
        nameDraw.visible = val;
        levelDraw.visible = val;

        enabled = val;
    }

    function setStruct(val)
    {
        struct = val;
    }

    function getStruct()
    {
        return struct;
    }

    function isEnabled()
    {
        return enabled;
    }

    function getPosition()
    {
        return tex.getPosition();
    }

    function getSize()
    {
        return tex.getSize();
    }

    function getBottom()
    {
        return tex.getPosition().y + tex.getSize().height;
    }

    function hover()
    {
        if (hovered) return;

        tex.setColor(220, 220, 255);
        nameDraw.setColor(180, 180, 255);
        levelDraw.setColor(180, 180, 255);

        hovered = true;
    }

    function select()
    {
        if (selected) return;

        vis_select();

        selected = true;
    }

    function vis_select()
    {
        tex.setColor(220, 220, 255);
        nameDraw.setColor(180, 180, 255);
        levelDraw.setColor(180, 180, 255);
    }

    function unselect()
    {
        if (!selected) return;

        tex.setColor(255, 255, 255);
        nameDraw.setColor(200, 200, 255);
        levelDraw.setColor(255, 255, 255);

        selected = false;
    }

    function unhover()
    {
        if (selected)
        {
            return vis_select();
        }

        if (!hovered) return;

        tex.setColor(255, 255, 255);
        nameDraw.setColor(200, 200, 255);
        levelDraw.setColor(255, 255, 255);

        hovered = false;
    }

    function moveAway(x, y)
    {
        tex.setPosition(basePos.x + x, basePos.y + y);
        nameDraw.setPosition(basePos.x + x + 100, basePos.y + y + 100);
        levelDraw.setPosition(basePos.x + x + 100, basePos.y + y + 100 + nameDraw.height + 100);
    }
}

function onClickS(key)
{
    if (key != MOUSE_BUTTONLEFT) return;

    local curs = getCursorPosition();
    foreach(v in slots)
    {
        if (!v.enabled) continue;
        if (inSquare(curs, v.tex.getPosition(), v.tex.getSize()))
        {
            pressedHolder = v;
            return;
        }
    }

    if (pressedHolder != null) pressedHolder = null;
}

function onReleaseS(key)
{
    if (key != MOUSE_BUTTONLEFT) return;
    if (pressedHolder == null) return;

    local curs = getCursorPosition();
    if (inSquare(curs, pressedHolder.getPosition(), pressedHolder.getSize()))
    {
        onSelectSlot(pressedHolder.id);
    }

    pressedHolder = null;
}

function deinitSlots()
{
    slot_id = 0;
    slots = [];
}

function charSlotRender()
{
    local curs = getCursorPosition();

    foreach(v in slots)
    {
        if (!v.enabled) continue;
        if (inSquare(curs, v.tex.getPosition(), v.tex.getSize()) && isInFrame())
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
}
addEventHandler("onRender", charSlotRender);