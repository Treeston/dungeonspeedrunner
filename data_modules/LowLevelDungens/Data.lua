GottaGoFast:RegisterInstanceData(48, { -- Blackfathom Deeps
    version = 1,
    
    name = "Blackfathom Deeps",
    maxLevel = 28,
    
    bosses = {
        kelris = {
            name = "Twilight Lord Kelris",
            dbmModId = "TwilightLordKelris",
        },
        turtle = {
            name = "Ghamoo-ra",
            dbmModId = "GhamooRa",
        },
        sarevess = {
            name = "Lady Sarevess",
            dbmModId = "LadySerevess",
        },
        nessie = {
            name = "Old Serra'kis",
            dbmModId = "OldSerrakis",
        },
        akumai = {
            name = "Aku'mai",
            dbmModId = "Akumai",
        },
        gelihast = {
            name = "Gelihast",
            dbmModId = "Gelihast",
        },
    },
    
    routes = {
        required = { "gelihast", "kelris", "sarevess", "turtle", "akumai" },
    },
})

GottaGoFast:RegisterInstanceData(90, { -- Gnomeregan
    version = 1,
    
    name = "Gnomeregan",
    maxLevel = 32,
    
    bosses = {
        pummeler = {
            name = "Crowd Pummeler 9-60",
            dbmModId = 418,
        },
        electrocutioner = {
            name = "Electrocutioner 6000",
            dbmModId = 421,
        },
        grubbis = {
            name = "Grubbis",
            dbmModId = 419,
        },
        thermaplugg = {
            name = "Mekgineer Thermaplugg",
            dbmModId = 422,
        },
        fallout = {
            name = "Viscous Fallout",
            dbmModId = 420,
        },
    },
    
    routes = {
        feraldruid = {
            name = "Feral Druid Run (Pummeler only)",
            required = { "pummeler" },
        },
        fullrun = {
            name = "Full Run",
            required = { "grubbis", "thermaplugg", "fallout", "electrocutioner", "pummeler" },
        },
        thermaplugg = {
            name = "Any%",
            required = { "thermaplugg" },
        },
    },
})

GottaGoFast:RegisterInstanceData(349, { -- Maraudon
    version = 1,
    
    name = "Maraudon",
    maxLevel = 54,
    
    bosses = {
        princess = {
            name = "Princess Theradras",
            dbmModId = 431,
        },
        vyletongue = {
            name = "Lord Vyletongue",
            dbmModId = 427,
        },
        noxxion = {
            name = "Noxxion",
            dbmModId = 423,
        },
        celebras = {
            name = "Celebras the Cursed",
            dbmModId = 428,
        },
    },
    
    routes = {
        purple = {
            name = "Purple Side",
            required = { "vyletongue" },
        },
        orange = {
            name = "Orange Side",
            required = { "noxxion" },
        },
        princess = {
            name = "Princess Only",
            required = { "princess" },
        },
        full = {
            name = "Full Run",
            required = { "vyletongue", "noxxion", "celebras", "princess" },
        },
    }
})

GottaGoFast:RegisterInstanceData(389, { -- Ragefire Chasm
    version = 1,
    
    name = "Ragefire Chasm",
    maxLevel = 20,
    
    bosses = {
        taragaman = {
            name = "Taragaman",
            dbmModId = "Taragaman",
        },
        oggleflint = {
            name = "Oggleflint",
            dbmModId = "Oggleflint",
        },
        jergosh = {
            name = "Jergosh",
            dbmModId = "Jergosh",
        },
        bazzalan = {
            name = "Bazzalan",
            dbmModId = "Bazzalan",
        },
    },
    
    routes = {
        required = { "taragaman", "oggleflint", "jergosh", "bazzalan" },
    },
})

GottaGoFast:RegisterInstanceData(129, { -- Razorfen Downs
    version = 1,
    
    name = "Razorfen Downs",
    maxLevel = 42,
    
    bosses = {
        coldbringer = {
            name = "Amnennar the Coldbringer",
            dbmModId = "AmnennartheColdbringer",
        },
        glutton = {
            name = "Glutton",
            dbmModId = "Glutton",
        },
        mordresh = {
            name = "Mordresh Fire Eye",
            dbmModId = "MordreshFireEye",
        },
        plaguemaw = {
            name = "Plaguemaw the Rotting",
            dbmModId = "PlaguemawtheRotting",
        },
        ragglesnout = {
            name = "Ragglesnout",
            dbmModId = "Ragglesnout",
        },
        tutenkash = {
            name = "Tuten'kash",
            dbmModId = "Tutenkash",
        },
    },
    
    routes = {
        required = { "tutenkash", "mordresh", "glutton", "coldbringer" },
    },
})

