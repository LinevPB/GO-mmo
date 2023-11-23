function onClick(button) {
    if (button == MOUSE_BUTTONLEFT) {
        local cursor = getCursorPosition();

        foreach (el in UI_Elements) {
            if (el.elementType == ElementType.TEXTBOX && el.active) {
                el.close();
                continue;
            }

            if (inSquare(cursor, el.pos, el.size) && el.isEnabled()) {
                if (el.elementType == ElementType.SLIDER_MASK) {
                    if (!el.parent.vertical) {
                        el.offsetX = cursor.x - el.maskX;
                        el.lastX = el.maskX;
                    } else {
                        el.offsetY = cursor.y - el.maskY;
                        el.lastY = el.maskY;
                    }
                }
                el.leftClicked = true;
                handleElementPress(el);
            }
        }
    }
}
addEventHandler("onMouseClick", onClick)

function onRelease(button) {
    if (button == MOUSE_BUTTONLEFT) {
        local cursor = getCursorPosition();

        foreach (el in UI_Elements) {
            if (el.leftClicked) {
                el.leftClicked = false;

                if (el.isEnabled()) {
                    if (el.elementType == ElementType.BUTTON) {
                        if (el.outer_release) {
                            handleElementClick(el);
                        } else {
                            if (inSquare(cursor, el.pos, el.size)) {
                                handleElementClick(el);
                            }
                        }
                    } else {
                        if (inSquare(cursor, el.pos, el.size)) {
                            handleElementClick(el);
                        }
                    }
                }
            }
        }
    }
}
addEventHandler("onMouseRelease", onRelease);

function handleElementClick(el) {
    switch (el.elementType) {
        case ElementType.BUTTON:
            onPressButton(el.id);
            break;

        case ElementType.TEXTBOX:
            el.open();
            onPressTextbox(el.id);
            break;

        case ElementType.LIST_ELEMENT:
            el.parent.select(el.id);
            onPressListElement(el);
            break;

        case ElementType.SLIDER_MASK:
            //onSlide(el);
            break;
    }
}

function handleElementPress(el) {
    switch (el.elementType) {
        case ElementType.BUTTON:
            onClickButton(el.id);
            break;
    }
}
