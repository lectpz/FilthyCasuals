require "TimedActions/ISBaseTimedAction"

DisActivateDistillery = ISBaseTimedAction:derive("DisActivateDistillery");

function DisActivateDistillery:isValid()
    return self.distillery:getObjectIndex() ~= -1
end

function DisActivateDistillery:start()
	self:setActionAnim("Loot")
	self.character:SetVariable("LootPosition", "Mid")
    self.sound = self.character:playSound("LightSwitch");

    CDistillerySystem.instance:sendCommand(self.character,"activateDistillery", { { x = self.distillery:getX(), y = self.distillery:getY(), z = self.distillery:getZ() }, self.active})
end

function DisActivateDistillery:waitToStart()
    self.character:faceThisObject(self.distillery)
    return self.character:shouldBeTurning()
end

function DisActivateDistillery:update()
    self.character:faceThisObject(self.distillery)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function DisActivateDistillery:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function DisActivateDistillery:perform()
    ISBaseTimedAction.perform(self);
end

function DisActivateDistillery:new(character, distillery, active)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.distillery = distillery
    o.active = active
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 10
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end