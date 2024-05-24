-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

local MOD_NAME = "Sunday Drivers Teleporter";

local function info()
    print("Mod Loaded:" .. MOD_NAME);
end

Events.OnGameBoot.Add(info);

local Commands = {};
local moduleName = "SDT";

SundayDriversGlobalContext = {}
SundayDriversGlobalContext.last_cc = 0;
SundayDriversGlobalContext.last_player = 0;
SundayDriversGlobalContext.last_safehouse = 0;
SundayDriversGlobalContext.players_online = {};
SundayDriversGlobalContext.updates = 0;

-----------------------------------------------------------------------------------------------------------------------
-------------------- Server commands and initial request

local function onPlayerUpdate(player)
	SundayDriversGlobalContext.updates = SundayDriversGlobalContext.updates + 1

	if SundayDriversGlobalContext.updates >= 10 then
        sendClientCommand(player, 'SDT', 'GetCooldowns', {});
		print('Requesting cooldowns')
		SundayDriversGlobalContext.updates = -10000
	end
end

if isClient() then
	Events.OnPlayerUpdate.Add(onPlayerUpdate)
end

function Commands.FailedToExecute(args)

    local remaining = (tonumber(args["cooldown"]) - tonumber(args["elapsed"]));
    local absolute = math.floor(remaining);

    local message = "Hours until ready: " .. absolute .. "." .. math.floor((remaining - absolute) * 10)

    getSpecificPlayer(0):Say(message)
end

function Commands.PlayersOnline(args)

    print("Received list of players online.")

    SundayDriversGlobalContext.players_online = {}

    for k,v in pairs(args)
    do
        table.insert(SundayDriversGlobalContext.players_online, v)
    end
end

function Commands.UpdateCooldowns(args)

    Events.OnPlayerUpdate.Remove(onPlayerUpdate)
    updates, onPlayerUpdate = nil, nil

    print ("Player received teleport cooldowns { last_cc=" .. args.last_cc .. ", last_player=" .. args.last_player .. ", last_safehouse=" .. args.last_safehouse .. "}")
    SundayDriversGlobalContext.last_cc = args.last_cc
    SundayDriversGlobalContext.last_player = args.last_player
    SundayDriversGlobalContext.last_safehouse = args.last_safehouse

end

local onServerCommand = function(module, command, args)
    if module == moduleName and Commands[command] then
        args = args or {}
        Commands[command](args);
    end
end
Events.OnServerCommand.Add(onServerCommand)

-----------------------------------------------------------------------------------------------------------------------
-------------------- Utility

local function has_valid_safehouse(player_name, player_safehouse)

    local result = false

    local safehouse = SafeHouse.hasSafehouse(player_name)
    if safehouse
    then

        x1 = player_safehouse:getX()
        y1 = player_safehouse:getY()
        x2 = safehouse:getX()
        y2 = safehouse:getY()

        local distance = math.floor(math.sqrt((x2-x1)^2, (y2-y1)^2))
        result = distance < 400
    end

    return result
end

local function is_in_safehouse()
    return true
    -- local player = getPlayer()
    -- local safehouse = SafeHouse.hasSafehouse(player)
    -- if safehouse
    -- then

    --     local x = player:getX()
    --     local y = player:getY()

    --     local x1 = safehouse:getX()
    --     local y1 = safehouse:getY()
    --     local x2 = safehouse:getW() + x1
    --     local y2 = safehouse:getH() + y1

    --     if x >= x1 and y >= y1 and x <= x2 and y <= y2
    --     then
    --         return true
    --     end
    -- end

    -- return false
end

local function can_travel_to_safehouse()

    local safehouse = SafeHouse.hasSafehouse(getPlayer());
    if not safehouse then
        print ("no safehouse");
        return false;
    end

    local world_age_hours = getGameTime():getWorldAgeHours();
    local last = SundayDriversGlobalContext.last_safehouse;
    local ingame_hours_since_last = world_age_hours - last;

    return (ingame_hours_since_last > SandboxVars.SDTeleporter.CooldownSafehouseCategory);
