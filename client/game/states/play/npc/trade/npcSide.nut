local npcInventory = null;
local npc_slots = [];

local npcInvDraw = null;
local npcInvDrawCover = null;
local npcItemsCover = null;

function initNpcWindow()
{
    npcInventory = Window(8192/2 + 300, 300, 8192/2-600, 6000, "SR_BLANK.TGA");
    npcInventory.setBackgroundColor(10, 10, 40);
    npcInventory.setCover("MENU_INGAME.TGA");

    return npcInventory;
}

function enableNpcWindow(val)
{
    npcItemsCover.visible = val;
    npcInvDrawCover.visible = val;
    npcInvDraw.visible = val;

    foreach(v in npc_slots)
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