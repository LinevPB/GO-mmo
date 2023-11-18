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

function onPressButton(id) {
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

function onPressTextbox(id)
{
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
    clearMultiplayerMessages();
    setCursorVisible(true);
    setCursorTxt("LO.TGA");
    setCursorPosition(0, 0);
    setCursorSensitivity(1.0);
    // main window
    ui.selection.main = Window(1000, 666, 2222, 2222, "DLG_CONVERSATION.TGA");

    ui.selection.login_button = Button(0, 0, 500, 200, "INV_SLOT_FOCUS.TGA", "Log In", "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.login_button);

    ui.selection.register_button = Button(0, 400, 500, 200, "INV_SLOT_FOCUS.TGA", "Sign Up", "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.register_button);

    ui.selection.exit_button = Button(0, 800, 500, 200, "INV_SLOT_FOCUS.TGA", "Quit", "INV_TITEL.TGA");
    ui.selection.main.attach(ui.selection.exit_button);

    ui.selection.main.enable(true);

    ///////////////
    // login window
    ui.login.main = Window(1000, 666, 2222, 2222, "DLG_CONVERSATION.TGA");

    ui.login.login_textbox = Textbox(0, 0, 1500, 200, "INV_SLOT_FOCUS.TGA", "Wpisz login..", "INV_TITEL.TGA", false);
    ui.login.main.attach(ui.login.login_textbox);

    ui.login.password_textbox = Textbox(0, 300, 1500, 200, "INV_SLOT_FOCUS.TGA", "Wpisz haslo..", "INV_TITEL.TGA", true);
    ui.login.main.attach(ui.login.password_textbox);

    ui.login.ok_button = Button(0, 600, 500, 200, "INV_SLOT_FOCUS.TGA", "Ok", "INV_TITEL.TGA");
    ui.login.main.attach(ui.login.ok_button);

    ui.login.back_button = Button(700, 600, 500, 200, "INV_SLOT_FOCUS.TGA", "Back", "INV_TITEL.TGA");
    ui.login.main.attach(ui.login.back_button);

    //////////////////
    // register window
    ui.register.main = Window(1000, 666, 2222, 2222, "DLG_CONVERSATION.TGA");

    ui.register.login_textbox = Textbox(0, 0, 1500, 200, "INV_SLOT_FOCUS.TGA", "Wpisz login..", "INV_TITEL.TGA", false);
    ui.register.main.attach(ui.register.login_textbox);

    ui.register.password_textbox = Textbox(0, 300, 1500, 200, "INV_SLOT_FOCUS.TGA", "Wpisz haslo..", "INV_TITEL.TGA", true);
    ui.register.main.attach(ui.register.password_textbox);

    ui.register.cpassword_textbox = Textbox(0, 600, 1500, 200, "INV_SLOT_FOCUS.TGA", "Potwierdz haslo..", "INV_TITEL.TGA", true);
    ui.register.main.attach(ui.register.cpassword_textbox);

    ui.register.ok_button = Button(0, 900, 500, 200, "INV_SLOT_FOCUS.TGA", "Ok", "INV_TITEL.TGA");
    ui.register.main.attach(ui.register.ok_button);

    ui.register.back_button = Button(700, 900, 500, 200, "INV_SLOT_FOCUS.TGA", "Back", "INV_TITEL.TGA");
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