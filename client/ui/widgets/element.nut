UI_Elements <- [];
activeElements <- [];
local element_id = 0;

enum ElementType {
    WINDOW,
    BUTTON,
    TEXTBOX,
    LABEL,
    LIST,
    LIST_ELEMENT,
    SLIDER,
    SLIDER_MASK,
    NUMERICBOX
}

class Element {
    id = null;
    pos = null;
    size = null;
    background = null;
    enabled = null;
    draw = null;
    leftClicked = null;
    elementType = null;
    regularColor = null;
    hoverColor = null;
    letterWidth = null;
    disableBackground = false;
    hovered = false;
    bg_color = null;
    bg_color_hover = null;
    parent = null;

    baseX = null;
    baseY = null;

    more = null;

    constructor(x, y, width, height, texture, title, hover_texture = "NONE") {
        id = element_id;
        element_id++;

        pos = { x = x, y = y };
        size = { width = width, height = height };

        if (texture != "NONE" && texture != null) {
            background = {
                regular = texture,
                hover = hover_texture,
                texture = Texture(x, y, width, height, texture)
            }
            background.texture.visible = false;
            bg_color = null;
            bg_color_hover = null;
        }

        draw = Draw(x, y, "Ab# sVt uIo PE# ### ### ###");
        letterWidth = draw.width / 27;
        draw.text = title;
        draw.visible = false;

        enabled = false;
        leftClicked = false;

        regularColor = { r = 255, g = 255, b = 255 };
        hoverColor = { r = 230, g = 170, b = 170 };
        hovered = false;

        baseX = x;
        baseY = y;
    }

    function isHovered()
    {
        return hovered;
    }

    function hasParent()
    {
        foreach(v in UI_Elements) {
            if (v.elementType == ElementType.LIST) {
                foreach(k in v.options) {
                    if (k.id == id) return k;
                }
            }
            if (v.elementType == ElementType.WINDOW) {
                foreach(k in v.elements) {
                    if (k.id == id) return v;
                }
            }
        }
        return false;
    }

    function reset() {
        id = null;
        pos = null;
        size = null;
        background = null;
        enabled = null;
        draw = null;
        leftClicked = null;
        elementType = null;
        regularColor = null;
        hoverColor = null;
        letterWidth = null;
    }

    function setPosition(x, y) {
        pos.x = x;
        pos.y = y;

        refresh();
    }

    function getPosition()
    {
        return pos;
    }

    function move(x, y) {
        pos.x += x;
        pos.y += y;
    }

    function refresh() {
        if (background != null) background.texture.setPosition(pos.x, pos.y);
    }

    function setBackground(texture) {
        if (background == null) return;
        background.texture.file = texture;
    }

    function setBackgroundColor(r,g,b) {
        if (background == null) return;
        background.texture.setColor(r, g, b);
    }

    function setBackgroundRegularColor(r,g,b) {
        if (background == null) return;
        bg_color = {r = r, g = g, b = b};
    }

    function setBackgroundHoverColor(r,g,b) {
        if (background == null) return;
        bg_color_hover = {r = r, g = g, b = b};
    }

    function enable(value) {
        if (value == true) {
            if (background != null) background.texture.visible = true;
            draw.visible = true;
            enabled = true;
            return;
        }

        enabled = false;
        draw.visible = false;
        if (background != null) background.texture.visible = false;
    }

    function hover() {
        if (hovered) return;

        hovered = true;
        if (background != null && background != "NONE") {
            if (background.hover == "NONE" || disableBackground) return;

            setBackground(background.hover);
            if (bg_color_hover != null)
                setBackgroundColor(bg_color_hover.r, bg_color_hover.g, bg_color_hover.b);
        }
        onHover(this);
    }

    function unhover() {
        if (!hovered) return;

        hovered = false;
        if (background != null && !disableBackground) {
            setBackground(background.regular);
            if (bg_color != null)
                setBackgroundColor(bg_color.r, bg_color.g, bg_color.b);
        }

        onUnhover(this);
    }

    function isEnabled() {
        return enabled;
    }

    function setColor(r, g, b)
    {
        regularColor = { r = r, g = g, b = b };
    }

    function setHoverColor(r, g, b)
    {
        hoverColor = { r = r, g = g, b = b };
    }
}

function destroy(el)
{
    foreach(i, val in UI_Elements) {
        if (el == val) {
            UI_Elements.remove(i);
            el.enable(false);
            el.reset();
            break;
        }
    }

    foreach(i, val in activeElements) {
        if (el == val) {
            activeElements.remove(i);
            break;
        }
    }
}