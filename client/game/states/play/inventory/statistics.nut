local statisticsMenu = null;

function getStatisticsMenu()
{
    return statisticsMenu;
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
];

function updateDraws()
{
    draws[0].text = "Name: " + getPlayerName(heroId);
    draws[1].text = "Level: " + Player.level;
    draws[2].text = "Experience: " + Player.experience + "/" + calcNextLevelExperience(Player.level);
    draws[3].text = ""
    draws[4].text = "Health: " + getPlayerHealth(heroId) + "/" + getPlayerMaxHealth(heroId);
    draws[5].text = "Mana: " + getPlayerMana(heroId) + "/" + getPlayerMaxMana(heroId);
    draws[6].text = "Strength: " + getPlayerStrength(heroId);
    draws[7].text = "Dexterity: " + getPlayerDexterity(heroId);
    draws[8].text = "Skill 1h: " + getPlayerSkillWeapon(heroId, WEAPON_1H);
    draws[9].text = "Skill 2h: " + getPlayerSkillWeapon(heroId, WEAPON_2H);
    draws[10].text = "Skill Bow: " + getPlayerSkillWeapon(heroId, WEAPON_BOW);
    draws[11].text = "Skill Crossbow: " + getPlayerSkillWeapon(heroId, WEAPON_CBOW);
}

function setupStatistics()
{
    statisticsMenu = Window(100, Inventory.SIZE + Inventory.SIZE + Inventory.MAX_ROW * Inventory.SIZE - 200, 4192 - 292, 4192 - 3 * Inventory.SIZE + 300, "LOG_PAPER.TGA");
    statisticsMenu.setBackgroundColor(255, 255, 0);
    getMainMenu().attach(statisticsMenu);
}

function setupDrawsPositions() {
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

function statisticsSlide()
{
    foreach(v in draws) {
        v.top();
    }
}

function enableStatistics(val)
{
    foreach (v in draws)
    {
        v.visible = val;
    }
}