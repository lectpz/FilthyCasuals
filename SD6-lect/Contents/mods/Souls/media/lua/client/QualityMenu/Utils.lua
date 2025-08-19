local Utils = {}
local Config = require("QualityMenu/Config")

function Utils.hasMdzPrefix(modData)
    local ok = modData and modData.mdzPrefix ~= nil and modData.mdzPrefix ~= ""
    print(string.format("[Utils] hasMdzPrefix=%s (value=%s)", tostring(ok), tostring(modData and modData.mdzPrefix)))
    return ok
end

function Utils.applyStatBonus(weapon, statKey, tierBonus)
    local modData = weapon:getModData()
    local mdzKey = "mdz" .. statKey
    local baseMult = modData[mdzKey] or 1.0

    if baseMult <= 1.15 then
        print("[Utils] Mult has not hit cap. Adding more.")
        modData[mdzKey] = baseMult + (tierBonus or 0)
    else
        print(string.format("[Utils] Cap reached for %s (%.4f). Skipping add.", mdzKey, baseMult))
    end

    print(string.format("[WeaponAugment] Applied %.4f to %s → %s = %.4f", tierBonus, statKey, mdzKey, modData[mdzKey]))
end

function Utils.getForgeableWeapon(items)
    for _, entry in ipairs(items) do
        local item = entry and entry.items and entry.items[1]
        if item and instanceof(item, "HandWeapon") then
            local modData = item:getModData()
            if Utils.hasMdzPrefix(modData) then
                print(string.format("[Utils] Found mdz weapon: %s (mdzPrefix=%s)", item:getName(),
                    tostring(modData.mdzPrefix)))
                return item
            else
                print(string.format("[Utils] HandWeapon without mdzPrefix: %s", item:getName()))
            end
        end
    end
    print("[Utils] No mdz-prefixed weapon found in context")
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
