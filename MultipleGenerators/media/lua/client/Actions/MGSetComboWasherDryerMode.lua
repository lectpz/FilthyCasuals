require "TimedActions/ISSetComboWasherDryerMode"

function ISSetComboWasherDryerMode:perform()
	local obj = self.object
	local args = { x = obj:getX(), y = obj:getY(), z = obj:getZ(), mode = self.mode }
	sendClientCommand(self.character, 'comboWasherDryer', 'setMode', args)
	sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
	
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end


