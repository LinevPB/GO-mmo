local DEBUG = true;

function onInit()
{
    initUI();
    if (DEBUG) {
        ChangeGameState(GameState.PLAY);
        return;
    }
    ChangeGameState(GameState.LOGIN);
}

addEventHandler("onInit", onInit);