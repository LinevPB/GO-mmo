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

    constructor(x, y, width, height, texture, title, hover_texture = "NONE") {
        id = element_id;
        element_id++;

        pos = { x = x, y = y };
        size = { width = width, height = height };

        if (texture) {
            background = {
                regular = texture,
                hover = hover_texture,
                texture = Texture(x, y, width, height, texture)
            }
            background.texture.visible = false;
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
        hovered = true;
        if (background.hover != "NONE" && !disableBackground) setBackground(background.hover);
    }

    function unhover() {
        hovered = false;
        if (background != null && !disableBackground) setBackground(background.regular);
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