local UpdateSpeed = 20;
local lastTime = getTickCount();
local deathDraw = null;
local deathTime = 0;
local deathTimer = null;

function updateDeathDraw()
{
    deathDraw.text = lang["RESPAWN_INFO"][Player.lang] + "" + deathTime;
    deathDraw.setPosition(4096 - deathDraw.width / 2, 4096 - deathDraw.height / 2);
    deathTime -= 1;

    if (deathTime < 0)
    {
        deathTime = 0;
        deathDraw.visible = false;
        killTimer(deathTimer);
    }
}

function startDeathDraw(sec)
{
    deathTime = sec;

    updateDeathDraw();
    deathDraw.visible = true;

    deathTimer = setTimer(updateDeathDraw, 1000, 0);
}

function initDeathDraw()
{
    deathDraw = Draw(0, 0, "");
    deathDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
    deathDraw.setColor(255, 0, 0);
}

function interfaceRender()
{
    local currentTime = getTickCount();
    if (currentTime - lastTime < UpdateSpeed) return;
    lastTime = currentTime;

    Showcase.Render();
    notificationRender();
    chatRender();
    mapRender();
}
addEventHandler("onRender", interfaceRender);
