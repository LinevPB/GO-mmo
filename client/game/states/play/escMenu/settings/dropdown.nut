local dropdowns = [];
local dropdownOptions = [];

local pressed = -1;
local pressedOption = -1;

class DropdownOption
{
    size = null;
    tex = null;
    draw = null;
    active = null;
    enabled = null;

    constructor(text)
    {
        tex = Texture(0, 0, 0, 0, "SR_BLANK.TGA");
        tex.setColor(20, 20, 20);
        draw = Draw(0, 0, text);
        active = false;
        enabled = false;
        size = { width = 0, height = 0 };

        dropdownOptions.append(this);
    }

    function setActive(val)
    {
        active = val;

        if (val == true)
        {
            tex.setColor(40, 40, 40);
            return;
        }

        tex.setColor(20, 20, 20);
    }

    function hover()
    {
        tex.setColor(40, 40, 40);
    }

    function unhover()
    {
        if (active)
        {
            tex.setColor(40, 40, 40);
            return;
        }

        tex.setColor(20, 20, 20);
    }

    function move(x, y)
    {
        local pos = tex.getPosition();
        local pos2 = draw.getPosition();

        tex.setPosition(pos.x + x, pos.y + y);
        draw.setPosition(pos2.x + x, pos2.y + y);
    }

    function setPosition(x, y)
    {
        tex.setPosition(x, y);
        draw.setPosition(x + 100, y + size.height / 2 - draw.height / 2);
    }

    function getPosition()
    {
        return tex.getPosition();
    }

    function getSize()
    {
        return tex.getSize();
    }

    function enable(val, x = 0, y = 0, width = 0, height = 0, ptY = 0)
    {
        if (val == true)
        {
            tex.setPosition(x, y);
            size = { width = width, height = height };
            tex.setSize(width, height - ptY);
            setPosition(x, y);

            if (ptY < 250)
            {
                draw.visible = true;
            }
            else
            {
                draw.visible = false;
            }
        }
        else
        {
            draw.visible = false;
        }

        if (enabled == val) return;

        tex.visible = val;
        enabled = val;
    }

    function top()
    {
        tex.top();
        draw.top();
    }
}

class Dropdown
{
    options = null;
    pos = null;
    size = null;
    tex = null;
    draw = null;
    expanded = null;
    slider = null;
    baseY = null;
    coverTex = null;
    optionsTex = null;
    optionsTexCover = null;
    visibleOptions = null;
    enabled = null;
    holdingSlider = null;
    selected = null;

    constructor(x, y, width, height, defaultText = "")
    {
        options = [];
        pos = { x = x, y = y };
        size = { width = width, height = height };

        tex = Texture(x, y, width, height, "DROPDOWN_BACKGROUND.TGA");
        tex.setColor(235, 235, 235);
        optionsTex = Texture(x, y + height, 0, 0, "SR_BLANK.TGA");
        optionsTexCover = Texture(x, y + height, 0, 0, "WINDOW_FRAME.TGA");
        optionsTex.setColor(20, 20, 20);
        draw = Draw(x, y, defaultText);
        draw.setPosition(x + width / 2 - draw.width / 2, y + height / 2 - draw.height / 2);

        expanded = false;
        enabled = false;
        holdingSlider = false;
        visibleOptions = 5;
        selected = -1;

        dropdowns.append(this);
    }

    function createSlider()
    {
        slider = Slider(pos.x + size.width - 200, pos.y + size.height + 100, size.height * 5 - 200, "SLIDER_BACKGROUND_VERTICAL.TGA", size.height * (options.len() - visibleOptions), "", "SLIDER_HANDLE.TGA", true, 150);
        coverTex = Texture(pos.x, pos.y + (visibleOptions + 1) * size.height, size.width, size.height / 2, "TEXTBOX_BACKGROUND.TGA");
        coverTex.setColor(235, 235, 235);
        optionsTex.setSize(size.width, size.height * visibleOptions);
        optionsTexCover.setSize(size.width, size.height * visibleOptions + 100);
    }

    function setPosition(x, y)
    {
        pos.x = x;
        pos.y = y;

        slider.setPosition(x + size.width - 200, y + size.height + 100);
        coverTex.setPosition(x, y + (visibleOptions + 1) * size.height);
        optionsTex.setPosition(x, y + size.height);
        optionsTexCover.setPosition(x, y + size.height);

        tex.setPosition(x, y);
        draw.setPosition(x + size.width / 2 - draw.width / 2, y + size.height / 2 - draw.height / 2);

        EscMenu.Top();
    }

    function addOption(text, config)
    {
        options.append({ option = DropdownOption(text), config = config });
        return options[options.len() - 1];
    }

