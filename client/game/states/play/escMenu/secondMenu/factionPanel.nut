local pFaction = null;
local pFrame = null;
local draws = null;

function initFaction()
{
    pFaction = provWindow(2000, 1000, 4000, 6000);
    pFaction.setTitle("FACTION PANEL");

    pFrame = Texture(2200, 1400, 3600, 5000, "WINDOW_BACKGROUND_SF.TGA");

    draws = [];

    for(local i = 0; i < 24; i++)
    {
        draws.append(Draw(2300, 1500 + 200 * i, ""));
    }

    draws[0].text = "Faction";
    draws[1].text = "Members";
}

function enableFactionPanel(val)
{
    pFaction.enable(val);
    pFrame.visible = val;

    foreach(v in draws)
    {
        v.visible = val;
    }
}