function onClick(button) {
    if (button == MOUSE_BUTTONLEFT) {
        local cursor = getCursorPosition();

        foreach (el in UI_Elements) {
            if (el.element_type == ElementType.TEXTBOX && el.active) {
                el.close();
            }
            if (inSquare(cursor, el.pos, el.size) && el.isEnabled()) {
                el.left_clicked = true;
            }
        }
    }
}

addEventHandler("onMouseClick", onClick)

function onRelease(button) {
    if (button == MOUSE_BUTTONLEFT) {
        local cursor = getCursorPosition();

        foreach (el in UI_Elements) {
            if (el.left_clicked) {
                el.left_clicked = false;

                if (inSquare(cursor, el.pos, el.size) && el.isEnabled()) {
                    handleElementClick(el);
                }
            }
        }
    }
}

addEventHandler("onMouseRelease", onRelease);

function handleElementClick(el) {
    switch (el.element_type) {
        case ElementType.BUTTON:
            onPressButton(el.id);
            break;

        case ElementType.TEXTBOX:
            el.open();
            onPressTextbox(el.id);
            break;
    }
}
