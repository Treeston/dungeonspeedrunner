local addon = (select(2,...))

local assert, pairs, ipairs = assert, pairs, ipairs
local GetTime = GetTime
local tinsert, tremove, twipe = table.insert, table.remove, table.wipe
local abs, floor = math.abs, math.floor

local currentRenderProps = {
    -- mainContentHeight
    -- mainNameWidth
    -- mainTimeWidth
    -- mainSpacing
    -- mainPadding
    -- mainBorderWidth
    -- mainBackdropInset
    
    -- growUp
    -- growLeft
    
    -- extraSplitHeight
    -- extraSpacing
    -- extraPadding
    -- extraBorderWidth
    -- extraBackdropInset
    
    -- extraSplitNameWidth
    -- extraSplitChangeWidth
    -- extraSplitTimeWidth
    -- extraSplitTextSpacing
    
    -- closeButtonSize
}

local derivedRenderProps = {
    -- extraInnerPadding
    -- extraHeightRelativeOffset
}

-- create all frames + assign unchanging static properties
local mainWindow = CreateFrame("Frame", "DungeonSpeedRunner_Status", UIParent)
mainWindow:Hide()
mainWindow:SetFrameLevel(3)
addon:CreateBackdropTextures(mainWindow)
addon.StatusWindow = mainWindow

mainWindow.currentInstanceText = mainWindow:CreateFontString(nil, "ARTWORK")
mainWindow.currentInstanceText:SetJustifyH("LEFT")
mainWindow.currentInstanceText:SetWordWrap(false)

mainWindow.currentTimeText = mainWindow:CreateFontString(nil, "OVERLAY")
mainWindow.currentTimeText:SetJustifyH("RIGHT")
mainWindow.currentTimeText:SetWordWrap(false)

local topBackdrop = CreateFrame("Frame", nil, mainWindow)
topBackdrop:SetFrameLevel(1)
addon:CreateBackdropTextures(topBackdrop, addon.EXCLUDE_BOTTOM)

local bottomBackdrop = CreateFrame("Frame", nil, mainWindow)
bottomBackdrop:SetFrameLevel(1)
addon:CreateBackdropTextures(bottomBackdrop, addon.EXCLUDE_TOP)

local leftBackdrop = CreateFrame("Frame", nil, mainWindow)
leftBackdrop:SetFrameLevel(1)
addon:CreateBackdropTextures(leftBackdrop, addon.EXCLUDE_RIGHT)

local rightBackdrop = CreateFrame("Frame", nil, mainWindow)
rightBackdrop:SetFrameLevel(1)
addon:CreateBackdropTextures(rightBackdrop, addon.EXCLUDE_LEFT)

local closeButton = CreateFrame("Button", nil, mainWindow, "UIPanelCloseButtonNoScripts")
closeButton:Disable()
for _,s in ipairs({"GetDisabledTexture","GetNormalTexture","GetPushedTexture","GetHighlightTexture"}) do
    closeButton[s](closeButton):SetTexCoord(.2,.8,.2,.8)
end


local pendingSplitFrame = CreateFrame("Frame", nil, mainWindow)
pendingSplitFrame:SetFrameLevel(2)

local splitFontElapsedName = CreateFont("DungeonSpeedRunnerElapsedSplitNameFont")
local splitFontElapsedOffset = CreateFont("DungeonSpeedRunnerElapsedSplitOffsetFont")
local splitFontElapsedTime = CreateFont("DungeonSpeedRunnerElapsedSplitTimeFont")

pendingSplitFrame.nameText = pendingSplitFrame:CreateFontString(nil, "OVERLAY")
pendingSplitFrame.nameText:SetFontObject(splitFontElapsedName)
pendingSplitFrame.nameText:SetTextColor(1,1,1)
pendingSplitFrame.nameText:SetJustifyH("LEFT")
pendingSplitFrame.nameText:SetJustifyV("MIDDLE")
pendingSplitFrame.nameText:SetWordWrap(false)
pendingSplitFrame.nameText:SetPoint("TOP")
pendingSplitFrame.nameText:SetPoint("BOTTOM")
pendingSplitFrame.nameText:SetPoint("LEFT", pendingSplitFrame, "LEFT")

