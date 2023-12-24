local draws = [];
local disappearY = 5500;
local startY = 6000;
local updateSpeed = 25;
local levelup_draw = null;
local levelup_state = 0;
local levelup_time = 0;

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
    levelup_draw = Draw(0, 0, "");
    levelup_draw.font = "FONT_OLD_20_WHITE_HI.TGA";
    levelup_draw.alpha = 0;
    levelup_state = 0;
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

    switch(levelup_state)
    {
        case 1:
            local calc = levelup_draw.alpha + 5;
            if (calc >= 255)
            {
                calc = 255;
                levelup_time = getTickCount() + 2000;
                levelup_state = 2;
            }
            levelup_draw.alpha = calc;
        break;

        case 2:
            if (getTickCount() > levelup_time)
            {
                levelup_state = 3;
            }
        break;

        case 3:
            local calc = levelup_draw.alpha - 5;
            if (calc <= 0)
            {
                calc = 0;
                levelup_state = 0;
                levelup_draw.visible = false;
            }
            levelup_draw.alpha = calc;
        break;
    }
}

function levelUp_notify(text)
{
    addEffect(heroId, "Spellfx_Palheal");
    levelup_draw.text = text;
    levelup_draw.setPosition(8192 / 2 - levelup_draw.width / 2, 8192 / 2);
    levelup_draw.visible = true;
    levelup_state = 1;
}