local BuffSystem = {}
local Config = require('SoulForgedJewelryConfig')

BuffSystem.BUFF_CALCULATIONS = {
    SoulStrength = {
        format = "Strengther",
        getDisplayValue = function(tier) return 1 end,
        getBonus = function(tier) return 1 end,
        modData = "PermaSoulForgeStrengthBonus",
        apply = function(player, value, isEquipping)
            local pMD = player:getModData()
            local faction = pMD.faction
            --COGbuff = pMD.WeaponCOGbuff or 0
            local handItem = player:getPrimaryHandItem()
            local COGbuff = 0
            if handItem and handItem:getModData().suffix2 == "COG" then
                if faction == "COG" then COGbuff = 3 else COGbuff = 1 end
            end
            player:setMaxWeightBase(player:getMaxWeightBase() + ( (pMD.PermaSoulForgeStrengthBonus + COGbuff) or (0+COGbuff) ))
        end,
        maxValue = 13,
        hasTier = false
    },
    luck = {
        format = "Luck",
        getDisplayValue = function(tier) return 1.25 * tier end,
        getBonus = function(tier) return 1.25 * tier end,
        modData = "PermaSoulForgeLuckBonus"
    },
    SoulDexterity = {
        format = "Transfer Speed",
        getDisplayValue = function(tier) return 1.6 * tier end,
        getBonus = function(tier) return 0.016 * tier end,
        modData = "PermaSoulForgeDexterityBonus"
    },
    SoulThirst = {
        format = "Soul Thirst Bonus",
        getDisplayValue = function(tier) return .6 * tier end,
        getBonus = function(tier) return 0.6 * tier end,
        modData = "PermaSoulThirstValue"
    },
    MaxCondition = {
        format = "Durability",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (0.01 * tier) end,
        modData = "PermaMaxConditionBonus",
        defaultValue = 1
    },
    ConditionLowerChance = {
        format = "Condition Resilience",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (0.01 * tier) end,
        modData = "PermaSoulForgeConditionBonus",
        defaultValue = 1
    },
    CritRate = {
        format = "Crit Chance",
        getDisplayValue = function(tier) return 1.25 * tier end,
        getBonus = function(tier) return (0.0125 * tier) end,
        modData = "PermaSoulForgeCritRateBonus",
        defaultValue = 1
    },
    CritMulti = {
        format = "Crit Multiplier",
        getDisplayValue = function(tier) return 1.5 * tier end,
        getBonus = function(tier) return (0.015 * tier) end,
        modData = "PermaSoulForgeCritMultiBonus",
        defaultValue = 1
    },
    MaxDmg = {
        format = "Maximum Damage",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (0.01 * tier) end,
        modData = "PermaSoulForgeMaxDmgBonus",
        defaultValue = 1
    },
    SoulSmith = {
        format = "Soul Smith Bonus",
        getDisplayValue = function(tier) return 0.03 * tier end,
        getBonus = function(tier) return (.03 * tier) end,
        modData = "PermaSoulSmithValue",
    },
    Aiming = {
        format = "Aiming Speed Bonus",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (.01 * tier) end,
        modData = "PermaAiming",
        defaultValue = 1
    },
    Reloading = {
        format = "Reloading Speed Bonus",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (.01 * tier) end,
        modData = "PermaReloading",
    },
    Recoil = {
        format = "Recoil Reduction Bonus",
        getDisplayValue = function(tier) return 0.4 * tier end,
        getBonus = function(tier) return (.004 * tier) end,
        modData = "PermaRecoil",
    },
 }

function BuffSystem.getTierNumber(item)
    local modData = item:getModData()
    
    if not modData.Tier then 
        print("getTierNumber: modData.Tier is nil")
        return 1 
    end
 
    if type(modData.Tier) == "number" then
        return modData.Tier
    end
    
    local tierMatch = string.match(modData.Tier, "T(%d)")
    return tonumber(tierMatch) or 1
