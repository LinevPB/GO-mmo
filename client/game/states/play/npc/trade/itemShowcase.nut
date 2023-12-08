local TShowcase2 = null;
local TShowcaseVisible = false;

function initTradeShowcase()
{
    TShowcase2 = {
        texture = Texture(2900, 2700, 1400, 3200, "SR_BLANK.TGA"),
        cover = Texture(2900, 2700, 1400, 3200, "MENU_INGAME.TGA"),
        render = ItemRender(2900, 2700, 1400, 1400, ""),
        draws = [],
        valueDraw = Draw(0, 0, "0")
    };

    TShowcase2.texture.setColor(10, 10, 60);

    for(local i = 0; i < 4; i++)
    {
        TShowcase2.draws.append(Draw(0, 0, ""));
    }
    TShowcase2.draws.append(Draw(0, 0, lang["PRICE"][Player.lang]));

    TShowcase2.draws[0].setPosition(3000, 4100);
    TShowcase2.draws[1].setPosition(3000, 4100 + TShowcase2.draws[0].height + 150);
    for(local j = 2; j < 5; j++) {
        TShowcase2.draws[j].setPosition(3000, TShowcase2.draws[j - 1].getPosition().y + TShowcase2.draws[j - 1].height + 75);
    }
    local pos = TShowcase2.draws[4].getPosition();
    TShowcase2.draws[4].setPosition(pos.x, pos.y + 150);
    TShowcase2.valueDraw.setPosition(3000 + TShowcase2.draws[4].width, TShowcase2.draws[4].getPosition().y);
    TShowcase2.valueDraw.setColor(0, 150, 255);

    TShowcase2.render.top();
}

function isTradeShowcaseVisible()
{
    return TShowcaseVisible;
}

function enableTradeShowcase(val, reverseY = false)
{
    Showcase.Enable(val, reverseY);
    TShowcase2.texture.visible = val;
    TShowcase2.cover.visible = val;
    TShowcase2.render.visible = val;

    foreach(v in TShowcase2.draws)
    {
        v.visible = val;
    }

    TShowcase2.valueDraw.visible = val;
}

function handleTradeShowcase(info)
{
    for(local i = 0; i < 4; i++)
    {
        TShowcase2.draws[i].text = info[i];
        TShowcase2.draws[i].top();
    }
}

function updateTradeShowcase(instance, amount = 1)
{
    local item = ServerItems.find(instance);
    TShowcase2.render.instance = instance;
    TShowcase2.valueDraw.text = calcGoldAmount(item.price);
    Showcase.UpdateOnlyPrice(instance, amount);

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
        Showcase.Hide(true);
    }
    else
    {
        Showcase.Hide(false);
    }
}