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

function Utils.getForgeableWeapon(player, opts)
    opts = opts or {}
    local targetModule = opts.module or "RMWeapons"
    print(string.format("[Utils][getForgeableWeapon] start (primary hand) module=%s", tostring(targetModule)))

    local playerObj = player
    if type(player) ~= "userdata" then
        playerObj = getSpecificPlayer(tonumber(player) or 0)
    end
    if not playerObj then
        print("[Utils][getForgeableWeapon] reject: no playerObj")
        return nil
    end

    local item = playerObj:getPrimaryHandItem()
    if not item then
        print("[Utils][getForgeableWeapon] reject: no primary-hand item")
        return nil
    end

    local name = tostring(item:getName())
    local ft = (_getFullType and _getFullType(item)) or (item.getFullType and item:getFullType()) or ""
    print(string.format("[Utils][getForgeableWeapon] held=%s fullType=%s", name, ft))

    if not Utils.isHandWeapon(item) then
        print("[Utils][getForgeableWeapon] reject: not HandWeapon")
        return nil
    end
    if not Utils.isFromModule(item, targetModule) then
        print("[Utils][getForgeableWeapon] reject: wrong module")
        return nil
    end

    print(string.format("[Utils][getForgeableWeapon] ACCEPT %s", name))
    return item
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
