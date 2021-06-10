local _G, assert, pairs, ipairs, unpack, select, print, time, type =
      _G, assert, pairs, ipairs, unpack, select, print, time, type
local UnitClass, UnitName, UnitRace, UnitLevel, UnitExists, UnitAffectingCombat, UnitIsVisible, UnitPosition = 
      UnitClass, UnitName, UnitRace, UnitLevel, UnitExists, UnitAffectingCombat, UnitIsVisible, UnitPosition
local GetTime, GetNumGroupMembers, GetRaidRosterInfo, IsInGroup, IsInRaid, InCombatLockdown, IsInInstance = 
      GetTime, GetNumGroupMembers, GetRaidRosterInfo, IsInGroup, IsInRaid, InCombatLockdown, IsInInstance
local StaticPopup_Show, CombatLogGetCurrentEventInfo, GetNormalizedRealmName, GetNumSubgroupMembers, LoadAddOn = 
      StaticPopup_Show, CombatLogGetCurrentEventInfo, GetNormalizedRealmName, GetNumSubgroupMembers, LoadAddOn
local SendChatMessage, RequestRaidInfo, GetInstanceInfo, COMBATLOG_OBJECT_CONTROL_PLAYER = 
      SendChatMessage, RequestRaidInfo, GetInstanceInfo, COMBATLOG_OBJECT_CONTROL_PLAYER
local CanSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat
local band, bor, blshift = bit.band, bit.bor, bit.lshift
local tinsert, tconcat, tremove = table.insert, table.concat, table.remove
local floor = math.floor

local addon = (select(2,...))

_G.DungeonSpeedRunner = addon

local eventFrame = CreateFrame("Frame")

local currentRun = nil
local hairTriggerFrame = CreateFrame("Frame")

local function CurrentRunUpdateNames()
    local compoundName = currentRun.instanceName
    
    local routeName = (currentRun.routeData and currentRun.routeData.name)
    if routeName then
        compoundName = compoundName..": "..routeName
    end
    if currentRun.instanceDifficultyId ~= 1 then
        local n = currentRun.instanceDifficultyName
        local m = n:match("^%d+")
        if m then
            compoundName = compoundName.." ("..m..")"
        else
            compoundName = compoundName.." ("..n:sub(1,1)..")"
        end
    end

    currentRun.chatName = compoundName
    currentRun.uiName = compoundName
    
    addon.StatusWindow:SetCurrentInstance(currentRun.uiName)
end

local function SetCurrentRunRoute(runData, routeLabel)
    if (currentRun ~= runData) then return end
    currentRun.routeLabel = routeLabel
    currentRun.routeData = currentRun.instanceData.routes[routeLabel]
    assert(currentRun.routeData)
    CurrentRunUpdateNames()
    
    local completionMask = 0x0
    for _, split in ipairs(currentRun.routeData.required) do
        local mask = currentRun.splitToMaskIdx[split]
        assert(mask)
        completionMask = bor(completionMask, mask)
    end
    assert(completionMask > 0)
    currentRun.completionMask = completionMask
    
    local compareRun = addon.db.global.savedRuns[("%d:%d:%s"):format(currentRun.instanceMapId, currentRun.instanceDifficultyId, routeLabel)][1]
    if compareRun then
        local compareMask = 0x0
        local compareIdx = {}
        local comparePredictor = {}
        comparePredictor[0x0] = {compareRun.splits[1]}
        for i=1,#compareRun.splits do
            local splitLabel, splitTime = unpack(compareRun.splits[i])
            local thisMask = currentRun.splitToMaskIdx[splitLabel]
            if thisMask then
                compareMask = band(compareMask + thisMask, completionMask)
                compareIdx[("%x:%s"):format(compareMask, splitLabel)] = splitTime
                
                local nextSplit = compareRun.splits[i+1]
                if nextSplit then
                    local p = comparePredictor[compareMask]
                    if not p then
                        p = {}
                        comparePredictor[compareMask] = p
                    end
                    tinsert(p, nextSplit)
                end
            end
        end
        currentRun.compareTime = compareRun.runTime
        currentRun.compareIdx = compareIdx
        currentRun.comparePredictor = comparePredictor
    end
    
    addon.StatusWindow:SetLongFormat(compareRun and (3600 <= compareRun.runTime))
