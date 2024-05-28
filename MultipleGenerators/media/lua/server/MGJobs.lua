function MGEveryTenMinutes()
    MGUpdateGenerators(true)
end

function MGEveryHours()
    MGUpdateGenerators(true)
end


function MGUpdateGenerators (sync)

    -- print ("TIME_START: " .. getTimeInMillis())
    local ts = getTimeInMillis()

    if isClient() then return end

    local cell = getCell()
    local workingGenerators = VirtualGenerator.GetAll()

    -- remove virtual generator if the real one vanished
    for k, generator in pairs(workingGenerators) do
        local square = cell:getGridSquare(generator.x, generator.y, generator.z)
        if square then
            local isoGenerator = MGGenerator.GetGenerator(generator.x, generator.y, generator.z)
            if not isoGenerator then
                -- probably sledgehammered, burned or removed in some other way than unplugging
                VirtualGenerator.Remove(generator.x, generator.y, generator.z)
            end
        end
    end

    -- print ("TIME 1PASS: " .. (getTimeInMillis() - ts))

    -- reset powered items as if it there was only one generator
    MGGenerator.squareSkipCache = {}
    for k, generator in pairs(workingGenerators) do
        if not generator.poweredItems then generator.poweredItems = {} end

        local square = cell:getGridSquare(generator.x, generator.y, generator.z)
        if square then
            if generator.state then
                local poweredItems = MGGenerator.GetSurroundingPowerItems(generator.x, generator.y, generator.z)
                generator.poweredItems = poweredItems
            end
        end
    end

    -- print ("TIME 2PASS: " .. (getTimeInMillis() - ts))

    --recalculate powered items checking if there are more than one generator
    for k1, generator1 in pairs(workingGenerators) do
        if generator1.state then
            for l1, item1 in pairs (generator1.poweredItems) do
                item1.div = 1
                for k2, generator2 in pairs(workingGenerators) do
                    if generator2.state and k1 ~= k2 and math.abs(generator1.x - generator2.x) < 41 and math.abs(generator1.y - generator2.y) < 41  then
                        for l2, item2 in pairs (generator2.poweredItems) do
                            if item1.x == item2.x and item1.y == item2.y and item1.z == item2.z then
                                item1.div = item1.div + 1
                            end
                        end
                    end
                end
            end
        end
    end

    -- print ("TIME 3PASS: " .. (getTimeInMillis() - ts))

    -- update generators fuel
	local fuelConsumption = getSandboxOptions():getOptionByName("GeneratorFuelConsumption"):getValue()
    -- print ("FC: " .. fuelConsumption)
    for k, generator in pairs(workingGenerators) do
        if generator.state then
            local groupPoweredItems = {}
            local total = 0.02 -- 0.148
            local realTotal = 0.02 -- 0.148

            for k, item in pairs(generator.poweredItems) do
                item.realPower = item.power / item.div
                if groupPoweredItems[item.name] then
                    groupPoweredItems[item.name].realPower = groupPoweredItems[item.name].realPower + item.realPower
                    groupPoweredItems[item.name].times = groupPoweredItems[item.name].times + 1
                else
                    groupPoweredItems[item.name] = item
                    groupPoweredItems[item.name].realPower = item.realPower
                    groupPoweredItems[item.name].times = 1
                end
                total = total + item.power
                realTotal = realTotal + item.realPower
            end 

            generator.groupPoweredItems = groupPoweredItems
            generator.totalPower = total
            generator.realTotalPower = realTotal
            generator.totalFuelConsumption = total * fuelConsumption
            generator.realTotalFuelConsumption = realTotal * fuelConsumption

            if not generator.fuel then generator.fuel = 0 end

            local interval = 6 -- 6 for 10 minutes, 1 for and hour

            local hourlyRealConsumptionPercent = realTotal * 100 / (100 / fuelConsumption)
            local intervalRealConsumptionPercent = hourlyRealConsumptionPercent / interval
            generator.fuel = generator.fuel - intervalRealConsumptionPercent
            if generator.fuel < 0 then generator.fuel = 0 end

            
            -- print ("K: " .. k .. " X: " .. generator.x .. " Y: " .. generator.y .. "R: " .. realTotal .. " F: " .. string.format("%.3f", generator.fuel) .. " (-".. string.format("%.3f", intervalRealConsumptionPercent) .. ")")

            local isoGenerator = MGGenerator.GetGenerator(generator.x, generator.y, generator.z)
            if isoGenerator then

                local realFuel = isoGenerator:getFuel()
                isoGenerator:setFuel(generator.fuel)

                --[[ reverse compatibility to be removed
                if realFuel < generator.fuel then
                    isoGenerator:setFuel(generator.fuel)
                else
                    generator.fuel = realFuel
                end]]

                if generator.fuel == 0 then
                    if isoGenerator:isActivated() then
                        isoGenerator:setActivated(false)
                    end
                    generator.state = false
                else
                    if not isoGenerator:isActivated() then
                        isoGenerator:setActivated(true)
                    end
                    generator.state = true
                end

                isoGenerator:transmitModData()
                -- isoGenerator:update()
                
            end
        end

        if not generator.realTotalPowerHistory then
            generator.realTotalPowerHistory = {}
        end
        if #generator.realTotalPowerHistory > 288 then
            table.remove(generator.realTotalPowerHistory, 1)
        end
        if generator.state and generator.realTotalPower then
            -- print ("HISTORY: " .. generator.realTotalPower)
            table.insert(generator.realTotalPowerHistory, generator.realTotalPower)
        else
            -- print ("HISTORY: 0")
            table.insert(generator.realTotalPowerHistory, 0)
        end

    end

    TransmitMGModData()

    -- print ("TIME ALL: " .. (getTimeInMillis() - ts))

end

print ("-------------------------------")
print ("- multigenerators jobs active -")
print ("-------------------------------")

Events.EveryTenMinutes.Add(MGEveryTenMinutes)
-- Events.EveryHours.Add(MGEveryHours)