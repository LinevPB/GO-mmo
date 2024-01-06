function learnStrength(pid, val)
{
    local player = findPlayer(pid);
    local sp = player.getSkillPoints();

    if (sp < val) return;

    player.setSkillPoints(sp - val);
    player.setStrength(player.strength + val);
}

function learnDexterity(pid, val)
{
    local player = findPlayer(pid);
    local sp = player.getSkillPoints();

    if (sp < val) return;

    player.setSkillPoints(sp - val);
    player.setDexterity(player.dexterity + val);
}

function learnHealth(pid, val)
{
    local player = findPlayer(pid);
    local sp = player.getSkillPoints();

    if (sp < val) return;

    player.setSkillPoints(sp - val);
    player.setMaxHealth(player.max_health + val);
    player.setHealth(player.health + val);
}

function learnMana(pid, val)
{
    local player = findPlayer(pid);
    local sp = player.getSkillPoints();

    if (sp < val) return;

    player.setSkillPoints(sp - val);
    player.setMaxMana(player.max_mana + val);
    player.setMana(player.mana + val);
}

function learnSkillWeapon(pid, skill, val)
{
    local player = findPlayer(pid);
    local sp = player.getSkillPoints();

    if (sp < val) return;

    player.setSkillPoints(sp - val);

    switch(skill)
    {
        case 0:
            player.setSkill1h(player.skill_1h + val);
        break;

        case 1:
            player.setSkill2h(player.skill_1h + val);
        break;

        case 2:
            player.setSkillBow(player.skill_1h + val);
        break;

        case 3:
            player.setSkillCBow(player.skill_1h + val);
        break;
    }
}
