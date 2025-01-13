local proceduralContainer = {}

local function initProceduralContainer()
	proceduralContainer["ArmyHangarOutfit"]="Army"
	proceduralContainer["ArmyHangarTools"]="Army"
	proceduralContainer["ArmyStorageAmmunition"]="Army"
	proceduralContainer["ArmyStorageElectronics"]="Army"
	proceduralContainer["ArmyStorageGuns"]="Army"
	proceduralContainer["ArmyStorageMedical"]="Army"
	proceduralContainer["ArmyStorageOutfit"]="Army"
	proceduralContainer["ArmySurplusBackpacks"]="Army"
	proceduralContainer["ArmySurplusFootwear"]="Army"
	proceduralContainer["ArmySurplusHeadwear"]="Army"
	proceduralContainer["ArmySurplusMisc"]="Army"
	proceduralContainer["ArmySurplusOutfit"]="Army"
	proceduralContainer["ArmySurplusTools"]="Army"
	proceduralContainer["LockerArmyBedroom"]="Army"
	proceduralContainer["BarCounterWeapon"]="Weapon"
	proceduralContainer["DrugLabGuns"]="Weapon"
	proceduralContainer["FirearmWeapons"]="Weapon"
	proceduralContainer["GunStoreAmmunition"]="Weapon"
	proceduralContainer["GunStoreCounter"]="Weapon"
	proceduralContainer["GunStoreDisplayCase"]="Weapon"
	proceduralContainer["GunStoreMagazineRack"]="Weapon"
	proceduralContainer["GunStoreShelf"]="Weapon"
	proceduralContainer["Hunter"]="Weapon"
	proceduralContainer["HuntingLockers"]="Weapon"
	proceduralContainer["MeleeWeapons"]="Weapon"
	proceduralContainer["PawnShopCases"]="Weapon"
	proceduralContainer["PawnShopGuns"]="Weapon"
	proceduralContainer["PawnShopGunsSpecial"]="Weapon"
	proceduralContainer["PawnShopKnives"]="Weapon"
	proceduralContainer["PlankStashGun"]="Weapon"
	proceduralContainer["SurvivalGear"]="Weapon"
	proceduralContainer["PoliceDesk"]="Police"
	proceduralContainer["PoliceEvidence"]="Police"
	proceduralContainer["PoliceLockers"]="Police"
	proceduralContainer["PoliceStorageAmmunition"]="Police"
	proceduralContainer["PoliceStorageGuns"]="Police"
	proceduralContainer["PoliceStorageOutfit"]="Police"
	proceduralContainer["PrisonCellRandom"]="Police"
	proceduralContainer["PrisonGuardLockers"]="Police"
	proceduralContainer["SecurityLockers"]="Police"
	proceduralContainer["CarBrakesModern1"]="Mechanic"
	proceduralContainer["CarBrakesModern2"]="Mechanic"
	proceduralContainer["CarBrakesModern3"]="Mechanic"
	proceduralContainer["CarBrakesNormal1"]="Mechanic"
	proceduralContainer["CarBrakesNormal2"]="Mechanic"
	proceduralContainer["CarBrakesNormal3"]="Mechanic"
	proceduralContainer["CarSuspensionModern1"]="Mechanic"
	proceduralContainer["CarSuspensionModern2"]="Mechanic"
	proceduralContainer["CarSuspensionModern3"]="Mechanic"
	proceduralContainer["CarSuspensionNormal1"]="Mechanic"
	proceduralContainer["CarSuspensionNormal2"]="Mechanic"
	proceduralContainer["CarSuspensionNormal3"]="Mechanic"
	proceduralContainer["CarTiresModern1"]="Mechanic"
	proceduralContainer["CarTiresModern2"]="Mechanic"
	proceduralContainer["CarTiresModern3"]="Mechanic"
	proceduralContainer["CarTiresNormal1"]="Mechanic"
	proceduralContainer["CarTiresNormal2"]="Mechanic"
	proceduralContainer["CarTiresNormal3"]="Mechanic"
	proceduralContainer["CarWindows1"]="Mechanic"
	proceduralContainer["CarWindows2"]="Mechanic"
	proceduralContainer["CarWindows3"]="Mechanic"
	proceduralContainer["GasStorageMechanics"]="Mechanic"
	proceduralContainer["CrateMechanics"]="Mechanic"
	proceduralContainer["MechanicShelfBrakes"]="Mechanic"
	proceduralContainer["MechanicShelfElectric"]="Mechanic"
	proceduralContainer["MechanicShelfMisc"]="Mechanic"
	proceduralContainer["MechanicShelfMufflers"]="Mechanic"
	proceduralContainer["MechanicShelfOutfit"]="Mechanic"
	proceduralContainer["MechanicShelfSuspension"]="Mechanic"
	proceduralContainer["MechanicShelfWheels"]="Mechanic"
	proceduralContainer["MechanicSpecial"]="Mechanic"
	proceduralContainer["StoreShelfMechanics"]="Mechanic"
	proceduralContainer["GasStorageCombo"]="Mechanic"
	proceduralContainer["CrateMetalwork"]="Metalwork"
	proceduralContainer["CratePropane"]="Metalwork"
	proceduralContainer["CrateSheetMetal"]="Metalwork"
	proceduralContainer["FactoryLockers"]="Metalwork"
	proceduralContainer["WireFactoryElectric"]="Metalwork"
	proceduralContainer["BookstoreBags"]="Book"
	proceduralContainer["BookstoreBooks"]="Book"
	proceduralContainer["BookstoreMisc"]="Book"
	proceduralContainer["BookstoreStationery"]="Book"
	proceduralContainer["CafeShelfBooks"]="Book"
	proceduralContainer["CampingStoreBooks"]="Book"
	proceduralContainer["CrateBooks"]="Book"
	proceduralContainer["KitchenBook"]="Book"
	proceduralContainer["LibraryBooks"]="Book"
	proceduralContainer["MechanicShelfBooks"]="Book"
	proceduralContainer["MedicalOfficeBooks"]="Book"
	proceduralContainer["PostOfficeBooks"]="Book"
	proceduralContainer["CrateComics"]="Book"
	proceduralContainer["LivingRoomShelf"]="Book"
	proceduralContainer["LivingRoomShelfNoTapes"]="Book"
	proceduralContainer["MagazineRackMaps"]="Book"
	proceduralContainer["MagazineRackMixed"]="Book"
	proceduralContainer["MagazineRackNewspaper"]="Book"
	proceduralContainer["PostOfficeBoxes"]="Book"
	proceduralContainer["PostOfficeMagazines"]="Book"
	proceduralContainer["PostOfficeNewspapers"]="Book"
	proceduralContainer["PostOfficeSupplies"]="Book"
	proceduralContainer["CrateMagazines"]="Book"
	proceduralContainer["CrateNewspapers"]="Book"
	proceduralContainer["DrugLabOutfit"]="Medical"
	proceduralContainer["DrugLabSupplies"]="Medical"
	proceduralContainer["DrugShackDrugs"]="Medical"
	proceduralContainer["DrugShackMisc"]="Medical"
	proceduralContainer["DrugShackWeapons"]="Medical"
	proceduralContainer["HospitalLockers"]="Medical"
	proceduralContainer["MedicalClinicDrugs"]="Medical"
	proceduralContainer["MedicalClinicOutfit"]="Medical"
	proceduralContainer["MedicalStorageDrugs"]="Medical"
	proceduralContainer["MedicalStorageOutfit"]="Medical"
	proceduralContainer["MorgueChemicals"]="Medical"
	proceduralContainer["PharmacyCosmetics"]="Medical"
	proceduralContainer["StoreShelfMedical"]="Medical"
	proceduralContainer["GardenStoreMisc"]="Tool"
	proceduralContainer["BurglarTools"]="Tool"
	proceduralContainer["ButcherTools"]="Tool"
	proceduralContainer["CabinetFactoryTools"]="Tool"
	proceduralContainer["CarSupplyTools"]="Tool"
	proceduralContainer["DrugShackTools"]="Tool"
	proceduralContainer["EngineerTools"]="Tool"
	proceduralContainer["FireStorageTools"]="Tool"
	proceduralContainer["ForestFireTools"]="Tool"
	proceduralContainer["GardenStoreTools"]="Tool"
	proceduralContainer["GigamartTools"]="Tool"
	proceduralContainer["JanitorTools"]="Tool"
	proceduralContainer["LoggingFactoryTools"]="Tool"
	proceduralContainer["MechanicShelfTools"]="Tool"
	proceduralContainer["MedicalClinicTools"]="Tool"
	proceduralContainer["MedicalStorageTools"]="Tool"
	proceduralContainer["MetalShopTools"]="Tool"
	proceduralContainer["MorgueTools"]="Tool"
	proceduralContainer["SewingStoreTools"]="Tool"
	proceduralContainer["ToolStoreAccessories"]="Tool"
	proceduralContainer["ToolStoreBooks"]="Tool"
	proceduralContainer["ToolStoreCarpentry"]="Tool"
	proceduralContainer["ToolStoreFarming"]="Tool"
	proceduralContainer["ToolStoreFootwear"]="Tool"
	proceduralContainer["ToolStoreMetalwork"]="Tool"
	proceduralContainer["ToolStoreMisc"]="Tool"
	proceduralContainer["ToolStoreOutfit"]="Tool"
	proceduralContainer["ToolStoreTools"]="Tool"