end

local function can_travel_to_cc()

    local world_age_hours = getGameTime():getWorldAgeHours();
    local last = SundayDriversGlobalContext.last_cc;
    local ingame_hours_since_last = world_age_hours - last;

    return (ingame_hours_since_last > SandboxVars.SDTeleporter.CooldownCCCategory);
end

local function can_travel_to_players()

    local world_age_hours = getGameTime():getWorldAgeHours();
    local last = SundayDriversGlobalContext.last_player;
    local ingame_hours_since_last = world_age_hours - last;

    return (ingame_hours_since_last > SandboxVars.SDTeleporter.CooldownPlayerCategory);
end


local SundayDriversTeleporterContextMenuObjectName = {};

SundayDriversTeleporterContextMenuObjectName.doMenu = function(player, context, items)

    local self_name = getOnlineUsername();

    for i,v in ipairs(items) do
        local item = v;
        if not instanceof(v, "InventoryItem") then
            item = v.items[1];
        end
        local item_type = item:getType()
        if item_type and (item_type == "Teleporter" or item_type == "TeleporterConsumable") then

            if isAdmin() then
                context:addOption("[Debug] Request cooldowns", item, SundayDriversTeleporterContextMenuObjectName.onRequestCooldowns, player);
            end

            local option_safehouse = context:addOption("Travel back to safehouse", item, SundayDriversTeleporterContextMenuObjectName.onTravelToSafehouse, player);
            option_safehouse.notAvailable = not can_travel_to_safehouse();

            local option_cc = context:addOption("Travel back to CC", item, SundayDriversTeleporterContextMenuObjectName.onTravelToCC, player);
            option_cc.notAvailable = not can_travel_to_cc();

            if SandboxVars.SDTeleporter.AllowTeleportToPlayer then
                local option_players = context:addOption("Travel to player", item, nil, player);
                if #SundayDriversGlobalContext.players_online > 1 then
                    local in_safehouse = is_in_safehouse()
                    local faction = Faction.getPlayerFaction(getPlayer())
                    if not in_safehouse
                    then
                        option_players.notAvailable = true;
                        local tooltip = ISWorldObjectContextMenu.addToolTip();
                        tooltip.description = tooltip.description .. "You need to be inside your safehouse to teleport to a player."
                        option_players.toolTip = tooltip
                    elseif faction
                    then
                        local players = {}
                        local faction_players = faction:getPlayers()
                        for j = 1, faction_players:size()
                        do
                            local anotherplayer_username = faction_players:get(j - 1)
                            if (anotherplayer_username ~= self_name) then
                                players[anotherplayer_username] = anotherplayer_username
                            end
                        end
                        local faction_leader = faction:getOwner()
                        if (faction_leader ~= self_name) then
                            players[faction_leader] = faction_leader
                        end

                        if players
                        then
                            local sub_menu = ISContextMenu:getNew(context)
                            context:addSubMenu(option_players, sub_menu);

                            local player_safehouse = SafeHouse.hasSafehouse(getPlayer())
                            for anotherplayer_username,_ in pairs(players)
                            do
                                if anotherplayer_username
                                then
                                    local option = sub_menu:addOption(anotherplayer_username, item, SundayDriversTeleporterContextMenuObjectName.onTravelToPlayer, player, anotherplayer_username);

                                    local disable_player = true
                                    for _,online_player in pairs(SundayDriversGlobalContext.players_online)
                                    do
                                        if anotherplayer_username == online_player
                                        then
                                            disable_player = false
                                            break
                                        end
                                    end

                                    if disable_player
                                    then
                                        option.notAvailable = true;
                                        local tooltip = ISWorldObjectContextMenu.addToolTip();
                                        tooltip.description = tooltip.description .. "Player offline."
                                        option.toolTip = tooltip
                                    elseif not has_valid_safehouse(anotherplayer_username, player_safehouse)
                                    then
                                        -- option.notAvailable = true;
                                        -- local tooltip = ISWorldObjectContextMenu.addToolTip();
                                        -- tooltip.description = tooltip.description .. "Player doesnt have a safehouse near yours."
                                        -- option.toolTip = tooltip
                                    end
                                end
                            end
                        end
                    else
                        option_players.notAvailable = true;
                        local tooltip = ISWorldObjectContextMenu.addToolTip();
                        tooltip.description = tooltip.description .. "You need to be in a faction to enable this option."
                        option_players.toolTip = tooltip
                    end
                else
                    option_players.notAvailable = true;
                    local tooltip = ISWorldObjectContextMenu.addToolTip();
                    tooltip.description = tooltip.description .. "Faction members not found or offline."
                    -- tooltip.description = tooltip.description .. "Option disabled temporarily."
                    option_players.toolTip = tooltip
                end
            end

            break;
        end
    end
