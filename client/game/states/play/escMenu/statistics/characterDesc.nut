local width = 2000;
local height = 3000;

local textAreaOpened = false;
local textAreaHold = null;


class TextAreaButton
{
    tex = null;
    draw = null;
    enabled = null;
    active = null;

    constructor(x, y, width, height, text)
    {
        tex = Texture(x, y, width, height, "BUTTON_BACKGROUND.TGA");
        tex.setColor(220, 0, 0);

        draw = Draw(0, 0, text);
        draw.setPosition(x + width / 2 - draw.width / 2, y + height / 2 - draw.height / 2);
        draw.setColor(255, 220, 220);

        setActive(true);

        enabled = false;
    }

    function enable(val)
    {
        tex.visible = val;
        draw.visible = val;
    }

    function setActive(val)
    {
        if (active == val) return;

        tex.alpha = (val ? 255 : 125);
        draw.alpha = (val ? 255 : 125);

        active = val;
    }

    function isEnabled()
    {
        return enabled;
    }

    function isActive()
    {
        return active;
    }

    function getPosition()
    {
        return tex.getPosition();
    }

    function getSize()
    {
        return tex.getSize();
    }

    function hover()
    {
        if (!active) return;

        tex.setColor(200, 0, 0);
        draw.setColor(255, 240, 240);
    }

    function unhover()
    {
        if (!active) return;

        tex.setColor(220, 0, 0);
        draw.setColor(255, 220, 220);
    }
}


class TextArea
{
    elEnabled = null;
    tex = null;
    titleTex = null;
    titleDraw = null;
    descTex = null;
    save_btn = null;
    cancel_btn = null;

    descHovered = null;
    descEnabled = null;

    lastInputPos = null;
    draws = null;
    text = null;
    lastText = null;

    constructor()
    {
        tex = Texture(492, height + 1300, width + 1000, 3400, "WINDOW_BACKGROUND.TGA");

        titleDraw = Draw(0, 0, "Character description");
        titleTex = Texture(0, 0, 200, 200, "TEXTBOX_BACKGROUND.TGA");
        updateTitlePosition();

        descTex = Texture(492 + 250, height + 1700, width + 500, 2300, "WINDOW_BACKGROUND_SF.TGA");
        descTex.setColor(210, 210, 210);

        save_btn = TextAreaButton(492 + width / 2 + 325 - 600, height + 4150, 600, 300, "Save");
        cancel_btn = TextAreaButton(492 + width / 2 + 675, height + 4150, 600, 300, "Restore");

        descHovered = false;
        descEnabled = false;

        local tpos = descTex.getPosition();
        local tsize = descTex.getSize();
        draws = DrawsSet(tpos.x + 100, tpos.y, tsize.width - 200, tsize.height);

        text = "";
        lastText = "";

        elEnabled = false;
    }

    function updateTitle(val)
    {
        titleDraw.text = val;
        updateTitlePosition();
    }

    function updateTitlePosition()
    {
        titleTex.setSize(300 + titleDraw.width, 100 + titleDraw.height);
        titleTex.setPosition(492 + width / 2 + 500 - titleTex.getSize().width / 2, height + 1300 - titleTex.getSize().height / 4);
        titleDraw.setPosition(titleTex.getPosition().x + titleTex.getSize().width / 2 - titleDraw.width / 2, titleTex.getPosition().y + titleTex.getSize().height / 2 - titleDraw.height / 2);
    }

    function enable(val)
    {
        tex.visible = val;
        titleTex.visible = val;
        titleDraw.visible = val;
        descTex.visible = val;

        save_btn.enable(val);
        cancel_btn.enable(val);

        draws.enable(val);

        elEnabled = val;
    }

    function isEnabled()
    {
        return elEnabled;;
    }

    function hover(el)
    {
        if (el != descTex)
        {
            el.hover();
            return;
        }

        if (descHovered) return;

        descHovered = true;
        descTex.setColor(190, 190, 190);
    }

    function unhover(el)
    {
        if (el != descTex)
        {
            el.unhover();
            return;
        }

        if (!descHovered) return;

        descHovered = false;

        if (textAreaOpened)
        {
            descTex.setColor(190, 190, 190);
        }
        else
        {
            descTex.setColor(210, 210, 210);
        }
    }

    function enableCloseArea(val)
    {
        setCursorVisible(val);
    }

    function openTextArea()
    {
        textAreaOpened = true;
        textAreaHold = this;

        lastInputPos = chatInputGetPosition();
        chatInputSetPosition(0, 8200);
        lastText = chatInputGetText();
        chatInputSetText(draws.text);
        chatInputOpen();
        setStatCanUseKeys(false);
    }

