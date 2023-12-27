local slots = [];

local charMenu = null;
local menuFrame = null;
local menuFrameBackground = null;
local menuShadow = null;
local menuSlider = null;
local menuTitle = null;

local coverTexTop = null;
local coverTexBottom = null;

local newCharBtn = null;
local logout_btn = null;
local quit_btn = null;
local play_btn = null;

local nameBigDraw = null;
local nameCover = null;

local slotSelected = -1;
local isBigDrawEnabled = false;

function enableSelection(val)
{
    charMenu.visible = val;
    menuFrameBackground.visible = val;

    foreach(v in slots)
    {
        v.enable(val);
    }

    newCharBtn.enable(val);

    coverTexTop.visible = val;
    coverTexBottom.visible = val;

    menuFrame.visible = val;
    menuShadow.visible = val;

    menuTitle.visible = val;

    if (menuSlider != null)
    {
        menuSlider.enable(val);
    }

    logout_btn.enable(val);
    quit_btn.enable(val);

    if (val == false)
    {
        enableBigDraw(val);
    }
}

function addSelectionSlider()
{
    if (slots.len() == 0)
    {
        newCharBtn.setPosition(newCharBtn.getPosition().x, 3550);
        return;
    }

    newCharBtn.setPosition(newCharBtn.getPosition().x, slots[slots.len() - 1].getBottom() + 400);

    if (newCharBtn.getBottom() < menuFrame.getPosition().y + menuFrame.getSize().height - 200)
    {
        newCharBtn.setPosition(newCharBtn.getPosition().x, slots[slots.len() - 1].getBottom() + (6800 - slots[slots.len() - 1].getBottom()) / 2 - 300);
        return;
    }

    local size = charMenu.getSize();
    charMenu.setSize(size.width + 200, size.height);
    menuShadow.setSize(size.width + 200, size.height);

    menuSlider = Slider(2900, 800, 6000, "SLIDER_BACKGROUND_VERTICAL.TGA", newCharBtn.getBottom() - menuFrame.getSize().height - 200, "", "SLIDER_HANDLE.TGA", true);
}

function onSlideSelection(el)
{
    if (el != menuSlider) return;

    foreach(v in slots)
    {
        v.moveAway(0, -el.getValue());
    }

    newCharBtn.setPosition(newCharBtn.getPosition().x, slots[slots.len() - 1].getBottom() + 400);
}

function initSelectionWindow()
{
    charMenu = Texture(0, 0, 3000, 8192, "BACKGROUND_GRAY.TGA");

    menuTitle = Draw(0, 0, "Characters");
    menuTitle.font = "FONT_OLD_20_WHITE_HI.TGA";
    menuTitle.setColor(230, 230, 255);
    menuTitle.setPosition(1500 - menuTitle.width / 2, 400 - menuTitle.height / 2);

    menuFrame = Texture(200, 800, 2600, 6000, "WINDOW_FRAME.TGA");
    menuFrameBackground = Texture(200, 800, 2600, 6000, "WINDOW_BACKGROUND.TGA");

    coverTexTop = Texture(0, 0, 3000, 800, "BACKGROUND_GRAY.TGA");
    coverTexBottom = Texture(0, 6800, 3000, 1592, "BACKGROUND_GRAY.TGA");

    menuShadow = Texture(0, 0, 3000, 8192, "BACKGROUND_SHADOW.TGA");

    newCharBtn = buttonInterface(900, 900, 1200, 500, "+ New character");
    newCharBtn.setColor(160, 160, 255);
    newCharBtn.setHoverColor(130, 130, 255);

    logout_btn = buttonInterface(400, 7300, 1000, 400, "Log out");
    quit_btn = buttonInterface(1600, 7300, 1000, 400, "Quit");
    play_btn = buttonInterface(3000 + (8192-3000) / 2 - 600, 7250, 1200, 500, "Play");

    nameBigDraw = Draw(0, 0, "Sample name");
    nameBigDraw.setColor(200, 200, 255);
    nameBigDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
    nameBigDraw.setPosition(3000 + (8192-3000) / 2 - nameBigDraw.width / 2, 7200 - nameBigDraw.height - 200);

    local pos = nameBigDraw.getPosition();
    nameCover = Texture(pos.x - 100, pos.y - 50, nameBigDraw.width + 200, nameBigDraw.height + 100, "TEXTBOX_BACKGROUND.TGA");
}

