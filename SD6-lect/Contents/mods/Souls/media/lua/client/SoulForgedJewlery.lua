local soulForgeBuffWeights = {
    ["luck"] = 1,
    ["SoulSmith"] = 1,
    ["SoulThirst"] = 1,
    ["SoulStrength"] = 1,
    ["SoulDexterity"] = 1,
    ["MaxCondition"] = 1,
    ["ConditionLowerChance"] = 1,
    ["CritRate"] = 1,
    ["CritMulti"] = 1,
    ["MaxDmg"] = 1
}

local tierBuffs = {
    T1 = {"CritMulti", "SoulDexterity"},
    T2 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith"},
    T3 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition"},
    T4 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate"},
    T5 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate", "SoulStrength", "MaxDmg"}
}

local buffDisplayNames = {
    luck = "Luck",
    SoulSmith = "Soul Smith",
    SoulThirst = "Soul Thirst",
    SoulStrength = "Strength",
    SoulDexterity = "Dexterity",
    MaxCondition = "Durability",
    ConditionLowerChance = "Resilience",
    CritRate = "Critical Chance",
    CritMulti = "Critical Multiplier",
    MaxDmg = "Maximum Damage"
}

-- Utility functions
local function getTierNumber(item)
    return tonumber(string.match(item:getModData().Tier or "T1", "T(%d)")) or 1
end

local function getWeightedBuff(tier)
    local availableBuffs = tierBuffs[tier]
    local totalWeight = 0
    local buffWeights = {}

    for _, buff in ipairs(availableBuffs) do
        local weight = soulForgeBuffWeights[buff] or 0
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

function ApplyBaseItemProperties(result, baseItem, selectedBuff)
    if not baseItem then return end

    if baseItem:getTexture() then
        result:setTexture(baseItem:getTexture())
        if baseItem:getIconsForTexture() then
            result:setIconsForTexture(baseItem:getIconsForTexture())
        end
    end
    
    local displayBuffName = buffDisplayNames[selectedBuff] or selectedBuff
    local itemName = "Soul Forged " .. baseItem:getName() .. " of " .. displayBuffName

    result:setName(itemName)
end

-- Stat modifiers
local function modifyStrength(player, item, isEquipping)
    local strength = 1
    local currentBaseWeight = player:getMaxWeightBase()
    local pMD = player:getModData();
    
    if isEquipping then
        if not player:getModData().originalMaxWeightBase then
            player:getModData().originalMaxWeightBase = currentBaseWeight
        end
        player:getModData().PermaSoulForgeStrengthBonus = (player:getModData().PermaSoulForgeStrengthBonus or 0) + strength
    else
        player:getModData().PermaSoulForgeStrengthBonus = (player:getModData().PermaSoulForgeStrengthBonus or 0) - strength
    end
    
    local originalWeight = player:getModData().originalMaxWeightBase or currentBaseWeight
    local newWeight = originalWeight + player:getModData().PermaSoulForgeStrengthBonus

    player:setMaxWeightBase(newWeight)
end

local function modifyDexterity(player, item, isEquipping)
    local tier = getTierNumber(item)
    local dexterityBonus = 0.05 * tier -- 10% faster transfer speed per tier
    local pMD = player:getModData()
        
    if isEquipping then
        pMD.PermaSoulForgeDexterityBonus = (pMD.PermaSoulForgeDexterityBonus or 0) + dexterityBonus
    else
        pMD.PermaSoulForgeDexterityBonus = (pMD.PermaSoulForgeDexterityBonus or 0) - dexterityBonus
    end
end

local function modifySoulSmith(player, item, isEquipping)
    local tier = getTierNumber(item)
    local soulSmithBonus = 5 * tier -- 5% per tier
    local pMD = player:getModData();
    
    if isEquipping then
        pMD.PermaSoulSmithValue = (pMD.PermaSoulSmithValue or 0) + soulSmithBonus
    else
        pMD.PermaSoulSmithValue = (pMD.PermaSoulSmithValue or 0) - soulSmithBonus
    end
