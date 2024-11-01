require "TimedActions/ISBaseTimedAction"

DisAddInput = ISBaseTimedAction:derive("DisAddInput");

function DisAddInput:isValid()
    return self.distillery:getObjectIndex() ~= -1
end

function DisAddInput:start()
    self:setActionAnim("Pour")
    self:setOverrideHandModels("Base.Pot", nil)
    self.sound = self.character:playSound("PourWaterIntoObject")

    CDistillerySystem.instance:sendCommand(self.character,"addInput", { { x = self.distillery:getX(), y = self.distillery:getY(), z = self.distillery:getZ() }, self.item})
    self.character:getInventory():Remove(self.item)
end

function DisAddInput:waitToStart()
    self.character:faceThisObject(self.distillery)
    return self.character:shouldBeTurning()
end

function DisAddInput:update()
    self.character:faceThisObject(self.distillery)
end

function DisAddInput:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function DisAddInput:perform()
    self.character:getInventory():AddItem("Base.Pot")

    ISBaseTimedAction.perform(self);
end

function DisAddInput:new(character, distillery, item)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.distillery = distillery
    o.item = item
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 120; --(90 - (character:getPerkLevel(Perks.Farming) - 3) * 10) * 2 * getGameTime():getMinutesPerDay() / 10 --2 hours at level 3, ~half at level 10 --- temp /10
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end
