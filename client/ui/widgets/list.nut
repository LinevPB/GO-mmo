class ListElement extends Element {
    selected = null;
    unchanged = null;

    constructor(x, y, width, height, texture, title, hover_texture = "DLG_CONVERSATION.TGA") {
        base.constructor(x, y, width, height, texture, title, hover_texture);
        elementType = ElementType.LIST_ELEMENT;
        selected = false;
        unchanged = true;

        background.texture.setColor(240, 240, 240);

        UI_Elements.append(this);
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
    }

    function getSlot()
    {
        foreach(i, v in parent.options) {
            if (v == this) return i;
        }
    }

    function move(x, y) {
        pos.x += x;
        pos.y += y;
        setPosition(pos.x, pos.y);
    }

    function changeText(text)
    {
        draw.text = text;
        move(0,0);
        unchanged = false;
    }

    function enable(val)
    {
        base.enable(val)
        hover();
        unhover();
    }

    function reset()
    {
        base.reset();
        elementType = null;
    }

    function hover()
    {
        if (selected) {
            draw.setColor(220, 220, 255);
            draw.alpha = 255;
        } else {
            draw.alpha = 255;
            draw.setColor(hoverColor.r, hoverColor.g, hoverColor.b);
        }
        base.hover();
    }

    function unhover()
    {
        if(!selected) {
            draw.setColor(hoverColor.r, hoverColor.g, hoverColor.b);
            base.unhover();
            draw.alpha = 150;
        }
    }
}

class List extends Element {
    options = null;
    currentOpt = null;
    firstAsDefault = false;
    constructor(x, y, width, height, texture, set, elWidth, elHeight, elX, elY, elTex, elHovTex) {
        base.constructor(x, y, width, height, texture, "", "NONE");
        elementType = ElementType.LIST;
        options = [];
        foreach(i, v in set) {
            local el = ListElement(x + elX*(i), y + elY*(i), elWidth, elHeight, elTex, v, elHovTex);
            el.parent = this;
            options.append(el);
        }
        currentOpt = -1;

        UI_Elements.append(this);
    }

    function selectFirstAsDefault()
    {
        select(options[0].id);
        onPressListElement(options[0]);
    }

    function enable(val)
    {
        base.enable(val);
        foreach(v in options) {
            v.enable(val);
        }
    }

    function setPosition(x, y) {
        local offsetX = x - pos.x;
        local offsetY = y - pos.y;
        foreach(v in options) {
            v.move(offsetX, offsetY);
        }
        base.setPosition(x, y);
    }

    function reset()
    {
        base.reset();
        elementType = null;
    }

    function center()
    {
        local parent = hasParent();
        if (parent) {
            setPosition(parent.pos.x + parent.size.width / 2 - size.width / 2, pos.y);
        }
    }

    function update()
    {

    }

    function uncheck(v)
    {
        v.selected = false;
        currentOpt = -1;
        v.unhover();
    }

    function check(v)
    {
        v.selected = true;
        currentOpt = v.id;
        v.hover();
    }

    function getOption()
    {
        return currentOpt;
    }

    function getSlot()
    {
        foreach(i, v in options) {
            if (currentOpt == v.id) return i;
        }
    }

    function select(eid)
    {
        if (currentOpt == eid) return;

        foreach(v in options) {
            if (v.id == currentOpt) uncheck(v);
        }

        foreach(v in options) {
            if (v.id == eid) check(v);
        }
    }
}