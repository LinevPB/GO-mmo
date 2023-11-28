local ui = {
    selection = {
        main = null,
        login_button = null,
        register_button = null,
        exit_button = null
    },

    login = {
        main = null,
        login_textbox = null,
        password_textbox = null,
        ok_button = null,
        back_button = null
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

function loginButtonHandler(id) {
    switch(id) {
        //main menu
        case ui.selection.login_button.id:
            switchWindows(ui.selection.main, ui.login.main);
            break;

        case ui.selection.register_button.id:
            switchWindows(ui.selection.main, ui.register.main);
            break;

        case ui.selection.exit_button.id:
            exitGame();
            break;

        //login menu
        case ui.login.ok_button.id:
            sendPacket(PacketType.LOGIN, ui.login.login_textbox.getValue(), ui.login.password_textbox.getValue());
            break;

        case ui.login.back_button.id:
            switchWindows(ui.login.main, ui.selection.main);
            break;

        //register menu
        case ui.register.ok_button.id:
            sendPacket(PacketType.REGISTER, ui.register.login_textbox.getValue(), ui.register.password_textbox.getValue(), ui.register.cpassword_textbox.getValue());
            break;

        case ui.register.back_button.id:
            switchWindows(ui.register.main, ui.selection.main);
            break;
    }
}

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

function debug_func()
{
    switchWindows(ui.selection.main, ui.login.main);
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
    //////////////
    // main window
    wW = 1600;
    wH = 2600;
    ui.selection.main = Window(8192 / 2 - wW / 2, 8192 / 2 - wH / 2, wW, wH, "SR_BLANK.TGA");
    ui.selection.main.setBackgroundColor(10, 10, 40);
    ui.selection.main.setCover("MENU_INGAME.TGA");

    local temp = Label(0, 100, "Memory");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    ui.selection.main.attach(temp);
    temp.center();
    temp = null;

    ui.selection.login_button = Button(wW / 2 - 350, 700, 700, 400, "MENU_CHOICE_BACK.TGA", lang["BUTTON_MAIN_MENU_LOGIN"][Player.lang], "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.login_button);

    ui.selection.register_button = Button(wW / 2 - 350, 1300, 700, 400, "MENU_CHOICE_BACK.TGA", lang["BUTTON_MAIN_MENU_REGISTER"][Player.lang], "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.register_button);

    ui.selection.exit_button = Button(wW / 2 - 350, 1900, 700, 400, "MENU_CHOICE_BACK.TGA", lang["BUTTON_MAIN_MENU_QUIT"][Player.lang], "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.exit_button);

    ui.selection.main.enable(true);

    ///////////////
    // login window
    wW = 2000;
    wH = 2600;
    ui.login.main = Window(8192 / 2 - wW / 2, 8192 / 2 - wH / 2, wW, wH, "SR_BLANK.TGA");
    ui.login.main.setBackgroundColor(10, 10, 40);
    ui.login.main.setCover("MENU_INGAME.TGA");

    temp = Label(0, 100, "Memory");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    ui.login.main.attach(temp);
    temp.center();
    temp = null;

    temp = Label(wW / 2 - 750, 800, lang["LABEL_LOGIN_MENU_USERNAME"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.login.main.attach(temp);
    temp = null;
    ui.login.login_textbox = Textbox(wW / 2 - 750, 800, 1500, 300, "MENU_INGAME.TGA", "", "INV_TITEL.TGA", false);
    ui.login.main.attach(ui.login.login_textbox);

    temp = Label(wW / 2 - 750, 1500, lang["LABEL_LOGIN_MENU_PASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.login.main.attach(temp);
    temp = null;
    ui.login.password_textbox = Textbox(wW / 2 - 750, 1500, 1500, 300, "MENU_INGAME.TGA", "", "INV_TITEL.TGA", true);
    ui.login.main.attach(ui.login.password_textbox);

    ui.login.ok_button = Button(wW / 2 - 600, 2100, 500, 300, "MENU_CHOICE_BACK.TGA", lang["BUTTON_LOGIN_MENU_OK"][Player.lang], "INV_TITEL.TGA");
    ui.login.main.attach(ui.login.ok_button);

    ui.login.back_button = Button(wW / 2 + 100, 2100, 500, 300, "MENU_CHOICE_BACK.TGA", lang["BUTTON_LOGIN_MENU_BACK"][Player.lang], "INV_TITEL.TGA");
    ui.login.main.attach(ui.login.back_button);

    //////////////////
    // register window
    wW = 2000;
    wH = 3400;
    ui.register.main = Window(8192 / 2 - wW / 2, 8192 / 2 - wH / 2, wW, wH, "SR_BLANK.TGA");
    ui.register.main.setBackgroundColor(10, 10, 40);
    ui.register.main.setCover("MENU_INGAME.TGA");

    temp = Label(0, 100, "Memory");
    temp.setFont("Font_Old_20_White_Hi.TGA");
    temp.setColor(255, 180, 0);
    ui.register.main.attach(temp);
    temp.center();
    temp = null;

    temp = Label(wW / 2 - 750, 800, lang["LABEL_REGISTER_MENU_USERNAME"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.login_textbox = Textbox(wW / 2 - 750, 800, 1500, 300, "MENU_INGAME.TGA", "", "INV_TITEL.TGA", false);
    ui.register.main.attach(ui.register.login_textbox);

    temp = Label(wW / 2 - 750, 1500, lang["LABEL_REGISTER_MENU_PASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.password_textbox = Textbox(wW / 2 - 750, 1500, 1500, 300, "MENU_INGAME.TGA", "", "INV_TITEL.TGA", true);
    ui.register.main.attach(ui.register.password_textbox);

    temp = Label(wW / 2 - 750, 2200, lang["LABEL_REGISTER_MENU_CPASSWORD"][Player.lang]);
    temp.move(0, -(temp.height() + 25));
    ui.register.main.attach(temp);
    temp = null;
    ui.register.cpassword_textbox = Textbox(wW / 2 - 750, 2200, 1500, 300, "MENU_INGAME.TGA", "", "INV_TITEL.TGA", true);
    ui.register.main.attach(ui.register.cpassword_textbox);

    ui.register.ok_button = Button(wW / 2 - 600, 2800, 500, 300, "MENU_CHOICE_BACK.TGA", lang["BUTTON_REGISTER_MENU_OK"][Player.lang], "INV_TITEL.TGA");
    ui.register.main.attach(ui.register.ok_button);

    ui.register.back_button = Button(wW / 2 + 100, 2800, 500, 300, "MENU_CHOICE_BACK.TGA", lang["BUTTON_REGISTER_MENU_BACK"][Player.lang], "INV_TITEL.TGA");
    ui.register.main.attach(ui.register.back_button);
}

function deinitLoginState()
{
    setCursorVisible(false);

    destroy(ui.selection.main);
    destroy(ui.login.main);
    destroy(ui.register.main);

    ui = {
        selection = { main = null, login_button = null, register_button = null, exit_button = null },
        login = { main = null, login_textbox = null, password_textbox = null, ok_button = null, back_button = null },
        register = { main = null, login_textbox = null, password_textbox = null, cpassword_textbox = null, ok_button = null, back_button = null }
    };
}