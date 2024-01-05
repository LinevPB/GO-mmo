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

local currentRes = null;
local currentSightFactor = null;
local currentLODMod = null;
local currentLODOverr = null;
local currentSoundVol = null;
local currentMusicVol = null;
local somethingChanged = false;
local selectedResOpt = -1;

local lastCamPos = null;
local lastCamRot = null;

function initSettings()
{
    lastCamPos = Camera.getPosition();
    lastCamRot = Camera.getRotation();

    settingsMenu = Texture(0, 600, 8192, 8192 - 600, "BACKGROUND_BORDERLESS.TGA");
    settingsContainer = Texture(1000, 300, 6192, 8192, "WINDOW_BACKGROUND_SF.TGA");

    actionMenu = Texture(0, 7692, 8192, 500, "DIALOG_BACKGROUND.TGA");

    actionSave = actionButton(6192, 7692, 1000, 500, lang["APPLY"][Player.lang]);
    actionCancel = actionButton(7192, 7692, 1000, 500, lang["CANCEL"][Player.lang]);

    videoTitle = Draw(baseX, 900, lang["VIDEO_SETTINGS"][Player.lang]);
    videoTitle.font = "FONT_OLD_20_WHITE_HI.TGA";

    initRes();

    sightSlider = settingsSlider(baseX, resDropdown.getBottomY() + 300, 3000, 5.0, 0.02, 5.0);
    sightSlider.setTitle(lang["SIGHT_FACTOR"][Player.lang]);
    //The player sight factor (in the range between 0.02-5.0).
    currentSightFactor = getSightFactor();
    sightSlider.setValue(currentSightFactor);

    renderDetailSlider = settingsSlider(baseX, sightSlider.getBottomY() + 300, 3000, 1.0, 0.0, 1.0);
    renderDetailSlider.setTitle(lang["LOD_STRENGTH_MODIFIER"][Player.lang]);
    //The LOD strength value in range <0.0, 1.0>.
    currentLODMod = getLODStrengthModifier();
    renderDetailSlider.setValue(currentLODMod);

    renderOverrideSlider = settingsSlider(baseX, renderDetailSlider.getBottomY() + 300, 3000, 2, -1, 1, false, false);
    renderOverrideSlider.setTitle(lang["DETAIL_RENDER_DISTANCE"][Player.lang]);
    //The LOD strength value. - -1 use values stored within mesh. - 0 don't use LOD for mesh. - 1 >= use aggressive LOD
    currentLODOverr = getLODStrengthOverride();
    renderOverrideSlider.setValue(currentLODOverr + 1);

    audioTitle = Draw(baseX, renderOverrideSlider.getBottomY() + 400, lang["AUDIO_SETTINGS"][Player.lang]);
    audioTitle.font = "FONT_OLD_20_WHITE_HI.TGA";

    musicSlider = settingsSlider(baseX, audioTitle.getPosition().y + audioTitle.height + 200, 3000, 1.0, 0, 100, true);
    musicSlider.setTitle(lang["MUSIC_VOLUME"][Player.lang]);
    //volume value in range <0.0, 1.0>.
    currentMusicVol = getMusicVolume();
    musicSlider.setValue(currentMusicVol);

    soundSlider = settingsSlider(baseX, musicSlider.getBottomY() + 300, 3000, 1.0, 0, 100, true);
    soundSlider.setTitle(lang["SOUND_VOLUME"][Player.lang]);
    //volume value in range <0.0, 1.0>.
    currentSoundVol = getSoundVolume();
    soundSlider.setValue(currentSoundVol);

    windowSlider = Slider(6192, 900, 6492, "SLIDER_BACKGROUND_VERTICAL.TGA", 2000, "", "SLIDER_HANDLE.TGA", true);
}

function updateSettingsPosition(x, y)
{
    videoTitle.setPosition(baseX + x, 900 + y);

    resTitle.setPosition(baseX + x, videoTitle.getPosition().y + videoTitle.height + 300);
    resDropdown.setPosition(baseX + x, resTitle.height + resTitle.getPosition().y + 100);
    sightSlider.setPosition(baseX + x, resDropdown.getBottomY() + 300);
    renderDetailSlider.setPosition(baseX + x, sightSlider.getBottomY() + 300);
    renderOverrideSlider.setPosition(baseX + x, renderDetailSlider.getBottomY() + 300);
    audioTitle.setPosition(baseX + x, renderOverrideSlider.getBottomY() + 400);
    musicSlider.setPosition(baseX + x, audioTitle.getPosition().y + audioTitle.height + 200);
    soundSlider.setPosition(baseX + x, musicSlider.getBottomY() + 300);
}