pendingSplitFrame.changeText = pendingSplitFrame:CreateFontString(nil, "OVERLAY")
pendingSplitFrame.changeText:SetFontObject(splitFontElapsedOffset)
pendingSplitFrame.changeText:SetTextColor(1,1,0)
pendingSplitFrame.changeText:SetJustifyH("RIGHT")
pendingSplitFrame.changeText:SetJustifyV("MIDDLE")
pendingSplitFrame.changeText:SetWordWrap(false)
pendingSplitFrame.changeText:SetPoint("TOP")
pendingSplitFrame.changeText:SetPoint("BOTTOM")

pendingSplitFrame.timeText = pendingSplitFrame:CreateFontString(nil, "OVERLAY")
pendingSplitFrame.timeText:SetFontObject(splitFontElapsedTime)
pendingSplitFrame.timeText:SetTextColor(1,1,0)
pendingSplitFrame.timeText:SetJustifyH("RIGHT")
pendingSplitFrame.timeText:SetJustifyV("MIDDLE")
pendingSplitFrame.timeText:SetWordWrap(false)
pendingSplitFrame.timeText:SetPoint("TOP")
pendingSplitFrame.timeText:SetPoint("BOTTOM")

local activeSplitFrames = {}
_G.ACTIVE = activeSplitFrames
local inactiveSplitFrames = {}
local function createSplitFrame()
    local f = CreateFrame("Frame", nil, mainWindow)
    f:SetFrameLevel(2)
    f:SetHeight(currentRenderProps.extraSplitHeight)
    f:SetWidth(derivedRenderProps.splitWidth)
    
    local textSpacing = currentRenderProps.extraSplitTextSpacing
    
    f.nameText = f:CreateFontString(nil, "OVERLAY")
    f.nameText:SetFontObject(splitFontElapsedName)
    f.nameText:SetTextColor(1,1,1)
    f.nameText:SetJustifyH("LEFT")
    f.nameText:SetJustifyV("MIDDLE")
    f.nameText:SetWordWrap(false)
    f.nameText:SetPoint("TOP")
    f.nameText:SetPoint("BOTTOM")
    f.nameText:SetPoint("LEFT")
    f.nameText:SetWidth(currentRenderProps.extraSplitNameWidth)
    
    f.changeText = f:CreateFontString(nil, "OVERLAY")
    f.changeText:SetFontObject(splitFontElapsedOffset)
    f.changeText:SetJustifyH("RIGHT")
    f.changeText:SetJustifyV("MIDDLE")
    f.changeText:SetWordWrap(false)
    f.changeText:SetPoint("TOP")
    f.changeText:SetPoint("BOTTOM")
    f.changeText:SetPoint("LEFT", f.nameText, "RIGHT", textSpacing, 0)
    f.changeText:SetWidth(currentRenderProps.extraSplitChangeWidth)
    
    f.timeText = f:CreateFontString(nil, "OVERLAY")
    f.timeText:SetFontObject(splitFontElapsedTime)
    f.timeText:SetTextColor(.4,1.,4)
    f.timeText:SetJustifyH("RIGHT")
    f.timeText:SetJustifyV("MIDDLE")
    f.timeText:SetWordWrap(false)
    f.timeText:SetPoint("TOP")
    f.timeText:SetPoint("BOTTOM")
    f.timeText:SetPoint("LEFT", f.changeText, "RIGHT", textSpacing, 0)
    f.timeText:SetWidth(currentRenderProps.extraSplitTimeWidth)

    return f
end

-- updaters for render properties
local function MainNameWidthUpdated()
    mainWindow.currentInstanceText:SetWidth(currentRenderProps.mainNameWidth)
end

local function MainTimeWidthUpdated()
    mainWindow.currentTimeText:SetWidth(currentRenderProps.mainTimeWidth)
end

local function MainBorderWidthUpdated()
    addon:SetBackdropBorderWidth(mainWindow, currentRenderProps.mainBorderWidth)
end

local function MainBackdropInsetUpdated()
    addon:SetBackdropInset(mainWindow, currentRenderProps.mainBackdropInset)
end

local function ExtraSplitHeightUpdated()
    local height = currentRenderProps.extraSplitHeight
    pendingSplitFrame:SetHeight(height)
    for _,f in ipairs(activeSplitFrames) do f:SetHeight(height) end
    for _,f in ipairs(inactiveSplitFrames) do f:SetHeight(height) end
end

local function ExtraBorderWidthUpdated()
    local width = currentRenderProps.extraBorderWidth
    addon:SetBackdropBorderWidth(topBackdrop, width)
    addon:SetBackdropBorderWidth(bottomBackdrop, width)
    addon:SetBackdropBorderWidth(leftBackdrop, width)
    addon:SetBackdropBorderWidth(rightBackdrop, width)