end

local function DiscardCurrentRun()
    eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    eventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:UnregisterEvent("PLAYER_LEVEL_UP")
    addon.StatusWindow:Reset()
    addon.StatusWindow:Hide()
    addon.RouteChoice:CloseChoice()
    currentRun = nil
    
    addon.TestMode:AllowTestMode()
end

local function DismissButtonClicked()
    DiscardCurrentRun()
    print("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Current run dismissed. Use |cffffd300/dsr restart|r to restart.")
end

local ourRealm
local function RecordPlayerLevel(level)
    local fullName = ("%s-%s"):format(UnitName("player"), ourRealm or "")
    local data = currentRun.players[fullName]
    if data then
        if data.maxLevel < level then
            data.maxLevel = level
        end
    else
        currentRun.players[fullName] = {
            race = (select(3, UnitRace("player"))),
            class = (select(2, UnitClass("player"))),
            minLevel = level,
            maxLevel = level,
        }
    end
end

local function RecordAllGroupMembers()
    for i=1,GetNumGroupMembers() do
        local name, _, _, level, _, classFileName = GetRaidRosterInfo(i)
        if name then
            local fullName = name:find("-") and name or (("%s-%s"):format(name, ourRealm or ""))
            local data = currentRun.players[fullName]
            if data then
                if data.maxLevel < level then
                    data.maxLevel = level
                end
            else
                currentRun.players[fullName] = {
                    race = (select(3, UnitRace(name))),
                    class = classFileName,
                    minLevel = level,
                    maxLevel = level,
                }
            end
        end
    end
end

local function SetupCurrentRun(instanceName, difficultyId, difficultyName, instanceMapId, instanceData)
    assert(addon.InstanceData[instanceMapId] == instanceData)
    currentRun = {
        instanceMapId = instanceMapId,
        instanceDifficultyId = difficultyId,
        instanceData = instanceData,
        
        instanceName = instanceName,
        instanceDifficultyName = difficultyName,
        
        SetRoute = SetCurrentRunRoute,
        routeLabel = nil,
        routeData = nil,
        
        splitToMaskIdx = {},
        
        hairTrigger = true,
        
        dbmPullTriggers = {},
        dbmKillTriggers = {},
        
        completedSplits = {},
        currentMask = 0x0,
        completionMask = nil,
        
        isComplete = false,
        startTime = nil,
        splits = {},
        players = {},
        ranked = true,
    }
    eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    
    local splitMask = 0x1
    for splitLabel, splitData in pairs(instanceData.splits) do
        currentRun.splitToMaskIdx[splitLabel] = splitMask
        splitMask = splitMask * 2
        
        for _, trigger in ipairs(splitData.triggers) do
            if trigger.event == "DBM_PULL" then
                currentRun.dbmPullTriggers[trigger.modId] = splitLabel
            elseif trigger.event == "DBM_KILL" then
                currentRun.dbmKillTriggers[trigger.modId] = splitLabel
            end
        end
    end
    assert(splitMask > 1)

    addon.TestMode:DisallowTestMode()

    addon.StatusWindow:SetTimeElapsed(0)
    addon.StatusWindow:SetCloseButtonCallback(DismissButtonClicked)
    addon.StatusWindow:SetLongFormat(false)
    CurrentRunUpdateNames()
    hairTriggerFrame:Show()
    addon.StatusWindow:Show()
    
    local possibleRoutes = {}
    for label, routeData in pairs(instanceData.routes) do
        if (not routeData.enabledDifficulties) or routeData.enabledDifficulties[difficultyId] then
            tinsert(possibleRoutes, label)
        end
    end
    
    if #possibleRoutes > 1 then -- @todo
        addon.RouteChoice:OfferChoice(currentRun, possibleRoutes)
    elseif #possibleRoutes == 0 then
        print(("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: No available routes for %s (map %d) on %s difficulty (%d). This is likely a bug. You can try and see if |cffffd300/dsr restart|r starts the run properly."):format(instanceName, instanceMapId, difficultyName, difficultyId))
        DiscardCurrentRun()
    else
        SetCurrentRunRoute(currentRun, possibleRoutes[1])
    end
