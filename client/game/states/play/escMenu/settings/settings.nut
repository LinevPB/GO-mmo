local settingsMenu = null;
local settingsContainer = null;
local settingsEnabled = false;

local resTitle = null;
local resDropdown = null;

local musicSlider = null;
local soundSlider = null;
local sightSlider = null;
local renderDetailSlider = null;
local renderOverrideSlider = null;

local baseX = 1400;

local actionMenu = null;
local actionSave = null;
local actionCancel = null;

local videoTitle = null;
local audioTitle = null;

local windowSlider = null;

function initSettings()
{
    settingsMenu = Texture(0, 600, 8192, 8192 - 600, "BACKGROUND_BORDERLESS.TGA");
    settingsContainer = Texture(1000, 300, 6192, 8192, "WINDOW_BACKGROUND_SF.TGA");

    actionMenu = Texture(0, 7692, 8192, 500, "WINDOW_BACKGROUND_SF.TGA");

    actionSave = actionButton(6192, 7692, 1000, 500, "Apply");
    actionCancel = actionButton(7192, 7692, 1000, 500, "Cancel");

    videoTitle = Draw(baseX, 900, "Video settings");
    videoTitle.font = "FONT_OLD_20_WHITE_HI.TGA";

    initRes();

    sightSlider = settingsSlider(baseX, resDropdown.getBottomY() + 300, 2500, 5);
    sightSlider.setTitle("Sight render distance");

    renderDetailSlider = settingsSlider(baseX, sightSlider.getBottomY() + 300, 2500, 1);
    renderDetailSlider.setTitle("Render detail");

    renderOverrideSlider = settingsSlider(baseX, renderDetailSlider.getBottomY() + 300, 2500, 2);
    renderOverrideSlider.setTitle("Detail render distance");

    audioTitle = Draw(baseX, renderOverrideSlider.getBottomY() + 400, "Audio settings");
    audioTitle.font = "FONT_OLD_20_WHITE_HI.TGA";

    musicSlider = settingsSlider(baseX, audioTitle.getPosition().y + audioTitle.height + 200, 2500, 100);
    musicSlider.setTitle("Music volume");

    soundSlider = settingsSlider(baseX, musicSlider.getBottomY() + 300, 2500, 100);
    soundSlider.setTitle("Sound volume");

    windowSlider = Slider(6192, 900, 6492, "SLIDER_BACKGROUND_VERTICAL.TGA", 1000, "", "SLIDER_HANDLE.TGA", true);
}

function initRes()
{
    local res = getResolution();

    resTitle = Draw(baseX, videoTitle.getPosition().y + videoTitle.height + 300, "Resolution");
    resDropdown = Dropdown(baseX, resTitle.height + resTitle.getPosition().y + 100, 2000, 400, res.x + "x" + res.y + "x" + res.bpp);

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
    settingsMenu.visible = val;
    settingsContainer.visible = val;

    videoTitle.visible = val;

    resTitle.visible = val;
    resDropdown.enable(val);

    sightSlider.enable(val);
    renderDetailSlider.enable(val);
    renderOverrideSlider.enable(val);

    audioTitle.visible = val;

    musicSlider.enable(val);
    soundSlider.enable(val);

    actionMenu.visible = val;
    actionSave.enable(val);
    actionCancel.enable(val);

    windowSlider.enable(val);

    settingsEnabled = val;

    EscMenu.Top();
}

function onSlideControls(el)
{
    switch(el)
    {
        case musicSlider:

        break;
    }
}

function onSettingsSlide(el)
{
    if (!settingsEnabled) return;

    slidersSlide(el);

    dropdownSlide(el);
}

function settingsRender()
{
    if (!settingsEnabled) return;

    actionButtonsRender();
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