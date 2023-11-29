class TradeSlot
{
    pos = null;
    size = null;
    regularTex = null;
    hoverTex = null;
    equippedTex = null;
    equippedHoverTex = null;

    background = null;
    render = null;
    amountDraw = null;

    baseX = null;
    baseY = null;

    enabled = null;

    constructor(x, y, width, height)
    {
        regularTex = "INV_SLOT.TGA";
        hoverTex = "INV_SLOT_FOCUS.TGA";
        equippedTex = "INV_SLOT_EQUIPPED.TGA";
        equippedHoverTex = "INV_SLOT_EQUIPPED_FOCUS.TGA";

        pos = { x = x, y = y };
        size = { width = width, height = height };

        background = Texture(x, y, width, height, regularTex);
        amountDraw = Draw(x, y, "x1");
        render = ItemRender(x, y, width, height, "");

        setPosition(x, y);
        amountDraw.text = "";

        baseX = x;
        baseY = y;

        enabled = false;
    }

    function enable(val)
    {
        background.visible = val;
        amountDraw.visible = val;
        render.visible = val;
        enabled = val;
    }

    function move(x, y)
    {
        pos.x += x;
        pos.y += y;
        background.setPosition(pos.x, pos.y);
        amountDraw.setPosition(pos.x, pos.y);
    }

    function setPosition(x, y)
    {
        pos.x = x;
        pos.y = y;
        background.setPosition(pos.x, pos.y);
        amountDraw.setPosition(pos.x + size.width - amountDraw.width - 10, pos.y + size.height - amountDraw.height - 10);
        render.setPosition(pos.x, pos.y);
    }

    function updateSlot(instance, amount)
    {
        render.instance = instance;
        amountDraw.text = "x"+amount;
        setPosition(pos.x, pos.y);
    }
}
