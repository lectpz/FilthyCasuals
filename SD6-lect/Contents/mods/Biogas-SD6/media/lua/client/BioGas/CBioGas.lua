require "Map/CGlobalObject"

CBioGas = CGlobalObject:derive("CBioGas")

function CBioGas:new(luaSystem, globalObject)
	local o = CGlobalObject.new(self, luaSystem, globalObject)
	return o
end

function CBioGas:fromModData(modData)
    self.methane = modData["methane"];
    self.biowaste = modData["biowaste"];
    self.fertilizer = modData["fertilizer"];
    self.exterior = modData["exterior"];
end