local sliderSize = 200;

class SliderMask extends Element
{
    range = null;
    lastX = null;
    maskX = null;
    offsetX = null;
    leftClicked = null;
    lengthX = 0;
    parent = null;

    constructor(x, y, width, tex, scope, length = 0)
    {
        base.constructor(x, y, width, width, tex, "", "NONE");
        elementType = ElementType.SLIDER_MASK;
        range = scope;
        maskX = 0;
        lastX = 0;
        offsetX = 0;
        leftClicked = false;
        lengthX = length - size.width;

        UI_Elements.append(this);
    }

    function update()
    {
        maskX = getCursorPosition().x - offsetX;
        if (maskX < 0) maskX = 0;
        if (maskX > lengthX) maskX = lengthX;
        setPosition(parent.pos.x + maskX, pos.y);
        parent.update();
    }

    function enable(val)
    {
        base.enable(val);
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
    }

    function reset()
    {
        base.reset();
        elementType = null;
    }

    function hover()
    {
        base.hover();
        //draw.setColor(hoverColor.r, hoverColor.g, hoverColor.b);
    }

    function unhover()
    {
        base.unhover();
        //draw.setColor(regularColor.r, regularColor.g, regularColor.b);
    }
}

class Slider extends Element {
    mask = null;
    textuboxu = null;
    labelu = null;
    leftBtn = null;
    rightBtn = null;
    constructor(x, y, width, texture, scope, label="", sliderTex = "MENU_MASKE.TGA") {
        base.constructor(x, y, width, sliderSize / 2, texture, "", "NONE");
        elementType = ElementType.SLIDER;
        mask = SliderMask(x, y, sliderSize * 1.25, "MENU_MASKE.TGA", 12, width);
        textuboxu = NumericBox(x, y, 250, 250, "INV_SLOT_FOCUS.TGA", scope);
        labelu = Label(x, y, label);
        mask.parent = this;

        UI_Elements.append(this);
    }

    function update()
    {
        local calc = (textuboxu.range * (mask.maskX / (size.width - mask.size.width))).tointeger();
        textuboxu.updateRaw(calc);
    }

    function getValue()
    {
        return (textuboxu.range * (mask.maskX / (size.width - mask.size.width))).tointeger();
    }

    function enable(val)
    {
        if(mask) {
            mask.enable(val);
        }
        if (textuboxu) {
            textuboxu.enable(val);
        }
        if (labelu) {
            labelu.enable(val);
        }
        base.enable(val);
        setPosition(pos.x, pos.y);
        update();
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        mask.setPosition(x + mask.maskX, y - mask.size.height / 2 + size.height / 2);
        draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
        labelu.setPosition(x, mask.pos.y - draw.height - 50);
        textuboxu.setPosition(labelu.pos.x + 50 + labelu.draw.width, labelu.pos.y + draw.height / 2 - textuboxu.size.height / 2);
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