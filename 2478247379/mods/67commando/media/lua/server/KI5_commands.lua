--***********************************************************
--**                    bikinihorst                        **
--***********************************************************

KI5 = KI5 or {};
KI5.Commands = KI5.Commands or {};

function KI5.Commands.setVehicleData(playerObj, args)
	--print("KI5.Commands.setVehicleData(" .. playerObj:getUsername() .. ", " .. args["_vehicleId"] .. ")");

	local vehicle = getVehicleById(args["_vehicleId"]);

	if vehicle
	then
		local part = KI5:getMulePart(vehicle);

		if part
		then
			--print("setting mod data");

			local modData = part:getModData();

			for k, v in pairs(args)
			do
				if k ~= "_vehicleId" and k ~= "contentAmount"
				then
					--print("- setting " .. tostring(k) .. " = " .. tostring(v));

					modData[k] = v;
				end
			end

			vehicle:transmitPartModData(part);
		--else
		--print("unable to find mule part");
		end
	--else
	--print("unable to find vehicle");
	end
end

function KI5.Commands.silentPartInstall(playerObj, args)
	local vehicle = getVehicleById(args["_vehicleId"]);
	local item = args["item"];
	local part = args["part"];

	if vehicle and part and item
	then
		--print("KI5.Commands.silentPartInstall(" .. playerObj:getUsername() .. ", " .. part .. ", " .. item .. ")");

		item = InventoryItemFactory.CreateItem(item);
		part = vehicle:getPartById(part);

		if item
		then
			part:setInventoryItem(item);
			vehicle:transmitPartItem(part);

			local installTable = part:getTable("install");

			if installTable and installTable.complete
			then
				VehicleUtils.callLua(installTable.complete, vehicle, part);
			end
		--else
		--print("no item generated");
		end
	--else
	--print("vehicle, part or item missing");
	end
end

Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
	if moduleName == "ki5_lib" and KI5.Commands[command]
	then
		--print(moduleName .. " -> " .. command .. " | " .. playerObj:getUsername());

		KI5.Commands[command](playerObj, args);
	end
end);