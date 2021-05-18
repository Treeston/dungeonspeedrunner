DungeonSpeedRunner:RegisterInstanceData(558, { -- Auchenai Crypts
    version = 1,
    
    name = "Auchenai Crypts",
    maxLevel = 70,
    
    bosses = {
        shirrak = {
            name = "Shirrak the Dead Watcher",
            dbmModId = 523,
        },
        maladaar = {
            name = "Exarch Maladaar",
            dbmModId = 524,
        },
    },
    
    routes = {
        required = { "shirrak", "maladaar" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(556, { -- Sethekk Halls
    version = 1,
    
    name = "Sethekk Halls",
    maxLevel = 70,
    
    bosses = {
        syth = {
            name = "Darkweaver Syth",
            dbmModId = 541,
        },
        ikiss = {
            name = "Talon King Ikiss",
            dbmModId = 543,
        },
        anzu = {
            name = "Anzu",
            dbmModId = 542,
        },
    },
    
    routes = {
        regular = {
            name = "no Anzu",
            required = { "syth", "ikiss" },
        },
        anzu = {
            name = "with Anzu (Heroic only)",
            required = { "syth", "ikiss", "anzu" },
            difficultyMask = 0x4,
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(555, { -- Shadow Labyrinth
    version = 1,
    
    name = "Shadow Labyrinth",
    maxLevel = 70,
    
    bosses = {
        hellmaw = {
            name = "Ambassador Hellmaw",
            dbmModId = 544,
        },
        blackheart = {
            name = "Blackheart the Inciter",
            dbmModId = 545,
        },
        vorpil = {
            name = "Grandmaster Vorpil",
            dbmModId = 546,
        },
        murmur = {
            name = "Murmur",
            dbmModId = 547,
        },
    },
    
    routes = {
        required = { "hellmaw", "blackheart", "vorpil", "murmur" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(557, { -- Mana-Tombs
    version = 1,
    
    name = "Mana-Tombs",
    maxLevel = 70,
    
    bosses = {
        pandemonius = {
            name = "Pandemonius",
            dbmModId = 534,
        },
        tavarok = {
            name = "Tavarok",
            dbmModId = 535,
        },
        shaffar = {
            name = "Nexus-Prince Shaffar",
            dbmModId = 537,
        },
        yor = {
            name = "Yor",
            dbmModId = 536,
        },
    },
    
    routes = {
        regular = {
            name = "no Yor",
            required = { "pandemonius", "tavarok", "shaffar" },
        },
        yor = {
            name = "with Yor (Heroic only)",
            required = { "pandemonius", "tavarok", "shaffar", "yor" },
            difficultyMask = 0x4,
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(547, { -- Slave Pens
    version = 1,
    
    name = "The Slave Pens",
    maxLevel = 70,
    
    bosses = {
        mennu = {
            name = "Mennu the Betrayer",
            dbmModId = 570,
        },
        rokmar = {
            name = "Rokmar the Crackler",
            dbmModId = 571,
        },
        quagmirran = {
            name = "Quagmirran",
            dbmModId = 572,
        },
    },
    
    routes = {
        required = { "mennu", "rokmar", "quagmirran" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(545, { -- Steamvault
    version = 1,
    
    name = "The Steamvault",
    maxLevel = 70,
    
    bosses = {
        thespia = {
            name = "Hydromancer Thespia",
            dbmModId = 573,
        },
        steamrigger = {
            name = "Mekgineer Steamrigger",
            dbmModId = 574,
        },
        kalithresh = {
            name = "Warlord Kalithresh",
            dbmModId = 575,
        },
    },
    
    routes = {
        required = { "thespia", "steamrigger", "kalithresh" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(546, { -- The Underbog
    version = 1,
    
    name = "The Underbog",
    maxLevel = 70,
    
    bosses = {
        hungarfen = {
            name = "Hungarfen",
            dbmModId = 576,
        },
        ghazan = {
            name = "Ghaz'an",
            dbmModId = 577,
        },
        muselek = {
            name = "Swamplord Musel'ek",
            dbmModId = 578,
        },
        stalker = {
            name = "The Black Stalker",
            dbmModId = 579,
        },
    },
    
    routes = {
        required = { "hungarfen", "ghazan", "muselek", "stalker" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(269, { -- Black Morass
    version = 1,
    
    name = "CoT: Black Morass",
    maxLevel = 70,
    
    bosses = {
        aeonus = {
            name = "Aeonus",
            dbmModId = 554,
        },
        deja = {
            name = "Chrono Lord Deja",
            dbmModId = 552,
        },
        temporus = {
            name = "Temporus",
            dbmModId = 553,
        },
    },
    
    routes = {
        required = { "aeonus", "deja", "temporus" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(560, { -- Old Hillsbrad
    version = 1,
    
    name = "CoT: Old Hillsbrad",
    maxLevel = 70,
    
    bosses = {
        drake = {
            name = "Lieutenant Drake",
            dbmModId = 538,
        },
        skarloc = {
            name = "Captain Skarloc",
            dbmModId = 539,
        },
        baddragon = {
            name = "Epoch Hunter",
            dbmModId = 540,
        },
    },
    
    routes = {
        required = { "drake", "skarloc", "baddragon" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(542, { -- Blood Furnace
    version = 1,
    
    name = "The Blood Furnace",
    maxLevel = 70,
    
    bosses = {
        maker = {
            name = "The Maker",
            dbmModId = 555,
        },
        broggok = {
            name = "Broggok",
            dbmModId = 556,
        },
        kelidan = {
            name = "Keli'dan the Breaker",
            dbmModId = 557,
        },
    },
    
    routes = {
        required = { "maker", "broggok", "kelidan" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(543, { -- Hellfire Ramparts
    version = 1,
    
    name = "Hellfire Ramparts",
    maxLevel = 70,
    
    bosses = {
        gargolmar = {
            name = "Watchkeeper Gargolmar",
            dbmModId = 527,
        },
        omor = {
            name = "Omor the Unscarred",
            dbmModId = 528,
        },
        drakerider = {
            name = "Nazan & Vazruden",
            dbmModId = 529,
        },
    },
    
    routes = {
        required = { "gargolmar", "omor", "drakerider" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(540, { -- The Shattered Halls
    version = 1,
    
    name = "Shattered Halls",
    maxLevel = 70,
    
    bosses = {
        nethekurse = {
            name = "Grand Warlock Nethekurse",
            dbmModId = 566,
        },
        porung = {
            name = "Blood Guard Porung",
            dbmModId = 728,
        },
        omrogg = {
            name = "Warbringer O'mrogg",
            dbmModId = 568,
        },
        bladefist = {
            name = "Warchief Kargath Bladefist",
            dbmModId = 569,
        },
    },
    
    routes = {
        n = {
            name = nil,
            required = { "nethekurse", "omrogg", "bladefist" },
            difficultyMask = 0x2,
        },
        h = {
            name = nil,
            required = { "nethekurse", "porung", "omrogg", "bladefist" },
            difficultyMask = 0x4,
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(585, { -- Magisters' Terrace
    version = 1,
    
    name = "Magisters' Terrace",
    maxLevel = 70,
    
    bosses = {
        selin = {
            name = "Selin Fireheart",
            dbmModId = 530,
        },
        vexallus = {
            name = "Vexallus",
            dbmModId = 531,
        },
        delrissa = {
            name = "Priestess Delrissa",
            dbmModId = 532,
        },
        setback_boi = {
            name = "Kael'thas Sunstrider",
            dbmModId = 533,
        },
    },
    
    routes = {
        required = { "selin", "vexallus", "delrissa", "setback_boi" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(552, { -- The Arcatraz
    version = 1,
    
    name = "The Arcatraz",
    maxLevel = 70,
    
    bosses = {
        zereketh = {
            name = "Zereketh the Unbound",
            dbmModId = 548,
        },
        dalliah = {
            name = "Dalliah the Doomsayer",
            dbmModId = 549,
        },
        soccothrates = {
            name = "Wrath-Scryer Soccothrates",
            dbmModId = 550,
        },
        skyriss = {
            name = "Harbinger Skyriss",
            dbmModId = 551,
        },
    },
    
    routes = {
        required = { "zereketh", "dalliah", "soccothrates", "skyriss" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(553, { -- The Botanica
    version = 1,
    
    name = "The Botanica",
    maxLevel = 70,
    
    bosses = {
        sarannis = {
            name = "Commander Sarannis",
            dbmModId = 558,
        },
        freywinn = {
            name = "High Botanist Freywinn",
            dbmModId = 559,
        },
        thorngrin = {
            name = "Thorngrin the Tender",
            dbmModId = 560,
        },
        laj = {
            name = "Laj",
            dbmModId = 561,
        },
        splinter = {
            name = "Warp Splinter",
            dbmModId = 562,
        },
    },
    
    routes = {
        required = { "sarannis", "freywinn", "thorngrin", "laj", "splinter" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(554, { -- The Mechanar
    version = 1,
    
    name = "The Mechanar",
    maxLevel = 70,
    
    bosses = {
        capacitus = {
            name = "Mechano-Lord Capacitus",
            dbmModId = 563,
        },
        gyrokill = {
            name = "Gatewatcher Gyro-Kill",
            dbmModId = "Gyrokill",
        },
        ironhand = {
            name = "Gatewatcher Iron-Hand",
            dbmModId = "Ironhand",
        },
        sepethrea = {
            name = "Nethermancer Sepethrea",
            dbmModId = 564,
        },
        pathaleon = {
            name = "Pathaleon the Calculator",
            dbmModId = 565,
        },
    },
    
    routes = {
        required = { "capacitus", "gyrokill", "ironhand", "sepethrea", "pathaleon" },
    },
})

print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Loaded data for |cffffd300Burning Crusade Dungeons|r!")