end

local function ExtraBackdropInsetUpdated()
    local inset = currentRenderProps.extraBackdropInset
    addon:SetBackdropInset(topBackdrop, inset)
    addon:SetBackdropInset(bottomBackdrop, inset)
    addon:SetBackdropInset(leftBackdrop, inset)
    addon:SetBackdropInset(rightBackdrop, inset)
end

local function ExtraSplitNameWidthUpdated()
    local width = currentRenderProps.extraSplitNameWidth
    pendingSplitFrame.nameText:SetWidth(width)
    for _,f in ipairs(activeSplitFrames) do f.nameText:SetWidth(width) end
    for _,f in ipairs(inactiveSplitFrames) do f.nameText:SetWidth(width) end
end

local function ExtraSplitChangeWidthUpdated()
    local width = currentRenderProps.extraSplitChangeWidth
    pendingSplitFrame.changeText:SetWidth(width)
    for _,f in ipairs(activeSplitFrames) do f.changeText:SetWidth(width) end
    for _,f in ipairs(inactiveSplitFrames) do f.changeText:SetWidth(width) end
end

local function ExtraSplitTimeWidthUpdated()
    local width = currentRenderProps.extraSplitTimeWidth
    pendingSplitFrame.timeText:SetWidth(width)
    for _,f in ipairs(activeSplitFrames) do f.changeText:SetWidth(width) end
    for _,f in ipairs(inactiveSplitFrames) do f.changeText:SetWidth(width) end
end

local function ExtraSplitTextSpacingUpdated()
    local spacing = currentRenderProps.extraSplitTextSpacing
    pendingSplitFrame.changeText:SetPoint("LEFT", pendingSplitFrame.nameText, "RIGHT", spacing, 0)
    pendingSplitFrame.timeText:SetPoint("LEFT", pendingSplitFrame.changeText, "RIGHT", spacing, 0)
    for _,f in ipairs(activeSplitFrames) do
        f.changeText:SetPoint("LEFT", f.nameText, "RIGHT", spacing, 0)
        f.timeText:SetPoint("LEFT", f.changeText, "RIGHT", spacing, 0)
    end
    for _,f in ipairs(inactiveSplitFrames) do
        f.changeText:SetPoint("LEFT", f.nameText, "RIGHT", spacing, 0)
        f.timeText:SetPoint("LEFT", f.changeText, "RIGHT", spacing, 0)
    end
end

local function CloseButtonSizeUpdated()
    local size = currentRenderProps.closeButtonSize
    closeButton:SetSize(size, size)
end

-- updaters for derived properties
local function UpdateMainWindowWidth()
    mainWindow:SetWidth(currentRenderProps.mainNameWidth + currentRenderProps.mainSpacing + currentRenderProps.mainTimeWidth + 2*(currentRenderProps.mainPadding + currentRenderProps.mainBackdropInset))
end

local function UpdateMainWindowHeight()
    mainWindow:SetHeight(currentRenderProps.mainContentHeight + 2*(currentRenderProps.mainPadding + currentRenderProps.mainBackdropInset))
end

local function UpdateMainTextAnchors()
    local offset = currentRenderProps.mainPadding + currentRenderProps.mainBackdropInset
    mainWindow.currentInstanceText:SetPoint("TOP", mainWindow, "TOP", 0, -offset)
    mainWindow.currentInstanceText:SetPoint("BOTTOM", mainWindow, "BOTTOM", 0, offset)
    mainWindow.currentInstanceText:SetPoint("LEFT", mainWindow, "LEFT", offset, 0)
    
    mainWindow.currentTimeText:SetPoint("TOP", mainWindow, "TOP", 0, -offset)
    mainWindow.currentTimeText:SetPoint("BOTTOM", mainWindow, "BOTTOM", 0, offset)
    mainWindow.currentTimeText:SetPoint("RIGHT", mainWindow, "RIGHT", -offset, 0)
end

local function UpdateExtraWindowWidth()
    local splitWidth = currentRenderProps.extraSplitNameWidth + currentRenderProps.extraSplitChangeWidth + currentRenderProps.extraSplitTimeWidth + 2*currentRenderProps.extraSplitTextSpacing
    
    pendingSplitFrame:SetWidth(splitWidth)
    for _,f in ipairs(activeSplitFrames) do f:SetWidth(splitWidth) end
    for _,f in ipairs(inactiveSplitFrames) do f:SetWidth(splitWidth) end
    derivedRenderProps.splitWidth = splitWidth
    
    local frameWidth = splitWidth + 2*(currentRenderProps.extraPadding + currentRenderProps.extraBackdropInset)
    topBackdrop:SetWidth(frameWidth)
    bottomBackdrop:SetWidth(frameWidth)
