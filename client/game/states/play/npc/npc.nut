local npc_list = [];
local ambient_draws = [];

function getNpcList()
{
    return npc_list;
}

class NPC
{
    npc = null;
    nickname = null;
    draw = null;
    pos = null;
    instance = null;
    event = null;
    holder = null;
    sound = null;
    ambient_draw = null;
    animation = null;
    angle = null;

    constructor(name, x, y, z, ang)
    {
        npc = createNpc(name);
        draw = Draw3d(x, y + 150, z);
        ambient_draw = Draw3d(x, y+170, z);
        pos = { x = x, y = y, z = z };
        instance = "PC_HERO";
        nickname = name;
        angle = ang;

        for (local i = 0; i < 4; i++)
        {
            draw.insertText("");
        }

        npc_list.append(this);
    }

    function spawn()
    {
        spawnNpc(npc, instance);
        setPlayerPosition(npc, pos.x, pos.y, pos.z);
        setPlayerAngle(npc, angle);
        draw.setWorldPosition(pos.x, pos.y + 150, pos.z);
        ambient_draw.setWorldPosition(pos.x, pos.y + 180, pos.z)
    }

    function interact()
    {
        if (event != null) {
            begin_interact();
            return;
        }

        play_ambient_dialog();
    }

    function set_ambient(l)
    {
        sound = Sound(l);
    }

    function play_ambient_dialog()
    {
        if (ambient_draw.visible) return;

        sound.play();
        ambient_draw.visible = true;
        ambient_draw.insertText("Get out of here!");
        timer_ambient(this);
    }

    function hide_ambient()
    {
        if (ambient_draw == null) return;
        ambient_draw.visible = false;
        ambient_draw.removeText(0);
    }

    function start()
    {
        if (event != null) {
            event();
        }
    }

    function setInteraction(int)
    {
        event = int;
    }

    function playAni(id)
    {
        animation = id;
    }
}

function shide_ambient()
{
    foreach(v in ambient_draws)
    {
        v.hide_ambient();
    }

    ambient_draws.clear();
}

function timer_ambient(l)
{
    ambient_draws.append(l);
    setTimer(shide_ambient, 1000, 1);
}

function eventfocus(focusid, previd)
{
    foreach(v in npc_list)
    {
        if (v.npc == focusid)
        {
            info_draw.visible = true;
            BOT = v;
            HERO = heroId;

            v.draw.setLineText(0, "(CTRL)");
            v.draw.setLineText(1, "Porozmawiaj");
        }
        else if (focusid == -1)
        {
            info_draw.visible = false;
            BOT = -1;
            HERO = -1;

            v.draw.setLineText(0, "");
            v.draw.setLineText(1, "");
        }
    }
}
addEventHandler("onFocus", eventfocus);