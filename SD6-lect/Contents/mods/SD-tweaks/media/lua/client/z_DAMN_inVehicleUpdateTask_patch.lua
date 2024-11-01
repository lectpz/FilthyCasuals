--[[local DAMN = DAMN or {}
original_DAMN_inVehicleUpdateTask = DAMN.inVehicleUpdateTask
local tick = 0
function DAMN.inVehicleUpdateTask(player)
	tick = tick + 1
	if tick > 100 then
		original_DAMN_inVehicleUpdateTask(player)
		tick = 0
	end
end]]