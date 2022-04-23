DungeonSpeedRunner:RegisterInstanceData(532, { -- Karazhan
    version = 1,
    
    name = "Karazhan",
    maxLevel = 70,
    
    bosses = {
        beasts = {
            name = "Servant Quarters Boss",
            dbmModId = { "Shadikith", "Hyakiss", "Rokad" },
        },
        attumen = {
            name = "Attumen the Huntsman",
            dbmModId = "Attumen",
        },
        moroes = {
            name = "Moroes",
            dbmModId = "Moroes",
        },
        maiden = {
            name = "Maiden of Virtue",
            dbmModId = "Maiden",
        },
        opera = {
            name = "Opera Event",
            dbmModId = { "RomuloAndJulianne", "BigBadWolf", "Oz" },
        },
        curator = {
            name = "The Curator",
            dbmModId = "Curator",
        },
        chess = {
            name = "A Game of Chess",
            dbmModId = "Chess",
        },
        illhoof = {
            name = "Terestian Illhoof",
            dbmModId = "TerestianIllhoof",
        },
        aran = {
            name = "Shade of Aran",
            dbmModId = "Aran",
        },
        netherspite = {
            name = "Netherspite",
            dbmModId = "Netherspite",
        },
        nightbane = {
            name = "Nightbane",
            dbmModId = "NightbaneRaid",
        },
        malchezaar = {
            name = "Prince Malchezaar",
            dbmModId = "Prince",
        },
    },
    
    routes = {
        required = { "attumen", "moroes", "maiden", "curator", "illhoof", "aran", "netherspite", "malchezaar" }
    },
    
    autoGossipNPCs = {
        [16812] = true, -- Barnes
        [17603] = true, -- Grandmother
    },
})

DungeonSpeedRunner:RegisterInstanceData(544, { -- Magtheridon's Lair
    version = 1,
    
    name = "Magtheridon's Lair",
    maxLevel = 70,
    
    bosses = {
        magtheridon = {
            name = "Magtheridon",
            dbmModId = "Magtheridon",
        },
    },
    
    routes = {
        required = { "magtheridon" }
    },
})

DungeonSpeedRunner:RegisterInstanceData(565, { -- Gruul's Lair
    version = 1,
    
    name = "Gruul's Lair",
    maxLevel = 70,
    
    bosses = {
        maulgar = {
            name = "High King Maulgar",
            dbmModId = "Maulgar",
        },
        gruul = {
            name = "Gruul the Dragonkiller",
            dbmModId = "Gruul",
        },
    },
    
    routes = {
        required = { "maulgar", "gruul" }
    },
})