end

local function SaveCurrentRun()
    assert(currentRun.isComplete and currentRun.ranked)
    local runData = {
        runTime = currentRun.completionTime,
        completionTimestamp = currentRun.completionTimestamp,
        addonDataVersion = 1,
        instanceDataVersion = currentRun.instanceData.version,
        splits = currentRun.splits,
        players = currentRun.players,
    }
    
    -- savedRuns is always sorted (ascending run time)
    local savedRuns = addon.db.global.savedRuns[("%d:%d:%s"):format(currentRun.instanceMapId, currentRun.instanceDifficultyId, currentRun.routeLabel)]
    local i = 0            -- savedRuns[i].runTime <= runData.runTime
    local j = #savedRuns+1 -- runData.runTime < savedRuns[j].runTime
    while (j-i) > 1 do
        local p = floor((i+j)/2)
        assert((i<p) and (p<j))
        if savedRuns[p].runTime <= runData.runTime then
            i = p
        else
            j = p
        end
    end
    tinsert(savedRuns, j, runData)
    
    DiscardCurrentRun()
end

local EMPTY = {}
local function PredictNextSplit(override)
    assert(currentRun)
    local predictedNextSplit, predictedNextTime
    
    if currentRun.routeData then
        local predictor = currentRun.comparePredictor
        local effectiveMask = band(currentRun.currentMask, currentRun.completionMask)
        if predictor then
            local ourPredictor = predictor[effectiveMask]
            if ourPredictor then
                for i=0, #ourPredictor do
                    if (i==0) or currentRun.completedSplits[ourPredictor[i][1]] then
                        predictedNextSplit, predictedNextTime = unpack(ourPredictor[i+1] or EMPTY)
                    end
                end
            end
        end
        
        if override and not currentRun.completedSplits[override] then
            if predictedNextSplit ~= override then
                predictedNextSplit = override
                if currentRun.completionMask and ((effectiveMask + currentRun.splitToMaskIdx[override]) == currentRun.completionMask) then
                    predictedNextTime = currentRun.compareTime
                else
                    predictedNextTime = nil
                end
            end
        end
    else
        predictedNextSplit = override
    end

    if predictedNextSplit then
        addon.StatusWindow:SetPendingSplit(currentRun.instanceData.splits[predictedNextSplit].uiName, predictedNextTime)
    end
end

hairTriggerFrame:Hide()
local function hairTriggerHit()
    assert(currentRun.hairTrigger)
    eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    currentRun.hairTrigger = false
    hairTriggerFrame:Hide()
    
    if IsInGroup() then
        RecordAllGroupMembers()
    else
        RecordPlayerLevel(UnitLevel("player"))
    end
    eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    
    currentRun.startTime = GetTime()
    addon.StatusWindow:ResetTimer()
    addon.StatusWindow:ResumeTimer()
    
    PredictNextSplit()
end
local function hairTriggerTest(puid,uid)
    if currentRun and currentRun.hairTrigger and UnitExists(puid) and UnitAffectingCombat(puid) then
        if not UnitIsVisible(puid) then
            if (select(4, UnitPosition(uid))) ~= currentRun.instanceMapId then return end
        end
        hairTriggerHit()
    end
end
hairTriggerFrame:SetScript("OnUpdate", function()
    if IsInRaid() then
        for i=1,GetNumGroupMembers() do
            local uid = ("raid"..i)
            local puid = ("raidpet"..i)
            hairTriggerTest(uid,uid)
            hairTriggerTest(puid,uid)
        end
    else
        hairTriggerTest("player","player")
        hairTriggerTest("pet","player")
        if IsInGroup() then
            for i=1,GetNumSubgroupMembers() do
                local uid = ("party"..i)
                local puid = ("partypet"..i)
                hairTriggerTest(uid,uid)
                hairTriggerTest(puid,uid)
            end
        end
    end
end)

