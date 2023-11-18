function sendMessage(pid, r, g, b, nickname, text)
{
    if (text == "") return;

    sendPlayerPacket(pid, PacketType.CHAT_MESSAGE, r, g, b, nickname + ": ", text);
}