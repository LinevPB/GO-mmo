local queue = null;
local draw = null;
local NotificationTime = 3000;
local UpdateSpeed = 20;

function initNotifications()
{
    queue = [];
    draw = Draw(0, 6000, "");
    draw.font = "FONT_OLD_20_WHITE_HI.TGA";
    draw.setColor(250, 200, 0);
    draw.alpha = 0;
    draw.visible = true;
}

function notify(text)
{
    if (queue.len() > 0) {
        if (queue[0].Message == text)
            return queue[0].TimeLeft = NotificationTime - 255;
    }

    queue.append({ TimeLeft = NotificationTime, Message = text});
}

local lastTime = getTickCount();
local function renderHandler()
{
    local currentTime = getTickCount();
    if (currentTime - lastTime < UpdateSpeed) return;
    lastTime = currentTime;

    if (queue.len() > 0) {
        if (draw.text != queue[0].Message) {
            draw.text = queue[0].Message;
            draw.setPosition(8192 / 2 - draw.width / 2, 6000);
        }

        queue[0].TimeLeft -= UpdateSpeed;
        if (queue[0].TimeLeft <= 0) {
            draw.alpha = 0;
            if (queue.len() == 1) return queue.remove(0);
            for(local i = 0; i < queue.len() - 2; i++) {
                queue[i + 1] = queue[i];
                if(i == queue.len() - 3) queue.remove(i + 1);
            }
        }
        else if (queue[0].TimeLeft > NotificationTime - 255) draw.alpha = NotificationTime - queue[0].TimeLeft;
        else if (queue[0].TimeLeft < 255) draw.alpha = queue[0].TimeLeft;
        else if (draw.alpha != 255) draw.alpha = 255;
    }
}
addEventHandler("onRender", renderHandler);