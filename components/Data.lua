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
                tinsert(killSplit.triggers, { event = "DBM_KILL", modId = tostring(bossData.dbmModId) })
                tinsert(pullSplit.triggers, { event = "DBM_PULL", modId = tostring(bossData.dbmModId) })
            end
            
            data.splits[label] = killSplit
            data.splits[label.."_pull"] = pullSplit
        end
    end
    
    data.routes = ValidateRoutes(data.routes)
    
    addon.InstanceData[instanceMapId] = data
end