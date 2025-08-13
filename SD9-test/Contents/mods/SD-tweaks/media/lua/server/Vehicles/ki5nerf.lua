--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************
require "Vehicle/Vehicles"

local ki5_patterns = {
	"67commando",
	"84gageV300",
	"97bush",
}

local function isKI5(vehicle)
	for i=1, #ki5_patterns do
		if string.find(vehicle, ki5_patterns[i]) then return true end
	end
	return false
end

VehicleUtils = VehicleUtils

local old_Vehicles_Create_Battery = Vehicles.Create.Battery
function Vehicles.Create.Battery(vehicle, part)
	if isKI5(vehicle:getScriptName()) then
		return false
	end
	old_Vehicles_Create_Battery(vehicle, part)
end

local old_Vehicles_Create_Engine = Vehicles.Create.Engine
function Vehicles.Create.Engine(vehicle, part)
	old_Vehicles_Create_Engine(vehicle, part)
	if isKI5(vehicle:getScriptName()) then
		part:setCondition(0)
		vehicle:setEngineFeature(0, vehicle:getScript():getEngineLoudness(), vehicle:getScript():getEngineForce());
		vehicle:transmitPartCondition(part)
		vehicle:transmitEngine()
	end	
end

local old_VehicleUtils_createPartInventoryItem =  VehicleUtils.createPartInventoryItem
function VehicleUtils.createPartInventoryItem(part)
	if isKI5(part:getVehicle():getScriptName()) then
		if not part:getItemType() or part:getItemType():isEmpty() then return nil end

		local iType = nil 
		if part:getItemType() and part:getItemType():get(0) then
			iType = part:getItemType():get(0)
		end
		if iType and iType:contains("Muffler") then
			return false
		end
		if iType and iType:contains("Wind") then
			return false
		end
		if iType and iType:contains("Hood") then
			return false
		end
		if iType and iType:contains("Tire") then
			return false
		end
		if iType and iType:contains("Gunner") then
			return false
		end
		if iType and iType:contains("gunner") then
			return false
		end
	end
	
	return  old_VehicleUtils_createPartInventoryItem(part)
end
