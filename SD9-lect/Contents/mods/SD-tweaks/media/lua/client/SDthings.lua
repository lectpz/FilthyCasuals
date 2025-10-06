require "SDZoneCheck"

local args = {}

local function PlayerDeathSD(player)
	local zonetier, zonename, x, y = checkZone()
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	local playerModData = player:getModData()
	local playerHC = playerModData.HardcoreMode or nil
	local playerSSF = playerModData.SSFMode or nil
	local playerKillCount = player:getZombieKills()
	local playerSurvived = player:getHoursSurvived()
	
	args = {
		player_x = math.floor(x),
		player_y = math.floor(y),
		player_name = getOnlineUsername(),
		player_kc = playerKillCount,
		player_hrs = playerSurvived,
		zonename = zonename,
		zonetier = zonetier,
		z_vis = z_vis,
		z_chase = z_chase,
		z_close = z_close,
	};
	
	if SandboxVars.SDevents.enabled then
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			sendClientCommand(player, 'sdLogger', 'LogEventDeath', args);
			return
		end
	end
	
	if playerHC and playerSSF then
		sendClientCommand(player, 'sdLogger', 'LogHCSSFDeath', args);
	elseif playerHC then
		sendClientCommand(player, 'sdLogger', 'LogHCDeath', args);
	elseif playerSSF then
		sendClientCommand(player, 'sdLogger', 'LogSSFDeath', args);
	else
		sendClientCommand(player, 'sdLogger', 'LogNormalDeath', args);
	end

end
Events.OnPlayerDeath.Add(PlayerDeathSD)

local function login_check(player)
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close,
		}
		
		if not player:isSeatedInVehicle() then
			if z_chase > 3 and zonetier > 3 then
				processGeneralMessage("Help! I just logged in at " .. zonename .. " [T" .. zonetier .."] and I'm being chased by " .. z_chase .. " zombies!")
			end
			sendClientCommand(player, 'sdLogger', 'Login', args);
		else
			sendClientCommand(player, 'sdLogger', 'VehicleLogin', args);
		end
	end

	Events.OnPlayerMove.Remove(login_check)
end
Events.OnPlayerMove.Add(login_check)

local function EveryTenMinutes_check()
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = x,
		  player_y = y,
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close
		}
		sendClientCommand(player, 'sdLogger', 'CheckIn', args);
	end
end
--Events.EveryTenMinutes_check.Add(EveryTenMinutes_check)

local function onItemFall(item)
	local player = getSpecificPlayer(0)
	local zonetier, zonename, x, y = checkZone()
	
	local iFT = item:getFullType()
	local itemID = item:getID()
	
	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	args.player_z = getSpecificPlayer(0):getZ()
	args.zonename = zonename
	args.zonetier = zonetier
	
	player:Say("I dropped " .. item:getName() .. "! Better pick it up later before it disappears!")
	sendClientCommand(player, 'sdLogger', 'onItemFall', args);
end

Events.onItemFall.Add(onItemFall)

require "DAMN_Armor_Shared";

DAMN = DAMN or {};
DAMN.Armor = DAMN.Armor or {};

DAMN.Armor["partUpdateInterval"] = 2000;

local function getFaction(player)
	local pMD = player:getModData()
	local faction = pMD.faction
	local DD_Faction = ModData.getOrCreate("DD_Faction")
	
	if faction then DD_Faction["Faction"] = faction end--compatibility so existing players save their faction pmd to gmd
	if not faction and type(DD_Faction)=="string" then faction = DD_Faction["Faction"] end--make factions persist on death

	if faction == "COG" then
		MF.getMoodle("COG"):setValue(1.0)
		MF.getMoodle("Ranger"):setValue(0.5)
		MF.getMoodle("VW"):setValue(0.5)
	elseif faction == "Ranger" then
		MF.getMoodle("COG"):setValue(0.5)
		MF.getMoodle("Ranger"):setValue(1.0)
		MF.getMoodle("VW"):setValue(0.5)
	elseif faction == "VoidWalker" then
		MF.getMoodle("COG"):setValue(0.5)
		MF.getMoodle("Ranger"):setValue(0.5)
		MF.getMoodle("VW"):setValue(1.0)
	else
		MF.getMoodle("COG"):setValue(0.5)
		MF.getMoodle("Ranger"):setValue(0.5)
		MF.getMoodle("VW"):setValue(0.5)
	end
	
	if faction then
		local gmd_faction = ModData.getOrCreate(faction)
		gmd_faction[getOnlineUsername()] = true
		ModData.transmit(faction)
		ModData.remove(faction)
	end
	
	Events.OnPlayerUpdate.Remove(getFaction)
end
Events.OnPlayerUpdate.Add(getFaction)
--Events.OnCreatePlayer.Add(getFaction)

local Commands = {}
Commands.SDthings = {}

function Commands.SDthings.OnWeaponHitThumpable(args)
	local player = getSpecificPlayer(0)
	if args.player_username ~= player:getUsername() then return end
	if isDebugEnabled() then print(args.player_username, player:getUsername()) end
	player:setPrimaryHandItem(nil)
	player:setSecondaryHandItem(nil)
	player:getInventory():setDrawDirty(true)
end

local function onServerCommand(module, command, args)
    if Commands[module] and Commands[module][command] then
		if args.player_username ~= getSpecificPlayer(0):getUsername() then return end
        Commands[module][command](args)
    end
end
Events.OnServerCommand.Add(onServerCommand)

Events.OnFillInventoryObjectContextMenu.Add(function(player, context, items)
												items = ISInventoryPane.getActualItems(items)
												for i=1, #items do
													item = items[i]
													if instanceof(item, "InventoryContainer") then
														if item:getClothingItemExtra() and item:isEquipped() then
															context:removeOptionByName(getText("ContextMenu_Wear"))
															context:removeOptionByName(getText("ContextMenu_Equip_Primary"))
															context:removeOptionByName(getText("ContextMenu_Equip_Secondary"))
															break
														end
													end
												end
											end)