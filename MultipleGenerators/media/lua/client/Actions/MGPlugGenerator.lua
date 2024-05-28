require "TimedActions/ISPlugGenerator"

function ISPlugGenerator:perform()
    -- base_perform(self)   

	self.character:stopOrTriggerSound(self.sound)
    self.generator:setConnected(self.plug)

    local x = self.generator:getX()
    local y = self.generator:getY()
    local z = self.generator:getZ()
    local fuel = self.generator:getFuel()
    
    if self.plug then
        VirtualGenerator.Add(x, y, z, fuel)
        
    else
        VirtualGenerator.Remove(x, y, z)
    end
    print ("PLUG WORKED")

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end
