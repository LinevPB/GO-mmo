UI_Elements <- [];
activeElements <- [];
local element_id = 0;

enum ElementType {
    WINDOW,
    BUTTON,
    TEXTBOX
}

class Element {
    id = null;
    pos = null;
    size = null;
    background = null;
    enabled = null;
    draw = null;
    left_clicked = null;
    element_type = null;
    regular_color = null;
    active_color = null;
    letterWidth = null;

    constructor(x, y, width, height, texture, title, hover_texture) {
        id = element_id;
        element_id++;

        pos = { x = x, y = y };
        size = { width = width, height = height };

        background = {
            regular = texture,
            hover = hover_texture,
            texture = Texture(x, y, width, height, texture)
        }
        background.texture.visible = false;

        draw = Draw(x, y, "Ab# sVt uIo PE# ### ### ###");
        letterWidth = draw.width / 27;
        draw.text = title;
        draw.visible = false;

        enabled = false;
        left_clicked = false;

        regular_color = { r = 255, g = 255, b = 255 };
        active_color = { r = 230, g = 215, b = 207 };
    }

    function reset() {
        id = null;
        pos = null;
        size = null;
        background = null;
        enabled = null;
        draw = null;
        left_clicked = null;
        element_type = null;
        regular_color = null;
        active_color = null;
        letterWidth = null;
    }

    function activate(val) {
        if (val == true) {
            draw.setColor(active_color.r, active_color.g, active_color.b);
            return;
        }

        draw.setColor(regular_color.r, regular_color.g, regular_color.b);
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
        background.texture.setPosition(pos.x, pos.y);
    }

    function setBackground(texture) {
        background.texture.file = texture;
    }

    function enable(value) {
        if (value == true) {
            background.texture.visible = true;
            draw.visible = true;
            enabled = true;
            return;
        }

        enabled = false;
        draw.visible = false;
        background.texture.visible = false;
    }

    function hover() {
        if (background.hover != "NONE") setBackground(background.hover);
    }

    function unhover() {
        setBackground(background.regular);
    }

    function isEnabled() {
        return enabled;
    }
}

function destroy(el)
{
    foreach(i, val in UI_Elements) {
        if (el == val) {
            UI_Elements.remove(i);
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