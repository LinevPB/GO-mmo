local map = null;
local meOnMap = null;
local mapEnabled = false;
local myName = "";

function initMap()
{
    map = Texture(600, 600, 8192 - 1200, 8192 - 1200, "MAP_ARCHOLOS.TGA");
    meOnMap = Draw(0, 0, "+ Hero");
    meOnMap.setColor(180, 180, 255);

    map.visible = true;
    meOnMap.visible = true;
    map.alpha = 0;
    meOnMap.alpha = 0;
}

function enableMap(val)
{
    if (val == true)
    {
        map.alpha = 255;
        meOnMap.alpha = 255;
        mapEnabled = true;

        return;
    }

    map.alpha = 0;
    meOnMap.alpha = 0;
    mapEnabled = false;
}

local function calcMapX(x)
{
    return (4096 + x / 24.75);
}

local function calcMapY(y)
{
    return (4096 - y / 13.25)
}

function mapRender()
{
    if (!mapEnabled) return;

    local pos = getPlayerPosition(heroId);
    meOnMap.setPosition(calcMapX(pos.x), calcMapY(pos.z));

    if (myName != getPlayerName(heroId))
    {
        myName = getPlayerName(heroId);
        meOnMap.text = "+ " + myName;
    }

    map.top();
    meOnMap.top();
}