STATS_AWAITING <- false;
local isEnabled = false;

local width = 2000;
local height = 3000;

local tex1 = Texture(0, 600, 8192, 400, "BACKGROUND_GRAY.TGA"); // top
local tex2 = Texture(0, 600 + height, 8192, 6192, "BACKGROUND_GRAY.TGA"); // bottom
local tex3 = Texture(0, 600, 1000, height, "BACKGROUND_GRAY.TGA"); // left
local tex4 = Texture(1000 + width, 600, 8192 - 250 - width, height, "BACKGROUND_GRAY.TGA"); // right
local statFrame = Texture(0, 600, 8192, 7592, "BACKGROUND_SHADOW.TGA");
local avatarFrame = Texture(1000, 1000, width, height - 400, "WINDOW_FRAME.TGA");
local nameFrame = Texture(1000, 600 + height - 300, width, 300, "TEXTBOX_BACKGROUND.TGA");
local nameDraw = Draw(0, 0, "My name");

local healthBackground = Texture(1000, 600 + height, width, 150, "MENU_CHOICE_BACK.TGA");
local healthTex = Texture(1000 + 10, 600 + height, width - 10, 150, "BAR_HEALTH.TGA");
local healthCover = Texture(1000, 600 + height, width, 150, "WINDOW_FRAME.TGA");

local manaBackground = Texture(1000, 600 + height + 155, width, 140, "MENU_CHOICE_BACK.TGA");
local manaTex = Texture(1000 + 10, 600 + height + 155, width - 10, 140, "BAR_MANA.TGA");
local manaCover = Texture(1000, 600 + height + 150, width, 150, "WINDOW_FRAME.TGA");

local paddingLR = 100;
local paddingTB = 50;

local lastCamPos = null;
local lastCamRot = null;

local statsContainers = null;
local charDesc = null;
local canUseKeys = true;

function statsCanUseKeys()
{
    return canUseKeys;
}

function setStatCanUseKeys(val)
{
    canUseKeys = val;
}

function statsCannotUseKeys(key)
{
    if (key != KEY_ESCAPE && key != KEY_RETURN) return;
    textAreaEsc();
}

function updateDraws()
{
    if (statsContainers == null) return;


    // character progress
    statsContainers[0].getContainer()[0].updateName(lang["LEVEL"][Player.lang]);
    statsContainers[0].getContainer()[0].updateVal(Player.level);

    statsContainers[0].getContainer()[1].updateName(lang["EXPERIENCE"][Player.lang]);
    statsContainers[0].getContainer()[1].updateVal(Player.experience);

    statsContainers[0].getContainer()[2].updateName(lang["NEXT_LEVEL"][Player.lang]);
    statsContainers[0].getContainer()[2].updateVal(calcNextLevelExperience(Player.level));

    // attributes
    statsContainers[1].getContainer()[0].updateName(lang["STRENGTH"][Player.lang]);
    statsContainers[1].getContainer()[0].updateVal(getPlayerStrength(heroId));

    statsContainers[1].getContainer()[1].updateName(lang["DEXTERITY"][Player.lang]);
    statsContainers[1].getContainer()[1].updateVal(getPlayerDexterity(heroId));

    statsContainers[1].getContainer()[2].updateName(lang["HEALTH"][Player.lang]);
    statsContainers[1].getContainer()[2].updateVal(getPlayerHealth(heroId) + "/" + getPlayerMaxHealth(heroId));

    statsContainers[1].getContainer()[3].updateName(lang["MANA"][Player.lang]);
    statsContainers[1].getContainer()[3].updateVal(getPlayerMana(heroId) + "/" + getPlayerMaxMana(heroId));

    // skills
    statsContainers[2].getContainer()[0].updateName(lang["SKILL_1H"][Player.lang]);
    statsContainers[2].getContainer()[0].updateVal(getPlayerSkillWeapon(heroId, WEAPON_1H));

    statsContainers[2].getContainer()[1].updateName(lang["SKILL_2H"][Player.lang]);
    statsContainers[2].getContainer()[1].updateVal(getPlayerSkillWeapon(heroId, WEAPON_2H));

    statsContainers[2].getContainer()[2].updateName(lang["SKILL_BOW"][Player.lang]);
    statsContainers[2].getContainer()[2].updateVal(getPlayerSkillWeapon(heroId, WEAPON_BOW));

    statsContainers[2].getContainer()[3].updateName(lang["SKILL_CBOW"][Player.lang]);
    statsContainers[2].getContainer()[3].updateVal(getPlayerSkillWeapon(heroId, WEAPON_CBOW));

    statsContainers[2].getContainer()[4].updateName(lang["MAGIC_LEVEL"][Player.lang]);
    statsContainers[2].getContainer()[4].updateVal(getPlayerMagicLevel(heroId));

    nameDraw.text = getPlayerName(heroId);
    nameFrame.setSize(nameDraw.width + 200, nameDraw.height + 100);
    nameFrame.setPosition(1000 + width / 2 - nameFrame.getSize().width / 2, 600 + height - nameFrame.getSize().height);
    nameDraw.setPosition(nameFrame.getPosition().x + nameFrame.getSize().width / 2 - nameDraw.width / 2, nameFrame.getPosition().y + nameFrame.getSize().height / 2 - nameDraw.height / 2);

    setupStatsPositions();
}

local function calcY(posY, argheight)
{
    return (posY + argheight + 250);
}

