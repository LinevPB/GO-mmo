Player <- {
    id = 0,
    gameState = GameState.UNKNOWN,
    canProceed = false,

    helper = createNpc("Mike"),
    bodyModel = ["Hum_Body_Naked0","Hum_Body_Babe0"],
    headModel = ["Hum_Head_FatBald","Hum_Head_Fighter","Hum_Head_Pony","Hum_Head_Bald","Hum_Head_Thief","Hum_Head_Psionic","Hum_Head_Babe"],
    cBodyModel = 0,
    cBodyTexture = 1,
    cHeadModel = 1,
    cHeadTexture = 1
};

Player.updateVisual <- function(id = -1)
{
    if (id == -1) id = heroId;
    setPlayerVisual(id, Player.bodyModel[Player.cBodyModel], Player.cBodyTexture, Player.headModel[Player.cHeadModel], Player.cHeadTexture);
}