local BEST_COMPLETE = "%s complete in %s. This is a new record (%s)!"
local WORSE_COMPLETE = "%s complete in %s. (%s compared to previous record.)"
local FIRST_COMPLETE = "%s complete in %s. This is the first recorded run."
local BEST_SPLIT = "%s: %s (%s)"
local WORSE_SPLIT = "%s: %s (%s)"
local FIRST_SPLIT = "%s: %s"

function addon:DoAnnounce(channels, formatstring, ...)
    local msg = formatstring:format(...)
    for channel, extra in pairs(channels) do
        if extra then
            if channel == "GROUP" then
                if IsInRaid() then
                    channel = "RAID"
                elseif IsInGroup() then
                    channel = "PARTY"
                else
                    channel = "PRINT"
                end
            elseif channel == "GUILD" then
                if not CanSpeakInGuildChat() then
                    channel = "NONE"
                end
            end
            
            if channel == "PRINT" then
                print(msg)
            elseif channel ~= "NONE" then
                SendChatMessage("[DSR] "..msg, channel)
            end
        end
    end
end

local function SplitReached(split)
    if currentRun.isComplete then return end
    if currentRun.completedSplits[split] then return end
    if currentRun.hairTrigger then hairTriggerHit() end
    if not currentRun.routeData then DiscardCurrentRun() return end
    assert(not currentRun.hairTrigger)
    local relativeTime = GetTime() - currentRun.startTime
    currentRun.currentMask = currentRun.currentMask + currentRun.splitToMaskIdx[split]
    currentRun.completedSplits[split] = true
    tinsert(currentRun.splits, { split, relativeTime })
    
    if band(currentRun.currentMask, currentRun.completionMask) == currentRun.completionMask then
        currentRun.isComplete = true
        currentRun.completionTime = relativeTime
        currentRun.completionTimestamp = time()
        if not InCombatLockdown() then
            StaticPopup_Show("DSR_SAVE", currentRun.chatName, addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat))
        end
        addon.StatusWindow:StopTimer()
        addon.StatusWindow:SetTimeElapsed(relativeTime)
    end
    
    local splitData = currentRun.instanceData.splits[split]
    local compareTime
    if currentRun.isComplete then
        compareTime = currentRun.compareTime
        
        if compareTime and (relativeTime < compareTime) then
            addon:DoAnnounce(addon.opt.announceTo.bestRunComplete,
                BEST_COMPLETE,
                currentRun.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat),
                addon:FormatChangeString(relativeTime-compareTime, addon.StatusWindow.longFormat)
            )
        elseif compareTime then
            addon:DoAnnounce(addon.opt.announceTo.anyRunComplete,
                WORSE_COMPLETE,
                currentRun.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat),
                addon:FormatChangeString(relativeTime-compareTime, addon.StatusWindow.longFormat)
            )
        else
            addon:DoAnnounce(addon.opt.announceTo.anyRunComplete,
                FIRST_COMPLETE,
                currentRun.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat)
            )
        end
    else
        compareTime = currentRun.compareIdx and currentRun.compareIdx[("%x:%s"):format(band(currentRun.currentMask, currentRun.completionMask), split)]
        
        if compareTime and (relativeTime < compareTime) then
            addon:DoAnnounce(addon.opt.announceTo.bestSplit,
                BEST_SPLIT,
                splitData.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat),
                addon:FormatChangeString(relativeTime-compareTime, addon.StatusWindow.longFormat)
            )
        elseif compareTime then
            addon:DoAnnounce(addon.opt.announceTo.anySplit,
                WORSE_SPLIT,
                splitData.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat),
                addon:FormatChangeString(relativeTime-compareTime, addon.StatusWindow.longFormat)
            )
        else
            addon:DoAnnounce(addon.opt.announceTo.anySplit,
                FIRST_SPLIT,
                splitData.chatName,
                addon:FormatTimerString(relativeTime, addon.StatusWindow.longFormat)
            )
        end
    end

    addon.StatusWindow:SetSplitComplete(splitData.uiName, compareTime, relativeTime)

    PredictNextSplit(splitData.predicts)