    function closeTextArea()
    {
        textAreaOpened = false;
        descHovered = true;
        unhover(descTex);
        textAreaHold = null;
        chatInputClose();
        chatInputSetPosition(lastInputPos.x, lastInputPos.y);
        chatInputSetText(lastText);
        setStatCanUseKeys(true);
        draws.removeSlash();
    }

    function updateArea()
    {
        local text = chatInputGetText();
        draws.setText(text);
    }

    function restoreText()
    {
        draws.setText(text);

        if (!textAreaOpened) draws.removeSlash();
    }

    function getText()
    {
        return draws.text;
    }

    function setText(val)
    {
        text = val;
        draws.setText(val);

        if (!textAreaOpened) draws.removeSlash();
    }
}


class DrawsSet
{
    text = null;
    draws = null;
    pos = null;
    size = null;
    isSlash = null;
    limiter = null;
    slashLine = null;

    constructor(x, y, width, height)
    {
        limiter = 200;
        slashLine = 0;
        text = "";
        draws = [];
        pos = { x = x, y = y };
        size = { width = width, height = height };

        local testDraw = Draw(0, 0, "TeSt1234");
        if (limiter < testDraw.height) limiter = testDraw.height;

        local times = (height / limiter).tointeger();
        local rest = height - limiter * times;

        for(local i = 0; i < times; i++)
        {
            draws.append(Draw(x, y + rest / 2 + i * limiter, ""));
        }

        isSlash = false;
    }

    function enable(val)
    {
        foreach(v in draws)
        {
            v.visible = val;
        }
    }

    function setText(val)
    {
        if (text == val)
        {
            if (!isSlash) addSlash();
            return;
        }
        isSlash = false;

        text = val;
        updateDraws();
    }

    function updateDraws()
    {
        local startIndex = 0;

        foreach(i, v in draws)
        {
            v.text = "";

            for(startIndex; startIndex < text.len(); startIndex++)
            {
                v.text += text.slice(startIndex, startIndex+1);

                if (v.width > size.width)
                {
                    v.text = v.text.slice(0, v.text.len() - 1);
                    break;
                }

                slashLine = i;
            }
        }

        addSlash();
    }

    function addSlash()
    {
        if (isSlash) return;

        draws[slashLine].text += "|";
        isSlash = true;
    }

    function removeSlash()
    {
        if (!isSlash) return;

        local temp = draws[slashLine];
        if (temp.text.slice(temp.text.len() - 1, temp.text.len()) == "|")
        {
            temp.text = temp.text.slice(0, temp.text.len() - 1);
        }
        isSlash = false;
    }
}


function textAreaHoverHandler(el)
{
    if (el.text != el.getText())
    {
        el.save_btn.setActive(true);
        el.cancel_btn.setActive(true);
    }
    else
    {
        el.save_btn.setActive(false);
        el.cancel_btn.setActive(false);
    }

    if (textAreaOpened)
    {
        textAreaHold.updateArea();
    }

    local set = [el.descTex, el.save_btn, el.cancel_btn];

    foreach(v in set)
    {
        if (inSquare(getCursorPosition(), v.getPosition(), v.getSize()))
        {
            el.hover(v);
            continue;
        }

        el.unhover(v);
    }
}

local pressed = -1;

function textAreaPress(el)
{
    if (textAreaOpened)
    {
        textAreaHold.closeTextArea();
    }

    local set = [el.descTex, el.save_btn, el.cancel_btn];
    foreach(i, v in set)
    {
        if (inSquare(getCursorPosition(), v.getPosition(), v.getSize()))
        {
            pressed = i;
            return;
        }
    }
}

function textAreaRelease(el)
{
    if (pressed == -1) return;

    local set = [el.descTex, el.save_btn, el.cancel_btn];
    foreach(i, v in set)
    {
        if (inSquare(getCursorPosition(), v.getPosition(), v.getSize()) && i == pressed)
        {
            onPressTextArea(el, v);
            pressed = -1;
            return;
        }
    }
}

function onPressTextArea(set, el)
{
    switch(el)
    {
        case set.descTex:
            if (el.visible)
            {
                set.openTextArea();
            }
        break;

        case set.save_btn:
            saveDesc();
        break;

        case set.cancel_btn:
            cancelDesc();
        break;
    }
}

function textAreaEsc()
{
    if (!textAreaOpened) return;
    textAreaHold.closeTextArea();
}