local settingsMenu = null;
local settingsEnabled = false;
local resDropdown = null;

function initSettings()
{
    settingsMenu = Window(0, 600, 8192, 8192-600, "WINDOW_BACKGROUND_SF.TGA");

    initRes();
}

function initRes()
{
    local res = getResolution();
    resDropdown = Dropdown(500, 1000, 2000, 400, res.x + "x" + res.y + "x" + res.bpp);

    local allRes = getAvailableResolutions();
    foreach(v in allRes)
    {
        if (v.x < 800 || v.y < 600) continue;
        if (v.bpp == 16) continue;

        resDropdown.addOption(v.x + "x" + v.y + "x" + v.bpp, v);

        if (v.x == res.x && v.y == res.y)
        {
            resDropdown.selectOption(resDropdown.options.len() - 1);
        }
    }
    resDropdown.createSlider();
}

function enableSettings(val)
{
    settingsMenu.enable(val);
    resDropdown.enable(val);

    settingsEnabled = val;
}

function onSettingsSlide(el)
{
    if (!settingsEnabled) return;

    dropdownSlide(el);
}

function settingsRender()
{
    if (!settingsEnabled) return;

    dropdownRender();
}

function settingsPress()
{
    if (!settingsEnabled) return;

    dropdownPress();
}



function settingsRelease()
{
    if (!settingsEnabled) return;

    dropdownRelease();
}