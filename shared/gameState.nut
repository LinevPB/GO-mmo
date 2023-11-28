enum GameState {
    UNKNOWN,
    LOGIN,
    CHARACTER_SELECTION,
    CHARACTER_CREATION,
    PLAY
};

function calcNextLevelExperience(level)
{
    return 500 * (level + 1);
}