GottaGoFast:RegisterInstanceData(47, { -- Razorfen Kraul
    version = 1,
    
    name = "Razorfen Kraul",
    maxLevel = 32,
    
    bosses = {
        roogug = {
            name = "Roogug",
            dbmModId = "Roogug",
        },
        aggem = {
            name = "Aggem Thorncurse",
            dbmModId = "AggemThorncurse",
        },
        jargba = {
            name = "Death Speaker Jargba",
            dbmModId = "DeathSpeakerJargba",
        },
        ramtusk = {
            name = "Overlord Ramtusk",
            dbmModId = "OverlordRamtusk",
        },
        boar = {
            name = "Agathelos the Raging",
            dbmModId = "AgathelostheRaging",
        },
        charlga = {
            name = "Charlga Razorflank",
            dbmModId = "CharlgaRazorflank",
        },
    },
    
    routes = {
        required = { "aggem", "jargba", "ramtusk", "boar", "charlga" },
    },
})

GottaGoFast:RegisterInstanceData(189, { -- Scarlet Monastery
    version = 1,
    
    name = "Scarlet Monastery",
    maxLevel = 47,
    
    bosses = {
        thalnos = {
            name = "Bloodmage Thalnos",
            dbmModId = "BloodmageThalnos",
        },
        vishas = {
            name = "Interrogator Vishas",
            dbmModId = "InterrogatorVishas",
        },
        houndmaster = {
            name = "Houndmaster Loksey",
            dbmModId = "HoundmasterLoksey",
        },
        doan = {
            name = "Arcanist Doan",
            dbmModId = "ArcanistDoan",
        },
        herod = {
            name = "Herod",
            dbmModId = "Herod",
        },
        whitemane = {
            name = "Mograine & Whitemane",
            dbmModId = "Mograine_and_Whitemane",
        },
    },
    
    routes = {
        graveyard = {
            name = "Graveyard",
            required = { "vishas", "thalnos" },
        },
        library = {
            name = "Library",
            required = { "houndmaster", "doan" },
        },
        armory = {
            name = "Armory",
            required = { "herod" },
        },
        cathedral = {
            name = "Cathedral",
            required = { "whitemane" },
        },
    },
})

GottaGoFast:RegisterInstanceData(33, { -- Shadowfang Keep
    version = 1,
    
    name = "Shadowfang Keep",
    maxLevel = 24,
    
    bosses = {
        arugal = {
            name = "Archmage Arugal",
            dbmModId = "ArchmageArugal",
        },
        razorclaw = {
            name = "Razorclaw the Butcher",
            dbmModId = "RazorclawtheButcher",
        },
        silverlaine = {
            name = "Baron Silverlaine",
            dbmModId = "BaronSilverlaine",
        },
        springvale = {
            name = "Commander Springvale",
            dbmModId = "CommanderSpringvale",
        },
        odo = {
            name = "Odo the Blindwatcher",
            dbmModId = "OdotheBlindwatcher",
        },
        fenrus = {
            name = "Fenrus the Devourer",
            dbmModId = "FenrustheDevourer",
        },
        wolfmaster = {
            name = "Wolf Master Nandos",
            dbmModId = "WolfMasterNandos",
        },
        rethilgore = {
            name = "Rethilgore",
            dbmModId = "Rethilgore",
        },
    },
    
    routes = {
        required = { "silverlaine", "springvale", "arugal" },
    },
})

GottaGoFast:RegisterInstanceData(36, { -- Deadmines
    version = 1,
    
    name = "The Deadmines",
    maxLevel = 23,
    
    bosses = {
        greenskin = {
            name = "Captain Greenskin",
            dbmModId = "CaptainGreenskin",
        },
        rhahkzor = {
            name = "Rhahk'Zor",
            dbmModId = "RhahkZor",
        },
        sneed = {
            name = "Sneed",
            dbmModId = "SneedsShredder",
        },
        gilnid = {
            name = "Gilnid",
            dbmModId = "Gilnid",
        },
        smite = {
            name = "Mr. Smite",
            dbmModId = "MrSmite",
        },
        vancleef = {
            name = "Edwin VanCleef",
            dbmModId = "EdwinVanCleef",
        },
    },
    
    routes = {
        required = { "smite", "gilnid", "sneed", "vancleef" },
    },
})

