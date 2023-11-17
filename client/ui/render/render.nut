local lastTime = getTickCount();

function onRender() {
    local currentTime = getTickCount();
    if (currentTime - lastTime < 50) return;
    lastTime = currentTime;

    local cursor = getCursorPosition();

    foreach (el in UI_Elements) {
        local isInSquare = inSquare(cursor, el.pos, el.size);
        local isActive = el.isEnabled() && isInSquare;

        if (isInSquare) {
            if (isActive) {
                if (el.left_clicked) el.activate(true);
                el.hover();

                if (!arrayContains(activeElements, el)) {
                    activeElements.append(el);
                }
            }
        }
    }

    foreach (el in activeElements) {
        local isInSquare = inSquare(cursor, el.pos, el.size);
        if (el.element_type == ElementType.TEXTBOX && el.active) {
                el.updateValue();
                continue;
        }

        if (!isInSquare) {
            el.activate(false);
            el.unhover();
            activeElements.remove(activeElements.find(el));
        }
    }
}

addEventHandler("onRender", onRender);