end

local function checkDepleted(player, item)

    local playerObj = getSpecificPlayer(player);
    if item:getType() == "TeleporterConsumable"
    then
        item:setUsedDelta(math.max(item:getUsedDelta() - 0.1,0))

        if item:getUsedDelta() < 0.1
        then
            local playerInv = playerObj:getInventory()
			local brokenTP = InventoryItemFactory.CreateItem("SD.TeleporterBroken")
			playerInv:AddItem(brokenTP)
			if item:isInPlayerInventory() then
				playerInv:Remove(item)
			else
				item:getContainer():Remove(item)
			end
        end
    end
end

SundayDriversTeleporterContextMenuObjectName.onTravelToPlayer = function(item, player, another_player)

    local playerObj = getSpecificPlayer(player);

    local args = {
        player_name = getOnlineUsername(),
        another_player = another_player
    };

	if (item:getType() == "TeleporterConsumable") and (item:getUsedDelta() < 0.1) then
		playerObj:Say("This teleporter is useless.")
	else
		checkDepleted(player, item)
		ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToPlayer', args));
	end
end

SundayDriversTeleporterContextMenuObjectName.onTravelToCC = function(item, player)

    local playerObj = getSpecificPlayer(player);

    local args = {
        player_name = getOnlineUsername()
    };
	
	if (item:getType() == "TeleporterConsumable") and (item:getUsedDelta() < 0.1) then
		playerObj:Say("This teleporter is useless.")
	else
		checkDepleted(player, item)
		ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToCC', args));
	end
end


SundayDriversTeleporterContextMenuObjectName.onTravelToSafehouse = function(item, player)

    local playerObj = getSpecificPlayer(player);
    local safehouse = SafeHouse.hasSafehouse(playerObj);
	local playerModData = playerObj:getModData()
	local pshx = playerModData.SafeHouseX
	local pshy = playerModData.SafeHouseY
    if safehouse then
		if playerModData.SafeHouseX ~= nil and playerModData.SafeHouseY ~= nil then
			local x1 = safehouse:getX()
			local y1 = safehouse:getY()
			local x2 = safehouse:getW() + x1
			local y2 = safehouse:getH() + y1
			if playerModData.SafeHouseX >= x1 and playerModData.SafeHouseY >= y1 and playerModData.SafeHouseX <= x2 and playerModData.SafeHouseY <= y2 then
				local args = {
					safehouse_x = pshx-3,
					safehouse_y = pshy-3,
					player_name = getOnlineUsername()
				};
				
				if (item:getType() == "TeleporterConsumable") and (item:getUsedDelta() < 0.1) then
					playerObj:Say("This teleporter is useless.")
					return
				else
					checkDepleted(player, item)
					ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToSafehouse', args));
				end
			else--if saved moddata SH is not within current SH boundaries then write overwrite existing moddata with default SH coordinates
				playerModData.SafeHouseX = safehouse:getX() --write moddata to player to save safehouse X coordinate
				playerModData.SafeHouseY = safehouse:getY() --write moddata to player to save safehouse Y coordinate
				playerObj:Say("Custom Safehouse coordinates are no longer within your current Safehouse and need to be reset.")
				
				local args = {
					safehouse_x = safehouse:getX(),
					safehouse_y = safehouse:getY(),
					player_name = getOnlineUsername()
				};
				
				if (item:getType() == "TeleporterConsumable") and (item:getUsedDelta() < 0.1) then
					playerObj:Say("This teleporter is useless.")
					return
				else
					checkDepleted(player, item)
					ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToSafehouse', args));
				end
			end
		else
			local args = {
				safehouse_x = safehouse:getX(),
				safehouse_y = safehouse:getY(),
				player_name = getOnlineUsername()
			};
			
			if (item:getType() == "TeleporterConsumable") and (item:getUsedDelta() < 0.1) then
				playerObj:Say("This teleporter is useless.")
				return
			else
				checkDepleted(player, item)
				ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToSafehouse', args));
			end
		end
	else
		playerObj:Say("I have no Safehouse to teleport to.")
    end