end

-- Get tier for a specific buff (supports individual buff tiers)
function BuffSystem.getBuffTier(item, buffType)
    local modData = item:getModData()
    
    -- Check if individual buff tiers are defined
    if modData.SoulBuffTiers and modData.SoulBuffTiers[buffType] then
        return modData.SoulBuffTiers[buffType]
    end
    
    -- Fall back to item tier for single buff items or items without individual tiers
    return BuffSystem.getTierNumber(item)
end

-- Set tier for a specific buff
function BuffSystem.setBuffTier(item, buffType, tier)
    local modData = item:getModData()
    
    -- Initialize SoulBuffTiers if it doesn't exist
    if not modData.SoulBuffTiers then
        modData.SoulBuffTiers = {}
    end
    
    modData.SoulBuffTiers[buffType] = tier
end

function BuffSystem.getWeightedBuff(tier)
    local availableBuffs = Config.tierBuffs[tier]
    local totalWeight = 0
    local buffWeights = {}
 
    for _, buff in ipairs(availableBuffs) do
        local weight = Config.soulForgeBuffWeights[buff] or 0
        totalWeight = totalWeight + weight
        table.insert(buffWeights, {
            buff = buff,
            weight = weight
        })
    end
 
    local roll = ZombRand(totalWeight)
    local currentWeight = 0
 
    for _, buffData in ipairs(buffWeights) do
        currentWeight = currentWeight + buffData.weight
        if roll < currentWeight then
            return buffData.buff
        end
    end
 
    return buffWeights[1].buff
end

function BuffSystem.getMultipleWeightedBuffs(tier, count)
    local selectedBuffs = {}
    local availableBuffs = {}
    
    for _, buff in ipairs(Config.tierBuffs[tier]) do
        table.insert(availableBuffs, buff)
    end
    
    for i = 1, count do
        if #availableBuffs == 0 then break end
        
        local totalWeight = 0
        local buffWeights = {}
        
        for _, buff in ipairs(availableBuffs) do
            local weight = Config.soulForgeBuffWeights[buff] or 0
            totalWeight = totalWeight + weight
            table.insert(buffWeights, {
                buff = buff,
                weight = weight
            })
        end
        
        local roll = ZombRand(totalWeight)
        local currentWeight = 0
        local selectedBuff = nil
        local selectedIndex = nil
        
        for idx, buffData in ipairs(buffWeights) do
            currentWeight = currentWeight + buffData.weight
            if roll < currentWeight then
                selectedBuff = buffData.buff
                selectedIndex = idx
                break
            end
        end
        
        if selectedBuff then
            table.insert(selectedBuffs, selectedBuff)
            for j = #availableBuffs, 1, -1 do
                if availableBuffs[j] == selectedBuff then
                    table.remove(availableBuffs, j)
                    break
                end
            end
        end
    end
    
    return selectedBuffs
end

function BuffSystem.modifyBuff(player, item, isEquipping, buffType)
    local buff = BuffSystem.BUFF_CALCULATIONS[buffType]
    if not buff then return end
    
    local tier = BuffSystem.getBuffTier(item, buffType) -- Use individual buff tier
    local value = buff.getBonus(tier)
    local pMD = player:getModData()
    
    if isEquipping then
        local newValue = (pMD[buff.modData] or 0) + value
        if buff.maxValue then
            newValue = math.min(newValue, buff.maxValue)
        end
        pMD[buff.modData] = newValue
    else
        pMD[buff.modData] = math.max((pMD[buff.modData] or 0) - value, 0)
    end
    
end

function BuffSystem.modifyMultipleBuffs(player, item, isEquipping)
    local modData = item:getModData()
    local buffs = modData.SoulBuffs
    
    if not buffs then return end
    
    for _, buffType in ipairs(buffs) do
        if buffType then
            BuffSystem.modifyBuff(player, item, isEquipping, buffType)
        end
    end
end

return BuffSystem
