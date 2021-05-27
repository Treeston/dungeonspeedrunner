DungeonSpeedRunner:RegisterInstanceData(230, { -- Blackrock Depths
    version = 1,
    
    name = "Blackrock Depths",
    maxLevel = 60,
    
    bosses = {
        ambassador = {
            name = "Ambassador Flamelash",
            dbmModId = 384,
        },
        baelgar = {
            name = "Bael'Gar",
            dbmModId = 377,
        },
        emperor = {
            name = "Emperor Dagran Thaurissan",
            dbmModId = 387,
        },
        fineous = {
            name = "Fineous Darkvire",
            dbmModId = 376,
        },
        angerforge = {
            name = "General Angerforge",
            dbmModId = 378,
        },
        arena = {
            name = "Ring of Law",
            dbmModId = 372,
        },
        interrogator = {
            name = "High Interrogator Gerstahn",
            dbmModId = 369,
        },
        argelmach = {
            name = "Golem Lord Argelmach",
            dbmModId = 379,
        },
        grebmar = {
            name = "Houndmaster Grebmar",
            dbmModId = 371,
        },
        hurley = {
            name = "Hurley Blackbreath",
            dbmModId = 380,
        },
        incendius = {
            name = "Lord Incendius",
            dbmModId = 374,
        },
        roccor = {
            name = "Lord Roccor",
            dbmModId = 370,
        },
        magmus = {
            name = "Magmus",
            dbmModId = 386,
        },
        phalanx = {
            name = "Phalanx",
            dbmModId = 381,
        },
        barkeeper = {
            name = "Plugger Spazzring",
            dbmModId = 383,
        },
        pyromancer = {
            name = "Pyromancer Loregrain",
            dbmModId = 373,
        },
        seven = {
            name = "The Seven",
            dbmModId = 385,
        },
        stilgiss = {
            name = "Warder Stilgiss",
            dbmModId = 375,
        },
    },
    splits = {},
    
    routes = {
        firsthalf = {
            name = "1st Half (Prison, Vault, Shadowforge Key)",
            required = { "fineous", "arena", "interrogator", "incendius", "stilgiss", "pyromancer" },
        },
        secondhalf = {
            name = "2nd Half (Angerforge to Emperor)",
            required = { "emperor", "angerforge", "argelmach", "seven" },
        },
        lava = {
            name = "Lava Run (Emperor only)",
            required = { "emperor" },
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(229, { -- Blackrock Spire
    version = 1,
    
    name = "Blackrock Spire",
    maxLevel = 60,
    
    bosses = {
        -- LBRS
        daddyworg = {
            name = "Gizrul the Slavener",
            dbmModId = 395,
        },
        mommyworg = {
            name = "Halycon",
            dbmModId = 394,
        },
        omokk = {
            name = "Highlord Omokk",
            dbmModId = 388,
        },
        smolderweb = {
            name = "Mother Smolderweb",
            dbmModId = 391,
        },
        wyrmthalak = {
            name = "Overlord Wyrmthalak",
            dbmModId = 396,
        },
        zigris = {
            name = "Quartermaster Zigris",
            dbmModId = 393,
        },
        voshgajin = {
            name = "Shadow Hunter Vosh'gajin",
            dbmModId = 389,
        },
        voone = {
            name = "War Master Voone",
            dbmModId = 390,
        },
        
        -- UBRS
        drakkisath = {
            name = "General Drakkisath",
            dbmModId = "GeneralDrakkisath",
        },
        jed = {
            name = "Jed Runewatcher",
            dbmModId = "JedRunewatcher",
        },
        goraluk = {
            name = "Goraluk Anvilcrack",
            dbmModId = "GoralukAnvilcrack",
        },
        pyroguard = {
            name = "Pyroguard Emberseer",
            dbmModId = "PyroguardEmberseer",
        },
        solakar = {
            name = "Solakar Flamewreath",
            dbmModId = "SolakarFlamewreath",
        },
        beast = {
            name = "The Beast",
            dbmModId = "TheBeast",
        },
        rend = {
            name = "Rend Blackhand",
            dbmModId = "WarchiefRendBlackhand",
        },
    },
    
    routes = {
        lbrs = {
            name = "Lower",
            required = { "omokk", "voshgajin", "voone", "smolderweb", "zigris", "mommyworg", "daddyworg", "wyrmthalak" },
        },
        rend = {
            name = "Rend",
            required = { "rend" },
        },
        ubrs = {
            name = "Upper",
            required = { "rend", "beast", "drakkisath" },
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(429, { -- Dire Maul
    version = 1,
    
    name = "Dire Maul",
    maxLevel = 60,
    
    bosses = {
        -- East
        alzzin = {
            name = "Alzzin the Wildshaper",
            dbmModId = 405,
        },
        hydrospawn = {
            name = "Hydrospawn",
            dbmModId = 403,
        },
        lethtendris = {
            name = "Lethtendris",
            dbmModId = 404,
        },
        zevrim = {
            name = "Zevrim Thornhoof",
            dbmModId = 402,
        },
        
        -- West
        illyanna = {
            name = "Illyanna Ravenoak",
            dbmModId = 407,
        },
        immolthar = {
            name = "Immol'thar",
            dbmModId = 409,
        },
        kalendris = {
            name = "Magister Kalendris",
            dbmModId = 408,
        },
        tortheldrin = {
            name = "Prince Tortheldrin",
            dbmModId = 410,
        },
        warpwood = {
            name = "Tendris Warpwood",
            dbmModId = 406,
        },
        
        -- North
        kromcrush = {
            name = "Captain Kromcrush",
            dbmModId = 415,
        },
        chorush = {
            name = "Cho'Rush the Observer",
            dbmModId = 416,
        },
        fengus = {
            name = "Guard Fengus",
            dbmModId = 413,
        },
        moldar = {
            name = "Guard Mol'dar",
            dbmModId = 411,
        },
        slipkik = {
            name = "Guard Slip'kik",
            dbmModId = 414,
        },
        gordok = {
            name = "King Gordok",
            dbmModId = 417,
        },
        kreeg = {
            name = "Stomper Kreeg",
            dbmModId = 412,
        },
    },
    
    routes = {
        east = {
            name = "East",
            required = { "lethtendris", "hydrospawn", "zevrim", "alzzin" },
        },
        west = {
            name = "West",
            required = { "warpwood", "kalendris", "illyanna", "immolthar", "tortheldrin" },
        },
        north = {
            name = "North",
            required = { "moldar", "kreeg", "fengus", "slipkik", "kromcrush", "chorush", "gordok" },
        },
        tribute = {
            name = "Tribute",
            required = { "gordok" },
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(289, { -- Scholomance
    version = 1,
    
    name = "Scholomance",
    maxLevel = 60,
    
    bosses = {
        gandling = {
            name = "Darkmaster Gandling",
            dbmModId = "DarkmasterGandling",
        },
        krastinov = {
            name = "Doctor Theloen Krastinov",
            dbmModId = "DoctorTheolenKrastinov",
        },
        malicia = {
            name = "Instructor Malicia",
            dbmModId = "InstructorMalicia",
        },
        jandice = {
            name = "Jandice Barov",
            dbmModId = "JandiceBarov",
        },
        kirtonos = {
            name = "Kirtonos the Herald",
            dbmModId = "KirtonostheHerald",
        },
        illucia = {
            name = "Lady Illucia Barov",
            dbmModId = "LadyIlluciaBarov",
        },
        alexei = {
            name = "Lord Alexei Barov",
            dbmModId = "LordAlexeiBarov",
        },
        lorekeeper = {
            name = "Lorekeeper Polkelt",
            dbmModId = "LorekeeperPolkelt",
        },
        marduk = {
            name = "Marduk Blackpool",
            dbmModId = "MardukBlackpool",
        },
        ras = {
            name = "Ras Frostwhisper",
            dbmModId = "RasFrostwhisper",
        },
        rattlegore = {
            name = "Rattlegore",
            dbmModId = "Rattlegore",
        },
        ravenian = {
            name = "The Ravenian",
            dbmModId = "TheRavenian",
        },
        vectus = {
            name = "Vectus",
            dbmModId = "Vectus",
        },
    },
    routes = {
        required = { "kirtonos", "jandice", "rattlegore", "ras", "gandling" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(329, { -- Stratholme
    version = 1,
    
    name = "Stratholme",
    maxLevel = 60,
    
    bosses = {
        balnazzar = {
            name = "Balnazzar",
            dbmModId = 449,
        },
        anastari = {
            name = "Baroness Anastari",
            dbmModId = 451,
        },
        malor = {
            name = "Malor the Zealous",
            dbmModId = 749,
        },
        forresten = {
            name = "Hearthsinger Forresten",
            dbmModId = 443,
        },
        galford = {
            name = "Archvist Galford",
            dbmModId = 448,
        },
        rivendare = {
            name = "Baron Rivendare",
            dbmModId = 456,
        },
        barthilas = {
            name = "Magistrate Barthilas",
            dbmModId = 454,
        },
        maleki = {
            name = "Maleki the Pallid",
            dbmModId = 453,
        },
        nerubenkan = {
            name = "Nerub'enkan",
            dbmModId = 452,
        },
        ramstein = {
            name = "Ramstein the Gorger",
            dbmModId = 455,
        },
        unforgiven = {
            name = "The Unforgiven",
            dbmModId = 450,
        },
        timmy = {
            name = "Timmy the Cruel",
            dbmModId = 445,
        },
        willey = {
            name = "Cannon Master Willey",
            dbmModId = 446,
        },
    },
    
    routes = {
        living = {
            name = "Living",
            required = { "forresten", "unforgiven", "timmy", "malor", "willey", "galford", "balnazzar" },
        },
        undead = {
            name = "Undead",
            required = { "nerubenkan", "maleki", "anastari", "barthilas", "ramstein", "rivendare" },
        },
    },
})

print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Loaded data for |cffffd300Level 60 Dungeons|r!")
