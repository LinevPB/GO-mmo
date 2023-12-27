enum GameState
{
    UNKNOWN,
    LOGIN,
    CHARACTER_SELECTION,
    CHARACTER_CREATION,
    PLAY
};

Overlay <-
{
    Default = "NORMAL",
    Arrogance = "HumanS_Arrogance.mds",
    Babe = "Humans_Babe.mds",
    Flee = "HumanS_Flee.mds",
    Mage = "Humans_Mage.mds",
    Militia = "HumanS_Militia.mds",
    Relaxed = "HumanS_Relaxed.mds",
    Tired = "Humans_Tired.mds"
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

function getOverlayId(ov)
{
    for(local i = 0; i <= 7; i++)
    {
        local temp = getOverlayById(i);
        if (temp == ov) return i;
    }
}

function getOverlayById(id)
{
    switch(id)
    {
        case 0:
            return Overlay.Default;
        break;

        case 1:
            return Overlay.Arrogance;
        break;

        case 2:
            return Overlay.Babe;
        break;

        case 3:
            return Overlay.Flee;
        break;

        case 4:
            return Overlay.Mage;
        break;

        case 5:
            return Overlay.Militia;
        break;

        case 6:
            return Overlay.Relaxed;
        break;

        case 7:
            return Overlay.Tired;
        break;
    }
}
