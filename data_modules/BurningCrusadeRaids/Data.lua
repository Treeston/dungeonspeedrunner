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

print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Loaded data for |cffffd300Burning Crusade Raids|r!")
