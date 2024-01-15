local isInteracting = false;
local lastFocus = -1;
local intMenu = null;
local getDescBtn = null;
local quitBtn = null;

function onInteractionPlayerFocus(fid, previd)
{
    if (previd != -1)
    {
        local player = findPlayer(previd);
        if (player != null)
        {
            player.clearInfo();
            lastFocus = -1;
        }
    }

    if (fid == -1) return;

    local player = findPlayer(fid);
    if (player == null) return;

    player.showInfo(lang["CTRL"][Player.lang], lang["TALK"][Player.lang]);
    lastFocus = fid;
}
addEventHandler("onFocus", onInteractionPlayerFocus);

function initPlayerInteraction()
{
    intMenu = Window(0, 0, 8192, 8192, "");

    getDescBtn = Button(3396, 6000, 1400, 400, "ANIM_ELEMENT.TGA", "Opis", "ANIM_ELEMENT_HOVER.TGA")
    intMenu.attach(getDescBtn);

    quitBtn = Button(3396, 6400, 1400, 400, "ANIM_ELEMENT.TGA", "Wyjdz", "ANIM_ELEMENT_HOVER.TGA");
    intMenu.attach(quitBtn);
}

function enablePlayerInteraction(val)
{
    setCursorVisible(val);
    intMenu.enable(val);
    setFreeze(val);
    disableControls(val);

    Camera.movementEnabled = !val;
    enableQA(!val);

    isInteracting = val;

    if (val == true)
    {
        setActionType(6);
        return;
    }

    setActionType(0);
}

function isPlayerInteractionEnabled()
{
    return isInteracting;
}

function focusInteract_Player()
{
    local weaponMode = getPlayerWeaponMode(heroId);
    if (weaponMode != WEAPONMODE_NONE) return false;
    if (lastFocus == -1) return false;
    if (isInteracting) return false;
    if (getActionType() != 0) return;

    enablePlayerInteraction(val);

    return true;
}

function playerInteractionBtn(id)
{
    switch(id)
    {
        case getDescBtn.id:

        break;

        case quitBtn.id:
            enablePlayerInteraction(false);
        break;
    }
}

function playerInteractionKey(key)
{
    if (key != KEY_ESCAPE) return;

    enablePlayerInteraction(false);
}

addEventHandler("onKey", function(key) {
    if (key != KEY_X) return;

    if (isInteracting)
    {
        enablePlayerInteraction(false);
        return;
    }

    if (getActionType() != 0) return;

    enablePlayerInteraction(true);
});