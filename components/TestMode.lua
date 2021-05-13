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

local function TestModeStart()
    assert(not addon.StatusWindow:IsShown())
    addon.StatusWindow:SetCurrentInstance("Test mode -- move me!")
    addon.StatusWindow:SetCloseButtonCallback(nil)
    
    local t = math.random() * 15
    local offs = 0
    for i=1,addon.opt.statusWindow.maxSplitCount do
        t  = t + math.random()*8
        offs = offs - 3 + math.random()*6
        
        addon.StatusWindow:SetSplitComplete(splitname(i), t+offs, t)
    end
    addon.StatusWindow:SetPendingSplit(splitname(addon.opt.statusWindow.maxSplitCount+1), t+offs+math.random()*12)
    addon.StatusWindow:SetTimeElapsed(t+math.random()*12)
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
