local Commands = {};
Commands.sdContainerSetLooted = {};

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.sdContainerSetLooted.setHasBeenLooted(player, container)
    container:setHasBeenLooted(true)
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