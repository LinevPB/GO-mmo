local npc_list = [];
local info_draw = Draw(0, 0, "Press (CTRL) to interact");
local fid = -1;
local dialog_draw = Draw(0, 0, "");

class NPC
{
    npc = null;
    nickname = null;
    draw = null;
    pos = null;
    instance = null;

    constructor(name, x, y, z)
    {
        npc = createNpc(name);
        draw = Draw3d(x, y + 75, z);
        pos = { x = x, y = y, z = z };
        instance = "PC_HERO";
        nickname = name;

        npc_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        playAni(npc, "S_HGUARD")
    }
}

function eventfocus(focusid, previd)
{
    foreach(v in npc_list) {
        if (v.npc == focusid) {
            if (!v.draw.visible)
                v.draw.visible = true;
                info_draw.visible = true;
                fid = v;
        } else {
            if (v.draw.visible) {
                v.draw.visible = false;
                info_draw.visible = false;
                fid = -1;
            }
        }
    }
}
addEventHandler("onFocus", eventfocus);

local npc = NPC("Z o", 0, 300, 0);
local npc1 = NPC("Z o 2", 0, 300, 0);

function initInteraction()
{
    info_draw.setPosition(8192 / 2 - info_draw.width / 2, 8192 - info_draw.height - 100);
    info_draw.setColor(220, 210, 189);

    npc.spawn();
    npc.draw.insertText("Zawsze dziewica");
    npc.draw.insertText("Zbigniew Ziobro");
    npc.draw.setLineColor(0, 255, 100, 255);

    //npc1.spawn();
    npc1.draw.insertText("Z a");
}

local con = 8192-6300-500;

local numerdraw1 = Draw(8192/2, 6550, "1. ");
local numerdraw2 = Draw(8192/2, 6850, "2. ");
local numerdraw3 = Draw(8192/2, 6850, "3. ");
local numerdraw4 = Draw(8192/2, 6850, "4. ");
local numerdraw5 = Draw(8192/2, 6850, "5. ");
local intWindow = Window(0, 6500, 8192, 8192 - 6500, "SR_BLANK.TGA");
local dialogOpt = [
    Button(8192/2 - 1000, 100, 8000/2, 300, "NONE", "Pokaz mi swoje towary", "NONE"),
    Button(8192/2 - 1000, 400, 8000/2, 300, "NONE", "Co tam", "NONE"),
    Button(8192/2 - 1000, 700, 8000/2, 300, "NONE", "Poboczne", "NONE"),
    Button(8192/2 - 1000, 1000, 8000/2, 300, "NONE", "Zagrajmy", "NONE"),
    Button(8192/2 - 1000, 1300, 8000/2, 300, "NONE", "Bywaj", "NONE")
];
intWindow.attach(dialogOpt[0]);
intWindow.attach(dialogOpt[1]);
intWindow.attach(dialogOpt[2]);
intWindow.attach(dialogOpt[3]);
intWindow.attach(dialogOpt[4]);
local cover1 = Texture(0, 0, 8192, con, "SR_BLANK.TGA");
cover1.setColor(0, 0, 0);
local cover2 = Texture(0, 6300+500, 8192, con, "SR_BLANK.TGA");
cover2.setColor(0, 0, 0);

function begin_interact()
{
    Chat.Enable(false);
    Camera.modeChangeEnabled = false;
    setFreeze(true);
    disableControls(true);
    setCursorVisible(true);
    setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
}

function interact(fid)
{
    cover1.visible = true;
    cover2.visible = true;
    // setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    Camera.setMode("CamModDialog", [getPlayerPtr(fid.npc), getPlayerPtr(heroId)]);
    fid.draw.visible = false;

    intWindow.setColorForAllButtons(160, 160, 255);
    intWindow.setHoverColorForAllButtons(200, 200, 255);
    intWindow.setBackgroundColor(60, 40, 20);

    dialogOpt[0].centered = false;
    dialogOpt[0].align_left = true;
    dialogOpt[0].recolor();

    dialogOpt[1].centered = false;
    dialogOpt[1].align_left = true;
    dialogOpt[1].recolor();

    dialogOpt[2].centered = false;
    dialogOpt[2].align_left = true;
    dialogOpt[2].recolor();

    dialogOpt[3].centered = false;
    dialogOpt[3].align_left = true;
    dialogOpt[3].recolor();

    dialogOpt[4].centered = false;
    dialogOpt[4].align_left = true;
    dialogOpt[4].recolor();

    show_dialog_menu();

    numerdraw1.setColor(255, 255, 255);
    numerdraw2.setColor(255, 255, 255);
    numerdraw3.setColor(255, 255, 255);
    numerdraw4.setColor(255, 255, 255);
    numerdraw5.setColor(255, 255, 255);

    numerdraw1.top();
    numerdraw2.top();
    numerdraw3.top();
    numerdraw4.top();
    numerdraw5.top();

    numerdraw1.setPosition(dialogOpt[0].draw.getPosition().x - numerdraw1.width, dialogOpt[0].draw.getPosition().y);
    numerdraw2.setPosition(dialogOpt[1].draw.getPosition().x - numerdraw2.width, dialogOpt[1].draw.getPosition().y);
    numerdraw3.setPosition(dialogOpt[2].draw.getPosition().x - numerdraw3.width, dialogOpt[2].draw.getPosition().y);
    numerdraw4.setPosition(dialogOpt[3].draw.getPosition().x - numerdraw4.width, dialogOpt[3].draw.getPosition().y);
    numerdraw5.setPosition(dialogOpt[4].draw.getPosition().x - numerdraw5.width, dialogOpt[4].draw.getPosition().y);

    local pos = getPlayerPosition(heroId);
    local npos = getPlayerPosition(fid.npc);
    local angle = getVectorAngle(pos.x, pos.z, npos.x, npos.z);
    setPlayerAngle(heroId, angle);
    angle = getVectorAngle(npos.x, npos.z, pos.x, pos.z);
    setPlayerAngle(fid.npc, angle);
}

