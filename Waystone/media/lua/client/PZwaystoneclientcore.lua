PZwaystone = {}

function PZwaystone.getstringpos(x,y,z)
    return tostring(x).."_"..tostring(y).."_" ..tostring(z)
end

function PZwaystone.getposdist(table1,table2)
    return ((table1[1]  - table2[1])^2 + (table1[2]  - table2[2])^2)^0.5
end



function PZwaystone.playerupdate()

    if getGameTime():getModData().PZwaystone == nil then
        return
    end


    for k,v in pairs(getGameTime():getModData().PZwaystone) do

        local square = getCell():getGridSquare(v.postion[1],v.postion[2],v.postion[3])


        if square then

            local object = square:getObjects()
            local ishaveobject

            if object then

                for ik=1,object:size() do
                    local isosprite = object:get(ik-1):getSprite()
                    if isosprite then
                        if isosprite:getName() == "PZwaystone_0" then
                            ishaveobject = true
                            break
                        end


                    end
                end
                

    
            end

            if not ishaveobject then

                getGameTime():getModData().PZwaystone[k] =nil
                if isClient() then

                    sendClientCommand("PZwaystone","deletewaystone",{k})


                    
                end
                
            end
            



        end


    
    
    end







end


Events.EveryOneMinute.Add(PZwaystone.playerupdate)
