require "TimedActions/ISBaseTimedAction"

DisdistillEthanol = ISBaseTimedAction:derive("DisdistillEthanol");

function DisdistillEthanol:isValid()
    return self.distillery:getObjectIndex() ~= -1
end

function DisdistillEthanol:start()
    self:setActionAnim("Pour")
    self:setOverrideHandModels("Base.Pot", nil)
	self.sound = self.character:playSound("PourWaterIntoObject")

    local newData = {}

    newData["mode"] = "ethanol"
    newData["tank"] = 0
    newData["input"] = 8
    newData["active"] = true

    CDistillerySystem.instance:sendCommand(self.character,"redistillEthanol", { { x = self.distillery:getX(), y = self.distillery:getY(), z = self.distillery:getZ() }, newData})
end

function DisdistillEthanol:waitToStart()
    self.character:faceThisObject(self.distillery)
    return self.character:shouldBeTurning()
end

function DisdistillEthanol:update()
    self.character:faceThisObject(self.distillery)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function DisdistillEthanol:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function DisdistillEthanol:perform()
    ISBaseTimedAction.perform(self);
end

function DisdistillEthanol:new(character, distillery)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.distillery = distillery
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 90
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end

