--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"
require "TimedActions/ISRemoveBurntVehicle"

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local ki5parts = splitString("damnCraft.HandleClassic damnCraft.HandleModern damnCraft.HingeSmall damnCraft.HingeLarge damnCraft.RubberStrip damnCraft.SeatFabric damnCraft.SeatFoam damnCraft.SeatFrameSmall damnCraft.SeatFrameLarge")

local function predicateWeldingMask(item)
	return item:hasTag("WeldingMask") or item:getType() == "WeldingMask"
end

local function predicateBlowTorch(item, tier)
	local tierzone = checkZone()
	return (item ~= nil) and
		(item:hasTag("BlowTorch") or item:getType() == "BlowTorch") and
		(item:getDrainableUsesInt() >= 14+(tierzone)*2)
end

function ISRemoveBurntVehicle:isValid()
	if not predicateBlowTorch(self.character:getPrimaryHandItem()) then
		self.character:Say("I need to refill this Propane Torch...")
		return false
	end
	return self.vehicle and not self.vehicle:isRemovedFromWorld();
end

local scrapConfig = {
	MetalBar = {
		chanceAtT6 = 0.08,
		quantityAtT6 = 1,
		dropsPerTier = 1
	},
	MetalPipe = {
		chanceAtT6 = 0.07,
		quantityAtT6 = 1,
		dropsPerTier = 1
	},
	SmallSheetMetal = {
		chanceAtT6 = 0.08,
		quantityAtT6 = 1,
		dropsPerTier = 1
	},
	SheetMetal = {
		chanceAtT6 = 0.02,
		quantityAtT6 = 1,
		dropsPerTier = 1
	},
}

