--***********************************************************
--**                      bikinihorst                      **
--***********************************************************


KI5 = KI5 or {};


-- create vehicle from config

KI5.loadedParts = KI5.loadedParts or {};
KI5.partDefaultsDebug = false;
KI5.modDataDebug = false;


function KI5:createVehicleConfig(rootNS)
	for i, node in ipairs({"Init", "Create", "InstallComplete", "UninstallComplete", "CheckEngine", "CheckOperate", "ContainerAccess", "InstallTest", "UninstallTest", "Update", "Use"})
	do
		if not rootNS[node]
		then
			rootNS[node] = {};
		end
	end

	if rootNS.parts
	then
		for partNS, partConfig in pairs(rootNS.parts)
		do
			for partName, partVariants in pairs(partConfig)
			do
				if type(rootNS.parts[partNS]) == "table"
				then
					if not rootNS[partNS]
					then
						rootNS[partNS] = function(vehicle, part)
							part = vehicle:getPartById(partName);
							local item = part:getInventoryItem();

							if item
							then
								for varModelName, varItem in pairs(partVariants)
								do
									part:setModelVisible(varModelName, item:getType() == varItem);
								end
							end
						end;
					end

					if not rootNS.Create[partNS]
					then
						rootNS.Create[partNS] = function(vehicle, part)
							part:setInventoryItem(nil);
							rootNS[partNS](vehicle, part, nil);
							vehicle:doDamageOverlay();
						end
					end

					for i, partFn in ipairs({"Init", "InstallComplete", "UninstallComplete"})
					do
						if not rootNS[partFn][partNS]
						then
							rootNS[partFn][partNS] = function(vehicle, part)
								if partFn == "Init"
								then
									KI5:checkDefaultParts(vehicle, part, rootNS.parts[partNS]);
									--KI5:checkLegacyTires(vehicle);

									local vName = vehicle:getScript():getName();

									if not KI5.loadedParts[vName]
									then
										KI5.loadedParts[vName] = {
											rootNS = rootNS,
											parts = {}
										}
									end

									if not KI5.loadedParts[vName].parts[partNS]
									then
										KI5.loadedParts[vName].parts[partNS] = true;
									end
								end

								rootNS[partNS](vehicle, part);
								vehicle:doDamageOverlay();
							end
						end
					end
				end
			end
		end
	end
end


-- process default parts

function KI5:checkDefaultParts(vehicle, part, partConfig)
	local partId = part:getId();
	local modData = KI5:getModData(vehicle);
	local default = partConfig["default"];

	if not modData["defaultPartSet_" .. partId] and KI5:partIsMissing(part)
	then
		if part:getTable("install")
		then
			local item = nil;

			if default
			then
				local possibilities = part:getItemType();

				if default == "first"
				then
					item = possibilities:get(0);
				elseif default == "random"
				then
					item = possibilities:get(ZombRandBetween(0, possibilities:size()));
				elseif default == "trve_random"
				then
					if ZombRandBetween(1, 100) >= tonumber(partConfig["noPartChance"] or 50)
					then
						item = possibilities:get(ZombRandBetween(0, possibilities:size()));
					end
				else
					item = default;
				end

                if KI5.partDefaultsDebug and item
                then
                    print("KI5:checkDefaultParts() -> would install item " .. tostring(item) .. " in slot " .. partId);
                end

				if not KI5.partDefaultsDebug and item
				then
					KI5:silentPartInstall(part, item);
				end
			end

			if not KI5.partDefaultsDebug
			then
				KI5:saveModData(vehicle, {
					["defaultPartSet_" .. partId] = "true"
				});
			end

			--if KI5.partDefaultsDebug and KI5:partIsMissing(part)
			--then
				--print("KI5:checkDefaultParts() -> part " .. partId .. " still missing");
			--end
		end
	end
end


-- check if part exists

function KI5:partIsMissing(part)
	return part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem();
end


-- silently install item in part slot

function KI5:silentPartInstall(part, itemId)
    if KI5.partDefaultsDebug
	then
        print("KI5:silentPartInstall() -> silently installing " .. itemId .. " for " .. part:getId());
    end

	KI5:sendClientCommand("ki5_lib", "silentPartInstall", {
		part = part:getId(),
		item = itemId
	}, part:getVehicle());
end


-- set container amounts (tires, gas tank, ...)

function KI5:setContainerAmount(part, amount)
	KI5:sendClientCommand("vehicle", "setContainerContentAmount", {
		vehicle = part:getVehicle():getId(),
		part = part:getId(),
		amount = amount
	});
end


-- replace old tire type with new one

function KI5:checkLegacyTires(vehicle)
	for i = 0, vehicle:getPartCount() -1
	do
		local part = vehicle:getPartByIndex(i);

		if not KI5:partIsMissing(part)
		then
			local inventoryItem = part:getInventoryItem();

			if inventoryItem and inventoryItem:getFullType() == "Base.V100Tire2"
			then
                if KI5.partDefaultsDebug
                then
                    print("KI5:checkLegacyTires() -> replacing " .. inventoryItem:getFullType() .. " on vehicle " .. tostring(vehicle:getSqlId()));
                end

				KI5:silentPartInstall(part, "Base.V101Tire2");
				KI5:setContainerAmount(part, 35);
			end
		end
	end
end


-- moddata fuckery because vehicle moddata is currently wonky

KI5.muleParts = KI5.muleParts or {
	"M101A3Trunk",
	"GloveBox",
	"TruckBed",
	"TrailerTrunk",
	"TruckBedOpen",
	"Engine",
};

function KI5:getMulePart(vehicle)
	if vehicle
	then
		for i, partId in ipairs(KI5.muleParts)
		do
			local part = vehicle:getPartById(partId);

			if part
			then
				return part;
			end
		end

        if KI5.modDataDebug
        then
            print("KI5:getMulePart() -> mule part not found");
        end
	elseif KI5.modDataDebug
    then
		print("KI5:getMulePart() -> vehicle not found");
	end

	return nil;
end

function KI5:getModData(vehicle)
	local part = KI5:getMulePart(vehicle);

	if part
	then
		return part:getModData();
	else
        if KI5.modDataDebug
        then
            print("KI5:getModData() -> data mule part NOT found");
        end

		return {};
	end
end

function KI5:saveModData(vehicle, data)
	KI5:sendClientCommand("ki5_lib", "setVehicleData", data, vehicle);
end


-- shortcut for client command

function KI5:sendClientCommand(moduleName, methodName, args, vehicle)
	if vehicle
	then
		args["_vehicleId"] = vehicle:getId();
	end

	sendClientCommand(getPlayer(), moduleName, methodName, args);
end