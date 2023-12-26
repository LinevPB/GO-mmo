class CharStruct
{
    name = null;
    charSlot = null;
    charId = null;
    ownerId = null;

    bodyModel = null;
    bodyTex = null;
    headModel = null;
    headTex = null;

    eqWeapon = null;
    eqWeapon2h = null;
    eqArmor = null;

    level = null;

    constructor(charSlota, charIda, ownerIda, namea, bodyModela, bodyTexa, headModela, headTexa, eqArmora, eqWeapona, eqWeapon2ha, lvl)
    {
        name = namea;
        charSlot = charSlota;
        charId = charIda;
        ownerId = ownerIda;

        bodyModel = bodyModela;
        bodyTex = bodyTexa;
        headModel = headModela;
        headTex = headTexa;

        eqWeapon = eqWeapona;
        eqArmor = eqArmora;
        eqWeapon2h = eqWeapon2ha;

        level = lvl;
    }
}