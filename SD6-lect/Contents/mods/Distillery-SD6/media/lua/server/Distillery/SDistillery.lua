if isClient() then return end

require "Map/SGlobalObject"

SDistillery = SGlobalObject:derive("SDistillery")

function SDistillery:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end

function SDistillery:initNew()
    self.mode = "None";
    self.active = false;
    self.hasPower = false;
    self.input = 0;
    self.tank = 0;
end

function SDistillery:stateFromIsoObject(isoObject)
    self:initNew()

    if SDistillerySystem.isValidModData(isoObject:getModData()) then
        print("Valid Data")
        self:fromModData(isoObject:getModData())
    end

    local worldPower = getWorld():isHydroPowerOn()
    local square = isoObject:getSquare()

    if worldPower and not square:isOutside() then
        self.hasPower = true
    elseif square:haveElectricity() then
        self.hasPower = true
    else
        self.hasPower = false
    end

    self:saveData(true)
end

function SDistillery:stateToIsoObject(isoObject)
    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
end

function SDistillery:fromModData(modData)
    self.mode = modData["mode"];
    self.active = modData["active"];
    self.input = modData["input"];
    self.tank = modData["tank"];
    self.hasPower = modData["hasPower"];
end

function SDistillery:toModData(modData)
    modData["mode"] = self.mode;
    modData["active"] = self.active;
    modData["input"] = self.input;
    modData["tank"] = self.tank;
    modData["hasPower"] = self.hasPower;
end

function SDistillery:saveData(transmit)
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    self:toModData(isoObject:getModData())
    if transmit then
        isoObject:transmitModData()
    end
end