function ISRemoveBurntVehicle:perform()
	local tierzone = checkZone()
	if self.sound ~= 0 then
		self.character:getEmitter():stopSound(self.sound)
	end

	local metalworks = {}
	metalworks.ScrapMetal = 0
	metalworks.MetalBar = 0
	metalworks.MetalPipe = 0
	metalworks.SmallSheetMetal = 0
	metalworks.SheetMetal = 0


	local initScrapMulti = 2
	local finalScrapMulti = 0.25  
	local scrap_reward_ranges = {
		{min = 12, max = 20}, -- Tier 1
		{min = 3,  max = 7},  -- Tier 2
		{min = 2,  max = 6},  -- Tier 3
		{min = 1,  max = 5},  -- Tier 4
		{min = 1,  max = 4},  -- Tier 5
		{min = 1,  max = 3}   -- Tier 6
	}


	for current_tier = 1, tierzone do

		local scaling_factor
		if tierzone == 1 then
			scaling_factor = initScrapMulti
		else
			local progress = (current_tier - 1) / (tierzone - 1)
			scaling_factor = initScrapMulti - (initScrapMulti - finalScrapMulti) * progress
		end

		local reward_range = scrap_reward_ranges[current_tier]
		local scrap_to_add = 0
		if reward_range then
			scrap_to_add = ZombRand(reward_range.min, reward_range.max)
		end
		metalworks.ScrapMetal = metalworks.ScrapMetal + scrap_to_add

		if current_tier == 1 then
			if ZombRand(2) == 0 then metalworks.MetalPipe = metalworks.MetalPipe + 1 else metalworks.MetalBar = metalworks.MetalBar + 1 end
			if ZombRand(4-current_tier) == 0 then metalworks.SmallSheetMetal = metalworks.SmallSheetMetal end
			if ZombRand(6-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		elseif current_tier == 2 then
			if ZombRand(2) == 0 then metalworks.MetalPipe = metalworks.MetalPipe + 1 else metalworks.MetalBar = metalworks.MetalBar + 1 end
			if ZombRand(2) == 0 then metalworks.MetalPipe = metalworks.MetalPipe + 1 else metalworks.MetalBar = metalworks.MetalBar + 1 end
			if ZombRand(4-current_tier) == 0 then metalworks.SmallSheetMetal = metalworks.SmallSheetMetal end
			if ZombRand(6-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		elseif current_tier == 3 then
			metalworks.SmallSheetMetal = metalworks.SmallSheetMetal + 1
			if ZombRand(2) == 0 then metalworks.MetalPipe = metalworks.MetalPipe + 1 else metalworks.MetalBar = metalworks.MetalBar + 1 end
			if ZombRand(6-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		elseif current_tier == 4 then
		  metalworks.SmallSheetMetal = metalworks.SmallSheetMetal + 1
			if ZombRand(7-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		elseif current_tier == 5 then
			metalworks.SmallSheetMetal = metalworks.SmallSheetMetal + 1
			if ZombRand(7-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		elseif current_tier == 6 then
			metalworks.SmallSheetMetal = metalworks.SmallSheetMetal + 1
			metalworks.SheetMetal = metalworks.SheetMetal + 1
			if ZombRand(7-current_tier) == 0 then metalworks.SheetMetal = metalworks.SheetMetal end
		end

		for item_name, config in pairs(scrapConfig) do
			local target_prob_at_tier6 = config.chanceAtT6
			local num_drops_this_tier = config.dropsPerTier

			local current_prob = target_prob_at_tier6 * scaling_factor

			local rng
			if current_prob >= 1.0 then
				rng = 1
			else
				rng = math.max(2, math.floor(1 / current_prob))
			end

			for _ = 1, num_drops_this_tier do
				if ZombRand(rng) == 0 then
					metalworks[item_name] = metalworks[item_name] + config.quantityAtT6
				end
			end
		end

	end
	
	local vehSq = self.vehicle:getSquare()
	
	if metalworks.ScrapMetal > 0 then vehSq:AddWorldInventoryItem("ScrapMetal", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, metalworks.ScrapMetal) end
	if metalworks.MetalBar > 0 then vehSq:AddWorldInventoryItem("MetalBar", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, metalworks.MetalBar) end
	if metalworks.MetalPipe > 0 then vehSq:AddWorldInventoryItem("MetalPipe", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, metalworks.MetalPipe) end
	if metalworks.SmallSheetMetal > 0 then vehSq:AddWorldInventoryItem("SmallSheetMetal", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, metalworks.SmallSheetMetal) end
	if metalworks.SheetMetal > 0 then vehSq:AddWorldInventoryItem("SheetMetal", ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, metalworks.SheetMetal) end
	
	vehSq:AddWorldInventoryItem(ki5parts[ZombRand(#ki5parts)+1], ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0)
	--vehSq:AddWorldInventoryItem(ki5parts[ZombRand(#ki5parts)+1], ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0)

	for i=1,(14+(tierzone)*2) do
		self.item:Use();
	end
	sendClientCommand(self.character, "vehicle", "remove", { vehicle = self.vehicle:getId() })
	self.item:setJobDelta(0);
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
	local playerObj = getSpecificPlayer(player)
	local tier = checkZone()
--[[
	local subOption = context:addOption("Vehicle")
	local vehicleMenu = ISContextMenu:getNew(context)
	context:addSubMenu(subOption, vehicleMenu)
	vehicleMenu:addOption("Info", playerObj, ISVehicleMenu.onInfo, vehicle)
--]]
--	context:addOption("Vehicle Info", playerObj, ISVehicleMenu.onInfo, vehicle)
	ISVehicleMenu.FillPartMenu(player, context, nil, vehicle);
	
	context:addOption(getText("ContextMenu_VehicleMechanics"), playerObj, ISVehicleMenu.onMechanic, vehicle);
	
	local part = vehicle:getClosestWindow(playerObj);
	if part then
		local window = part:getWindow()
		if not window:isDestroyed() and not window:isOpen() then
			context:addOption(getText("ContextMenu_Vehicle_Smashwindow", getText("IGUI_VehiclePart" .. part:getId())), playerObj, ISVehiclePartMenu.onSmashWindow, part)
		end
	end
	
	-- remove burnt vehicles
	if string.match(vehicle:getScript():getName(), "Burnt") or string.match(vehicle:getScript():getName(), "Smashed") then
		local option = context:addOption(getText("ContextMenu_RemoveBurntVehicle"), playerObj, ISVehicleMenu.onRemoveBurntVehicle, vehicle);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_RemoveBurntVehicle"));
		toolTip.description = getText("Tooltip_removeBurntVehicle") .. " <LINE> <LINE> ";
		
		toolTip.description = toolTip.description .. " <RGB:1,1,1> Requires " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. (14 + tier*2)  .. "/" .. 32 .. " <LINE> ";
		
		if playerObj:getInventory():containsEvalRecurse(predicateWeldingMask) then
			toolTip.description = toolTip.description .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType("Base.WeldingMask") .. " 1/1";
		else
			toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("Base.WeldingMask") .. " 0/1";
			option.notAvailable = true;
		end
		
		local blowTorch = ISBlacksmithMenu.getBlowTorchWithMostUses(playerObj:getInventory());
		if blowTorch then
			
			local blowTorchUseLeft = blowTorch:getDrainableUsesInt();
			if blowTorchUseLeft >= (14 + tier*2) then
				toolTip.description = toolTip.description .. " <LINE> <RGB:1,1,1> Available " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. "/" .. 32;
			else
				toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> Available " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. "/" .. 32;
				option.notAvailable = true;
			end
		else
			toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " 0/" .. 32;
			option.notAvailable = true;
		end
	end

	if ISWashVehicle.hasBlood(vehicle) then
		local option = context:addOption(getText("ContextMenu_Vehicle_Wash"), playerObj, ISVehicleMenu.onWash, vehicle);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		toolTip:setName(getText("Tooltip_Vehicle_WashTitle"));
		toolTip.description = getText("Tooltip_Vehicle_WashWaterRequired1", 100 / ISWashVehicle.BLOOD_PER_WATER);
		local waterAvailable = ISWashVehicle.getWaterAmountForPlayer(playerObj);
		option.notAvailable = waterAvailable <= 0
		if waterAvailable == 1 then
			toolTip.description = toolTip.description .. " <BR> " .. getText("Tooltip_Vehicle_WashWaterRequired2");
		else
			toolTip.description = toolTip.description .. " <BR> " .. getText("Tooltip_Vehicle_WashWaterRequired3", waterAvailable);
		end
		option.toolTip = toolTip;
	end

	local vehicleMenu = nil
	if getCore():getDebug() or ISVehicleMechanics.cheat then
		local subOption = context:addOption("Vehicle")
		subOption.iconTexture = getTexture("media/ui/BugIcon.png")
		vehicleMenu = ISContextMenu:getNew(context)
		context:addSubMenu(subOption, vehicleMenu)
	end
	
	if getCore():getDebug() then
		vehicleMenu:addOption("Reload Vehicle Textures", vehicle:getScript():getName(), reloadVehicleTextures)
		if ISVehicleMechanics.cheat then
			vehicleMenu:addOption("ISVehicleMechanics.cheat=false", playerObj, ISVehicleMechanics.onCheatToggle)
		else
			vehicleMenu:addOption("ISVehicleMechanics.cheat=true", playerObj, ISVehicleMechanics.onCheatToggle)
		end
		vehicleMenu:addOption("Roadtrip UI", playerObj, ISVehicleMenu.onRoadtrip);
		vehicleMenu:addOption("Vehicle Angles UI", playerObj, ISVehicleMenu.onDebugAngles, vehicle);
		vehicleMenu:addOption("Vehicle HSV & Skin UI", playerObj, ISVehicleMenu.onDebugColor, vehicle);
		vehicleMenu:addOption("Vehicle Blood UI", playerObj, ISVehicleMenu.onDebugBlood, vehicle);
		vehicleMenu:addOption("Vehicle Editor", playerObj, ISVehicleMenu.onDebugEditor, vehicle);
		if vehicle:isAlarmed() then			
			vehicleMenu:addOption("Disable Alarm", playerObj, ISVehicleMenu.onDisableAlarm, vehicle);
		else
			vehicleMenu:addOption("Enable Alarm", playerObj, ISVehicleMenu.onEnableAlarm, vehicle);		
		end
		if not isClient() then
			ISVehicleMenu.addSetScriptMenu(vehicleMenu, playerObj, vehicle)
		end
	end
	
	if getCore():getDebug() or ISVehicleMechanics.cheat then
		vehicleMenu:addOption("Remove vehicle", playerObj, ISVehicleMechanics.onCheatRemove, vehicle);
	end
end