end

local function modifySoulThirst(player, item, isEquipping)
    local tier = getTierNumber(item) or 1
    local soulThirstBonus = 0.1 * tier
    local pMD = player:getModData();
    
    if isEquipping then
        pMD.PermaSoulThirstValue = (pMD.PermaSoulThirstValue or 0) + soulThirstBonus
    else
        pMD.PermaSoulThirstValue = (pMD.PermaSoulThirstValue or 0) - soulThirstBonus
    end
end

local function modifyMaxCondition(player, item, isEquipping)
    local tier = getTierNumber(item)
    local maxConditionBonus = math.ceil(0.5 * tier)
    local pMD = player:getModData();
    
    if isEquipping then
        pMD.PermaMaxConditionBonus = (pMD.PermaMaxConditionBonus or 0) + maxConditionBonus
    else
        pMD.PermaMaxConditionBonus = (pMD.PermaMaxConditionBonus or 0) - maxConditionBonus
    end
end

local function modifyLuck(player, item, isEquipping)
    local tier = getTierNumber(item)
    local luckBonus = 10 * tier
    local pMD = player:getModData()
    
    if isEquipping then
        pMD.PermaSoulForgeLuckBonus = (pMD.PermaSoulForgeLuckBonus or 0) + luckBonus
    else
        pMD.PermaSoulForgeLuckBonus = (pMD.PermaSoulForgeLuckBonus or 0) - luckBonus
    end
end

local function modifyConditionLowerChance(player, item, isEquipping)
    local conditionBonus = 2
    local pMD = player:getModData()
    
    if isEquipping then
        pMD.PermaSoulForgeConditionBonus = (pMD.PermaSoulForgeConditionBonus or 0) + conditionBonus
    else
        pMD.PermaSoulForgeConditionBonus = (pMD.PermaSoulForgeConditionBonus or 0) - conditionBonus
    end
end

local function modifyCritRate(player, item, isEquipping)
    local tier = getTierNumber(item)
    local critRateBonus = 0.02 * tier
    local pMD = player:getModData()
    
    if isEquipping then
        pMD.PermaSoulForgeCritRateBonus = (pMD.PermaSoulForgeCritRateBonus or 0) + critRateBonus
    else
        pMD.PermaSoulForgeCritRateBonus = (pMD.PermaSoulForgeCritRateBonus or 0) - critRateBonus
    end
end

local function modifyCritMulti(player, item, isEquipping)
    local tier = getTierNumber(item)
    local critMultiBonus = 0.1 * tier
    local pMD = player:getModData()
    
    if isEquipping then
        pMD.PermaSoulForgeCritMultiBonus = (pMD.PermaSoulForgeCritMultiBonus or 0) + critMultiBonus
    else
        pMD.PermaSoulForgeCritMultiBonus = (pMD.PermaSoulForgeCritMultiBonus or 0) - critMultiBonus
    end
end

local function modifyMaxDmg(player, item, isEquipping)
    local tier = getTierNumber(item)
    local damageBonus = 0.05 * tier
    local pMD = player:getModData()
    
    if isEquipping then
        pMD.PermaSoulForgeMaxDmgBonus = (pMD.PermaSoulForgeMaxDmgBonus or 0) + damageBonus
    else
        pMD.PermaSoulForgeMaxDmgBonus = (pMD.PermaSoulForgeMaxDmgBonus or 0) - damageBonus
    end
end

