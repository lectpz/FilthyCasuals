require "TimedActions/ISBaseTimedAction"

SDTeleporterAction = ISBaseTimedAction:derive("SDTeleporterAction");

function SDTeleporterAction:isValid()
	return true;
end

function SDTeleporterAction:waitToStart()
    return false;
end

function SDTeleporterAction:update()
end

function SDTeleporterAction:start()
	getSoundManager():PlayWorldSound("teleporter", false, self.character:getCurrentSquare(), 30, 3, 10, false) ;

	local soundRadius = 4
	local volume = 8
	addSound(self.character,
				self.character:getX(),
				self.character:getY(),
				self.character:getZ(),
				soundRadius,
				volume)
end

function SDTeleporterAction:stop()

	getSoundManager():stop();
	ISBaseTimedAction.stop(self);

end

function SDTeleporterAction:perform()

    sendClientCommand(self.character, 'SDT', self.command, self.args);

	ISBaseTimedAction.perform(self);
end

function SDTeleporterAction:new(character, command, args)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    o.character = character
    o.command = command
    o.args = args
	o.gameSound = 0
	o.maxTime = 500
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true
    if o.character:isTimedActionInstant() then o.maxTime = 1; end

	return o;
end