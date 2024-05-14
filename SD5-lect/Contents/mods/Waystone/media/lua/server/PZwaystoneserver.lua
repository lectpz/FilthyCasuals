require "PZwaystoneclientcore"
require "PZwaystonepanel"


if not isServer() then return end


function PZwaystone.OnClientCommand(module, command, player,arguments)

    if module =="PZwaystone" then

        

        if command =="getwaystoneinfo" then

            if getGameTime():getModData().PZwaystone ==nil  then
                getGameTime():getModData().PZwaystone={}
            end

            sendServerCommand(player,"PZwaystone", "getwaystoneinfo",getGameTime():getModData().PZwaystone)
        elseif command =="newwaystone" then

            getGameTime():getModData().PZwaystone[arguments[1]] = arguments[2]

            sendServerCommand("PZwaystone", "getwaystoneinfo",getGameTime():getModData().PZwaystone)
            
        elseif command =="deletewaystone" then

            getGameTime():getModData().PZwaystone[arguments[1]] = nil
            sendServerCommand("PZwaystone", "getwaystoneinfo",getGameTime():getModData().PZwaystone)
			
        end
            


    end


end

Events.OnClientCommand.Add(PZwaystone.OnClientCommand)

--server code

local function SD5_EventReward_onClientCommand(module, command, player, args)
	if module == "SD5_EventReward_ClientCommands" then
		if command == "ResetEventReward" then
			args = {}
			sendServerCommand('SD5_EventReward_ServerCommands', 'ResetEventReward', args)
		end
	end
end

Events.OnClientCommand.Add(SD5_EventReward_onClientCommand)