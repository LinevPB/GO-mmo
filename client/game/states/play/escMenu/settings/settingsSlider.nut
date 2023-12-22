local sliders = [];

class settingsSlider
{
    slider = null;
    draw = null;
    title = null;
    background = null;
    height = 600;
    limiter = null;
    limiterRight = null;
    percentage = null;
    scope = null;
    raw = null;

    constructor(x, ny, width, ascope, limit = 0, limitr = 1, perc = false, araw = true)
    {
        raw = araw;
        scope = ascope;
        title = Draw(x, ny, "A");
        local y = ny + title.height + 100;
        title.text = "";

        draw = Draw(0, 0, "100%");
        draw.setPosition(x + width - 400, y + height / 2 - draw.height / 2);
        draw.setColor(0, 255, 0);

        background = Texture(x, y, width, height, "SR_BLANK.TGA");
        background.setColor(40, 40, 40);

        limiter = limit;
        limiterRight = limitr;

        percentage = perc;

        slider = Slider(x + 100, y + height / 2 + 50 - draw.height / 2, width - 700, "TEXTBOX_BACKGROUND.TGA", scope, "", "SLIDER_HANDLE.TGA", false, 200);

        sliders.append(this);
    }

    function setValue(val)
    {
        if (val > scope) val = scope;
        if (val < 0) val = 0;

        slider.setValue(val);
        updateDraw();
    }

    function enable(val)
    {
        background.visible = val;
        slider.enable(val);
        draw.visible = val;
        title.visible = val;
    }

    function setPosition(x, y)
    {
        title.setPosition(x, y);
        draw.setPosition(x + background.getSize().width - 400, y + title.height + 100 + background.getSize().height / 2 - draw.height / 2);
        background.setPosition(x, y + title.height + 100);
        slider.setPosition(x + 100, y + title.height + 100 + background.getSize().height / 2 + 50 - draw.height / 2);
    }

    function setTitle(val)
    {
        title.text = val;
    }

    function getValue()
    {
        if (raw == true)
        {
            local val = slider.getRawValue();
            val = val * 100.0;
            val = val.tointeger();
            val = (val / 100.0).tofloat();
            if (val < limiter) val = limiter;
            return val;
        }
        else
        {
            return slider.getRawValue().tointeger() + limiter;
        }
    }

    function updateDraw()
    {
        if (percentage == true)
        {
            local text = (((slider.getRawValue()) / (scope)) * 100).tointeger() + "%";
            draw.text = text;
            return;
        }

        local text;

        if (raw == true)
        {
            local val = slider.getRawValue();
            val = val * 100.0;
            val = val.tointeger();
            val = (val / 100.0).tofloat();
            if (val < limiter) val = limiter;
            text = val;
        }
        else
        {
            text = slider.getRawValue().tointeger() + limiter;
        }

        draw.text = text;
    }

    function getBottomY()
    {
        return background.getPosition().y + background.getSize().height;
    }
}

function slidersSlide(el)
{
    foreach(v in sliders)
    {
        if (v.slider == el)
        {
            v.updateDraw();
            onSlideControls(el);
            return;
        }
    }
}