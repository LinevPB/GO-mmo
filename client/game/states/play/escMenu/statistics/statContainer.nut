local statsContainers = [];
local paddingLR = 100;
local paddingTB = 50;

class Stat
{
    statNameFrame = null;
    statNameDraw = null;
    valFrame = null;
    valDraw = null;
    pos = null;
    parent = null;

    constructor(x, y, name, val)
    {
        pos = { x = x, y = y };

        statNameDraw = Draw(pos.x, pos.y, name);
        statNameFrame = Texture(pos.x, pos.y, statNameDraw.width, statNameDraw.height, "TEXTBOX_BACKGROUND.TGA");
        valDraw = Draw(pos.x, pos.y, val);
        valFrame = Texture(pos.x, pos.y, statNameDraw.width, statNameDraw.height, "TEXTBOX_BACKGROUND.TGA");
    }

    function updatePosition(x, y, nameWidth, valWidth, height)
    {
        pos.x = x;
        pos.y = y;

        statNameFrame.setPosition(x, y);
        statNameFrame.setSize(nameWidth + paddingLR * 2, height);

        valFrame.setPosition(x + nameWidth + paddingLR * 2, y);
        valFrame.setSize(valWidth + paddingLR * 2, height);

        statNameDraw.setPosition(valFrame.getPosition().x - paddingLR - statNameDraw.width, y + height / 2 - statNameDraw.height / 2);
        valDraw.setPosition(valFrame.getPosition().x + valFrame.getSize().width / 2 - valDraw.width / 2, y + height / 2 - valDraw.height / 2);
    }

    function updateName(val)
    {
        statNameDraw.text = val;
    }

    function updateVal(val)
    {
        valDraw.text = val;
    }

    function enable(val)
    {
        statNameFrame.visible = val;
        valFrame.visible = val;

        statNameDraw.visible = val;
        valDraw.visible = val;
    }
}


class StatsContainer
{
    tex = null;
    draw = null;
    drawCover = null;
    pos = null;
    size = null;
    nameWidth = null;
    valWidth = null;

    statsContainer = null;

    constructor(x, y, width, height, name)
    {
        statsContainer = [];
        pos = { x = x, y = y };
        size = { width = width, height = height };

        tex = Texture(x, y, width, height, "WINDOW_BACKGROUND.TGA");
        draw = Draw(x, y, name);
        drawCover = Texture(x, y, draw.width + 200, draw.height + 100, "TEXTBOX_BACKGROUND.TGA");
        nameWidth = 0;
        valWidth = 0;

        statsContainers.append(this);
    }

    function getContainer()
    {
        return statsContainer;
    }

    function attach(val)
    {
        statsContainer.append(val);
        updateElementsPosition();
    }

    function setNameWidth(val)
    {
        nameWidth = val;
    }

    function setValWidth(val)
    {
        valWidth = val;
    }

    function setPosition(x, y)
    {
        pos.x = x;
        pos.y = y;

        tex.setPosition(x, y);

        updateElementsPosition();

        if (statsContainer.len() == 0) return;

        local temp = statsContainer[statsContainer.len() - 1];

        if (tex.getPosition().y + tex.getSize().height < temp.statNameFrame.getPosition().y + temp.statNameFrame.getSize().height + 200)
        {
            tex.setSize(temp.statNameFrame.getSize().width + temp.valFrame.getSize().width + paddingLR * 2, temp.pos.y - tex.getPosition().y + temp.statNameFrame.getSize().height + 200);
            size = tex.getSize();
        }

        refreshNamePosition();
    }

    function refresh()
    {
        setPosition(pos.x, pos.y);
    }

    function updateElementsPosition()
    {
        foreach(i, v in statsContainer)
        {
            v.updatePosition(pos.x + paddingLR, drawCover.getPosition().y + drawCover.getSize().height + 200 + 400 * i, nameWidth, valWidth, 400);
        }
    }

    function updateName(val)
    {
        draw.text = val;
        refreshNamePosition();
    }

    function refreshNamePosition()
    {
        drawCover.setSize(draw.width + 200, draw.height + 100);
        drawCover.setPosition(pos.x + tex.getSize().width / 2 - drawCover.getSize().width / 2, pos.y - drawCover.getSize().height / 4);
        draw.setPosition(drawCover.getPosition().x + drawCover.getSize().width / 2 - draw.width / 2, drawCover.getPosition().y + drawCover.getSize().height / 2 - draw.height / 2);
    }

    function enable(val)
    {
        tex.visible = val;
        drawCover.visible = val;
        draw.visible = val;

        foreach (v in statsContainer)
        {
            v.enable(val);
        }
    }
}

function getStatsContainers()
{
    return statsContainers;
}