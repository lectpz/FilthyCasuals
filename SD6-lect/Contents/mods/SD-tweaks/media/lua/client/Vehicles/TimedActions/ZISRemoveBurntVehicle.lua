--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"
require "TimedActions/ISRemoveBurntVehicle"
require "SDZoneCheck"

function ISRemoveBurntVehicle:perform()
	local tierzone = checkZone()
	if self.sound ~= 0 then
		self.character:getEmitter():stopSound(self.sound)
	end
	local totalXp = 5;
	for i=1,math.min(tierzone*2, self.character:getPerkLevel(Perks.MetalWelding)) do
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalBar", 30) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 27) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 37) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 30) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 40) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 30) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 13) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 13) then totalXp = totalXp + 2 end;
		self.vehicle:getSquare():AddWorldInventoryItem("ScrapMetal", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0);
		self.vehicle:getSquare():AddWorldInventoryItem("ScrapMetal", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0);
	end
	for i=1,(15+(tierzone)*2) do
		self.item:Use();
	end
	self.character:getXp():AddXP(Perks.MetalWelding, totalXp);
	sendClientCommand(self.character, "vehicle", "remove", { vehicle = self.vehicle:getId() })
	self.item:setJobDelta(0);
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end