function enableBigDraw(val)
{
    if (isBigDrawEnabled == val) return false;

    nameCover.visible = val;
    nameBigDraw.visible = val;

    play_btn.enable(val);

    isBigDrawEnabled = val;

    return true;
}

function updateBigDraw(text)
{
    local val = (text != "");
    enableBigDraw(val);

    nameBigDraw.text = text;
    nameBigDraw.setPosition(3000 + (8192-3000) / 2 - nameBigDraw.width / 2, 7200 - nameBigDraw.height - 200);

    nameCover.setSize(nameBigDraw.width + 200, nameBigDraw.height + 100);
    local pos = nameBigDraw.getPosition();
    nameCover.setPosition(pos.x - 100, pos.y - 50);
}

function initCharacterSelection()
{
    setCursorVisible(true);
    initSelectionWindow();

    setPlayerPosition(Player.helper, 37730, 4680, 44830);
    setPlayerAngle(Player.helper, 230);
    sendPacket(PacketType.CHARACTERS_QUERY, 0);
}

function moveCameraToNPC()
{
    Camera.setPosition(37540, 4680, 44605);
    Camera.setRotation(0, 20, 0);
    Player.updateVisual(Player.helper);
    addSelectionSlider();

    if (slots.len() > 0)
    {
        onSelectSlot(0, true);
    }
    else
    {
        setPlayerVisualAlpha(Player.helper, 0.0);
    }

    enableSelection(true);

    Player.canProceed = true;
}

function deinitCharacterSelection()
{
    enableSelection(false);

    deinitSlots();

    slots = [];

    charMenu = null;
    menuFrame = null;
    menuFrameBackground = null;
    menuShadow = null;
    menuSlider = null;
    coverTexTop = null;
    coverTexBottom = null;
    newCharBtn = null;
    logout_btn = null;
    quit_btn = null;
    play_btn = null;
    nameBigDraw = null;
    nameCover = null;

    slotSelected = -1;
    isBigDrawEnabled = false;
}

function deinitNpc()
{
    unspawnNpc(Player.helper);
}

function onSelectSlot(id, forced = false)
{
    if (!isInFrame() && forced == false) return;

    slotSelected = id;

    foreach(v in slots)
    {
        if (v.id != id)
        {
            if (v.selected)
            {
                v.unselect();
            }

            continue;
        }

        v.select();

        local struct = v.getStruct();
        changeVisual(struct);
        updateBigDraw(struct.name);
    }
}

function loadCharacter(index, charId, ownerId, charName, bodyModel, bodyTex, headModel, headTex, eqWeapon, eqArmor, slotId, eqWeapon2h, level, fat)
{
    local char = CharStruct(slotId, charId, ownerId, charName, bodyModel, bodyTex, headModel, headTex, eqArmor, eqWeapon, eqWeapon2h, level, fat);
    local slot = charSlot(300, 1000 + 800 * slots.len(), charName, level);
    slot.setStruct(char);
    slots.append(slot);
}

function changeVisual(slot)
{
    Player.cBodyModel = slot.bodyModel;
    Player.cBodyTexture = slot.bodyTex;
    Player.cHeadModel = slot.headModel;
    Player.cHeadTexture = slot.headTex;
    Player.updateVisual(Player.helper);
    Player.updateEquipped(slot.eqArmor, slot.eqWeapon, slot.eqWeapon2h);
    setPlayerFatness(Player.helper, slot.fatness);
}

function isInFrame()
{
    return (inSquare(getCursorPosition(), menuFrame.getPosition(), menuFrame.getSize()));
}

function buttonInterfaceHandler(btn)
{
    switch(btn)
    {
        case newCharBtn:
            if (!isInFrame()) return;

            sendPacket(PacketType.CHARACTERS_CREATE, 0);
        break;

        case logout_btn:
            logOut();
        break;

        case quit_btn:
            exitGame();
        break;

        case play_btn:
            if (slots.len() == 0) return;
            if (slotSelected == -1) return;

            sendPacket(PacketType.CHARACTERS_SELECT, slotSelected);
        break;
    }
}


function debug_funcx()
{
    //sendPacket(PacketType.CHARACTERS_CREATE, 0);
    //sendPacket(PacketType.CHARACTERS_SELECT, slotSelected);
}

// addEventHandler("onRender", function(){
//     print(getPlayerAni(heroId));
// });