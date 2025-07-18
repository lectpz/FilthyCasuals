local Utils = {}
local Config = require("QualityMenu/Config")

function Utils.applyStatBonus(weapon, statKey, tierBonus)
    local modData = weapon:getModData()
    local mdzKey = "mdz" .. statKey
    local baseMult = modData[mdzKey] or 1.0
    modData[mdzKey] = baseMult + (tierBonus or 0)

    print(string.format("[WeaponAugment] Applied %.4f to %s → %s = %.4f", tierBonus, statKey, mdzKey, modData[mdzKey]))
end

function Utils.getForgeableWeapon(items)
    for _, entry in ipairs(items) do
        local item = entry and entry.items and entry.items[1]
        if item and instanceof(item, "HandWeapon") then
            local modData = item:getModData()
            if modData and modData.IsSoulForged then
                print("[Utils] Found SoulForged weapon:", item:getName())
                return item
            end
        end
    end
    print("[Utils] No valid SoulForged weapon found in context")
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
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

return Utils
