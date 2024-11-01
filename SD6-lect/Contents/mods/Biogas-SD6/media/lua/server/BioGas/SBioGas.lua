if isClient() then return end

require "Map/SGlobalObject"

SBioGas = SGlobalObject:derive("SBioGas")

function SBioGas:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end

function SBioGas:initNew()
    self.methane = 0;
    self.biowaste = 0;
    self.fertilizer = 0;
    self.exterior = false;
end

function SBioGas:stateFromIsoObject(isoObject)
    self:initNew()

    if SBioGasSystem.isValidModData(isoObject:getModData()) then
        print("Valid Data")
        self:fromModData(isoObject:getModData())
    end
    
    self.exterior = isoObject:getSquare():isInARoom()

    self:saveData(true)
end

function SBioGas:stateToIsoObject(isoObject)

    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
    --print("Methane to: ",self.methane)

end

function SBioGas:fromModData(modData)
    self.methane = modData["methane"];
    self.biowaste = modData["biowaste"];
    self.fertilizer = modData["fertilizer"];
    self.exterior = modData["exterior"];
end

function SBioGas:toModData(modData)
    modData["methane"] = self.methane;
    modData["biowaste"] = self.biowaste;
    modData["fertilizer"] = self.fertilizer;
    modData["exterior"] = self.exterior;
end

function SBioGas:saveData(transmit)
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    self:toModData(isoObject:getModData())
    if transmit then
        isoObject:transmitModData()
    end
end