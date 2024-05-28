--
-- ********************************
-- *** Multiple Generators      ***
-- ********************************
-- *** Coded by: Slayer         ***
-- ********************************
--

local MGGeneratorInfoAction = require("Actions/MGGeneratorInfoAction")
require "MGUI/MGGeneratorInfoWindow"

function DBGListVirtualGenerators (player, square)
    local generatorList = VirtualGenerator.GetAll()
    for k, v in pairs(generatorList) do
        print ("K: " .. k .. " X: " .. v.x .. " Y: " .. v.y .. " Z: " .. v.z )
    end
end

function DBGSetMinFuel (player, generator)
    generator:setFuel(0.25)
    generator:transmitModData()
end

function MGOnInfoGenerator (playerObj, generator)
	if luautils.walkAdj(playerObj, generator:getSquare()) then
		ISTimedActionQueue.add(MGGeneratorInfoAction:new(playerObj, generator))
	end
end

function MGOnInfoGenerator2(player, generator)
    local ui = MGGeneratorInfoWindow:new(0, 0, 300, 300, player, generator)
    local x = player
    local y = generator
    ui:initialise()
    ui:addToUIManager()
end


function MGContextMenuPre(player, context, worldobjects, test)
end

function MGContextMenu(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
    local square = clickedSquare

    local generatorInfoOption = context:getOptionFromName(getText("ContextMenu_GeneratorInfo"))
    if generatorInfoOption then

        local generator = square:getGenerator()
        if generator then
            local x = generator:getX()
            local y = generator:getY()
            local z = generator:getZ()
            vg = VirtualGenerator.Get (x, y, z)
            
            if generator:isConnected() and not vg then
                local fuel = generator:getFuel()
                VirtualGenerator.Add (x, y, z, fuel)
                sendClientCommand(playerObj, 'mg_commands', 'update_generators', {sync=false})
            end

            -- local tooltipGeneratorInfo = ISToolTip:new()
            -- tooltipGeneratorInfo:setName(getText("ContextMenu_GeneratorInfo"))
            -- tooltipGeneratorInfo.description = MGGeneratorInfoWindow.getRichTextNew(generator)
    
            -- generatorInfoOption = context:addOption(getText("ContextMenu_GeneratorInfo") .. " ", playerObj, MGOnInfoGenerator, generator)
            -- generatorInfoOption = context:addOption(getText("ContextMenu_GeneratorInfo"), playerObj, MGOnInfoGenerator2, generator)

            context:removeOptionTsar(context:getOptionFromName(getText("ContextMenu_GeneratorInfo")))
            local option = context:addOptionOnTop(getText(getText("ContextMenu_GeneratorInfo")), playerObj, MGOnInfoGenerator2, generator)

            -- this method fails with other mods using context:addOptionOnTop
            --context:updateOptionTsar(generatorInfoOption.id, generatorInfoOption.name, generatorInfoOption.target, MGOnInfoGenerator2, generator, playerObj)

        end
    end

end

-- Events.OnPreFillWorldObjectContextMenu.Add(MGContextMenuPre)
Events.OnFillWorldObjectContextMenu.Add(MGContextMenu)
