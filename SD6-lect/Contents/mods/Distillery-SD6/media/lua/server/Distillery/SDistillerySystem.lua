if isClient() then return end

require "Map/SGlobalObjectSystem"

SDistillerySystem = SGlobalObjectSystem:derive("SDistillerySystem")

function SDistillerySystem:new()
    return SGlobalObjectSystem.new(self, "Distillery")
end

function SDistillerySystem:initSystem()
	SGlobalObjectSystem.initSystem(self)

	-- Specify GlobalObjectSystem fields that should be saved.
	self.system:setModDataKeys({})
	
	-- Specify GlobalObject fields that should be saved.
	self.system:setObjectModDataKeys({'mode', 'active', 'input', 'tank', 'hasPower'})
end

function SDistillerySystem:newLuaObject(globalObject)
    return SDistillery:new(self, globalObject)
end

function SDistillerySystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "distillery_tileset_01_0"
end

function SDistillerySystem.isValidModData(modData)
    return modData.tank ~= nil
end

function SDistillerySystem:OnClientCommand(command, playerObj, args)
    SDistillerySystemCommands[command](playerObj, args)
end

function SDistillerySystem:checkPower(dis)
    
    local worldPower = getWorld():isHydroPowerOn()
    local square = dis:getIsoObject():getSquare()
    
    if square then
        if worldPower and not square:isOutside() then
            dis.hasPower = true
        elseif square:haveElectricity() then
            dis.hasPower = true
        else
            dis.hasPower = false
        end
    end

    return dis.hasPower
end

function SDistillerySystem:distill()
    local maxTankAmount = SandboxVars.Distillery.maxTankAmount
    local amountPerProcess = SandboxVars.Distillery.maxTankAmount / SandboxVars.Distillery.processTime
    local currentPower = false

    for i=1,self.system:getObjectCount() do
        local still = self.system:getObjectByIndex(i-1):getModData()
        
        if still:getIsoObject() ~= nil then
            currentPower = SDistillerySystem:checkPower(still)
        end

        if still.active and still.input > 0 then
            if currentPower then
                still.input = still.input - amountPerProcess

                if still.input < 0 then
                    still.input = 0                
                end

                still.tank = still.tank + amountPerProcess

                if still.tank >= maxTankAmount then 
                    still.tank = maxTankAmount
                end

                if still.input == 0 and still.active then
                    still.active = false
                end
                
                print(string.format("mode: %s input: %.2f tank: %.2f",still.mode,still.input,still.tank))   
            else
                still.active = false
            end

            still:saveData(true)
        end
    end                     
end

function SDistillerySystem.sandbox()
    Events.EveryHours.Add(function()SDistillerySystem.instance:distill() end)
end

Events.OnInitGlobalModData.Add(SDistillerySystem.sandbox)

SGlobalObjectSystem.RegisterSystemClass(SDistillerySystem)