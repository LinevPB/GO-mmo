local provWindows = [];
local pressedPtr = null;

class provWindow
{
    headerTex = null;
    headerClose = null;
    closeMark = null;
    headerDraw = null;

    tex = null;

    pos = null;
    size = null;

    enabled = null;

    constructor(x, y, width, height)
    {
        headerTex = Texture(x, y, width, 250, "TEXTBOX_BACKGROUND.TGA");
        headerTex.setColor(150, 150, 150);

        headerClose = Texture(x + width - 250, y, 250, 250, "INVENTORY_SLOT.TGA");
        headerClose.setColor(255, 60, 60);

        closeMark = Texture(x + width - 250 + 30, y + 30, 250 - 80, 250 - 80, "X_MARK_WHITE.TGA");

        headerDraw = Draw(x, y, "");

        tex = Texture(x, y, width, height - 250, "WINDOW_BACKGROUND_SF.TGA");

        pos = { x = x, y = y };
        size = { width = width, height = height };

        provWindows.append(this);
    }

    function setTitle(val)
    {
        headerDraw.text = val;
        headerDraw.setPosition(pos.x + size.width / 2 - headerDraw.width / 2, pos.y + 125 - headerDraw.height / 2);
    }

    function enable(val)
    {
        tex.visible = val;
        headerTex.visible = val;
        headerClose.visible = val;
        headerDraw.visible = val;
        closeMark.visible = val;

        enabled = val;
    }

    function hover()
    {
        closeMark.setColor(255, 100, 0);
    }

    function unhover()
    {
        closeMark.setColor(255, 255, 255);
    }
}

function onProvWindowClick(key)
{
    if (key != MOUSE_BUTTONLEFT) return;

    local curs = getCursorPosition();
    foreach(v in provWindows)
    {
        if (inSquare(curs, v.headerClose.getPosition(), v.headerClose.getSize()))
        {
            pressedPtr = v;
            return;
        }
    }

    pressedPtr = null;
}
addEventHandler("onMouseClick", onProvWindowClick);

function onProvWindowRelease(key)
{
    if (key != MOUSE_BUTTONLEFT) return;
    if (pressedPtr == null) return;

    if (inSquare(getCursorPosition(), pressedPtr.headerClose.getPosition(), pressedPtr.headerClose.getSize()))
    {
        onTryCloseProvWindow(pressedPtr);
    }

    pressedPtr = null;
}
addEventHandler("onMouseRelease", onProvWindowRelease);

function onProvWindowRender()
{
    local curs = getCursorPosition();
    foreach(v in provWindows)
    {
        if (inSquare(curs, v.headerClose.getPosition(), v.headerClose.getSize()))
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
}
addEventHandler("onRender", onProvWindowRender);

