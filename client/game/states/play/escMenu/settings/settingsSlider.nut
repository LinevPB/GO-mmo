local sliders = [];

class settingsSlider
{
    slider = null;
    draw = null;
    title = null;
    background = null;
    height = 600;

    constructor(x, ny, width, scope)
    {
        title = Draw(x, ny, "A");
        local y = ny + title.height + 100;
        title.text = "";

        draw = Draw(0, 0, "100%");
        draw.setPosition(x + width - draw.width - 100, y + height / 2 - draw.height / 2);
        draw.setColor(0, 255, 0);

        background = Texture(x, y, width, height, "SR_BLANK.TGA");
        background.setColor(40, 40, 40);

        slider = Slider(x + 100, y + height / 2 + 50 - draw.height / 2, width - 300 - draw.width, "TEXTBOX_BACKGROUND.TGA", scope, "", "SLIDER_HANDLE.TGA", false, 200);

        sliders.append(this);
    }

    function enable(val)
    {
        background.visible = val;
        slider.enable(val);
        draw.visible = val;
        title.visible = val;
    }

    function setTitle(val)
    {
        title.text = val;
    }

    function updateDraw()
    {
        draw.text = slider.getRawValue() + "%";
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