EscMenu <- {};
local enabled = false;

local tex = null;
local submenus = null;
local submenuHeight = 600;
local submenuSpan = 100;
local currentSubmenu = 0;

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

        draw.setColor(255, 150, 0);

        hovered = true;
    }

    function unhover()
    {
        if (!hovered) return;

        if (active)
            draw.setColor(5, 150, 0);
        else
            draw.setColor(255, 255, 255);

        hovered = false;
    }

    function activate()
    {
        if (active) return;
        draw.setColor(5, 150, 0);
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
    tex = Texture(0, 0, 8192, 600, "WINDOW_BACKGROUND_SF.TGA");

    subMenu("Wroc");
    subMenu("Mapa");
    subMenu("Ekwipunek");
    subMenu("Statystyki");
    subMenu("Ustawienia");
    subMenu("Wyjdz");

    repositionSubmenus();
    submenus[0].activate();
}

function EscMenu::Enable(val)
{
    setFreeze(val);
    disableControls(val);
    setCursorVisible(val);
    Camera.movementEnabled = !val;

    tex.visible = val;

    foreach(v in submenus)
    {
        v.enable(val);
    }

    enabled = val;

    if (val == true)
    {
        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
        enableSubmenu(true);
    }
    else
    {
        setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
        enableSubmenu(false);
    }
}

function EscMenu::Top()
{
    tex.top();

    foreach(v in submenus)
    {
        v.top();
    }
}

function enableSubmenu(val)
{
    switch(currentSubmenu)
    {
        case 0: // default

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
            enableSettings(val)
        break;

        case 5: // quit

        break;
    }
}

function escMenuRender()
{
    if (!enabled) return;

    foreach(v in submenus)
    {
        local pos = v.texture.getPosition();
        local size = v.texture.getSize();

        if (inSquare(getCursorPosition(), pos, size))
        {
            v.hover();
        }
        else
        {
            v.unhover();
        }
    }
}

function selectSubmenu(i, v)
{
    submenus[currentSubmenu].deactivate();
    enableSubmenu(false);

    v.activate();
    currentSubmenu = i;
    enableSubmenu(true);
}

local pressed = -1;

function escMenuClickPress(key)
{
    if (!enabled) return;
    if (key != MOUSE_LMB) return;

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
    if (pressed == -1) return;

    foreach(i, v in submenus)
    {
        if (i != pressed) continue;

        local pos = v.texture.getPosition();
        local size = v.texture.getSize();

        if (inSquare(getCursorPosition(), pos, size))
        {
            pressed = -1;
            selectSubmenu(i, v);
        }
    }
}