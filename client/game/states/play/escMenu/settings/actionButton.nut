local actionButtons = [];

class actionButton
{
    draw = null;
    enabled = null;
    pos = null;
    size = null;
    active = null;
    hovered = null;

    constructor(x, y, width, height, text)
    {
        pos = {x = x, y = y};
        size = {width = width, height = height};
        draw = Draw(0, 0, text);
        draw.font = "FONT_OLD_20_WHITE_HI.TGA";
        draw.setPosition(x + width / 2 - draw.width / 2, y + height / 2 - draw.height / 2);

        enabled = false;
        hovered = false;

        setActive(false);

        actionButtons.append(this);
    }

    function setActive(val)
    {
        if (active == val) return;

        if (val == true)
        {
            draw.alpha = 255;
        }
        else
        {
            unhover();
            draw.alpha = 100;
        }

        active = val;
    }

    function getPos()
    {
        return pos;
    }

    function getSize()
    {
        return size;
    }

    function enable(val)
    {
        draw.visible = val;
        enabled = val;
    }

    function hover()
    {
        if (!active) return;

        draw.setColor(170, 170, 255);
    }

    function unhover()
    {
        if (!active) return;

        draw.setColor(255, 255, 255);
    }
}

function actionButtonsRender()
{
    foreach(v in actionButtons)
    {
        if (inSquare(getCursorPosition(), v.getPos(), v.getSize()) && v.active)
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
}

local pressed = -1;

function actionButtonPress()
{
    foreach(i, v in actionButtons)
    {
        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            pressed = i;
            return;
        }
    }
}

function actionButtonRelease()
{
    if (pressed == -1) return;

    foreach(i, v in actionButtons)
    {
        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            if (pressed == i)
            {
                pressed = -1;
                onClickActionButton(i);
                return;
            }
        }
    }
}