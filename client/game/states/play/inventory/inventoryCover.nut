local gold_cover_tex = null;
local esc_lab = Draw(200, 8000, "(ESC) Press to resume");
local gold_lab = Draw(0, 0, "Ore: ");
local sec_gold_lab = Draw(0, 0, "0");
local ore_render = ItemRender(0, 0, 0, 0, "ItMi_Nugget");
local big_inv_title = Draw(0, 0, "Inventory");
local big_stat_title = Draw(0, 0, "Statistics");
local coverTex1 = null;
local coverTex11 = null;
local coverTex2 = null;
local coverTex22 = null;
local coverTex3 = null;
local coverTex33 = null;
local coverTex4 = null;

local inv = {
    itemSlots = null
};

function onInvSlide(el)
{
    if (!Inventory.IsEnabled()) return;

    handleSlideSlots(el);

    coverTex4.top();
    getStatisticsMenu().background.texture.top();

    coverTex11.top();
    coverTex1.top();
    coverTex22.top();
    coverTex2.top();
    coverTex33.top();
    coverTex3.top();

    gold_cover_tex.top();
    esc_lab.top();
    gold_lab.top();
    ore_render.top();
    sec_gold_lab.top();
    big_inv_title.top();
    big_stat_title.top();

    statisticsSlide();
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

    gold_lab.text = "Ore: ";
    sec_gold_lab.text = res;
}

function setupCoverTextures()
{
    gold_cover_tex = Texture(0, 0, 0, 0, "MENU_CHOICE_BACK.TGA");

    coverTex1 = createCoverTexture(0, 0, Inventory.width, Inventory.SIZE - 25);
    coverTex11 = createCoverTexture(coverTex1.getPosition().x, coverTex1.getPosition().y, coverTex1.getSize().width, coverTex1.getSize().height);
    coverTex11.setColor(0, 0, 0);

    coverTex2 = createCoverTexture(0, Inventory.SIZE + Inventory.MAX_ROW * Inventory.SIZE, Inventory.width, 100 + getStatisticsMenu().pos.y - ((Inventory.MAX_ROW + 1) * Inventory.SIZE));
    coverTex22 = createCoverTexture(coverTex2.getPosition().x, coverTex2.getPosition().y, coverTex2.getSize().width, coverTex2.getSize().height);
    coverTex22.setColor(0, 0, 0);

    coverTex3 = createCoverTexture(0, getStatisticsMenu().pos.y + getStatisticsMenu().size.height - 150, Inventory.width, 8192 - getStatisticsMenu().pos.y - getStatisticsMenu().size.height + 150);
    coverTex33 = createCoverTexture(coverTex3.getPosition().x, coverTex3.getPosition().y, coverTex3.getSize().width, coverTex3.getSize().height);
    coverTex33.setColor(0, 0, 0);

    coverTex4 = createCoverTexture(getStatisticsMenu().pos.x, getStatisticsMenu().pos.y, getStatisticsMenu().size.width, getStatisticsMenu().size.height);
    coverTex4.setColor(0, 0, 0);
}

function createCoverTexture(x, y, width, height)
{
    return Texture(x, y, width, height, "MENU_CHOICE_BACK.TGA");
}

function setCoverTexturesVisibility(val)
{
    coverTex1.visible = val;
    coverTex11.visible = val;
    coverTex2.visible = val;
    coverTex22.visible = val;
    coverTex3.visible = val;
    coverTex33.visible = val;
    coverTex4.visible = val;
}

function enableCover()
{
    esc_lab.visible = true;
    esc_lab.setColor(180, 200, 220);
    esc_lab.setPosition(200, coverTex3.getPosition().y + coverTex3.getSize().height / 2 - esc_lab.height / 2);

    gold_lab.visible = true;
    gold_lab.setColor(255, 255, 255);
    gold_lab.setPosition(getCharacterMenu().pos.x + 350, getCharacterMenu().pos.y - gold_lab.height);

    ore_render.visible = true;
    ore_render.setPosition(getCharacterMenu().pos.x - gold_lab.height + 250, getCharacterMenu().pos.y - gold_lab.height - 125);
    ore_render.setSize(gold_lab.height * 2, gold_lab.height * 2);

    sec_gold_lab.visible = true;
    sec_gold_lab.setColor(0, 150, 255);
    sec_gold_lab.setPosition(gold_lab.getPosition().x + gold_lab.width, getCharacterMenu().pos.y - gold_lab.height);


    gold_cover_tex.visible = true;
    gold_cover_tex.setPosition(getCharacterMenu().pos.x, getCharacterMenu().pos.y - gold_lab.height - 25);
    gold_cover_tex.setSize(getCharacterMenu().size.width, gold_lab.height + 25);

    big_inv_title.visible = true;
    big_inv_title.font = "FONT_OLD_20_WHITE_HI.TGA";
    big_inv_title.setColor(255, 250, 250);
    big_inv_title.setPosition(8192/4 - big_inv_title.width / 2, coverTex1.getPosition().y + coverTex1.getSize().height / 2 - big_inv_title.height / 2);

    big_stat_title.visible = true;
    big_stat_title.font = "FONT_OLD_20_WHITE_HI.TGA";
    big_stat_title.setColor(255, 250, 250);
    big_stat_title.setPosition(8192/4 - big_inv_title.width / 2, coverTex2.getPosition().y + coverTex2.getSize().height / 2 - big_stat_title.height / 2);
}

function disableCover()
{
    esc_lab.visible = false;
    gold_cover_tex.visible = false;
    gold_lab.visible = false;
    big_inv_title.visible = false;
    big_stat_title.visible = false;
    sec_gold_lab.visible = false;
    ore_render.visible = false;
}