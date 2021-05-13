local addon = (select(2,...))

addon.EXCLUDE_TOP = 0x1
addon.EXCLUDE_LEFT = 0x2
addon.EXCLUDE_RIGHT = 0x4
addon.EXCLUDE_BOTTOM = 0x8

local pairs = pairs
local tinsert, band = table.insert, bit.band

function addon:CreateBackdropTextures(f, sides)
    sides = sides or 0
    local hasTop = (band(addon.EXCLUDE_TOP, sides) == 0)
    local hasLeft = (band(addon.EXCLUDE_LEFT, sides) == 0)
    local hasRight = (band(addon.EXCLUDE_RIGHT, sides) == 0)
    local hasBottom = (band(addon.EXCLUDE_BOTTOM, sides) == 0)
    
    f.backdrop = f:CreateTexture(nil, "BACKGROUND")
    f.backdrop:SetVertTile(true)
    f.borders = {}
    if hasLeft then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(0,.125,0,1)
        f.borders.LEFT = b
    end
    if hasRight then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.125,.25,0,1)
        f.borders.RIGHT = b
    end
    if hasTop then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.25,1,.375,1,.25,0,.375,0)
        f.borders.TOP = b
    end
    if hasBottom then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.375,1,.5,1,.375,0,.5,0)
        b:SetPoint("BOTTOMLEFT", hasLeft and 1 or 0, 0)
        b:SetPoint("BOTTOMRIGHT", hasRight and -1 or 0, 0)
        f.borders.BOTTOM = b
    end
    if hasTop and hasLeft then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.5,.625,0,1)
        b:SetPoint("TOPLEFT")
        f.borders.TOPLEFT = b
    end
    if hasTop and hasRight then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.625,.75,0,1)
        b:SetPoint("TOPRIGHT")
        f.borders.TOPRIGHT = b
    end
    if hasBottom and hasLeft then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.75,.875,0,1)
        b:SetPoint("BOTTOMLEFT")
        f.borders.BOTTOMLEFT = b
    end
    if hasBottom and hasRight then
        local b = f:CreateTexture(nil, "BORDER")
        b:SetTexCoord(.875,1,0,1)
        b:SetPoint("BOTTOMRIGHT")
        f.borders.BOTTOMRIGHT = b
    end
end

function addon:SetBackdropTexture(f, texture)
    f.backdrop:SetTexture(texture, true)
end

function addon:SetBackdropInset(f, inset)
    local hasLeft = not not f.borders.LEFT
    local hasRight = not not f.borders.RIGHT
    local hasTop = not not f.borders.TOP
    local hasBottom = not not f.borders.BOTTOM
    
    f.backdrop:SetPoint("TOPLEFT", hasLeft and inset or 0, hasTop and -inset or 0)
    f.backdrop:SetPoint("BOTTOMRIGHT", hasRight and -inset or 0, hasBottom and inset or 0)
end

function addon:SetBackdropBorderTexture(f, texture)
    for _,t in pairs(f.borders) do t:SetTexture(texture, true) end
end

function addon:SetBackdropBorderWidth(f, width)
    local hasLeft = not not f.borders.LEFT
    local hasRight = not not f.borders.RIGHT
    local hasTop = not not f.borders.TOP
    local hasBottom = not not f.borders.BOTTOM
    
    if hasLeft then
        local b = f.borders.LEFT
        b:SetPoint("TOPLEFT", 0, hasTop and -width or 0)
        b:SetPoint("BOTTOMLEFT", 0, hasBottom and width or 0)
        b:SetWidth(width)
    end
    if hasRight then
        local b = f.borders.RIGHT
        b:SetPoint("TOPRIGHT", 0, hasTop and -width or 0)
        b:SetPoint("BOTTOMRIGHT", 0, hasBottom and width or 0)
        b:SetWidth(width)
    end
    if hasTop then
        local b = f.borders.TOP
        b:SetPoint("TOPLEFT", hasLeft and width or 0, 0)
        b:SetPoint("TOPRIGHT", hasRight and -width or 0, 0)
        b:SetHeight(width)
    end
    if hasBottom then
        local b = f.borders.BOTTOM
        b:SetPoint("BOTTOMLEFT", hasLeft and width or 0, 0)
        b:SetPoint("BOTTOMRIGHT", hasRight and -width or 0, 0)
        b:SetHeight(width)
    end
    if hasTop and hasLeft then
        f.borders.TOPLEFT:SetSize(width, width)
    end
    if hasTop and hasRight then
        f.borders.TOPRIGHT:SetSize(width, width)
    end
    if hasBottom and hasLeft then
        f.borders.BOTTOMLEFT:SetSize(width, width)
    end
    if hasBottom and hasRight then
        f.borders.BOTTOMRIGHT:SetSize(width, width)
    end
end

local __timer_formatstring1 = "%02d:%05.2f"
local __timer_formatstring2 = "%02d:%02d:%02d"
function addon:FormatTimerString(elapsed, longFormat)
    if not elapsed then return "" end
    if not longFormat then
        return __timer_formatstring1:format(floor(elapsed/60), elapsed%60)
    else
        return __timer_formatstring2:format(floor(elapsed/3600), floor((elapsed%3600)/60), elapsed%60)
    end
end

local __offset_formatstring1 = "%+02dh%02dm"
local __offset_formatstring2 = "%+02d:%02d"
local __offset_formatstring3 = "%+05.2f"
function addon:FormatChangeString(offset, longFormat)
    if offset == 0 then return "±0.00" end
    if not longFormat then
        return __offset_formatstring3:format(offset)
    end
    local absOffset = abs(offset)
    local sgn = (offset/absOffset)
    if 6000 <= absOffset then
        return __offset_formatstring1:format(sgn*floor(absOffset/3600), floor((absOffset%3600)/60))
    else
        return __offset_formatstring2:format(sgn*floor(absOffset/60), floor(absOffset%60))
    end
end
