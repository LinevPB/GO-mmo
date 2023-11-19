function ResetState()
{
    switch(Player.gameState) {
        case GameState.LOGIN: deinitLoginState(); break;
        case GameState.CHARACTER_SELECTION: deinitCharacterSelection(); break;
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

        case GameState.CHARACTER_SELECTION:
            Player.gameState = GameState.CHARACTER_SELECTION;
            initCharacterSelection();
            break;

        case GameState.CHARACTER_CREATION:
            Player.gameState = GameState.CHARACTER_CREATION;
            initCharacterCreation();
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
                    ChangeGameState(GameState.CHARACTER_SELECTION);
                    break;
                default: authResult(2); break;
            }
        break;

        case PacketType.REGISTER:
            switch(data[0]) {
                case 1:
                    authResult(3);
                    ChangeGameState(GameState.CHARACTER_SELECTION);
                    break;
                case 0: authResult(4); break;
                case -1: authResult(5); break;
                case -2: authResult(6); break;
                default: authResult(7); break;
            }
        break;

        case PacketType.CHARACTERS_RECEIVE:
            loadCharacter(data[0], data[1], data[2], data[3]);
        break;

        case PacketType.CHARACTERS_FINISHED:
            if(data[0] == 1) {
                moveCameraToNPC();
                ChangeGameState(GameState.CHARACTER_CREATION);
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

function onPressButton(id)
{
    switch(Player.gameState) {
        case GameState.LOGIN: loginButtonHandler(id); break;
        case GameState.CHARACTER_SELECTION: characterButtonHandler(id); break;
        case GameState.CHARACTER_CREATION: creationButtonHandler(id); break;
    }
}

function onPressTextbox(id)
{

}

function onPressListElement(element)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_SELECTION: characterListHandler(element); break;
        case GameState.CHARACTER_CREATION: creationListHandler(element); break;
    }
}

local function onRenderH()
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onRenderC(); break;
    }
}
addEventHandler("onRender", onRenderH);

local function onClickH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onClickC(key); break;
    }
}
addEventHandler("onMouseClick", onClickH);

local function onReleaseH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onReleaseC(key); break;
    }
}
addEventHandler("onMouseRelease", onReleaseH);