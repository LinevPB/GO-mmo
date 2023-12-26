local ui = {
    login = {
        main = null,
        login_textbox = null,
        password_textbox = null,
        ok_button = null,
        back_button = null,

        register_button = null
    },

    register = {
        main = null,
        login_textbox = null,
        password_textbox = null,
        cpassword_textbox = null,
        ok_button = null,
        back_button = null
    }
};

function authResult(id)
{
    switch(id) {
        case 1:
            ui.login.main.enable(false);
            break;

        case 2:
            notify("You failed to log in!");
            break;

        case 3:
            ui.register.main.enable(false);
            break;

        case 4:
            notify("Account with that username already exists!");
            break;

        case 5:
            notify("Passwords are not the same!");
            break;

        case 6:
            notify("You must fill all fields!");
            break;

        case 7:
            notify("Unknown error! Please report it.");
            break;
    }
}

function RunDebug()
{
    sendPacket(PacketType.LOGIN, "DEBUG_ACCOUNT", "DEBUG_ACCOUNT_PLS_LET_ME_IN");
}

function initLoginState()
{
    spawnNpc(Player.helper, "PC_HERO");
    setPlayerPosition(Player.helper, 37730, 4680, 44830);

    clearMultiplayerMessages();
    setCursorVisible(true);
    setCursorTxt("LO.TGA");
    setCursorPosition(0, 0);
    setCursorSensitivity(1.0);

    Camera.setPosition(9650, 400, -730);
    Camera.setRotation(0, 85, 0);

    local wW; // window width
    local wH; // window height
    local temp;

    ///////////////
    // login window
    wW = 3000;
    wH = 4000;
    ui.login.main = Window(8192 / 2 - wW / 2, 8192 / 2 - wH / 2, wW, wH, "WINDOW_BACKGROUND1.TGA");

    temp = Label(0, 400, "Memory");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    ui.login.main.attach(temp);
    temp.center();
    temp = null;

    temp = Label(400, 1200, lang["LABEL_LOGIN_MENU_USERNAME"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.login.main.attach(temp);
    temp = null;
    ui.login.login_textbox = Textbox(400, 1200, 2200, 500, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", false);
    ui.login.login_textbox.addHoverCover(Texture(0, 0, 2200, 500, "TEXTBOX_SHADOW.TGA"));
    ui.login.main.attach(ui.login.login_textbox);

    temp = Label(400, 2200, lang["LABEL_LOGIN_MENU_PASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.login.main.attach(temp);
    temp = null;
    ui.login.password_textbox = Textbox(400, 2200, 2200, 500, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", true);
    ui.login.password_textbox.addHoverCover(Texture(0, 0, 2200, 500, "TEXTBOX_SHADOW.TGA"));
    ui.login.main.attach(ui.login.password_textbox);

    ui.login.ok_button = Button(wW / 2 - 900, 3000, 700, 500, "BUTTON_BACKGROUND.TGA", lang["BUTTON_LOGIN_MENU_OK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    ui.login.ok_button.setBackgroundRegularColor(200, 20, 20);
    ui.login.ok_button.setBackgroundHoverColor(150, 20, 20);
    ui.login.main.attach(ui.login.ok_button);

    ui.login.back_button = Button(wW / 2 + 200, 3000, 700, 500, "BUTTON_BACKGROUND.TGA", lang["BUTTON_LOGIN_MENU_QUIT"][Player.lang], "BUTTON_BACKGROUND.TGA");
    ui.login.back_button.setBackgroundRegularColor(200, 20, 20);
    ui.login.back_button.setBackgroundHoverColor(150, 20, 20);
    ui.login.main.attach(ui.login.back_button);

    ui.login.register_button = Button(wW / 2 + 200, 4000, 700, 500, "BUTTON_BACKGROUND.TGA", "Nie masz konta? :)", "BUTTON_BACKGROUND.TGA");
    ui.login.register_button.setBackgroundRegularColor(200, 20, 20);
    ui.login.register_button.setBackgroundHoverColor(150, 20, 20);
    ui.login.main.attach(ui.login.register_button);

    ui.login.main.enable(true);

    //////////////////
    // register window
    wW = 3000;
    wH = 5000;
    ui.register.main = Window(8192 / 2 - wW / 2, 8192 / 2 - wH / 2, wW, wH, "WINDOW_BACKGROUND.TGA");

    temp = Label(0, 400, "Memory");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    ui.register.main.attach(temp);
    temp.center();
    temp = null;

    temp = Label(400, 1200, lang["LABEL_REGISTER_MENU_USERNAME"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.login_textbox = Textbox(400, 1200, 2200, 500, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", false);
    ui.register.main.attach(ui.register.login_textbox);

    temp = Label(400, 2200, lang["LABEL_REGISTER_MENU_PASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.password_textbox = Textbox(400, 2200, 2200, 500, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", true);
    ui.register.main.attach(ui.register.password_textbox);

    temp = Label(400, 3200, lang["LABEL_REGISTER_MENU_CPASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.cpassword_textbox = Textbox(400, 3200, 2200, 500, "TEXTBOX_BACKGROUND.TGA", "", "TEXTBOX_BACKGROUND.TGA", true);
    ui.register.main.attach(ui.register.cpassword_textbox);

    ui.register.ok_button = Button(wW / 2 - 900, 4000, 700, 500, "BUTTON_BACKGROUND.TGA", lang["BUTTON_REGISTER_MENU_OK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    ui.register.ok_button.setBackgroundRegularColor(200, 20, 20);
    ui.register.ok_button.setBackgroundHoverColor(150, 20, 20);
    ui.register.main.attach(ui.register.ok_button);

    ui.register.back_button = Button(wW / 2 + 200, 4000, 700, 500, "BUTTON_BACKGROUND.TGA", lang["BUTTON_REGISTER_MENU_BACK"][Player.lang], "BUTTON_BACKGROUND.TGA");
    ui.register.back_button.setBackgroundRegularColor(200, 20, 20);
    ui.register.back_button.setBackgroundHoverColor(150, 20, 20);
    ui.register.main.attach(ui.register.back_button);
}

function loginButtonHandler(id)
{
    switch(id)
    {
        //login menu
        case ui.login.ok_button.id:
            sendPacket(PacketType.LOGIN, ui.login.login_textbox.getValue(), ui.login.password_textbox.getValue());
            break;

        case ui.login.back_button.id:
            exitGame();
            break;

        case ui.login.register_button.id:
            switchWindows(ui.login.main, ui.register.main);
            break;

        //register menu
        case ui.register.ok_button.id:
            sendPacket(PacketType.REGISTER, ui.register.login_textbox.getValue(), ui.register.password_textbox.getValue(), ui.register.cpassword_textbox.getValue());
            break;

        case ui.register.back_button.id:
            switchWindows(ui.register.main, ui.login.main);
            break;
    }
}

function deinitLoginState()
{
    setCursorVisible(false);

    destroy(ui.login.main);
    destroy(ui.register.main);

    ui = {
        login = { main = null, login_textbox = null, password_textbox = null, ok_button = null, back_button = null,
                    register_button = null },
        register = { main = null, login_textbox = null, password_textbox = null, cpassword_textbox = null, ok_button = null, back_button = null }
    };
}