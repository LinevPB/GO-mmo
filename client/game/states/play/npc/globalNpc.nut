local global_npc_list = [];

class GlobalNpc
{
    id = null;
    npc = null;
    name = null;
    pos = null;
    angle = null;
    instance = null;
    oneTime = null;
    currentAnim = null;
    previousAnim = null;
    draw = null;
    texture = null;
    coverTexture = null;
    dead = null;
    dying = null;
    level = null;

    levelTex = null;
    levelDraw = null;
    visualVisible = null;

    constructor(npcId, npcName, posX, posY, posZ, npcAngle, npcInst)
    {
        id = npcId;
        name = npcName;
        pos = { x = posX, y = posY, z = posZ };
        angle = npcAngle;
        instance = npcInst;

        npc = createNpc(name);

        draw = Draw3d(posX, posY + 100, posZ);
        draw.insertText(lang[name.toupper()][Player.lang]);
        draw.setLineColor(0, 250, 80, 10);

        texture = Texture(0, 0, 1000, 100, "SR_BLANK.TGA");
        texture.setColor(250, 80, 80);
        coverTexture = Texture(0, 0, 1000, 100, "MENU_COVER.TGA");

        dead = false;
        dying = false;

        level = 0;
        levelDraw = Draw(0, 0, level);
        levelDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
        levelTex = Texture(0, 0, 100, 100, "MENU_CHOICE_BACK.TGA");
        visualVisible = false;

        currentAnim = "S_RUN";
        previousAnim = "S_RUN";

        updateWorld(false);

        global_npc_list.append(this);
    }

    function die()
    {
        dead = true;
        dying = true;
        stopCurrentAnim();
        setHealth(0);
        playAnim("T_DEADB");
        updateWorld(false);
    }

    function respawn()
    {
        dead = false;
        dying = false;
        spawn();
        stopAni(npc, "S_DEADB");
        stopAni(npc, "T_DEADB");
        playAnim("S_RUN");
    }

    function setLevel(val)
    {
        level = val;
        levelDraw.text = val;
        local size = levelDraw.width > levelDraw.height ? levelDraw.width : levelDraw.height;
        levelTex.setSize(size, size);
    }

    function setHealth(val)
    {
        setPlayerHealth(npc, val);
    }

    function setMaxHealth(val)
    {
        setPlayerMaxHealth(npc, val);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        setPlayerAngle(npc, angle);
    }

    function playAnim(aniId)
    {
        if (aniId != currentAnim)
        {
            stopAni(npc, previousAnim);
            previousAnim = currentAnim;
        }

        currentAnim = aniId;
        playAni(npc, aniId);
    }

    function playAnimId(aniId)
    {
        playAniId(npc, aniId);
    }

    function stopCurrentAnim()
    {
        playAnim("S_RUN");
    }

    function setPosition(x, y, z)
    {
        pos = { x = x, y = y, z = z};
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
    }

    function setAngle(ang)
    {
        angle = ang;
        if (isPlayerDead(npc)) return;

        setPlayerAngle(npc, angle);
    }

    function updateWorldPos()
    {
        local npos = getPlayerPosition(npc);
        draw.setWorldPosition(npos.x, npos.y + 100, npos.z);

        local dPos = draw.getPosition();
        texture.setPosition(dPos.x + draw.width / 2 - 500, dPos.y - draw.height - 150);

        dPos = texture.getPosition();
        coverTexture.setPosition(dPos.x, dPos.y);

        local healthSize = 1000.0 * (getPlayerHealth(npc).tofloat()/getPlayerMaxHealth(npc).tofloat());
        texture.setSize(healthSize, 100);

        levelTex.setPosition(texture.getPosition().x - levelTex.getSize().width, texture.getPosition().y - levelTex.getSize().height / 2);
        levelDraw.setPosition(levelTex.getPosition().x + levelTex.getSize().width / 2 - levelDraw.width / 2, levelTex.getPosition().y + levelTex.getSize().height / 2 - levelDraw.height / 2);

        levelTex.rotation = 45;
    }

