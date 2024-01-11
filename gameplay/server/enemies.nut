function initNpcs()
{
    local pos = [
        // { x = -4810.47, y = -297.969, z = -2276.41, angle = 293.966 },
        // { x = -4672.89, y = -301.719, z = -2337.5, angle = 293.966 },
        // { x = -4144.45, y = -285.156, z = -2602.27, angle = 228.821 },
        // { x = -4056.48, y = -273.281, z = -2525.08, angle = 228.821 },
        // { x = -3843.2, y = -197.891, z = -1970.31, angle = 158.667 },
        // { x = -3879.77, y = -196.719, z = -1877.03, angle = 158.667 },
        // { x = -4059.06, y = -163.359, z = -1307.42, angle = 173.274 },
        // { x = -4071.48, y = -172.031, z = -1210.31, angle = 177.476 },
        // { x = -3790.08, y = -111.562, z = -910.625, angle = 249.91 },
        // { x = -3697.19, y = -111.562, z = -876.484, angle = 249.91 },
        // { x = -3212.19, y = -72.7344, z = -409.766, angle = 168.368 },
        // { x = -3242.19, y = -102.812, z = -264.609, angle = 168.368 },
        // { x = -3120.94, y = -144.375, z = 252.812, angle = 243.505 },
        // { x = -3004.53, y = -143.125, z = 311.094, angle = 243.505 },
        { x = -92603, y = 178.125, z = -117200, angle = 55.4269 }
    ];

    foreach(v in pos)
    {
        local npc = Npc("Scavenger", Vec3(v.x, v.y, v.z), v.angle, "SCAVENGER");
        npc.setAi(AiType.MONSTER);
        npc.setMaxHealth(100);
        npc.setHealth(100);
        npc.setDamage(10);
        npc.setLevel(2);
        npc.setRespawnTime(10);
        npc.addDrop("ITAR_GOVERNOR", 1);
        npc.setGoldReward(100);
        npc.setExpReward(20);

        npc.movementSpeed = 1;
    }
}