end
initProceduralContainer()

local function splitString(_string)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in _string:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local lootTable = {}
local lootCategories = { "Weapon", "Gun", "Police", "Army",}-- "Medical", "Tool", "Mechanic", "Metalwork" }
for i=1, #lootCategories do
	lootTable[lootCategories[i]] = {}
end

local function initWeapons()
	for i=1,4 do
		lootTable[lootCategories[i]]["T1"] = splitString(SandboxVars.RWC.table1)
		lootTable[lootCategories[i]]["T2"] = splitString(SandboxVars.RWC.table2)
		lootTable[lootCategories[i]]["T3"] = splitString(SandboxVars.RWC.table3)
		lootTable[lootCategories[i]]["T4"] = splitString(SandboxVars.RWC.table4)
		lootTable[lootCategories[i]]["T5"] = splitString(SandboxVars.RWC.table5)
		--print("LootTable: ", lootCategories[i])
	end
end
--Events.OnInitGlobalModData.Add(initWeapons)
--Events.EveryTenMinutes.Add(initWeapons)

local function delimit(_string)
	local ztable = {}
	local pattern = "[^ {},=]+"
	local _string = tostring(_string)

	for match in _string:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function onFillContainer(_roomName, _containerType, container)
	if instanceof(container:getParent(), "BaseVehicle") then return end
	
	local sq = container:getSourceGrid()
	if not sq then return end
	
	local SafeHouseSQ = SafeHouse.getSafeHouse(sq)
	--SafeHouseSQ = true
	if SafeHouseSQ then return end
	
	local sq_room = sq:getRoom()
	if not sq_room then return end
	
	if sd_bID[sq:getBuilding():getID()] then return end
	
	local sq_roomDef = sq_room:getRoomDef()
	if not sq_roomDef then return end
	
	if not sq_roomDef:isExplored() then return end
	
	local sq_procedural = sq_roomDef:getProceduralSpawnedContainer()
	if not sq_procedural then return end
	
	local x = sq:getX()
	local y = sq:getY()

	local tier, zone, x, y, control, toxic = checkZoneAtXY(x,y)
	if tier == 1 then return end

	local hashMap = sq_procedural
	local hashString = delimit(hashMap)
	--print(hashMap)
	
	for i=1,#hashString,2 do
		--print(hashString[i] .. "=" .. hashString[i+1])
		if hashString[i+1] == "1" then
			local containerClass = proceduralContainer[hashString[i]]
			if lootTable[containerClass] then
				--if not sd_bID[sq:getBuilding():getID()] then
					--print(containerClass)
					--local _tier = "T"..tier
					--local loot = lootTable[containerClass][_tier]
					--if loot then
						--local _additem = loot[ZombRand(#loot)+1]
						--container:AddItem(_additem)
						for i=1,math.ceil(tier/3) do sq_room:spawnZombies() end
						break
					--end
				--end
			end
		end
	end
end
Events.OnFillContainer.Add(onFillContainer)