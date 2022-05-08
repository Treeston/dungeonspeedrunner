local assert, pairs, type, ipairs, tostring = assert, pairs, type, ipairs, tostring
local tinsert = table.insert

local addon = (select(2,...))

addon.InstanceData = {
    [  48] = "DungeonSpeedRunner_LowLevelDungeons", -- Blackfathom Deeps
    [  90] = "DungeonSpeedRunner_LowLevelDungeons", -- Gnomeregan
    [ 349] = "DungeonSpeedRunner_LowLevelDungeons", -- Maraudon
    [ 389] = "DungeonSpeedRunner_LowLevelDungeons", -- Ragefire Chasm
    [ 129] = "DungeonSpeedRunner_LowLevelDungeons", -- Razorfen Downs
    [  47] = "DungeonSpeedRunner_LowLevelDungeons", -- Razorfen Kraul
    [ 189] = "DungeonSpeedRunner_LowLevelDungeons", -- Scarlet Monastery
    [  33] = "DungeonSpeedRunner_LowLevelDungeons", -- Shadowfang Keep
    [  36] = "DungeonSpeedRunner_LowLevelDungeons", -- Deadmines
    [  34] = "DungeonSpeedRunner_LowLevelDungeons", -- Stockades
    [ 109] = "DungeonSpeedRunner_LowLevelDungeons", -- Sunken Temple
    [  70] = "DungeonSpeedRunner_LowLevelDungeons", -- Uldaman
    [  43] = "DungeonSpeedRunner_LowLevelDungeons", -- Wailing Caverns
    [ 209] = "DungeonSpeedRunner_LowLevelDungeons", -- Zul'Farrak

    [ 230] = "DungeonSpeedRunner_Level60Dungeons", -- Blackrock Depths
    [ 229] = "DungeonSpeedRunner_Level60Dungeons", -- Blackrock Spire
    [ 429] = "DungeonSpeedRunner_Level60Dungeons", -- Dire Maul
    [ 289] = "DungeonSpeedRunner_Level60Dungeons", -- Scholomance
    [ 329] = "DungeonSpeedRunner_Level60Dungeons", -- Stratholme
    
    [ 249] = "DungeonSpeedRunner_VanillaRaids", -- Onyxia
    [ 309] = "DungeonSpeedRunner_VanillaRaids", -- Zul'Gurub
    [ 409] = "DungeonSpeedRunner_VanillaRaids", -- Molten Core
    [ 469] = "DungeonSpeedRunner_VanillaRaids", -- Blackwing Lair
    [ 509] = "DungeonSpeedRunner_VanillaRaids", -- AQ20
    [ 531] = "DungeonSpeedRunner_VanillaRaids", -- AQ40
    [ 533] = "DungeonSpeedRunner_VanillaRaids", -- Naxxramas
    
    [ 558] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Auchenai Crypts
    [ 556] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Sethekk Halls
    [ 555] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Shadow Labyrinth
    [ 557] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Mana-Tombs
    [ 547] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Slave Pens
    [ 545] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Steamvault
    [ 546] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- The Underbog
    [ 269] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Black Morass
    [ 560] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Old Hillsbrad
    [ 542] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Blood Furnace
    [ 543] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Hellfire Ramparts
    [ 540] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- The Shattered Halls
    [ 585] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Magisters' Terrace
    [ 552] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- The Arcatraz
    [ 553] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- The Botanica
    [ 554] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- The Mechanar
    [ 585] = "DungeonSpeedRunner_BurningCrusadeDungeons", -- Magisters' Terrace
    
    [ 532] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Karazhan
    [ 544] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Magtheridon's Lair
    [ 565] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Gruul's Lair
    [ 548] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Serpentshrine Cavern
    [ 550] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Tempest Keep
    [ 564] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Black Temple
    [ 534] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Mount Hyjal
    [ 568] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Zul'Aman
    [ 580] = "DungeonSpeedRunner_BurningCrusadeRaids", -- Sunwell Plateau
}

local function ValidateRoutes(routesTable)
    -- normalize table to form: routesTable[routeName] = { name = ..., required = { ... } }
    if routesTable.required then
        return { _only = routesTable }
    else
        return routesTable
    end
end

function addon:RegisterInstanceData(instanceMapId, data)
    assert(data.version)
    assert(data.name)
    assert(data.maxLevel)
    assert(data.routes)
    
    if not data.splits then data.splits = {} end
    
    if data.bosses then
        for label, bossData in pairs(data.bosses) do
            local name = bossData.name
            local killSplit = {
                uiName = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t "..name,
                chatName = name.." (Kill)",
                triggers = {},
            }
            local pullSplit = {
                uiName = "|T132147:0|t "..name,
                chatName = name.." (Pull)",
                triggers = {},
                predicts = label,
            }
            
            if bossData.dbmModId then
                if type(bossData.dbmModId) == "table" then
                    for _,modId in ipairs(bossData.dbmModId) do
                        tinsert(killSplit.triggers, { event = "DBM_KILL", modId = tostring(modId) })
                        tinsert(pullSplit.triggers, { event = "DBM_PULL", modId = tostring(modId) })
                    end
                else
                    tinsert(killSplit.triggers, { event = "DBM_KILL", modId = tostring(bossData.dbmModId) })
                    tinsert(pullSplit.triggers, { event = "DBM_PULL", modId = tostring(bossData.dbmModId) })
                end
            end
            
            data.splits[label] = killSplit
            data.splits[label.."_pull"] = pullSplit
        end
    end
    
    if data.routes.required then
        data.routes = { _only = data.routes }
    end
    
    for _, routeData in pairs(data.routes) do
        for _, splitLabel in ipairs(routeData) do
            assert(data.splits[splitLabel], splitLabel)
        end
    end
    
    addon.InstanceData[instanceMapId] = data
end
