----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local EventHandlers = require('SoulForgedJewelryEventHandlers')

local function sfjReroll(player, items, sfjTier)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
	--items = ISInventoryPane.getActualItems(items)
	local cachedItems = {}
	for n=1,5 do
		cachedItems[n] = {}
	end
	
	for i=1, #items do
		local item = items[i]
		if not item:isInPlayerInventory() then return end -- item must be in inventory
		local iTier = item:getModData().Tier
		if iTier then table.insert(cachedItems[iTier], item:getID()) end -- populate cached items table
	end
	
	for tier,v in pairs(cachedItems) do
		if tier == sfjTier then
			local count = 0
			local _v = math.floor(#v/3)*3 --number of triplicates in tier group
			--print("Tier: " .. tier .. "/ " .. _v)
			-- remove triplicates
			for _,itemID in pairs(v) do
				count = count + 1
				if count <= _v then
					--print(tier, itemID)
					playerInv:removeItemWithID(itemID)
				end
			end
			-- remove triplicates
			-- count number of triplicates to reforge
			local no_sfjToCreate = math.floor(count/3)
			for i=1, no_sfjToCreate do
				shard = ItemGenerator.getTierSoulShardExplicit(tier)
				SoulForgedJewelryOnCreate(shard, "Base.Dice", playerObj)
			end
			-- count number of triplicates to reforge
		end
	end
end

local function sfjContext(player, context, items)
    local playerObj = getSpecificPlayer(0)
    local playerInv = playerObj:getInventory()
	local _items = ISInventoryPane.getActualItems(items)
	local cachedItems = {}
	for n=1,5 do
		cachedItems[n] = {}
	end
	
	for i=1, #_items do
		local item = _items[i]
		if not item:isInPlayerInventory() then return end -- item must be in inventory
		local iTier = item:getModData().Tier
		if iTier then table.insert(cachedItems[iTier], item:getID()) end -- populate cached items table
	end
	
	for tier,v in pairs(cachedItems) do
		local _v = math.floor(#v/3) 
		if _v >=1 then
			context:addOption("Recombine [T" .. tier .. "] SoulForged Jewelry (" .. _v .. " rerolls)", player, sfjReroll, _items, tier)
		end
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(sfjContext)