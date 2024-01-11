local pHelp = null;
local pFrame = null;
local draws = null;

function initHelp()
{
    pHelp = provWindow(2000, 1000, 4000, 6000);
    pHelp.setTitle(lang["HELP"][Player.lang]);

    pFrame = Texture(2200, 1400, 3600, 5000, "WINDOW_BACKGROUND_SF.TGA");

    draws = [];

    for(local i = 0; i < 24; i++)
    {
        draws.append(Draw(2300, 1500 + 200 * i, ""));
    }

    draws[0].text = lang["NO_HELP"][Player.lang];
}

function enableHelp(val)
{
    pHelp.enable(val);
    pFrame.visible = val;

    foreach(v in draws)
    {
        v.visible = val;
    }
}