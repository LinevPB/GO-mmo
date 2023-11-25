class Button extends Element {
    centered = null;
    align_left = null;
    my_pos = null;
    outer_release = null;
    forced = null;

    constructor(x, y, width, height, texture, title, hover_texture = "DLG_CONVERSATION.TGA") {
        base.constructor(x, y, width, height, texture, title, hover_texture);
        centered = true;
        elementType = ElementType.BUTTON;
        UI_Elements.append(this);
        my_pos = { x = x, y = y };
        outer_release = false;
        align_left = false;
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        if (centered) {
            my_pos.x = pos.x + size.width / 2 - draw.width / 2;
            my_pos.y = pos.y + size.height / 2 - draw.height / 2;
            draw.setPosition(my_pos.x, my_pos.y);
        }
        else {
            if (align_left)
                draw.setPosition(pos.x + 25, pos.y + size.height / 2 - draw.height / 2);
            else
                draw.setPosition(pos.x + size.width - draw.width - 25, pos.y + size.height - draw.height - 25);
        }
    }

    function force_enable(val)
    {
        forced = val;
        if (forced != null) enable(forced);
    }

    function enable(val) {
        if (forced != null) val = forced;
        base.enable(val);
        setPosition(pos.x, pos.y);
    }

    function setDrawPosition(x, y)
    {
        my_pos.x = pos.x + x;
        my_pos.y = pos.y + y;
        draw.setPosition(my_pos.x, my_pos.y);
    }

    function changeText(val) {
        draw.text = val;
        setPosition(pos.x, pos.y);
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

    function rehover()
    {
        hover();
        unhover();
    }

    function recolor()
    {
        draw.setColor(regularColor.r, regularColor.g, regularColor.b);
    }
}