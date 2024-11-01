require "TimedActions/ISBaseTimedAction"

HBGDrainFertilizer = ISBaseTimedAction:derive("HBGDrainFertilizer");

function HBGDrainFertilizer:isValid()
    return self.homebiogas:getObjectIndex() ~= -1 and not self.homebiogas:getSquare():isInARoom()
end

function HBGDrainFertilizer:start()
    self:setActionAnim("fill_container_tap")
    --self.sound = self.character:playSound("GetWaterFromTap");

    local bucket = self.bucket

    if bucket:getType() == "BucketEmpty" then
        local inv = self.character:getInventory()
        
        inv:Remove(bucket)
        bucket = InventoryItemFactory.CreateItem("Biofuel.BucketFertilizerFull");
        bucket:setDelta(0)
        inv:addItem(bucket)
    end

    local bucketCurrentLevel = round(bucket:getDelta(),3)
    local bucketDelta = bucket:getUseDelta()
    local bucketMaxCapacity = 1/bucketDelta
    local bucketSpace = (1 - bucketCurrentLevel) * bucketMaxCapacity
    local data = self.homebiogas:getModData()
    local newFertilizer = 0
    local filledAmount = 0

    if bucketSpace > data["fertilizer"] then
        newFertilizer = data["fertilizer"] * bucketDelta + bucketCurrentLevel
        filledAmount = data["fertilizer"]
    else
        newFertilizer = ( bucketSpace * bucketDelta ) + bucketCurrentLevel
        filledAmount = bucketSpace
    end
    
    self.action:setTime((filledAmount * 10) + 30)

    if newFertilizer > 0 then
        bucket:setUsedDelta(newFertilizer)
    end

    if bucket:getUsedDelta() > 1 then
        bucket:setUsedDelta(1)
    end

    CBioGasSystem.instance:sendCommand(self.character,"drainFertilizer", { { x = self.homebiogas:getX(), y = self.homebiogas:getY(), z = self.homebiogas:getZ() }, filledAmount})
end

function HBGDrainFertilizer:waitToStart()
    self.character:faceThisObject(self.homebiogas)
    return self.character:shouldBeTurning()
end

function HBGDrainFertilizer:update()
    self.character:faceThisObject(self.homebiogas)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function HBGDrainFertilizer:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function HBGDrainFertilizer:perform()
    ISBaseTimedAction.perform(self);
end

function HBGDrainFertilizer:new(character, homebiogas, bucket)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.homebiogas = homebiogas
    o.bucket = bucket
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 10
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end