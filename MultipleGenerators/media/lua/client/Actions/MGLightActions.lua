require "TimedActions/ISLightActions"

function ISLightActions:perform()
    if self.character and self.lightswitch and self.mode then
        if self["perform"..self.mode] then
            self["perform"..self.mode](self);
            sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
        end
    end

    ISBaseTimedAction.perform(self)
end
