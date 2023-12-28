local gold_cover_tex = null;
local esc_lab = null;
local gold_lab = null;
local sec_gold_lab = null;
local ore_render = null;
local big_inv_title = null;
local big_stat_title = null;
local coverTex1 = null;
local coverTex2 = null;
local coverTex3 = null;
local itemAmountDraw = null;

local inv = {
    itemSlots = null
};

function letCoversTop()
{
    gold_cover_tex.top();
    gold_lab.top();
    ore_render.top();
    sec_gold_lab.top();
    coverTex3.top();
    itemAmountDraw.top();
    EscMenu.Top();
}

function updateGoldDraws()
{
    local res = "";
    local temp = Player.gold + "";
    while(temp.len() > 3) {
        res = "," + temp.slice(temp.len() - 3, temp.len()) + res;
        temp = temp.slice(0, temp.len() - 3);
    }
    res = temp + res;

    gold_lab.text = lang["ORE"][Player.lang];
    sec_gold_lab.text = res;
}

function setupCoverTextures()
{
    gold_lab = Draw(0, 0, lang["ORE"][Player.lang]);
    sec_gold_lab = Draw(0, 0, "0");

    ore_render = ItemRender(0, 0, 0, 0, "ItMi_Nugget");
    gold_cover_tex = createCoverTexture(0, 0, 0, 0);

    coverTex3 = createCoverTexture(0, 8192-392, Inventory.width, 392);
    itemAmountDraw = Draw(0, 0, "Items: 0/100");
    itemAmountDraw.setColor(200, 220, 240);
}

function createCoverTexture(x, y, width, height)
{
    return Texture(x, y, width, height, "TEXTBOX_BACKGROUND.TGA");
}

function enableCover()
{
    local goldY = getMainMenu().pos.y + 400;
    local goldX = Inventory.MAX_COLUMN * Inventory.SIZE + 600 - 36;
    local goldWidth = Inventory.width - Inventory.MAX_COLUMN*Inventory.SIZE - Inventory.SIZE - 92;

    gold_lab.visible = true;
    gold_lab.setColor(255, 255, 255);
    gold_lab.setPosition(goldX + 350, goldY);

    ore_render.visible = true;
    ore_render.setPosition(goldX - gold_lab.height + 250, goldY - 100);
    ore_render.setSize(gold_lab.height * 2, gold_lab.height * 2);

    sec_gold_lab.visible = true;
    sec_gold_lab.setColor(0, 150, 255);
    sec_gold_lab.setPosition(gold_lab.getPosition().x + gold_lab.width, goldY);


    gold_cover_tex.visible = true;
    gold_cover_tex.setPosition(goldX, goldY - 50);
    gold_cover_tex.setSize(goldWidth, gold_lab.height + 100);

    coverTex3.visible = true;
    itemAmountDraw.text = (lang["ITEMS"][Player.lang] + ": " + getUniqueItemsAmount() + "/" + Inventory.MAX_ITEMS);
    itemAmountDraw.setPosition(250, 8192-392 + 392/2 - itemAmountDraw.height / 2);
    itemAmountDraw.visible = true;
}

function disableCover()
{
    gold_cover_tex.visible = false;
    gold_lab.visible = false;
    sec_gold_lab.visible = false;
    ore_render.visible = false;
    coverTex3.visible = false;
    itemAmountDraw.visible = false;
}