local players = [];
local sets = [];
local pList = null;
local playersCont = null;

local pFrame = null;

local idFrame = null;
local idFrameDraw = null;

local nameFrame = null;
local nameFrameDraw = null;

local pingFrame = null;
local pingFrameDraw = null;

local playerListEnabled = false;

local kickBtn = null;
local banBtn = null;
local controlId = -1;

local isMod = false;

function setIsMod(val)
{
    isMod = val;
}

class controlBtn
{
    btn = null;

    constructor(x, y, text, color = { r = 200, g = 20, b = 20 })
    {
        btn = Button(x, y, 400, 180, "BUTTON_BACKGROUND.TGA", text, "BUTTON_BACKGROUND.TGA");
        btn.setBackgroundRegularColor(color.r, color.g, color.b);
        btn.setBackgroundHoverColor(color.r - 20, color.g - 20, color.b - 20);
        btn.rehover();
    }

    function enable(val)
    {
        return btn.enable(val);
    }

    function getId()
    {
        return btn.id;
    }

    function setPosition(x, y)
    {
        return btn.setPosition(x, y);
    }
}

class playerRow
{
    pid = null;

    idTex = null;
    idDraw = null;

    nameTex = null;
    nameDraw = null;

    pingTex = null;
    pingDraw = null;

    pos = null;
    enabled = null;

    constructor(x, y, id = -1)
    {
        pid = id;
        pos = { x = x, y = y};

        idTex = Texture(x, y, 400, 250, "TEXTBOX_BACKGROUND.TGA");
        nameTex = Texture(x + 400, y, 2500, 250, "TEXTBOX_BACKGROUND.TGA");
        pingTex = Texture(x + 2900, y, 700, 250, "TEXTBOX_BACKGROUND.TGA");

        idDraw = Draw(x, y, "0");
        nameDraw = Draw(x + 400, y, "Konstantynopolitańczykowianeczka");
        pingDraw = Draw(x + 2900, y, "120ms");

        updateRow();

        enabled = false;
    }

    function getSize()
    {
        return { width = 3600, height = 250 };
    }

    function enable(val)
    {
        idTex.visible = val;
        nameTex.visible = val;
        pingTex.visible = val;

        idDraw.visible = val;
        nameDraw.visible = val;
        pingDraw.visible = val;

        enabled = val;
    }

    function updateRow()
    {
        if (pid == -1)
        {
            idDraw.text = "";
            nameDraw.text = "";
            pingDraw.text = "";

            return;
        }

        idDraw.text = pid;
        nameDraw.text = getPlayerName(pid);
        pingDraw.text = getPlayerPing(pid) + "ms";

        updatePosition();
    }

    function updatePosition()
    {
        idDraw.setPosition(idTex.getPosition().x + idTex.getSize().width / 2 - idDraw.width / 2, idTex.getPosition().y + idTex.getSize().height / 2 - idDraw.height / 2);
        nameDraw.setPosition(nameTex.getPosition().x + 200, nameTex.getPosition().y + nameTex.getSize().height / 2 - nameDraw.height / 2);
        pingDraw.setPosition(pingTex.getPosition().x + pingTex.getSize().width / 2 - pingDraw.width / 2, pingTex.getPosition().y + pingTex.getSize().height / 2 - pingDraw.height / 2);
    }

    function updateId(id)
    {
        pid = id;
        updateRow();
    }

    function destroy()
    {
        if (enabled)
        {
            enable(false);
        }

        idTex = null;
        idDraw = null;

        nameTex = null;
        nameDraw = null;

        pingTex = null;
        pingDraw = null;
    }

    function enableControls(val)
    {
        if (pid == -1) return;
        if (pid == controlId) return;
        if (!isMod) return;

        kickBtn.setPosition(pos.x + 1900, pos.y + 35);
        banBtn.setPosition(pos.x + 2400, pos.y + 35);

        kickBtn.enable(val);
        banBtn.enable(val);
        controlId = pid;
    }
}


class playerSet
{
    pos = null;
    height = null;
    rowHeight = null;
    rows = null;

    constructor(x, y, _height, _rowHeight)
    {
        pos = { x = x, y = y };
        height = _height;
        rowHeight = _rowHeight;
        rows = [];

        local count = _height / _rowHeight;
        for(local i = 0; i < count; i++)
        {
            rows.append(playerRow(x, y + _rowHeight * i));
        }

        sets.append(this);
    }

    function enable(val)
    {
        foreach(v in rows)
        {
            v.enable(val);
        }
    }

    function getRows()
    {
        return rows;
    }

    function update()
    {
        foreach(v in rows)
        {
            v.updateRow();
        }
    }

    function clear()
    {
        foreach(v in rows)
        {
            v.updateId(-1);
        }
    }

    function destroy()
    {
        foreach(v in rows)
        {
            v.destroy();
        }
    }

    function isClear()
    {
        foreach(v in rows)
        {
            if (v.pid == -1) continue;

            return false;
        }

        return true;
    }
}


