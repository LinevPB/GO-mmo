local SH_tex = null;
local SH_cover = null;
local SH_name = null;
local SH_nameCover = null;
local SH_render = null;
local SH_draws = null;
local SH_enabled = null;
local SH_hidden = null;
local SH_reverseY = null;
local SH_priceDraw = null;
local SH_wasPriceOnly = null;
local SH_offsetX = null;
Showcase <- {};

Showcase.Init <- function()
{
    SH_tex = Texture(0, 0, 1500, 1000, "SR_BLANK");
    SH_tex.setColor(10, 10, 40);
    SH_cover = Texture(0, 0, 1500, 1000, "WINDOW_BACKGROUND.TGA");

    SH_name = Draw(0, 0, "Item name");
    SH_name.setColor(0, 190, 255);
    SH_nameCover = Texture(0, 0, SH_name.width + 100, SH_name.height + 100, "TEXTBOX_BACKGROUND.TGA");

    SH_render = ItemRender(0, SH_nameCover.getPosition().y + SH_nameCover.getSize().height, 1000, 1000, "ITAR_GOVERNOR");
    SH_render.lightingswell = true;
    SH_resetRenderSettings();

    local baseY = SH_render.getPosition().y + SH_render.getSize().height;
    SH_draws = [];
    for(local i = 0; i < 4; i++)
    {
        SH_draws.append(Draw(0, baseY + (SH_name.height + 50) * i, "samplesamplesamplesamplesample"));
        SH_draws[i].setColor(180, 180, 180);
    }
    SH_priceDraw = Draw(SH_draws[0].getPosition().x + SH_draws[0].width, baseY, "");
    SH_priceDraw.setColor(0, 150, 255);

    SH_enabled = false;
    SH_hidden = false;
    SH_reverseY = false;
    SH_wasPriceOnly = false;
    SH_offsetX = 0;
}

Showcase.IsHidden <- function()
{
    return SH_hidden;
}

Showcase.Hide <- function(val)
{
    SH_tex.visible = val;
    SH_cover.visible = val;
    SH_nameCover.visible = val;
    SH_name.visible = val;
    SH_render.visible = val;

    foreach(v in SH_draws)
    {
        v.visible = val;
    }

    SH_hidden = val;

    if (val == true)
    {
        SH_render.top();
    }

    SH_offsetX = 0;
}

function SH_resetRenderSettings()
{
    SH_render.rotX = -30;
    SH_render.rotZ = 0;
    SH_render.rotY = 0;
}

local function SH_calcTexWidth()
{
    local minWidth = SH_name.width;
    foreach(v in SH_draws)
    {
        if (v.width > minWidth)
        {
            minWidth = v.width;
        }
    }

    minWidth += 200;

    local temp = SH_nameCover.getSize().width + 400;
    if (temp > minWidth) minWidth = temp;

    temp = SH_render.getSize().width;
    if (temp > minWidth) minWidth = temp;

    return minWidth;
}

local function SH_calcTexHeight()
{
    local totalHeight = SH_nameCover.getSize().height;

    if (SH_render.visible == true)
    {
        totalHeight += SH_render.getSize().height;
    }

    local temp = 0;
    foreach(i, v in SH_draws)
    {
        if (v.text != "" && v.visible)
        {
            temp = i;
        }
    }
    totalHeight += (SH_name.height + 50) * (temp + 1);
    totalHeight += 300;

    return totalHeight;
}

local function SH_updatePosition()
{
    local curs = getCursorPosition();
    local texWidth = SH_calcTexWidth();
    local texHeight = SH_calcTexHeight();

    if (curs.x + texWidth > 8192)
    {
        curs.x = 8192 - texWidth;
    }

    if (SH_offsetX != 0)
    {
        curs.x += SH_offsetX;
    }

    if (SH_reverseY)
    {
        curs.y -= texHeight;
    }

    SH_tex.setPosition(curs.x, curs.y);
    SH_cover.setPosition(curs.x, curs.y);
    SH_tex.setSize(texWidth, texHeight);
    SH_cover.setSize(texWidth, texHeight);

    SH_nameCover.setSize(SH_name.width + 100, SH_name.height + 100);
    SH_nameCover.setPosition(curs.x + texWidth / 2 - SH_nameCover.getSize().width / 2, curs.y);
    SH_name.setPosition(SH_nameCover.getPosition().x + SH_nameCover.getSize().width / 2 - SH_name.width / 2, SH_nameCover.getPosition().y + SH_nameCover.getSize().height / 2 - SH_name.height / 2);
    SH_render.setPosition(curs.x + texWidth / 2 - SH_render.getSize().width / 2, SH_nameCover.getPosition().y + SH_nameCover.getSize().height + 100);

    local baseX = curs.x + 100;
    local baseY = SH_render.getPosition().y + SH_render.getSize().height + 100;
    local constHeight = SH_name.height + 50;
    foreach(i, v in SH_draws)
    {
        v.setPosition(baseX, baseY + constHeight * i);
    }

    texHeight = SH_calcTexHeight();
    SH_tex.setSize(texWidth, texHeight);
    SH_cover.setSize(texWidth, texHeight);
}

