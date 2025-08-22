if not isClient() then return end 

require "PZwaystoneclientcore"



function PZwaystone.OnServerCommand(module, command, arguments)



    if module =="PZwaystone" then 

        if command =="getwaystoneinfo" then 
            getGameTime():getModData().PZwaystone = arguments
        end


    end





end

Events.OnServerCommand.Add(PZwaystone.OnServerCommand)