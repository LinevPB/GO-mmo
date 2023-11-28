local sliderSize = 200;

class SliderMask extends Element
{
    range = null;

    lastX = null;
    lastY = null;

    maskX = null;
    maskY = null;

    offsetX = null;
    offsetY = null;

    lengthX = null;
    lengthY = null;

    leftClicked = null;

    constructor(x, y, width, tex, scope, length = 0)
    {
        base.constructor(x, y + width / 2, width, width, tex, "", "NONE");

        elementType = ElementType.SLIDER_MASK;
        range = scope;
        maskX = 0;
        lastX = 0;
        lastY = 0;
        offsetY = 0;
        offsetX = 0;
        maskY = 0;
        leftClicked = false;
        lengthX = length - size.width;
        lengthY = length - size.height;

        UI_Elements.append(this);
    }

    function update()
    {
        if (!parent.vertical) {
            maskX = getCursorPosition().x - offsetX;
            if (maskX < 0) maskX = 0;
            if (maskX > lengthX) maskX = lengthX;
            setPosition(parent.pos.x + maskX, pos.y);
            parent.update();
            return;
        }

        maskY = getCursorPosition().y - offsetY;
        if (maskY < 0) maskY = 0;
        if (maskY > lengthY) maskY = lengthY;
        setPosition(parent.pos.x + parent.size.width / 2 - size.width / 2, parent.pos.y + maskY);
        parent.update();
    }

    function enable(val)
    {
        base.enable(val);
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
    }

    function reset()
    {
        base.reset();
        elementType = null;
    }

    function hover()
    {
        base.hover();
    }

    function unhover()
    {
        base.unhover();
    }
}

class Slider extends Element {
    mask = null;
    textuboxu = null;
    labelu = null;
    leftBtn = null;
    rightBtn = null;
    vertical = null;
    hasLabel = null;

    constructor(x, y, width, texture, scope, label="", sliderTex = "MENU_MASKE.TGA", vert = false) {
        vertical = vert;

        if (!vertical)
            base.constructor(x, y, width, sliderSize / 2, texture, "", "NONE");
        else
            base.constructor(x, y, sliderSize / 2, width, texture, "", "NONE");

        elementType = ElementType.SLIDER;

        if (label != "")
        {
            textuboxu = NumericBox(x, y, 250, 250, "MENU_CHOICE_BACK.TGA", scope);
            labelu = Label(x, y, label);
            hasLabel = true;
        }
        else
        {
            hasLabel = false;
        }

        mask = SliderMask(x, y, sliderSize, sliderTex, scope, width);
        mask.parent = this;

        UI_Elements.append(this);
    }

    function update()
    {
        if (hasLabel) {
            local calc = (textuboxu.range * (mask.maskX / (size.width - mask.size.width))).tointeger();
            textuboxu.updateRaw(calc);
        }
    }

    function getValue()
    {
        if (hasLabel)
        {
            return (mask.range * (mask.maskX / (size.width - mask.size.width))).tointeger();
        }

        return (mask.range * (mask.maskY / (size.height - mask.size.height))).tointeger();
    }

    function enable(val)
    {
        if (hasLabel) {
            textuboxu.enable(val);
            labelu.enable(val);
        }

        base.enable(val);

        if(mask) {
            mask.enable(val);
        }

        setPosition(pos.x, pos.y);
        update();
    }

    function setPosition(x, y) {
        base.setPosition(x, y);

        if (!vertical) {
            draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
            labelu.setPosition(x, mask.pos.y - draw.height - 50);
            textuboxu.setPosition(labelu.pos.x + 50 + labelu.draw.width, labelu.pos.y + draw.height / 2 - textuboxu.size.height / 2);

            mask.setPosition(x + mask.maskX, pos.y + size.height / 2 - mask.size.height / 2);
        } else {
            mask.setPosition(pos.x + size.width / 2 - mask.size.width / 2, y + mask.maskY);
        }
    }

    function reset()
    {
        base.reset();
        elementType = null;
    }

    function hover()
    {
        base.hover();
        draw.setColor(hoverColor.r, hoverColor.g, hoverColor.b);
    }

    function unhover()
    {
        base.unhover();
        draw.setColor(regularColor.r, regularColor.g, regularColor.b);
    }
}