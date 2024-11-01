require "Map/CGlobalObject"

CDistillery = CGlobalObject:derive("CDistillery")

function CDistillery:new(luaSystem, globalObject)
	local o = CGlobalObject.new(self, luaSystem, globalObject)
	return o
end

function CDistillery:fromModData(modData)
    self.mode = modData["mode"];
    self.active = modData["active"];
    self.input = modData["input"];
    self.tank = modData["tank"];
    self.hasPower = modData["hasPower"];
end