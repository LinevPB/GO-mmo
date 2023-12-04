local UpdateSpeed = 20;
local lastTime = getTickCount();

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
