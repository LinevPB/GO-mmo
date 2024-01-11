local listBtn = null;
local helpBtn = null;
local secTex = null;

local menuOpened = -1;
local secEnabled = false;

class menuBtn
{
    btn = null;

    constructor(x, y, text)
    {
        btn = Button(x, y, 1000, 400, "BUTTON_BACKGROUND.TGA", text, "BUTTON_BACKGROUND.TGA");
        btn.setBackgroundRegularColor(200, 20, 20);
        btn.setBackgroundHoverColor(150, 20, 20);
        btn.rehover();
    }

    function enable(val)
    {
        btn.enable(val);
    }

    function getId()
    {
        return btn.id;
    }
}

function initSecMenu()
{
    listBtn = menuBtn(6800, 6800, lang["PLAYER_LIST"][Player.lang]);
    helpBtn = menuBtn(6800, 7400, lang["HELP"][Player.lang]);
    secTex = Texture(6700, 6700, 1200, 1200, "WINDOW_BACKGROUND_SF.TGA");
}

function enableSecMenu(val)
{
    if (secEnabled == val) return;

    secTex.visible = val;

    listBtn.enable(val);
    helpBtn.enable(val);

    secEnabled = val;
}

function onTryCloseProvWindow(ptr = -1)
{
    switch(menuOpened)
    {
        case 0: // player list
            enablePlayerList(false);
            enableSecMenu(true);
        break;

        case 1: // help window
            enableHelp(false);
            enableSecMenu(true);
        break;
    }

    menuOpened = -1;
}

function setProvMenu(val)
{
    menuOpened = val;
}

function isSecMenuEnabled()
{
    return secEnabled;
}

function secMenuBtnPress(id)
{
    switch(id)
    {
        case listBtn.getId():
            enablePlayerList(true);
            enableSecMenu(false);
            setProvMenu(0);
        break;

        case helpBtn.getId():
            enableHelp(true);
            enableSecMenu(false);
            setProvMenu(1);
        break;
    }
}