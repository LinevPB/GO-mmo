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
local coverTex11 = null;
local coverTex2 = null;
local coverTex22 = null;
local coverTex3 = null;
local coverTex33 = null;
local coverTex4 = null;

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

        if (instance == null) render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, "");
        else render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, instance);

        render.visible = val;

        if (alpha) {
            render.lightingswell = true;
        } else {
            render.lightingswell = true;
        }
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

        if (render == null && btn.enabled) {
            render = ItemRender(btn.pos.x, btn.pos.y, btn.size.width, btn.size.height, instance);
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

local showcaseTex = Texture(0, 0, 2000, 2300, "SR_BLANK.TGA");
local showcaseId = -1;
local showcaseName = Draw(0, 0, "Laga");
local showcaseRender = ItemRender(200, 1200, 1000, 1000, "");
local showcaseAdd1 = Draw(0, 0, "Obrażenia: ");
local showcaseAdd2 = Draw(0, 0, "Obrażenia: ");
local showcaseAdd3 = Draw(0, 0, "Obrażenia: ");
local showcaseAdd4 = Draw(0, 0, "Obrażenia: ");
local itemR = ItemRender(0, 0, 600, 600, "");
local isclicked = false;

local x1 = MAX_COLUMN * SIZE + 600;
local y1 = SIZE + 350;
local w1 = 8192/2 - MAX_COLUMN*SIZE - SIZE - 96;
local calw1 = (w1-SIZE-100-SIZE)/2;
local labs = [];

local lab1 = Draw(x1, y1, "Weapons");
labs.append(InventorySlot(x1 + calw1, y1 + lab1.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + lab1.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

local lab3 = Draw(x1,
    y1 + 1000, "Armor");
labs.append(InventorySlot(x1 + calw1, y1 + 1000 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 1000 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

local lab5 = Draw(x1,
    y1 + 2000, "Quick access");
labs.append(InventorySlot(x1 + calw1, y1 + 2000 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 2000 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
labs.append(InventorySlot(x1 + calw1, y1 + 2800 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));
labs.append(InventorySlot(x1 + calw1 + SIZE + 100, y1 + 2800 + lab3.height + 50,
    SIZE, SIZE, "INV_SLOT_EQUIPPED.TGA", "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA"));

local esc_lab = Draw(200, 8000, "(ESC) Press to resume");
local gold_lab = Draw(0, 0, "Gold: ");
local sec_gold_lab = Draw(0, 0, "0");
local big_inv_title = Draw(0, 0, "Inventory");
local big_stat_title = Draw(0, 0, "Statistics");
local showcaseEl = null;

function updateInvEqColor()
{
    foreach(v in inv.itemSlots) {
        if (v.instance == "" || v.instance == null) continue;
        if (v.instance.toupper() == Player.eqArmor.toupper() || v.instance.toupper() == Player.eqWeapon.toupper() || v.instance.toupper() == Player.eqWeapon2h.toupper()) {
            //v.btn.setBackgroundRegularColor(200, 50, 50);
            v.btn.background.regular = "INV_SLOT_EQUIPPED.TGA";
            v.btn.background.hover = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
        } else {
            //v.btn.setBackgroundRegularColor(255, 255, 255);
            v.btn.background.regular = "INV_SLOT.TGA";
            v.btn.background.hover = "INV_SLOT_HIGHLIGHTED.TGA";
        }
        v.btn.rehover();
    }
}

function invHover(el)
{
    if (isclicked) return;
    if (el.elementType != ElementType.BUTTON) return;
    if (el.more == null) return;
    if (el.more.instance == null || el.more.instance == "") return;

    showcaseRender.instance = el.more.render.instance;
    if (showcaseRender.instance == "") return;

    showcaseTex.visible = true;
    showcaseId = el.id;
    showcaseName.visible = true;
    showcaseName.text = getItemName(showcaseRender.instance);
    showcaseRender.visible = true;
    showcaseName.setColor(100, 255, 100);
    showcaseTex.setColor(10, 10, 60);
    showcaseRender.lightingswell = true;
    showcaseRender.rotX = -30;
    showcaseRender.rotZ = 0;
    showcaseRender.rotY = 0;
    showcaseEl = el;

    local item = Daedalus.instance(showcaseRender.instance);
    // foreach(i, v in item) {
    //     if (typeof v == "array") {
    //         foreach(l, k in v) {
    //            if (k != 0) print(i + " : " + k + " : " + l);
    //         }
    //     }
    // }

    switch(item.mainflag) {
        case 2:
        case 4:
            showcaseAdd1.text = "";
            showcaseAdd2.text = "";
            showcaseAdd3.text = item.text[2] + ": " + item.count[2];
            showcaseAdd4.text = item.text[3] + " " + item.count[3];
        break;
        case 16:
            showcaseAdd1.text = item.text[1] + " " + item.count[1];
            showcaseAdd2.text = item.text[2] + " " + item.count[2];
            showcaseAdd3.text = item.text[3] + " " + item.count[3];
            showcaseAdd4.text = item.text[4] + " " + item.count[4];
        break;
        case 32:
            showcaseAdd1.text = "";
            showcaseAdd2.text = "";
            showcaseAdd3.text = "";
            showcaseAdd4.text = "";
        break;
        default:
            showcaseAdd1.text = "";
            showcaseAdd2.text = "";
            showcaseAdd3.text = "";
            showcaseAdd4.text = description;
        break;
    }
    showcaseAdd1.setColor(190, 190, 190);
    showcaseAdd1.visible = true;
    showcaseAdd2.setColor(190, 190, 190);
    showcaseAdd2.visible = true;
    showcaseAdd3.setColor(190, 190, 190);
    showcaseAdd3.visible = true;
    showcaseAdd4.setColor(190, 190, 190);
    showcaseAdd4.visible = true;

    onElementRender(el);
}

function invUnhover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
    if (showcaseId == el.id) {
        showcaseTex.visible = false;
        showcaseName.visible = false;
        showcaseRender.visible = false;
        showcaseAdd1.visible = false;
        showcaseAdd2.visible = false;
        showcaseAdd3.visible = false;
        showcaseAdd4.visible = false;
    }
}

local oler = false;
local slid = -1;
function playClickButtonHandler(id)
{
    if (!invEnabled) return;
    local temp = null;
    foreach(i, v in inv.itemSlots) {
        if (v.btn.id == id) {
            temp = v;
            slid = i;
            break;
        }
    }

    foreach(v in labs) {
        if (v.btn.id == id) {
            temp = v;
            oler = v;
            break;
        }
    }

    if (temp == null) return;
    itemR.instance = temp.render.instance;
    itemR.visible = true;
    isclicked = true;
    showcaseEl = temp;
    if (showcaseTex.visible == true) invUnhover({id = id, elementType = ElementType.BUTTON});
    onElementRender(temp.btn)
}

function invEquip(slot, instance)
{
    local item = Daedalus.instance(instance);
    switch(slot) {
        case 0:
            if (item.mainflag == 2) {
                Player.eqWeapon = instance;
                equipItem(Player.helper, Items.id(instance));
                Player.refreshEq(2);
                updateInvEqColor();
                return true;
            }
            break;
        case 1:
            if (item.mainflag == 4) {
                Player.eqWeapon2h = instance;
                equipItem(Player.helper, Items.id(instance));
                Player.refreshEq(4);
                updateInvEqColor();
                return true;
            }
            break;

        case 2:
            if (item.mainflag == 16) {
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
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
    }
}

function invUnequip(slot, instance)
{
    switch(slot) {
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
    }
}

function moveItems(btn1, id1, btn2, id2)
{
    local temp1 = inv.itemSlots[id1].instance;
    local temp2 = inv.itemSlots[id1].amount;

    inv.itemSlots[id1].setRender(inv.itemSlots[id2].instance, inv.itemSlots[id2].amount);
    inv.itemSlots[id2].setRender(temp1, temp2);
    Player.moveItems(id1, id2);
}

function INVplayButtonHandler(id)
{
    if (!invEnabled) return;
    if (isclicked) {
        itemR.visible = false;
        isclicked = false;

        local curs = getCursorPosition();
        local temp = null;
        local found = -1;

        foreach(i, v in labs) {
            if (oler) {
                if (v.btn.id == oler.btn.id) {
                    if (!inSquare(getCursorPosition(), v.btn.pos, v.btn.size)) {
                        v.render.instance = "";
                        oler = false;
                        return invUnequip(i, itemR.instance);
                    }
                    oler = false;
                    break;
                }
            }
            if (inSquare(getCursorPosition(), v.btn.pos, v.btn.size)) {
                temp = v;
                found = i;
                break;
            }
        }

        foreach(i, v in inv.itemSlots) {
            if (inSquare(getCursorPosition(), v.btn.pos, v.btn.size)) {
                moveItems(v, i, showcaseEl, slid);
                showcaseEl = null;
                slid = -1;
                return;
            }
        }

        if (temp == null) return;
        if (!temp.btn.enabled) return;
        showcaseEl = null;

        if (invEquip(found, itemR.instance)) {
            temp.render.instance = itemR.instance;
        }
    }
}

function onElementRender(el)
{
    if (!invEnabled) return;
    if (showcaseTex.visible) {
        local curs = getCursorPosition();
        showcaseTex.setPosition(curs.x, curs.y);
        showcaseName.setPosition(curs.x + 1000 - showcaseName.width / 2, curs.y + 100);
        showcaseRender.setPosition(curs.x + 500, curs.y + showcaseName.height + 50);
        showcaseAdd1.setPosition(curs.x + 100, showcaseRender.getPosition().y + showcaseRender.getSize().height + 50);
        showcaseAdd2.setPosition(curs.x + 100, showcaseAdd1.getPosition().y + showcaseAdd1.height + 50);
        showcaseAdd3.setPosition(curs.x + 100, showcaseAdd2.getPosition().y + showcaseAdd2.height + 50);
        showcaseAdd4.setPosition(curs.x + 100, showcaseAdd3.getPosition().y + showcaseAdd3.height + 50);
        showcaseRender.rotY += 1;
    }

    if (isclicked) {
        local curs = getCursorPosition();
        local size = itemR.getSize();
        itemR.setPosition(curs.x - size.width / 2, curs.y - size.height / 2);
    }
}

function test_inv()
{

    //InventorySlot(x, y, width, height, texture, textureActive)
}
local gold_cover_tex = null;

function test_inv_s()
{
    lab1.visible = true;
    lab3.visible = true;
    lab5.visible = true;

    lab1.setPosition(x1 + w1/2 - lab1.width / 2, y1);
    lab3.setPosition(x1 + w1/2 - lab3.width / 2, y1 + 1000);
    lab5.setPosition(x1 + w1/2 - lab5.width / 2, y1 + 2000);


    foreach(i, v in labs)
    {
        if (i == 0) v.setRender(Player.eqWeapon, 0);
        if (i == 1) v.setRender(Player.eqWeapon2h, 0);
        if (i == 2) v.setRender(Player.eqArmor, 0);

        v.enable(true);
    }

    esc_lab.visible = true;
    esc_lab.setColor(180, 200, 220);
    esc_lab.setPosition(200, coverTex3.getPosition().y + coverTex3.getSize().height / 2 - esc_lab.height / 2);

    gold_lab.visible = true;
    gold_lab.setColor(255, 255, 255);
    gold_lab.setPosition(50 + inv.oneMenu.pos.x, inv.oneMenu.pos.y - gold_lab.height);
    sec_gold_lab.visible = true;
    sec_gold_lab.setColor(255, 150, 0);
    sec_gold_lab.setPosition(gold_lab.getPosition().x + gold_lab.width, inv.oneMenu.pos.y - gold_lab.height);

    gold_cover_tex.visible = true;
    gold_cover_tex.setPosition(inv.oneMenu.pos.x, inv.oneMenu.pos.y - gold_lab.height - 25);
    gold_cover_tex.setSize(inv.oneMenu.size.width, gold_lab.height + 25);

    big_inv_title.visible = true;
    big_inv_title.font = "FONT_OLD_20_WHITE_HI.TGA";
    big_inv_title.setColor(255, 250, 250);
    big_inv_title.setPosition(8192/4 - big_inv_title.width / 2, coverTex1.getPosition().y + coverTex1.getSize().height / 2 - big_inv_title.height / 2);

    big_stat_title.visible = true;
    big_stat_title.font = "FONT_OLD_20_WHITE_HI.TGA";
    big_stat_title.setColor(255, 250, 250);
    big_stat_title.setPosition(8192/4 - big_inv_title.width / 2, coverTex2.getPosition().y + coverTex2.getSize().height / 2 - big_stat_title.height / 2);
}

function off_inv_s()
{
    lab1.visible = false;
    lab3.visible = false;
    lab5.visible = false;
    foreach(i, v in labs){
        v.enable(false);
    }
    esc_lab.visible = false;
    gold_cover_tex.visible = false;
    gold_lab.visible = false;
    big_inv_title.visible = false;
    big_stat_title.visible = false;
    sec_gold_lab.visible = false;
}

local draws = [
    Draw(0, 0, "Name: Michael"),
    Draw(0, 0, "Level: 20"),
    Draw(0, 0, "Experience: 1944/2137"),
    Draw(0, 0, ""),
    Draw(0, 0, "Health: 1950/2000"),
    Draw(0, 0, "Mana: 500/500"),
    Draw(0, 0, "Strength: 0"),
    Draw(0, 0, "Dexterity: 0"),
    Draw(0, 0, "Skill 1h: 0"),
    Draw(0, 0, "Skill 2h: 0"),
    Draw(0, 0, "Skill Bow: 0"),
    Draw(0, 0, "Skill Crossbow: 0")
    //Draw(0, 0, "Strength: 0"),
];

function updateDraws()
{
    draws[0].text = "Name: " + getPlayerName(heroId);
    draws[1].text = "Level: " + getPlayerLevel(heroId);
    draws[2].text = "Experience: " + getExp() + "/" + getNextLevelExp();
    draws[3].text = ""
    draws[4].text = "Health: " + getPlayerHealth(heroId) + "/" + getPlayerMaxHealth(heroId);
    draws[5].text = "Mana: " + getPlayerMana(heroId) + "/" + getPlayerMaxMana(heroId);
    draws[6].text = "Strength: " + getPlayerStrength(heroId);
    draws[7].text = "Dexterity: " + getPlayerDexterity(heroId);
    draws[8].text = "Skill 1h: " + getPlayerSkillWeapon(heroId, WEAPON_1H);
    draws[9].text = "Skill 2h: " + getPlayerSkillWeapon(heroId, WEAPON_2H);
    draws[10].text = "Skill Bow: " + getPlayerSkillWeapon(heroId, WEAPON_BOW);
    draws[11].text = "Skill Crossbow: " + getPlayerSkillWeapon(heroId, WEAPON_CBOW);

    local res = "";
    local temp = Player.gold + "";
    while(temp.len() > 3) {
        res = "," + temp.slice(temp.len() - 3, temp.len()) + res;
        temp = temp.slice(0, temp.len() - 3);
    }
    res = temp + res;

    gold_lab.text = "Gold: ";
    sec_gold_lab.text = res;
}

function onSlidePlay(el)
{
    if (!invEnabled) return;
    inv.menuItems.setPosition(inv.menuItems.baseX, inv.menuItems.baseY - el.getValue());

    foreach(v in inv.itemSlots) {
        if ((v.btn.pos.y + v.btn.size.height < v.btn.parent.baseY) || (v.btn.pos.y > v.btn.parent.baseY + MAX_ROW * SIZE))
            v.enable(false);
        else
            v.enable(true);

        v.updatePos();
    }

    coverTex4.top();
    inv.twoMenu.background.texture.top();

    coverTex11.top();
    coverTex1.top();
    coverTex22.top();
    coverTex2.top();
    coverTex33.top();
    coverTex3.top();

    gold_cover_tex.top();
    esc_lab.top();
    gold_lab.top();
    sec_gold_lab.top();
    big_inv_title.top();
    big_stat_title.top();

    foreach(v in draws) {
        v.top();
    }
}

Inventory.Init <- function()
{
    local wW = 8192/2;
    local wH = 8192;
    local column = 0;
    local row = 0;

    inv.menu = Window(0, 0, wW, wH, "SR_BLANK.TGA");
    inv.menu.background.texture.setColor(10, 10, 10);

    inv.menuItems = Window(200, SIZE, MAX_COLUMN * SIZE, MAX_ITEMS / MAX_COLUMN * SIZE, "SR_BLANK.TGA");
    inv.menuItems.setBackgroundColor(100, 100, 100);
    inv.menu.attach(inv.menuItems);

    inv.oneMenu = Window(MAX_COLUMN * SIZE + 600 - 36, SIZE + 250, wW - MAX_COLUMN*SIZE - SIZE - 92, MAX_ROW * SIZE - 250, "LOG_PAPER.TGA");
    //inv.oneMenu.setBackgroundColor(255, 255, 0);
    inv.menu.attach(inv.oneMenu);

    inv.twoMenu = Window(100, SIZE + SIZE + MAX_ROW * SIZE - 200, 4192 - 292, 4192 - 3 * SIZE + 300, "LOG_PAPER.TGA");
    inv.twoMenu.setBackgroundColor(255, 255, 0);
    inv.menu.attach(inv.twoMenu);

    gold_cover_tex = Texture(0, 0, 0, 0, "MENU_CHOICE_BACK.TGA");

    coverTex1 = Texture(0, 0, wW, SIZE - 25, "MENU_CHOICE_BACK.TGA");
    coverTex11 = Texture(coverTex1.getPosition().x, coverTex1.getPosition().y, coverTex1.getSize().width, coverTex1.getSize().height, "SR_BLANK.TGA");
    coverTex11.setColor(0, 0, 0);

    coverTex2 = Texture(0, SIZE + MAX_ROW * SIZE, wW, 100 + inv.twoMenu.pos.y - ((MAX_ROW + 1) * SIZE), "MENU_CHOICE_BACK.TGA");
    coverTex22 = Texture(coverTex2.getPosition().x, coverTex2.getPosition().y, coverTex2.getSize().width, coverTex2.getSize().height, "SR_BLANK.TGA");
    coverTex22.setColor(0, 0, 0);

    coverTex3 = Texture(0, inv.twoMenu.pos.y + inv.twoMenu.size.height - 150, wW, 8192 - inv.twoMenu.pos.y - inv.twoMenu.size.height + 150, "MENU_CHOICE_BACK.TGA");
    coverTex33 = Texture(coverTex3.getPosition().x, coverTex3.getPosition().y, coverTex3.getSize().width, coverTex3.getSize().height, "SR_BLANK.TGA");
    coverTex33.setColor(0, 0, 0);

    coverTex4 = Texture(inv.twoMenu.pos.x, inv.twoMenu.pos.y, inv.twoMenu.size.width, inv.twoMenu.size.height, "SR_BLANK.TGA");
    coverTex4.setColor(0, 0, 0);

    local ls = 0;
    foreach(i, v in draws) {
        v.setPosition(250, inv.twoMenu.pos.y + 125 + i * (50 + v.height));
        if (v.getPosition().y + v.height > inv.twoMenu.pos.y + inv.twoMenu.size.height) {
            v.setPosition(inv.twoMenu.size.width / 2 + 250, inv.twoMenu.pos.y + 125 + ls * (50 + v.height));
            ls++;
        }
        v.setColor(220, 210, 189);
    }

    inv.itemSlots = [];
    for (local i = 0; i < MAX_ITEMS; i++) {
        local temp = InventorySlot(SIZE * column, SIZE * row, SIZE, SIZE, "INV_SLOT.TGA", "INV_SLOT_HIGHLIGHTED.TGA");
        //temp.btn.setBackgroundRegularColor(255, 255, 255);
        //temp.btn.setBackgroundHoverColor(255, 255, 0);
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

    inv.itemSlider = Slider(MAX_COLUMN * SIZE + 300, SIZE + 50, MAX_ROW * SIZE - 100, "LOG_PAPER.TGA", SIZE * (MAX_ITEMS / MAX_COLUMN - MAX_ROW), false, "MENU_MASKE.TGA", true);
    inv.itemSlider.setBackgroundColor(255, 255, 0);
    inv.menu.attach(inv.itemSlider);

    ////////////////////////////
    for (local i = 0; i < MAX_ITEMS; i++) {
        inv.itemSlots[i].setRender("", 0);
    }

    test_inv();
}

local vob = Vob("nw_misc_big_tent_430p.3DS");
Inventory.Enable <- function(val)
{
    setFreeze(val);
    Camera.movementEnabled = !val;
    disableControls(val);
    setCursorVisible(val);
    inv.menu.enable(val);
    coverTex1.visible = val;
    coverTex11.visible = val;
    coverTex2.visible = val;
    coverTex22.visible = val;
    coverTex3.visible = val;
    coverTex33.visible = val;
    coverTex4.visible = val;
    invEnabled = val;

    foreach(v in draws) {
        v.visible = val;
    }


    if (val == true) {
        setHudMode(HUD_ALL, HUD_MODE_HIDDEN);
        Camera.setPosition(37900, 4680, 44440);
        Camera.setRotation(0, 30, 0);
        vob.addToWorld();
        vob.setPosition(29912, 5246, -15710);
        vob.floor();
        vob.physicsEnabled = val;
        //inv.menu.setBackgroundColor(0, 0, 0);

        foreach(v in Player.items) {
            inv.itemSlots[v.slot].setRender(v.instance, v.amount);
            inv.itemSlots[v.slot].setAlpha(true);
        }

        test_inv_s();
        updateDraws();
        updateInvEqColor();
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
        off_inv_s();
    }
}

Inventory.IsEnabled <- function() {
    return invEnabled;
}