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

local tex1 = null;
local tex2 = null;

function creationButtonHandler(id)
{
    switch(id) {
        case makeupMenu.quit.id:
            sendPacket(PacketType.CHARACTER_CREATION_BACK, 1);
            break;

        case makeupMenu.ok.id:
            sendPacket(PacketType.CHARACTER_CREATION_CONFIRM, makeupMenu.nickTextbox.getValue(), Player.cBodyModel, Player.cBodyTexture, Player.cHeadModel, Player.cHeadTexture, Player.charSlot);
            break;
    }
}

function creationListHandler(el)
{
    Player.cBodyModel = el.parent.getSlot();
    Player.updateVisual(Player.helper);
}

function initCharacterCreation()
{
    setCursorVisible(true);

    local wW = 2000;
    local wH = 6000;
    makeupMenu.window = Window(8192 - wW - 400, 8192 / 2 - wH / 2, wW, wH, "WINDOW_BACKGROUND.TGA");

    local temp = Label(0, 100, lang["LABEL_CREATION_TITLE"][Player.lang]);
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    makeupMenu.window.attach(temp);
    temp.center();
    temp = null;

    temp = Label(wW / 2 - 850, 800, lang["LABEL_CREATION_NAME"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    makeupMenu.window.attach(temp);
    temp = null;
    makeupMenu.nickTextbox = Textbox(wW / 2 - 850, 800, 1700, 300, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", false);
    makeupMenu.nickTextbox.addHoverCover(Texture(0, 0, 1700, 300, "TEXTBOX_SHADOW.TGA"));
    makeupMenu.window.attach(makeupMenu.nickTextbox);

    temp = Label(wW / 2 - 850, 1500, lang["LABEL_CREATION_SEX"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    makeupMenu.window.attach(temp);
    temp = null;
    makeupMenu.characterList = List(wW/2, 1500, 1700, 300, "DLG_CONVERSATION.TGA", [lang["LABEL_CREATION_MALE"][Player.lang], lang["LABEL_CREATION_FEMALE"][Player.lang]], 800, 300, 900, 0, "MENU_CHOICE_BACK.TGA", "INV_TITEL.TGA");
    makeupMenu.window.attach(makeupMenu.characterList);
    makeupMenu.characterList.center();
    makeupMenu.characterList.selectFirstAsDefault();

    makeupMenu.bodySlider = Slider(wW / 2 - 850, 2500, 1700, "TEXTBOX_BACKGROUND.TGA", 12, lang["LABEL_CREATION_BODYTEX"][Player.lang], "SLIDER_HANDLE.TGA");
    makeupMenu.window.attach(makeupMenu.bodySlider);

    makeupMenu.headSlider = Slider(wW / 2 - 850, 3500, 1700, "TEXTBOX_BACKGROUND.TGA", 6, lang["LABEL_CREATION_HEADMODEL"][Player.lang], "SLIDER_HANDLE.TGA");
    makeupMenu.window.attach(makeupMenu.headSlider);

    makeupMenu.headTexSlider = Slider(wW / 2 - 850, 4500, 1700, "TEXTBOX_BACKGROUND.TGA", 163, lang["LABEL_CREATION_HEADTEX"][Player.lang], "SLIDER_HANDLE.TGA");
    makeupMenu.window.attach(makeupMenu.headTexSlider);

    makeupMenu.ok = Button(300, 5400, 600, 400, "BUTTON_BACKGROUND.TGA", lang["BUTTON_CREATION_OK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    makeupMenu.ok.setBackgroundRegularColor(200, 20, 20);
    makeupMenu.ok.setBackgroundHoverColor(150, 20, 20);

    makeupMenu.quit = Button(1100, 5400, 600, 400, "BUTTON_BACKGROUND.TGA", lang["BUTTON_CREATION_BACK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    makeupMenu.quit.setBackgroundRegularColor(200, 20, 20);
    makeupMenu.quit.setBackgroundHoverColor(150, 20, 20);

    makeupMenu.window.attach(makeupMenu.ok);
    makeupMenu.window.attach(makeupMenu.quit);

    makeupMenu.window.enable(true);

    Player.cBodyModel = 0;
    Player.cBodyTexture = 0;
    Player.cHeadModel = 0;
    Player.cHeadTexture = 0;
    Player.updateVisual(Player.helper);
    setPlayerVisualAlpha(Player.helper, 1.0);
    Player.updateEquipped("", "", "", Player.helper)

    tex1 = Texture(7192/2 - 200, 7200, 150, 200, "L.TGA");
    tex2 = Texture(7192/2 + 1400, 7200, 150, 200, "R.TGA");
    tex1.visible = true;
    tex2.visible = true;
}

function deinitCharacterCreation()
{
    destroy(makeupMenu.window);
    tex1.visible = false;
    tex2.visible = false;
    tex1 = null;
    tex2 = null;

    makeupMenu = {
        window = null,
        characterList = null,
        nickTextbox = null,
        bodySlider = null,
        headSlider = null,
        headTexSlider = null,
        ok = null,
        quit = null
    };

    control = {
        lclicked = false,
        lastCursX = 0,
        lastTime = getTickCount(),
        cursX = 0
    };
}

function onSlideChar(el)
{
    switch(el.id)
    {
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