function ResetState()
{
    switch(Player.gameState)
    {
        case GameState.LOGIN: deinitLoginState(); break;
        case GameState.CHARACTER_SELECTION: deinitCharacterSelection(); break;
        case GameState.CHARACTER_CREATION: deinitCharacterCreation(); break;
    }

    clearMultiplayerMessages();
    setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
    setFreeze(true);
    Camera.movementEnabled = false;
    disableControls(true);
    Player.gameState = GameState.UNKNOWN;
    setCursorVisible(false);
}

function ChangeGameState(state)
{
    ResetState();

    switch(state) {
        case GameState.LOGIN:
            Player.music.play();
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
            Player.music.stop();
            Player.music.volume = 1;
            initPlayState();
            break;
    }
}

function onPressButton(id)
{
    switch(Player.gameState) {
        case GameState.LOGIN: loginButtonHandler(id); break;
        case GameState.CHARACTER_SELECTION: characterButtonHandler(id); break;
        case GameState.CHARACTER_CREATION: creationButtonHandler(id); break;
        case GameState.PLAY: playButtonHandler(id); break;
    }
}

function onClickButton(id)
{
    switch(Player.gameState) {
        case GameState.PLAY: playClickButtonHandler(id); break;
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

local lastTime = getTickCount();
local function onRenderH()
{
    local currentTime = getTickCount();
    if (currentTime - lastTime < 50)
        lastTime = currentTime;

    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onRenderC(); break;
        case GameState.PLAY: onRenderP(currentTime, lastTime); break;
    }
}
addEventHandler("onRender", onRenderH);

local function onClickH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onClickC(key); break;
        case GameState.PLAY:
            rawOnClick(key);
            onClickPlay(key);
        break;
    }
}
addEventHandler("onMouseClick", onClickH);

local function onReleaseH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onReleaseC(key); break;
        case GameState.PLAY: onReleasePlay(key);
    }
}
addEventHandler("onMouseRelease", onReleaseH);

function setupPlayer(name, bodyMod, bodyTex, headMod, headTex)
{
    Player.cBodyModel = bodyMod;
    Player.cBodyTexture = bodyTex;
    Player.cHeadModel = headMod;
    Player.cHeadTexture = headTex;
    Player.updateVisual();
    setPlayerName(heroId, name);
}

function onSlide(el)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_CREATION: onSlideChar(el);
        case GameState.PLAY: onSlidePlay(el);
    }
}

function onHover(el)
{
    switch(Player.gameState) {
        case GameState.PLAY: invHover(el);
    }
}

function onUnhover(el)
{
    switch(Player.gameState) {
        case GameState.PLAY: invUnhover(el);
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
            loadCharacter(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11]);
        break;

        case PacketType.CHARACTERS_FINISHED:
            if(data[0] == 1) {
                moveCameraToNPC();



                ///////////////


                ///// DEBUG


                /////////

                if (DEBUG) debug_funcx();
            }
        break;

        case PacketType.CHARACTERS_SELECT:
            if (data[0] == -1) return;
            setupPlayer(data[2], data[3], data[4], data[5], data[6]);
            for(local i = 0; i < 4; i++)
            {
                Player.qa[i] = data[i+10];
            }
            ChangeGameState(GameState.PLAY);
        break;

        case PacketType.CHARACTERS_CREATE:
            Player.charSlot = data[0];
            ChangeGameState(GameState.CHARACTER_CREATION);
        break;

        case PacketType.CHARACTER_CREATION_CONFIRM:
            setupPlayer(data[2], data[3], data[4], data[5], data[6]);
            for(local i = 0; i < 4; i++)
            {
                Player.qa[i] = "";
            }
            ChangeGameState(GameState.CHARACTER_SELECTION);
        break;

        case PacketType.CHARACTER_CREATION_BACK:
            ChangeGameState(GameState.CHARACTER_SELECTION);
        break;

        case PacketType.CHAT_MESSAGE:
            if (Player.gameState == GameState.PLAY) {
                onMessage(data);
            }
        break;

        case PacketType.UPDATE_ITEM:
            Player.manageItem(data[0], data[1], data[2], data[3]);
        break;

        case PacketType.SPAWN_ENEMIES:
            spawnEnemy(data[0], data[1], data[2], data[3], data[4], data[5]);
        break;

        case PacketType.UPDATE_LEVEL:
            Player.level = data[0];
        break;

        case PacketType.UPDATE_EXPERIENCE:
            Player.experience = data[0];
        break;

        case PacketType.UPDATE_GOLD:
            Player.gold = data[0];
        break;
    }
}
addEventHandler("onPacket", onPacket);