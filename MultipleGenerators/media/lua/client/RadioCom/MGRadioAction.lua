require "RadioCom/ISRadioAction"

function ISRadioAction:performToggleOnOff()
    if self:isValidToggleOnOff() then
        if self.character then
            self.character:playSound(self.deviceData:getIsTurnedOn() and "TelevisionOff" or "TelevisionOn")
        end
        self.deviceData:setIsTurnedOn( not self.deviceData:getIsTurnedOn() );
        sendClientCommand(self.character, 'mg_commands', 'update_generators', {sync=false})
    end
end