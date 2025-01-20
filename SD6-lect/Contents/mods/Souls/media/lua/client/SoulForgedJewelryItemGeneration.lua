local ItemGenerator = {}
local Config = require('SoulForgedJeweleryConfig')
local BuffSystem = require('SoulForgedJeweleryBuffs')

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

function ItemGenerator.getRandomAccessoryForSlots()
    local randomIndex = ZombRand(1, #Config.AccessorySlots + 1)
    local selectedSlot = Config.AccessorySlots[randomIndex]

    local allItems = getAllItems()
    local validItems = {}

    for i=0, allItems:size()-1 do
        local itemType = allItems:get(i)
        
        if itemType:getBodyLocation() == selectedSlot and not itemType:getFabricType() then
            table.insert(validItems, itemType:getFullName())
        end
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
    local newItemName = displayBuffName .. " Soul Forged " .. result:getName()
    
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

return ItemGenerator