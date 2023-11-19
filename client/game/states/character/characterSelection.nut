local charMenu = {
    window = null,
    characterList = null,
    ok = null,
    quit = null
};

function characterButtonHandler(id)
{
    switch(id) {
        case charMenu.ok.id:
            if (charMenu.characterList.currentOpt != -1) {

            }
            break;
        case charMenu.quit.id:
            exitGame();
            break;
    }
}

function initCharacterSelection()
{
    setCursorVisible(true);

    local wW = 1600;
    local wH = 3300;
    charMenu.window = Window(8192 - wW - 400, 8192 / 2 - wH / 2, wW, wH, "DLG_CONVERSATION.TGA");

    local temp = Label(0, 100, "Characters");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    charMenu.window.attach(temp);
    temp.center();
    temp = null;

    charMenu.characterList = List(0, 700, 1200, 1800, "DLG_CONVERSATION.TGA", ["Slot 1", "Slot 2", "Slot 3"], 1200, 400, 0, 600, "INV_SLOT_FOCUS.TGA", "INV_TITEL.TGA");
    charMenu.window.attach(charMenu.characterList);
    charMenu.characterList.center();

    charMenu.ok = Button(200, 2700, 500, 400, "INV_SLOT_FOCUS.TGA", "Ok", "INV_TITEL.TGA");
    charMenu.quit = Button(900, 2700, 500, 400, "INV_SLOT_FOCUS.TGA", "Quit", "INV_TITEL.TGA");
    charMenu.window.attach(charMenu.ok);
    charMenu.window.attach(charMenu.quit);

    charMenu.window.enable(true);

    spawnNpc(Player.helper, "PC_HERO");
    setPlayerPosition(Player.helper, 9947, 368, -717);
    setPlayerAngle(Player.helper, 270);
    sendPacket(PacketType.CHARACTERS_QUERY, 0);
}

function moveCameraToNPC()
{
    Player.canProceed = true;
    Camera.setPosition(9650, 400, -730);
    Camera.setRotation(0, 85, 0);
}

function deinitCharacterSelection()
{
    charMenu.window.enable(false);
    destroy(charMenu.window);
    charMenu = {
        window = null,
        characterList = null,
        ok = null,
        quit = null
    };
}

function deinitNpc()
{
    unspawnNpc(Player.helper);
}

function loadCharacter(charSlot, charId, ownerId, charName)
{
    charMenu.characterList.options[charSlot].changeText(charName);
}

local function onkey(key)
{
    if (key == KEY_Z) {
        exitGame();
    }

}
addEventHandler("onKey", onkey);

function characterListHandler(el)
{

}