local Commands = {};
Commands.PlayerDeathSD = {};

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.PlayerDeathSD.LogEventDeath(player, args)
    print("Player [" .. args.player_name .. "] died within a designated Event Zone at " .. args.playerdeath_x .. "," .. args.playerdeath_y)
end

function Commands.PlayerDeathSD.LogHCDeath(player, args)
    print("Player [" .. args.player_name .. "] died in Hardcore mode at " .. args.playerdeath_x .. "," .. args.playerdeath_y)
end

function Commands.PlayerDeathSD.LogSSFDeath(player, args)
    print("Player [" .. args.player_name .. "] died in Solo-Self Found mode at " .. args.playerdeath_x .. "," .. args.playerdeath_y)
end

function Commands.PlayerDeathSD.LogHCSSFDeath(player, args)
    print("Player [" .. args.player_name .. "] died in Hardcore Solo-Self Found mode at " .. args.playerdeath_x .. "," .. args.playerdeath_y)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    Events.OnClientCommand.Add(onClientCommand);
end