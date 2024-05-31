--***********************************************************
--**                   KI5 / bikinihorst                   **
--***********************************************************
--v1.9.3

KI5 = KI5 or {};
V100 = V100 or {};

function V100.extractCond(player)
	local vehicle = player:getVehicle()
	if (vehicle and string.find( vehicle:getScriptName(), "67commando" )) then
		for i, partId in ipairs ({
			"", "",
			})
		do
			KI5:savePartCondById(vehicle, partId);
		end
	end
end

function KI5:savePartCond(part)
	if part then
		local vehicle = part:getVehicle()
		if vehicle then
			KI5:sendArmorCommandWrapper(getPlayer(), part, "setPartModData", {
				data = {
					saveCond = part:getCondition()
				}
			});
		end
	end
end

function KI5:savePartCondById(vehicle, partId)
	if vehicle and partId then
		KI5:savePartCond(vehicle:getPartById(partId))
	end
end

function KI5:sendVehicleCommandWrapper(player, part, methodName, args)
	local args = args or {}
	args.part = part:getId()
	args.vehicle = part:getVehicle():getId()
	sendClientCommand(player, "vehicle", methodName, args)
end

function KI5:sendArmorCommandWrapper(player, part, methodName, args)
	local args = args or {}
	args.part = part:getId()
	args.vehicle = part:getVehicle():getId()
	sendClientCommand(player, "KI5_armor", methodName, args)
end

function V100.activeArmor(player)
    local vehicle = player:getVehicle()
    	if (vehicle and string.find( vehicle:getScriptName(), "67commando" )) then

		--

			for i, tirePart in ipairs ({"TireFrontLeft", "TireFrontRight", "TireRearLeft", "TireRearRight"})
				do
					if vehicle:getPartById(tirePart) then
						local part = vehicle:getPartById(tirePart)
						local tireCond = 25;
					    	if part:getCondition() < tireCond then
					    		KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = tireCond})
							elseif part:getContainerContentAmount() < 33 then
								KI5:sendVehicleCommandWrapper(player, part, "setContainerContentAmount", {amount = 35})
							end
					end
			end

		--

			for i, viewportPart in ipairs ({"Windshield", "WindshieldRear", "WindowFrontLeft", "WindowFrontRight", "WindowRearLeft", "WindowRearRight"})
				do
					if vehicle:getPartById(viewportPart) then
						local part = vehicle:getPartById(viewportPart)
						local viewportPart = 49;
					    	if part:getCondition() < viewportPart then
					    		KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = viewportPart})
							end
					end
			end

		--

			for i, doorPart in ipairs ({"DoorFrontLeft", "DoorFrontRight", "DoorRear", "V100ToolboxLid"})
				do
					if vehicle:getPartById(doorPart) then
						local part = vehicle:getPartById(doorPart)
						local doorPart = 11;
					    	if part:getCondition() < doorPart then
					    		KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = doorPart})
							end
					end
			end

		--

			local part = vehicle:getPartById("EngineDoor")
				if part:getCondition() < 49 then
					KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = 49})
				end

			local part = vehicle:getPartById("Engine")
				if part:getCondition() < 9 then
					KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = 9})
				end


			local part = vehicle:getPartById("GasTank")
				if part:getCondition() < 95 then
					KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = 95})
				end

			local part = vehicle:getPartById("TruckBed")
				if part:getCondition() < 95 then
					KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = 95})
				end

			local part = vehicle:getPartById("V100Toolbox")
				if part:getCondition() < 49 then
					KI5:sendVehicleCommandWrapper(player, part, "setPartCondition", {condition = 49})
				end

			--
		end
end

--Events.OnEnterVehicle.Add(V100.extractCond);
Events.OnPlayerUpdate.Add(V100.activeArmor);