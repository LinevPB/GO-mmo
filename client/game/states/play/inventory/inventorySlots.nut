local itemMenu = null;
function getItemMenu()
{
    return itemMenu;
}

local itemSlots = null;
function getItemSlots()
{
    return itemSlots;
}

local itemSlider = null;
function getItemSlider()
{
    return itemSlider;
}

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
    alpha = null;
    equipped = null;

    constructor(x, y, width, height, texture, textureActive)
    {
        local xel = 0.1;
        btn = Button(x, y, width, height, texture, "", textureActive);
        btn.centered = false;
        btn.outer_release = true;

        amount = null;
        instance = null;
        alpha = false;
        enabledA = false;
        btn.more = this;
        equipped = false;
        render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, "");
    }

    function reset()
    {
        amount = null;
        instance = null;
    }

    function setAlpha(val)
    {
        alpha = val;
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
        invUnhover(this.btn);

        render.visible = val;

        if (val == false)
        {
            render.setPosition(0, 0);
        }
        else
        {
            render.setPosition(btn.pos.x, btn.pos.y);
        }
    }

    function setRender(instancea, amounta)
    {
        instance = instancea;
        amount = amounta;

        if (amount == 0 || amount == 1)
            btn.draw.text = "";
        else
            btn.draw.text = "x" + amount;

        btn.setDrawPosition(btn.size.width - btn.draw.width - 25, btn.size.height - btn.draw.height - 25);

        if (render == null && btn.enabled)
        {
            render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, instance);
            render.lightingswell = true;
            render.visible = false;
        }

        if (render == null) return;
        if (render != null)
            render.instance = instance;

        if (render.visible == false && btn.enabled)
            render.visible = true;
    }

    function updatePos()
    {
        if (isVisible()) {
            render.setPosition(btn.pos.x, btn.pos.y);
        }
    }
}

function handleSlideSlots(el)
{
    itemMenu.setPosition(itemMenu.baseX, itemMenu.baseY - el.getValue());

    foreach(v in itemSlots)
    {
        if ((v.btn.pos.y + v.btn.size.height < invY) || (v.btn.pos.y > 8192 - 392))
            v.enable(false);
        else
            v.enable(true);

        v.updatePos();
    }
}

function handleSlotsRelease()
{

}

function setupInventorySlots()
{
    itemMenu = Window(200, invY, Inventory.MAX_COLUMN * Inventory.SIZE, Inventory.MAX_ITEMS / Inventory.MAX_COLUMN * Inventory.SIZE, "SR_BLANK.TGA");
    itemMenu.setBackgroundColor(75, 75, 100);
    getMainMenu().attach(itemMenu);
}

function getRawSlot(slot)
{
    foreach(v in itemSlots)
    {
        if (slot == v.slot)
        {
            return v;
        }
    }
}

function getInvSlots()
{
    return itemSlots;
}

function setupItemSlider()
{
    itemSlider = Slider(Inventory.MAX_COLUMN * Inventory.SIZE + 300,  350, getMainMenu().size.height - invY * 2 - 150, "TEXTBOX_BACKGROUND.TGA", Inventory.SIZE * (Inventory.MAX_ITEMS / Inventory.MAX_COLUMN - 12), "", "SLIDER_HANDLE.TGA", true);
    getMainMenu().attach(itemSlider);
}

function initializeItemRenders()
{
    for (local i = 0; i < Inventory.MAX_ITEMS; i++)
    {
        itemSlots[i].setRender("", 0);
    }
}

function initializeInventorySlots()
{
    local column = 0;
    local row = 0;
    itemSlots = [];
    for (local i = 0; i < Inventory.MAX_ITEMS; i++) {
        local temp = InventorySlot(Inventory.SIZE * column, Inventory.SIZE * row, Inventory.SIZE, Inventory.SIZE, "INVENTORY_SLOT.TGA", "INVENTORY_SLOT_HIGHLIGHTED.TGA");
        temp.btn.rehover();
        temp.row = row;
        temp.column = column;
        temp.slot = i;
        temp.btn.more = temp;
        temp.setRender("", 0);

        itemMenu.attach(temp.btn);
        itemSlots.append(temp);

        if (column == Inventory.MAX_COLUMN - 1) {
            column = 0;
            row += 1;
            continue;
        }
        column++;
    }
}

