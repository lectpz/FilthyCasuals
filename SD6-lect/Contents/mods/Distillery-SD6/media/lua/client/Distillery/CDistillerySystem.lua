require "Map/CGlobalObjectSystem"

CDistillerySystem = CGlobalObjectSystem:derive("CDistillerySystem")

function CDistillerySystem:new()
	local o = CGlobalObjectSystem.new(self, "Distillery")
	return o
end

function CDistillerySystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "distillery_tileset_01_0"
end

function CDistillerySystem:newLuaObject(globalObject)
	return CDistillery:new(self, globalObject)
end

function CDistillerySystem:OnServerCommand(command, args)
	CDistillerySystemCommands[command](args)
end

function CDistillerySystem.onMoveablesAction(o)
    if o.mode == "pickup" and o.origSpriteName == "distillery_tileset_01_0" then
        local isoObjectSpecial = DistilleryUtilities.findOnSquare(o.square,o.origSpriteName)

        if isoObjectSpecial then
            isoObjectSpecial:getModData().input = 0
            isoObjectSpecial:getModData().tank = 0
            isoObjectSpecial:getModData().active = false
            isoObjectSpecial:getModData().hasPower = false
            isoObjectSpecial:getModData().mode = "None"
        end
    end
end

CGlobalObjectSystem.RegisterSystemClass(CDistillerySystem)