    function getSelectedConfig()
    {
        return options[selected].config;
    }

    function setDropdownText(val)
    {
        draw.text = val;
        draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
    }

    function selectOption(i)
    {
        if (selected != -1)
        {
            options[selected].option.setActive(false);
        }

        selected = i;
        options[i].option.setActive(true);
        setDropdownText(options[i].option.draw.text);
    }

    function restore(v)
    {
        selectOption(v);
    }

    function setOptionsPosition(x, y)
    {
        optionsTex.top();

        foreach(i, v in options)
        {
            local calcY = y + size.height * (i + 1);
            local warY = pos.y + size.height * (visibleOptions + 1);
            if (calcY < pos.y || calcY > warY)
            {
                v.option.enable(false);
                continue;
            }

            local ptY = (calcY - (warY - size.height));
            ptY -= 10;
            if (ptY < 0) ptY = 0;

            v.option.enable(true, x, calcY, size.width - 350, size.height, ptY);

            v.option.top();
        }

        tex.top();
        draw.top();

        if (slider != null) slider.top();

        optionsTexCover.top();

        if (coverTex != null) coverTex.top();

    }

    function moveOptions(x, y)
    {
        foreach(v in options)
        {
            v.option.move(x, y);
        }
    }

    function enable(val)
    {
        tex.visible = val;
        draw.visible = val;

        if (val == false)
        {
            collapse();
        }

        enabled = val;
    }

    function expand()
    {
        if (expanded)
        {
            return collapse();
        }

        if (slider != null) slider.enable(true);
        if (coverTex != null) coverTex.visible = true;

        optionsTex.visible = true;
        optionsTexCover.visible = true;

        local calcY = (slider == null) ? 0 : slider.getValue();
        setOptionsPosition(pos.x, pos.y - calcY);

        expanded = true;
    }

    function collapse()
    {
        if (!expanded) return;

        foreach(v in options)
        {
            v.option.enable(false);
        }

        if (slider != null) slider.enable(false);
        if (coverTex != null) coverTex.visible = false;

        optionsTex.visible = false;
        optionsTexCover.visible = false;

        expanded = false;
    }

    function wasHoldingSlider()
    {
        return holdingSlider;
    }

    function getBottomY()
    {
        return (pos.y + size.height);
    }
}


function dropdownSlide(el)
{
    foreach(i, v in dropdowns)
    {
        if (el != v.slider) continue;

        v.holdingSlider = true;
        v.setOptionsPosition(v.pos.x, v.pos.y - v.slider.getValue())
    }
}

function dropdownRender()
{
    foreach(v in dropdowns)
    {
        if (v.options.len() == 0) continue;
        if (!v.expanded) continue;

        foreach(k in v.options)
        {
            if (inSquare(getCursorPosition(), k.option.getPosition(), k.option.getSize()))
            {
                k.option.hover();
                continue;
            }

            k.option.unhover();
        }
    }
}

function dropdownPress()
{
    foreach(i, v in dropdowns)
    {
        if (!v.enabled) continue;
        local collapsed = false;
        if (v.expanded)
        {
            if (getCursorPosition().y > v.pos.y + v.size.height)
            {
                foreach(j, k in v.options)
                {
                    if (inSquare(getCursorPosition(), k.option.getPosition(), k.option.getSize()))
                    {
                        pressedOption = j;
                        onPressDropdownOption(v, k, j);
                        return;
                    }
                }
            }

            if (!inSquare(getCursorPosition(), v.optionsTex.getPosition(), v.optionsTex.getSize()))
            {
                v.collapse();
                collapsed = true;
            }
        }

        if (inSquare(getCursorPosition(), v.pos, { width = v.size.width + 200, height = v.size.height }) && !collapsed)
        {
            pressed = i;
            return;
        }
    }
}

function dropdownRelease()
{
    foreach(i, v in dropdowns)
    {

        if (pressed == -1)
        {
            if (v.expanded && !inSquare(getCursorPosition(), v.optionsTex.getPosition(), v.optionsTex.getSize()) && v.holdingSlider == false)
            {
                v.collapse();
                EscMenu.Top();
            }
            else
            {
                if (v.holdingSlider == true)
                {
                    v.holdingSlider = false;
                }
            }

            continue;
        }

        if (inSquare(getCursorPosition(), v.pos, v.size))
        {
            v.expand();
            EscMenu.Top();
            pressed = -1;
            return;
        }
    }
}

function onPressDropdownOption(dropdown, option, id)
{
    dropdown.selectOption(id);
    dropdown.collapse();
    EscMenu.Top();
}