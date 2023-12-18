local myInventory = null;
local itemSlider = null;

local myInvDraw = null;
local myInvDrawCover = null;

local myItemsCover = null;

local topCover = null;
local bottomCover = null;
local bottomCoverSecond = null;
local myGoldDraw = null;
local myGoldAmountDraw = null;
local oreRender = null;

local itemsToTradeTex = null;
local itemsToTradeTexCover = null;

local slots = [];
local trade_slots = [];
local tradeSlotsCover = null;

local basketValueDraw = null;
local basketValueAmountDraw = null;

function getPlayerBasketItems()
{
    local temp = [];

    foreach(v in trade_slots)
    {
        if (v.render.instance != "")
        {
            temp.append({instance = v.render.instance, amount = v.amount});
        }
    }

    return temp;
}

function clearPlayerBasket()
{
    foreach(v in trade_slots)
    {
        v.updateSlot("", 0);
    }
}

function initPlayerWindow()
{
    myInventory = Window(300, 300, 2500, 6000, "WINDOW_BACKGROUND.TGA");

    itemsToTradeTex = Texture(300, 6400, 2500, 8192 - 6500 - 100, "WINDOW_BACKGROUND.TGA");
    itemsToTradeTexCover = Texture(300, 6400, 2500, 8192 - 6500 - 100, "WINDOW_BACKGROUND.TGA");
    itemsToTradeTex.setColor(10, 10, 30);

    tradeSlotsCover = Texture(300, 6400, 2500, 8192 - 6500 - 100, "WINDOW_BACKGROUND.TGA");
    tradeSlotsCover.setColor(75, 75, 100);

    basketValueDraw = Draw(0, 0, lang["VALUE"][Player.lang]);
    basketValueAmountDraw = Draw(0, 0, "0");

    basketValueDraw.setPosition(450, 7700);
    basketValueAmountDraw.setPosition(450 + basketValueDraw.width, 7700);
    basketValueAmountDraw.setColor(0, 150, 255);

    initPlayerTradeSlots();

    return myInventory;
}

function enablePlayerWindow(val)
{
    myItemsCover.visible = val;

    topCover.visible = val;
    bottomCover.visible = val;
    bottomCoverSecond.visible = val;

    myInvDrawCover.visible = val;
    myInvDraw.visible = val;

    myGoldDraw.visible = val;
    myGoldAmountDraw.visible = val;
    oreRender.visible = val;

    itemsToTradeTex.visible = val;
    itemsToTradeTexCover.visible = val;
    tradeSlotsCover.visible = val;

    basketValueDraw.visible = val;
    basketValueAmountDraw.visible = val;

    foreach(v in slots)
    {
        v.enable(val);
    }

    foreach(v in trade_slots)
    {
        v.enable(val);
    }

    if (val == true)
    {
        foreach(i, v in slots)
        {
            foreach(k in Player.items)
            {
                if (i == k.slot)
                {
                    v.updateSlot(k.instance, k.amount);
                    break;
                }

                if (v.instance != "")
                {
                    v.updateSlot("", 0);
                }
            }
        }

        setVisiblity(itemSlider.getValue());
    }
}

function refreshPlayerSlots()
{
    foreach(i, v in Player.items)
    {
        for(local j = 0; j < 90; j++)
        {
            if (j != v.slot) continue;

            slots[j].updateSlot(v.instance, v.amount);
        }
    }

    setVisiblity(itemSlider.getValue());
}

