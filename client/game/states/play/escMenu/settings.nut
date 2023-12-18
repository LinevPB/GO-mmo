local draw = null;
local settingsMenu = null;
local enabled = false;

function initSettings()
{
    settingsMenu = Window(0, 600, 8192, 8192-600, "WINDOW_BACKGROUND_SF.TGA");
    draw = Draw(200, 1000, "Settings");
    draw.font = "FONT_OLD_20_WHITE_HI.TGA";
}

function enableSettings(val)
{
    settingsMenu.enable(val);
    draw.visible = val;

    enabled = val;
}

function settingsRender()
{

}
