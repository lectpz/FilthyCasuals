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

function SD6onDebugRust(playerObj, vehicle)

    local zonetier, zonename, x, y = checkZone()

	args.player_name = getOnlineUsername()
	args.vehicle = vehicle:getScriptName()
	args.vehicleID = vehicle:getId()
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)

	sendClientCommand(playerObj, 'sdLogger', 'VehicleRustChange', args);

	local playerInv = playerObj:getInventory()
	if not playerInv:contains("Base.VehicleRustChanger") then
		playerObj:Say("I cannot do that.")
		return
	end

	local rust = vehicle:getRust()
	if rust > 0.0 then
	   rust = 0.0
	else
	   rust = 1.0
	end
	sendClientCommand(playerObj, "vehicle", "setRust", { vehicle = vehicle:getId(), rust = rust })
	playerInv:RemoveOneOf("Base.VehicleRustChanger")
end

local o_FillMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle
function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
	o_FillMenuOutsideVehicle(player, context, vehicle, test)

	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	if playerInv:contains("Base.VehicleSkinChanger") then
	   context:addOption("Change skin for: " .. vehicle:getScriptName() .. " (WILL CONSUME TICKET)", playerObj, SD6onDebugColor, vehicle)
	end
	if playerInv:contains("Base.VehicleRustChanger") then
	   context:addOption("Change rust for: " .. vehicle:getScriptName() .. " (WILL CONSUME TICKET)", playerObj, SD6onDebugRust, vehicle)
	end
end