function setupStatistics()
{
    local progress = StatsContainer(0, 0, width + 1300, 1700, lang["PROGRESS"][Player.lang]);
    progress.attach(Stat(0, 0, "Level", "20"));
    progress.attach(Stat(0, 0, "Experience", "1944"));
    progress.attach(Stat(0, 0, "Next level", "2137"));
    progress.setNameWidth(2200);
    progress.setValWidth(800);
    progress.setPosition(4000, calcY(200, 500));

    local attributes = StatsContainer(0, 0, width + 1300, 2000, lang["ATTRIBUTES"][Player.lang]);
    attributes.attach(Stat(0, 0, "Strength", "1950/2000"));
    attributes.attach(Stat(0, 0, "Dexterity", "1950/2000"));
    attributes.attach(Stat(0, 0, "Health", "1950/2000"));
    attributes.attach(Stat(0, 0, "Mana", "1950/2000"));
    attributes.setNameWidth(2200);
    attributes.setValWidth(800);
    attributes.setPosition(4000, calcY(progress.pos.y, progress.size.height));

    local skills = StatsContainer(0, 0, width + 1000, 2400, lang["SKILLS"][Player.lang]);
    skills.attach(Stat(0, 0, "Skill 1h", "0"));
    skills.attach(Stat(0, 0, "Skill 2h", "0"));
    skills.attach(Stat(0, 0, "Skill Bow", "0"));
    skills.attach(Stat(0, 0, "Skill Crossbow", "0"));
    skills.attach(Stat(0, 0, "Magic Circle", "0"));
    skills.setNameWidth(2200);
    skills.setValWidth(800);
    skills.setPosition(4000, calcY(attributes.pos.y + 100, attributes.size.height));

    setupStatsPositions();

    // healthTex.setColor(255, 0, 0);
    // manaTex.setColor(0, 0, 255);

    charDesc = TextArea();

    lastCamPos = Camera.getPosition();
    lastCamRot = Camera.getRotation();

    statsContainers = getStatsContainers();
}

function saveDesc()
{
    sendPacket(PacketType.SAVE_DESC, charDesc.getText());
}

function updateCharacterDesc()
{
    charDesc.setText(Player.desc);
}

function cancelDesc()
{
    charDesc.restoreText();
}

function setupStatsPositions()
{
    if (statsContainers == null) return;

    foreach(v in statsContainers)
    {
        v.refresh();
    }
}

function enableStatistics(val)
{
    if (val == true)
    {
        lastCamPos = Camera.getPosition();
        lastCamRot = Camera.getRotation();

        Camera.setPosition(37925, 4700, 44486);
        Camera.setRotation(0, 95, 0);
    }
    else
    {
        Camera.setPosition(lastCamPos.x, lastCamPos.y, lastCamPos.z);
        Camera.setRotation(lastCamRot.x, lastCamRot.y, lastCamRot.z);
    }

    tex1.visible = val;
    tex2.visible = val;
    tex3.visible = val;
    tex4.visible = val;

    statFrame.visible = val;
    avatarFrame.visible = val;

    nameFrame.visible = val;
    nameDraw.visible = val;

    healthBackground.visible = val;
    manaBackground.visible = val;

    healthTex.visible = val;
    manaTex.visible = val;

    healthCover.visible = val;
    manaCover.visible = val;

    charDesc.enable(val);

    foreach(v in statsContainers)
    {
        v.enable(val);
    }

    isEnabled = val;

    manaTex.top();
    manaCover.top();

    healthTex.top();
    healthCover.top();
}

function statisticsRender()
{
    if (STATS_AWAITING == true)
    {
        STATS_AWAITING = false;
        updateDraws();
    }

    if (isEnabled)
    {
        stopAni(Player.helper, "S_RUN");
        playAni(Player.helper, "S_RUN");

        local pos = getPlayerPosition(Player.helper);
        if (pos.x != 38086 || pos.y != 4681 || pos.z != 44551)
        {
            setPlayerPosition(Player.helper, 38086, 4681, 44551);
        }

        local ang = getPlayerAngle(Player.helper);
        if (ang != 250)
        {
            setPlayerAngle(Player.helper, 250);
        }

        local cpos = Camera.getPosition();
        local crot = Camera.getRotation();

        if (cpos.x != 37925 || cpos.y != 4700 || cpos.z != 44486)
        {
            Camera.setPosition(37925, 4700, 44486);
        }

        if (crot != 95)
        {
            Camera.setRotation(0, 95, 0);
        }
    }

    local calcHealth = getPlayerHealth(heroId).tofloat() / getPlayerMaxHealth(heroId).tofloat();
    local calcMana = getPlayerMana(heroId).tofloat() / getPlayerMaxMana(heroId).tofloat();

    healthTex.setSize((width - 20) * calcHealth, 140);
    manaTex.setSize((width - 20) * calcMana, 140);

    textAreaHoverHandler(charDesc);
}

function statisticsPress()
{
    return textAreaPress(charDesc);
}

function statisticsRelease()
{
    textAreaRelease(charDesc);
}

local function updateStatisticsDraw(pid, old = 0, new = 1)
{
    if (pid != heroId) return;
    STATS_AWAITING = true;
}

addEventHandler("onPlayerChangeHealth", updateStatisticsDraw);
addEventHandler("onPlayerChangeMaxHealth", updateStatisticsDraw);
addEventHandler("onPlayerChangeMana", updateStatisticsDraw);
addEventHandler("onPlayerChangeMaxMana", updateStatisticsDraw);