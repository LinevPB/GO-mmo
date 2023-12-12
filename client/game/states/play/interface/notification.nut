local queue = null;
local draw = null;
local NotificationTime = 2500;
local UpdateSpeed = 20;

function initNotifications()
{
    queue = [];
    draw = Draw(0, 6000, "");
    draw.font = "FONT_OLD_20_WHITE_HI.TGA";
    draw.setColor(250, 200, 0);
    draw.alpha = 0;
    draw.visible = false;
    draw.top();
}

function notify(text, big = true, x = -1, y = -1)
{
    if (queue.len() > 0)
    {
        if (queue[0].Message == text)
        {
            return queue[0].TimeLeft = NotificationTime - 255;
        }
    }

    local font = big ? "Font_Old_20_White_Hi.TGA" : "Font_Old_10_White_Hi.TGA";
    draw.visible = true;
    draw.top();

    queue.append({ TimeLeft = NotificationTime, Message = text, x = x, y = y, font = font });
}


function notificationRender()
{
    if (queue.len() > 0)
    {
        if (draw.text != queue[0].Message)
        {
            draw.text = queue[0].Message;
            local posX = queue[0].x == -1 ? 8192 / 2 - draw.width / 2 : queue[0].x;
            local posY = queue[0].y == -1 ? 6000 : queue[0].y;
            draw.setPosition(posX, posY);
            draw.visible = true;
            draw.alpha = 255;
            draw.font = queue[0].font;
        }

        queue[0].TimeLeft -= UpdateSpeed;

        if (queue[0].TimeLeft <= 0)
        {
            draw.visible = false;
            draw.text = "";
            draw.alpha = 0;

            queue.remove(0);
        }
        else if (queue[0].TimeLeft > NotificationTime - 255)
        {
            draw.alpha = NotificationTime - queue[0].TimeLeft;
        }
        else if (queue[0].TimeLeft < 255)
        {
            draw.alpha = queue[0].TimeLeft;
        }
        else if (draw.alpha != 255)
        {
            draw.alpha = 255;
        }
    }
}
