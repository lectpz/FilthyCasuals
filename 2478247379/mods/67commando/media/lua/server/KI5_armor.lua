--***********************************************************
--**                    bikinihorst                        **
--***********************************************************

KI5 = KI5 or {};
KI5.Armor = KI5.Armor or {};
KI5.Armor.Commands = KI5.Armor.Commands or {};

function KI5.Armor.Commands.setPartModData(playerObj, args)

	local vehicle = getVehicleById(args.vehicle);

	if vehicle and args.data
	then
		local part = vehicle:getPartById(args.part);

		if part
		then
			local modData = part:getModData();

			for key, value in pairs(args.data)
			do
				modData[key] = value;
			end

			vehicle:transmitPartModData(part);
		end
	end
end

Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
	if moduleName == "KI5_armor" and KI5.Armor.Commands[command]
	then
		KI5.Armor.Commands[command](playerObj, args);
	end
end);