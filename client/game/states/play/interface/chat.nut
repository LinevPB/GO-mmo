local Span = 25;
local ifY = Span;
local drawHeight = 0;

class ChatLineDraw
{
    draw = null;
    text = null;
    position = null;
    color = null;

    constructor(x, y, text, r = 255, g = 255, b = 255)
    {
        draw = Draw(x, y, text);
        draw.setColor(r, g, b);
        draw.visible = false;
        position = {x = x, y = y};
        color = { r = r, g = g, b = b };
        this.text = text;
    }

    function move(x, y) {
        position.x += x;
        position.y += y;
        draw.setPosition(position.x, position.y);
    }

    function alpha(r)
    {
        draw.alpha = r;
    }

    function enable(val)
    {
        draw.visible = true;
    }
}

class ChatLine
{
    draws = null;
    position = null;
    desiredY = 0;

    constructor(y, ...)
    {
        draws = [];
        position = { x = Span, y = y };
        local lineWidth = position.x;
        desiredY = ifY;

        if (!vargv[0])
            vargv = vargv[1];

        foreach(i, v in vargv) {
            local draw = 0;
            if (typeof v == "array") {
                draw = ChatLineDraw(lineWidth, position.y, v[3], v[0], v[1], v[2]);
            } else {
                draw = ChatLineDraw(lineWidth, position.y, v);
            }

            draws.append(draw);
            lineWidth += draw.draw.width;
        }
    }

    function move(x, y)
    {
        position.x += x;
        position.y += y;

        foreach(v in draws) {
            v.move(x, y);
        }
    }

    function alpha(r) {
        if (r > 255) r = 255;
        if (r <= 0) r = 0;

        foreach(v in draws)
            v.alpha(r);
    }

    function enable(val)
    {
        foreach(v in draws)
            v.enable(val);
    }
}

Chat <- {}
Chat.Lines <- [];
Chat.MaxLines <- 12;
Chat.LineSpace <- 50;
local chatVisible = false;
local totalSpace = 0;

function initChat()
{
    local temp = Draw(0, 0, "AAAAAAA VVVVV XXXXXX");
    temp.visible = false;
    drawHeight = temp.height;
    totalSpace = drawHeight + Chat.LineSpace;

    for(local i = 0; i < Chat.MaxLines - 1; i++) {
        local chatLine = ChatLine(ifY, [255, 255, 0, "Player : "], "Hello :) " + i);
        Chat.Lines.append(chatLine);
        ifY += totalSpace;
    }
}

function enableChat(val)
{
    foreach(v in Chat.Lines) {
        v.enable(val);
    }
}

function addChatLine(...)
{
    local chatLine = ChatLine(Chat.Lines[Chat.Lines.len() - 1].position.y + totalSpace, false, vargv);
    Chat.Lines.append(chatLine);
    chatLine.enable(chatVisible);
    chatLine.alpha(0);

    foreach(v in Chat.Lines)
        v.desiredY -= totalSpace;
}

local lastTime = getTickCount();
function onRenderChat() {
    local currentTime = getTickCount();
    if (currentTime - lastTime < 20) return;
    lastTime = currentTime;

        foreach(i, v in Chat.Lines) {
            if (v.position.y == v.desiredY)
                continue;

            v.move(0, -10);
            if (v.position.y <= v.desiredY) {
                v.move(0, v.desiredY - v.position.y);
            }

            if (v.position.y <= Span) {
                local calcAlpha = 255 - (Span - (v.position.y)*1.5);
                v.alpha(calcAlpha);
                if (calcAlpha <= 0) {
                    Chat.Lines.remove(i);
                }
            }
            else if (v.position.y + totalSpace >= ifY) {
                local calcAlpha = ifY - v.position.y;
                v.alpha(calcAlpha);
            } else {
                v.alpha(255);
            }
        }
}



addEventHandler("onRender", onRenderChat);

function ra() {
    return rand() % 256;
}

function onKey(key)
{
    if (key == KEY_X) {
        chatVisible = !chatVisible;
        enableChat(chatVisible);
    }

    if (key == KEY_T && !chatInputIsOpen()) {
        chatInputSetPosition(Span, ifY + Span);
        chatInputOpen();
    }

    if (key ==  KEY_Z) {
        addChatLine([ra(), ra(), ra(), "N"],
        [ra(), ra(), ra(), "e"],
        [ra(), ra(), ra(), "v"],
        [ra(), ra(), ra(), "e"],
        [ra(), ra(), ra(), "r"],
        [ra(), ra(), ra(), " "],
        [ra(), ra(), ra(), "g"],
        [ra(), ra(), ra(), "o"],
        [ra(), ra(), ra(), "n"],
        [ra(), ra(), ra(), "n"],
        [ra(), ra(), ra(), "a"],
        [ra(), ra(), ra(), " "],
        [ra(), ra(), ra(), "g"],
        [ra(), ra(), ra(), "i"],
        [ra(), ra(), ra(), "v"],
        [ra(), ra(), ra(), "e"],
        [ra(), ra(), ra(), " "],
        [ra(), ra(), ra(), "y"],
        [ra(), ra(), ra(), "o"],
        [ra(), ra(), ra(), "u"],
        [ra(), ra(), ra(), " "],
        [ra(), ra(), ra(), "u"],
        [ra(), ra(), ra(), "p"]);
    }

    if (key == KEY_RETURN && chatInputIsOpen()) {
        local text = chatInputGetText();
        addChatLine([25, 255, 50, "Player : "], text);
        chatInputSend();
        chatInputClose();
    }

    if (key == KEY_ESCAPE && chatInputIsOpen()) {
        chatInputClose();
    }
}

addEventHandler("onKey", onKey);