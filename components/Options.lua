local name,addon = ...

local LSM = LibStub("LibSharedMedia-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
function addon:RefreshOptionsDialog(which)
    if which then
        ACR:NotifyChange((which ~= "") and ("DungeonSpeedRunner-"..which) or "DungeonSpeedRunner")
    else
        ACR:NotifyChange("DungeonSpeedRunner")
        ACR:NotifyChange("DungeonSpeedRunner-Appearance")
        ACR:NotifyChange("DungeonSpeedRunner-Layout")
        ACR:NotifyChange("DungeonSpeedRunner-Announcements")
        ACR:NotifyChange("DungeonSpeedRunner-Profile")
    end
end

local defaults =
{
    profile = {
        testMode = true,
        
        announceTo = {
            bestSplit = { GROUP = true },
            anySplit = { PRINT = true },
            
            bestRunComplete = { GROUP = true, GUILD = true },
            anyRunComplete = { GROUP = true },
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

local POINTS = {TOPLEFT="top-left",TOP="top-center",TOPRIGHT="top-right",LEFT="middle-left",CENTER="middle-center",RIGHT="middle-right",BOTTOMLEFT="bottom-left",BOTTOM="bottom-center",BOTTOMRIGHT="bottom-right"}
local FONTOPTS = {[""]="No Outline", OUTLINE="Outline", THICKOUTLINE="Thick Outline", MONOCHROME="No Outline + Monochrome", ["OUTLINE,MONOCHROME"]="Outline + Monochrome", ["THICKOUTLINE,MONOCHROME"]="Thick Outline + Monochrome"}
local options = {
    name = "|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r",
    type = "group",
    args = {
        testMode={
            name="Enable test mode",
            desc="Shows dummy data, allowing you to play with the settings in peace",
            descStyle="inline",
            width="full",
            type="toggle",
            order=1,
            
            get=function() return addon.opt.testMode end,
            set=function(_,v) addon.opt.testMode=v addon.TestMode[(v and "Enable" or "Disable").."TestMode"](addon.TestMode) end,
        },
        locked={
            name="Lock window position",
            desc="Prevents you from dragging the status window around",
            descStyle="inline",
            width="full",
            type="toggle",
            order=2,
            
            get = function() return addon.opt.statusWindow.locked end,
            set=function(_,v) addon.opt.statusWindow.locked=v addon.StatusWindow:SetLocked(v) end,
        },
        anchorPoint={
            name="Status Window position",
            desc="This positions the \"central\" box containing instance name and current time.\nThe popout boxes grow out from that box.",
            type="group",
            inline=true,
            order=3,
            get=function(ctx) return addon.opt.statusWindow.anchorPoint[tonumber(ctx[#ctx])] end,
            set=function(ctx,v)
                addon.opt.statusWindow.anchorPoint[tonumber(ctx[#ctx])]=v
                addon.opt.statusWindow.locked=true
                addon.StatusWindow:SetLocked(v)
                addon.StatusWindow:SetAnchorPoint(unpack(addon.opt.statusWindow.anchorPoint))
            end,
            args={
                ["1"]={
                    name="Place which corner ...",
                    type="select",
                    values=POINTS,
                    order=1,
                    width=1,
                },
                ["2"]={
                    name="... of which frame?",
                    type="input",
                    order=3,
                    width=1,
                },
                ["3"]={
                    name="... relative to which corner ...",
                    type="select",
                    values=POINTS,
                    order=2,
                    width=1,
                },
                ["4"]={
                    name="X Offset (- is left, + is right)",
                    type="range",
                    softMin=-600,
                    softMax=600,
                    bigStep=1,
                    order=4,
                    width=1.5,
                },
                ["5"]={
                    name="Y Offset (- is down, + is up)",
                    type="range",
                    softMin=-600,
                    softMax=600,
                    bigStep=1,
                    order=5,
                    width=1.5,
                },
            },
        },
        growUp={
            name="Split timers grow upwards",
            desc="Expand split timers upwards out from the main window, instead of downwards",
            descStyle="inline",
            width="full",
            type="toggle",
            order=4,
            
            get=function() return addon.opt.statusWindow.growUp end,
            set=function(_,v) addon.opt.statusWindow.growUp = v addon.StatusWindow:SetGrowUp(v) end,
        },
        growLeft={
            name="Close button expands left",
            desc="Attach the close button to the left of the main window, rather than to the right",
            descStyle="inline",
            width="full",
            type="toggle",
            order=5,
            
            get=function() return addon.opt.statusWindow.growLeft end,
            set=function(_,v) addon.opt.statusWindow.growLeft = v addon.StatusWindow:SetGrowLeft(v) end,
        },
        splitCount={
            name="Maximum number of visible split timers",
            width="full",
            type="range",
            order=6,
            min=1,
            softMax=10,
            step=1,
            
            get=function() return addon.opt.statusWindow.maxSplitCount end,
            set=function(_,v)
                addon.opt.statusWindow.maxSplitCount = v
                addon.StatusWindow:SetMaxSplitCount(v)
                addon.TestMode:RefreshTestModeSplits()
            end,
        },
    },
}

local layoutOptions = {
    name = "|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Layout",
    type = "group",
    args = {
        mainHeight = {
            name="Main content height",
            type="range",
            min=1,
            softMin=4,
            softMax=70,
            bigStep=1,
            order=1,
            width=.75,
            get=function() return addon.opt.statusWindow.mainContentHeight end,
            set=function(_,v)
                addon.opt.statusWindow.mainContentHeight = v
                addon.StatusWindow:SetMainContentHeight(v)
            end,
        },
        mainPadding = {
            name="Main frame padding",
            type="range",
            min=0,
            softMax=40,
            bigStep=.1,
            order=2,
            width=.75,
            get=function() return addon.opt.statusWindow.mainPadding end,
            set=function(_,v)
                addon.opt.statusWindow.mainPadding = v
                addon.StatusWindow:SetMainPadding(v)
            end,
        },
        nameWidth = {
            name="Instance name width",
            type="range",
            min=1,
            softMin=60,
            softMax=300,
            bigStep=1,
            order=3,
            width=.75,
            get=function() return addon.opt.statusWindow.mainNameWidth end,
            set=function(_,v)
                addon.opt.statusWindow.mainNameWidth = v
                addon.StatusWindow:SetMainInstanceNameWidth(v)
            end,
        },
        textSpacing = {
            name="Main text spacing",
            desc="The amount of space between the instance name and elapsed time texts",
            type="range",
            min=0,
            softMax=50,
            bigStep=.1,
            order=4,
            width=.75,
            get=function() return addon.opt.statusWindow.mainSpacing end,
            set=function(_,v)
                addon.opt.statusWindow.mainSpacing = v
                addon.StatusWindow:SetMainTextSpacing(v)
            end,
        },
        elapsedTimeWidth = {
            name="Elapsed time width",
            type="range",
            min=1,
            softMin=30,
            softMax=200,
            bigStep=1,
            order=5,
            width=.75,
            get=function() return addon.opt.statusWindow.mainTimeWidth end,
            set=function(_,v)
                addon.opt.statusWindow.mainTimeWidth = v
                addon.StatusWindow:SetMainCurrentTimeWidth(v)
            end,
        },
        splitNameWidth = {
            name="Split label width",
            type="range",
            min=1,
            softMin=60,
            softMax=300,
            bigStep=1,
            order=6,
            width=.75,
            get=function() return addon.opt.statusWindow.extraSplitNameWidth end,
            set=function(_,v)
                addon.opt.statusWindow.extraSplitNameWidth = v
                addon.StatusWindow:SetExtraSplitNameWidth(v)
            end,
        },
        splitChangeWidth = {
            name="Split change width",
            type="range",
            min=1,
            softMin=20,
            softMax=150,
            bigStep=.5,
            order=7,
            width=.75,
            get=function() return addon.opt.statusWindow.extraSplitChangeWidth end,
            set=function(_,v)
                addon.opt.statusWindow.extraSplitChangeWidth = v
                addon.StatusWindow:SetExtraSplitChangeWidth(v)
            end,
        },
        splitTextSpacing = {
            name="Split text spacing",
            type="range",
            min=0,
            softMax=20,
            bigStep=.1,
            order=8,
            width=.75,
            get=function() return addon.opt.statusWindow.extraSplitTextSpacing end,
            set=function(_,v)
                addon.opt.statusWindow.extraSplitTextSpacing = v
                addon.StatusWindow:SetExtraSplitTextSpacing(v)
            end,
        },
        splitHeight = {
            name="Split entry height",
            type="range",
            min=1,
            softMin=8,
            softMax=64,
            bigStep=1,
            order=9,
            width=.75,
            get=function() return addon.opt.statusWindow.extraSplitHeight end,
            set=function(_,v)
                addon.opt.statusWindow.extraSplitHeight = v
                addon.StatusWindow:SetExtraSplitHeight(v)
            end,
        },
        splitSpacing={
            name="Split vertical spacing",
            type="range",
            min=0,
            softMax=15,
            bigStep=.1,
            order=10,
            width=.75,
            get=function() return addon.opt.statusWindow.extraSpacing end,
            set=function(_,v)
                addon.opt.statusWindow.extraSpacing = v
                addon.StatusWindow:SetExtraSplitSpacing(v)
            end,
        },
        extraPadding={
            name="Outer frame padding",
            type="range",
            min=0,
            softMax=30,
            bigStep=.1,
            order=11,
            width=.75,
            get=function() return addon.opt.statusWindow.extraPadding end,
            set=function(_,v)
                addon.opt.statusWindow.extraPadding = v
                addon.StatusWindow:SetExtraPadding(v)
            end,
        },
        closeButtonSize={
            name="Close button size",
            type="range",
            min=1,
            softMax=32,
            bigStep=1,
            order=12,
            width=.75,
            get=function() return addon.opt.statusWindow.closeButtonSize end,
            set=function(_,v)
                addon.opt.statusWindow.closeButtonSize = v
                addon.StatusWindow:SetCloseButtonSize(v)
            end,
        },
    },
}

local appearanceOptions = {
    name = "|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Textures & Fonts",
    type = "group",
    args = {
        main_texture={
            name="Main Display",
            type="group",
            inline=true,
            order=1,
            args={
                background={
                    name="Background #1",
                    type="select",
                    values=LSM:HashTable("background"),
                    dialogControl="LSM30_Background",
                    order=1,
                    width=1,
                    get=function() return addon.opt.statusWindow.mainBackdropTexture end,
                    set=function(_,v)
                        addon.opt.statusWindow.mainBackdropTexture = v
                        addon.StatusWindow:SetMainBackdropTexture(LSM:Fetch("background", v))
                    end,
                },
                inset={
                    name="BG #1 inset",
                    desc="How far from the edge of the actual frame the backdrop is drawn",
                    type="range",
                    min=0,
                    softMax=32,
                    bigStep=1,
                    order=2,
                    width=.7,
                    get=function() return addon.opt.statusWindow.mainBackdropInset end,
                    set=function(_,v)
                        addon.opt.statusWindow.mainBackdropInset = v
                        addon.StatusWindow:SetMainBackdropInset(v)
                    end,
                },
                border={
                    name="Border #1",
                    type="select",
                    values=LSM:HashTable("border"),
                    dialogControl="LSM30_Border",
                    order=3,
                    width=1,
                    get=function() return addon.opt.statusWindow.mainBorderTexture end,
                    set=function(_,v)
                        addon.opt.statusWindow.mainBorderTexture = v
                        addon.StatusWindow:SetMainBorderTexture(LSM:Fetch("border", v))
                    end,
                },
                width={
                    name="Border #1 width",
                    type="range",
                    min=0,
                    softMax=64,
                    bigStep=8,
                    order=4,
                    width=.7,
                    get=function() return addon.opt.statusWindow.mainBorderWidth end,
                    set=function(_,v)
                        addon.opt.statusWindow.mainBorderWidth = v
                        addon.StatusWindow:SetMainBorderWidth(v)
                    end,
                },
                background2={
                    name="Background #2",
                    type="select",
                    values=LSM:HashTable("background"),
                    dialogControl="LSM30_Background",
                    order=5,
                    width=.95,
                    get=function() return addon.opt.statusWindow.extraBackdropTexture end,
                    set=function(_,v)
                        addon.opt.statusWindow.extraBackdropTexture = v
                        addon.StatusWindow:SetExtraBackdropTexture(LSM:Fetch("background", v))
                    end,
                },
                inset2={
                    name="BG #2 inset",
                    desc="How far from the edge of the actual frame the backdrop is drawn",
                    type="range",
                    min=0,
                    softMax=32,
                    bigStep=1,
                    order=6,
                    width=.7,
                    get=function() return addon.opt.statusWindow.extraBackdropInset end,
                    set=function(_,v)
                        addon.opt.statusWindow.extraBackdropInset = v
                        addon.StatusWindow:SetExtraBackdropInset(v)
                    end,
                },
                border2={
                    name="Border #2",
                    type="select",
                    values=LSM:HashTable("border"),
                    dialogControl="LSM30_Border",
                    order=7,
                    width=.95,
                    get=function() return addon.opt.statusWindow.extraBorderTexture end,
                    set=function(_,v)
                        addon.opt.statusWindow.extraBorderTexture = v
                        addon.StatusWindow:SetExtraBorderTexture(LSM:Fetch("border", v))
                    end,
                },
                width2={
                    name="Border #2 width",
                    type="range",
                    min=0,
                    softMax=64,
                    bigStep=8,
                    order=8,
                    width=.7,
                    get=function() return addon.opt.statusWindow.extraBorderWidth end,
                    set=function(_,v)
                        addon.opt.statusWindow.extraBorderWidth = v
                        addon.StatusWindow:SetExtraBorderWidth(v)
                    end,
                },
            },
        },
        font={
            name="Fonts",
            type="group",
            inline=true,
            order=3,
            get=function(ctx) local which,key = ("|"):split(ctx[#ctx]) return addon.opt.statusWindow[which][key] end,
            set=function(ctx,v)
                local which,key = ("|"):split(ctx[#ctx])
                addon.opt.statusWindow[which][key] = v
                if which == "instanceFont" then
                    addon.StatusWindow:SetCurrentInstanceFont(fontopt(addon.opt.statusWindow.instanceFont))
                elseif which == "currentTimeFont" then
                    addon.StatusWindow:SetCurrentTimeFont(fontopt(addon.opt.statusWindow.currentTimeFont))
                elseif which == "splitNameFont" then
                    addon.StatusWindow:SetElapsedSplitNameFont(fontopt(addon.opt.statusWindow.splitNameFont))
                elseif which == "splitOffsetFont" then
                    addon.StatusWindow:SetElapsedSplitOffsetFont(fontopt(addon.opt.statusWindow.splitOffsetFont))
                elseif which == "splitTimeFont" then
                    addon.StatusWindow:SetElapsedSplitTimeFont(fontopt(addon.opt.statusWindow.splitTimeFont))
                end
            end,
            args={
                ["instanceFont|font"]={
                    name="Instance name font face",
                    type="select",
                    values=LSM:HashTable("font"),
                    dialogControl="LSM30_Font",
                    order=1,
                },
                ["instanceFont|size"]={
                    name="Instance name font size",
                    type="range",
                    min=4,
                    max=64,
                    bigStep=1,
                    order=2,
                },
                ["instanceFont|outline"]={
                    name="Instance name font flags",
                    type="select",
                    values=FONTOPTS,
                    order=3,
                },
                ["currentTimeFont|font"]={
                    name="Elapsed time font face",
                    type="select",
                    values=LSM:HashTable("font"),
                    dialogControl="LSM30_Font",
                    order=4,
                },
                ["currentTimeFont|size"]={
                    name="Elapsed time font size",
                    type="range",
                    min=4,
                    max=64,
                    bigStep=1,
                    order=5,
                },
                ["currentTimeFont|outline"]={
                    name="Elapsed time font flags",
                    type="select",
                    values=FONTOPTS,
                    order=6,
                },
                ["splitNameFont|font"]={
                    name="Split title font face",
                    type="select",
                    values=LSM:HashTable("font"),
                    dialogControl="LSM30_Font",
                    order=7,
                },
                ["splitNameFont|size"]={
                    name="Split title font size",
                    type="range",
                    min=4,
                    max=64,
                    bigStep=1,
                    order=8,
                },
                ["splitNameFont|outline"]={
                    name="Split title font flags",
                    type="select",
                    values=FONTOPTS,
                    order=9,
                },
                ["splitOffsetFont|font"]={
                    name="Split delta font face",
                    type="select",
                    values=LSM:HashTable("font"),
                    dialogControl="LSM30_Font",
                    order=10,
                },
                ["splitOffsetFont|size"]={
                    name="Split delta font size",
                    type="range",
                    min=4,
                    max=64,
                    bigStep=1,
                    order=11,
                },
                ["splitOffsetFont|outline"]={
                    name="Split delta font flags",
                    type="select",
                    values=FONTOPTS,
                    order=12,
                },
                ["splitTimeFont|font"]={
                    name="Split time font face",
                    type="select",
                    values=LSM:HashTable("font"),
                    dialogControl="LSM30_Font",
                    order=13,
                },
                ["splitTimeFont|size"]={
                    name="Split time font size",
                    type="range",
                    min=4,
                    max=64,
                    bigStep=1,
                    order=14,
                },
                ["splitTimeFont|outline"]={
                    name="Split time font flags",
                    type="select",
                    values=FONTOPTS,
                    order=15,
                },
            },
        },
    },
}

local CHANNELS = {
    PRINT = {
        name = "Print to chat",
        type="toggle",
        order=1,
    },
    GROUP = {
        name = "Send to group",
        type="toggle",
        order=2,
    },
    GUILD = {
        name = "Send to guild",
        type="toggle",
        order=3,
    },
}
local announcementOptions = {
    name = "|cffffd300D|r|cffff5000ungeon|r|cffffd300S|r|cffff5000peed|r|cffffd300R|r|cffff5000unner|r: Announcements",
    type = "group",
    get = function(ctx)
        return addon.opt.announceTo[ctx[#ctx-1]][ctx[#ctx]]
    end,
    set = function(ctx,state)
        addon.opt.announceTo[ctx[#ctx-1]][ctx[#ctx]] = state
    end,
    args = {
        bestRunComplete = {
            name="Run complete: New Record",
            desc="Send an announcement to these channels if you've just beaten a previous record!",
            type="group",
            inline=true,
            order=1,
            args=CHANNELS,
        },
        anyRunComplete = {
            name="Run complete: Other",
            desc="Send an announcement to these channels if you've just completed your first run, or did not beat your record",
            type="group",
            inline=true,
            order=2,
            args=CHANNELS,
        },
        bestSplit = {
            name="Split reached: On record pace",
            desc="Send an announcement to these channels if you've just reached a split, and were faster than on your currect best run",
            type="group",
            inline=true,
            order=3,
            args=CHANNELS,
        },
        anySplit = {
            name="Split reached: Other",
            desc="Send an announcement to these channels if you've just reached a split, but are not on track to beat your record",
            type="group",
            inline=true,
            order=4,
            args=CHANNELS,
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
    local optionsRefDummy = { element = optionsRef }
    
    AC:RegisterOptionsTable("DungeonSpeedRunner-Announcements", announcementOptions)
    ACD:AddToBlizOptions("DungeonSpeedRunner-Announcements", "Announcements", "DungeonSpeedRunner")
    
    AC:RegisterOptionsTable("DungeonSpeedRunner-Appearance", appearanceOptions)
    ACD:AddToBlizOptions("DungeonSpeedRunner-Appearance", "Textures & Fonts", "DungeonSpeedRunner")
    
    AC:RegisterOptionsTable("DungeonSpeedRunner-Layout", layoutOptions)
    ACD:AddToBlizOptions("DungeonSpeedRunner-Layout", "Layout", "DungeonSpeedRunner")
    
    AC:RegisterOptionsTable("DungeonSpeedRunner-Profile", LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db))
    ACD:AddToBlizOptions("DungeonSpeedRunner-Profile", "Profiles", "DungeonSpeedRunner")
    
    _G.SlashCmdList["DSR"] = function()
        InterfaceOptionsFrame:Show() -- force it to load first
        InterfaceOptionsFrame_OpenToCategory(optionsRef) -- open to our category
        if optionsRef.collapsed then -- expand our sub-categories
            InterfaceOptionsListButton_ToggleSubCategories(optionsRefDummy)
        end
    end
        
    _G.SLASH_DSR1 = "/dsr"
    _G.SLASH_DSR2 = "/dungeonspeedrunner"
    _G.SLASH_DSR3 = "/speedrun"
end)
listener:RegisterEvent("ADDON_LOADED")

function addon:OnProfileEnable()
    addon.opt = addon.db.profile
    
    -- run updates
    if addon.opt.announce then
        local oldDefaults = {
            bestSplit = { "GROUP" },
            anySplit = { "PRINT" },
            bestRunComplete = { "GROUP", "GUILD" },
            anyRunComplete = { "GROUP" },
        }
        for key, values in pairs(addon.opt.announce) do
            local newValues = {}
            for k,v in pairs(oldDefaults[key]) do
                newValues[k] = v
            end
            for k,v in pairs(values) do
                newValues[k] = v[1]
            end
            local newSettings = addon.opt.announceTo[key]
            newSettings.PRINT = false
            newSettings.GROUP = false
            newSettings.GUILD = false
            for _,v in ipairs(newValues) do newSettings[v] = true end
        end
        addon.opt.announce = nil
    end

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