function initRes()
{
    local res = getResolution();
    currentRes = res;

    resTitle = Draw(baseX, videoTitle.getPosition().y + videoTitle.height + 300, lang["RESOLUTION"][Player.lang]);
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
            selectedResOpt = resDropdown.selected;
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

    updateGameSettings();

    EscMenu.Top();

    if (val == true)
    {
        lastCamPos = Camera.getPosition();
        lastCamRot = Camera.getRotation();

        Camera.setPosition(37925, 4700, 44486);
        Camera.setRotation(0, 95, 0);
    }
    else
    {
        Camera.setPosition(lastCamPos.x, lastCamPos.y, lastCamPos.z);
        Camera.setRotation(lastCamRot.x, lastCamRot.y, lastCamRot.z);
    }
}

function updateGameSettings()
{
    currentSightFactor = getSightFactor();
    currentLODMod = getLODStrengthModifier();
    currentLODOverr = getLODStrengthOverride();
    currentMusicVol = getMusicVolume();
    currentSoundVol = getSoundVolume();
    currentRes = getResolution();
}

function resChanged(res1, res2)
{
    if (res1.x == res2.x && res1.y == res2.y && res1.bpp == res2.bpp) return false;
    return true;
}

function sightFactorChanged()
{
    if (currentSightFactor != sightSlider.getValue()) return true;
    return false;
}

function LODModChanged()
{
    if (currentLODMod != renderDetailSlider.getValue()) return true;
    return false;
}

function LODOverrChanged()
{
    if (currentLODOverr != renderOverrideSlider.getValue()) return true;
    return false;
}

function musicVolChanged()
{
    if (currentMusicVol != musicSlider.getValue()) return true;
    return false;
}

function soundVolChanged()
{
    if (currentSoundVol != soundSlider.getValue()) return true;
    return false;
}

function activateChangeButtons()
{
    if (somethingChanged) return;
    somethingChanged = true;

    actionSave.setActive(true);
    actionCancel.setActive(true);
}

function deactivateChangeButtons()
{
    if (!somethingChanged) return;
    somethingChanged = false;

    actionSave.setActive(false);
    actionCancel.setActive(false);
}

function handleChanges()
{
    if (sightFactorChanged() || LODModChanged() || LODOverrChanged() || musicVolChanged() || soundVolChanged() || resChanged(currentRes, resDropdown.getSelectedConfig()))
    {
        activateChangeButtons();
    }
    else
    {
        deactivateChangeButtons();
    }
}

function onSlideControls(el)
{

}

function onSlideWindow()
{
    updateSettingsPosition(0, -windowSlider.getValue());
}

function onSettingsSlide(el)
{
    if (!settingsEnabled) return;

    slidersSlide(el);
    dropdownSlide(el);

    if (el == windowSlider)
    {
        onSlideWindow();
    }
}

function settingsRender()
{
    if (!settingsEnabled) return;

    handleChanges();

    actionButtonsRender();
    dropdownRender();
}

function settingsPress()
{
    if (!settingsEnabled) return;
    if (getCursorPosition().y <= 600) return;

    dropdownPress();
    actionButtonPress();
}

function settingsRelease()
{
    if (!settingsEnabled) return;

    dropdownRelease();
    actionButtonRelease();
}

local function restoreAll()
{
    deactivateChangeButtons();

    if (sightFactorChanged())
    {
        sightSlider.setValue(currentSightFactor);
    }

    if (LODModChanged())
    {
        renderDetailSlider.setValue(currentLODMod);
    }

    if (LODOverrChanged())
    {
        renderOverrideSlider.setValue(currentLODOverr);
    }

    if (musicVolChanged())
    {
        musicSlider.setValue(currentMusicVol);
    }

    if (soundVolChanged())
    {
        soundSlider.setValue(currentSoundVol);
    }

    if (resChanged(currentRes, resDropdown.getSelectedConfig()))
    {
        resDropdown.restore(selectedResOpt);
    }
}

local function saveAny()
{
    if (sightFactorChanged())
    {
        setSightFactor(sightSlider.getValue());
    }

    if (LODModChanged())
    {
        setLODStrengthModifier(renderDetailSlider.getValue())
    }

    if (LODOverrChanged())
    {
        setLODStrengthOverride(renderOverrideSlider.getValue());
    }

    if (musicVolChanged())
    {
        setMusicVolume(musicSlider.getValue());
    }

    if (soundVolChanged())
    {
        setSoundVolume(soundSlider.getValue())
    }

    if (resChanged(currentRes, resDropdown.getSelectedConfig()))
    {
        local res = resDropdown.getSelectedConfig();
        setResolution(res.x, res.y, res.bpp);
        selectedResOpt = resDropdown.selected;
    }

    updateGameSettings();
    deactivateChangeButtons();
    saveLogicalKeys();
}

function onClickActionButton(i)
{
    switch(i)
    {
        case 0:
            saveAny();
        break;

        case 1:
            restoreAll();
        break;
    }
}