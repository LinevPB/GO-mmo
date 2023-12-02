local showcase = {
    texture = Texture(0, 0, 2000, 2300, "SR_BLANK.TGA"),
    cover = Texture(0, 0, 2000, 2300, "MENU_INGAME.TGA"),
    nameDraw = Draw(0, 0, "Laga"),
    nameCover = Texture(0, 0, 0, 0, "MENU_CHOICE_BACK.TGA"),
    draws = [Draw(0, 0, "Obrażenia: "),Draw(0, 0, "Obrażenia: "),Draw(0, 0, "Obrażenia: "),Draw(0, 0, "Obrażenia: ")],
    render = ItemRender(200, 1200, 1000, 1000, ""),
    id = -1
}

function handleShowcaseInfo(itemInfo)
{
    for(local i = 0; i < 4; i++)
    {
        showcase.draws[i].text = itemInfo[i];
    }
}

function showcaseHover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
    if (el.more == null) return;
    if (el.more.instance == null || el.more.instance == "" || el.more.instance == "-1" || el.more.instance == "0") return;

    showcase.render.instance = el.more.render.instance;
    showcase.texture.visible = true;
    showcase.cover.visible = true;
    showcase.nameCover.visible = true;
    showcase.id = el.id;
    showcase.nameDraw.visible = true;

    local item = ServerItems.find(showcase.render.instance);
    if (item == null)
    {
        print("Couldnt find `" + showcase.render.instance + "`")
    }
    showcase.nameDraw.text = item.name;

    local amount = getItemAmount(showcase.render.instance);
    if (amount > 1)
        showcase.nameDraw.text = showcase.nameDraw.text + " x" + amount;

    showcase.render.visible = true;
    showcase.nameDraw.setColor(100, 255, 100);
    showcase.texture.setColor(10, 10, 60);
    showcase.render.lightingswell = true;
    showcase.render.rotX = -30;
    showcase.render.rotZ = 0;
    showcase.render.rotY = 0;
    showcase.render.top();

    switch(item.type)
    {
        case ItemType.WEAPON:
            handleShowcaseInfo(handleWeaponInfo(item));
        break;

        case ItemType.ARMOR:
            handleShowcaseInfo(handleArmorInfo(item));
        break;

        case ItemType.AMMO:
            handleShowcaseInfo(handleAmmoInfo(item));
        break;

        case ItemType.MAGIC:
            handleShowcaseInfo(handleMagicInfo(item));
        break;

        case ItemType.FOOD:
            handleShowcaseInfo(handleFoodInfo(item));
        break;

        case ItemType.POTION:
            handleShowcaseInfo(handlePotionInfo(item));
        break;

        case ItemType.OTHER:
            handleShowcaseInfo(handleOtherInfo(item));
        break;
    }

    for(local i = 0; i < 4; i++)
    {
        showcase.draws[i].setColor(190, 190, 190);
        showcase.draws[i].visible = true;
    }
}

function showcaseUnhover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
    if (showcase.id != el.id) return;

    showcase.texture.visible = false;
    showcase.cover.visible = false;
    showcase.nameDraw.visible = false;
    showcase.nameCover.visible = false;
    showcase.render.visible = false;

    for(local i = 0; i < 4; i++)
    {
        showcase.draws[i].visible = false;
    }
}

function showcaseRender()
{
    if (!showcase.texture.visible) return;

    local curs = getCursorPosition();
    showcase.texture.setPosition(curs.x, curs.y);
    showcase.cover.setPosition(curs.x, curs.y);

    local max_width = 1500;
    local max_line = 0;
    for(local i = 0; i < 4; i++) {
        if (showcase.draws[i].text != "") {
            if ((showcase.draws[i].width > max_width)) {
                max_width = showcase.draws[i].width;
            }
            max_line = i;
        }
    }
    showcase.texture.setSize(max_width + 200, showcase.texture.getSize().height);
    showcase.cover.setSize(showcase.texture.getSize().width, showcase.texture.getSize().height);

    showcase.nameDraw.setPosition(curs.x + showcase.texture.getSize().width / 2 - showcase.nameDraw.width / 2, curs.y + 50);
    showcase.nameCover.setPosition(showcase.nameDraw.getPosition().x - 50, showcase.nameDraw.getPosition().y - 50);
    showcase.nameCover.setSize(showcase.nameDraw.width + 100, showcase.nameDraw.height + 100);
    showcase.render.setPosition(curs.x + showcase.texture.getSize().width / 2 - showcase.render.getSize().width / 2, curs.y + showcase.nameDraw.height + 150);

    showcase.draws[0].setPosition(curs.x + 100, showcase.render.getPosition().y + showcase.render.getSize().height + 200);
    for(local i = 1; i < 4; i++) {
        showcase.draws[i].setPosition(curs.x + 100, showcase.draws[i - 1].getPosition().y + showcase.draws[i - 1].height + 50);
    }

    showcase.texture.setSize(showcase.texture.getSize().width,
        showcase.draws[max_line].getPosition().y - showcase.texture.getPosition().y + 100 + showcase.draws[max_line].height);
    showcase.cover.setSize(showcase.texture.getSize().width, showcase.texture.getSize().height);

    showcase.render.rotY += 1;
}

function handleShowcaseClick(id)
{
    if (showcase.texture.visible == true)
    {
        invUnhover({id = id, elementType = ElementType.BUTTON});
    }
}