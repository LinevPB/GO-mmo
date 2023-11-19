function ChangeGameState(pid, state)
{
    switch(state) {
        case GameState.LOGIN:
            findPlayer(pid).gameState = GameState.LOGIN;
            break;

        case GameState.PLAY:
            findPlayer(pid).gameState = GameState.PLAY;
            break;
    }
}

local function onConnect(pid)
{
    ChangeGameState(pid, GameState.LOGIN);
}
addEventHandler("onConnect", onConnect);

function loginHandler(pid, data)
{
    local result = logIn(data[0], data[1]);
    if (!result)
        return loginFailed(pid, "Player " + data[0] + " failed to log in.");

    loginSuccessful(pid, data[0], "Player " + data[0] + " logged in.", result);
    ChangeGameState(pid, GameState.PLAY);
}

function registerHandler(pid, data)
{
    local result = signUp(data[0], data[1], data[2]);
    switch(result) {
        case 0:
            registerFailed(pid, 0, "Account " + data[0] + " already exists.");
            break;

        case -1:
            registerFailed(pid, -1, "Passwords for " + data[0] + " are not the same.");
            break;

        case -2:
            registerFailed(pid, -2);
            break;

        case -3:
            registerFailed(pid, -3, "Unknow error for " + data[0] + " account.");
            break;

        default:
            registerSuccessful(pid, data[0], "Player " + data[0] + " signed up.", result);
            ChangeGameState(pid, GameState.PLAY);
            break;
    }
}

function messageHandler(pid, data)
{
    local sid = data[0];
    local message = data[1];
    local nickname = findPlayer(sid).nickname;

    foreach(player in getPlayers()) {
        if (player.logged) {
            sendMessage(player.id, 25, 250, 50, nickname, message)
        }
    }

    console.log(nickname + ": " + message);
}

function charactersHandler(pid, data)
{
    local temp = findPlayer(pid);
    if (temp.logged) {
        local result = mysql.gquery("SELECT id, pid, name FROM characters WHERE pid='" + temp.dbId + "'");
        if (result[0] != null) {
            foreach(i, v in result) {
                if (v[1].tointeger() != temp.dbId) continue;
                sendPlayerPacket(pid, PacketType.CHARACTERS_RECEIVE, i, v[0], v[1], v[2]);
            }
        }

        sendPlayerPacket(pid, PacketType.CHARACTERS_FINISHED, 1);
    }
}

local function onPacket(pid, packet)
{
    local packetType = packet.readInt8();
    local data = decode(packet.readString());

    switch(packetType) {
        case PacketType.LOGIN:
            loginHandler(pid, data);
        break;

        case PacketType.REGISTER:
            registerHandler(pid, data);
        break;

        case PacketType.CHAT_MESSAGE:
            messageHandler(pid, data);
        break;

        case PacketType.CHARACTERS_QUERY:
            charactersHandler(pid, data);
        break;
    }
}
addEventHandler("onPacket", onPacket);