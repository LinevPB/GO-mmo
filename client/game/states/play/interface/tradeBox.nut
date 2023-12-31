local box = null;
local window = null;
local ok_btn = null;
local cancel_btn = null;
local info_label = null;
local info_label2 = null;
local info_label3 = null;
local isBEnabled = false;
local item_name = "Scroll of happiness";
local holdVal = null;

TradeBox <- {};

local function nr_reposition()
{
    local restrWidth = 1250;

    local name = split(item_name, " ");
    local spaceWidth = textWidth(" ");

    local baseWidth = 0;
    local text1 = "";
    local text2 = "";

    foreach(v in name)
    {
        local tempWidth = textWidth(v);
        if (baseWidth + tempWidth + spaceWidth > restrWidth)
        {
            text2 += v + " ";
            continue;
        }

        text1 += v + " ";
        baseWidth += tempWidth;
    }

    info_label2.setText(text1);
    info_label3.setText(text2);
}

TradeBox.SetItemName <- function(name)
{
    item_name = name;

    if (isBEnabled)
    {
        nr_reposition();
    }
}

TradeBox.Init <- function()
{
    info_label = Label(100, 200, lang["ENTER_AMOUNT"][Player.lang]);
    info_label2 = Label(100, 200 + info_label.height() + 50, item_name);
    info_label3 = Label(100, info_label2.pos.y + info_label2.height() + 50, " ");

    window = Window(2800, 2000, 1600, 2200, "WINDOW_BACKGROUND.TGA");

    box = Textbox(1600/2-250, info_label3.pos.y + info_label3.height() + 200, 500, 300, "TEXTBOX_BACKGROUND.TGA", "1", "TEXTBOX_BACKGROUND.TGA");
    box.addHoverCover(Texture(0, 0, 500, 300, "TEXTBOX_SHADOW.TGA"));
    box.setNumericOnly(true);
    box.setDefaultValue(1);

    ok_btn = Button(250, box.pos.y + box.size.height + 200, 500, 300, "BUTTON_BACKGROUND.TGA", lang["TRADEBOX_OK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    ok_btn.setBackgroundRegularColor(200, 20, 20);
    ok_btn.setBackgroundHoverColor(150, 20, 20);

    cancel_btn = Button(850, box.pos.y + box.size.height + 200, 500, 300, "BUTTON_BACKGROUND.TGA", lang["TRADEBOX_CANCEL"][Player.lang], "BUTTON_BACKGROUND.TGA");
    cancel_btn.setBackgroundRegularColor(200, 20, 20);
    cancel_btn.setBackgroundHoverColor(150, 20, 20);

    window.attach(info_label);
    window.attach(info_label2);
    window.attach(info_label3);
    window.attach(box);
    window.attach(ok_btn);
    window.attach(cancel_btn);

    info_label.center();
    info_label2.center();
    info_label3.center();
}

TradeBox.Enable <- function(val)
{
    window.enable(val);
    nr_reposition();

    if (val == false && isBEnabled)
    {
        holdVal = null;
    }

    isBEnabled = val;

    if (val == true)
    {
        box.setInputText("1");
    }
}

TradeBox.IsEnabled <- function()
{
    return isBEnabled;
}

TradeBox.SetHold <- function(val)
{
    holdVal = val;
}

TradeBox.GetHold <- function()
{
    return holdVal;
}

TradeBox.Select <- function()
{
    box.open();
}

TradeBox.GetOkBtn <- function()
{
    return ok_btn.id;
}

TradeBox.GetCancelBtn <- function()
{
    return cancel_btn.id;
}

TradeBox.GetValue <- function()
{
    return box.getValue();
}