end

SundayDriversTeleporterContextMenuObjectName.onRequestCooldowns = function(item, player)

    local playerObj = getSpecificPlayer(player);

    print("requesting cooldowns")
    local args = {}
    sendClientCommand(playerObj, 'SDT', "GetCooldowns", args);
end

Events.OnFillInventoryObjectContextMenu.Add(SundayDriversTeleporterContextMenuObjectName.doMenu);

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--SD5 lect additions below


--context menu option for teleport
--[[
--not used, using waystone instead
SDteleporterContextMenuObjectName.doSDteleport_to_event = function(item, player)
	local playerObj = getSpecificPlayer(player)
	local playerStats = playerObj:getStats()
	
	local args = {
		player_name = getOnlineUsername(),
		another_player = SandboxVars.SDevents.Admin_to_Teleport
	};
	ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToEventAdmin', args));
end

--not used, using waystone instead
SDteleporterContextMenuObjectName.doSDreward_to_CC = function(item, player)
	local playerObj = getSpecificPlayer(player)
	local playerStats = playerObj:getStats()
	playerObj:Say("item: " .. item)
	local tpModData = item:getFullType():getModData()
	local steamID = getCurrentUserSteamID()
	
	local claimed = tpModData.steamID or nil
		
	local args = {
		player_name = getOnlineUsername(),
	};
	if not claimed then
		tpModData.steamID = true
		ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToCCFromEvent', args));
	else
		playerObj:Say("I already claimed a reward.")
	end
end

--not used, using waystone instead
SDteleporterContextMenuObjectName.doSDreward_to_SH = function(item, player)
	local playerObj = getSpecificPlayer(player);
	local playerModData = playerObj:getModData()
	local safehouse = SafeHouse.hasSafehouse(playerObj);
	
	if playerModData.SafeHouseX ~= nil and playerModData.SafeHouseY ~= nil then
		if safehouse then
		
			local x1 = safehouse:getX()
			local y1 = safehouse:getY()
			local x2 = safehouse:getW() + x1
			local y2 = safehouse:getH() + y1
			
			local tpModData = item:getFullType():getModData()
			local steamID = getCurrentUserSteamID()

			local claimed = tpModData.steamID or nil
			
			--if saved moddata SH is within current SH boundaries then define use moddata SH coordinates
			if playerModData.SafeHouseX >= x1 and playerModData.SafeHouseY >= y1 and playerModData.SafeHouseX <= x2 and playerModData.SafeHouseY <= y2 then
				local args = {
					safehouse_x = playerModData.SafeHouseX,
					safehouse_y = playerModData.SafeHouseY,
					player_name = getOnlineUsername()
				};
				if not claimed then
					tpModData.steamID = true
					ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToSafehouseFromEvent', args));
				else
					playerObj:Say("I already claimed a reward.")
				end	
			else--if saved moddata SH is not within current SH boundaries then write overwrite existing moddata with default SH coordinates
				playerModData.SafeHouseX = safehouse:getX() --write moddata to player to save safehouse X coordinate
				playerModData.SafeHouseY = safehouse:getY() --write moddata to player to save safehouse Y coordinate
				playerObj:Say("Custom Safehouse coordinates are no longer within your current Safehouse and need to be reset.")
				
				local args = {
					safehouse_x = safehouse:getX(),
					safehouse_y = safehouse:getY(),
					player_name = getOnlineUsername()
				};
				
				if not claimed then
					tpModData.steamID = true
					ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToSafehouseFromEvent', args));
				else
					playerObj:Say("I already claimed a reward.")
				end	
			end
		else
			playerObj:Say("I have no Safehouse to teleport to.")
		end
	end
end
]]--

