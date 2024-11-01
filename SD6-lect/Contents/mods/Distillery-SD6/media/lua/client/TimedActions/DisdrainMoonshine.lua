require "TimedActions/ISBaseTimedAction"

DisdrainMoonshine = ISBaseTimedAction:derive("DisdrainMoonshine");

function DisdrainMoonshine:isValid()
    return self.distillery:getObjectIndex() ~= -1
end

function DisdrainMoonshine:start()
    self:setActionAnim("fill_container_tap")
    self:setOverrideHandModels("Base.Pot", nil)
	--self.sound = self.character:playSound("GetWaterFromTap")

    local pot = self.pot

    if pot:getType() == "Pot" then
        local inv = self.character:getInventory()
        
        inv:Remove(pot)

        pot = InventoryItemFactory.CreateItem("Biofuel.UnfilteredMoonshinePot")

        inv:addItem(pot)
    end

    CDistillerySystem.instance:sendCommand(self.character,"drainMoonshine", { { x = self.distillery:getX(), y = self.distillery:getY(), z = self.distillery:getZ() } })
end

function DisdrainMoonshine:waitToStart()
    self.character:faceThisObject(self.distillery)
    return self.character:shouldBeTurning()
end

function DisdrainMoonshine:update()
    self.character:faceThisObject(self.distillery)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function DisdrainMoonshine:stopSound()
	if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound);
	end
end

function DisdrainMoonshine:stop()
    --self:stopSound();

    ISBaseTimedAction.stop(self);
end

function DisdrainMoonshine:perform()
    --self:stopSound();
    --self.character:stopOrTriggerSound(self.sound)
    ISBaseTimedAction.perform(self);
end

function DisdrainMoonshine:new(character, distillery, pot)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.distillery = distillery
    o.pot = pot
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = 90
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end

