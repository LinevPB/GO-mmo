class PlayerStructure
{
    constructor(playerid)
    {
        id = playerid;
        logged = false;
    }

    function logIn(username, password)
    {
        local result = mysql.query("SELECT password FROM players WHERE username='" + username + "'");

        if(!result)
            return false;

        if (result[0] == md5Hash(password)) {
            logged = true;
            return true;
        }

        return false;
    }

    function signUp(username, password, cpassword)
    {
        local result = mysql.query("SELECT id FROM players WHERE username='" + username + "'");
        if (result) return -1;
        if (password != cpassword) return -2;
        result = 0;

        local hashedPass = md5Hash(password);
        result = mysql.squery(
            "INSERT INTO `players` (`id`, `username`, `password`) VALUES (NULL, '" +
            username + "', '" +
            hashedPass + "');"
        );
        if (result && logIn(username, password)) return 1;

        return -3;
    }

    id = -1;
    logged = false;
}

local players = [];

function onInit()
{
    // DEFAULT
    mysql.init();
}

addEventHandler("onInit", onInit);

function onPacket(pid, packet)
{
    local packetType = packet.readInt8();
    local data = packet.readString();
    local decoded = decode(data);

    local newPlayer = PlayerStructure(pid);

    switch(packetType) {
        case PacketType.LOGIN:
            // GAME
            local result = newPlayer.logIn(decoded[0].value, decoded[1].value);
            if (!result) {
                console.log("Player " + decoded[0].value + " failed to log in.");
                sendPlayerPacket(pid, PacketType.LOGIN, [newPlayer.logged]);
                return false;
            }

            console.log("Player " + decoded[0].value + " logged in.");
            players.append(newPlayer);

            sendPlayerPacket(pid, PacketType.LOGIN, [newPlayer.logged]);
        break;

        case PacketType.REGISTER:
            local result = newPlayer.signUp(decoded[0].value, decoded[1].value, decoded[2].value);

            switch(result) {
                case 1:
                    console.log("Player " + decoded[0].value + " signed up.");
                    break;
                case -1:
                    console.warn("Account " + decoded[0].value + " already exists.");
                    break;

                case -2:
                    console.warn("Passwords for " + decoded[0].value + " are not the same.");
                    break;

                case -3:
                    console.warn("Unknow error for " + decoded[0].value + " account.");
                    break;
            }
            sendPlayerPacket(pid, PacketType.REGISTER, [newPlayer.logged]);
        break;
    }
}

addEventHandler("onPacket", onPacket);