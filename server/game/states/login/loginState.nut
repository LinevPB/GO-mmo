function logIn(username, password)
{
    if (username == "" || password == "") return false;

    local result = mysql.gquery("SELECT password, id FROM players WHERE username='" + username + "'");
    if(!result) return false;
    if (result[0] == null) return false;
    if (result[0][0] == md5Hash(password)) return result[0][1].tointeger();

    return false;
}

function signUp(username, password, cpassword)
{
    if (username == "" || password == "" || cpassword == "") return -2;
    if (password != cpassword) return -1;
    if (username.len() > 30 || username.len() < 3) return -2;
    if (password.len() > 50 || password.len() < 3) return -2;

    username = filter_sql(username);
    password = filter_sql(password);

    local result = mysql.gquery("SELECT id FROM players WHERE username='" + username + "'");
    if (result[0] != null) return 0;
    result = 0;

    local hashedPass = md5Hash(password);
    result = mysql.squery(
        "INSERT INTO `players` (`id`, `username`, `password`) VALUES (NULL, '" +
        username + "', '" +
        hashedPass + "');"
    );

    local login = logIn(username, password);
    if (result && login) return login;

    return -3;
}

function loginSuccessful(pid, nickname, msg, id)
{
    local newPlayer = PlayerStructure(pid);
    newPlayer.setNickname(nickname);
    newPlayer.setStatus(true);
    newPlayer.dbId = id;
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
    local uid = getPlayerUID(pid);
    local result = mysql.gquery("SELECT banned FROM unique_ids WHERE uid='" + uid + "'");
    if (result[0] == null)
    {
        nickname = filter_sql(nickname);
        result = mysql.squery(
            "INSERT INTO `unique_ids` (`uid`, `remember`, `remember_name`, `banned`) VALUES ('" + uid + "', '" +
            false + "', '" +
            nickname + "', '" +
            false + "');"
        );
    }

    console.log(msg);
}

function registerFailed(pid, errId, errMsg = false)
{
    if(errMsg != false) console.warn(errMsg);
    sendPlayerPacket(pid, PacketType.REGISTER, errId);
}
