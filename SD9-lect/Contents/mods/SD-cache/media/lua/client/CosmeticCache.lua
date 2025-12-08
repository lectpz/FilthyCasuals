----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

--require "SDZoneCheck"

local Config = require('SoulForgedJewelryConfig')
local BuffSystem = require('SoulForgedJewelryBuffs')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local EventHandlers = require('SoulForgedJewelryEventHandlers')


-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local args = {}

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addItemsToPlayer(loot, amount)
	getSpecificPlayer(0):getInventory():AddItems(loot, amount)
	addToArgs(loot, amount)
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function randomrollSD(zoneroll, loot, itemname)
	if ZombRand(zoneroll) == 0 then
		getSpecificPlayer(0):getInventory():AddItem(loot)
		local itemname = itemname or loot
		addToArgs(loot, 1, itemname)
	end
end

local shoeItems = {}
local bagItems = {}
local function getCosmeticItems()
	local items = getAllItems();
	for i = 0, items:size()-1, 1 do
		local item = items:get(i)
		
		if item:getModuleName() ~= "HCustoms" then
			
			local typeString = item:getTypeString()
			
			if typeString and typeString == "Container" then
				local clothingItem = item:getClothingItem()
				if clothingItem and not item:getClothingItemExtra() then
					local iFT = item:getFullName()
					if iFT ~= "Base.rangerTrailblazer" and iFT ~= "Base.VWZombieKillerBP" then
						local bag = InventoryItemFactory.CreateItem(iFT)
						if bag:getWeightReduction() > 65 and bag:getWeightReduction() <= 90 then
							table.insert(bagItems, iFT)
						end
					end
				end
			end
			
			local bodyLocation = item:getBodyLocation()
			if bodyLocation and bodyLocation == "Shoes" then
				table.insert(shoeItems, item:getFullName())
			end
			
		end
	end
end
Events.OnInitGlobalModData.Add(getCosmeticItems)

function OnCreate_BagCache(items, result, player)
	local _tier, zonename, x, y = checkZone()
	local tier = items:get(0):getModData().TierZone
	local inventory = player:getInventory()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Bag Cache ["..tier.."]",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = _tier,
	}
	
    local rolledItem = bagItems[ZombRand(#bagItems)+1]
	if not rolledItem then print(rolledItem) return end
	addItemToPlayer(rolledItem, bagItems[ZombRand(#bagItems)+1])

    local createdItem = ItemGenerator.findUnmodifiedSoulBuffJewlery(inventory, rolledItem)
    createdItem:setDisplayCategory('SoulForge')

    if createdItem then

		if tier == 6 and ZombRand(10) == 0 then
			local selectedBuffs = BuffSystem.getMultipleWeightedBuffs("T3", 2)
			createdItem:getModData().SoulBuffs = selectedBuffs
			-- Set individual buff tiers for multiple buffs
			createdItem:getModData().SoulBuffTiers = {}
			for _, buff in ipairs(selectedBuffs) do
				createdItem:getModData().SoulBuffTiers[buff] = 3
			end
			createdItem:getModData().Tier = 3
		else
			tier = math.max(tier-3, 1)
			local selectedBuff = BuffSystem.getWeightedBuff("T" .. tier)
			createdItem:getModData().SoulBuffs = {selectedBuff}
			createdItem:getModData().Tier = tier
		end
		
		createdItem:setDisplayCategory('SoulForge')
		ItemGenerator.SetResultName(createdItem)
		
    end
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function OnCreate_ShoeCache(items, result, player)
	local _tier, zonename, x, y = checkZone()
	local tier = items:get(0):getModData().TierZone
	local inventory = player:getInventory()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Shoe Cache ["..tier.."]",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = _tier,
	}
	
    local rolledItem = shoeItems[ZombRand(#shoeItems)+1]
	addItemToPlayer(rolledItem, shoeItems[ZombRand(#shoeItems)+1])

    local createdItem = ItemGenerator.findUnmodifiedSoulBuffJewlery(inventory, rolledItem)
    createdItem:setDisplayCategory('SoulForge')

    if createdItem then

		if tier == 6 and ZombRand(10) == 0 then
			local selectedBuffs = BuffSystem.getMultipleWeightedBuffs("T3", 2)
			createdItem:getModData().SoulBuffs = selectedBuffs
			-- Set individual buff tiers for multiple buffs
			createdItem:getModData().SoulBuffTiers = {}
			for _, buff in ipairs(selectedBuffs) do
				createdItem:getModData().SoulBuffTiers[buff] = 3
			end
			createdItem:getModData().Tier = 3
		else
			tier = math.max(tier-3, 1)
			local selectedBuff = BuffSystem.getWeightedBuff("T" .. tier)
			createdItem:getModData().SoulBuffs = {selectedBuff}
			createdItem:getModData().Tier = tier
		end
		
		createdItem:setDisplayCategory('SoulForge')
		ItemGenerator.SetResultName(createdItem)
		
    end
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end