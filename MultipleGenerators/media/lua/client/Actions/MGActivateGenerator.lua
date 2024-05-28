require "TimedActions/ISActivateGenerator"

function ISActivateGenerator:perform()
	if self.activate and self.generator:getCondition() <= 50 and ZombRand(2) == 0 then
		self.generator:failToStart()
	else
		self.generator:setActivated(self.activate)
		VirtualGenerator.Toggle (self.generator:getX(), self.generator:getY(), self.generator:getZ(), self.activate, self.generator:getFuel())
		sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
	end

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end