    function updateWorld(val)
    {
        // the reason for the weird mechanic is that textures in g2o are bugged

        texture.visible = val;
        coverTexture.visible = val;
        levelTex.visible = val;
        levelDraw.visible = val;
        draw.visible = val;

        visualVisible = val;
    }
}

function onPlayerHit(kid, pid, desc)
{
    cancelEvent();

    foreach(v in global_npc_list)
    {
        if (pid == v.npc)
        {
            sendPacket(PacketType.NPC_DAMAGE, v.id);
            return;
        }
    }
}
addEventHandler("onPlayerHit", onPlayerHit);

function handleNpcSpawn(data)
{
    local id = data[0];
    local name = data[1];
    local posX = data[2];
    local posY = data[3];
    local posZ = data[4];
    local angle = data[5];
    local instance = data[6];
    local hp = data[7];
    local maxhp = data[8];
    local lvl = data[9];

    local npc = GlobalNpc(id, name, posX, posY, posZ, angle, instance);
    npc.spawn();
    npc.setMaxHealth(maxhp);
    npc.setHealth(hp);
    npc.setLevel(lvl);
}

function setNpcCoords(data)
{
    local id = data[0];
    local posX = data[1];
    local posY = data[2];
    local posZ = data[3];
    local angle = data[4];

    local npc = findGlobalNpc(id);
    npc.setPosition(posX, posY, posZ);
    npc.setAngle(angle);
}

function findGlobalNpc(id)
{
    foreach(v in global_npc_list)
    {
        if (v.id == id) return v;
    }

    return null;
}

function handleNpcCoords(data)
{
    local id = data[0];
    local npc = findGlobalNpc(id);
    if (npc == null) return;

    local pos = getPlayerPosition(npc.npc);
    local angle = getPlayerAngle(npc.npc);
    npc.pos.x = pos.x;
    npc.pos.y = pos.y;
    npc.pos.z = pos.z;
    npc.angle = angle;

    sendPacket(PacketType.NPC_COORDS, id, npc.pos.x, npc.pos.y, npc.pos.z, npc.angle, getTime().min);
}

function handleNpcAnimation(data)
{
    local id = data[0];
    local aniId = data[1];

    foreach(v in global_npc_list)
    {
        if (id == v.id)
        {
            if (v.dead) return;
            return v.playAnim(aniId);
        }
    }
}

function handleDying(npc)
{
    local alpha = getPlayerVisualAlpha(npc.npc);
    setPlayerVisualAlpha(npc.npc, alpha - 0.001);

    if (alpha <= 0)
    {
        unspawnNpc(npc.npc);
        npc.dying = false;
        npc.updateWorld(false);
        setPlayerVisualAlpha(npc.npc, 0.0);
    }
}

function globalNpcRender()
{
    local pos = getPlayerPosition(heroId);

    foreach(npc in global_npc_list)
    {
        if (npc.dying)
        {
            handleDying(npc);
        }

        if (npc.dead) continue;

        local dist = getDistance3d(npc.pos.x, npc.pos.y, npc.pos.z, pos.x, pos.y, pos.z);
        if (dist < distance_draw)
        {
            if (!npc.visualVisible)
            {
                npc.updateWorld(true);
            }
            else
            {
                npc.updateWorldPos();
            }
        }
        else
        {
            if (npc.visualVisible)
            {
                npc.updateWorld(false);
            }
        }
    }
}

function handleNpcSetHealth(id, val)
{
    local npc = findGlobalNpc(id);
    if (val == 0) val = 1;
    npc.setHealth(val);
}

function handleNpcSetMaxHealth(id, val)
{
    local npc = findGlobalNpc(id);
    npc.setMaxHealth(val);
}

function handleNpcDeath(id)
{
    local npc = findGlobalNpc(id);
    npc.die();
}

function handleNpcRespawn(id, pos, angle)
{
    local npc = findGlobalNpc(id);
    npc.respawn();
    setPlayerPosition(npc.npc, pos.x, pos.y, pos.z);
    setPlayerAngle(npc.npc, angle);
    setPlayerVisualAlpha(npc.npc, 1.0);
}