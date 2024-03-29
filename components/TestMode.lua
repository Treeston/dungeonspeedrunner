local assert, select, print = assert, select, print
local random = math.random

local addon = (select(2, ...))

local allowTestMode = true
local wantTestMode = false
local inTestMode = false

local function splitname(i)
    if i%2 == 1 then
        return ("|T132147:0|t Boss #"..((i+1)/2))
    else
        return ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Boss #"..(i/2))
    end
end

local function closeCallback()
    addon.opt.testMode = false
    addon.TestMode:DisableTestMode()
    addon:RefreshOptionsDialog("")
    print("|cffffd300DSR|r: Test Mode disabled, use |cffffd300/dsr|r to access settings!")
end

local function TestModeStart()
    assert(not addon.StatusWindow:IsShown())
    addon.StatusWindow:SetCurrentInstance("Test mode -- use |cffffd300/dsr|r for options!")
    addon.StatusWindow:SetCloseButtonCallback(closeCallback)
    
    local t = random() * 15
    local offs = 0
    for i=1,addon.opt.statusWindow.maxSplitCount do
        t  = t + random()*8
        offs = offs - 3 + random()*6
        
        addon.StatusWindow:SetSplitComplete(splitname(i), t+offs, t)
    end
    addon.StatusWindow:SetPendingSplit(splitname(addon.opt.statusWindow.maxSplitCount+1), t+offs+random()*12)
    addon.StatusWindow:SetTimeElapsed(t+random()*12)
    addon.StatusWindow:SetRightClickOptionsEnabled(true)
    
    addon.StatusWindow:Show()
end

local function TestModeStop()
    addon.StatusWindow:SetRightClickOptionsEnabled(false)
    addon.StatusWindow:ImmediateReset()
    addon.StatusWindow:Hide()
end

local function TestModeUpdate()
    local shouldHaveTestMode = (allowTestMode and wantTestMode)
    if shouldHaveTestMode == inTestMode then return end
    
    if shouldHaveTestMode then
        TestModeStart()
    else
        TestModeStop()
    end
    inTestMode = shouldHaveTestMode
end

addon.TestMode = {}

function addon.TestMode:AllowTestMode()
    allowTestMode = true
    TestModeUpdate()
end

function addon.TestMode:DisallowTestMode()
    allowTestMode = false
    TestModeUpdate()
end

function addon.TestMode:EnableTestMode()
    wantTestMode = true
    TestModeUpdate()
end

function addon.TestMode:DisableTestMode()
    wantTestMode = false
    TestModeUpdate()
end

function addon.TestMode:RefreshTestModeSplits()
    if inTestMode then
        TestModeStop()
        TestModeStart()
    end
end
