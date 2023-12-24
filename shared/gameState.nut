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

function absolute(v)
{
    if (v <= 0) return v * (-1);
    return v;
}