DungeonSpeedRunner:RegisterInstanceData(548, { -- Serpentshrine Cavern
    version = 1,
    
    name = "Serpentshrine Cavern",
    maxLevel = 70,
    
    bosses = {
        hydross = {
            name = "Hydross the Unstable",
            dbmModId = "Hydross",
        },
        lurker = {
            name = "The Lurker Below",
            dbmModId = "LurkerBelow",
        },
        leotheras = {
            name = "Leotheras the Blind",
            dbmModId = "Leotheras",
        },
        fathomlord = {
            name = "Fathom-Lord Karathress",
            dbmModId = "Fathomlord",
        },
        morogrim = {
            name = "Morogrim Tidewalker",
            dbmModId = "Tidewalker",
        },
        vashj = {
            name = "Lady Vashj",
            dbmModId = "Vashj",
        },
    },
    
    routes = {
        required = { "hydross", "lurker", "leotheras", "fathomlord", "morogrim", "vashj" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(550, { -- Tempest Keep
    version = 1,
    
    name = "Tempest Keep",
    maxLevel = 70,
    
    bosses = {
        alar = {
            name = "Al'ar",
            dbmModId = "Alar",
        },
        loot = {
            name = "Void Reaver",
            dbmModId = "VoidReaver",
        },
        solarian = {
            name = "High Astromancer Solarian",
            dbmModId = "Solarian",
        },
        kael = {
            name = "Kael'thas Sunstrider",
            dbmModId = "KaelThas",
        },
    },
    
    routes = {
        required = { "alar", "loot", "solarian", "kael" },
    },
})

DungeonSpeedRunner:RegisterInstanceData(564, { -- Black Temple
    version = 1,
    
    name = "Black Temple",
    maxLevel = 70,
    
    bosses = {
        najentus = {
            name = "High Warlord Naj'entus",
            dbmModId = "Najentus",
        },
        supremus = {
            name = "Supremus",
            dbmModId = "Supremus",
        },
        akama = {
            name = "Shade of Akama",
            dbmModId = "Akama",
        },
        gorefiend = {
            name = "Teron Gorefiend",
            dbmModId = "TeronGorefiend",
        },
        gurtogg = {
            name = "Gurtogg Bloodboil",
            dbmModId = "Bloodboil",
        },
        reliquary = {
            name = "Reliquary of Souls",
            dbmModId = "Souls",
        },
        mother = {
            name = "Mother Shahraz",
            dbmModId = "Shahraz",
        },
        council = {
            name = "Illidari Council",
            dbmModId = "Council",
        },
        illidan = {
            name = "Illidan Stormrage",
            dbmModId = "Illidan",
        },
    },
    
    routes = {
        required = { "najentus", "supremus", "gorefiend", "gurtogg", "reliquary", "mother", "council", "illidan" },
    },
    
    autoGossipNPCs = {
        [23089] = true, -- Akama
    },
})

DungeonSpeedRunner:RegisterInstanceData(534, { -- CoT: Hyjal
    version = 1,
    
    name = "CoT: Hyjal",
    maxLevel = 70,
    
    bosses = {
        winterchill = {
            name = "Rage Winterchill",
            dbmModId = "Rage",
        },
        anetheron = {
            name = "Anetheron",
            dbmModId = "Anetheron",
        },
        kazrogal = {
            name = "Kaz'rogal",
            dbmModId = "Kazrogal",
        },
        azgalor = {
            name = "Azgalor",
            dbmModId = "Azgalor",
        },
        archimonde = {
            name = "Archimonde",
            dbmModId = "Archimonde",
        },
    },
    
    routes = {
        required = { "winterchill", "anetheron", "kazrogal", "azgalor", "archimonde" },
    },
    
    autoGossipNPCs = {
        [17772] = true, -- Jaina Proudmoore
        [17852] = true, -- Thrall
        [17948] = true, -- Tyrande Whisperwind
    },
})

DungeonSpeedRunner:RegisterInstanceData(568, { -- Zul'Aman
    version = 1,
    
    name = "Zul'Aman",
    maxLevel = 70,
    
    bosses = {
        eagle = {
            name = "Eagle (Akil'zon)",
            dbmModId = "Akilzon",
        },
        bear = {
            name = "Bear (Nalorakk)",
            dbmModId = "Nalorakk",
        },
        dragonhawk = {
            name = "Dragonhawk (Jan'alai)",
            dbmModId = "Janalai",
        },
        lynx = {
            name = "Lynx (Halazzi)",
            dbmModId = "Halazzi",
        },
        malacrass = {
            name = "Hex Lord Malacrass",
            dbmModId = "Malacrass",
        },
        zuljin = {
            name = "Zul'jin",
            dbmModId = "ZulJin",
        },
    },
    
    routes = {
        bear = {
            name = "Bear Run",
            required = { "eagle", "bear", "dragonhawk", "lynx" },
        },
        full = {
            name = "Full Clear",
            required = { "eagle", "bear", "dragonhawk", "lynx", "malacrass", "zuljin" },
        },
    },
    
    autoGossipNPCs = {
        [23999] = true, -- Harkor
        [23790] = true, -- Tanzar
        [24024] = true, -- Kraz
        [24001] = true, -- Ashli
    },
})

print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Loaded data for |cffffd300Burning Crusade Raids|r!")
