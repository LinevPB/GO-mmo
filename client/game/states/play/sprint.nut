addEventHandler("onInit", function() {
    disableLogicalKey(GAME_SLOW, true);
});

local sprinting = false;
function sprint()
{
    local pressed = isKeyPressed(KEY_LSHIFT);

    if (sprinting)
    {
        if (pressed) return;

        sprinting = false;
        removePlayerOverlay(heroId, Mds.id("HUMANS_SPRINT.MDS"));

        return;
    }

    if (!pressed) return;

    sprinting = true;
    applyPlayerOverlay(heroId, Mds.id("HUMANS_SPRINT.MDS"));
}
addEventHandler("onRender", sprint);
