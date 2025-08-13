local Utils = {}
local Config = require("QualityMenu/Config")

function Utils.applyStatBonus(weapon, statKey, tierBonus)
    local modData = weapon:getModData()
    local mdzKey = "mdz" .. statKey
    local baseMult = modData[mdzKey] or 1.0

    local newMult = baseMult + (tierBonus or 0)
    if newMult > 1.15 then
        print(string.format("[Utils] Clamp %s from %.4f to 1.1500", mdzKey, newMult))
        newMult = 1.15
    end

    if newMult <= baseMult then
        print(string.format("[Utils] No-op for %s (base=%.4f, bonus=%.4f)", mdzKey, baseMult, tierBonus or 0))
        return
    end

    modData[mdzKey] = newMult
    print(string.format("[WeaponAugment] Applied %.4f to %s → %s = %.4f", tierBonus or 0, statKey, mdzKey,
        modData[mdzKey]))
end

local function _s(x) return tostring(x) end
local function _getFullType(item)
    local ok, ft = pcall(function() return item:getFullType() end)
    return ok and ft or ""
end

function Utils.isHandWeapon(item)
    local isHW = item and instanceof(item, "HandWeapon") or false
    print(string.format("[Utils][isHandWeapon] %s -> %s", _s(item and item:getName() or "nil"), _s(isHW)))
    return isHW
end

function Utils.isFromModule(item, moduleName)
    local ft = _getFullType(item)
    local match = (type(ft) == "string") and string.match(ft, "^" .. moduleName .. "%.") ~= nil
    print(string.format("[Utils][isFromModule] %s -> fullType=%s module=%s match=%s",
        _s(item and item:getName() or "nil"), ft, moduleName, _s(match)))
    return match
end

function Utils.debugPrintHeldWeapon(playerIndex)
    local p = getSpecificPlayer(playerIndex)
    if not p then
        print("[Utils] No player found for index:", tostring(playerIndex)); return
    end
    local held = p:getPrimaryHandItem()
    if held then
        print("[Utils] Held:", held:getName(), "| FullType:", held:getFullType())
    else
        print("[Utils] Held: none")
    end
end

function Utils.getForgeableWeapon(items, opts)
    opts = opts or {}
    local targetModule = opts.module or "RMWeapons"

    print(string.format("[Utils][getForgeableWeapon] start module=%s", tostring(targetModule)))

    for idx, entry in ipairs(items) do
        local item = entry and entry.items and entry.items[1]
        if not item then
            print(string.format("[Utils][getForgeableWeapon] idx=%d -> skip: no item", idx))
        else
            local name = tostring(item:getName())
            local ft = item:getFullType() or ""
            print(string.format("[Utils][getForgeableWeapon] idx=%d name=%s fullType=%s", idx, name, ft))

            if not Utils.isHandWeapon(item) then
                print(string.format("[Utils][getForgeableWeapon] idx=%d -> reject: not HandWeapon", idx))
            elseif not Utils.isFromModule(item, targetModule) then
                print(string.format("[Utils][getForgeableWeapon] idx=%d -> reject: wrong module", idx))
            else
                print(string.format("[Utils][getForgeableWeapon] idx=%d -> ACCEPT %s", idx, name))
                return item
            end
        end
    end

    print("[Utils][getForgeableWeapon] No matching weapon found in context")
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
