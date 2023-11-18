enum GameState {
    UNKNOWN,
    LOGIN,
    CHARACTER,
    PLAY
}

Player <- {
    id = 0,
    gameState = GameState.UNKNOWN
}

function ResetState()
{
    switch(Player.gameState) {
        case GameState.LOGIN: deinitLoginState(); break;
    }

    clearMultiplayerMessages();
    setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
    setFreeze(true);
    Camera.movementEnabled = false;
    disableControls(true);
    Player.gameState = GameState.UNKNOWN;
}

function ChangeGameState(state)
{
    ResetState();

    switch(state) {
        case GameState.LOGIN:
            Player.gameState = GameState.LOGIN;
            initLoginState();
            break;

        case GameState.CHARACTER:
            break;

        case GameState.PLAY:
            Player.gameState = GameState.PLAY;
            initPlayState();
            break;
    }
}

function onPacket(packet) {
    local packetType = packet.readInt8();
    local data = packet.readString();
    local decoded = decode(data);

    switch(packetType) {
        case PacketType.LOGIN:
            if (decoded[0] == 1) {
                authResult(1);
                ChangeGameState(GameState.PLAY);
            } else authResult(2);
            break;

        case PacketType.REGISTER:
            if (decoded[0] == 1) {
                authResult(3);
                ChangeGameState(GameState.PLAY);
            }
            else if (decoded[0] == 0) authResult(4);
            else if (decoded[0] == -1) authResult(5);
            else authResult(6);
            break;

        case PacketType.CHAT_MESSAGE:
            Chat.Add([decoded[0], decoded[1], decoded[2], decoded[3]], decoded[4]);
            break;
    }
}

addEventHandler("onPacket", onPacket);

function onKey(key)
{
    if (key == KEY_T) {
        Chat.EnableInput(true);
    }

    if (key == KEY_RETURN ) {
        Chat.Send();
    }

    if (key == KEY_ESCAPE) {
        Chat.EnableInput(false);
    }
}

addEventHandler("onKey", onKey);