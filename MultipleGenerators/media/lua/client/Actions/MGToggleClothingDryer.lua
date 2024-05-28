require "TimedActions/ISToggleClothingDryer"

function ISToggleClothingDryer:perform()
	local obj = self.object
	local args = { x = obj:getX(), y = obj:getY(), z = obj:getZ() }
	sendClientCommand(self.character, 'clothingDryer', 'toggle', args)
	sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end
