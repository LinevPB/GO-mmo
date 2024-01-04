DEBUG <- true;
distance_draw <- 1000;

BodyModel <- ["Hum_Body_Naked0", "Hum_Body_Babe0"];
HeadModel <- ["Hum_Head_FatBald", "Hum_Head_Fighter", "Hum_Head_Pony", "Hum_Head_Bald", "Hum_Head_Thief", "Hum_Head_Psionic", "Hum_Head_Babe"];

function calcNextLevelExperience(level)
{
    return 500 * (level);
}