function moveItems(btn1, id1, btn2, id2)
{
    local temp1 = itemSlots[id1].instance;
    local temp2 = itemSlots[id1].amount;

    itemSlots[id1].setRender(itemSlots[id2].instance, itemSlots[id2].amount);
    itemSlots[id2].setRender(temp1, temp2);
    Player.moveItems(id1, id2);
    updateInvEqColor();
}

function updateInvEqColor()
{
    foreach(v in itemSlots) {
        if (v.equipped) {
            v.btn.background.regular = "INVENTORY_SLOT_EQUIPPED.TGA";
            v.btn.background.hover = "INVENTORY_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
        } else {
            v.btn.background.regular = "INVENTORY_SLOT.TGA";
            v.btn.background.hover = "INVENTORY_SLOT_HIGHLIGHTED.TGA";
        }
        v.btn.rehover();
    }
}

function handleEquip(slot, instance, val)
{
    if (val) return invEquip(slot, instance);
    invUnequip(slot, instance);
}

function invEquip(slot, instance)
{
    if (instance == "" || instance == null) return false;

    local item = Daedalus.instance(instance);
    switch(slot)
    {
        case 0:
            if (item.mainflag == 2)
            {
                Player.eqWeapon = instance;
                equipItem(Player.helper, Items.id(instance));
                Player.refreshEq(2);
                updateInvEqColor();
                return true;
            }
        break;

        case 1:
            if (item.mainflag == 4)
            {
                Player.eqWeapon2h = instance;
                equipItem(Player.helper, Items.id(instance));
                Player.refreshEq(4);
                updateInvEqColor();
                return true;
            }
        break;

        case 2:
            if (item.mainflag == 16)
            {
                Player.eqArmor = instance;
                equipItem(Player.helper, Items.id(instance));
                Player.refreshEq(16);
                updateInvEqColor();
                return true;
            }
        break;

        case 3:
            break;
        case 4:
            Player.qa[0] = instance;
            Player.refreshQA(1);
            return true;
            break;
        case 5:
            Player.qa[1] = instance;
            Player.refreshQA(2);
            return true;
            break;
        case 6:
            Player.qa[2] = instance;
            Player.refreshQA(3);
            return true;
            break;
        case 7:
            Player.qa[3] = instance;
            Player.refreshQA(4);
            return true;
            break;
    }
}

function invUnequip(slot, instance)
{
    switch(slot)
    {
        case 0:
            Player.eqWeapon = "";
            unequipItem(Player.helper, Items.id(instance));
            Player.refreshEq(2);
            updateInvEqColor();
            break;
        case 1:
            Player.eqWeapon2h = "";
            unequipItem(Player.helper, Items.id(instance));
            Player.refreshEq(4);
            updateInvEqColor();
            break;
        case 2:
            Player.eqArmor = "";
            unequipItem(Player.helper, Items.id(instance));
            Player.refreshEq(16);
            updateInvEqColor();
            break;

        case 3:
            break;
        case 4:
            Player.qa[0] = "";
            Player.refreshQA(1);
            return true;
            break;
        case 5:
            Player.qa[1] = "";
            Player.refreshQA(2);
            return true;
            break;
        case 6:
            Player.qa[2] = "";
            Player.refreshQA(3);
            return true;
            break;
        case 7:
            Player.qa[3] = "";
            Player.refreshQA(4);
            return true;
            break;
    }
}

function handleItemMenuRender()
{
    if (TradeBox.IsEnabled()) return;

    foreach(v in itemSlots)
    {
        if (v.render == null)
        {
            continue;
        }

        if (v.equipped)
        {
            if (v.render.instance == "")
            {
                v.equipped = false;
                updateInvEqColor();
                continue;
            }
            if (v.render.instance != Player.eqArmor && v.render.instance != Player.eqWeapon && v.render.instance != Player.eqWeapon2h)
            {
                v.equipped = false;
                updateInvEqColor();
                continue;
            }
        }
        else
        {
            if (v.render.instance == Player.eqArmor || v.render.instance == Player.eqWeapon || v.render.instance == Player.eqWeapon2h)
            {
                if (v.render.instance == "")
                {
                    continue;
                }

                v.equipped = true;
                updateInvEqColor();
            }
        }
    }
}