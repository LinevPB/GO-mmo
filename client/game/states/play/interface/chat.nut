Chat <- {
    Lines = [],
    MaxLines = 12,
    LineSpace = 50,
    Visible = false
};

local Span = 25;
local ifY = Span;
local drawHeight = 0;
local totalSpace = 0;
local inputOpened = false;

class ChatLineDraw
{
    draw = null;
    position = null;
    color = null;
    text = null;

    constructor(x, y, val, r = 255, g = 255, b = 255)
    {
        draw = Draw(x, y, val);
        position = {x = x, y = y};
        color = { r = r, g = g, b = b };
        text = val;

        draw.setColor(r, g, b);
        draw.visible = false;
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
        draw.visible = val;
    }
}

class ChatLine
{
    draws = null;
    position = null;
    desiredY = null;

    constructor(y, ...)
    {
        draws = [];
        position = { x = Span, y = y };
        desiredY = ifY;

        local lineWidth = position.x;

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

local function addChatLine(...)
{
    local chatLine = ChatLine(Chat.Lines[Chat.Lines.len() - 1].position.y + totalSpace, false, vargv);
    chatLine.enable(Chat.Visible);
    chatLine.alpha(0);
    Chat.Lines.append(chatLine);

    foreach(v in Chat.Lines)
        v.desiredY -= totalSpace;
}

function chatRender()
{
    print(Chat.Visible);
    foreach(i, v in Chat.Lines)
    {
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

Chat.Init <- function()
{
    local temp = Draw(0, 0, "AAAAAAA VVVVV XXXXXX");
    temp.visible = false;
    drawHeight = temp.height;
    totalSpace = drawHeight + Chat.LineSpace;

    for(local i = 0; i < Chat.MaxLines - 1; i++) {
        local chatLine = ChatLine(ifY, " ");
        Chat.Lines.append(chatLine);
        ifY += totalSpace;
    }
}

Chat.Enable <- function(val)
{
    foreach(v in Chat.Lines)
    {
        v.enable(val);
    }

    Chat.Visible = val;
}

Chat.EnableInput <- function(val)
{
    inputOpened = val;

    if (val && !chatInputIsOpen()) {
        chatInputSetPosition(Span, ifY + Span);
        chatInputOpen();
        return;
    }

    if (!val && chatInputIsOpen())
        chatInputClose();
}

Chat.Send <- function()
{
    if (!inputOpened) return;
    if (!chatInputIsOpen()) return;

    local text = chatInputGetText();
    sendPacket(PacketType.CHAT_MESSAGE, heroId, text);

    chatInputSend();
    Chat.EnableInput(false);
}

Chat.Add <- addChatLine;

Chat.IsEnabled <- function()
{
    return Chat.Visible;
}