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
--		if self:checkAddItem("MetalBar", 15) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("MetalBar", 15) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("MetalBar", 15) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end; -- additional yield on account of fixing propane torches not draining-
--		if self:checkAddItem("MetalPipe", 15) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("MetalPipe", 15) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("MetalPipe", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 25) then totalXp = totalXp + 2 end; -- additional yield on account of fixing propane torches not draining
--		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 28) then totalXp = totalXp + 2 end; -- additional yield on account of fixing propane torches not draining
--		if self:checkAddItem("SmallSheetMetal", 15) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("SmallSheetMetal", 15) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 18) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 18) then totalXp = totalXp + 2 end; -- additional yield on account of fixing propane torches not draining
--		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
--		if self:checkAddItem("ScrapMetal", 12) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 10) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 10) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 10) then totalXp = totalXp + 2 end; -- additional yield on account of fixing propane torches not draining
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