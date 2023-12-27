local control = {
    lclicked = false,
    lastCursX = 0,
    lastTime = getTickCount(),
    cursX = 0
};

local tex1 = null;
local tex2 = null;
local nameTextbox = null;
local createBtn = null;
local cancelBtn = null;

local leftMenu = null;
local sexList = null;
local walkingDropdown = null;
local fatSlider = null;

local rightMenu = null;
local bodySlider = null;
local headSlider = null;
local headTexSlider = null;

local lastMds = null;

function initCharacterCreation()
{
    setCursorVisible(true);

    setPlayerPosition(Player.helper, 37730, 4660, 44830);
    setPlayerAngle(Player.helper, 230);

    Camera.setPosition(37520, 4680, 44655);
    Camera.setRotation(0, 50, 0);

    // arrows
    tex1 = Texture(8192/2 - 1000, 6300, 150, 200, "R.TGA");
    tex1.rotation = 180;
    tex2 = Texture(8192/2 + 850, 6300, 150, 200, "R.TGA");

    nameTextbox = Textbox(8192 / 2 - 1000, 6700, 2000, 400, "TEXTBOX_BACKGROUND.TGA", "Character name", "TEXTBOX_BACKGROUND.TGA", false);
    nameTextbox.addHoverCover(Texture(8192 / 2 - 1000, 6700, 2000, 400, "TEXTBOX_SHADOW.TGA"));

    createBtn = buttonInterface(8192 / 2 - 600, 7300, 1200, 500, "Create");
    cancelBtn = buttonInterface(400, 7300, 1200, 500, "Go back");

    // reset player visual
    Player.cBodyModel = 0;
    Player.cBodyTexture = 0;
    Player.cHeadModel = 0;
    Player.cHeadTexture = 0;
    Player.updateVisual(Player.helper);
    setPlayerVisualAlpha(Player.helper, 1.0);
    setPlayerFatness(Player.helper, 0.0);
    Player.updateEquipped("-1", "-1", "-1");

    // left menu
    leftMenu = Window(400, 8192 / 2 - 2500, 2500, 4000, "WINDOW_BACKGROUND_SF.TGA");

    local temp = Label(150, 800, lang["LABEL_CREATION_SEX"][Player.lang]);
    temp.move(0, -(temp.height() + 100));
    leftMenu.attach(temp);
    temp = null;

    sexList = List(250, 800, 2250, 400, "", [lang["LABEL_CREATION_MALE"][Player.lang], lang["LABEL_CREATION_FEMALE"][Player.lang]], 1000, 400, 1250, 0, "TEXTBOX_BACKGROUND.TGA", "MENU_CHOICE_BACK.TGA");
    leftMenu.attach(sexList);
    sexList.center();
    sexList.selectFirstAsDefault();

    temp = Label(150, 1900, "Walking style");
    temp.move(0, -(temp.height() + 100));
    leftMenu.attach(temp);

    walkingDropdown = Dropdown(leftMenu.pos.x + 150, 1900 + leftMenu.pos.y, 2200, 400, "Default");

    walkingDropdown.addOption("Default", "NORMAL");
    walkingDropdown.addOption("Arrogance", "HumanS_Arrogance.mds");
    walkingDropdown.addOption("Babe", "Humans_Babe.mds");
    walkingDropdown.addOption("Flee", "HumanS_Flee.mds");
    walkingDropdown.addOption("Mage", "Humans_Mage.mds");
    walkingDropdown.addOption("Militia", "HumanS_Militia.mds");
    walkingDropdown.addOption("Relaxed", "HumanS_Relaxed.mds");
    walkingDropdown.addOption("Tired", "Humans_Tired.mds");

    walkingDropdown.selectOption(0);
    walkingDropdown.createSlider();

    fatSlider = Slider(150, 3200, 2200, "TEXTBOX_BACKGROUND.TGA", 5, "Fatness", "SLIDER_HANDLE.TGA");
    leftMenu.attach(fatSlider);

    // right menu
    rightMenu = Window(8192 - 400 - 2500, 8192 / 2 - 2500, 2500, 4000, "WINDOW_BACKGROUND_SF.TGA");

    bodySlider = Slider(150, 800, 2200, "TEXTBOX_BACKGROUND.TGA", 12, lang["LABEL_CREATION_BODYTEX"][Player.lang], "SLIDER_HANDLE.TGA");
    rightMenu.attach(bodySlider);

    headSlider = Slider(150, 2000, 2200, "TEXTBOX_BACKGROUND.TGA", 6, lang["LABEL_CREATION_HEADMODEL"][Player.lang], "SLIDER_HANDLE.TGA");
    rightMenu.attach(headSlider);

    headTexSlider = Slider(150, 3200, 2200, "TEXTBOX_BACKGROUND.TGA", 163, lang["LABEL_CREATION_HEADTEX"][Player.lang], "SLIDER_HANDLE.TGA");
    rightMenu.attach(headTexSlider);

    enableCreation(true);
}

