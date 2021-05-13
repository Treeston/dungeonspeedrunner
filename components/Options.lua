local name,addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

local defaults =
{
    profile = {
        testMode = true,
        
        announce = {
            bestSplit = { { "GROUP" } },
            anySplit = { { "PRINT" } },
            
            bestRunComplete = { { "GROUP", "GUILD" } },
            anyRunComplete = { { "GROUP" } },
        },

        statusWindow = {
            locked = false,
            
            anchorPoint = { "CENTER", "UIParent", "CENTER", 0, 0 },
            
            mainContentHeight = 13,
            mainNameWidth = 140,
            mainTimeWidth = 60,
            mainSpacing = 5,
            mainPadding = 5,
            
            mainBorderTexture = "Blizzard Achievement Wood",
            mainBorderWidth = 16,
            
            mainBackdropTexture = "Blizzard Rock",
            mainBackdropInset = 4,
            
            growUp = false,
            growLeft = false,
            
            extraSplitHeight = 16,
            extraSpacing = 2,
            extraPadding = 5,
            
            extraBorderTexture = "Blizzard Dialog Gold",
            extraBorderWidth = 16,
            
            extraBackdropTexture = "Blizzard Marble",
            extraBackdropInset = 4,
            
            extraSplitNameWidth = 100,
            extraSplitChangeWidth = 45,
            extraSplitTimeWidth = 50,
            extraSplitTextSpacing = 1,
            
            closeButtonSize = 12,
            
            maxSplitCount = 5,
            
            instanceFont = { font = "Arial Narrow", size = 10, outline = "OUTLINE" },
            currentTimeFont = { font = "Arial Narrow", size = 11, outline = "OUTLINE" },
            
            splitNameFont = { font = "Arial Narrow", size = 10, outline = "OUTLINE" },
            splitOffsetFont = { font = "Arial Narrow", size = 11, outline = "OUTLINE" },
            splitTimeFont = { font = "Arial Narrow", size = 11, outline = "OUTLINE" },
        },
    },
    global = {
        savedRuns = {
            ['*']={},
        },
    },
}

local function fontopt(t)
    return LSM:Fetch("font", t.font), t.size, t.outline
end

local options = {
    type = "group",
    args = {
        testMode={
            name="Enable test mode",
            desc="Shows dummy data, allowing you to play with the settings in peace",
            descStyle="inline",
            width="full",
            type="toggle",
            order=0,
            
            get=function() return addon.opt.testMode end,
            set=function(_,v) addon.opt.testMode=v addon.TestMode[(v and "Enable" or "Disable").."TestMode"](addon.TestMode) end,
        },
    },
}

local listener = CreateFrame("Frame")
listener:SetScript("OnEvent", function(_, _, arg)
    if arg ~= name then return end
    listener:UnregisterEvent("ADDON_LOADED")
    addon.db = LibStub("AceDB-3.0"):New("DSR__DB", defaults, true)
    addon.db.RegisterCallback(addon, "OnProfileChanged", "OnProfileEnable")
    addon.db.RegisterCallback(addon, "OnProfileCopied", "OnProfileEnable")
    addon.db.RegisterCallback(addon, "OnProfileReset", "OnProfileEnable")
    addon:OnProfileEnable()
    
    local AC, ACD = LibStub("AceConfig-3.0"), LibStub("AceConfigDialog-3.0")
    AC:RegisterOptionsTable("DungeonSpeedRunner", options)
    local optionsRef = ACD:AddToBlizOptions("DungeonSpeedRunner")
    AC:RegisterOptionsTable("DungeonSpeedRunner-Profile", LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db))
    ACD:AddToBlizOptions("DungeonSpeedRunner-Profile", "Profiles", "DungeonSpeedRunner")
    
    _G.SlashCmdList["DSR"] = function() InterfaceOptionsFrame_OpenToCategory(optionsRef) end
    _G.SLASH_DSR1 = "/dsr"
    _G.SLASH_DSR2 = "/dungeonspeedrunner"
    _G.SLASH_DSR3 = "/speedrun"
end)
listener:RegisterEvent("ADDON_LOADED")

function addon:OnProfileEnable()
    addon.opt = addon.db.profile

    -- sequencing matters here!!

    -- set uninteresting properties, none of these are dangerous
    addon.StatusWindow:SetMainBackdropTexture(LSM:Fetch("background", addon.opt.statusWindow.mainBackdropTexture))
    
    addon.StatusWindow:SetMainBorderTexture(LSM:Fetch("border", addon.opt.statusWindow.mainBorderTexture))
    
    addon.StatusWindow:SetExtraBackdropTexture(LSM:Fetch("background", addon.opt.statusWindow.extraBackdropTexture))
    
    addon.StatusWindow:SetExtraBorderTexture(LSM:Fetch("border", addon.opt.statusWindow.extraBorderTexture))
    
    addon.StatusWindow:SetCurrentInstanceFont(fontopt(addon.opt.statusWindow.instanceFont))
    addon.StatusWindow:SetCurrentTimeFont(fontopt(addon.opt.statusWindow.currentTimeFont))
    
    addon.StatusWindow:SetElapsedSplitNameFont(fontopt(addon.opt.statusWindow.splitNameFont))
    addon.StatusWindow:SetElapsedSplitOffsetFont(fontopt(addon.opt.statusWindow.splitOffsetFont))
    addon.StatusWindow:SetElapsedSplitTimeFont(fontopt(addon.opt.statusWindow.splitTimeFont))
    
    addon.StatusWindow:SetAnchorPoint(unpack(addon.opt.statusWindow.anchorPoint))
    
    -- batch import the impactful render options, after this the window should be functional
    addon.StatusWindow:ImportRenderOptions(addon.opt.statusWindow)
    
    -- load functional settings
    addon.StatusWindow:SetMaxSplitCount(addon.opt.statusWindow.maxSplitCount)
    addon.StatusWindow:SetLocked(addon.opt.statusWindow.locked)
    
    -- setup test mode if applicable
    if addon.opt.testMode then
        addon.TestMode:EnableTestMode()
    else
        addon.TestMode:DisableTestMode()
    end
end
