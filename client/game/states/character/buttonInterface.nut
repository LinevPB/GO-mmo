local buttons = [];
class buttonInterface
{
    btn = null;
    enabled = null;

    constructor(x, y, width, height, text)
    {
        btn = Button(x, y, width, height, "BUTTON_BACKGROUND.TGA", text, "BUTTON_BACKGROUND.TGA");
        btn.setBackgroundRegularColor(200, 20, 20);
        btn.setBackgroundHoverColor(150, 20, 20);
        btn.rehover();

        enabled = false;

        buttons.append(this);
    }

    function enable(val)
    {
        btn.enable(val);

        enabled = val;
    }

    function getBottom()
    {
        return btn.pos.y + btn.size.height;
    }

    function setPosition(x, y)
    {
        btn.setPosition(x, y);
    }

    function getPosition()
    {
        return btn.pos;
    }

    function setColor(r, g, b)
    {
        btn.setBackgroundRegularColor(r, g, b);
        btn.rehover();
    }

    function setHoverColor(r, g, b)
    {
        btn.setBackgroundHoverColor(r, g, b);
        btn.rehover();
    }
}

function characterButtonHandler(id)
{
    foreach(v in buttons)
    {
        if (!v.enabled) continue;
        if (v.btn.id == id)
        {
            return buttonInterfaceHandler(v);
        }
    }
}

function destroyButtonInterface(btn)
{
    foreach(i, v in buttons)
    {
        if (v != btn) continue;

        return buttons.remove(i);
    }
}