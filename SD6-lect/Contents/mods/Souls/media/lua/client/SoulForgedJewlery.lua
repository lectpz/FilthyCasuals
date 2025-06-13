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
		
	--print("old o.maxTime",o.maxTime)
	if SDxferQOL then o.maxTime = o.maxTime * 0.25 end
	--print("new o.maxTime",o.maxTime)
	
    return o
end

SoulForgedJewelryOnCreate = EventHandlers.SoulForgedJewelryOnCreate
function SoulForgedJewelryOnCreateCache(items, result, player)
    local cacheItem = items:get(0)
    local tier = tonumber(string.match(cacheItem:getType(), "T(%d+)"))
    
    for i=1,3 do
        items = ItemGenerator.getTierSoulShardExplicit(tier)
        SoulForgedJewelryOnCreate(items, result, player)
    end
end

function getSoulForgedValidItems()
    local validItems = ItemGenerator.getValidItems()
    
    print("Valid Soulforged Items:")
    print("----------------------")
    
    table.sort(validItems)
    
    for i, itemName in ipairs(validItems) do
        print(string.format("%d. %s", i, itemName))
    end
    
    print(string.format("\nTotal valid items: %d", #validItems))
end

-- Weird Text Test

local function ticketList(player)
    local inv = player:getInventory()
    local items = inv:getItems()
    local tickets = {}

    for i = 0, items:size() - 1 do
        local itemInv = items:get(i)
        local itemName = itemInv:getFullType()
        if string.sub(itemName, 1, 10) == "SoulForge." then
            -- TODO: also check for weapon type (melee vs ranged)
            local stat, tier = getQualityModifier(itemName)
            if stat and tier then
                local tierName = "T" .. tier
                local tierBonus = tiers[tierName]
                if tierBonus then
                    tickets[stat] = tickets[stat] or {}
                    table.insert(tickets[stat],
                        {
                            item = item,
                            tier = tierName,
                            bonus = tierBonus
                        }
                    )
                end
            end
        end
    end

    return tickets
end