-- Event watchers
function SoulForgedJewelryOnCreate(items, result, player)
    if not result then return end
    if not items then return end
    
    local tier = 1
    for i=0, items:size()-1 do
        local itemType = items:get(i):getFullType()
        if itemType == "SoulForge.SoulShardT5" then 
            tier = 5
            break
        elseif itemType == "SoulForge.SoulShardT4" then 
            tier = 4
        elseif itemType == "SoulForge.SoulShardT3" then 
            tier = 3
        elseif itemType == "SoulForge.SoulShardT2" then 
            tier = 2
        end
    end
    
    local selectedBuff = getWeightedBuff("T" .. tier)
    
    local resultBodyLocation = result:getBodyLocation()
    
    local allItems = getAllItems()
    local validItems = {}
    
    for i=0, allItems:size()-1 do
        local itemType = allItems:get(i)
        if string.find(itemType:getBodyLocation(), resultBodyLocation) then
            table.insert(validItems, itemType:getFullName())
        end
    end
    
    if #validItems > 0 then
        local randomIndex = ZombRand(1, #validItems + 1)
        local selectedJewelry = validItems[randomIndex]
        
        local tempItem = InventoryItemFactory.CreateItem(selectedJewelry)
        if tempItem then
            result:getModData().BaseItem = selectedJewelry
            result:getModData().SoulBuff = selectedBuff
            result:getModData().Tier = tier
            
            ApplyBaseItemProperties(result, tempItem, selectedBuff)
        end
    end
end

local function OnClothingUpdated(player)
    
    local buffHandlers = {
        SoulStrength = modifyStrength,
        SoulDexterity = modifyDexterity,
        SoulSmith = modifySoulSmith,
        SoulThirst = modifySoulThirst,
        MaxCondition = modifyMaxCondition,
        luck = modifyLuck,
        ConditionLowerChance = modifyConditionLowerChance,
        CritRate = modifyCritRate,
        CritMulti = modifyCritMulti,
        MaxDmg = modifyMaxDmg
    }

    local inventory = player:getInventory()
    local equipped = inventory:getItems()
    
    if not player:getModData().originalMaxWeightBase then
        player:getModData().originalMaxWeightBase = player:getMaxWeightBase()
    end
    
    player:setMaxWeightBase(player:getModData().originalMaxWeightBase)
    player:getModData().PermaSoulForgeStrengthBonus = 0
    player:getModData().PermaSoulSmithValue = 0
    player:getModData().PermaSoulThirstValue = 0
    player:getModData().PermaSoulForgeDexterityBonus = 0
    player:getModData().PermaSoulForgeLuckBonus = 0
    player:getModData().PermaSoulForgeConditionBonus = 0
    player:getModData().PermaSoulForgeCritRateBonus = 0
    player:getModData().PermaSoulForgeCritMultiBonus = 0
    player:getModData().PermaSoulForgeMaxDmgBonus = 0

    for i = 0, equipped:size()-1 do
        local item = equipped:get(i)
        
        if string.find(item:getFullType(), "SoulForged") and item:isEquipped() then
            local buff = item:getModData().SoulBuff

            if buff and buffHandlers[buff] then
                buffHandlers[buff](player, item, true)
            end
        end
    end
end


local function SoulForgedJewelryOnLoad(item)
    if not item then return end
    
    local modData = item:getModData()
    if modData.BaseItem then
        local baseItem = InventoryItemFactory.CreateItem(modData.BaseItem)
        if baseItem then
            ApplyBaseItemProperties(item, baseItem, modData.SoulBuff)
        end
    end
end

-- Overwrites
local original_new = ISInventoryTransferAction.new

function ISInventoryTransferAction:new(character, item, srcContainer, destContainer, time)
    local o = original_new(self, character, item, srcContainer, destContainer, time)
    local dexterityBonus = character:getModData().PermaSoulForgeDexterityBonus or 0
    
    if o and dexterityBonus > 0 then
        o.maxTime = o.maxTime - (o.maxTime * dexterityBonus);
    end
    
    return o
end

Events.OnClothingUpdated.Add(OnClothingUpdated)
Events.OnGameStart.Add(function()
    OnClothingUpdated(getPlayer())
end)