--context menu option to add safehouse coordinate
doSDsafehousecoord_SD5 = function(item, player)
	local playerObj = getSpecificPlayer(player)
	local safehouse = SafeHouse.hasSafehouse(playerObj);--define safehouse
	local playerModData = getPlayer():getModData()
	
	if safehouse then -- check if there is a valid safehouse
		
		local x = playerObj:getX()
		local y = playerObj:getY()
		local z = playerObj:getZ()
		
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
	
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if z == 0 then
				playerModData.SafeHouseX = math.floor(x) --write moddata to player to save safehouse X coordinate
				playerModData.SafeHouseY = math.floor(y) --write moddata to player to save safehouse Y coordinate
				--player:getModData().SafeHouseZ = z --write moddata to player to save safehouse Z coordinate
				playerObj:Say("Safehouse teleport coordinates set to: x=" .. tostring(playerModData.SafeHouseX) ..", y=" .. tostring(playerModData.SafeHouseY))
			else
				playerObj:Say("I need to be on the ground floor to do this.")
			end
		else
			playerObj:Say("I need to be inside my Safehouse boundaries to do this.")
		end
	else
		playerObj:Say("It would be nice if I had a Safehouse though.") 
	end
end

--context menu option add for teleporter. 
local function SDteleportercontext_add(player, context, items) -- # When an inventory item context menu is opened
	--local playerObj = getSpecificPlayer(player);
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if (item:getFullType() == 'SD.Teleporter' or item:getFullType() == 'SD.TeleporterConsumable') and item:isInPlayerInventory() then--and (item:getContainer() == playerObj:getInventory()) then
			--if SandboxVars.SDevents.teleporttoeventenabled and (not SandboxVars.SDevents.EventRewardEnabled) then
				--anotherplayer_username = SandboxVars.SDevents.Admin_to_Teleport
				--context:addOption("Teleport to Event (No Cooldown)", item, SDteleporterContextMenuObjectName.doSDteleport_to_event, player, anotherplayer_username) -- add context menu option to Teleport to event
			--end
			context:addOption("Set Return Coordinates for Safehouse Teleport", item, doSDsafehousecoord_SD5, player) -- add context menu option to write safehouse coordinates to player getmoddata
			break -- break the loop when found
		end

	end
end

Events.OnFillInventoryObjectContextMenu.Add(SDteleportercontext_add) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option

--[[
local function SDrewardcontext(player, context, items) -- # When an inventory item context menu is opened
	--local playerObj = getSpecificPlayer(player);
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if (item:getFullType() == 'SundayDrivers.EventRewardTP') then--and (item:getContainer() == playerObj:getInventory()) then
			if SandboxVars.SDevents.EventRewardEnabled then
				context:addOption("Claim Reward and Return to CC", item, SDteleporterContextMenuObjectName.doSDreward_to_CC, player) -- add context menu option to Teleport to event
				context:addOption("Claim Reward and Return to Safehouse", item, SDteleporterContextMenuObjectName.doSDreward_to_SH, player) -- add context menu option to Teleport to event
			end
			break -- break the loop when found
		end

	end
end
--SD.TeleporterBroken

Events.OnFillInventoryObjectContextMenu.Add(SDrewardcontext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option
]]--
