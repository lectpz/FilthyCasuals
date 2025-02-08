local BuffSystem = {}
local Config = require('SoulForgedJewelryConfig')

BuffSystem.BUFF_CALCULATIONS = {
    SoulStrength = {
        format = "Strengther",
        getDisplayValue = function(tier) return 1 end,
        getBonus = function(tier) return 1 end,
        modData = "PermaSoulForgeStrengthBonus",
        apply = function(player, value, isEquipping)
            player:setMaxWeightBase(player:getMaxWeightBase() + (player:getModData().PermaSoulForgeStrengthBonus or 0))
        end
    },
    luck = {
        format = "Luck",
        getDisplayValue = function(tier) return 1.5 * tier end,
        getBonus = function(tier) return 1.5 * tier end,
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
        getDisplayValue = function(tier) return .4 * tier end,
        getBonus = function(tier) return 0.4 * tier end,
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
        getDisplayValue = function(tier) return 1*1.5 * tier end,
        getBonus = function(tier) return (0.01*1.5 * tier) end,
        modData = "PermaSoulForgeCritRateBonus",
        defaultValue = 1
    },
    CritMulti = {
        format = "Crit Multiplier",
        getDisplayValue = function(tier) return 2 * tier end,
        getBonus = function(tier) return (0.02 * tier) end,
        modData = "PermaSoulForgeCritMultiBonus",
        defaultValue = 1
    },
    MaxDmg = {
        format = "Maximum Damage",
        getDisplayValue = function(tier) return .5*2 * tier end,
        getBonus = function(tier) return (0.005*2 * tier) end,
        modData = "PermaSoulForgeMaxDmgBonus",
        defaultValue = 1
    },
    SoulSmith = {
        format = "Soul Smith Bonus",
        getDisplayValue = function(tier) return 1 * tier end,
        getBonus = function(tier) return (.01 * tier) end,
        modData = "PermaSoulSmithValue",
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

function BuffSystem.modifyBuff(player, item, isEquipping, buffType)
    local buff = BuffSystem.BUFF_CALCULATIONS[buffType]
    if not buff then return end
    
    local tier = BuffSystem.getTierNumber(item)
    local value = buff.getBonus(tier)
    local pMD = player:getModData()
    
    if isEquipping then
        pMD[buff.modData] = (pMD[buff.modData] or 0) + value
    else
        pMD[buff.modData] = (pMD[buff.modData] or 0) - value
    end
    
    if buff.apply then
        buff.apply(player, value, isEquipping)
    end
end

return BuffSystem