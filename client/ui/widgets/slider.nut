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

    function setValue(val)
    {
        if (val > range) val = range;
        if (val < 0) val = 0;

        if (parent.vertical)
        {
            maskY = (parent.size.height.tofloat() - size.height) * (val.tofloat()/parent.range.tofloat()).tofloat();
            if (maskY < 0) maskY = 0;
            if (val > lengthY) maskY = lengthY;
            setPosition(parent.pos.x + parent.size.width / 2 - size.width / 2, parent.pos.y + maskY);
            parent.update();
            return;
        }

        maskX = (parent.size.width.tofloat() - size.width) * (val.tofloat()/(parent.range.tofloat())).tofloat();
        if (maskX < 0) maskX = 0;
        if (val > lengthX) maskX = lengthX;
        setPosition(parent.pos.x + maskX, pos.y);
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

    function top()
    {
        base.top();
    }

    function getWidth()
    {
        return size.width;
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
    sliderSize = null;
    range = null;

    constructor(x, y, width, texture, scope, label="", sliderTex = "MENU_MASKE.TGA", vert = false, slidSize = 200) {
        vertical = vert;
        sliderSize = slidSize;

        if (!vertical)
            base.constructor(x, y, width, sliderSize / 2, texture, "", "NONE");
        else
            base.constructor(x, y, sliderSize / 2, width, texture, "", "NONE");

        elementType = ElementType.SLIDER;

        if (label != "")
        {
            textuboxu = NumericBox(x, y, 250, 250, "TEXTBOX_BACKGROUND.TGA", scope);
            labelu = Label(x, y, label);
            hasLabel = true;
        }
        else
        {
            hasLabel = false;
        }

        range = scope;
        mask = SliderMask(x, y, sliderSize, sliderTex, scope, width);
        mask.parent = this;

        UI_Elements.append(this);
    }

    function getCenterY()
    {
        return mask.pos.y;
    }

    function update()
    {
        if (hasLabel) {
            local calc = (mask.range * (mask.maskX.tofloat() / (size.width - mask.size.width).tofloat())).tointeger();
            textuboxu.updateRaw(calc);
        }
    }

    function getValue()
    {
        if (hasLabel)
        {
            return (mask.range * (mask.maskX.tofloat() / (size.width - mask.size.width).tofloat())).tointeger();
        }

        return (mask.range * (mask.maskY.tofloat() / (size.height - mask.size.height).tofloat())).tointeger();
    }

    function getRawValue()
    {
        return (mask.range.tofloat() * (mask.maskX.tofloat() / (size.width.tofloat() - mask.size.width.tofloat()))).tofloat();
    }

    function setValue(val)
    {
        mask.setValue(val);
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

        if (hasLabel)
        {
            draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
            labelu.setPosition(x, mask.pos.y - draw.height - 50);
            textuboxu.setPosition(labelu.pos.x + 50 + labelu.draw.width, labelu.pos.y + draw.height / 2 - textuboxu.size.height / 2);
        }

        if (!vertical) {
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

    function top()
    {
        base.top();
        mask.top();
    }

    function getWidth()
    {
        return mask.getWidth();
    }
}