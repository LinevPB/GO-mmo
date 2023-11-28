function random(dolnyZakres, gornyZakres) {
    local zakres = gornyZakres - dolnyZakres + 1;
    return dolnyZakres + rand() % zakres;
}

function initZiobro()
{
    local npcValues = {
        name = "Guardian",
        camp = "Old Camp",
        ani = "S_HGUARD",
        armor = "ITAR_MIL_L"
    };

    local npcPositions = [
        { x = 3696.48, y = 368.516, z = -761.406, angle = 99.9991 },
        { x = 2676.25, y = 247.734, z = -1309.3, angle = 200.449 },
        { x = 2704.14, y = 247.812, z = -1611.64, angle = 342.229 },
        { x = 1115.47, y = 247.812, z = -1062.73, angle = 3.43877 },
        { x = 1728.36, y = 248.047, z = 457.266, angle = 183.139 },
        { x = 2746.95, y = 248.125, z = 155.391, angle = 190.242 },
        { x = 2957.58, y = 248.125, z = 1270.55, angle = 190.143 },
        { x = 1900.86, y = 248.047, z = 1084.92, angle = 108.871 },
        { x = 887.266, y = 247.734, z = 1057.5, angle = 180.003 },
        { x = -238.672, y = 241.719, z = 662.969, angle = 184.809 },
        { x = -4141.09, y = -200.312, z = -1766.17, angle = 298.574 },
        { x = -4512.73, y = -239.922, z = -1634.53, angle = 100.466 },
        { x = -4367.66, y = -212.656, z = -1422.5, angle = 159.095 },
        { x = -4359.92, y = -239.844, z = 6.17188, angle = 93.962 },
        { x = -3018.98, y = -485.859, z = 2384.69, angle = 335.89 },
        { x = -3593.67, y = -482.734, z = 2114.77, angle = 334.292 },
        { x = -2342.27, y = 177.734, z = -796.406, angle = 355.106 },
        { x = -1818.98, y = 180.703, z = -774.375, angle = 7.51476 }
    ];

    foreach(v in npcPositions) {
        local npc = NPC("Zbysiu", v.x, v.y, v.z, v.angle);
        npc.spawn();

        equipItem(npc.npc, Items.id(npcValues.armor));
        setPlayerVisual(npc.npc, Player.bodyModel[0], 3, Player.headModel[1], random(1, 50));
        npc.playAni(npcValues.ani)

        npc.draw.insertText(npcValues.camp);
        npc.draw.insertText(npcValues.name);
        npc.draw.setLineColor(0, 100, 255, 100);

        npc.set_ambient("SVM_1_GETOUTOFHERE.WAV");
    }
}