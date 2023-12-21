local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function preDistributionMerge()
	table.insert(ProceduralDistributions.list.StoreShelfMedical.items, "Coldpack");
	table.insert(ProceduralDistributions.list.StoreShelfMedical.items, 5);
	
	table.insert(ProceduralDistributions.list.MedicalStorageDrugs.items, "Coldpack");
	table.insert(ProceduralDistributions.list.MedicalStorageDrugs.items, 2);
	
	table.insert(ProceduralDistributions.list.MedicalClinicDrugs.items, "Coldpack");
	table.insert(ProceduralDistributions.list.MedicalClinicDrugs.items, 2);
	
	table.insert(ProceduralDistributions.list.ArmyStorageMedical.items, "Coldpack");
	table.insert(ProceduralDistributions.list.ArmyStorageMedical.items, 1);
	
	table.insert(ProceduralDistributions.list.MedicalStorageTools.items, "Coldpack");
	table.insert(ProceduralDistributions.list.MedicalStorageTools.items, 2);
	
	table.insert(ProceduralDistributions.list.MedicalClinicTools.items, "Coldpack");
	table.insert(ProceduralDistributions.list.MedicalClinicTools.items, 2);
	
	---------------------------------------------------------------------------------
	table.insert(ProceduralDistributions.list.CampingStoreGear.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.CampingStoreGear.items, 0.00001);

	table.insert(ProceduralDistributions.list.FireStorageTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.FireStorageTools.items, 0.0001);
	
	table.insert(ProceduralDistributions.list.GigamartTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.GigamartTools.items, 0.00001);

	table.insert(ProceduralDistributions.list.PawnShopGunsSpecial.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.PawnShopGunsSpecial.items, 0.002);

	table.insert(ProceduralDistributions.list.MeleeWeapons.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.MeleeWeapons.items, 0.004);

	table.insert(ProceduralDistributions.list.JanitorTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.JanitorTools.items, 0.00001);

	table.insert(ProceduralDistributions.list.BurglarTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.BurglarTools.items, 0.00001);

	table.insert(ProceduralDistributions.list.PoliceStorageGuns.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.PoliceStorageGuns.items, 0.002);

	table.insert(ProceduralDistributions.list.WardrobeWoman.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.WardrobeWoman.items, 0.000001);

	table.insert(ProceduralDistributions.list.PawnShopKnives.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.PawnShopKnives.items, 0.001);

	table.insert(ProceduralDistributions.list.GardenStoreTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.GardenStoreTools.items, 0.000001);

	table.insert(ProceduralDistributions.list.BarCounterWeapon.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.BarCounterWeapon.items, 0.00001);

	table.insert(ProceduralDistributions.list.BedroomDresser.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.BedroomDresser.items, 0.0000001);

	table.insert(ProceduralDistributions.list.ToolStoreTools.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.ToolStoreTools.items, 0.00001);

	table.insert(ProceduralDistributions.list.GunStoreAmmunition.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.GunStoreAmmunition.items, 0.0001);

	table.insert(ProceduralDistributions.list.WardrobeMan.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.WardrobeMan.items, 0.00001);

	table.insert(ProceduralDistributions.list.GunStoreDisplayCase.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.GunStoreDisplayCase.items, 0.001);
	
	table.insert(ProceduralDistributions.list.PoliceStorageAmmunition.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.PoliceStorageAmmunition.items, 0.0001);

	table.insert(ProceduralDistributions.list.ArmyStorageGuns.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.ArmyStorageGuns.items, 0.00001);
	
	table.insert(ProceduralDistributions.list.GunStoreShelf.items, "WeaponCache");
	table.insert(ProceduralDistributions.list.GunStoreShelf.items, 0.001);

	-------------------------------------------------------------------------------------
	table.insert(ProceduralDistributions.list.GarageMechanics.items, "MechanicCache");
	table.insert(ProceduralDistributions.list.GarageMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.GasStorageMechanics.items, "MechanicCache");
	table.insert(ProceduralDistributions.list.GasStorageMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, "MechanicCache");
	table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.CrateMechanics.items, "MechanicCache");
	table.insert(ProceduralDistributions.list.CrateMechanics.items, 0.001);
	
	-------------------------------------------------------------------------------------
	table.insert(ProceduralDistributions.list.GarageMetalwork.items, "MetalworkCache");
	table.insert(ProceduralDistributions.list.GarageMetalwork.items, 0.001);

	table.insert(ProceduralDistributions.list.ToolStoreMetalwork.items, "MetalworkCache");
	table.insert(ProceduralDistributions.list.ToolStoreMetalwork.items, 0.001);

	table.insert(ProceduralDistributions.list.CrateMetalwork.items, "MetalworkCache");
	table.insert(ProceduralDistributions.list.CrateMetalwork.items, 0.001);
	
	----------------------------------------------------------------------------------------
	table.insert(ProceduralDistributions.list.GarageMechanics.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.GarageMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.GasStorageMechanics.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.GasStorageMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, 0.001);

	table.insert(ProceduralDistributions.list.CrateMechanics.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.CrateMechanics.items, 0.001);
	
	table.insert(ProceduralDistributions.list.GarageMetalwork.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.GarageMetalwork.items, 0.001);

	table.insert(ProceduralDistributions.list.ToolStoreMetalwork.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.ToolStoreMetalwork.items, 0.001);

	table.insert(ProceduralDistributions.list.CrateMetalwork.items, "FarmerCache");
	table.insert(ProceduralDistributions.list.CrateMetalwork.items, 0.001);
	
	----------------------------------------------------------------------------------------
	table.insert(ProceduralDistributions.list.PoliceStorageAmmunition.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.PoliceStorageAmmunition.items, 0.001);
	
	table.insert(ProceduralDistributions.list.GunStoreAmmunition.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.GunStoreAmmunition.items, 0.001);
	
	table.insert(ProceduralDistributions.list.ArmyStorageAmmunition.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.ArmyStorageAmmunition.items, 0.001);
	
	table.insert(ProceduralDistributions.list.GunStoreCounter.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.GunStoreCounter.items, 0.0001);
	
	table.insert(ProceduralDistributions.list.GunStoreDisplayCase.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.GunStoreDisplayCase.items, 0.0001);
	
	table.insert(ProceduralDistributions.list.GunStoreShelf.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.GunStoreShelf.items, 0.0001);
	
	table.insert(ProceduralDistributions.list.PoliceStorageGuns.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.PoliceStorageGuns.items, 0.0001);
	
	table.insert(ProceduralDistributions.list.ArmyStorageGuns.items, "AmmoCache");
	table.insert(ProceduralDistributions.list.ArmyStorageGuns.items, 0.0001);
	
end
Events.OnPreDistributionMerge.Add(preDistributionMerge)

local function RMWadjust()
	local item = ScriptManager.instance:getItem("RMWeapons.firelink")
	if item then
		item:DoParam("CriticalChance	=	27")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.themauler")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.warhammer40k")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.MizutsuneSword")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.Nikabo")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.falchion")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.spinecrusher")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.thunderbreaker")
	if item then
		item:DoParam("CriticalChance	=	33")
	end

	local item = ScriptManager.instance:getItem("RMWeapons.steinbeer")
	if item then
		item:DoParam("MaxRange	=	1.15")
		item:DoParam("ConditionLowerChanceOneIn    =    16")
		item:DoParam("CriticalChance    =    22")
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