EscMenu <- {};
local enabled = false;

local tex = null;
local submenus = null;
local submenuHeight = 600;
local submenuSpan = 100;
local currentSubmenu = -1;

class subMenu
{
    draw = null;
    texture = null;
    hovered = null;
    active = null;

    constructor(text)
    {
        draw = Draw(0, 0, text);
        draw.font = "FONT_OLD_20_WHITE_HI.TGA";

        texture = Texture(0, 0, 200, 600, "TEXTBOX_BACKGROUND.TGA");

        hovered = false;
        active = false;

        submenus.append(this);
    }

    function top()
    {
        texture.top();
        draw.top();
    }

    function enable(val)
    {
        //texture.visible = val;
        draw.visible = val;
    }

    function hover()
    {
        if (hovered) return;

        draw.setColor(0, 200, 255);

        hovered = true;
    }

    function unhover()
    {
        if (!hovered) return;

        if (active)
            draw.setColor(0, 180, 255);
        else
            draw.setColor(255, 255, 255);

        hovered = false;
    }

    function activate()
    {
        if (active) return;
        draw.setColor(0, 180, 255);
        active = true;
    }

    function deactivate()
    {
        if (!active) return;
        draw.setColor(255, 255, 255);
        active = false;
    }
}

local function repositionSubmenus()
{
    if (submenus.len() == 0) return;

    local totalSpace = 0;
    for(local i = submenus.len() - 1; i >= 0; i--)
    {
        totalSpace += submenus[i].draw.width;

        submenus[i].draw.setPosition(8192 - totalSpace - submenuSpan, submenuHeight / 2 - submenus[i].draw.height / 2);

        submenus[i].texture.setSize(submenus[i].draw.width + 200, submenuHeight);
        submenus[i].texture.setPosition(submenus[i].draw.getPosition().x - 100, 0);

        totalSpace += 250;
    }
}

function EscMenu::Init()
{
    submenus = [];
    tex = Texture(0, 0, 8192, 600, "ESC_BAR.TGA");

    subMenu(lang["RESUME"][Player.lang]);
    subMenu(lang["MAP"][Player.lang]);
    subMenu(lang["INVENTORY"][Player.lang]);
    subMenu(lang["CHARACTER"][Player.lang]);
    subMenu(lang["SETTINGS"][Player.lang]);
    subMenu(lang["QUIT"][Player.lang]);

    repositionSubmenus();
    initSecMenu();
}

function EscMenu::Enable(val, submenu = -1)
{
    if (tex == null) return;

    setFreeze(val);
    disableControls(val);
    setCursorVisible(val);

    Camera.movementEnabled = !val;

    tex.visible = val;

    foreach(v in submenus)
    {
        v.enable(val);
    }

    if (submenu != -1)
    {
        currentSubmenu = submenu;
        submenus[submenu].activate();
        enableSubmenu(val);
    }

    if (val == true)
    {
        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);

        if (submenu == -1)
        {
            enableSecMenu(true);
        }
    }
    else
    {
        setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
        disableAnyWindow();
        onTryCloseProvWindow();
        enableSecMenu(false);
    }

    enabled = val;
}

function getCurrentSubmenu()
{
    return currentSubmenu;
}

function EscMenu::Top()
{
    if (tex == null) return;

    tex.top();

    foreach(v in submenus)
    {
        v.top();
    }
}

function disableAnyWindow()
{
    switch(currentSubmenu)
    {
        case 1:
            enableMap(false);
        break;

        case 2:
            Inventory.Enable(false);
        break;

        case 3:
            enableStatistics(false);
        break;

        case 4:
            enableSettings(false);
        break;
    }

    if (currentSubmenu != -1)
    {
        submenus[currentSubmenu].deactivate();
        currentSubmenu = -1;
    }
}

function enableSubmenu(val)
{
    switch(currentSubmenu)
    {
        case 0: // back
            EscMenu.Enable(false);
            launchFree();
        break;

        case 1: // map
            enableMap(val);
        break;

        case 2: // eq
            Inventory.Enable(val);
        break;

        case 3: // stats
            enableStatistics(val);
        break;

        case 4: // settings
            enableSettings(val);
        break;

        case 5: // quit
            exitGame();
        break;
    }
}

function escMenuRender()
{
    if (!enabled) return;

    settingsRender();

    foreach(v in submenus)
    {
        local pos = v.texture.getPosition();
        local size = v.texture.getSize();

        if (inSquare(getCursorPosition(), pos, size))
        {
            v.hover();
            continue;
        }

        v.unhover();
    }
}

function selectSubmenu(i, v)
{
    if (currentSubmenu != -1)
    {
        submenus[currentSubmenu].deactivate();
        enableSubmenu(false);
        enableSecMenu(true);
    }

    if (i == currentSubmenu || i == -1)
    {
        currentSubmenu = -1;
        return;
    }

    v.activate();
    currentSubmenu = i;
    onTryCloseProvWindow();
    enableSubmenu(true);
    enableSecMenu(false);
}

local pressed = -1;

function escMenuClickPress(key)
{
    if (!enabled) return;
    if (key != MOUSE_LMB) return;

    statisticsPress();
    settingsPress();

    foreach(i, v in submenus)
    {
        local pos = v.texture.getPosition();
        local size = v.texture.getSize();

        if (inSquare(getCursorPosition(), pos, size))
        {
            pressed = i;
            return;
        }
    }
}

function escMenuClickRelease(key)
{
    if (!enabled) return;
    if (key != MOUSE_LMB) return;

    statisticsRelease();
    settingsRelease();

    if (pressed == -1) return;

    foreach(i, v in submenus)
    {
        if (i != pressed) continue;

        local pos = v.texture.getPosition();
        local size = v.texture.getSize();

        if (inSquare(getCursorPosition(), pos, size))
        {
            selectSubmenu(i, v);
            return;
        }
    }

    pressed = -1;
}