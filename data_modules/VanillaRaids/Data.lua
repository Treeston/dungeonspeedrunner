DungeonSpeedRunner:RegisterInstanceData(249, { -- Onyxia
    version = 1,
    
    name = "Onyxia's Lair",
    maxLevel = 60,
    
    bosses = {
        ony = {
            name = "Onyxia",
            dbmModId = "Onyxia",
        },
    },
    
    routes = { required = { "ony" } },
})

DungeonSpeedRunner:RegisterInstanceData(309, { -- Zul'Gurub
    version = 1,
    
    name = "Zul'Gurub",
    maxLevel = 60,
    
    bosses = {
        arlokk = {
            name = "High Priestess Arlokk",
            dbmModId = "Arlokk",
        },
        mandokir = {
            name = "Bloodlord Mandokir",
            dbmModId = "Bloodlord",
        },
        hakkar = {
            name = "Hakkar",
            dbmModId = "Hakkar",
        },
        jeklik = {
            name = "High Priestess Jeklik",
            dbmModId = "Jeklik",
        },
        jindo = {
            name = "Jin'do the Hexxer",
            dbmModId = "Jindo",
        },
        marli = {
            name = "High Priestess Mar'li",
            dbmModId = "Marli",
        },
        thekal = {
            name = "High Priest Thekal",
            dbmModId = "Thekal",
        },
        venoxis = {
            name = "High Priest Venoxis",
            dbmModId = "Venoxis",
        },
    },
    
    routes = {
        required = { "venoxis", "jeklik", "marli", "mandokir", "thekal", "arlokk", "jindo", "hakkar" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(409, { -- Molten Core
    version = 1,
    
    name = "Molten Core",
    maxLevel = 60,
    
    bosses = {
        garr = {
            name = "Garr",
            dbmModId = "Garr-Classic",
        },
        geddon = {
            name = "Baron Geddon",
            dbmModId = "Geddon",
        },
        gehennas = {
            name = "Gehennas",
            dbmModId = "Gehennas",
        },
        golemagg = {
            name = "Golemagg the Incinerator",
            dbmModId = "Golemagg",
        },
        lucifron = {
            name = "Lucifron",
            dbmModId = "Lucifron",
        },
        magmadar = {
            name = "Magmadar",
            dbmModId = "Magmadar",
        },
        majordomo = {
            name = "Majordomo Executus",
            dbmModId = "Majordomo",
        },
        ragnaros = {
            name = "Ragnaros",
            dbmModId = "Ragnaros-Classic",
        },
        shazzrah = {
            name = "Shazzrah",
            dbmModId = "Shazzrah",
        },
        harbinger = {
            name = "Sulfuron Harbinger",
            dbmModId = "Sulfuron",
        },
    },
    
    routes = {
        required = { "lucifron", "magmadar", "gehennas", "garr", "shazzrah", "geddon", "golemagg", "harbinger", "majordomo", "ragnaros" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(469, { -- Blackwing Lair
    version = 1,
    
    name = "Blackwing Lair",
    maxLevel = 60,
    
    bosses = {
        broodlord = {
            name = "Broodlord Lashlayer",
            dbmModId = "Broodlord",
        },
        chromaggus = {
            name = "Chromaggus",
            dbmModId = "Chromaggus",
        },
        ebonroc = {
            name = "Ebonroc",
            dbmModId = "Ebonroc",
        },
        firemaw = {
            name = "Firemaw",
            dbmModId = "Firemaw",
        },
        flamegor = {
            name = "Flamegor",
            dbmModId = "Flamegor",
        },
        nefarian = {
            name = "Nefarian",
            dbmModId = "Nefarian-Classic",
        },
        razorgore = {
            name = "Razorgore",
            dbmModId = "Razorgore",
        },
        vaelastrasz = {
            name = "Vaelastrasz",
            dbmModId = "Vaelastrasz",
        },
    },
    
    routes = {
        required = { "razorgore", "vaelastrasz", "broodlord", "firemaw", "ebonroc", "flamegor", "chromaggus", "nefarian" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(509, { -- AQ20
    version = 1,
    
    name = "Ruins of Ahn'Qiraj",
    maxLevel = 60,
    
    bosses = {
        ayamiss = {
            name = "Ayamiss the Hunter",
            dbmModId = "Ayamiss",
        },
        buru = {
            name = "Buru the Gorger",
            dbmModId = "Buru",
        },
        kurinnaxx = {
            name = "Kurinnaxx",
            dbmModId = "Kurinnaxx",
        },
        moam = {
            name = "Moam",
            dbmModId = "Moam",
        },
        ossirian = {
            name = "Ossirian the Unscarred",
            dbmModId = "Ossirian",
        },
        rajaxx = {
            name = "General Rajaxx",
            dbmModId = "Rajaxx",
        },
    },
    
    routes = {
        nofly = {
            name = "No Ayamiss",
            required = { "kurinnaxx", "rajaxx", "moam", "buru", "ossirian" },
        },
        full = {
            name = "All Bosses",
            required = { "kurinnaxx", "rajaxx", "moam", "buru", "ayamiss", "ossirian" },
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(531, { -- AQ40
    version = 1,
    
    name = "Temple of Ahn'Qiraj",
    maxLevel = 60,
    
    bosses = {
        cthun = {
            name = "C'Thun",
            dbmModId = "CThun",
        },
        fankriss = {
            name = "Fankriss the Unyielding",
            dbmModId = "Fankriss",
        },
        huhuran = {
            name = "Princess Huhuran",
            dbmModId = "Huhuran",
        },
        ouro = {
            name = "Ouro",
            dbmModId = "Ouro",
        },
        sartura = {
            name = "Battleguard Sartura",
            dbmModId = "Sartura",
        },
        skeram = {
            name = "The Prophet Skeram",
            dbmModId = "Skeram",
        },
        trio = {
            name = "Bug Trio",
            dbmModId = "ThreeBugs",
        },
        twins = {
            name = "Twin Emperors",
            dbmModId = "TwinEmpsAQ",
        },
        viscidus = {
            name = "Viscidus",
            dbmModId = "Viscidus",
        },
    },
    
    routes = {
        any = {
            name = "Any%",
            required = { "skeram", "sartura", "fankriss", "huhuran", "twins", "cthun" },
        },
        full = {
            name = "100%",
            required = { "skeram", "sartura", "fankriss", "huhuran", "twins", "cthun", "trio", "viscidus", "ouro" },
        },
    },
})

DungeonSpeedRunner:RegisterInstanceData(533, { -- Naxx
    version = 1,
    
    name = "Naxxramas",
    maxLevel = 60,
    
    bosses = {
        anubrekhan = {
            name = "Anub'Rekhan",
            dbmModId = "Anub'Rekhan",
        },
        faerlina = {
            name = "Grand Widow Faerlina",
            dbmModId = "Faerlina",
        },
        maexxna = {
            name = "Maexxna",
            dbmModId = "Maexxna",
        },
        noth = {
            name = "Noth the Plaguebringer",
            dbmModId = "Noth",
        },
        heigan = {
            name = "Heigan the Unclean",
            dbmModId = "Heigan",
        },
        loatheb = {
            name = "Loatheb",
            dbmModId = "Loatheb",
        },
        razuvious = {
            name = "Instructor Razuvious",
            dbmModId = "Razuvious",
        },
        gothik = {
            name = "Gothik the Harvester",
            dbmModId = "Gothik",
        },
        horsemen = {
            name = "The Four Horsemen",
            dbmModId = "Horsemen",
        },
        patchwerk = {
            name = "Patchwerk",
            dbmModId = "Patchwerk",
        },
        grobbulus = {
            name = "Grobbulus",
            dbmModId = "Grobbulus",
        },
        gluth = {
            name = "Gluth",
            dbmModId = "Gluth",
        },
        thaddius = {
            name = "Thaddius",
            dbmModId = "Thaddius",
        },
        sapphiron = {
            name = "Sapphiron",
            dbmModId = "Sapphiron",
        },
        kelthuzad = {
            name = "Kel'Thuzad",
            dbmModId = "Kel'Thuzad",
        },
    },
    
    routes = {
        required = { "anubrekhan", "faerlina", "maexxna", "noth", "heigan", "loatheb", "razuvious", "gothik", "horsemen", "patchwerk", "grobbulus", "gluth", "thaddius", "sapphiron", "kelthuzad" }
    },
})

print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Loaded data for |cffffd300Classic Era Raids|r!")
