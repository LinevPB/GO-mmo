local animVis = false;
local animMenu = null;
local animButtons = null;

local function btnHelper(x, y, text)
{
    local temp = Button(x, y, 1400, 500, "ANIM_ELEMENT.TGA", text, "ANIM_ELEMENT_HOVER.TGA");
    // temp.setBackgroundRegularColor(160, 160, 255);
    // temp.setBackgroundHoverColor(130, 130, 255);
    // temp.rehover();

    return temp;
}

function isAnimListEnabled()
{
    return animVis;
}

function initAnimList()
{
    animMenu = Window(0, 0, 8192, 8192, "");
    local leftX = 8192/2-1400 - 700;
    local rightX = 8192/2 + 700;

    animButtons = {
        btn = btnHelper(leftX, 2000, "Taniec"),
        btn1 = btnHelper(leftX, 2600, "Cwiczenia"),
        btn2 = btnHelper(leftX, 3200, "Magia"),
        btn3 = btnHelper(leftX, 3800, "Statyczne"),

        btn5 = btnHelper(rightX, 2000, "Uzycie"),
        btn6 = btnHelper(rightX, 2600, "Reakcje"),
        btn7 = btnHelper(rightX, 3200, "Rozne"),
        btn8 = btnHelper(rightX, 3800, "Czynnosci"),
    };

    animMenu.attach(animButtons.btn);
    animMenu.attach(animButtons.btn1);
    animMenu.attach(animButtons.btn2);
    animMenu.attach(animButtons.btn3);

    animMenu.attach(animButtons.btn5);
    animMenu.attach(animButtons.btn6);
    animMenu.attach(animButtons.btn7);
    animMenu.attach(animButtons.btn8);
}

function animListBtn(id)
{
    switch(id)
    {
        case animButtons.btn.id:

        break;

        case animButtons.btn1.id:

        break;

        default:
            enableAnimList(false);
        break;
    }
}

function animMouseClick(btn)
{
    if (!animVis) return;
}

function enableAnimList(val)
{
    setCursorVisible(val);
    animMenu.enable(val);
    setFreeze(val);
    disableControls(val);

    Camera.movementEnabled = !val;
    animVis = val;

    if (val == true)
    {
        setActionType(5);
        return;
    }

    setActionType(0);
}

function animMouseRelease(btn)
{
    if (btn != MOUSE_BUTTONRIGHT) return;

    if (getActionType() == 0 && !animVis)
    {
        enableAnimList(true);

        return;
    }

    if (getActionType() != 5) return;
    if (!animVis) return;

    enableAnimList(false);
}
