local addon = (select(2, ...))

local allowTestMode = true
local wantTestMode = false
local inTestMode = false

local function TestModeStart()
    assert(not addon.StatusWindow:IsShown())
    addon.StatusWindow:SetCurrentInstance("Test mode -- move me!")
    addon.StatusWindow:SetCloseButtonCallback(nil)
    addon.StatusWindow:SetLongFormat(true)
    
    local t = math.random() * 15
    local offs = 0
    for i=1,addon.opt.statusWindow.maxSplitCount do
        t  = t + math.random()*8
        offs = offs - 3 + math.random()*6
        addon.StatusWindow:SetSplitComplete("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Split #"..i, t+offs, t)
    end
    addon.StatusWindow:SetPendingSplit("|T132147:0|t Pending Split", t+offs+math.random()*12)
    addon.StatusWindow:SetTimeElapsed(t)
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
