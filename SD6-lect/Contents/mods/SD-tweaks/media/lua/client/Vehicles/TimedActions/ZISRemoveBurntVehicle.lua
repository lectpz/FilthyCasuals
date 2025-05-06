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
		if self:checkAddItem("MetalBar", 23) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 30) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 33) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 21) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 21) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
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