end

local function UpdateVerticalExtraContent()
    local growUp = currentRenderProps.growUp
    ;(growUp and bottomBackdrop or topBackdrop):Hide()
    
    local anchorBackdrop = (growUp and topBackdrop or bottomBackdrop)
    if #activeSplitFrames == 0 then anchorBackdrop:Hide() return end
    
    local anchor = growUp and "BOTTOM" or "TOP"
    local extra = growUp and currentRenderProps.extraSplitHeight or 0
    local sign = growUp and 1 or -1
    
    local offsetFirst = derivedRenderProps.extraInnerPadding + currentRenderProps.extraPadding
    local offsetEach = currentRenderProps.extraSplitHeight + currentRenderProps.extraSpacing
    
    for i,f in ipairs(activeSplitFrames) do
        f:SetPoint("TOP", anchorBackdrop, anchor, 0, sign * (offsetFirst + extra + ((i-1)-(f.relativeOffset))*offsetEach))
    end
    
    anchorBackdrop:SetHeight(offsetFirst + (#activeSplitFrames - derivedRenderProps.extraHeightRelativeOffset) * offsetEach + (currentRenderProps.extraPadding - currentRenderProps.extraSpacing) + currentRenderProps.extraBackdropInset)
    
    anchorBackdrop:Show()
end

local function UpdateHorizontalExtraContent()
    local growLeft = currentRenderProps.growLeft
    ;(growLeft and rightBackdrop or leftBackdrop):Hide()
    
    local anchorBackdrop = (growLeft and leftBackdrop or rightBackdrop)
    local anchor = growLeft and "LEFT" or "RIGHT"
    local sign = growLeft and 1 or -1
    
    anchorBackdrop:SetWidth(derivedRenderProps.extraInnerPadding + currentRenderProps.closeButtonSize + 2*currentRenderProps.extraPadding + currentRenderProps.extraBackdropInset)
    anchorBackdrop:SetHeight(currentRenderProps.closeButtonSize + 2*(currentRenderProps.extraPadding + currentRenderProps.extraBackdropInset))
    
    closeButton:ClearAllPoints()
    closeButton:SetPoint(anchor, anchorBackdrop, anchor, sign*(currentRenderProps.extraPadding + currentRenderProps.extraBackdropInset), 0)
end

local function UpdateExtraAnchorOffsets()
    local extraAnchorOffset = (currentRenderProps.mainBorderWidth + currentRenderProps.mainBackdropInset) / 2
    derivedRenderProps.extraInnerPadding = currentRenderProps.mainBorderWidth - extraAnchorOffset
    
    topBackdrop:SetPoint("BOTTOM", mainWindow, "TOP", 0, -extraAnchorOffset)
    bottomBackdrop:SetPoint("TOP", mainWindow, "BOTTOM", 0, extraAnchorOffset)
    leftBackdrop:SetPoint("RIGHT", mainWindow, "LEFT", extraAnchorOffset, 0)
    rightBackdrop:SetPoint("LEFT", mainWindow, "RIGHT", -extraAnchorOffset, 0)
    
    UpdateVerticalExtraContent()
    UpdateHorizontalExtraContent()
end

-- animation queue system
local isAnimating = false
local animationQueue = {}
local animationQueueNext = 1
local function CurrentAnimationFinished()
    if not isAnimating then geterrorhandler()("Tried to finish animation. No animation ongoing.") return end
    isAnimating = false
    local nextAnimation = animationQueue[animationQueueNext]
    if nextAnimation then
        animationQueueNext = animationQueueNext + 1
        mainWindow[nextAnimation[1]](mainWindow, unpack(nextAnimation, 2))
    else
        twipe(animationQueue)
        animationQueueNext = 1
    end
end

local function AskAnimationPermission(fn, ...)
    if not isAnimating then
        isAnimating = true
        return true
    end
    tinsert(animationQueue, {fn, ...})
    return false
end

local function WrapImmediateAnimation(fn)
    local old = assert(mainWindow[fn])
    mainWindow[fn] = function(f, ...)
        if not AskAnimationPermission(fn, ...) then return end
        old(f, ...)
        CurrentAnimationFinished()
    end
end

local FIRST_SPLIT_OFFSET = 3
local SPLIT_FRAME_HEIGHT = 20
local SPLIT_FRAME_PADDING = 1
local EACH_SPLIT_OFFSET = (SPLIT_FRAME_HEIGHT + SPLIT_FRAME_PADDING)
local LAST_SPLIT_OFFSET = 5

local splitAnimationFrame = CreateFrame("Frame")
splitAnimationFrame:Hide()
splitAnimationFrame:SetScript("OnUpdate", function(self, elapsed)
    if self.remaining <= elapsed then
        self.remaining = 0
    else
        self.remaining = self.remaining - elapsed
    end
    
    local relativeOffset = (self.remaining / self.duration)
    if self.stopAfterFirst then
        activeSplitFrames[1].relativeOffset = relativeOffset
    else
        for _,f in ipairs(activeSplitFrames) do f.relativeOffset = relativeOffset end
    end
    
    if not self.skipHeight then derivedRenderProps.extraHeightRelativeOffset = relativeOffset end
    
    UpdateVerticalExtraContent()
    
    if self.remaining == 0 then
        self:Hide()
        if self.nextAnimationFrame then
            self.nextAnimationFrame:Animate()
        else
            CurrentAnimationFinished()
        end
    end
end)
function splitAnimationFrame:Animate()
    assert(not self:IsShown())
    self.remaining = self.duration
    self:Show()
    self:GetScript("OnUpdate")(self,0)
end

local cos = math.cos
local flashFactor = -5*math.pi
local flashFirstSplitFrame = CreateFrame("Frame")
flashFirstSplitFrame:Hide()
flashFirstSplitFrame:SetScript("OnUpdate", function(self, elapsed)
    if self.remaining <= elapsed then
        activeSplitFrames[1].timeText:SetAlpha(1)
        self.remaining = 0
        self:Hide()
        if self.nextAnimationFrame then
            self.nextAnimationFrame:Animate()
        else
            CurrentAnimationFinished()
        end
    else
        self.remaining = self.remaining - elapsed
        activeSplitFrames[1].timeText:SetAlpha(cos(flashFactor*(self.remaining / self.duration))/2+0.5)
    end
end)
function flashFirstSplitFrame:Animate()
    assert(not self:IsShown())
    self.remaining = self.duration
    self:Show()
    self:GetScript("OnUpdate")(self,0)
end

local waitFrame = CreateFrame("Frame")
waitFrame:Hide()
waitFrame:SetScript("OnUpdate", function(self, elapsed)
    if self.remaining <= elapsed then
        self.remaining = 0
        self:Hide()
        if self.nextAnimationFrame then
            self.nextAnimationFrame:Animate()
        else
            CurrentAnimationFinished()
        end
    else
        self.remaining = self.remaining - elapsed
    end
end)
function waitFrame:Animate()
    assert(not self:IsShown())
    self.remaining = self.duration
    self:Show()
    self:GetScript("OnUpdate")(self,0)
end

-- animation operators
function mainWindow:SetPendingSplit(name, targetTime)
    if not AskAnimationPermission("SetPendingSplit", name, targetTime) then return end
    
    pendingSplitFrame.nameText:SetText(name)
    pendingSplitFrame.timeText:SetText(addon:FormatTimerString(targetTime, mainWindow.longFormat))
    pendingSplitFrame.targetTime = targetTime
    pendingSplitFrame:Show()
    if activeSplitFrames[1] == pendingSplitFrame then
        splitAnimationFrame.stopAfterFirst = true
        splitAnimationFrame.skipHeight = true
    else
        tinsert(activeSplitFrames, 1, pendingSplitFrame)
        splitAnimationFrame.stopAfterFirst = false
        
        if #activeSplitFrames <= mainWindow.maxSplitCount then
            splitAnimationFrame.skipHeight = false
        else
            assert(mainWindow.maxSplitCount > 0)
            local trailing = tremove(activeSplitFrames)
            trailing:Hide()
            tinsert(inactiveSplitFrames, trailing)
            splitAnimationFrame.skipHeight = true
        end
    end
    
    splitAnimationFrame.nextAnimationFrame = waitFrame
    splitAnimationFrame.duration = .5
    waitFrame.nextAnimationFrame = nil
    waitFrame.duration = .2
    splitAnimationFrame:Animate()
end

function mainWindow:SetSplitComplete(name, targetTime, ourTime)
    if not AskAnimationPermission("SetSplitComplete", name, targetTime, ourTime) then return end
    
    local splitFrame = tremove(inactiveSplitFrames) or createSplitFrame()
    if targetTime then
        local change = ourTime - targetTime
        if change < 0 then
            splitFrame.changeText:SetTextColor(0,1,0)
        elseif change > 0 then
            splitFrame.changeText:SetTextColor(1,0,0)
        else
            splitFrame.changeText:SetTextColor(1,1,0)
        end

        splitFrame.change = change
        splitFrame.changeText:SetText(addon:FormatChangeString(change, mainWindow.longFormat))
    else
        splitFrame.change = nil
        splitFrame.changeText:SetText("")
    end
    
    splitFrame.ourTime = ourTime

    splitFrame.nameText:SetText(name)
    splitFrame.timeText:SetText(addon:FormatTimerString(ourTime, mainWindow.longFormat))
    splitFrame.relativeOffset = 0
    
    splitFrame:Show()
    
    if activeSplitFrames[1] == pendingSplitFrame then
        pendingSplitFrame:Hide()
        activeSplitFrames[1] = splitFrame
        
        UpdateVerticalExtraContent()
        
        flashFirstSplitFrame.nextAnimationFrame = waitFrame
        flashFirstSplitFrame.duration = 1.5
        
        waitFrame.nextAnimationFrame = nil
        waitFrame.duration = .2
        
        flashFirstSplitFrame:Animate()
    else
        tinsert(activeSplitFrames, 1, splitFrame)
        splitAnimationFrame.stopAfterFirst = false
        if #activeSplitFrames <= mainWindow.maxSplitCount then
            splitAnimationFrame.skipHeight = false
        else
            local trailing = tremove(activeSplitFrames)
            trailing:Hide()
            tinsert(inactiveSplitFrames, trailing)
            splitAnimationFrame.skipHeight = true
        end
        
        splitAnimationFrame.nextAnimationFrame = waitFrame
        splitAnimationFrame.duration = .5
        waitFrame.nextAnimationFrame = nil
        waitFrame.duration = .2
        splitAnimationFrame:Animate()
    end
end

function mainWindow:SetMaxSplitCount(splitCount)
    assert(splitCount > 0)
    mainWindow.maxSplitCount = splitCount
    local nOver = (#activeSplitFrames - splitCount)
    if nOver <= 0 then return end
    for i=1, nOver do
        local trailing = tremove(activeSplitFrames)
        trailing:Hide()
        tinsert(inactiveSplitFrames, trailing)
    end
    UpdateVerticalExtraContent()
end
WrapImmediateAnimation("SetMaxSplitCount")

function mainWindow:Reset()
    mainWindow:ImmediateReset() --@todo
end

function mainWindow:ImmediateReset()
    mainWindow:StopTimer()
    for _,f in ipairs(activeSplitFrames) do
        f:Hide()
        if f ~= pendingSplitFrame then
            tinsert(inactiveSplitFrames, f)
        end
    end
    twipe(activeSplitFrames);
    UpdateVerticalExtraContent()
end
WrapImmediateAnimation("ImmediateReset")

-- render property setters
function mainWindow:SetMainContentHeight(height)
    currentRenderProps.mainContentHeight = height
    UpdateMainWindowHeight()
end

function mainWindow:SetMainInstanceNameWidth(width)
    currentRenderProps.mainNameWidth = width
    MainNameWidthUpdated()
    
    UpdateMainWindowWidth()
end

function mainWindow:SetMainCurrentTimeWidth(width)
    currentRenderProps.mainTimeWidth = width
    MainTimeWidthUpdated()
    
    UpdateMainWindowWidth()
end

function mainWindow:SetMainTextSpacing(spacing)
    currentRenderProps.mainSpacing = spacing
    
    UpdateMainWindowWidth()
end

function mainWindow:SetMainPadding(padding)
    currentRenderProps.mainPadding = padding
    
    UpdateMainWindowWidth()
    UpdateMainWindowHeight()
    UpdateMainTextAnchors()
end

function mainWindow:SetMainBorderWidth(width)
    currentRenderProps.mainBorderWidth = width
    MainBorderWidthUpdated()

    UpdateExtraAnchorOffset()
end

function mainWindow:SetMainBackdropInset(inset)
    currentRenderProps.mainBackdropInset = inset
    MainBackdropInsetUpdated()

    UpdateMainTextAnchors()
    UpdateMainWindowWidth()
    UpdateMainWindowHeight()
    UpdateExtraAnchorOffset()
end

function mainWindow:SetGrowUp(growUp)
    currentRenderProps.growUp = growUp
    
    UpdateVerticalExtraContent()
end

function mainWindow:SetGrowLeft(growLeft)
    currentRenderProps.growLeft = growLeft
    
    UpdateHorizontalExtraContent()
end

function mainWindow:SetExtraSplitHeight(height)
    currentRenderProps.extraSplitHeight = height
    ExtraSplitHeightUpdated()

    UpdateVerticalExtraContent()
end

function mainWindow:SetExtraSplitSpacing(spacing)
    currentRenderProps.extraSpacing = spacing
    
    UpdateVerticalExtraContent()
end

function mainWindow:SetExtraPadding(padding)
    currentRenderProps.extraPadding = padding
    
    UpdateExtraWindowWidth()
    UpdateVerticalExtraContent()
    UpdateHorizontalExtraContent()
end

function mainWindow:SetExtraBorderWidth(width)
    currentRenderProps.extraBorderWidth = width
    ExtraBorderWidthUpdated()
end

function mainWindow:SetExtraBackdropInset(inset)
    currentRenderProps.extraBackdropInset = inset
    ExtraBackdropInsetUpdated()
    
    UpdateExtraWindowWidth()
    UpdateVerticalExtraContent()
    UpdateHorizontalExtraContent()
end

function mainWindow:SetExtraSplitNameWidth(width)
    currentRenderProps.extraSplitNameWidth = width
    ExtraSplitNameWidthUpdated()
    
    UpdateExtraWindowWidth()
end

function mainWindow:SetExtraSplitChangeWidth(width)
    currentRenderProps.extraSplitChangeWidth = width
    ExtraSplitChangeWidthUpdated()
    
    UpdateExtraWindowWidth()
end

function mainWindow:SetExtraSplitTimeWidth(width)
    currentRenderProps.extraSplitTimeWidth = width
    ExtraSplitTimeWidthUpdated()
    
    UpdateExtraWindowWidth()
end

function mainWindow:SetExtraSplitTextSpacing(spacing)
    currentRenderProps.extraSplitTextSpacing = spacing
    ExtraSplitTextSpacingUpdated()
    
    UpdateExtraWindowWidth()
end

function mainWindow:SetCloseButtonSize(size)
    currentRenderProps.closeButtonSize = size
    CloseButtonSizeUpdated()
    
    UpdateHorizontalExtraContent()
end

local keys = {"mainContentHeight", "mainNameWidth", "mainTimeWidth", "mainSpacing", "mainPadding", "mainBorderWidth", "mainBackdropInset", "growUp", "growLeft", "extraSplitHeight", "extraSpacing", "extraPadding", "extraBorderWidth", "extraBackdropInset", "extraSplitNameWidth", "extraSplitChangeWidth", "extraSplitTimeWidth", "extraSplitTextSpacing", "closeButtonSize" }
function mainWindow:ImportRenderOptions(options)
    for _,key in ipairs(keys) do
        local v = options[key]
        assert(v ~= nil, key)
        currentRenderProps[key] = v
    end
    
    MainNameWidthUpdated()
    MainTimeWidthUpdated()
    MainBorderWidthUpdated()
    MainBackdropInsetUpdated()
    ExtraSplitHeightUpdated()
    ExtraBorderWidthUpdated()
    ExtraBackdropInsetUpdated()
    ExtraSplitNameWidthUpdated()
    ExtraSplitChangeWidthUpdated()
    ExtraSplitTimeWidthUpdated()
    ExtraSplitTextSpacingUpdated()
    CloseButtonSizeUpdated()
    
    UpdateMainWindowWidth()
    UpdateMainWindowHeight()
    UpdateMainTextAnchors()
    UpdateExtraWindowWidth()
    UpdateExtraAnchorOffsets() -- this also calls vertical/horizontal content updaters
end

-- uninteresting setters (no derived properties)
function mainWindow:SetMainBackdropTexture(texture)
    addon:SetBackdropTexture(mainWindow, texture)
end

function mainWindow:SetMainBorderTexture(texture)
    addon:SetBackdropBorderTexture(mainWindow, texture)
end

function mainWindow:SetExtraBackdropTexture(texture)
    addon:SetBackdropTexture(topBackdrop, texture)
    addon:SetBackdropTexture(bottomBackdrop, texture)
    addon:SetBackdropTexture(leftBackdrop, texture)
    addon:SetBackdropTexture(rightBackdrop, texture)
end

function mainWindow:SetExtraBorderTexture(texture)
    addon:SetBackdropBorderTexture(topBackdrop, texture)
    addon:SetBackdropBorderTexture(bottomBackdrop, texture)
    addon:SetBackdropBorderTexture(leftBackdrop, texture)
    addon:SetBackdropBorderTexture(rightBackdrop, texture)
end

function mainWindow:SetCurrentInstanceFont(font, size, outline)
    mainWindow.currentInstanceText:SetFont(font, size, outline)
    mainWindow.currentInstanceText:SetTextColor(1,1,1)
end

function mainWindow:SetCurrentTimeFont(font, size, outline)
    mainWindow.currentTimeText:SetFont(font, size, outline)
    mainWindow.currentTimeText:SetTextColor(.4,1,.4)
end

function mainWindow:SetElapsedSplitNameFont(font, size, outline)
    splitFontElapsedName:SetFont(font, size, outline)
end
function mainWindow:SetElapsedSplitOffsetFont(font, size, outline)
    splitFontElapsedOffset:SetFont(font, size, outline)
end
function mainWindow:SetElapsedSplitTimeFont(font, size, outline)
    splitFontElapsedTime:SetFont(font, size, outline)
end

function mainWindow:SetAnchorPoint(myPoint, relativeFrame, theirPoint, offX, offY)
    mainWindow:ClearAllPoints()
    mainWindow:SetPoint(myPoint, _G[relativeFrame] or UIParent, theirPoint, offX, offY)
end

function mainWindow:SetLongFormat(state)
    mainWindow.longFormat = state
    mainWindow.currentTimeText:SetText(addon:FormatTimerString(mainWindow.timeElapsed, state))
    pendingSplitFrame.timeText:SetText(addon:FormatTimerString(pendingSplitFrame.targetTime, state))
    for _,f in pairs(activeSplitFrames) do
        if f ~= pendingSplitFrame then
            f.timeText:SetText(addon:FormatTimerString(f.ourTime, state))
            if f.change then f.changeText:SetText(addon:FormatChangeString(f.change, state)) end
        end
    end
end

function mainWindow:SetCurrentInstance(name)
    mainWindow.currentInstanceText:SetText(name)
end

function mainWindow:SetTimeElapsed(elapsed)
    if (not mainWindow.longFormat) and (3600 <= elapsed) then
        mainWindow:SetLongFormat(true)
    end
    mainWindow.timeElapsed = elapsed
    mainWindow.currentTimeText:SetText(addon:FormatTimerString(elapsed, mainWindow.longFormat))
end

function mainWindow:SetCloseButtonCallback(fn)
    closeButton:SetScript("OnClick", fn)
    closeButton[fn and "Enable" or "Disable"](closeButton)
end

-- drag & drop functionality
mainWindow.locked = true
function mainWindow:SetLocked(state)
    mainWindow.locked = state
    if not mainWindow.locked then
        mainWindow:EnableMouse(true)
        mainWindow:RegisterForDrag("button1")
        mainWindow:SetMovable(true)
    else
        mainWindow:StopMovingOrSizing()
        mainWindow:SetMovable(false)
        mainWindow:RegisterForDrag()
        mainWindow:EnableMouse(false)
    end
end

mainWindow:SetScript("OnDragStart", function()
    if not mainWindow.locked then
        mainWindow:StartMoving()
        mainWindow:SetUserPlaced(false)
    end
end)

mainWindow:SetScript("OnDragStop", function()
    mainWindow:StopMovingOrSizing()
    addon.opt.statusWindow.anchorPoint = {mainWindow:GetPoint(1)}
end)

mainWindow:SetScript("OnMouseUp", function(_,btn)
    if mainWindow.rightClickOpensOptions and (btn == "RightButton") then
        SlashCmdList.DSR()
    end
end)

function mainWindow:SetRightClickOptionsEnabled(state)
    mainWindow.rightClickOpensOptions = state
end
 
-- timer functionality
local timerFrame = CreateFrame("Frame")
timerFrame:Hide()
timerFrame:SetScript("OnUpdate", function(self)
    mainWindow:SetTimeElapsed(GetTime() - self.startTime)
end)

function mainWindow:ResetTimer()
    timerFrame.startTime = GetTime()
end

function mainWindow:ResumeTimer()
    if not timerFrame.startTime then
        mainWindow:ResetTimer()
    end
    timerFrame:Show()
end

function mainWindow:StopTimer()
    timerFrame:Hide()
end
