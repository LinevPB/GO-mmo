DEBUG <- true;

lang <- {
    ["SERVER_NAME"] = {
        ["en"]= "Memory",
        ["pl"]= "Memory"
    },

    ["BUTTON_MAIN_MENU_LOGIN"] = {
        ["en"]= "Sign in",
        ["pl"]= "Zaloguj"
    },

    ["BUTTON_MAIN_MENU_REGISTER"] = {
        ["en"]= "Sign up",
        ["pl"]= "Zarejestruj"
    },

    ["BUTTON_MAIN_MENU_QUIT"] = {
        ["en"]= "Quit",
        ["pl"]= "Wyjdź"
    },

    ///
    ["LABEL_LOGIN_MENU_USERNAME"] = {
        ["en"]= "Username",
        ["pl"]= "Login"
    },

    ["LABEL_LOGIN_MENU_PASSWORD"] = {
        ["en"]= "Password",
        ["pl"]= "Hasło"
    },

    ["BUTTON_LOGIN_MENU_OK"] = {
        ["en"]= "Ok",
        ["pl"]= "Ok"
    },

    ["BUTTON_LOGIN_MENU_BACK"] = {
        ["en"]= "Back",
        ["pl"]= "Wróć"
    },

    ///
    ["LABEL_REGISTER_MENU_USERNAME"] = {
        ["en"]= "Username",
        ["pl"]= "Login"
    },

    ["LABEL_REGISTER_MENU_PASSWORD"] = {
        ["en"]= "Password",
        ["pl"]= "Hasło"
    },

    ["LABEL_REGISTER_MENU_CPASSWORD"] = {
        ["en"]= "Confirm password",
        ["pl"]= "Powtórz hasło"
    },

    ["BUTTON_REGISTER_MENU_OK"] = {
        ["en"]= "Ok",
        ["pl"]= "Ok"
    },

    ["BUTTON_REGISTER_MENU_BACK"] = {
        ["en"]= "Back",
        ["pl"]= "Wróć"
    },

    //
    ["LABEL_CHAR_SELECTION_MENU_CHARACTERS"] = {
        ["en"]= "Characters",
        ["pl"]= "Postacie"
    },

    ["LABEL_CHAR_SELECTION_MENU_SLOT1"] = {
        ["en"]= "(Slot 1)",
        ["pl"]= "(Slot 1)"
    },

    ["LABEL_CHAR_SELECTION_MENU_SLOT2"] = {
        ["en"]= "(Slot 2)",
        ["pl"]= "(Slot 2)"
    },

    ["LABEL_CHAR_SELECTION_MENU_SLOT3"] = {
        ["en"]= "(Slot 3)",
        ["pl"]= "(Slot 3)"
    },

    ["BUTTON_CHAR_SELECTION_MENU_OK"] = {
        ["en"]= "Ok",
        ["pl"]= "Ok"
    },

    ["BUTTON_CHAR_SELECTION_MENU_CREATE"] = {
        ["en"]= "Create",
        ["pl"]= "Stwórz"
    },

    ["BUTTON_CHAR_SELECTION_MENU_SELECT"] = {
        ["en"]= "Select",
        ["pl"]= "Wybierz"
    },

    ["BUTTON_CHAR_SELECTION_MENU_QUIT"] = {
        ["en"]= "Quit",
        ["pl"]= "Wyjdź"
    },

    //
    ["LABEL_CREATION_TITLE"] = {
        ["en"]= "Creation",
        ["pl"]= "Kreacja"
    },

    ["LABEL_CREATION_NAME"] = {
        ["en"]= "Name:",
        ["pl"]= "Imię:"
    },

    ["LABEL_CREATION_MALE"] = {
        ["en"]= "Male",
        ["pl"]= "Mężczyzna"
    },

    ["LABEL_CREATION_FEMALE"] = {
        ["en"]= "Female",
        ["pl"]= "Kobieta"
    },

    ["LABEL_CREATION_SEX"] = {
        ["en"]= "Sex",
        ["pl"]= "Płeć"
    },

    ["LABEL_CREATION_BODYTEX"] = {
        ["en"]= "Body texture",
        ["pl"]= "Tekstura ciała"
    },

    ["LABEL_CREATION_HEADMODEL"] = {
        ["en"]= "Head model",
        ["pl"]= "Model głowy"
    },

    ["LABEL_CREATION_HEADTEX"] = {
        ["en"]= "Head texture",
        ["pl"]= "Tekstura głowy"
    },

    ["BUTTON_CREATION_OK"] = {
        ["en"]= "Create",
        ["pl"]= "Stwórz"
    },

    ["BUTTON_CREATION_BACK"] = {
        ["en"]= "Back",
        ["pl"]= "Wróć"
    }
};

Player <- {
    id = 0,
    gameState = GameState.UNKNOWN,
    canProceed = false,

    helper = createNpc("Glapiński"),
    bodyModel = ["Hum_Body_Naked0","Hum_Body_Babe0"],
    headModel = ["Hum_Head_FatBald","Hum_Head_Fighter","Hum_Head_Pony","Hum_Head_Bald","Hum_Head_Thief","Hum_Head_Psionic","Hum_Head_Babe"],
    cBodyModel = 0,
    cBodyTexture = 1,
    cHeadModel = 6,
    cHeadTexture = 108,
    music = Sound("muzyka.wav"),
    lang = "en",
    charSlot = -1,
    eqArmor = "",
    eqWeapon = "",
    eqWeapon2h = "",
    items = []
};

Player.updateVisual <- function(id = -1)
{
    if (id == -1) id = heroId;
    setPlayerVisual(id, Player.bodyModel[Player.cBodyModel], Player.cBodyTexture, Player.headModel[Player.cHeadModel], Player.cHeadTexture);
}

Player.manageItem <- function(act, instance, amount)
{
    if (act == 0 || act == 1) {
        foreach(v in Player.items) {
            if (v.instance == instance)
                return v.amount += amount;
        }
        Player.items.append({instance = instance, amount = amount });
    } else {
        foreach(i, v in Player.items) {
            if (v.instance == instance) {
                v.amount -= amount;
                if (v.amount < 0) {
                    v.amount = 0;
                    return Player.items.remove(i);
                }
            }
        }
    }
}

Player.updateEquipped <- function(armor, weapon, ranged)
{
    if (armor != Player.eqArmor) {
        if (armor == "-1") {
            unequipItem(Player.helper, Items.id(Player.eqArmor));
        }
        Player.eqArmor = armor;
        equipItem(Player.helper, Items.id(armor));
    }

    if (weapon != Player.eqWeapon) {
        if (weapon == "-1") {
            unequipItem(Player.helper, Items.id(Player.eqWeapon));
        }
        Player.eqWeapon = weapon;
        setPlayerDexterity(Player.helper, 300);
        setPlayerStrength(Player.helper, 300);
        equipItem(Player.helper, Items.id(weapon));
    }

    if (ranged != Player.eqWeapon2h) {
        if (ranged == "-1") {
            unequipItem(Player.helper, Items.id(Player.eqWeapon2h));
        }
        Player.eqWeapon2h = ranged;
        setPlayerDexterity(Player.helper, 300);
        setPlayerStrength(Player.helper, 300);
        equipItem(Player.helper, Items.id(ranged));
    }
}