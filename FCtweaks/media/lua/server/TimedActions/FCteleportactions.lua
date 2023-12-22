require "TimedActions/ISBaseTimedAction"

doFCteleport = ISBaseTimedAction:derive("doFCteleport");

function doFCteleport:isValid()
	return true;
end

function doFCteleport:waitToStart()
    return false;
end

function doFCteleport:update()
end

function doFCteleport:start()
	getSoundManager():PlayWorldSound("s_teleport", false, self.character:getCurrentSquare(), 30, 3, 10, false) ;
	local soundRadius = 3
	local volume = 6
	addSound(self.character,
				self.character:getX(),
				self.character:getY(),
				self.character:getZ(),
				soundRadius,
				volume)
end

function doFCteleport:stop()
	getSoundManager():stop();
	ISBaseTimedAction.stop(self);
end

function doFCteleport:perform()
	ISBaseTimedAction.perform(self);
end

function doFCteleport:new(character, command, args)
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