end

local function UndoSplit(split)
    if currentRun.isComplete then return end
    if not currentRun.completedSplits[split] then return end
    
    currentRun.currentMask = currentRun.currentMask - currentRun.splitToMaskIdx[split]
    currentRun.completedSplits[split] = nil
    
    for i=#currentRun.splits, 1, -1 do
        if currentRun.splits[i][1] == split then
            tremove(currentRun.splits, i)
            break
        end
    end
    
    PredictNextSplit(split)
end

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("UPDATE_INSTANCE_INFO")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
local hostileSubEvents = {SWING_DAMAGE=true,RANGE_DAMAGE=true,SPELL_DAMAGE=true,SPELL_PERIODIC_DAMAGE=true,SWING_MISSED=true,SWING_ABSORBED=true,}
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if not ourRealm then ourRealm = GetNormalizedRealmName() end
        if IsInInstance() then
            RequestRaidInfo()
        end
    elseif event == "UPDATE_INSTANCE_INFO" then
        if currentRun then return end
        local instanceName, _, difficultyID, difficultyName, _, _, _, currentMap = GetInstanceInfo()
        local data = addon.InstanceData[currentMap]
        if not data then return end
        if type(data) == "string" then
            local loaded, reason = LoadAddOn(data)
            if not loaded then
                print(("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Failed to load |cffffd300%s|r: %s"):format(data, _G["ADDON_"..reason]))
                return
            end
            data = addon.InstanceData[currentMap]
            assert(type(data) == "table")
        end
        print(("|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Detected |cffffd300%s|r -- waiting for combat"):format(data.name))
        SetupCurrentRun(instanceName, difficultyID, difficultyName, currentMap, data)
    elseif event == "PLAYER_REGEN_ENABLED" then
        if currentRun and currentRun.isComplete then
            -- @todo remove statusWindow internals
            StaticPopup_Show("DSR_SAVE", currentRun.chatName, addon:FormatTimerString(currentRun.completionTime, addon.StatusWindow.longFormat))
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if not currentRun then return end
        local _, subevent, _, sourceGUID, _, sourceFlags, _, targetGUID, _, targetFlags, _ = CombatLogGetCurrentEventInfo()
        if hostileSubEvents[subevent] then
            if currentRun.hairTrigger and (band(sourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= band(targetFlags, COMBATLOG_OBJECT_CONTROL_PLAYER)) then
                hairTriggerHit()
            end
        end
    elseif (event == "GROUP_ROSTER_UPDATE") then
        RecordAllGroupMembers()
    elseif (event == "PLAYER_LEVEL_UP") then
        RecordPlayerLevel((...))
    end
end)

function addon:AttemptRunStart()
    eventFrame:GetScript("OnEvent")(eventFrame, "PLAYER_ENTERING_WORLD")
end

if DBM then
    DBM:RegisterCallback("DBM_Pull", function(_, mod, delay)
        if not currentRun then return end
        local split = currentRun.dbmPullTriggers[mod.id]
        if split then
            SplitReached(split)
        end
    end)
    DBM:RegisterCallback("DBM_Wipe", function(_, mod)
        if not currentRun then return end
        local split = currentRun.dbmPullTriggers[mod.id]
        if split then
            UndoSplit(split)
        end
    end)
    DBM:RegisterCallback("DBM_Kill", function(_, mod)
        if not currentRun then return end
        local split = currentRun.dbmKillTriggers[mod.id]
        if split then
            SplitReached(split)
        end
    end)
end

StaticPopupDialogs.DSR_SAVE = {
    text = "%s finished in %s - save this?",
    button1 = YES,
    button2 = NO,
    OnAccept=SaveCurrentRun,
    OnCancel=DiscardCurrentRun,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    notClosableByLogout = true,
}
