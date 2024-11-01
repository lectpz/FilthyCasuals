local args = {}

function SD6onDebugColor(playerObj, vehicle)

	local zonetier, zonename, x, y = checkZone()
	
	args.player_name = getOnlineUsername()
	args.vehicle = vehicle:getScriptName()
	args.vehicleID = vehicle:getId()
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	
	sendClientCommand(playerObj, 'sdLogger', 'VehicleSkinChange', args);
	
	local playerInv = playerObj:getInventory()
	if not playerInv:contains("Base.VehicleSkinChanger") then 
		playerObj:Say("I cannot do that.")
		return
	end
	debugVehicleColor(playerObj, vehicle)
	playerInv:RemoveOneOf("Base.VehicleSkinChanger")
end

local o_FillMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle
function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
	o_FillMenuOutsideVehicle(player, context, vehicle, test)

	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	if not playerInv:contains("Base.VehicleSkinChanger") then return end
	context:addOption("Change skin for: " .. vehicle:getScriptName() .. " (WILL CONSUME TICKET)", playerObj, SD6onDebugColor, vehicle);
end