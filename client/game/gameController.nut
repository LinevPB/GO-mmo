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
            if (decoded[0].value == "true") {
                authResult(1);
                ChangeGameState(GameState.PLAY);
            } else {
                authResult(2);
            }
            break;

        case PacketType.REGISTER:
            if (decoded[0].value == "true") {
                authResult(3);
                ChangeGameState(GameState.PLAY);
            } else {
                authResult(4);
            }
            break;
    }
}

addEventHandler("onPacket", onPacket);