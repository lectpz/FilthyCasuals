local modName = "SandboxSyncFix"
local Daikon = require("daikon_WrapperToMakeTheSettingsIG")
--Udderly Commands
print("["..modName.."] Initializing UdderlyCommands Server..")

Events.OnClientCommand.Add(function(moduleName, command, player, args)
	--print("["..modName.."] OnClientCommand \""..moduleName.."\", \""..command.."\"..")
	if moduleName == modName then
		local commandHandler = Daikon.SandboxOptionsSyncing.CommandHandlers[command]
		if commandHandler then
			print("["..modName.."] Running command \""..command.."\" for player \""..player:getUsername().."\".")
			commandHandler(player, args)
		else
			print("["..modName.."] Unknown command \""..command.."\" from player \""..player:getUsername().."\"!")
		end
	end
end)

print("["..modName.."] Initializing UdderlyCommands Command Handlers..")
Daikon.SandboxOptionsSyncing.CommandHandlers["ForceClientsToUpdate"] = function(player, args)
	Daikon.SandboxOptionsSyncing.ForceClientsToUpdate()
end
Daikon.SandboxOptionsSyncing.CommandHandlers["RefreshModData"] = function(player, args)
	Daikon.SandboxOptionsSyncing.UpdateGlobalModData()
end
Daikon.SandboxOptionsSyncing.CommandHandlers["RefreshAndUpdate"] = function(player, args)
	Daikon.SandboxOptionsSyncing.UpdateGlobalModData()
	Daikon.SandboxOptionsSyncing.ForceClientsToUpdate()
end