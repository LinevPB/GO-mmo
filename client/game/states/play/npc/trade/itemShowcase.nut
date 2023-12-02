local TShowcase = null;
local TShowcase2 = null;
local TShowcaseVisible = false;
local argy = 0;

function initTradeShowcase()
{
    TShowcase = {
        texture = Texture(0, 0, 2000, 1800, "SR_BLANK.TGA"),
        cover = Texture(0, 0, 2000, 1800, "MENU_INGAME.TGA"),
        nameDraw = Draw(0, 0, "Laga"),
        nameCover = Texture(0, 0, 0, 0, "MENU_CHOICE_BACK.TGA"),
        priceDraw = Draw(0, 0, "Price: "),
        priceAmountDraw = Draw(0, 0, "0"),
        render = null
    };

    TShowcase2 = {
        texture = Texture(2900, 3000, 1400, 3000, "SR_BLANK.TGA"),
        cover = Texture(2900, 3000, 1400, 3000, "MENU_INGAME.TGA"),
        render = ItemRender(2900, 3000, 1400, 1400, ""),
        draws = [],
        valueDraw = Draw(0, 0, "0")
    };

    TShowcase2.texture.setColor(10, 10, 60);

    for(local i = 0; i < 4; i++)
    {
        TShowcase2.draws.append(Draw(0, 0, ""));
    }
    TShowcase2.draws.append(Draw(0, 0, "Price: "));

    TShowcase.priceAmountDraw.setColor(0, 150, 255);
    TShowcase.texture.setColor(10, 10, 60);
    TShowcase.nameDraw.setColor(100, 255, 100);

    TShowcase.render = ItemRender(200, 1200, 1000, 1000, "ITMI_NUGGET");
    TShowcase.render.lightingswell = true;
    TShowcase.render.rotX = 0;
    TShowcase.render.rotY = 0;
    TShowcase.render.rotZ = 0;
    TShowcase.render.visible = false;

    TShowcase2.draws[0].setPosition(3000, 4400);
    for(local j = 1; j < 5; j++) {
        TShowcase2.draws[j].setPosition(3000, TShowcase2.draws[j - 1].getPosition().y + TShowcase2.draws[j - 1].height + 50);
    }
    TShowcase2.valueDraw.setPosition(3000 + TShowcase2.draws[4].width, TShowcase2.draws[4].getPosition().y);
    TShowcase2.valueDraw.setColor(0, 150, 255);

    TShowcase2.render.top();
}

function isTradeShowcaseVisible()
{
    return TShowcaseVisible;
}

function enableTradeShowcase(val, arg = 0)
{
    if (val == 2)
    {
        TShowcase.texture.visible = false;
        TShowcase.cover.visible = false;
        TShowcase.nameCover.visible = false;
        TShowcase.render.visible = false;
        TShowcase.nameDraw.visible = false;
        TShowcase.priceDraw.visible = false;
        TShowcase.priceAmountDraw.visible = false;

        return;
    }

    argy = arg;

    TShowcase.texture.visible = val;
    TShowcase.cover.visible = val;
    TShowcase.nameCover.visible = val;
    TShowcase.render.visible = val;
    TShowcase.nameDraw.visible = val;
    TShowcase.priceDraw.visible = val;
    TShowcase.priceAmountDraw.visible = val;

    TShowcase2.texture.visible = val;
    TShowcase2.cover.visible = val;
    TShowcase2.render.visible = val;

    foreach(v in TShowcase2.draws)
    {
        v.visible = val;
        v.top();
    }

    TShowcase2.valueDraw.visible = val;
    TShowcase2.valueDraw.top();

    TShowcase.render.top();
    TShowcaseVisible = val;
}

function handleTradeShowcase(info)
{
    for(local i = 0; i < 4; i++)
    {
        TShowcase2.draws[i].text = info[i];
    }
}

function updateTradeShowcase(instance)
{
    local item = ServerItems.find(instance);

    TShowcase.render.instance = instance;
    TShowcase.nameDraw.text = item.name;
    TShowcase2.render.instance = instance;

    TShowcase.priceAmountDraw.text = calcGoldAmount(item.price);
    TShowcase2.valueDraw.text = calcGoldAmount(item.price);

    switch(item.type)
    {
        case ItemType.WEAPON:
            handleTradeShowcase(handleWeaponInfo(item));
        break;

        case ItemType.ARMOR:
            handleTradeShowcase(handleArmorInfo(item));
        break;

        case ItemType.AMMO:
            handleTradeShowcase(handleAmmoInfo(item));
        break;

        case ItemType.MAGIC:
            handleTradeShowcase(handleMagicInfo(item));
        break;

        case ItemType.FOOD:
            handleTradeShowcase(handleFoodInfo(item));
        break;

        case ItemType.POTION:
            handleTradeShowcase(handlePotionInfo(item));
        break;

        case ItemType.OTHER:
            handleTradeShowcase(handleOtherInfo(item));
        break;
    }

    for(local i = 0; i < 4; i++)
    {
        TShowcase2.draws[i].setColor(190, 190, 190);
        TShowcase2.draws[i].visible = true;
    }
}

function updateTradeShowcasePosition(holding)
{
    if (!isTradeShowcaseVisible()) return;
    if (holding == true)
    {
        if (isTradeShowcaseVisible())
        {
            enableTradeShowcase(2);
        }

        return;
    }

    local curs = getCursorPosition();
    curs.x -= 500;
    if (argy == 1) curs.y -= 1800;
    TShowcase.texture.setPosition(curs.x, curs.y);
    TShowcase.cover.setPosition(curs.x, curs.y);

    local max_width = 1000;
    if (TShowcase.nameDraw.width > max_width) max_width = TShowcase.nameDraw.width;
    if (TShowcase.priceDraw.width + TShowcase.priceAmountDraw.width > max_width) max_width = TShowcase.priceDraw.width + TShowcase.priceAmountDraw.width;

    TShowcase.texture.setSize(max_width + 200, TShowcase.texture.getSize().height);
    TShowcase.cover.setSize(TShowcase.texture.getSize().width, TShowcase.texture.getSize().height);

    TShowcase.nameDraw.setPosition(curs.x + TShowcase.texture.getSize().width / 2 - TShowcase.nameDraw.width / 2, curs.y + 50);
    TShowcase.nameCover.setPosition(TShowcase.nameDraw.getPosition().x - 50, TShowcase.nameDraw.getPosition().y - 50);
    TShowcase.nameCover.setSize(TShowcase.nameDraw.width + 100, TShowcase.nameDraw.height + 100);
    TShowcase.render.setPosition(curs.x + TShowcase.texture.getSize().width / 2 - TShowcase.render.getSize().width / 2, curs.y + TShowcase.nameDraw.height + 150);

    TShowcase.texture.setSize(TShowcase.texture.getSize().width, 1700);
    TShowcase.cover.setSize(TShowcase.texture.getSize().width, TShowcase.texture.getSize().height);

    TShowcase.priceDraw.setPosition(TShowcase.texture.getPosition().x + 100, TShowcase.render.getPosition().y + TShowcase.render.getSize().height);
    TShowcase.priceAmountDraw.setPosition(TShowcase.priceDraw.getPosition().x + TShowcase.priceDraw.width, TShowcase.priceDraw.getPosition().y);

    TShowcase.render.rotY += 1;
}