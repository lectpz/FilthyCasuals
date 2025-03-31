local EventHandlers = {}
local Config = require('SoulForgedJewelryConfig')
local BuffSystem = require('SoulForgedJewelryBuffs')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')

function EventHandlers.OnTest_CheckInInventory(item)
    local player = getSpecificPlayer(0)

    local isOwnSafeHouse = SafeHouse.hasSafehouse(player)
    local x = player:getX()
    local y = player:getY()

    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX()
        local shy1 = isOwnSafeHouse:getY()-15
        local shx2 = isOwnSafeHouse:getW() + shx1
        local shy2 = isOwnSafeHouse:getH() + shy1

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
            return true
        end
    end
    
    if not item:isInPlayerInventory() then return false end

    return true
end

function EventHandlers.SoulForgedJewelryOnCreate(items, result, player)
    if not items then return end
    
    local rolledItem = ItemGenerator.getRandomAccessoryForSlots()
    local inventory = player:getInventory()
    inventory:AddItems(rolledItem, 1)

    local createdItem = ItemGenerator.findUnmodifiedSoulBuffJewlery(inventory, rolledItem)
    createdItem:setDisplayCategory('SoulForge')

    if createdItem then
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
        
        local selectedBuff = BuffSystem.getWeightedBuff("T" .. tier)

        createdItem:getModData().SoulBuff = selectedBuff
        createdItem:getModData().Tier = tier
        createdItem:setDisplayCategory('SoulForge')
        
        ItemGenerator.SetResultName(createdItem)
    end
end

function EventHandlers.OnClothingUpdated(player)
    if player:HasTrait("StrongBack") then
        player:setMaxWeightBase(9)
    elseif player:HasTrait("WeakBack") then
        player:setMaxWeightBase(7)
    else
        player:setMaxWeightBase(8)
    end
    
    for _, buff in pairs(BuffSystem.BUFF_CALCULATIONS) do
        player:getModData()[buff.modData] = buff.defaultValue or 0
    end

    local playerWornItems = getPlayer():getWornItems()
    for i=0,playerWornItems:size()-1 do 
        local item = playerWornItems:get(i):getItem()
        local modData = item:getModData()

        if modData.SoulBuff then
            local buff = modData.SoulBuff
            
            if buff and BuffSystem.BUFF_CALCULATIONS[buff] then
                BuffSystem.modifyBuff(player, item, true, buff)
                ItemGenerator.SetResultName(item)
                item:setDisplayCategory('SoulForge')
            end
        end
    end
    
    for _, buff in pairs(BuffSystem.BUFF_CALCULATIONS) do
        if buff.apply then
            buff.apply(player)
        end
    end
end

return EventHandlers