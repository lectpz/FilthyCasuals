MGGenerator = {}

MGGenerator.squareSkipCache = {}

function MGGenerator.GetPoweredItemName (object)
    
    local name = getText("IGUI_VehiclePartCatOther")

    local propertyContainer = object:getProperties()
        
    if propertyContainer and propertyContainer:Is("CustomName") then
        local moveableName = "Moveable Object"

        if propertyContainer:Is("GroupName") then
            moveableName = propertyContainer:Val("GroupName") .. " " .. propertyContainer:Val("CustomName")
        else
            moveableName = propertyContainer:Val("CustomName")
        end
    
        name = Translator.getMoveableDisplayName(moveableName)

    end

    if instanceof(object, "IsoLightSwitch") then
        name = getText("IGUI_Lights")
    end
    return name
end

function MGGenerator.GetSurroundingPowerItems (cx, cy, cz)

    local cell = getCell()

    local poweredItems = {}

    local ts = getTimeInMillis()
    local ps = 0
    local ss = 0

    for z = cz-2, cz+2 do
        for y = cy-20, cy+20 do
            for x = cx-20, cx+20 do
                if z >= 0 and not (IsoUtils.DistanceToSquared(x + 0.5, y + 0.5, cx + 0.5, cy + 0.5) > 400) then
                    sid = tostring(x) .. "-" .. tostring(y) .. tostring(z)
                    if not MGGenerator.squareSkipCache[sid] then
                        ps = ps + 1
                        local tsquare = cell:getGridSquare(x, y, z)
                        if tsquare then
                            local objects = tsquare:getObjects()
                            local foundPoweredItem = false
                            for i=0, objects:size()-1 do
                                local object = objects:get(i)

                                local name = MGGenerator.GetPoweredItemName(object)
                                local power = 0

                                local isClothingDryer = instanceof(object, "IsoClothingDryer") and object:isActivated()
                                local isClothingWasher = instanceof(object, "IsoClothingWasher") and object:isActivated()
                                local isCombinationWasherDryer = instanceof(object, "IsoCombinationWasherDryer") and object:isActivated()
                                local isStackedWasherDryer = instanceof(object, "IsoStackedWasherDryer") and (object:isDryerActivated() or object:isWasherActivated())
                                local isTelevision = instanceof(object, "IsoTelevision") and object:getDeviceData():getIsTurnedOn()
                                local isRadio = instanceof(object, "IsoRadio") and object:getDeviceData():getIsTurnedOn() and not object:getDeviceData():getIsBatteryPowered()
                                local isStove = instanceof(object, "IsoStove") and object:Activated()
                                local isFridge = object:getContainerByType("fridge") ~= nil
                                local isFreezer = object:getContainerByType("freezer") ~= nil
                                local isLights = instanceof(object, "IsoLightSwitch") and object:isActivated()

                                --[[if instanceof(object, "IsoStove") then
                                    print ("found stove")
                                    if object:Activated() then
                                        print ("the stove  is on")
                                    end
                                end]]

                                if isClothingDryer then power = 0.09 end
                                if isClothingWasher then power = 0.09 end
                                if isCombinationWasherDryer then power = 0.09 end
                                if isStackedWasherDryer then power = 0.09 end
                                if isTelevision then power = 0.03 end
                                if isRadio then power = 0.01 end
                                
                                if isStove then 
                                    local temp = object:getCurrentTemperature()
                                    power = 0.09 * temp / 100
                                end

                                if isFridge and isFreezer then
                                    power = 0.13
                                elseif isFridge or isFreezer then
                                    power = 0.08
                                end

                                if isLights then power = 0.002 end

                                if power > 0 then
                                    table.insert(poweredItems, {name=name, power=power, div=1, x=x, y=y, z=z})
                                    foundPoweredItem = true
                                    -- print ("FOUND: " .. name)
                                end
                            end
                            if foundPoweredItem then
                                MGGenerator.squareSkipCache[sid] = false
                            else
                                MGGenerator.squareSkipCache[sid] = true
                            end
                        else
                            MGGenerator.squareSkipCache[sid] = true
                        end
                    else
                        ss = ss + 1
                    end
                end
            end
        end
    end
    -- print ("PROCESSED: " .. ps .. " SKIPPED: " .. ss)
    return poweredItems

end

function MGGenerator.GetGenerator (x, y, z)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if square then
        local objects = square:getSpecialObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoGenerator") then
                return object
            end
        end
    end
    return false
end

