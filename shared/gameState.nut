enum GameState
{
    UNKNOWN,
    LOGIN,
    CHARACTER_SELECTION,
    CHARACTER_CREATION,
    PLAY
};

Animation <-
{
    STAND = "T_STAND_2_SIT"
};

function calcNextLevelExperience(level)
{
    return 500 * (level);
}

function absolute(v)
{
    if (v <= 0) return v * (-1);
    return v;
}


// interface controller