function initPlayerList()
{
    local pos = { x = 2200, y = 1500 };
    local size = { width = 3600, height = 4250 };

    pList = provWindow(2000, 1000, 4000, 6000);
    pList.setTitle(lang["PLAYER_LIST"][Player.lang]);

    local page1 = Page();
    local page2 = Page();

    page1.addElement(playerSet(pos.x, pos.y + 250, size.height - 250, 250));
    page2.addElement(playerSet(pos.x, pos.y + 250, size.height - 250, 250));

    playersCont = PageContainer(2000, 6150, 4000);
    playersCont.addPage(page1);
    playersCont.addPage(page2);

    pFrame = Texture(pos.x, pos.y, size.width, size.height, "WINDOW_BACKGROUND_SF.TGA");

    idFrame = Texture(pos.x, pos.y, 400, 250, "TEXTBOX_BACKGROUND.TGA");
    idFrame.setColor(200, 200, 200);

    nameFrame = Texture(pos.x + 400, pos.y, 2500, 250, "TEXTBOX_BACKGROUND.TGA");
    nameFrame.setColor(200, 200, 200);

    pingFrame = Texture(pos.x + 2900, pos.y, 700, 250, "TEXTBOX_BACKGROUND.TGA");
    pingFrame.setColor(200, 200, 200);

    idFrameDraw = Draw(pos.x, pos.y + 20, lang["ID"][Player.lang]);
    nameFrameDraw = Draw(pos.x + 400, pos.y + 20, lang["NAME"][Player.lang]);
    pingFrameDraw = Draw(pos.x + 2900, pos.y + 20, lang["PING"][Player.lang]);

    idFrameDraw.setPosition(idFrame.getPosition().x + idFrame.getSize().width / 2 - idFrameDraw.width / 2, idFrame.getPosition().y + idFrame.getSize().height / 2 - idFrameDraw.height / 2);
    pingFrameDraw.setPosition(pingFrame.getPosition().x + pingFrame.getSize().width / 2 - pingFrameDraw.width / 2, pingFrame.getPosition().y + pingFrame.getSize().height / 2 - pingFrameDraw.height / 2);
    nameFrameDraw.setPosition(nameFrame.getPosition().x + 200, nameFrame.getPosition().y + nameFrame.getSize().height / 2 - nameFrameDraw.height / 2);

    kickBtn = controlBtn(0, 0, "Kick", { r = 180, g = 180, b = 255 });
    banBtn = controlBtn(0, 0, "Ban");

    handlePlayerSpawnList(heroId);
}

function enablePlayerList(val)
{
    pList.enable(val);

    pFrame.visible = val;

    idFrame.visible = val;
    nameFrame.visible = val;
    pingFrame.visible = val;

    idFrameDraw.visible = val;
    nameFrameDraw.visible = val;
    pingFrameDraw.visible = val;

    playersCont.enable(val);

    if (val == true)
    {
        foreach(v in sets)
        {
            v.update();
        }
    }
    else
    {
        kickBtn.enable(false);
        banBtn.enable(false);
        if (controlId != -1) controlId = -1;
    }

    playerListEnabled = val;
}

function isPlayerListEnabled()
{
    return playerListEnabled;
}

function scanSets()
{
    foreach(i, v in sets)
    {
        if (!v.isClear()) continue;

        playersCont.removePage(i);
        v.destroy();
        sets.remove(i);
    }
}

function handlePlayerSpawnList(id = -1)
{
    if (id == -1) id = heroId;

    players.append(id);
    players.sort();

    foreach(v in sets)
    {
        v.clear();
    }

    foreach(i, pid in players)
    {
        local column = (i + 1) / 16;
        local row = (i + 1) % 16;

        if (column + 1 > sets.len())
        {
            local page1 = Page();
            page1.addElement(playerSet(pos.x, pos.y + 250, size.height - 250, 250));
            playersCont.addPage(page1);
        }

        sets[column].getRows()[row - 1].updateId(pid);
    }

    scanSets();
}
addEventHandler("onPlayerSpawn", handlePlayerSpawnList);

function handlePlayerUnspawnList(id)
{
    foreach(i, v in players)
    {
        if (v != id) continue;

        players.remove(i);
        break;
    }

    players.sort();
    scanSets();
}

function playerListRender()
{
    if (!playerListEnabled) return;

    local page = playersCont.getCurrentPage();
    if (page == -1) return;

    local curs = getCursorPosition();
    foreach(v in sets[page].getRows())
    {
        if (inSquare(curs, v.pos, v.getSize()) && v.pid != -1)
        {
            v.enableControls(true);
            return;
        }
    }

    kickBtn.enable(false);
    banBtn.enable(false);
    if (controlId != -1) controlId = -1;
}
addEventHandler("onRender", playerListRender);

function playerListBtn(id)
{
    if (controlId == -1) return;

    switch(id)
    {
        case kickBtn.getId():
            sendPacket(PacketType.KICK, controlId);
        break;

        case banBtn.getId():
            sendPacket(PacketType.BAN, controlId);
        break;
    }
}