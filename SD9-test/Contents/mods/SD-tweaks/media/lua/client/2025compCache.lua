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

function request_compensation20250610reward(player)
	ModData.request("compensation20250610reward")
	Events.OnPlayerMove.Remove(request_compensation20250610reward)
end
--[[Events.OnInitGlobalModData.Add(	function()
									local gmd_compensation20250610 = ModData.getOrCreate("transmit_compensation20250610reward")	
									if not gmd_compensation20250610[getCurrentUserSteamID()] then 
										Events.OnPlayerMove.Add(request_compensation20250610reward)
									end
								end)]]

function compensation20250610_GMD(key, modData)
	if key == "compensation20250610reward" then
		if modData[getCurrentUserSteamID()] then
			Events.OnReceiveGlobalModData.Remove(compensation20250610_GMD)
			return
		end
		
		local gmd_compensation20250610 = ModData.getOrCreate("transmit_compensation20250610reward")		
		gmd_compensation20250610[getCurrentUserSteamID()] = true
		ModData.transmit("transmit_compensation20250610reward")
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "20250610 Compensation Cache",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		addItemToPlayer("Base.20250610compensationcache")
		
		sendClientCommand(player, 'sdLogger', 'ReceiveCache', args);
		Events.OnReceiveGlobalModData.Remove(compensation20250610_GMD)
	end
end
--Events.OnReceiveGlobalModData.Add(compensation20250610_GMD)


function OnCanPerform_20250610compensationcache(recipe, playerObj)
	local gmd_compensation20250610 = ModData.getOrCreate("compensation20250610reward")
	if gmd_compensation20250610[getCurrentUserSteamID()] then
		playerObj:Say("I've already been compensated.")
		return false 
	end
	return true
end

function OnCreate_20250610compensationcache(items, result, player)

	local zonetier, zonename, x, y = checkZone()
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "20250610 Compensation Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	addItemsToPlayer("Base.bagCapacityTicket", 2)
	addItemsToPlayer("Base.bagWeightTicket", 2)
	
	addItemToPlayer("Base.PropaneTorch")
	addItemToPlayer("Packing.10pkScrapMetal")
	addItemToPlayer("Packing.10pkScrapMetal")
	addItemToPlayer("Base.TileCacheRegular")
		
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end