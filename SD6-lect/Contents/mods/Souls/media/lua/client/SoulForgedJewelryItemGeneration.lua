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

function ItemGenerator.getRandomAccessoryForSlots()
    local randomIndex = ZombRand(1, #Config.AccessorySlots + 1)
    local selectedSlot = Config.AccessorySlots[randomIndex]

    local allItems = getAllItems()
    local validItems = {}

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
        
        if itemType:getBodyLocation() == selectedSlot 
            and not itemType:getFabricType()
            and not string.find(string.lower(itemType:getDisplayName()), "kp")
            and not isBlacklisted then
            table.insert(validItems, fullName)
        end
    end

    if #validItems == 0 then
        return nil
    end

    return validItems[ZombRand(1, #validItems + 1)]
end

function ItemGenerator.SetResultName(result)
    if not result then return end
    local modData = result:getModData()
    local selectedBuff = modData.SoulBuff
    if not selectedBuff then return end
    
    if result:getName():find("Soul Forged") then return end
    
    local displayBuffName = Config.buffDisplayNames[selectedBuff] or selectedBuff
    local newItemName = "[T" .. modData.Tier .."] " .. displayBuffName .. " Soul Forged " .. result:getName()
    
    if result:getName() ~= newItemName then
        result:setName(newItemName)
    end
end

function ItemGenerator.getTierSoulShard()
    local tier = checkZone()
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