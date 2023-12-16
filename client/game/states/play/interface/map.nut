local map = null;
local meOnMap = null;
local mapEnabled = false;

function initMap()
{
    map = Texture(0, 0, 8192, 8192, "MAP_WORLD_ORC.TGA");
    meOnMap = Draw(0, 0, "+ Hero");

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

function mapRender()
{
    if (!mapEnabled) return;

    local pos = getPlayerPosition(heroId);
    meOnMap.setPosition(4096 + pos.x / 24.75, 4096 - pos.z / 13.25);
}