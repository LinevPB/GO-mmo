class Textbox extends Element {
    hashed = null;
    value = "";
    active = false;
    placeholder = "";
    span = 100;

    constructor(x, y, width, height, texture, placeholderTitle = "", hoverTexture = "DLG_CONVERSATION.TGA", hash = false) {
        if (hoverTexture == null) {
            hoverTexture = "DLG_CONVERSATION.TGA";
        }

        base.constructor(x, y, width, height, texture, placeholderTitle, hoverTexture);
        element_type = ElementType.TEXTBOX;
        UI_Elements.append(this);
        hashed = hash;
        placeholder = placeholderTitle;
    }

    function reset()
    {
        base.reset();
        hashed = null;
        value = "";
        active = false;
        placeholder = "";
        span = 100;
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        draw.setPosition(span + pos.x, pos.y + size.height / 2 - draw.height / 2);
    }

    function enable(val) {
        base.enable(val);
        if (!val) {
            value = "";
        }

        if (val && value == "") {
            draw.text = placeholder;
        }

        draw.alpha = (draw.text == placeholder) ? 150 : 255;
    }

    function updateValue(slash = "|") {
        if (chatInputIsOpen()) {
            if (value == chatInputGetText() && slash) {
                if (value == "") draw.text = slash;
                return;
            };

            value = chatInputGetText();
            local tempText = hashed ? repeatString("#", value.len()) : value;

            if (slash) {
                tempText += slash;
            }

            draw.text = tempText;
            local i = 0;
            while (draw.width + span * 2 > size.width) {
                i++;
                draw.text = tempText.slice(i, tempText.len());
            }
        }
    }

    function open() {
        chatInputOpen();
        chatInputSetPosition(8200, 8200);
        local temp = value;
        updateValue();
        chatInputSetText(temp);
        active = true;
        draw.alpha = 255;
    }

    function close() {
        updateValue(false);
        chatInputClear();
        chatInputClose();
        active = false;
        draw.alpha = 150;
    }

    function getValue() {
        return value;
    }
}
