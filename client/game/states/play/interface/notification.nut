local draws = [];
local disappearY = 5500;
local startY = 6000;
local updateSpeed = 25;

class Info
{
    draw = null;
    enabled = null;
    finishedShowing = null;
    finishedHiding = null;
    done = null;

    constructor(text)
    {
        draw = Draw(0, 0, text);
        draw.setColor(220, 220, 80);

        local calcY = startY;

        if (draws.len() > 0)
        {
            local temp = draws[draws.len() - 1].draw;
            calcY = temp.getPosition().y + temp.height + 50;

            if (calcY < startY) calcY = startY;
        }

        draw.setPosition(8192/2 - draw.width / 2, calcY);
        draw.alpha = 0;

        enabled = false;
        finishedShowing = false;
        finishedHiding = true;
        done = false;

        draws.append(this);
    }

    function enable(val)
    {
        draw.visible = val;
        enabled = val;
    }

    function move(x, y)
    {
        local pos = draw.getPosition();
        draw.setPosition(pos.x + x, pos.y + y);
    }

    function lighten()
    {
        if (finishedShowing) return;

        local temp = draw.alpha + 7;
        if (temp >= 255)
        {
            temp = 255;
            finishedShowing = true;
        }

        draw.alpha = temp;
    }

    function darken()
    {
        if (!finishedShowing) return;
        if (finishedHiding) return;

        local temp = draw.alpha - 7;
        if (temp <= 0)
        {
            temp = 0;
            finishedHiding = true;
            done = true;
        }

        draw.alpha = temp;
    }
}

function initNotifications()
{

}

function notify(text)
{
    if (getActionType() != 0) return;

    local temp = Info(text);
    temp.enable(true);
}

function notificationRender()
{
    foreach(i, v in draws)
    {
        if (!v.enabled) continue;
        v.move(0, -updateSpeed);
        v.lighten();
        v.darken();

        if (v.draw.getPosition().y - disappearY < 400 && v.finishedHiding)
        {
            v.finishedHiding = false;
        }

        if (v.done)
        {
            draws.remove(i);
        }
    }
}
