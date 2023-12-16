class Window extends Element {
    elements = null;
    frozen = null;
    coverTex = null;

    constructor(x, y, width, height, texture = "DLG_CONVERSATION.TGA", title = "", hover_texture = "NONE") {
        base.constructor(x, y, width, height, texture, title, hover_texture);
        elementType = ElementType.WINDOW;
        elements = [];
        UI_Elements.append(this);
        frozen = false;
        coverTex = null;
    }

    function attach(val) {
        val.parent = this;
        val.setPosition(val.pos.x + pos.x, val.pos.y + pos.y);
        elements.append(val);
        refresh();

        if (val.elementType == ElementType.BUTTON)
        {
            val.rehover();
        }
    }

    function enable(val) {
        base.enable(val);

        if (coverTex != null)
        {
            coverTex.visible = val;
        }

        foreach (el in elements)
        {
            el.enable(val);
        }
    }

    function setCover(tex)
    {
        coverTex = Texture(pos.x, pos.y, size.width, size.height, tex);
    }

    function reset()
    {
        base.reset();
        foreach(el in elements)
        {
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

    function setPosition(x, y)
    {
        foreach(v in elements)
        {
            v.setPosition(v.pos.x - pos.x + x, v.pos.y - pos.y + y);
        }

        if (coverTex!= null)
        {
            coverTex.setPosition(x, y);
        }

        base.setPosition(x, y);
    }

    function top()
    {
        base.top();
        coverTex.top();

        foreach(v in elements)
        {
            v.top();
        }
    }
}

function switchWindows(window1, window2) {
    window1.enable(false);
    window2.enable(true);
}
