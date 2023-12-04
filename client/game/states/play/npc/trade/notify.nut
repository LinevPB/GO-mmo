local notifyDraw = null;
local notify_queue = null;
local UpdateSpeed = 20;
const NotificationTime = 2500;

function initTradeNotify()
{
    notifyDraw = Draw(0, 0, "");
    notifyDraw.visible = false;
    notifyDraw.alpha = 0;
    notifyDraw.top();
    notify_queue = [];
}

function tradeNotify(text)
{
    if (notify_queue.len() > 0)
    {
        if (notify_queue[0].Message == text)
        {
            return notify_queue[0].TimeLeft = NotificationTime - 255;
        }
    }

    notifyDraw.visible = true;
    notify_queue.append({ TimeLeft = NotificationTime, Message = text});
}

function tradeNotifyRender()
{
    if (notify_queue == null) return;
    if (notify_queue.len() == 0) return;

    print(notifyDraw.visible);
    print(notifyDraw.text);
    print(notify_queue[0].Message);

    notify_queue[0].TimeLeft -= UpdateSpeed;

    if (notifyDraw.text != notify_queue[0].Message)
    {
        notifyDraw.visible = true;
        notifyDraw.text = notify_queue[0].Message;
        notifyDraw.setPosition(3600 - notifyDraw.width / 2, 6000);
    }

    if (notify_queue[0].TimeLeft <= 0)
    {
        notifyDraw.visible = false;
        notifyDraw.alpha = 0;

        if (notify_queue.len() == 1)
        {
            return notify_queue.remove(0);
        }

        for(local i = 0; i < notify_queue.len() - 2; i++)
        {
            notify_queue[i + 1] = notify_queue[i];

            if(i == notify_queue.len() - 3)
            {
                notify_queue.remove(i + 1);
            }
        }
    }

    else if (notify_queue[0].TimeLeft > NotificationTime - 255)
    {
        notifyDraw.alpha = NotificationTime - notify_queue[0].TimeLeft;
    }
    else if (notify_queue[0].TimeLeft < 255)
    {
        notifyDraw.alpha = notify_queue[0].TimeLeft;
    }
    else if (notifyDraw.alpha != 255)
    {
        notifyDraw.alpha = 255;
    }
}