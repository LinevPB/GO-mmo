local players = [];
class PlayerStructure
{
    constructor(playerid)
    {
        id = playerid;
        logged = false;
        nickname = "";
    }

    function setNickname(nick)
    {
        nickname = nick;
    }

    function setStatus(val)
    {
        logged = val;
    }


    id = -1;
    logged = false;
    nickname = null;
}

function findPlayer(pid)
{
    foreach(v in players) {
        if (v.id == pid)
        return v;
    }
    return -1;
}

function logIn(username, password)
{
    local result = mysql.query("SELECT password FROM players WHERE username='" + username + "'");

    if(!result) return false;
    if (result[0] == md5Hash(password)) return true;

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
    if (result && logIn(username, password))
        return 1;

    return -3;
}

function onInit()
{
    mysql.init();
}
addEventHandler("onInit", onInit);

function onPacket(pid, packet)
{
    local packetType = packet.readInt8();
    local data = packet.readString();
    local decoded = decode(data);

    switch(packetType) {
        case PacketType.LOGIN:
            // GAME
            local newPlayer = PlayerStructure(pid);
            local result = logIn(decoded[0], decoded[1]);
            if (!result) {
                console.log("Player " + decoded[0] + " failed to log in.");
                sendPlayerPacket(pid, PacketType.LOGIN, 0);
                return false;
            }

            console.log("Player " + decoded[0] + " logged in.");
            newPlayer.setNickname(decoded[0]);
            newPlayer.setStatus(true);
            players.append(newPlayer);

            sendPlayerPacket(pid, PacketType.LOGIN, 1);
        break;

        case PacketType.REGISTER:
            local newPlayer = PlayerStructure(pid);
            local result = signUp(decoded[0], decoded[1], decoded[2]);

            switch(result) {
                case 1:
                    newPlayer.setNickname(decoded[0]);
                    newPlayer.setStatus(true);
                    players.append(newPlayer);

                    console.log("Player " + decoded[0] + " signed up.");
                    sendPlayerPacket(pid, PacketType.REGISTER, 1);
                    break;
                case -1:
                    console.warn("Account " + decoded[0] + " already exists.");
                    sendPlayerPacket(pid, PacketType.REGISTER, 0);
                    break;

                case -2:
                    console.warn("Passwords for " + decoded[0] + " are not the same.");
                    sendPlayerPacket(pid, PacketType.REGISTER, -1);
                    break;

                case -3:
                    console.warn("Unknow error for " + decoded[0] + " account.");
                    sendPlayerPacket(pid, PacketType.REGISTER, -2);
                    break;
            }

        break;

        case PacketType.CHAT_MESSAGE:
            local locPlayer = findPlayer(pid);
            if(!locPlayer) return;

            local nickname = locPlayer.nickname;

            foreach(player in players) {
                if (player.logged) {
                    sendPlayerPacket(player.id, PacketType.CHAT_MESSAGE, 25, 250, 50, player.nickname + ": ", decoded[0]);
                }
            }

            console.log(nickname + ": " + decoded[0]);
        break;
    }
}

addEventHandler("onPacket", onPacket);