GottaGoFast:RegisterInstanceData(34, { -- Stockades
    version = 1,
    
    name = "The Stockade",
    maxLevel = 30,
    
    bosses = {
        targorr = {
            name = "Targorr the Dread",
            dbmModId = "Targorr",
        },
        kam = {
            name = "Kam Deepfury",
            dbmModId = "KamDeepfury",
        },
        hamhock = {
            name = "Hamhock",
            dbmModId = "Hamhock",
        },
        dextren = {
            name = "Dextren Ward",
            dbmModId = "DextrenWard",
        },
        bazil = {
            name = "Bazil Thredd",
            dbmModId = "BazilThredd";
        },
    },
    
    routes = {
        required = { "targorr", "kam", "hamhock", "dextren", "bazil" },
    },
})

GottaGoFast:RegisterInstanceData(109, { -- Sunken Temple
    version = 1,
    
    name = "Sunken Temple",
    maxLevel = 59,
    
    bosses = {
        avatar = {
            name = "Avatar of Hakkar",
            dbmModId = 457,
        },
        jammalan = {
            name = "Jammalan";
            dbmModId = 458,
        },
        eranikus = {
            name = "Shade of Eranikus",
            dbmModId = 463,
        },
    },
    
    routes = {
        required = { "eranikus" },
    },
})

GottaGoFast:RegisterInstanceData(70, { -- Uldaman
    version = 1,
    
    name = "Uldaman",
    maxLevel = 49,
    
    bosses = {
        revelosh = {
            name = "Revelosh",
            dbmModId = 467,
        },
        dwarves = {
            name = "Lost Dwarves",
            dbmModId = 468,
        },
        ironaya = {
            name = "Ironaya",
            dbmModId = 469,
        },
        sentinel = {
            name = "Obsidian Sentinel",
            dbmModId = 748,
        },
        keeper = {
            name = "Ancient Stone Keeper",
            dbmModId = 470,
        },
        galgann = {
            name = "Galgann Firehammer",
            dbmModId = 471,
        },
        grimlok = {
            name = "Grimlok",
            dbmModId = 472,
        },
        archaedas = {
            name = "Archaedas",
            dbmModId = 473,
        },
    },
    
    routes = {
        required = { "revelosh", "ironaya", "sentinel", "keeper", "galgann", "grimlok", "archaedas" },
    },
})

GottaGoFast:RegisterInstanceData(43, { -- Wailing Caverns
    version = 1,
    
    name = "Wailing Caverns",
    maxLevel = 23,
    
    bosses = {
        anacondra = {
            name = "Lady Anacondra",
            dbmModId = 474,
        },
        cobrahn = {
            name = "Lord Cobrahn",
            dbmModId = 475,
        },
        pythas = {
            name = "Lord Pythas",
            dbmModId = 476,
        },
        serpentis = {
            name = "Lord Serpentis",
            dbmModId = 479,
        },
        mutanus = {
            name = "Mutanus the Devourer",
            dbmModId = 481,
        },
        skum = {
            name = "Skum",
            dbmModId = 478,
        },
        veran = {
            name = "Verdan the Everliving",
            dbmModId = 480,
        },
        kresh = {
            name = "Kresh",
            dbmModId = 477,
        },
    },
    
    routes = {
        required = { "anacondra", "cobrahn", "pythas", "serpentis", "mutanus", "skum", "veran", "kresh" },
    },
})

GottaGoFast:RegisterInstanceData(209, { -- Zul'Farrak
    version = 1,
    
    name = "Zul'Farrak",
    maxLevel = 54,
    
    bosses = {
        antusul = {
            name = "Antu'sul",
            dbmModId = 484,
        },
        theka = {
            name = "Theka the Martyr",
            dbmModId = 485,
        },
        stairs = {
            name = "Nekrum & Sezz'ziz",
            dbmModId = 487,
        },
        zumrah = {
            name = "Witch Doctor Zum'rah",
            dbmModId = 486,
        },
        velratha = {
            name = "Hydromancer Velratha",
            dbmModId = "HydromancerVelrath",
        },
        ukorz = {
            name = "Chief Ukorz Sandscalp",
            dbmModId = 489,
        },
    },
    routes = {
        required = { "antusul", "zumrah", "stairs", "velratha", "ukorz" },
    },
})

print("GottaGoFast: Loaded data for |cff999900Low-Level Dungeons|r")
