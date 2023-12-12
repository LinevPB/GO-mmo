ServerItems.add({
    name = {
        ["en"] = "Ice lance",
        ["pl"] = "Lodowa lanca"
    },
    instance = "ITSC_ICELANCE",
    type = ItemType.MAGIC,
    rune = false,
    magicLevelRequired = 0,

    cost = {
        health = 0,
        mana = 20
    }

    damage = {
        physical = 0,
        magical = 100
    },

    price = 100
});

ServerItems.add({
    name = {
        ["en"] = "Ice lance",
        ["pl"] = "Lodowa lanca"
    },
    instance = "ITRU_ICELANCE",
    type = ItemType.MAGIC,
    rune = true,
    magicLevelRequired = 2,

    cost = {
        health = 0,
        mana = 20
    }

    damage = {
        physical = 0,
        magical = 100
    },

    price = 4000
});

ServerItems.add({
    name = {
        ["en"] = "Ice shot",
        ["pl"] = "Lodowy strzał"
    },
    instance = "ITRU_ICEBOLT",
    type = ItemType.MAGIC,
    rune = true,
    magicLevelRequired = 2,

    cost = {
        health = 0,
        mana = 20
    }

    damage = {
        physical = 0,
        magical = 100
    },

    price = 4000
});

ServerItems.add({
    name = {
        ["en"] = "Storm",
        ["pl"] = "Sztorm"
    },
    instance = "ITRU_THUNDERSTORM",
    type = ItemType.MAGIC,
    rune = true,
    magicLevelRequired = 4,

    cost = {
        health = 0,
        mana = 40
    }

    damage = {
        physical = 0,
        magical = 150
    },

    price = 4000
});