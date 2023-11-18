function logIn(username, password)
{
    if (username == "" || password == "") return false;
    local result = mysql.query("SELECT password FROM players WHERE username='" + username + "'");

    if(!result) return false;
    if (result[0] == md5Hash(password)) return true;

    return false;
}

function signUp(username, password, cpassword)
{
    if (username == "" || password == "" || cpassword == "") return -2;
    if (password != cpassword) return -1;

    local result = mysql.query("SELECT id FROM players WHERE username='" + username + "'");
    if (result) return 0;
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

function loginSuccessful(pid, nickname, msg)
{
    local newPlayer = PlayerStructure(pid);
    newPlayer.setNickname(nickname);
    newPlayer.setStatus(true);
    addPlayer(newPlayer);

    console.log(msg);
    sendPlayerPacket(pid, PacketType.LOGIN, 1);
}

function loginFailed(pid, msg = false)
{
    if(msg) console.log(msg);
    sendPlayerPacket(pid, PacketType.LOGIN, 0);
}

function registerSuccessful(pid, nickname, msg)
{
    local newPlayer = PlayerStructure(pid);
    newPlayer.setNickname(nickname);
    newPlayer.setStatus(true);
    addPlayer(newPlayer);

    console.log(msg);
    sendPlayerPacket(pid, PacketType.REGISTER, 1);
}

function registerFailed(pid, errId, errMsg = false)
{
    if(errMsg) console.warn(errMsg);
    sendPlayerPacket(pid, PacketType.REGISTER, errId);
}
