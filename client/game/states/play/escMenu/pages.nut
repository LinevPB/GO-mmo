local containers = [];


class Page
{
    pages = null;
    constructor()
    {
        pages = [];
    }

    function addElement(el)
    {
        pages.append(el);
    }

    function enable(val)
    {
        foreach(v in pages)
        {
            v.enable(val);
        }
    }
}


class PageContainer
{
    page_draw = null;
    page_tex = null;
    leftArrow = null;
    rightArrow = null;
    leftHov = null;
    rightHov = null;
    pages = null;
    enabled = null;
    orgX = null;
    orgY = null;
    orgWidth = null;
    orgHeight = null;

    currentPage = null;

    constructor(x, y, width, height = 200)
    {
        orgX = x;
        orgY = y;
        orgWidth = width;
        orgHeight = height;

        page_draw = Draw(0, 0, "0/0");
        page_draw.setPosition(x + width / 2 - page_draw.width / 2, y + height / 2 - page_draw.height / 2);

        local pos = page_draw.getPosition();
        page_tex = Texture(pos.x - 100, pos.y - 50, page_draw.width + 200, page_draw.height + 100, "TEXTBOX_BACKGROUND.TGA");

        leftArrow = Texture(pos.x - 600, y, 200, 200, "R.TGA");
        leftArrow.rotation = 180;

        rightArrow = Texture(pos.x + 400 + page_draw.width, y, 200, 200, "R.TGA");

        pages = [];
        currentPage = 0;

        leftHov = false;
        rightHov = false;

        enabled = false;

        containers.append(this);
    }

    function addPage(el)
    {
        pages.append(el);

        updatePageDraw();
    }

    function removePage(i)
    {
        pages[i].enable(false);
        pages.remove(i);

        updatePageDraw();
    }

    function getPages()
    {
        return pages;
    }

    function getPagesCount()
    {
        return pages.len();
    }

    function getCurrentPage()
    {
        return currentPage;
    }

    function updatePageDraw(resize = true)
    {
        page_draw.text = (currentPage + 1) + "/" + pages.len();
        page_draw.setPosition(orgX + orgWidth / 2 - page_draw.width / 2, orgY + orgHeight / 2 - page_draw.height / 2);

        if (!resize) return;

        local pos = page_draw.getPosition();
        page_tex.setPosition(pos.x - 100, pos.y - 50);
        page_tex.setSize(page_draw.width + 200, page_draw.height + 100);
    }

    function enable(val)
    {
        if (pages.len() == 0) return;
        if (enabled == val) return;

        pages[currentPage].enable(val);

        leftArrow.visible = val;
        rightArrow.visible = val;

        page_tex.visible = val;
        page_draw.visible = val;

        enabled = val;
    }

    function hover(arr)
    {
        switch(arr)
        {
            case 0:
                if (leftHov) return;

                leftArrow.setColor(180, 180, 255);
                leftHov = true;
            break;

            case 1:
                if (rightHov) return;

                rightArrow.setColor(180, 180, 255);
                rightHov = true;
            break;
        }
    }

    function unhover(arr)
    {
        switch(arr)
        {
            case 0:
                if (!leftHov) return;

                leftArrow.setColor(255, 255, 255);
                leftHov = false;
            break;

            case 1:
                if (!rightHov) return;

                rightArrow.setColor(255, 255, 255);
                rightHov = false;
            break;
        }
    }

    function scrollPage(dodo)
    {
        if (!enabled) return;
        if (pages.len() == 0) return;

        local lastPage = currentPage;
        currentPage += dodo;

        if (currentPage < 0) currentPage = pages.len() - 1;
        if (currentPage >= pages.len()) currentPage = 0;

        if (lastPage == currentPage) return;

        pages[lastPage].enable(false);
        pages[currentPage].enable(true);

        updatePageDraw(false);
    }
}

local pressedPtr = null;
local id_pressed = -1;

function pageClick(key)
{
    if (key != MOUSE_BUTTONLEFT) return;

    local curs = getCursorPosition();
    foreach(v in containers)
    {
        local lpos = v.leftArrow.getPosition();
        local lsize = v.leftArrow.getSize();
        local rpos = v.rightArrow.getPosition();
        local rsize = v.rightArrow.getSize();

        if (inSquare(curs, lpos, lsize))
        {
            pressedPtr = v;
            id_pressed = 0;
        }

        if (inSquare(curs, rpos, rsize))
        {
            pressedPtr = v;
            id_pressed = 1;
        }
    }
}
addEventHandler("onMouseClick", pageClick);

function pageRelease(key)
{
    if (key != MOUSE_BUTTONLEFT) return;
    if (pressedPtr == null) return;

    local curs = getCursorPosition();

    local pos = 0;
    local size = 0;
    local dodo = 0;
    switch(id_pressed)
    {
        case 0:
            pos = pressedPtr.leftArrow.getPosition();
            size = pressedPtr.leftArrow.getSize();
            dodo = -1;
        break;

        case 1:
            pos = pressedPtr.rightArrow.getPosition();
            size = pressedPtr.rightArrow.getSize();
            dodo = 1;
        break;
    }

    if (inSquare(curs, pos, size))
    {
        pressedPtr.scrollPage(dodo);
    }

    pressedPtr = null;
    id_pressed = -1;
}
addEventHandler("onMouseRelease", pageRelease);

function pageRender()
{
    local curs = getCursorPosition();
    foreach(v in containers)
    {
        local lpos = v.leftArrow.getPosition();
        local lsize = v.leftArrow.getSize();
        local rpos = v.rightArrow.getPosition();
        local rsize = v.rightArrow.getSize();

        if (inSquare(curs, lpos, lsize))
        {
            v.hover(0);
        }
        else
        {
            v.unhover(0);
        }

        if (inSquare(curs, rpos, rsize))
        {
            v.hover(1);
        }
        else
        {
            v.unhover(1);
        }
    }
}
addEventHandler("onRender", pageRender);