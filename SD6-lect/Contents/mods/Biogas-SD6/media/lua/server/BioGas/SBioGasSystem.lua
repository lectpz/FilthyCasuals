if isClient() then return end

require "Map/SGlobalObjectSystem"

SBioGasSystem = SGlobalObjectSystem:derive("SBioGasSystem")

function SBioGasSystem:new()
    return SGlobalObjectSystem.new(self, "HomeBioGas")
end

function SBioGasSystem:initSystem()
	SGlobalObjectSystem.initSystem(self)

	-- Specify GlobalObjectSystem fields that should be saved.
	self.system:setModDataKeys({})
	
	-- Specify GlobalObject fields that should be saved.
	self.system:setObjectModDataKeys({'methane', 'biowaste', 'fertilizer', 'exterior'})
end

function SBioGasSystem:newLuaObject(globalObject)
    return SBioGas:new(self, globalObject)
end

function SBioGasSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "biogas_tileset_01_0"
end

function SBioGasSystem.isValidModData(modData)
    return modData.methane ~= nil
end

function SBioGasSystem:OnClientCommand(command, playerObj, args)
    SBioGasSystemCommands[command](playerObj, args)
end

function SBioGasSystem.playerInVicinity(luahbg)
    local square = getSquare(luahbg.x,luahbg.y,luahbg.z)
    --square = getSquare(10923,9773,0)
    local area = {}

    --luautils.getNextTiles
    if square then
        print("square:",square)
        area = luautils.getNextTiles(square:getCell(), square, 2)
        print("area:",area)
    end

    for _,gs in ipairs(area) do
        if not (gs == nil) then
            if gs:getPlayer() then
                return true
            end
        end
    end
    return false
end

function SBioGasSystem.getModifiedOutput()
    local cutOffTemp = SandboxVars.BioGas.cutOffTemp
    local minTemp = SandboxVars.BioGas.minTemp
    local maxTemp = SandboxVars.BioGas.maxTemp

    local currentTemp = round(getClimateManager():getTemperature())
    local output = 0

    if currentTemp <= cutOffTemp then
        return output
    end
    
    if currentTemp <= minTemp then
        output = .25
        return output
    end

    if currentTemp >= ( maxTemp + 10 ) then
        output = .9
        return output        
    end

    if currentTemp >= maxTemp and currentTemp <= ( maxTemp + 5 ) then
        output = 1
        return output
    end

    if currentTemp <= ( maxTemp + 10 ) and currentTemp >= ( maxTemp + 5 ) then
        --max % - current temp - max temp + 5 * 2
        output = ((100 - ((currentTemp - (maxTemp + 5)) * 2)) / 100)
        return output
    end

    --max % - min % / maxTemp - minTemp * currentTemp - minTemp + min %
    output = ((((75 / (maxTemp - minTemp))*(currentTemp - minTemp)) + 25) / 100)

    
    return output
end

function SBioGasSystem:processBiowaste()
    local tempEfficiency = SandboxVars.BioGas.tempEfficiency
    local MethaneDailyRate = SandboxVars.BioGas.MethaneDailyRate
    local FertilizerDailyRate = SandboxVars.BioGas.FertilizerDailyRate
    local MaxMethane = SandboxVars.BioGas.MaxMethane
    local MaxFertilizer = SandboxVars.BioGas.MaxFertilizer
    local BioWasteDayConsumption = SandboxVars.BioGas.BiowasteDayConsumptionRate

    local BioWasteHourlyConsumption = (BioWasteDayConsumption / 24)
    local MethaneHourlyRate = (MethaneDailyRate / 24)
    local FertilizerHourlyRate = (FertilizerDailyRate / 24)

    local tempModifier = 1

    for i=1,self.system:getObjectCount() do
        local hbg = self.system:getObjectByIndex(i-1):getModData()

        if tempEfficiency then
            tempModifier = self.getModifiedOutput(hbg:getSquare())
        end

        local updatedValues = {}

        if tempModifier == 0 or hbg.biowaste < BioWasteHourlyConsumption then
            --print("Object: "..i.." No Biowaste.")
        else
            updatedValues["biowaste"] = hbg.biowaste - BioWasteHourlyConsumption
            --print("Biowaste Consumption: ",BioWasteHourlyConsumption)
        
            if hbg.methane < MaxMethane or hbg.fertilizer < MaxFertilizer then
                updatedValues["BioGas"] = hbg.methane + (MethaneHourlyRate * tempModifier)

                if updatedValues["BioGas"] >= MaxMethane then
                    updatedValues["BioGas"] = MaxMethane
                end

                updatedValues["Fertilizer"] = hbg.fertilizer + (FertilizerHourlyRate * tempModifier)

                if updatedValues["Fertilizer"] >= MaxFertilizer then
                    updatedValues["Fertilizer"] = MaxFertilizer
                end
            end

            if updatedValues["BioGas"] ~= nil then
                hbg.methane = round(updatedValues["BioGas"],2)
            end
            
            if updatedValues["biowaste"] ~= nil then
                hbg.biowaste = round(updatedValues["biowaste"],2)
            end

            if updatedValues["Fertilizer"] ~= nil then
                hbg.fertilizer = round(updatedValues["Fertilizer"],2)
            end

            hbg:saveData(true)

            --print(string.format("Object: "..i.." BioWaste: %d Current Modifier: %.2f Updated BioGas: %.2f Updated Fertilizer: %.2f",updatedValues["biowaste"],tempModifier,updatedValues["BioGas"],updatedValues["Fertilizer"]))
        end
    end                     
end

function SBioGasSystem:addBioWaste()
    local waste = 0
    local maxWaste = SandboxVars.BioGas.MaxBiowaste

    for i=1,self.system:getObjectCount() do
        local hbg = self.system:getObjectByIndex(i-1):getModData()
        local isohbg = hbg:getIsoObject()
        
        --if not SBioGasSystem.playerInVicinity(hbg) then
            if isohbg then
                if not (hbg.biowaste == maxWaste) then
                    local biowastecontainer = isohbg:getContainer()
                    local foodList = biowastecontainer:getAllCategory("Food")
                    
                    if foodList:size() > 0 then
                        for v=1,foodList:size() do
                            local item = foodList:get(v-1)
                            if hbg.biowaste < maxWaste then
                                hbg.biowaste = hbg.biowaste + item:getCalories()
                                if item:getReplaceOnUse() then biowastecontainer:AddItem(item:getReplaceOnUse()) end
                                biowastecontainer:Remove(item)
                            end
                        end

                        if hbg.biowaste > maxWaste then
                            hbg.biowaste = maxWaste
                        end
                        isohbg:sendObjectChange("containers")
                        hbg:saveData(true)
                    end
                end
            end
        --end
    end
end

function SBioGasSystem.sandbox()
    --Events.EveryTenMinutes.Add(function()SBioGasSystem.instance:addBioWaste() end)
    Events.EveryHours.Add(function()SBioGasSystem.instance:processBiowaste() end)
end

Events.OnInitGlobalModData.Add(SBioGasSystem.sandbox)

SGlobalObjectSystem.RegisterSystemClass(SBioGasSystem)