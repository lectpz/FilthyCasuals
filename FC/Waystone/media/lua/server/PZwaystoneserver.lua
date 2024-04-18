require "PZwaystoneclientcore"


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