Showcase.Enable <- function(val, reverseY = false)
{
    if (val == false && Showcase.IsHidden())
    {
        Showcase.Hide(false);
    }

    SH_updatePosition();

    SH_tex.visible = val;
    SH_cover.visible = val;
    SH_nameCover.visible = val;
    SH_name.visible = val;
    SH_render.visible = val;

    foreach(v in SH_draws)
    {
        v.visible = val;
    }

    SH_draws[0].setPosition(SH_draws[0].getPosition().x, SH_render.getPosition().y + SH_render.getSize().height);
    SH_priceDraw.setPosition(SH_draws[0].getPosition().x + SH_draws[0].width, SH_draws[0].getPosition().y);

    SH_enabled = val;
    SH_reverseY = reverseY;
    SH_priceDraw.visible = false;
}

local function SH_clearInfo()
{
    foreach(v in SH_draws)
    {
        v.text = "";
    }
}

local function SH_handleInfo(itemInfo)
{
    foreach(i, v in itemInfo)
    {
        SH_draws[i].text = v;
    }
}

function updateShowcaseName(name, amount)
{
    SH_name.text = name;

    if (amount > 1)
        SH_name.text = SH_name.text + " x" + amount;
}

Showcase.UpdateOnlyPrice <- function(instance, amount)
{
    SH_clearInfo();
    local item = ServerItems.find(instance);
    updateShowcaseName(item.name[Player.lang], amount);
    SH_render.instance = instance;
    SH_resetRenderSettings();

    SH_draws[0].text = lang["PRICE"][Player.lang];
    SH_priceDraw.text = calcGoldAmount(item.price);
    SH_draws[0].setPosition(SH_draws[0].getPosition().x, SH_render.getPosition().y + 100);
    SH_priceDraw.setPosition(SH_draws[0].getPosition().x + SH_draws[0].width, SH_draws[0].getPosition().y);
    SH_render.visible = false;
    SH_priceDraw.visible = true;

    SH_wasPriceOnly = true;
    SH_draws[0].setColor(255, 255, 255);
}

Showcase.SetOffsetX <- function(val)
{
    SH_offsetX = val;
}

Showcase.Update <- function(instance)
{
    if (instance == "") return;

    if (SH_wasPriceOnly)
    {
        SH_wasPriceOnly = false;
        SH_draws[0].setColor(180, 180, 180);
    }

    SH_clearInfo();

    local item = ServerItems.find(instance);
    updateShowcaseName(item.name[Player.lang], getItemAmount(instance));
    SH_render.instance = instance;
    SH_resetRenderSettings();

    switch(item.type)
    {
        case ItemType.WEAPON:
            SH_handleInfo(handleWeaponInfo(item, Player.lang));
        break;

        case ItemType.ARMOR:
            SH_handleInfo(handleArmorInfo(item, Player.lang));
        break;

        case ItemType.AMMO:
            SH_handleInfo(handleAmmoInfo(item, Player.lang));
        break;

        case ItemType.MAGIC:
            SH_handleInfo(handleMagicInfo(item, Player.lang));
        break;

        case ItemType.FOOD:
            SH_handleInfo(handleFoodInfo(item, Player.lang));
        break;

        case ItemType.POTION:
            SH_handleInfo(handlePotionInfo(item, Player.lang));
        break;

        case ItemType.OTHER:
            SH_handleInfo(handleOtherInfo(item, Player.lang));
        break;
    }
}

Showcase.IsEnabled <- function()
{
    return SH_enabled;
}

Showcase.Render <- function()
{
    if (!Showcase.IsEnabled()) return;

    SH_updatePosition();

    SH_render.rotY += 1;
}