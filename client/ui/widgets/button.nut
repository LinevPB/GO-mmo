class Button extends Element {
    constructor(x, y, width, height, texture, title, hover_texture = "DLG_CONVERSATION.TGA") {
        base.constructor(x, y, width, height, texture, title, hover_texture);
        elementType = ElementType.BUTTON;
        UI_Elements.append(this);
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
        draw.setColor(hoverColor.r, hoverColor.g, hoverColor.b);
    }

    function unhover()
    {
        base.unhover();
        draw.setColor(regularColor.r, regularColor.g, regularColor.b);
    }
}