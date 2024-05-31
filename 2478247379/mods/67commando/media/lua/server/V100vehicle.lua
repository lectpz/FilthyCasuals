--***********************************************************
--**                   KI5 / bikinihorst                   **
--***********************************************************

V100 = {
	parts = {

		--to be continued...
		
	},
};

KI5:createVehicleConfig(V100);

function V100.ContainerAccess.Trunk(vehicle, part, chr)
	if chr:getVehicle() == vehicle then
		local seat = vehicle:getSeat(chr)
		return seat == 5 or seat == 4 or seat == 3 or seat == 2 or seat == 1 or seat == 0;
	elseif chr:getVehicle() then
		return false
	else
		if not vehicle:isInArea(part:getArea(), chr) then return false end
		local doorPart = vehicle:getPartById("DoorRear")
		if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
			return false
		end
		return true
	end
end

function V100.ContainerAccess.Toolbox(vehicle, part, chr)
	if chr:getVehicle() then return false end
	if not vehicle:isInArea(part:getArea(), chr) then return false end
	local ToolboxLid = vehicle:getPartById("V100ToolboxLid")
	if ToolboxLid and ToolboxLid:getDoor() then
		if not ToolboxLid:getInventoryItem() then return true end
		if not ToolboxLid:getDoor():isOpen() then return false end
	end
	--
	return true
end