local Config = require('SoulForgedJewelryConfig')
local BuffSystem = require('SoulForgedJewelryBuffs')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local EventHandlers = require('SoulForgedJewelryEventHandlers')
local TooltipSystem = require('SoulForgedJewelryTooltips')
local EventHandlers = require('SoulForgedJewelryEventHandlers')

-- Initialize tooltip system
TooltipSystem.setupTooltipRenderer()

function OnTest_CheckInInventory(item)
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

 -- Override transfer speed for dexterity buff
local original_new = ISInventoryTransferAction.new
function ISInventoryTransferAction:new(character, item, srcContainer, destContainer, time)
    local o = original_new(self, character, item, srcContainer, destContainer, time)
    local dexterityBonus = character:getModData().PermaSoulForgeDexterityBonus or 0
    
    if o and dexterityBonus > 0 then
        o.maxTime = o.maxTime - (o.maxTime * dexterityBonus)
    end
    
    return o
end

SoulForgedJewelryOnCreate = EventHandlers.SoulForgedJewelryOnCreate
function SoulForgedJewelryOnCreateCache(items, result, player)
    local cacheItem = items:get(0)
    local tier = tonumber(string.match(cacheItem:getType(), "T(%d+)"))
    
    items = ItemGenerator.getTierSoulShardExplicit(tier)
    EventHandlers.SoulForgedJewelryOnCreate(items, result, player)
end