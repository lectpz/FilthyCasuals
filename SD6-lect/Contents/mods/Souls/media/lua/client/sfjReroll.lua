----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local EventHandlers = require('SoulForgedJewelryEventHandlers')

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "

local function countItems(playerObj, item)
	local inv = playerObj:getInventory()
	local items = inv:getItemsFromFullType(item, false)
	local count = 0
	for i=1,items:size() do
		local invItem = items:get(i-1)
		if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
			count = count + 1
		end
	end
	return count
end

local function itemToolTipMats(tooltip, material, option, quantity)
	local playerObj = getSpecificPlayer(0)
	local playerInv = playerObj:getInventory()
	local scriptItem = ScriptManager.instance:getItem(material)
	local itemdisplayname = scriptItem:getDisplayName()
	tooltip.description = tooltip.description .. " <LINE> "
	if countItems(playerObj, material) < quantity then
		count = countItems(playerObj, material)
		option.notAvailable = true;
		--tooltip = ISWorldObjectContextMenu.addToolTip();
		tooltip.description = tooltip.description .. red .. itemdisplayname .. " " .. count .. "/" .. quantity ;
	else
		--count = playerInv:getCountTypeRecurse(material)
		count = countItems(playerObj, material)
		tooltip.description = tooltip.description .. green .. itemdisplayname .. " " .. count .. "/" .. quantity ;
	end
end

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
		if not item:isInPlayerInventory() or item:isEquipped() or item:isFavorite() then return end -- item must be in inventory
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
			for i=1,no_sfjToCreate*tier^2 do
				playerInv:RemoveOneOf("Base.ScrapMetal")
			end
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
		if not item:isInPlayerInventory() or item:isEquipped() or item:isFavorite() then return end -- item must be in inventory
		local iTier = item:getModData().Tier
		if iTier then table.insert(cachedItems[iTier], item:getID()) end -- populate cached items table
	end
	
	for tier,v in pairs(cachedItems) do
		local _v = math.floor(#v/3) 
		if _v >=1 then
			local sfj_recomb = context:addOption("Recombine [T" .. tier .. "] SoulForged Jewelry (" .. _v .. " rerolls)", player, sfjReroll, _items, tier)
			tooltip = ISWorldObjectContextMenu.addToolTip();
			tooltip.description = gold .. "Scrap Metal required (" .. tier^2 .. " per reroll):"
			itemToolTipMats(tooltip, "Base.ScrapMetal", sfj_recomb, _v*tier^2)
			sfj_recomb.toolTip = tooltip
		end
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(sfjContext)