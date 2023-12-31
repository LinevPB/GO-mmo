local lastTime = getTickCount();

function onRender() {
    local currentTime = getTickCount();
    if (currentTime - lastTime < 50) return;
    lastTime = currentTime;

    local cursor = getCursorPosition();

    foreach (el in UI_Elements) {
        if (!el.isEnabled()) continue;

        local isInSquare = inSquare(cursor, el.pos, el.size);
        if (isInSquare && !el.isHovered())
        {
            if (el.elementType == ElementType.BUTTON)
            {
                if (el.hasParent())
                {
                    if (!el.parent.frozen)
                    {
                        el.hover();
                    }
                }
                else
                {
                    el.hover();
                }
            }
            else
            {
                el.hover();
            }
        }
        else if(!isInSquare && el.isHovered())
        {
            el.unhover();
        }
        else if (isInSquare && el.isHovered())
        {
            onElementRender(el);
        }

        if (el.elementType == ElementType.SLIDER_MASK && el.leftClicked)
        {
            el.update();
            onSlide(el.parent);
        }
    }

    foreach(el in activeElements)
    {
        if (el.elementType == ElementType.TEXTBOX)
        {
            el.updateValue();
        }
    }
}

addEventHandler("onRender", onRender);