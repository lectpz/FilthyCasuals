require "PZwaystoneclientcore"






function PZwaystone.contexttele(object,player,sq)


    -- local playerObj = getSpecificPlayer(player)

    if sq and luautils.walkAdj(player, sq) then

        ISTimedActionQueue.add(PZwaystone.action:new(player, object))
        if isClient() then
            sendClientCommand("PZwaystone","getwaystoneinfo",{})
        end
    end
end

function PZwaystone.contextmenu(player, context, worldobjects, test)

    local playerObj = getSpecificPlayer(player)
    -- print(worldobjects)
    for i,v in pairs(worldobjects) do


        -- print(i,v)

        local isosprite = v:getSprite()

        if isosprite then
            isosprite:getName()

            -- print(isosprite:getName())

            if isosprite:getName() == "PZwaystone_0" then
                local sq = v:getSquare()

                local submenu = context:addOption(getText("IGUI_PZwaystone_tele"), v, PZwaystone.contexttele,playerObj,sq)


                
                return


            end

        end
    end





end



Events.OnPreFillWorldObjectContextMenu.Add(PZwaystone.contextmenu)