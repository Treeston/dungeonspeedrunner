local assert, select, pairs, ipairs =
      assert, select, pairs, ipairs
local tsort = table.sort
local CreateFrame, GameTooltip = CreateFrame, GameTooltip

local addon = (select(2, ...))

local LSM = LibStub("LibSharedMedia-3.0")

local routeChoiceFrame = CreateFrame("Frame", "DungeonSpeedRunner_RouteChoice", UIParent)
routeChoiceFrame:SetFrameStrata("DIALOG")
addon:CreateBackdropTextures(routeChoiceFrame)
addon:SetBackdropTexture(routeChoiceFrame, LSM:Fetch("background", "Blizzard Dialog Background Gold"))
addon:SetBackdropInset(routeChoiceFrame, 4)
addon:SetBackdropBorderTexture(routeChoiceFrame, LSM:Fetch("border", "Blizzard Dialog Gold"))
addon:SetBackdropBorderWidth(routeChoiceFrame, 16)

routeChoiceFrame:SetPoint("CENTER", UIParent, "CENTER")
routeChoiceFrame:SetWidth(210)
routeChoiceFrame:Hide()

routeChoiceFrame:SetMovable(true)
routeChoiceFrame:EnableMouse(true)
routeChoiceFrame:RegisterForDrag("button1")
routeChoiceFrame:SetScript("OnDragStart", function() routeChoiceFrame:StartMoving() end)
routeChoiceFrame:SetScript("OnDragStop", function() routeChoiceFrame:StopMovingOrSizing() end)

local function buttonOnClick(btn)
    btn.currentRun:SetRoute(btn.routeLabel)
    routeChoiceFrame:CloseChoice()
end

local function buttonOnEnter(btn)
    GameTooltip:SetOwner(btn, "ANCHOR_CURSOR", 5, -5)
    GameTooltip:SetText(btn.routeData.name or "<unnamed>")
    GameTooltip:AddLine("Requires:", 1,1,1)
    for _,label in ipairs(btn.routeData.required) do
        GameTooltip:AddLine(" - "..btn.currentRun.instanceData.splits[label].uiName, 1,1,1)
    end
    GameTooltip:Show()
end

local function buttonOnLeave(btn)
    if GameTooltip:IsOwned(btn) then GameTooltip:Hide() end
end

routeChoiceFrame.frames = {}
function routeChoiceFrame:OfferChoice(currentRun, routes)
    tsort(routes)
    for i=1, #routes do
        local routeLabel = routes[i]
        local routeData = currentRun.instanceData.routes[routeLabel]
        assert(routeData)
        local frame = routeChoiceFrame.frames[i]
        if not frame then
            frame = CreateFrame("Button", nil, routeChoiceFrame, "UIPanelButtonTemplate")
            frame:SetPoint("TOP", routeChoiceFrame, "TOP", 0, - 11 - 23*(i-1))
            frame:SetSize(190, 20)
            frame:SetScript("OnClick", buttonOnClick)
            frame:SetScript("OnEnter", buttonOnEnter)
            frame:SetScript("OnLeave", buttonOnLeave)
            routeChoiceFrame.frames[i] = frame
        end
        frame.currentRun = currentRun
        frame.routeLabel = routeLabel
        frame.routeData = routeData
        frame:SetText(routeData.choiceName or routeData.name or "<unnamed>")
    end
    for i=#routes+1, #routeChoiceFrame.frames do
        routeChoiceFrame.frames[i]:Hide()
    end
    routeChoiceFrame:SetHeight(23*#routes + 20)
    routeChoiceFrame:Show()
end

function routeChoiceFrame:CloseChoice()
    routeChoiceFrame:StopMovingOrSizing()
    routeChoiceFrame:Hide()
end

addon.RouteChoice = routeChoiceFrame
