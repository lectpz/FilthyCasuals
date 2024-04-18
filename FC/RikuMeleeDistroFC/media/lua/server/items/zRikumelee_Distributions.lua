local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function preDistributionMerge()
---------------------------------------------------------------------------------
	local coldpackData = {
		StoreShelfMedical = 5,
		MedicalStorageDrugs = 2,
		MedicalClinicDrugs = 2,
		ArmyStorageMedical = 1,
		MedicalStorageTools = 2,
		MedicalClinicTools= 2
	}
	
	for distribution, chance in pairs(coldpackData) do
		table.insert(ProceduralDistributions.list[distribution].items, "Coldpack")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
---------------------------------------------------------------------------------
	local weaponCacheData = {
		CampingStoreGear = 0.0001,
		FireStorageTools = 0.001,
		GigamartTools = 0.0001,
		PawnShopGunsSpecial = 0.002,
		MeleeWeapons = 0.004,
		JanitorTools = 0.0001,
		BurglarTools = 0.0001,
		PoliceStorageGuns = 0.002,
		WardrobeWoman = 0.00001,
		PawnShopKnives = 0.001,
		GardenStoreTools = 0.00001,
		BarCounterWeapon = 0.00001,
		BedroomDresser = 0.000001,
		ToolStoreTools = 0.0001,
		GunStoreAmmunition = 0.001,
		WardrobeMan = 0.0001,
		GunStoreDisplayCase = 0.001,
		PoliceStorageAmmunition = 0.0001,
		ArmyStorageGuns = 0.001,
		GunStoreShelf = 0.001
	}

	for distribution, chance in pairs(weaponCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "WeaponCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
-------------------------------------------------------------------------------------
	local MechMWCacheData = {
		CampingStoreGear = 0.0001,
		FireStorageTools = 0.0001,
		GigamartTools = 0.0001,
		JanitorTools = 0.0001,
		BurglarTools = 0.0001,
		GardenStoreTools = 0.0001,
		ToolStoreTools = 0.0001,
		GarageMechanics = 0.001,
		GasStorageMechanics = 0.001,
		StoreShelfMechanics = 0.001,
		CrateMechanics = 0.001,
		GarageMetalwork = 0.001,
		ToolStoreMetalwork = 0.001,
		CrateMetalwork = 0.001
	}

	for distribution, chance in pairs(MechMWCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "MechanicCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "MetalworkCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------
	local FarmerCacheData = {
		GigamartTools = 0.0001,
		GardenStoreTools = 0.001,
		ToolStoreTools = 0.0001,
		GarageMechanics = 0.001,
		GasStorageMechanics = 0.001,
		StoreShelfMechanics = 0.001,
		CrateMechanics = 0.001,
		GarageMetalwork = 0.001,
		ToolStoreMetalwork = 0.001,
		CrateMetalwork = 0.001,
		CrateFarming = 0.001,
		GardenStoreMisc = 0.001,
		GigamartFarming = 0.001,
		ToolStoreFarming = 0.001
	}

	for distribution, chance in pairs(FarmerCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "FarmerCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------
	local AmmoCacheData = {
		PoliceStorageAmmunition = 0.001,
		GunStoreAmmunition = 0.001,
		ArmyStorageAmmunition = 0.001,
		GunStoreCounter = 0.0001,
		GunStoreDisplayCase = 0.0001,
		GunStoreShelf= 0.0001,
		PoliceStorageGuns = 0.0001,
		ArmyStorageGuns = 0.0001
	}
	
	for distribution, chance in pairs(AmmoCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "AmmoCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
--------------------------------------------------------------------------------------
end
Events.OnPreDistributionMerge.Add(preDistributionMerge)

local function RMWadjust()
	local RMWacritchance = {
		["RMWeapons.firelink"] = 27,
		["RMWeapons.themauler"] = 33,
		["RMWeapons.warhammer40k"] = 33,
		["RMWeapons.MizutsuneSword"] = 33,
		["RMWeapons.Nikabo"] = 33,
		["RMWeapons.falchion"] = 33,
		["RMWeapons.spinecrusher"] = 33,
		["RMWeapons.thunderbreaker"] = 33
	}
	
	for item, critchance in pairs(RMWacritchance) do
		local item = ScriptManager.instance:getItem(item)
		if item then
			item:DoParam("CriticalChance = " .. tostring(critchance))
		end
	end
	
	local item = ScriptManager.instance:getItem("RMWeapons.steinbeer")
	if item then
		item:DoParam("MaxRange	=	1.15")
		item:DoParam("ConditionLowerChanceOneIn	=	16")
		item:DoParam("CriticalChance	=	22")
	end
end
Events.OnInitGlobalModData.Add(RMWadjust)

local function FCnofirethrowables()

	local firethrowables = splitString("AerosolbombTriggered AerosolbombSensorV1 AerosolbombSensorV2 AerosolbombSensorV3 AerosolbombRemote FlameTrap FlameTrapTriggered FlameTrapSensorV1 FlameTrapSensorV2 FlameTrapSensorV3 FlameTrapRemote PipeBomb PipeBombTriggered PipeBombSensorV1 PipeBombSensorV2 PipeBombSensorV3 PipeBombRemote Molotov")

	for i=1,#firethrowables do

		local item = ScriptManager.instance:getItem(firethrowables[i])
		if item then
			item:DoParam("FirePower  =   0")
			item:DoParam("FireRange  =   0")
		end
		
	end

end
Events.OnInitGlobalModData.Add(FCnofirethrowables)

local function FCvanillaweaptweak()

	local vanillaweap = splitString("PickAxe Axe HandAxe BaseballBat BaseballBatNails Machete WoodAxe Base.OverlookFireAxe UndeadSurvivor.StalkerKnife")

	for i=1,#vanillaweap do

		local item = ScriptManager.instance:getItem(vanillaweap[i])
		if item then
			item:DoParam("CritDmgMultiplier = 2")
		end
		
	end
	
	local item = ScriptManager.instance:getItem("WoodAxe")
	if item then
		item:DoParam("CriticalChance	=	25")
	end

end
Events.OnInitGlobalModData.Add(FCvanillaweaptweak)