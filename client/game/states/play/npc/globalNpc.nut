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
    textureFrame = null;
    dead = null;
    dying = null;
    level = null;

    levelTex = null;
    levelDraw = null;
    visualVisible = null;
    max_health = null;

    constructor(npcId, npcName, posX, posY, posZ, npcAngle, npcInst)
    {
        id = npcId;
        name = npcName;
        pos = { x = posX, y = posY, z = posZ };
        angle = npcAngle;
        instance = npcInst;

        npc = createNpc(name);

        draw = Draw3d(posX, posY + 100, posZ);
        draw.insertText(lang[instance.toupper()][Player.lang]);
        draw.setLineColor(0, 250, 80, 10);

        texture = Texture(0, 0, 1000, 100, "BAR_HEALTH.TGA");
        texture.setColor(250, 80, 80);
        coverTexture = Texture(0, 0, 1000, 100, "BAR_BACK.TGA");
        textureFrame = Texture(0, 0, 1000, 100, "WINDOW_FRAME.TGA");

        dead = false;
        dying = false;

        level = 0;
        max_health = 20;

        levelDraw = Draw(0, 0, level);
        levelDraw.font = "FONT_OLD_20_WHITE_HI.TGA";
        levelDraw.setColor(255, 255, 255);
        levelTex = Texture(0, 0, 100, 100, "LEVEL_FRAME.TGA");

        visualVisible = false;

        currentAnim = "S_RUN";
        previousAnim = "S_RUN";

        global_npc_list.append(this);
    }

    function die()
    {
        dead = true;
        dying = true;
        stopCurrentAnim();
        setHealth(0);
        playAnim("T_DEADB");
    }

    function respawn()
    {
        dead = false;
        dying = false;
        spawn();
        setPlayerMaxHealth(npc, max_health);
        stopAni(npc, "S_DEADB");
        stopAni(npc, "T_DEADB");
        playAnim("S_RUN");
    }

    function setLevel(val)
    {
        level = val;
        levelDraw.text = val;

        //local size = levelDraw.width > levelDraw.height ? levelDraw.width : levelDraw.height;
        levelTex.setSize(levelDraw.width + 100, levelDraw.height);
    }

    function setHealth(val)
    {
        setPlayerHealth(npc, val);
    }

    function setMaxHealth(val)
    {
        max_health = val;
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
        coverTexture.setPosition(dPos.x + draw.width / 2 - 500, dPos.y - draw.height - 150);

        dPos = coverTexture.getPosition();
        texture.setPosition(dPos.x, dPos.y);
        textureFrame.setPosition(dPos.x, dPos.y);

        local healthSize = 1000.0 * (getPlayerHealth(npc).tofloat()/getPlayerMaxHealth(npc).tofloat());
        texture.setSize(healthSize, 100);

        levelTex.setPosition(texture.getPosition().x - levelTex.getSize().width, texture.getPosition().y - levelTex.getSize().height / 2);
        levelDraw.setPosition(levelTex.getPosition().x + levelTex.getSize().width / 2 - levelDraw.width / 2 + 5, levelTex.getPosition().y + levelTex.getSize().height / 2 - levelDraw.height / 2 + 10);

        // local temp = levelTex.getSize();
        // levelTex.setPivotPoint(temp.width / 2, temp.height / 2);
        // levelTex.rotation = 45;
    }

    function isSomethingVisible()
    {
        return (texture.visible || coverTexture.visible || levelTex.visible || levelDraw.visible || draw.visible || visualVisible);
    }

    function updateWorld(val)
    {
        if (val == false)
        {
            texture.setPosition(0, 0);
            coverTexture.setPosition(0, 0);
        }

        coverTexture.visible = val;
        texture.visible = val;
        textureFrame.visible = val;

        levelTex.visible = val;
        levelDraw.visible = val;
        draw.visible = val;

        visualVisible = val;
    }

    function handleDeath()
    {
        dying = false;
        dead = true;
        setPlayerVisualAlpha(npc, 0.0);
        unspawnNpc(npc);
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

    sendPacket(PacketType.DAMAGE_DO, pid);
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
    alpha -= 0.003;
    if (alpha <= 0.0) alpha = 0.0;

    setPlayerVisualAlpha(npc.npc, alpha);

    if (alpha == 0.0)
    {
        npc.handleDeath();
    }
}

function globalNpcRender()
{
    local pos = getPlayerPosition(heroId);

    foreach(npc in global_npc_list)
    {
        if (npc.dying)
        {
            if (npc.isSomethingVisible())
            {
                npc.updateWorld(false);
            }

            handleDying(npc);
            continue;
        }

        if (npc.dead) continue;

        local dist = getDistance3d(npc.pos.x, npc.pos.y, npc.pos.z, pos.x, pos.y, pos.z);
        if (dist < distance_draw)
        {
            if (!npc.isSomethingVisible())
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
            if (npc.isSomethingVisible())
            {
                npc.updateWorld(false);
            }
        }
    }
}

function handleNpcSetHealth(id, val)
{
    local npc = findGlobalNpc(id);
    //if (val == 0) val = 1;
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