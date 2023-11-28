local charMenu = {
    window = null,
    characterList = null,
    ok = null,
    quit = null
};

local characters = [];
local maxchar = 3;
local charcount = 0;

class CharSlot
{
    name = null;
    charSlot = null;
    charId = null;
    ownerId = null;

    bodyModel = null;
    bodyTex = null;
    headModel = null;
    headTex = null;

    eqWeapon = null;
    eqWeapon2h = null;
    eqArmor = null;

    constructor(charSlota, charIda, ownerIda, namea, bodyModela, bodyTexa, headModela, headTexa, eqArmora, eqWeapona, eqWeapon2ha)
    {
        name = namea;
        charSlot = charSlota;
        charId = charIda;
        ownerId = ownerIda;

        bodyModel = bodyModela;
        bodyTex = bodyTexa;
        headModel = headModela;
        headTex = headTexa;

        eqWeapon = eqWeapona;
        eqArmor = eqArmora;
        eqWeapon2h = eqWeapon2ha;
    }
}

function characterButtonHandler(id)
{
    switch(id) {
        case charMenu.ok.id:
            if (charMenu.characterList.currentOpt == -1) return;
            if (characters[charMenu.characterList.getSlot()] != 0) {
                sendPacket(PacketType.CHARACTERS_SELECT, characters[charMenu.characterList.getSlot()].charId);
                return;
            }
            sendPacket(PacketType.CHARACTERS_CREATE, charMenu.characterList.getSlot());
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
    charMenu.window = Window(8192 - wW - 400, 8192 / 2 - wH / 2, wW, wH, "SR_BLANK.TGA");
    charMenu.window.setBackgroundColor(10, 10, 40);
    charMenu.window.setCover("MENU_INGAME.TGA");

    local temp = Label(0, 100, lang["LABEL_CHAR_SELECTION_MENU_CHARACTERS"][Player.lang]);
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    charMenu.window.attach(temp);
    temp.center();
    temp = null;

    charMenu.characterList = List(0, 700, 1200, 1800, "DLG_CONVERSATION.TGA", [lang["LABEL_CHAR_SELECTION_MENU_SLOT1"][Player.lang], lang["LABEL_CHAR_SELECTION_MENU_SLOT2"][Player.lang], lang["LABEL_CHAR_SELECTION_MENU_SLOT3"][Player.lang]], 1200, 400, 0, 600, "MENU_CHOICE_BACK.TGA", "INV_TITEL.TGA");
    charMenu.window.attach(charMenu.characterList);
    charMenu.characterList.center();

    charMenu.ok = Button(200, 2700, 500, 400, "MENU_CHOICE_BACK.TGA", lang["BUTTON_CHAR_SELECTION_MENU_OK"][Player.lang], "INV_TITEL.TGA");
    charMenu.quit = Button(900, 2700, 500, 400, "MENU_CHOICE_BACK.TGA", lang["BUTTON_CHAR_SELECTION_MENU_QUIT"][Player.lang], "INV_TITEL.TGA");
    charMenu.window.attach(charMenu.ok);
    charMenu.window.attach(charMenu.quit);

    charMenu.window.enable(true);

    setPlayerPosition(Player.helper, 37730, 4680, 44830);
    setPlayerAngle(Player.helper, 230);
    sendPacket(PacketType.CHARACTERS_QUERY, 0);

    for(local i = 0; i < maxchar; i++)
        characters.append(0);
}

function moveCameraToNPC()
{
    Player.canProceed = true;
    Camera.setPosition(37530, 4680, 44650);
    Camera.setRotation(0, 45, 0);
    Player.updateVisual(Player.helper);
    charMenu.characterList.selectFirstAsDefault();
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
    characters = [];
    charcount = 0;
}

function deinitNpc()
{
    unspawnNpc(Player.helper);
}

function loadCharacter(charSlot, charId, ownerId, charName, bodyModel, bodyTex, headModel, headTex, eqWeapon, eqArmor, slotId, eqWeapon2h)
{
    local link = null;
    foreach (i, v in charMenu.characterList.options)
    {
        if (i == slotId) link = v;
    }
    link.changeText(charName);
    local temp = CharSlot(slotId, charId, ownerId, charName, bodyModel, bodyTex, headModel, headTex, eqArmor, eqWeapon, eqWeapon2h);
    characters[slotId] = temp;
    charcount++;
}

function characterListHandler(el)
{
    foreach(i, v in characters) {
        if (v == 0)
        {
            Player.cBodyModel = 0;
            Player.cBodyModel = 0;
            Player.cBodyTexture = 0;
            Player.cHeadModel = 0;
            Player.cHeadTexture = 0;
            Player.updateVisual(Player.helper);
            Player.updateEquipped("", "", "");

            setPlayerVisualAlpha(Player.helper, 0.0);
            charMenu.ok.changeText(lang["BUTTON_CHAR_SELECTION_MENU_CREATE"][Player.lang]);
            continue;
        }

        if (el.getSlot() == v.charSlot)
        {
            Player.cBodyModel = v.bodyModel;
            Player.cBodyTexture = v.bodyTex;
            Player.cHeadModel = v.headModel;
            Player.cHeadTexture = v.headTex;
            Player.updateVisual(Player.helper);
            Player.updateEquipped(v.eqArmor, v.eqWeapon, v.eqWeapon2h);

            setPlayerVisualAlpha(Player.helper, 1.0);
            charMenu.ok.changeText(lang["BUTTON_CHAR_SELECTION_MENU_SELECT"][Player.lang]);
            return;
        }
    }
}

function debug_funcx()
{
    sendPacket(PacketType.CHARACTERS_SELECT, characters[charMenu.characterList.getSlot()].charId);
}