function initPlayerSlots()
{
    for (local j = 0; j < 30; j++)
    {
        for(local i = 0; i < 3; i++)
        {
            local slot = TradeSlot(myInventory.pos.x + 200 + 600 * i, myInventory.pos.y + 600 + 600 * j, 600, 600);
            slots.append(slot);
        }
    }

    topCover = Texture(myInventory.pos.x, myInventory.pos.y, myInventory.size.width, 600, "WINDOW_BACKGROUND.TGA");
    topCover.setColor(10, 10, 40);

    bottomCover = Texture(myInventory.pos.x, myInventory.pos.y + 6 * 900, myInventory.size.width, 600, "WINDOW_BACKGROUND.TGA");
    bottomCover.setColor(10, 10, 40);

    bottomCoverSecond = Texture(myInventory.pos.x, myInventory.pos.y + 6 * 900, myInventory.size.width, 600, "WINDOW_BACKGROUND.TGA");

    myGoldDraw = Draw(0, 0, lang["ORE"][Player.lang]);
    myGoldDraw.setPosition(myInventory.pos.x + 350, myInventory.pos.y + 6 * 900 + 300 - myGoldDraw.height / 2);
    oreRender = ItemRender(myInventory.pos.x + 250 - myGoldDraw.height, myGoldDraw.getPosition().y - 100, myGoldDraw.height * 2, myGoldDraw.height * 2, "ItMi_Nugget");

    myGoldAmountDraw = Draw(0, 0, Player.gold);
    myGoldAmountDraw.setColor(0, 150, 255);
    myGoldAmountDraw.setPosition(myGoldDraw.getPosition().x + myGoldDraw.width, myGoldDraw.getPosition().y);

    itemSlider = Slider(3 * 600 + 400, 600 + 50, 8 * 600 - 100, "LOG_PAPER.TGA", 600 * (90 / 3 - 8), "", "SLIDER_HANDLE.TGA", true);
    itemSlider.setBackgroundColor(255, 255, 0);
    myInventory.attach(itemSlider);

    myItemsCover = Texture(myInventory.pos.x + 200, myInventory.pos.y + 600, 600 * 3, 600*8, "WINDOW_BACKGROUND.TGA");
    myItemsCover.setColor(75, 75, 100);

    myInvDraw = Draw(0, 0, lang["MY_INVENTORY"][Player.lang]);
    myInvDraw.setColor(240, 220, 180);
    myInvDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
    myInvDraw.setPosition(myInventory.pos.x + myInventory.size.width / 2 - myInvDraw.width / 2, myInventory.pos.y + 300 - myInvDraw.height / 2);

    myInvDrawCover = Texture(myInventory.pos.x, myInventory.pos.y, myInventory.size.width, 600, "WINDOW_BACKGROUND.TGA");
}

function initPlayerTradeSlots()
{
    for(local j = 0; j < 4; j++)
    {
        for(local i = 0; i < 2; i++)
        {
            local slot = TradeSlot(itemsToTradeTex.getPosition().x + 575 * j + 100, itemsToTradeTex.getPosition().y + 575 * i + 100, 575, 575);
            trade_slots.append(slot);
        }
    }

    tradeSlotsCover.setPosition(itemsToTradeTex.getPosition().x + 100, itemsToTradeTex.getPosition().y + 100);
    tradeSlotsCover.setSize(575 * 4, 575 * 2);
}

function setVisiblity(val)
{
    local coverY = myItemsCover.getPosition().y;
    local coverHeight = myItemsCover.getSize().height;

    foreach(v in slots)
    {
        v.setPosition(v.baseX, v.baseY - val);

        if (v.pos.y < coverY - 600 && v.enabled)
        {
            v.enable(false);
        }
        else if (v.pos.y > coverY + coverHeight && v.enabled)
        {
            v.enable(false);
        }
        else if (v.pos.y >= coverY - 600 && v.pos.y <= coverHeight + coverY && !v.enabled)
        {
            v.enable(true);
        }

        if (v.pos.y < coverY)
        {
            topCover.top();
            myInvDrawCover.top();
            myInvDraw.top();
        }

        if (v.pos.y > coverY)
        {
            bottomCover.top();
            bottomCoverSecond.top();
            myGoldDraw.top();
            myGoldAmountDraw.top();
            oreRender.top();
        }
    }
}

function onTradeSlide(el)
{
    if (!isTradeEnabled()) return;
    if (el.id != itemSlider.id) return;

    setVisiblity(el.getValue());
}

function tradePlayerRender()
{
    if (!isTradeEnabled()) return;

    if (Player.gold != myGoldAmountDraw.text)
    {
        myGoldAmountDraw.text = calcGoldAmount();
    }
}

function updatePlayerBasketValue(value)
{
    basketValueAmountDraw.text = calcGoldAmount(value);
}