function enableCreation(val)
{
    tex1.visible = val;
    tex2.visible = val;

    nameTextbox.enable(val);
    createBtn.enable(val);

    cancelBtn.enable(val);

    leftMenu.enable(val);
    walkingDropdown.enable(val);

    rightMenu.enable(val);
}

function creationButtonHandler(id)
{
    switch(id)
    {
        case createBtn.btn.id:
            sendPacket(PacketType.CHARACTER_CREATION_CONFIRM, nameTextbox.getValue(), Player.cBodyModel, Player.cBodyTexture, Player.cHeadModel, Player.cHeadTexture, Player.charSlot, Player.fat, Player.overlay);
            resetTempAni();
        break;

        case cancelBtn.btn.id:
            sendPacket(PacketType.CHARACTER_CREATION_BACK, 1);
            resetTempAni();
        break;
    }
}

function creationListHandler(el)
{
    Player.cBodyModel = el.parent.getSlot();
    Player.updateVisual(Player.helper);
}

function onSlideChar(el)
{
    switch(el.id)
    {
        case bodySlider.id:
            Player.cBodyTexture = bodySlider.getValue();
            Player.updateVisual(Player.helper);
            break;

        case headSlider.id:
            Player.cHeadModel = headSlider.getValue();
            Player.updateVisual(Player.helper);
            break;

        case headTexSlider.id:
            Player.cHeadTexture = headTexSlider.getValue();
            Player.updateVisual(Player.helper);
            break;

        case fatSlider.id:
            local calc = (((fatSlider.getRawValue() * 10).tointeger()).tofloat() / 10.0);
            setPlayerFatness(Player.helper, calc);
            Player.fat = calc;
            fatSlider.textuboxu.updateRaw(calc);
        break;
    }

    dropdownSlide(el);
}

function playTempAni(mds)
{
    lastMds = mds;

    if (mds != "NORMAL")
    {
        applyPlayerOverlay(Player.helper, mds);
    }

    playAni(Player.helper, "S_WALKL");
}

function resetTempAni()
{
    if (lastMds == null) return;

    if (lastMds != "NORMAL")
    {
        removePlayerOverlay(Player.helper, lastMds);
    }

    stopAni(Player.helper, "S_WALKL");

    lastMds = null;
}

function onSelectDropdown(dropdown, option, id)
{
    if (dropdown != walkingDropdown) return

    local config = dropdown.getSelectedConfig();
    Player.overlay = config;

    if (config == "NORMAL")
    {
        playTempAni(config);
        return;
    }

    playTempAni(Mds.id(config));
}

function onClickC(key)
{
    local curs = getCursorPosition();
    if (key == MOUSE_BUTTONLEFT && !inSquare(curs, leftMenu.pos, leftMenu.size) && !inSquare(curs, rightMenu.pos, rightMenu.size))
    {
        control.lclicked = true;
        control.lastCursX = curs.x;
    }

    if ((inSquare(curs, leftMenu.pos, leftMenu.size) || inSquare(curs, rightMenu.pos, rightMenu.size)))
    {
        resetTempAni();
    }

    dropdownPress();
}

function onReleaseC(key)
{
    control.lclicked = false;

    dropdownRelease();
}

function onRenderC()
{
    local currentTime = getTickCount();
    if (currentTime - control.lastTime < 20) return;

    control.lastTime = currentTime;

    local curs = getCursorPosition();
    if (control.lclicked && control.lastCursX != curs.x)
    {
        setPlayerAngle(Player.helper, getPlayerAngle(Player.helper) + (control.lastCursX - curs.x) / 20);
        control.lastCursX = curs.x;
    }

    local pos = getPlayerPosition(Player.helper);
    if (pos.x != 37730 || pos.z != 44830)
    {
        setPlayerPosition(Player.helper, 37730, pos.y, 44830);
    }

    dropdownRender();
}

function deinitCharacterCreation()
{
    enableCreation(false);

    destroy(leftMenu);
    destroy(rightMenu);
    destroy(nameTextbox);
    destroyDropdown(walkingDropdown);
    destroyButtonInterface(createBtn);
    destroyButtonInterface(cancelBtn);

    control = {
        lclicked = false,
        lastCursX = 0,
        lastTime = getTickCount(),
        cursX = 0
    };

    tex1 = null;
    tex2 = null;
    nameTextbox = null;
    createBtn = null;
    cancelBtn = null;

    leftMenu = null;
    sexList = null;
    walkingDropdown = null;
    fatSlider = null;

    rightMenu = null;
    bodySlider = null;
    headSlider = null;
    headTexSlider = null;

    lastMds = null;
}