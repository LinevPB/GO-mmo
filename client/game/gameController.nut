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
    setCursorTxt("SR_CURSOR.TGA");
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

function logOut()
{
    ChangeGameState(GameState.LOGIN);
    sendPacket(PacketType.LOG_OUT, 1);
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
        case GameState.CHARACTER_SELECTION: onRenderS(); break;
        case GameState.CHARACTER_CREATION: onRenderC(); break;
        case GameState.PLAY: onRenderP(currentTime, lastTime); break;
    }
}
addEventHandler("onRender", onRenderH);

local function onClickH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_SELECTION: onClickS(key); break;
        case GameState.CHARACTER_CREATION: onClickC(key); break;
        case GameState.PLAY:
            onClickPlay(key);
            rawOnClick(key);
        break;
    }
}
addEventHandler("onMouseClick", onClickH);

local function onReleaseH(key)
{
    switch(Player.gameState) {
        case GameState.CHARACTER_SELECTION: onReleaseS(key); break;
        case GameState.CHARACTER_CREATION: onReleaseC(key); break;
        case GameState.PLAY:
            rawOnRelease(key);
            onReleasePlay(key);
        break;
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
        case GameState.CHARACTER_SELECTION: onSlideSelection(el); break;
        case GameState.CHARACTER_CREATION: onSlideChar(el); break;
        case GameState.PLAY: onSlidePlay(el); break;
    }
}

function onHover(el)
{
    switch(Player.gameState) {
        case GameState.PLAY: invHover(el); break;
    }
}

function onUnhover(el)
{
    switch(Player.gameState) {
        case GameState.PLAY: invUnhover(el); break;
    }
}

function onPlayerDisconnect(pid)
{
    handlePlayerUnspawnList(pid);
    handlePlayerUnspawn(pid);
}