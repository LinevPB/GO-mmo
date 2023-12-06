local coverTex = null;
local QA_Slots = [];
local QA_Renders = [];
local QAF_Draws = [];
local QAA_Draws = [];

function initQA()
{
    coverTex = Texture(8192/2 - 1400, 8192-1000, 2800, 500, "SR_BLANK.TGA");
    coverTex.setColor(10, 10, 40);
    for(local i = 0;  i < 4; i++)
    {
        QA_Slots.append(Texture(coverTex.getPosition().x + 700 * i, coverTex.getPosition().y, 700, 500, "MENU_COVER.TGA"));
        QA_Renders.append(ItemRender(QA_Slots[i].getPosition().x + 100, QA_Slots[i].getPosition().y, QA_Slots[i].getSize().width - 200, QA_Slots[i].getSize().height, Player.qa[i]));
        QAF_Draws.append(Draw(QA_Slots[i].getPosition().x, QA_Slots[i].getPosition().y, "F" + (i + 1)));
        QAA_Draws.append(Draw(QA_Slots[i].getPosition().x, QA_Slots[i].getPosition().y, ""));

        QAF_Draws[i].setPosition(QA_Slots[i].getPosition().x + 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAF_Draws[i].height - 5);
        QAF_Draws[i].setColor(240, 180, 50);

        QAA_Draws[i].setPosition(QA_Slots[i].getPosition().x + QA_Slots[i].getSize().width - QAA_Draws[i].width - 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAA_Draws[i].height - 20)
        QAA_Draws[i].setColor(240, 220, 180);
    }
}

function enableQA(val)
{
    coverTex.visible = val;
    for(local i = 0; i < 4; i++)
    {
        QA_Slots[i].visible = val;
        QA_Renders[i].visible = val;
        QAF_Draws[i].visible = val;
        QAA_Draws[i].visible = val;
    }
}

function handleQARender()
{
    for(local i = 0; i < 4; i++)
    {
        if (Player.qa[i] != QA_Renders[i].instance)
        {
            QA_Renders[i].instance = Player.qa[i];
        }

        if (QA_Renders[i].instance == Player.eqArmor || QA_Renders[i].instance == Player.eqWeapon || QA_Renders[i].instance == Player.eqWeapon2h)
        {
            QA_Slots[i].file = "INV_SLOT_EQUIPPED.TGA";
        }
        else
        {
            QA_Slots[i].file = "MENU_COVER.TGA";
        }

        foreach(v in Player.items)
        {
            if (v.instance.toupper() != QA_Renders[i].instance.toupper())
            {
                if (QA_Renders[i].instance == "")
                {
                    QAA_Draws[i].text = "";
                }
                continue;
            }

            if (v.amount <= 1)
            {
                QAA_Draws[i].text = "";
            }
            else
            {
                local item = Daedalus.instance(v.instance)
                if (item.mainflag == 2 || item.mainflag == 4)
                {
                    QAA_Draws[i].text = "";
                    continue;
                }

                QAA_Draws[i].text = "x" + v.amount;
                QAA_Draws[i].setPosition(QA_Slots[i].getPosition().x + QA_Slots[i].getSize().width - QAA_Draws[i].width - 20, QA_Slots[i].getPosition().y + QA_Slots[i].getSize().height - QAA_Draws[i].height - 20)
            }
        }
    }
}

function handleQAKey(key)
{
    if (key == KEY_F1 && Player.qa[0] != "")
    {
        handleUseItem({instance = Player.qa[0]});
    }

    if (key == KEY_F2 && Player.qa[1] != "")
    {
        handleUseItem({instance = Player.qa[1]});
    }

    if (key == KEY_F3 && Player.qa[2] != "")
    {
        handleUseItem({instance = Player.qa[2]});
    }

    if (key == KEY_F4 && Player.qa[3] != "")
    {
        handleUseItem({instance = Player.qa[3]});
    }
}