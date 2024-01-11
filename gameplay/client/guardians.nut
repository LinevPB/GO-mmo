function random(dolnyZakres, gornyZakres)
{
    local zakres = gornyZakres - dolnyZakres + 1;
    return dolnyZakres + rand() % zakres;
}

function initZiobro()
{
    local npcValues = {
        name = lang["GUARDIAN"][Player.lang],
        camp = "Old Camp",
        ani = "S_HGUARD",
        armor = "ITAR_MIL_L"
    };

    local npcPositions = [
        { x = -89616.8, y = 633.75, z = -116788, angle = 306.468 },
        { x = -90001.5, y = 627.969, z = -117138, angle = 334.879 },
        { x = -92138.4, y = 275.469, z = -114716, angle = 286.863 },
        { x = -92215.4, y = 277.812, z = -115925, angle = 223.388 },
        { x = -92379.5, y = 187.344, z = -116379, angle = 28.4166 },
        { x = -93103.8, y = 177.344, z = -118111, angle = 346.794 },
        { x = -94902.7, y = 178.203, z = -117116, angle = 86.3648 },
        { x = -95338.1, y = 175.156, z = -116343, angle = 89.9519 }
    ];

    foreach(v in npcPositions)
    {
        local npc = NPC(lang["GUARDIAN"][Player.lang], v.x, v.y, v.z, v.angle);
        npc.spawn();

        equipItem(npc.npc, Items.id(npcValues.armor));
        setPlayerVisual(npc.npc, BodyModel[random(0, 1)], random(0, 4), HeadModel[random(0, 5)], random(1, 143));
        npc.playAni(npcValues.ani)

        npc.draw.setLineText(2, npcValues.name);
        npc.draw.setLineColor(0, 250, 240, 220);
        npc.draw.setLineColor(1, 250, 240, 220);
        npc.draw.setLineColor(2, 160, 160, 255);

        npc.set_ambient("SVM_1_GETOUTOFHERE.WAV");
    }
}

