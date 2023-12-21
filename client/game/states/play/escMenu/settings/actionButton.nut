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
        active = true;
        hovered = false;

        actionButtons.append(this);
    }

    function enable(val)
    {
        draw.visible = val;
        enabled = val;
    }

    function hover()
    {
        if (!active) return;

        draw.setColor(255, 255, 0);
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
        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
}