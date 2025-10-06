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

function request_compensation20250910reward(player)
	if isInSafeHouse or isInCC then
		ModData.request("compensation20250910reward")
		Events.OnPlayerMove.Remove(request_compensation20250910reward)
	end
end
--[[Events.OnInitGlobalModData.Add(	function()
									local gmd_compensation20250910 = ModData.getOrCreate("transmit_compensation20250910reward")	
									if not gmd_compensation20250910[getCurrentUserSteamID()] then 
										Events.OnPlayerMove.Add(request_compensation20250910reward)
									end
								end)]]

function compensation20250910_GMD(key, modData)
	if key == "compensation20250910reward" then
		if modData[getCurrentUserSteamID()] then
			Events.OnReceiveGlobalModData.Remove(compensation20250910_GMD)
			local gmd_compensation20250910 = ModData.getOrCreate("transmit_compensation20250910reward")		
			gmd_compensation20250910[getCurrentUserSteamID()] = true
			return
		end
		
		local gmd_compensation20250910 = ModData.getOrCreate("transmit_compensation20250910reward")		
		gmd_compensation20250910[getCurrentUserSteamID()] = true
		ModData.transmit("transmit_compensation20250910reward")
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "20250910 Compensation Cache",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		addItemToPlayer("Base.20250910compensationcache")
		local player = getSpecificPlayer(0)
		player:setHaloNote("You have received your Compensation Package! (2025-09-10)", 0, 255, 0, 450)
		player:getEmitter():playSoundImpl("SDWelcomePackage", nil)
		
		sendClientCommand(player, 'sdLogger', 'ReceiveCache', args);
		Events.OnReceiveGlobalModData.Remove(compensation20250910_GMD)
	end
end
--Events.OnReceiveGlobalModData.Add(compensation20250910_GMD)


function OnCanPerform_20250910compensationcache(recipe, playerObj)
	local gmd_compensation20250910 = ModData.getOrCreate("compensation20250910reward")
	if not gmd_compensation20250910 then
		playerObj:Say("I shouldn't be opening someone else's compensation package.")
		return false
	end
	if gmd_compensation20250910[getCurrentUserSteamID()] then
		playerObj:Say("I've already been compensated.")
		return false 
	end
	return true
end

function OnCreate_20250910compensationcache(items, result, player)

	local zonetier, zonename, x, y = checkZone()
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "20250910 Compensation Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	addItemsToPlayer("Base.bagCapacityTicket", 3)
	addItemsToPlayer("Base.bagWeightTicket", 3)
	addItemsToPlayer("SoulForge.mdzMinDmg_EnhancerT5",2)
	addItemsToPlayer("SoulForge.mdzMaxDmg_EnhancerT5",2)
	addItemsToPlayer("SoulForge.mdzCriticalChance_EnhancerT5",2)
	addItemsToPlayer("SoulForge.mdzCritDmgMultiplier_EnhancerT5",2)
	
	addItemToPlayer("Base.PropaneTorch")
	addItemToPlayer("SoulForge.LuckFlask_300")
	addItemToPlayer("SoulForge.SoulSmithFlask_2pct")
	addItemToPlayer("Base.GasCanVoucher")
	addItemToPlayer("SoulForgeJewelery.EventJewelryCacheT6")
		
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end