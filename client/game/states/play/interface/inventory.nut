Inventory <- {};
local invEnabled = false;
local inv = {
    menu = null,
    menuItems = null,
    itemSlots = null,
    itemSlider = null,
    slots = null,
    oneMenu = null,
    twoMenu = null
};
local MAX_COLUMN = 3;
local MAX_ROW = 7;
local SIZE = 600;
local MAX_ITEMS = 3 * 30;
local coverTex1 = null;
local coverTex2 = null;

class InventorySlot
{
    btn = null;
    render = null;
    amount = null;
    instance = null;
    row = null;
    column = null;
    slot = null;
    enabledA = null;

    constructor(x, y, width, height, texture, textureActive)
    {
        local xel = 0.1;
        btn = Button(x, y, width, height, texture, "", textureActive);
        btn.centered = false;

        amount = null;
        instance = null;
        enabledA = false;
    }

    function isVisible()
    {
        return enabledA;
    }

    function enable(val)
    {
        if (val == true && isVisible()) return;
        if (val == false && !isVisible()) return;

        btn.enable(val);
        enabledA = val;

        if (instance == null) render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, "");
        else render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, instance);

        render.visible = val;
    }

    function setRender(instancea, amounta)
    {
        instance = instancea;
        amount = amounta;

        if (amount == 0 || amount == 1)
            btn.draw.text = "";
        else
            btn.draw.text = amount;

        btn.setDrawPosition(btn.size.width - btn.draw.width - 25, btn.size.height - btn.draw.height - 25);
    }

    function updatePos()
    {
        if (isVisible()) {
            render.setPosition(btn.pos.x, btn.pos.y);
        }
    }
}

function onSlidePlay(el)
{
    inv.menuItems.setPosition(inv.menuItems.baseX, inv.menuItems.baseY - el.getValue());

    foreach(v in inv.itemSlots) {
        if ((v.btn.pos.y + v.btn.size.height < v.btn.parent.baseY) || (v.btn.pos.y > v.btn.parent.baseY + MAX_ROW * SIZE))
            v.enable(false);
        else
            v.enable(true);

        v.updatePos();
    }

    coverTex1.top();
    coverTex2.top();
    inv.twoMenu.background.texture.top();
}

function invHover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
}

function invUnhover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
}

Inventory.Init <- function()
{
    local wW = 8192/2;
    local wH = 8192;
    local column = 0;
    local row = 0;

    inv.menu = Window(0, 0, wW, wH, "SR_BLANK.TGA");

    inv.menuItems = Window(200, SIZE, MAX_COLUMN * SIZE, MAX_ITEMS / MAX_COLUMN * SIZE, "SR_BLANK.TGA");
    inv.menuItems.setBackgroundColor(100, 100, 100);
    inv.menu.attach(inv.menuItems);

    inv.oneMenu = Window(MAX_COLUMN * SIZE + 600, SIZE, wW - MAX_COLUMN*SIZE - SIZE - 96, MAX_ROW * SIZE, "SR_BLANK.TGA");
    inv.oneMenu.setBackgroundColor(255, 255, 0);
    inv.menu.attach(inv.oneMenu);

    inv.twoMenu = Window(200, SIZE + MAX_ROW * SIZE, 4192 - 400, 8192 - (MAX_ROW - 2) * SIZE, "SR_BLANK.TGA");
    inv.twoMenu.setBackgroundColor(255, 255, 0);
    inv.menu.attach(inv.twoMenu);

    coverTex1 = Texture(200, 0, MAX_COLUMN*SIZE, SIZE, "SR_BLANK.TGA");
    coverTex1.setColor(0, 0, 0);
    coverTex2 = Texture(200, SIZE + MAX_ROW * SIZE, MAX_COLUMN * SIZE, 8192 - (MAX_ROW - 1) * SIZE, "SR_BLANK.TGA");
    coverTex2.setColor(0, 0, 0);

    inv.itemSlots = [];
    for (local i = 0; i < MAX_ITEMS; i++) {
        local temp = InventorySlot(SIZE * column, SIZE * row, SIZE, SIZE, "INV_TITEL.TGA", "INV_TITEL.TGA");
        temp.btn.setBackgroundRegularColor(90, 255, 90);
        temp.btn.setBackgroundHoverColor(255, 255, 0);
        temp.btn.rehover();
        temp.row = row;
        temp.column = column;
        temp.slot = i;
        temp.btn.more = temp;
        temp.setRender("", 0);

        inv.menuItems.attach(temp.btn);
        inv.itemSlots.append(temp);

        if (column == MAX_COLUMN - 1) {
            column = 0;
            row += 1;
            continue;
        }
        column++;
    }

    inv.itemSlider = Slider(MAX_COLUMN * SIZE + 300, SIZE, MAX_ROW * SIZE, "SR_BLANK.TGA", SIZE * (MAX_ITEMS / MAX_COLUMN - MAX_ROW), false, "MENU_MASKE.TGA", true);
    inv.menu.attach(inv.itemSlider);


    ////////////////////////////
    for (local i = 0; i < MAX_ITEMS; i++) {
        inv.itemSlots[i].setRender("", 0);
    }
}


local vob = Vob("nw_misc_big_tent_430p.3DS");
Inventory.Enable <- function(val)
{
    invEnabled = val;
    setFreeze(val);
    Camera.movementEnabled = !val;
    disableControls(val);
    setCursorVisible(val);
    inv.menu.enable(val);
    coverTex1.visible = val;
    coverTex2.visible = val;

    if (val == true) {
        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
        Camera.setPosition(30117, 5250, -15815);
        Camera.setRotation(0, -90, 0);
        vob.addToWorld();
        vob.setPosition(29912, 5246, -15710);
        vob.floor();
        vob.physicsEnabled = val;
        setPlayerPosition(Player.helper, 29912, 5246, -15710);
        setPlayerAngle(Player.helper, 140);
        inv.menu.setBackgroundColor(0, 0, 0);

        foreach(i, v in Player.items) {
            inv.itemSlots[i].setRender(v.instance, v.amount);
        }

        onSlidePlay(inv.itemSlider);
    } else {
        for (local i = 0; i < MAX_ITEMS; i++) {
            inv.itemSlots[i].setRender("", 0);
        }
        setHudMode(HUD_ALL, HUD_MODE_DEFAULT);
        vob.removeFromWorld();
        foreach(v in inv.itemSlots) {
            v.enable(false);
        }
    }
}