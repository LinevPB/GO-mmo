local makeupMenu = {
    window = null,
    characterList = null,
    nickTextbox = null,
    bodySlider = null,
    headSlider = null,
    headTexSlider = null,
    ok = null,
    quit = null
};

local control = {
    lclicked = false,
    lastCursX = 0,
    lastTime = getTickCount(),
    cursX = 0
};

function creationButtonHandler(id)
{
    switch(id) {
        case makeupMenu.quit.id:
            exitGame();
            break;
    }
}

function creationListHandler(el)
{
    Player.cBodyModel = el.parent.getSlot();
    Player.updateVisual(Player.helper);
}

local tex1 = null;
local tex2 = null;

function initCharacterCreation()
{
    setCursorVisible(true);

    local wW = 2000;
    local wH = 6000;
    makeupMenu.window = Window(8192 - wW - 400, 8192 / 2 - wH / 2, wW, wH, "DLG_CONVERSATION.TGA");

    local temp = Label(0, 100, "Creation");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    makeupMenu.window.attach(temp);
    temp.center();
    temp = null;

    temp = Label(wW / 2 - 850, 800, "Name:");
    temp.move(0, -(temp.height() + 25));
    makeupMenu.window.attach(temp);
    temp = null;
    makeupMenu.nickTextbox = Textbox(wW / 2 - 850, 800, 1700, 300, "INV_SLOT_FOCUS.TGA", "", "INV_TITEL.TGA", false);
    makeupMenu.window.attach(makeupMenu.nickTextbox);

    temp = Label(wW / 2 - 850, 1500, "Sex:");
    temp.move(0, -(temp.height() + 25));
    makeupMenu.window.attach(temp);
    temp = null;
    makeupMenu.characterList = List(wW/2, 1500, 1700, 300, "DLG_CONVERSATION.TGA", ["Male", "Female"], 800, 300, 900, 0, "INV_SLOT_FOCUS.TGA", "INV_TITEL.TGA");
    makeupMenu.window.attach(makeupMenu.characterList);
    makeupMenu.characterList.center();
    makeupMenu.characterList.selectFirstAsDefault();

    makeupMenu.bodySlider = Slider(wW / 2 - 850, 2500, 1700, "INV_TITEL.TGA", 12, "Body texture: ", "MENU_MASKE.TGA");
    makeupMenu.window.attach(makeupMenu.bodySlider);
    makeupMenu.headSlider = Slider(wW / 2 - 850, 3500, 1700, "INV_TITEL.TGA", 6, "Head model: ", "MENU_MASKE.TGA");
    makeupMenu.window.attach(makeupMenu.headSlider);
    makeupMenu.headTexSlider = Slider(wW / 2 - 850, 4500, 1700, "INV_TITEL.TGA", 163, "Head texture: ", "MENU_MASKE.TGA");
    makeupMenu.window.attach(makeupMenu.headTexSlider);

    makeupMenu.ok = Button(300, 5400, 600, 400, "INV_SLOT_FOCUS.TGA", "Ok", "INV_TITEL.TGA");
    makeupMenu.quit = Button(1100, 5400, 600, 400, "INV_SLOT_FOCUS.TGA", "Quit", "INV_TITEL.TGA");
    makeupMenu.window.attach(makeupMenu.ok);
    makeupMenu.window.attach(makeupMenu.quit);

    makeupMenu.window.enable(true);
    Player.updateVisual(Player.helper);

    tex1 = Texture(7192/2 - 200, 7200, 150, 200, "L.TGA");
    tex2 = Texture(7192/2 + 1400, 7200, 150, 200, "R.TGA");
    tex1.visible = true;
    tex2.visible = true;
}

function onSlide(el)
{
    switch(el.id) {
        case makeupMenu.bodySlider.id:
            Player.cBodyTexture = makeupMenu.bodySlider.getValue();
            Player.updateVisual(Player.helper);
            break;

        case makeupMenu.headSlider.id:
            Player.cHeadModel = makeupMenu.headSlider.getValue();
            Player.updateVisual(Player.helper);
            break;

        case makeupMenu.headTexSlider.id:
            Player.cHeadTexture = makeupMenu.headTexSlider.getValue();
            Player.updateVisual(Player.helper);
            break;
    }
}

function onClickC(key)
{
    if (key == MOUSE_BUTTONLEFT && !inSquare(getCursorPosition(), makeupMenu.window.pos, makeupMenu.window.size)) {
        control.lclicked = true;
        control.lastCursX = getCursorPosition().x;
    }
}

function onReleaseC(key)
{
    control.lclicked = false;
}

function onRenderC()
{
    local currentTime = getTickCount();
    if (currentTime - control.lastTime < 20) return;
    control.lastTime = currentTime;

    if (control.lclicked && control.lastCursX != getCursorPosition().x) {
        setPlayerAngle(Player.helper, getPlayerAngle(Player.helper) + (control.lastCursX - getCursorPosition().x) / 20);
        control.lastCursX = getCursorPosition().x;
    }
}