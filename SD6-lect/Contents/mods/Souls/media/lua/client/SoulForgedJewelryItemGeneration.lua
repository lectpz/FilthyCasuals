local ItemGenerator = {}
local Config = require('SoulForgedJewelryConfig')
local BuffSystem = require('SoulForgedJewelryBuffs')

function ItemGenerator.findUnmodifiedSoulBuffJewlery(inventory, itemType)
    local items = inventory:getItems()
    for i=0, items:size()-1 do
        local item = items:get(i)
        if not item:getModData().SoulBuff and item:getFullType() == itemType then
            return item
        end
    end
    return nil
end

Config.AccessoryBlacklist = {
    "Base.SpookySuit",
    "SWSuits.MaskFeelsGoodMan",
    "SWSuits.SuitFeelsGoodMan"
}

function ItemGenerator.getValidItems(checkAllSlots)
    local validItems = {}
    
    local slotsToCheck = checkAllSlots and Config.AccessorySlots or {Config.AccessorySlots[ZombRand(1, #Config.AccessorySlots + 1)]}

    local allItems = getAllItems()

    for i=0, allItems:size()-1 do
        local itemType = allItems:get(i)
        local fullName = itemType:getFullName()
        
        local isBlacklisted = false
        for _, blacklistedItem in ipairs(Config.AccessoryBlacklist) do
            if fullName == blacklistedItem then
                isBlacklisted = true
                break
            end
        end
        
        local validSlot = false
        for _, slot in ipairs(slotsToCheck) do
            if itemType:getBodyLocation() == slot then
                validSlot = true
                break
            end
        end
        
        if validSlot 
            and not itemType:getFabricType()
            and not string.find(string.lower(itemType:getDisplayName()), "kp")
            and not isBlacklisted then
            table.insert(validItems, fullName)
        end
    end

    if #validItems == 0 then
        return nil
    end

    return validItems
end

function ItemGenerator.getRandomAccessoryForSlots()
    local validItems = ItemGenerator.getValidItems(false)

    return validItems[ZombRand(1, #validItems + 1)]
end

function ItemGenerator.SetResultName(result)
    if not result then return end
    local modData = result:getModData()
    local buffs = modData.SoulBuffs or {modData.SoulBuff}
    if not buffs or #buffs == 0 then return end
    
    local currentName = result:getName()
    local baseItemName = currentName:match("Soul Forged (.+)$") or currentName
    
    local displayBuffNames = {}
    local showTier = true
    
    for _, buff in ipairs(buffs) do
        if buff then
            local buffCalc = BuffSystem.BUFF_CALCULATIONS[buff]
            if buffCalc and buffCalc.hasTier == false then
                showTier = false
            end
            local displayName = Config.buffDisplayNames[buff] or buff
            table.insert(displayBuffNames, displayName)
        end
    end
    
    if #displayBuffNames == 0 then return end
    
    local combinedBuffName
    if #displayBuffNames == 1 then
        combinedBuffName = displayBuffNames[1]
    else
        combinedBuffName = table.concat(displayBuffNames, "/")
    end
    
    local newItemName
    if showTier then
        newItemName = "[T" .. modData.Tier .."] " .. combinedBuffName .. " Soul Forged " .. baseItemName
    else
        newItemName = combinedBuffName .. " Soul Forged " .. baseItemName
    end
    
    if currentName ~= newItemName then
        result:setName(newItemName)
    end
end

function ItemGenerator.getTierSoulShard()
    local tier = checkZone()
	tier = math.min(6, tier)
    local items = ArrayList.new()
    
    local soulShard = InventoryItemFactory.CreateItem("SoulForge.SoulShardT" .. tier)
    if soulShard then
        items:add(soulShard)
    end
    
    return items
end

function ItemGenerator.getTierSoulShardExplicit(tier)
    local items = ArrayList.new()
    
    local soulShard = InventoryItemFactory.CreateItem("SoulForge.SoulShardT" .. tier)
    if soulShard then
        items:add(soulShard)
    end
    
    return items
end

return ItemGenerator