require "TimedActions/ISBaseTimedAction"

DisDrainGas = ISBaseTimedAction:derive("DisDrainGas");

function DisDrainGas:isValid()
    return self.distillery:getObjectIndex() ~= -1
end

function DisDrainGas:start()
    self:setActionAnim("fill_container_tap")
    self:setOverrideHandModels(self.gascan:getType() or "EmptyPetrol", nil)

    local gascan = self.gascan

	--self.sound = self.character:playSound("GetWaterFromTap");

    if gascan:hasTag("EmptyPetrol") then
        local inv = self.character:getInventory()
        
        inv:Remove(gascan)
        gascan = InventoryItemFactory.CreateItem(gascan:getReplaceType("PetrolSource"));
        gascan:setDelta(0)
        inv:addItem(gascan)
    end

    local gascanCurrentLevel = round(gascan:getDelta(),3)
    local gascanDelta = gascan:getUseDelta()
    local gascanMaxCapacity = 1/gascanDelta
    local gascanSpace = (1 - gascanCurrentLevel) * gascanMaxCapacity
    local data = self.distillery:getModData()
    local newGas = 0
    local filledAmount = 0

    if gascanSpace > data["tank"] then
        newGas = data["tank"] * gascanDelta + gascanCurrentLevel
        filledAmount = data["tank"]
    else
        newGas = ( gascanSpace * gascanDelta ) + gascanCurrentLevel
        filledAmount = gascanSpace
    end
    
    self.action:setTime((filledAmount * 10) + 30)

    if newGas > 0 then
        gascan:setUsedDelta(newGas)
    end

    if gascan:getUsedDelta() > 1 then
        gascan:setUsedDelta(1)
    end

    CDistillerySystem.instance:sendCommand(self.character,"drainGas", { { x = self.distillery:getX(), y = self.distillery:getY(), z = self.distillery:getZ() }, filledAmount})
end

function DisDrainGas:waitToStart()
    self.character:faceThisObject(self.distillery)
    return self.character:shouldBeTurning()
end

function DisDrainGas:update()
    self.character:faceThisObject(self.distillery)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function DisDrainGas:stop()
    --self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function DisDrainGas:perform()
    --self:stopSound();
    ISBaseTimedAction.perform(self);
end

function DisDrainGas:new(character, distillery, gascan)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.distillery = distillery
    o.gascan = gascan
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 30
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end