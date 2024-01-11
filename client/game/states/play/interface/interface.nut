local UpdateSpeed = 20;
local lastTime = getTickCount();
local deathDraw = null;
local deathTime = 0;
local deathTimer = null;

local igTime = null;
local realTime = null;

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

function initTimeDraws()
{
    igTime = Draw(100, 7400, "Czas w grze: 12:00");
    realTime = Draw(100, 7600, "Czas realny: 12:00:00");

    igTime.setColor(200, 170, 140);
    realTime.setColor(200, 170, 140);
}

function enableTimeDraws(val)
{
    igTime.visible = val;
    realTime.visible = val;
}

function timeDrawsRender()
{
    if (igTime == null || realTime == null) return;

    local time = getTime();
    local timeFormat = format("%d:%02d", time.hour, time.min);
    igTime.text = "Czas w grze: " + timeFormat;

    time = date();
    timeFormat = format("%d:%02d:%02d", time.hour, time.min, time.sec);
    realTime.text = "Czas realny: " + timeFormat;
}

function initInterface()
{
    initDeathDraw();
    initTimeDraws();
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
    playersNameRender();
    timeDrawsRender();
}
addEventHandler("onRender", interfaceRender);
