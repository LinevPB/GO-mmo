enum PacketType {
    LOGIN = 0,
    REGISTER = 1
}

function encode(args) {
    local result = "";

    foreach (val in args) {
        local typeIdentifier = "";
        local valueStr = val.tostring();

        switch (typeof val) {
            case "string": typeIdentifier = "s"; break;
            case "integer": typeIdentifier = "i"; break;
            case "float": typeIdentifier = "f"; break;
            case "bool": typeIdentifier = "b"; break;
            default: break;
        }

        result += format("%s%d:%s:", typeIdentifier, valueStr.len(), valueStr);
    }

    // Remove the trailing colon
    if (result.len() > 0) {
        result = result.slice(0, result.len() - 1);
    }

    return result;
}

function decode(encodedString) {
    local result = [];
    local currentIndex = 0;

    while (currentIndex < encodedString.len() - 1) {
        local vartype = encodedString[currentIndex].tochar();
        currentIndex += 1; // Skip the type and the following ':'

        local colonIndex = encodedString.find(":", currentIndex);
        if (colonIndex != null) {
            local varlength = encodedString.slice(currentIndex, colonIndex).tointeger();
            currentIndex = colonIndex + 1;
            local varvalue = encodedString.slice(currentIndex, currentIndex + varlength);
            currentIndex += varlength + 1;

            result.append({
                type = vartype,
                value = varvalue
            });
        }
    }

    return result;
}

function sendPacket(packetType, args)
{
    local packet = Packet();
    packet.writeInt8(packetType);
    packet.writeString(encode(args));
    packet.send(RELIABLE_ORDERED);
}

function sendPlayerPacket(pid, packetType, args)
{
    local packet = Packet();
    packet.writeInt8(packetType);
    packet.writeString(encode(args));
    packet.send(pid, RELIABLE_ORDERED);
}