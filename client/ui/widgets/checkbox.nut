local checkboxes = [];
local pressedHolder = null;

class Checkbox
{
    pos = null;
    size = null;
    enabled = null;
    name = null;
    checked = null;

    draw = null;
    texture = null;
    checkedTexture = null;

    constructor(x, y, text)
    {
        texture = Texture(x, y, 150, 200, "WINDOW_BACKGROUND.TGA");
        checkedTexture = Texture(x, y, 150, 200, "X_MARK.TGA");

        draw = Draw(x, y, text);
        draw.setPosition(x + 250, y + 100 - draw.height / 2);
        pos = { x = x, y = y };
        size = { width = draw.width + 400, height = 200 };
        enabled = false;
        checked = false;
        name = text;

        checkboxes.append(this);
    }

    function check()
    {
        if (checked) return;

        if (enabled)
        {
            checkedTexture.visible = true;
        }

        checked = true;
    }

    function uncheck()
    {
        if (!checked) return;

        checkedTexture.visible = false;
        checked = false;
    }

    function hover()
    {
        draw.setColor(200, 200, 255);
    }

    function unhover()
    {
        draw.setColor(255, 255, 255);
    }

    function enable(val)
    {
        if (enabled == val) return;

        draw.visible = val;
        texture.visible = val;

        if (val == true && checked == true)
        {
            checkedTexture.visible = true;
            checkedTexture.top();
        }

        enabled = val;
    }
}

function destroyCheckbox(el)
{
    foreach(i, v in checkboxes)
    {
        if (v == el)
        {
            v.enable(false);
            return checkboxes.remove(i);
        }
    }
}

addEventHandler("onMouseClick", function(key) {
    if (key != MOUSE_BUTTONLEFT) return;

    local curs = getCursorPosition();
    foreach(v in checkboxes)
    {
        if (!v.enabled) continue;
        if (inSquare(curs, v.pos, v.size))
        {
            pressedHolder = v;
            return;
        }
    }
});

addEventHandler("onMouseRelease", function(key) {
    if (key != MOUSE_BUTTONLEFT) return;
    if (pressedHolder == null) return;
    if (!pressedHolder.enabled) return;
    if (!inSquare(getCursorPosition(), pressedHolder.pos, pressedHolder.size)) return;

    if (pressedHolder.checked)
    {
        pressedHolder.uncheck();
    }
    else
    {
        pressedHolder.check();
    }

    pressedHolder = null;
});

addEventHandler("onRender", function() {
    foreach(v in checkboxes)
    {
        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
});