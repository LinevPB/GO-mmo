class Label extends Element {
    constructor(x, y, text) {
        base.constructor(x, y, 0, 0, false, text);
        elementType = ElementType.LABEL;
        UI_Elements.append(this);
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        draw.setPosition(x, y);
    }

    function move(x, y) {
        local calcX = pos.x + x;
        local calcY = pos.y + y;
        setPosition(calcX, calcY);
    }

    function setColor(r, g, b)
    {
        draw.setColor(r, g, b);
    }

    function setFont(font)
    {
        draw.font = font;
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
            setPosition(parent.pos.x + parent.size.width / 2 - draw.width / 2, pos.y);
            return;
        }
        setPosition(8192 / 2 - draw.width / 2, pos.y);
    }

    function width()
    {
        return draw.width;
    }

    function height()
    {
        return draw.height;
    }
}