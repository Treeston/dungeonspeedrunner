local addon = (select(2,...))

local tinsert, tremove, twipe = table.insert, table.remove, table.wipe

local pool = {}
local function getfrompool()
    if #pool > 0 then
        return table.remove(pool)
    else
        return {}
    end
end
function addon.gettable(...)
    local t = getfrompool()
    for i=1,select('#',...) do
		t[i] = (select(i,...))
	end
    return t
end

function addon.freetable(t)
    twipe(t)
    tinsert(pool,t)
end
