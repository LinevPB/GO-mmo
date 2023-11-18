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

local function onPacket(packet) {
    local packetType = packet.readInt8();
    local data = decode(packet.readString());

    switch(packetType) {
        case PacketType.LOGIN:
            switch(data[0]) {
                case 1:
                    authResult(1);
                    ChangeGameState(GameState.PLAY);
                    break;
                default: authResult(2); break;
            }
        break;

        case PacketType.REGISTER:
            switch(data[0]) {
                case 1:
                    authResult(3);
                    ChangeGameState(GameState.PLAY);
                    break;
                case 0: authResult(4); break;
                case -1: authResult(5); break;
                case -2: authResult(6); break;
                default: authResult(7); break;
            }
        break;
    }
}
addEventHandler("onPacket", onPacket);

local function onKey(key)
{
    if (Player.gameState == GameState.PLAY) {
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
}
addEventHandler("onKey", onKey);