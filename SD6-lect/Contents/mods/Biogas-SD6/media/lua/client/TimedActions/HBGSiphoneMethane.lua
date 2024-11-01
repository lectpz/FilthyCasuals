require "TimedActions/ISBaseTimedAction"

HBGSiphonMethane = ISBaseTimedAction:derive("HBGSiphonMethane");

function HBGSiphonMethane:isValid()
    return self.homebiogas:getObjectIndex() ~= -1 and not self.homebiogas:getSquare():isInARoom()
end

function HBGSiphonMethane:start()
    self:setActionAnim("Loot")
	self.character:SetVariable("LootPosition", "Mid")    
	self.sound = self.character:playSound("BBQPropaneTankRemove")

    local tank = self.tank
    local tankCurrentLevel = round(tank:getDelta(),3)
    local tankDelta = tank:getUseDelta()
    local tankMaxCapacity = 1/tankDelta
    local tankSpace = (1 - tankCurrentLevel) * tankMaxCapacity
    local data = self.homebiogas:getModData()
    local newMethane = 0
    local filledAmount = 0

    if tankSpace > data["methane"] then
        newMethane = data["methane"] * tankDelta + tankCurrentLevel
        filledAmount = data["methane"]
    else
        newMethane = ( tankSpace * tankDelta ) + tankCurrentLevel
        filledAmount = tankSpace
    end
    
    self.action:setTime((filledAmount * 10) + 30)

    if newMethane > 0 then
        tank:setUsedDelta(newMethane)
    end

    if tank:getUsedDelta() > 1 then
        tank:setUsedDelta(1)
    end

    CBioGasSystem.instance:sendCommand(self.character,"siphonMethane", { { x = self.homebiogas:getX(), y = self.homebiogas:getY(), z = self.homebiogas:getZ() }, filledAmount})
end

function HBGSiphonMethane:waitToStart()
    self.character:faceThisObject(self.homebiogas)
    return self.character:shouldBeTurning()
end

function HBGSiphonMethane:update()
    self.character:faceThisObject(self.homebiogas)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function HBGSiphonMethane:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function HBGSiphonMethane:perform()
    ISBaseTimedAction.perform(self);
end

function HBGSiphonMethane:new(character, homebiogas, tank)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.homebiogas = homebiogas
    o.tank = tank
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 30
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end

