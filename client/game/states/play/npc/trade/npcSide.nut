local npcInventory = null;

local npcInvDraw = null;
local npcInvDrawCover = null;
local npcItemsCover = null;

local NPC_itemsToTradeTex = null;
local NPC_itemsToTradeTexCover = null;

local npc_slots = [];
local NPC_trade_slots = [];
local NPC_tradeSlotsCover = null;

local NPC_basketValueDraw = null;
local NPC_basketValueAmountDraw = null;

function getNpcBasketItems()
{
    local temp = [];

    foreach(v in NPC_trade_slots)
    {
        if (v.render.instance != "")
        {
            temp.append({instance = v.render.instance, amount = v.amount});
        }
    }

    return temp;
}

function clearNpcBasket()
{
    foreach(v in NPC_trade_slots)
    {
        v.updateSlot("", 0);
    }
}

function initNpcWindow()
{
    npcInventory = Window(8192/2 + 300, 300, 8192/2-600, 6000, "SR_BLANK.TGA");
    npcInventory.setBackgroundColor(10, 10, 30);
    npcInventory.setCover("MENU_INGAME.TGA");

    NPC_itemsToTradeTex = Texture(8192/2 + 300, 6375, 8192/2-600, 8192 - 6500 - 50, "SR_BLANK.TGA");
    NPC_itemsToTradeTexCover = Texture(8192/2 + 300, 6375, 8192/2-600, 8192 - 6500 - 50, "MENU_INGAME.TGA");
    NPC_itemsToTradeTex.setColor(10, 10, 30);

    NPC_tradeSlotsCover = Texture(8192/2 + 300, 6375, 8192/2-600, 8192 - 6500 - 50, "SR_BLANK.TGA");
    NPC_tradeSlotsCover.setColor(75, 75, 100);

    NPC_basketValueDraw = Draw(0, 0, "Value: ");
    NPC_basketValueAmountDraw = Draw(0, 0, "0");

    NPC_basketValueDraw.setPosition(4550, 7725);
    NPC_basketValueAmountDraw.setPosition(4550 + NPC_basketValueDraw.width, 7725);
    NPC_basketValueAmountDraw.setColor(0, 150, 255);

    initNpcTradeSlots();

    return npcInventory;
}

function enableNpcWindow(val)
{
    npcItemsCover.visible = val;
    npcInvDrawCover.visible = val;
    npcInvDraw.visible = val;

    NPC_itemsToTradeTex.visible = val;
    NPC_itemsToTradeTexCover.visible = val;
    NPC_tradeSlotsCover.visible = val;

    NPC_basketValueDraw.visible = val;
    NPC_basketValueAmountDraw.visible = val;

    foreach(v in npc_slots)
    {
        v.enable(val);
    }

    foreach(v in NPC_trade_slots)
    {
        v.enable(val);
    }
}

function initNpcSlots()
{
    for(local i = 0; i < 5; i++)
    {
        for (local j = 0; j < 8; j++)
        {
            local slot = TradeSlot(npcInventory.pos.x + 250 + 600 * i, npcInventory.pos.y + 800 + 600 * j, 600, 600);
            if (j % 2 == 0)
            {
                slot.updateSlot("ITAR_VLK_M", j%2+1);
            }
            npc_slots.append(slot);
        }
    }

    npcItemsCover = Texture(npcInventory.pos.x + 250, npcInventory.pos.y + 800, 600 * 5, 600*8, "SR_BLANK.TGA");
    npcItemsCover.setColor(75, 75, 100);

    npcInvDraw = Draw(0, 0, "Npc inventory");
    npcInvDraw.setColor(240, 220, 180);
    npcInvDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
    npcInvDraw.setPosition(npcInventory.pos.x + npcInventory.size.width / 2 - npcInvDraw.width / 2, npcInventory.pos.y + 300 - npcInvDraw.height / 2);

    npcInvDrawCover = Texture(npcInventory.pos.x, npcInventory.pos.y, npcInventory.size.width, 600, "MENU_CHOICE_BACK.TGA");
}

function initNpcTradeSlots()
{
    for(local j = 0; j < 5; j++)
    {
        for(local i = 0; i < 2; i++)
        {
            local slot = TradeSlot(NPC_itemsToTradeTex.getPosition().x + 100 + 650 * j, NPC_itemsToTradeTex.getPosition().y + 600 * i + 100, 650, 600);
            NPC_trade_slots.append(slot);
        }
    }

    NPC_tradeSlotsCover.setPosition(NPC_itemsToTradeTex.getPosition().x + 100, NPC_itemsToTradeTex.getPosition().y + 100);
    NPC_tradeSlotsCover.setSize(650 * 5, 600 * 2);
}

function updateNpcBasketValue(value)
{
    NPC_basketValueAmountDraw.text = calcGoldAmount(value);
}