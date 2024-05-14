---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local Commands = {};
Commands.SDT = {};

---------------------------------------------------------------------------------------------------
-------------------- Local helper functions

local function getPlayerLastTeleport(player_name, type)
    -- Prepare data if doesnt exist
    local modData = getGameTime():getModData();

    if nil == modData["SD-teleporter"] then
        modData["SD-teleporter"] = {};
    end
    if nil == modData["SD-teleporter"][player_name] then
        modData["SD-teleporter"][player_name] = {};
    end
    local last = modData["SD-teleporter"][player_name][type];
    if last == nil then
        last = 0 -- world_age_hours - cooldown_ingame_hours - 1;
        modData["SD-teleporter"][player_name][type] = 0
    end

    return last
end

local function authorizeTeleport(player, player_name, type)

    local cooldown_ingame_hours = SandboxVars.SDTeleporter.CooldownCCCategory;
    if type == "player" then
        cooldown_ingame_hours = SandboxVars.SDTeleporter.CooldownPlayerCategory;
    elseif type == "safehouse" then
        cooldown_ingame_hours = SandboxVars.SDTeleporter.CooldownSafehouseCategory;
    end

    local result = false;

    local gameTime = getGameTime();
    local world_age_hours = gameTime:getWorldAgeHours();
    local modData = gameTime:getModData();

    local last = getPlayerLastTeleport(player_name, type);
    local ingame_hours_since_last = world_age_hours - last;

    if (ingame_hours_since_last > cooldown_ingame_hours) then

        modData["SD-teleporter"][player_name][type] = world_age_hours;
        print ("Player [" .. player_name .. "] requested teleport (Type:" .. type .. ") - ingame_hours_since_last=" .. ingame_hours_since_last);
        result = true;
    else
        local args = {
            last = last,
            cooldown = cooldown_ingame_hours,
            elapsed = ingame_hours_since_last
        };
        sendServerCommand(player, 'SDT', 'FailedToExecute', args);
        print ("Player [" .. player_name .. "] request not authorized (Type:" .. type .. ") - ingame_hours_since_last=" .. ingame_hours_since_last);
    end

    return result;
end

-- Fix for 41.78 TiS garbage: send list of players online
-- Thanks bikinihorst!
function broadcastPlayersOnline()

    print("Broadcasting players online...")

	local online_players = getOnlinePlayers();
	local players_online = {};

	if online_players
	then
		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);

			if player
			then
				table.insert(players_online, player:getUsername());
			end
		end

		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);

			if player
			then
                sendServerCommand(player, 'SDT', 'PlayersOnline', players_online);
			end
		end
	end

end

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.SDT.GetCooldowns(player, args)

    print ("Teleport cooldowns requested");
    local player_name = player:getUsername();

    local response = {
        last_cc = getPlayerLastTeleport(player_name, "CC"),
        last_player = getPlayerLastTeleport(player_name, "player"),
        last_safehouse = getPlayerLastTeleport(player_name, "safehouse")
    };

    print ("Player [" .. player_name .. "] received teleport cooldowns { last_cc=" .. response.last_cc .. ", last_player=" .. response.last_player .. ", last_safehouse=" .. response.last_safehouse .. "}")

    sendServerCommand(player, 'SDT', 'UpdateCooldowns', response);

    broadcastPlayersOnline();
end

function Commands.SDT.TravelToCC(player, args)
    if authorizeTeleport(player, args.player_name, "CC") then
        print("Player [" .. args.player_name .. "] requesting teleport to CC");
    end
    -- update player with cooldowns
    Commands.SDT.GetCooldowns(player,args);
end

function Commands.SDT.TravelToPlayer(player, args)
    if authorizeTeleport(player, args.player_name, "player") then
        print("Player [" .. args.player_name .. "] requesting teleport to player [" .. args.another_player .. "]");
    end
    -- update player with cooldowns
    Commands.SDT.GetCooldowns(player,args);
end

function Commands.SDT.TravelToSafehouse(player, args)
    if authorizeTeleport(player, args.player_name, "safehouse") then
        print("Player [" .. args.player_name .. "] requesting teleport to safehouse at " .. args.safehouse_x .. "," .. args.safehouse_y )
    end
    -- update player with cooldowns
    Commands.SDT.GetCooldowns(player,args);
end

--SD5 lect
function Commands.SDT.EventTPToSH(player, args)
    print("Event Completion Safehouse Teleport activated for: [" .. args.player_name .."]")
    print("Player [" .. args.player_name .. "] requesting teleport to safehouse at " .. args.safehouse_x .. "," .. args.safehouse_y )
end

function Commands.SDT.TravelToCoordinates(player, args)
    print("Event Teleport to [ x = " .. args.safehouse_x .. ", y = " .. args.safehouse_y .. " ] activated for: [" .. args.player_name .."]")
    print("Player [" .. args.player_name .. "] requesting teleport to safehouse at " .. args.safehouse_x .. "," .. args.safehouse_y )
end
--SD5 lect

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    Events.OnClientCommand.Add(onClientCommand);
    Events.EveryTenMinutes.Add(broadcastPlayersOnline)
end