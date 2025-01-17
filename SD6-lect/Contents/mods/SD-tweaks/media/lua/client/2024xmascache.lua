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

function request_XMAS2024reward(player)
	ModData.request("XMAS2024reward")
	Events.OnPlayerMove.Remove(request_XMAS2024reward)
end
--[[Events.OnInitGlobalModData.Add(	function()
									local gmd_xmas2024 = ModData.getOrCreate("transmit_XMAS2024reward")	
									if not gmd_xmas2024[getCurrentUserSteamID()] then 
										Events.OnPlayerMove.Add(request_XMAS2024reward)
									end
								end)]]

function XMAS2024_GMD(key, modData)
	if key == "XMAS2024reward" then
		if modData[getCurrentUserSteamID()] then
			Events.OnReceiveGlobalModData.Remove(XMAS2024_GMD)
			return
		end
		
		local gmd_xmas2024 = ModData.getOrCreate("transmit_XMAS2024reward")		
		gmd_xmas2024[getCurrentUserSteamID()] = true
		ModData.transmit("transmit_XMAS2024reward")
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "2024 Christmas Cache",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		addItemToPlayer("Base.2024xmascache")
		
		sendClientCommand(player, 'sdLogger', 'ReceiveCache', args);
		Events.OnReceiveGlobalModData.Remove(XMAS2024_GMD)
	end
end
Events.OnReceiveGlobalModData.Add(XMAS2024_GMD)


function OnCanPerform_2024xmascache(recipe, playerObj)
	local gmd_xmas2024 = ModData.getOrCreate("XMAS2024reward")
	if gmd_xmas2024[getCurrentUserSteamID()] then
		playerObj:Say("I already obtained my 2024 Christmas Reward!")
		return false 
	end
	return true
end

function OnCreate_2024xmascache(items, result, player)

	local zonetier, zonename, x, y = checkZone()
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "2024 Christmas Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	addItemsToPlayer("SoulForge.ContainerSoulsDisposable", 2)
	addItemsToPlayer("Base.bagCapacityTicket", 4)
	addItemsToPlayer("Base.bagWeightTicket", 4)
	
	addItemToPlayer("Base.SCoin")
	--addItemToPlayer("Base.EventWeaponCacheT5")
	addItemToPlayer("SoulForge.SoulCrystalT1")
	addItemToPlayer("SoulForge.SoulCrystalT2")
	addItemToPlayer("SoulForge.SoulCrystalT3")
	addItemToPlayer("SoulForge.SoulCrystalT4")
	addItemToPlayer("SoulForge.SoulCrystalT5")
	addItemToPlayer("SoulForge.BiteHealing")
	
	local dd_T5 = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", "Base.rangerToken", "Base.cogToken", "Base.vwToken", }
	for i=1,#dd_T5 do
		addItemToPlayer(dd_T5[i])
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end