local statisticsMenu = null;
STATS_AWAITING <- false;

function getStatisticsMenu()
{
    return statisticsMenu;
}

local draws = null;

function updateDraws()
{
    draws[0].text = lang["NAME"][Player.lang] + getPlayerName(heroId);
    draws[1].text = lang["LEVEL"][Player.lang] + Player.level;
    draws[2].text = lang["EXPERIENCE"][Player.lang] + Player.experience + "/" + calcNextLevelExperience(Player.level);
    draws[3].text = ""
    draws[4].text = lang["HEALTH"][Player.lang] + getPlayerHealth(heroId) + "/" + getPlayerMaxHealth(heroId);
    draws[5].text = lang["MANA"][Player.lang] + getPlayerMana(heroId) + "/" + getPlayerMaxMana(heroId);
    draws[6].text = lang["STRENGTH"][Player.lang] + getPlayerStrength(heroId);
    draws[7].text = lang["DEXTERITY"][Player.lang] + getPlayerDexterity(heroId);
    draws[8].text = lang["SKILL_1H"][Player.lang] + getPlayerSkillWeapon(heroId, WEAPON_1H);
    draws[9].text = lang["SKILL_2H"][Player.lang] + getPlayerSkillWeapon(heroId, WEAPON_2H);
    draws[10].text = lang["SKILL_BOW"][Player.lang] + getPlayerSkillWeapon(heroId, WEAPON_BOW);
    draws[11].text = lang["SKILL_CBOW"][Player.lang] + getPlayerSkillWeapon(heroId, WEAPON_CBOW);
    draws[12].text = lang["MAGIC_LEVEL"][Player.lang] + getPlayerMagicLevel(heroId);
}

function setupStatistics()
{
    statisticsMenu = Window(0, 600, 8192, 8192-600, "WINDOW_BACKGROUND_SF.TGA");

    draws = [
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
        Draw(0, 0, "Magic Circle: 0")
    ];

    setupDrawsPositions();
}

function setupDrawsPositions()
{
    local ls = 0;
    foreach (i, v in draws) {
        v.setPosition(250, statisticsMenu.pos.y + 125 + i * (50 + v.height));
        if (v.getPosition().y + v.height + 50 > statisticsMenu.pos.y + statisticsMenu.size.height) {
            v.setPosition(statisticsMenu.size.width / 2 + 250, statisticsMenu.pos.y + 125 + ls * (50 + v.height));
            ls++;
        }
        v.setColor(220, 210, 189);
    }
}

function enableStatistics(val)
{
    statisticsMenu.enable(val);

    foreach (v in draws)
    {
        v.visible = val;
    }
}

function statisticsRender()
{
    if (STATS_AWAITING == true)
    {
        STATS_AWAITING = false;
        updateDraws();
    }
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