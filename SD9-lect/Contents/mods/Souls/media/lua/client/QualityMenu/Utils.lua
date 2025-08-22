local Utils = {}
local Config = require("QualityMenu/Config")

function Utils.hasMdzPrefix(modData)
    local ok = modData and modData.mdzPrefix ~= nil and modData.mdzPrefix ~= ""
    return ok
end

function Utils.applyStatBonus(weapon, statKey, tierBonus)
    local modData = weapon:getModData()
    local mdzKey = "mdz" .. statKey
    local baseMult = modData[mdzKey] or 1.0

    if baseMult < 1.15 then
        modData[mdzKey] = math.min(1.15, baseMult + (tierBonus or 0))
		return true
	else
		return false
    end

end

function Utils.getForgeableWeapon(items)
	for i=1, #items do
		local entry = items[i]
        local item = entry and entry.items and entry.items[1]
        if item and instanceof(item, "HandWeapon") then
            local modData = item:getModData()
            if Utils.hasMdzPrefix(modData) then
                return item
            end
        end
    end
    return nil
end

function Utils.formatEnhancerBonus(modData, statKey)
    local mdzKey = "mdz" .. statKey
    local mult = modData[mdzKey] or 1.0
    local bonus = (mult - 1.0) * 100
    return string.format("+%.2f%%", bonus)
end

function Utils.getAllEnhancerStats(modData)
    local results = {}
    for statKey, _ in pairs(Config.statMap) do
        results[statKey] = Utils.formatEnhancerBonus(modData, statKey)
    end
    return results
end

function Utils.contains(tbl, val)
	for i=1, #tbl do
		local v = tbl[i]
        if v == val then return true end
    end
    return false
end

return Utils
