function ISToggleStoveAction:perform()
	self.object:Toggle()
	sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end
