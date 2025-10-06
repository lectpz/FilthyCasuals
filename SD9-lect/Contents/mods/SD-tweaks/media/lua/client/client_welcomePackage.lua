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

function request_welcomePackage(player)
	if SandboxVars.SDWelcomePackage.enabled then
		if isInSafeHouse or isInCC then
			ModData.request("welcomePackage")
			Events.OnPlayerMove.Remove(request_welcomePackage)
		end
	else
		Events.OnPlayerMove.Remove(request_welcomePackage)
	end
end
Events.OnInitGlobalModData.Add(	function()
									local gmd_welcomePackage = ModData.getOrCreate("transmit_welcomePackage")	
									if not gmd_welcomePackage[getCurrentUserSteamID()] then 
										Events.OnPlayerMove.Add(request_welcomePackage)
									end
								end)

function welcomePackage_GMD(key, modData)
	if key == "welcomePackage" then
		if modData[getCurrentUserSteamID()] then
			Events.OnReceiveGlobalModData.Remove(welcomePackage_GMD)
			local gmd_welcomePackage = ModData.getOrCreate("transmit_welcomePackage")		
			gmd_welcomePackage[getCurrentUserSteamID()] = true
			return
		end
		
		local gmd_welcomePackage = ModData.getOrCreate("transmit_welcomePackage")		
		gmd_welcomePackage[getCurrentUserSteamID()] = true
		ModData.transmit("transmit_welcomePackage")
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "Sunday Drivers Welcome Package",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		addItemToPlayer("SD.WelcomePackageBox")
		local player = getSpecificPlayer(0)
		player:setHaloNote("You have received a Sunday Drivers Welcome Package!", 0, 255, 0, 450)
		player:getEmitter():playSoundImpl("SDWelcomePackage", nil)
		
		sendClientCommand(player, 'sdLogger', 'ReceiveCache', args);
		Events.OnReceiveGlobalModData.Remove(welcomePackage_GMD)
	end
end
Events.OnReceiveGlobalModData.Add(welcomePackage_GMD)