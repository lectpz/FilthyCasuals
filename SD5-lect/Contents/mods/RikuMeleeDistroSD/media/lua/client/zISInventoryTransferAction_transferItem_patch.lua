local args = {}
local timeStamp = 0
local transferTimeStamp = 0
local itemcount = 0

local function itemsLooted()
	local result = ""
	local itemCounts = {}

	for i=1, itemcount do
  	local itemKey = "item" .. i
  	local data = args.items[itemKey][#args.items[itemKey]]
  	--print(itemKey)
  	--print(i)
  	local item, source, destination

  	for k, v in pairs(data) do
  		if k == "item" then 
  			item = v 
  			--print("item = " .. item) 
  		elseif k == "source" then 
  			source = v
  			--print("source = " .. source)
  		elseif k == "destination" then 
  			destination = v
  			--print("destination = " .. destination)
  		elseif k == "itemID" then 
  			itemID = v
  			--print("destination = " .. destination)
  		end
  	end
		--print("itemcount = " .. i)
		--print("item = " .. item) 
		--print("source = " .. source)
		--print("destination = " .. destination)

		if not itemCounts[item] then
			itemCounts[item] = {}
		end
		if not itemCounts[item][source] then
			itemCounts[item][source] = {}
		end
		if not itemCounts[item][source][destination] then
			itemCounts[item][source][destination] = { count = 0, itemID = itemID }
		end
		
    itemCounts[item][source][destination].count = itemCounts[item][source][destination].count + 1
	end

	for item, sourceData in pairs(itemCounts) do
		for source, destinationCounts in pairs(sourceData) do
			for destination, count in pairs(destinationCounts) do
				if itemCounts[item][source][destination].count == 1 then
					result = result .. "\n[sdLogger] Player [" .. args.player_name .. "] moved items: " .. count.count .. "x " .. item .. " (ID=" .. count.itemID .. ") [" .. source .. " -> " .. destination .. "], "
				else
					result = result .. "\n[sdLogger] Player [" .. args.player_name .. "] moved items: " .. count.count .. "x " .. item .. " [" .. source .. " -> " .. destination .. "], "
				end
			end
		end
	end
	
	return string.sub(result, 0, string.len(result) - 2)
end

local function logItemTransfer(iFT, itemID, sourceContainer, destinationContainer)
	itemcount = itemcount + 1

	args.items = args.items or {}

	local itemData = {
		item = iFT,
		itemID = itemID,
		source = sourceContainer,
		destination = destinationContainer,
	}

	local itemKey = "item" .. itemcount
	args.items[itemKey] = args.items[itemKey] or {}
	table.insert(args.items[itemKey], itemData)

end

local function printItemTransfer()
	if args.items and itemcount == 0 then
		return
	elseif args.items and itemcount > 0 then
		timeStamp = getTimestampMs()
		if timeStamp - transferTimeStamp >= 1000 then
			args.itemString = {}
			table.insert(args.itemString, itemsLooted(args))
			
			--print("[sdLogger] Player [" .. args.player_name .. "] at (" .. args.player_x .. "," .. args.player_y .. "," .. args.player_z .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]" .. "moved items: " .. args.itemString[1])
			sendClientCommand(getSpecificPlayer(0), 'sdLogger', 'ItemTransfer', args);
			args = {}
			itemcount = 0
		end
	end
end

ISInventoryTransferAction.o_transferItem = ISInventoryTransferAction.transferItem;
function ISInventoryTransferAction:transferItem(item)
	
	local zonetier, zonename, x, y = checkZone()
	
	local iFT = item:getFullType()
	local itemID = item:getID()
	
	local sourceContainer = self.srcContainer:getType()
	local destinationContainer = self.destContainer:getType()
	
	if self.srcContainer:getType() == "none" then 
		sourceContainer = "Player Inventory" 
	end
	
	if self.destContainer:getType() == "none" then 
		destinationContainer = "Player Inventory" 
	end

	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	args.player_z = getSpecificPlayer(0):getZ()
	args.zonename = zonename
	args.zonetier = zonetier
	args.srcContainer = sourceContainer
	args.destContainer = destinationContainer
	
	if  
		iFT ~= "Base.WeaponCache" 
	and iFT ~= "Base.MechanicCache" 
	and iFT ~= "Base.MetalworkCache" 
	and iFT ~= "Base.MedicalCache" 
	and iFT ~= "Base.AmmoCache" 
	and iFT ~= 'Base.ArmorCachePatriot' 
	and iFT ~= 'Base.ArmorCacheDefender' 
	and iFT ~= 'Base.ArmorCacheVanguard' 
	and iFT ~= 'Base.SpiffoCache' 
	then
		--sendClientCommand(self.character, 'sdLogger', 'ItemTransfer', args);
		self:o_transferItem(item);
		logItemTransfer(iFT, itemID, sourceContainer, destinationContainer)
		if (item ~= nil) and (item:getType() == "Generator" or item:getType() == "CorpseMale" or item:getType() == "CorpseFemale" or item:hasTag("HeavyItem")) then
			self.character:getModData().isXferHeavyItem = true -- true
			
		else
			self.character:getModData().isXferHeavyItem = false -- false
			
		end
	elseif self.destContainer:getType()=="floor" then
		--sendClientCommand(self.character, 'sdLogger', 'ItemTransfer', args);
		self:o_transferItem(item);
		logItemTransfer(iFT, itemID, sourceContainer, destinationContainer)
		if (item ~= nil) and (item:getType() == "Generator" or item:getType() == "CorpseMale" or item:getType() == "CorpseFemale" or item:hasTag("HeavyItem")) then
			self.character:getModData().isXferHeavyItem = true -- true
			
		else
			self.character:getModData().isXferHeavyItem = false -- false
			
		end
	else
		self.character:Say("I should just open this here.")
	end

end

Events.EveryOneMinute.Add(printItemTransfer)