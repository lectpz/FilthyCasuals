require "PZwaystoneclientcore"
require "TimedActions/ISBaseTimedAction"

PZwaystone.action = ISBaseTimedAction:derive("PZwaystone.action");              
function PZwaystone.action:isValid()                        
	return true
end

function PZwaystone.action:update()                          
end

function PZwaystone.action:start()
    self:setActionAnim("nil")                     
end

function PZwaystone.action:stop()                             
    ISBaseTimedAction.stop(self);
end

function PZwaystone.action:perform()


    local waystonepanel  =PZwaystone.mainpanel:new(getMouseX(),getMouseY(),500,600 , self.object,self.character);
    waystonepanel:initialise();
    waystonepanel:addToUIManager();

	
	ISBaseTimedAction.perform(self);
end

function PZwaystone.action:new(character, object)     
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 100;
	o.timer = 1;
	o.tick = 0;
    o.object = object;
	return o;
end



