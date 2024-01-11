function handleChatMessage(pid, nickname, message)
{
    if (message == "") return;

    local prefix = message.slice(0, 1);

    switch(prefix)
    {
        case "!":
            sendCryMessage(nickname, message);
        break;

        case "@":
            sendOOCMessage(nickname, message);
        break;

        case "#":
            sendEnvMessage(nickname, message);
        break;

        case "/":
            local args = split(message, " ");
            local cmd = args.remove(0);
            onCommand(pid, cmd, args);
        break;

        default:
            sendChatMessage(nickname + ": ", message);
        break;
    }
}

function sendCryMessage(nickname, message)
{
    local msg = message.slice(1, message.len());

    foreach(player in getPlayers())
    {
        if (player.logged)
        {
            sendPlayerPacket(player.id, PacketType.CHAT_CRY, 255, 170, 20, nickname, msg);
        }
    }
}

function sendOOCMessage(nickname, message)
{
    local msg = message.slice(1, message.len());

    foreach(player in getPlayers())
    {
        if (player.logged)
        {
            sendPlayerPacket(player.id, PacketType.CHAT_OOC, 100, 100, 250, nickname, msg);
        }
    }
}

function sendEnvMessage(nickname, message, r = 25, g = 250, b = 50)
{
    foreach(player in getPlayers())
    {
        if (player.logged)
        {
            sendClearMessage(player.id, "#" + nickname + " " + message.slice(1, message.len()) + "#", 170, 255, 20);
        }
    }
}

function sendChatMessage(nickname, message, r = 255, g = 255, b = 220)
{
    foreach(player in getPlayers())
    {
        if (player.logged)
        {
            sendMessage(player.id, r, g, b, nickname, message)
        }
    }
}

function sendMessage(pid, r, g, b, nickname, text)
{
    if (text == "") return;

    sendPlayerPacket(pid, PacketType.CHAT_MESSAGE, r, g, b, nickname, text);
}

function sendClearMessage(pid, text, r = 255, g = 255, b = 255)
{
    if (text == "") return;

    sendPlayerPacket(pid, PacketType.CHAT_CLEAR_MESSAGE, r, g, b, text);
}

