local sprinting = false;

function sprint_init()
{
    disableLogicalKey(GAME_SLOW, true);
}
addEventHandler("onInit", sprint_init);

function sprint_render()
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
addEventHandler("onRender", sprint_render);