local turning = false;
local turned = false;
local unturning = false;
local unturned = false;
local superf = -1;
local superTexture = Texture(0, 0, 8192, 8192, "SR_BLANK.TGA");
superTexture.setColor(0, 0, 0);
superTexture.alpha = 0;
superTexture.visible = false;
local mealpha = 0;
local interacting = false;

function begin_hiding()
{
    Camera.modeChangeEnabled = true;
    Camera.setMode("CAMMODNORMAL");
    cover1.visible = false;
    cover2.visible = false;
    hide_dialog_menu();
    fid.draw.visible = true;
    updateDialogDraw("");
    Chat.Enable(true);
    setCursorVisible(false);
}

function end_interaction()
{
    setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
    setFreeze(false);
    disableControls(false);
    interacting = false;
}

function show_dialog_menu()
{
    numerdraw1.visible = true;
    numerdraw2.visible = true;
    numerdraw3.visible = true;
    numerdraw4.visible = true;
    numerdraw5.visible = true;
    intWindow.enable(true);
    numerdraw1.top();
    numerdraw2.top();
    numerdraw3.top();
    numerdraw4.top();
    numerdraw5.top();

}
function hide_dialog_menu()
{
    numerdraw1.visible = false;
    numerdraw2.visible = false;
    numerdraw3.visible = false;
    numerdraw4.visible = false;
    numerdraw5.visible = false;
    intWindow.enable(false);
}

/*

	CAMERA MODES

	"CAMMODNORMAL"
	"CAMMODRUN"
	"CAMMODDIALOG"
	"CAMMODINVENTORY"
	"CAMMODMELEE"
	"CAMMODMAGIC"
	"CAMMODMELEEMULT"
	"CAMMODRANGED"
	"CAMMODSWIM"
	"CAMMODDIVE"
	"CAMMODJUMP"
	"CAMMODJUMPUP"
	"CAMMODCLIMB"
	"CAMMODDEATH"
	"CAMMODLOOK"
	"CAMMODLOOKBACK"
	"CAMMODFOCUS"
	"CAMMODRANGEDSHORT"
	"CAMMODSHOULDER"
	"CAMMODFIRSTPERSON"
	"CAMMODTHROW"
	"CAMMODMOBLADDER"
	"CAMMODFALL"

*/

function updateDialogDraw(text)
{
    playGesticulation(heroId);
    dialog_draw.text = text;
    dialog_draw.setPosition(8192 / 2 - dialog_draw.width / 2, 6300 - dialog_draw.height - 50);
    if (text == "")
        dialog_draw.visible = false;
    else
        dialog_draw.visible = true;
}

function playButtonHandler(id)
{
    if (Inventory.IsEnabled()) return INVplayButtonHandler(id);

    switch(id) {
        case dialogOpt[0].id:
            Camera.setMode("CamModDialog", [getPlayerPtr(fid.npc), getPlayerPtr(heroId)]);
            hide_dialog_menu();
            updateDialogDraw("Pokaz mi swoje towary");
        break;

        case dialogOpt[1].id:
            Camera.setMode("CamModDialog", [getPlayerPtr(heroId), getPlayerPtr(fid.npc), getPlayerPtr(fid.npc)]);
            hide_dialog_menu();
            updateDialogDraw("co tam");
        break;

        case dialogOpt[2].id:
            Camera.setMode("CamModDialog", [getPlayerPtr(heroId), getPlayerPtr(fid.npc), getPlayerPtr(fid.npc)]);
            hide_dialog_menu();
            updateDialogDraw("poboczne");
        break;

        case dialogOpt[3].id:
            Camera.setMode("CamModDialog", [getPlayerPtr(heroId), getPlayerPtr(fid.npc), getPlayerPtr(fid.npc)]);
            hide_dialog_menu();
            updateDialogDraw("zagrajmy");
        break;

        case dialogOpt[4].id:
            Camera.setMode("CamModDialog", [getPlayerPtr(heroId), getPlayerPtr(fid.npc), getPlayerPtr(fid.npc)]);
            hide_dialog_menu();
            updateDialogDraw("bywaj");
        break;
    }
}

local exiting = false;

function npcInteractionHandler()
{
    if (!interacting) return;
    if (turning) {
        mealpha += 10;
        if (mealpha >= 255) {
            turning = false;
            turned = true;
            mealpha = 255;
        }
        superTexture.alpha = mealpha;
        return;
    }
    if (unturning) {
        mealpha -= 10;
        if (mealpha <= 0) {
            unturning = false;
            unturned = true;
            mealpha = 0;
        }
        superTexture.alpha = mealpha;
        return;
    }

    if (turned) {
        if (!exiting) interact(superf);
        else begin_hiding();
        turned = false;
        unturning = true;
        return;
    }

    if (unturned) {
        if (exiting) {
            end_interaction();
            exiting = false;
        }
        unturned = false;
        superTexture.visible = false;
        superf = -1;
        return;
    }
}

local function onplayerkey(key)
{
    if (key == KEY_LCONTROL) {
        if (fid == -1) return;
        if (interacting) return;
        superf = fid;
        superTexture.visible = true;
        turning = true;
        begin_interact();
        interacting = true;
    }

    if (key == KEY_SPACE && interacting && !exiting) {
        show_dialog_menu();
        if (dialog_draw.text == "bywaj") {
            exiting = true;
            superTexture.visible = true;
            turning = true;
        }
    }
}
addEventHandler("onKey", onplayerkey);