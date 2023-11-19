class Window extends Element {
    elements = null;

    constructor(x, y, width, height, texture = "DLG_CONVERSATION.TGA", title = "", hover_texture = "NONE") {
        base.constructor(x, y, width, height, texture, title, hover_texture);
        elementType = ElementType.WINDOW;
        elements = [];
        UI_Elements.append(this);
    }

    function attach(val) {
        val.setPosition(val.pos.x + pos.x, val.pos.y + pos.y);
        elements.append(val);
        refresh();
    }

    function enable(val) {
        base.enable(val);

        foreach (el in elements) {
            el.enable(val);
        }
    }

    function reset()
    {
        base.reset();
        foreach(el in elements) {
            destroy(el);
        }
    }

    function setColorForAllButtons(r,g,b)
    {
        foreach(v in elements) {
            if (v.elementType == ElementType.BUTTON)
                v.setColor(r, g, b);
        }
    }

    function setHoverColorForAllButtons(r,g,b)
    {
        foreach(v in elements) {
            if (v.elementType == ElementType.BUTTON)
                v.setHoverColor(r, g, b);
        }
    }
}

function switchWindows(window1, window2) {
    window1.enable(false);
    window2.enable(true);
}
