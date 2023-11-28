class NumericBox extends Element {
    value = "";
    active = false;
    span = 0;
    originalX = 0;
    originalY = 0;
    range = 0;

    constructor(x, y, width, height, texture, scope, hoverTexture = "DLG_CONVERSATION.TGA") {
        if (hoverTexture == null) {
            hoverTexture = "DLG_CONVERSATION.TGA";
        }

        base.constructor(x, y, width, height, texture, "", hoverTexture);
        elementType = ElementType.NUMERICBOX;
        originalX = x;
        originalY = y;
        range = scope;
        UI_Elements.append(this);
    }

    function reset()
    {
        base.reset();
        value = "";
        active = false;
        span = 0;
    }

    function setPosition(x, y) {
        base.setPosition(x, y);
        draw.setPosition(x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
    }

    function enable(val) {
        base.enable(val);
        if (!val) {
            value = "";
        }

        if (val && value == "") {
            draw.text = range;
        }

        draw.alpha = (draw.text == "") ? 150 : 255;
        setPosition(pos.x, pos.y);
    }

    function updateRaw(text)
    {
        draw.text = text;
        draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
    }

    function updateValue(slash = "|") {
        if (chatInputIsOpen()) {
            if (value == chatInputGetText() && slash) {
                if (value == "") draw.text = slash;
                return;
            };

            value = chatInputGetText();
            local tempText = value;

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
        activeElements.append(this);
    }

    function close() {
        updateValue(false);
        chatInputClear();
        chatInputClose();
        active = false;
        draw.alpha = 150;
        activeElements.remove(activeElements.find(this));
    }

    function getValue() {
        return value;
    }

    function hover() {

    }

    function unhover() {
        //if (!active)
            //base.unhover();
    }
}
