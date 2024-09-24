require "Items/ItemPicker"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

-- add items to ProceduralDistributions
local function preDistributionMergeSD5()
----------------------------------------------------------------------------------------
	--[[local propaneSpawn = {
		--CampingStoreGear = 0.01,
		--FireStorageTools = 0.01,
		GigamartTools = 0.025,
		--GardenStoreTools = 0.025,
		--ToolStoreTools = 0.05,
		--GarageMechanics = 0.025,
		GasStorageMechanics = 0.15,
		--StoreShelfMechanics = 0.05,
		--CrateMechanics = 0.025,
		CrateMetalwork = 0.05,
		Chemistry = 0.05,
		CratePropane = 1,
		--CrateRandomJunk = 0.05,
		GarageMetalwork = 0.025,
		MetalShopTools = 0.25,
		ToolStoreMetalwork = 0.05
	}
	
	for distribution, chance in pairs(propaneSpawn) do
		table.insert(ProceduralDistributions.list[distribution].items, "PropaneTank")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "TW.LargePropaneTank")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end]]--
----------------------------------------------------------------------------------------	
	local weaponCacheData = {
		PawnShopGunsSpecial = 0.02,
		MeleeWeapons = 0.04,
		PoliceStorageGuns = 0.02,
		PawnShopKnives = 0.01,
		BarCounterWeapon = 0.001,
		GunStoreAmmunition = 0.01,
		WardrobeMan = 0.000001,
		GunStoreDisplayCase = 0.02,
		PoliceStorageAmmunition = 0.01,
		ArmyStorageGuns = 0.01,
		GunStoreShelf = 0.02
	}

	for distribution, chance in pairs(weaponCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "WeaponCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------	
	local MechMWCacheData = {
		CampingStoreGear = 0.001,
		FireStorageTools = 0.001,
		GigamartTools = 0.001,
		JanitorTools = 0.001,
		BurglarTools = 0.001,
		GardenStoreTools = 0.0001,
		ToolStoreTools = 0.001,
		GarageMechanics = 0.0001,
		GasStorageMechanics = 0.0001,
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
--[[local FarmerCacheData = {
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
	end]]--
----------------------------------------------------------------------------------------
	local AmmoCacheData = {
		PoliceStorageAmmunition = 0.01,
		GunStoreAmmunition = 0.01,
		ArmyStorageAmmunition = 0.01,
		GunStoreCounter = 0.001,
		GunStoreDisplayCase = 0.001,
		GunStoreShelf= 0.001,
		PoliceStorageGuns = 0.001,
		ArmyStorageGuns = 0.001,
		WardrobeMan = 0.0001,
	}
	
	for distribution, chance in pairs(AmmoCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "AmmoCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------	
	local medData = {
		StoreShelfMedical = 0.0001,
		MedicalStorageDrugs = 0.001,
		MedicalClinicDrugs = 0.001,
		ArmyStorageMedical = 0.001,
		MedicalStorageTools = 0.001,
		MedicalClinicTools = 0.001,
	}
	
	for distribution, chance in pairs(medData) do
		table.insert(ProceduralDistributions.list[distribution].items, "MedicalCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------		
	local armorCacheData = {	
		CampingStoreGear = 0.01,
		PawnShopGunsSpecial = 0.01,
		PoliceStorageOutfit = 0.01,
		PoliceLockers = 0.01,
		PoliceStorageGuns = 0.01,
		WardrobeWoman = 0.001,
		ArmySurplusOutfit = 0.01,
		LockerArmyBedroom = 0.01,
		ArmyStorageOutfit = 0.01,
		GunStoreAmmunition = 0.01,
		WardrobeMan = 0.001,
		GunStoreDisplayCase = 0.01,
	}
	
	for distribution, chance in pairs(armorCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "ArmorCacheDefender")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "ArmorCachePatriot")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "ArmorCacheVanguard")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------		
	local toyData = {
		CrateToys = 0.01,
		GigamartToys = 0.01,
		WardrobeChild = 0.01,
		Hobbies = 0.01,
		Gifts = 0.01,
		DaycareShelves = 0.01,
		DaycareDesk = 0.01,
		DaycareCounter = 0.01,
		CrateToys = 0.01,
	}
	
	for distribution, chance in pairs(toyData) do
		table.insert(ProceduralDistributions.list[distribution].items, "SpiffoCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------		
end
	
Events.OnPreDistributionMerge.Add(preDistributionMergeSD5)


local function OnPostDistributionMergeSD5()
	local itemIndex = {}
	local containerIndex = {}

	for containerName, containerData in pairs(ProceduralDistributions.list) do
		-- Index items
		if containerData.items then
			for i = 1, #containerData.items, 2 do  -- Step by 2 to get item name and weight
				local itemName = containerData.items[i]
				itemIndex[itemName] = itemIndex[itemName] or {}
				table.insert(itemIndex[itemName], { container = containerName, type = "items" })
			end
		end

		-- Index junk items
		if containerData.junk and containerData.junk.items then
			for i = 1, #containerData.junk.items, 2 do -- Step by 2 to get item name and weight
				local itemName = containerData.junk.items[i]
				itemIndex[itemName] = itemIndex[itemName] or {}
				table.insert(itemIndex[itemName], { container = containerName, type = "junk" })
			end
		end

		-- Index containers
		containerIndex[containerName] = {
			rolls = containerData.rolls, 
			items = {} -- Store items found within the container
		}

		if containerData.items then
			for i = 1, #containerData.items, 2 do
				local itemName = containerData.items[i]
				table.insert(containerIndex[containerName].items, itemName)
			end
		end
	end


	--[[

	-- Print the entire itemIndex
	for itemName, containerList in pairs(itemIndex) do
	  print("Item:", itemName)
	  for _, containerInfo in ipairs(containerList) do
		print("  - Container:", containerInfo.container, "(Type:", containerInfo.type, ")")
	  end
	end

	-- List of specific items to search for
	local itemsToSearch = {
	  "BookTrapping1", "Book", "PropaneTank"
	}

	for _, itemName in ipairs(itemsToSearch) do
	  if itemIndex[itemName] then
		print("Item:", itemName)
		for _, containerInfo in ipairs(itemIndex[itemName]) do
		  print("  - Container:", containerInfo.container, "(Type:", containerInfo.type, ")")
		end
		print()
	  else
		print("Item '" .. itemName .. "' not found in any containers.")
	  end
	end
	]]--


	-- function to modify item weight
	function modifyItemWeight(itemName, multiplier)
	  if itemIndex[itemName] then
		local processedContainers = {}  -- Track processed containers for this item

		for _, containerInfo in ipairs(itemIndex[itemName]) do
		  local containerName = containerInfo.container
		  if not processedContainers[containerName] then  -- Process each container only once
			local containerData = ProceduralDistributions.list[containerName]
			local itemCount = 0

			if containerInfo.type == "items" then
			  for i = 1, #containerData.items, 2 do
				if containerData.items[i] == itemName then
				  itemCount = itemCount + 1
				  --print("Item:", itemName, "found in", containerName, "(items) - Entry", itemCount)
				  --print("  - Original weight:", containerData.items[i+1])
				  containerData.items[i+1] = containerData.items[i+1] * multiplier
				  --print("  - Modified weight:", containerData.items[i+1])
				end 
			  end
			elseif containerInfo.type == "junk" then
			  for i = 1, #containerData.junk.items, 2 do
				if containerData.junk.items[i] == itemName then
				  itemCount = itemCount + 1
				  --print("Item:", itemName, "found in", containerName, "(junk) - Entry", itemCount)
				  --print("  - Original weight:", containerData.junk.items[i+1])
				  containerData.junk.items[i+1] = containerData.junk.items[i+1] * multiplier
				  --print("  - Modified weight:", containerData.junk.items[i+1])
				end
			  end
			end

			processedContainers[containerName] = true  -- Mark container as processed
		  end
		end
	  end
	end
	
	--foodContainers = { "Bakery", "BakeryBread", "BakeryCake", "BakeryDoughnuts", "BakeryKitchenBaking", "BakeryKitchenFridge", "BakeryKitchenFreezer", "BakeryMisc", "BakeryPie", "BarCounterGlasses", "BarCounterLiquor", "BarCounterMisc", "BarCounterWeapon", "BreweryBottles", "BreweryCans", "BreweryEmptyBottles", "BurgerKitchenButcher", "BurgerKitchenFridge", "BurgerKitchenFreezer", "BurgerKitchenSauce", "ButcherChicken", "ButcherChops", "ButcherFish", "ButcherFreezer", "ButcherGround", "ButcherSnacks", "ButcherSmoked", "ButcherTools", "CafeKitchenFridge", "CafeteriaDrinks", "CafeteriaFruit", "CafeteriaSandwiches", "CafeteriaSnacks", "CandyStoreSnacks", "ChineseKitchenBaking", "ChineseKitchenButcher", "ChineseKitchenFreezer", "ChineseKitchenFridge", "ChineseKitchenSauce", "CrepeKitchenBaking", "CrepeKitchenFridge", "CrepeKitchenSauce", "DeepFryKitchenFridge", "DeepFryKitchenFreezer", "DinerKitchenFridge", "DinerKitchenFreezer", "FishChipsKitchenButcher", "FishChipsKitchenFridge", "FishChipsKitchenFreezer", "FoodGourmet", "FreezerGeneric", "FreezerIceCream", "FreezerRich", "FreezerTrailerPark", "FridgeBeer", "FridgeBottles", "FridgeGeneric", "FridgeOffice", "FridgeOther", "FridgeSnacks", "FridgeSoda", "FridgeTrailerPark", "GigamartBakingMisc", "GigamartBottles", "GigamartCandy", "GigamartCannedFood", "GigamartCrisps", "GigamartDryGoods", "GigamartFarming", "GigamartHousewares", "GigamartLightbulb", "GigamartPots", "GigamartSauce", "GigamartSchool", "GigamartToys", "GroceryStandFruits1", "GroceryStandFruits2", "GroceryStandFruits3", "GroceryStandLettuce", "GroceryStandVegetables1", "GroceryStandVegetables2", "GroceryStandVegetables3", "GroceryStandVegetables4", "GroceryStorageCrate1", "GroceryStorageCrate2", "GroceryStorageCrate3", "ItalianKitchenBaking", "ItalianKitchenButcher", "ItalianKitchenFridge", "ItalianKitchenFreezer", "JaysKitchenBaking", "JaysKitchenBags", "JaysKitchenButcher", "JaysKitchenFridge", "JaysKitchenFreezer", "KitchenBaking", "KitchenBottles", "KitchenBreakfast", "KitchenDishes", "KitchenDryFood", "KitchenPots", "KitchenRandom", "Meat", "MexicanKitchenBaking", "MexicanKitchenButcher", "MexicanKitchenFridge", "MexicanKitchenFreezer", "MexicanKitchenSauce", "MotelFridge", "PizzaKitchenBaking", "PizzaKitchenButcher", "PizzaKitchenCheese", "PizzaKitchenFridge", "PizzaKitchenSauce", "ProduceStorageApples", "ProduceStorageBellPeppers", "ProduceStorageBroccoli", "ProduceStorageCabbages", "ProduceStorageCarrots", "ProduceStorageCherries", "ProduceStorageCorn", "ProduceStorageEggplant", "ProduceStorageLettuce", "ProduceStorageLeeks", "ProduceStorageOnions", "ProduceStoragePeaches", "ProduceStoragePear", "ProduceStoragePotatoes", "ProduceStorageRadishes", "ProduceStorageStrawberries", "ProduceStorageTomatoes", "ProduceStorageWatermelons", "RestaurantKitchenFreezer", "SeafoodKitchenButcher", "SeafoodKitchenFridge", "SeafoodKitchenFreezer", "SeafoodKitchenSauce", "ServingTrayBiscuits", "ServingTrayBurgers", "ServingTrayBurritos", "ServingTrayChicken", "ServingTrayChickenNuggets", "ServingTrayCornbread", "ServingTrayFish", "ServingTrayFries", "ServingTrayGravy", "ServingTrayHotdogs", "ServingTrayMaki", "ServingTrayNoodleSoup", "ServingTrayOmelettes", "ServingTrayOnionRings", "ServingTrayOnigiri", "ServingTrayOysters", "ServingTrayPancakes", "ServingTrayPerogies", "ServingTrayPizza", "ServingTrayPotatoPancakes", "ServingTrayRefriedBeans", "ServingTrayScrambledEggs", "ServingTrayShrimp", "ServingTrayShrimpDumplings", "ServingTraySpringRolls", "ServingTraySushiEgg", "ServingTraySushiFish", "ServingTrayTaco", "ServingTrayTofuFried", "ServingTrayWaffles", "SpiffosKitchenBags", "SpiffosKitchenCounter", "SpiffosKitchenFridge", "SpiffosKitchenFreezer", "SushiKitchenBaking", "SushiKitchenButcher", "SushiKitchenCutlery", "SushiKitchenFridge", "SushiKitchenFreezer", "SushiKitchenSauce" } 
	gunContainers = { "ArmyStorageAmmunition", "ArmyStorageGuns", "FirearmWeapons", "GarageFirearms", "GunStoreAmmunition", "GunStoreCounter", "GunStoreDisplayCase", "GunStoreMagazineRack", "GunStoreShelf", "HuntingLockers", "PawnShopGuns", "PawnShopGunsSpecial", "PlankStashGun", "PoliceStorageAmmunition", "PoliceStorageGuns", "PawnShopCases", "PawnShopGuns", "PawnShopGunsSpecial", "PawnShopKnives" } 

	-- Function to set roll values of a list of containers 
	function setRollValue(containerList, newRollValue)
	  for _, containerName in ipairs(containerList) do
		if ProceduralDistributions.list[containerName] then -- Make sure the container exists in ProceduralDistributions.list
		  ProceduralDistributions.list[containerName].rolls = newRollValue

		  -- Print log message
		  --print("Setting roll value for container:", containerName, "to", newRollValue)
		end
	  end
	end

	-- Set rolls to 1 for food containers
	--setRollValue(foodContainers, 1)
	-- Set rolls to 2 for gun/ammo/weapon containers
	setRollValue(gunContainers, 2)
	
	--item list for removal (setting to 0 chance on distribution)
	local yeetItems = {"RMWeapons.NulBlade", "RMWeapons.bassax", "RMWeapons.crabspear", "RMWeapons.themauler", "RMWeapons.warhammer40k", "RMWeapons.MizutsuneSword", "RMWeapons.Nikabo", "RMWeapons.firelink", "RMWeapons.mace1", "RMWeapons.Falx", "RMWeapons.kindness", "RMWeapons.Crimson1Sword", "RMWeapons.MorningStar", "RMWeapons.BrushAxe", "RMWeapons.sword40k", "RMWeapons.LastHope", "RMWeapons.sawbat1", "RMWeapons.spikedleg", "RMWeapons.TrenchShovel", "RMWeapons.CrimsonLance", "RMWeapons.warhammer", "RMWeapons.MightCleaver", "RMWeapons.Thawk", "RMWeapons.bonkhammer", "RMWeapons.club1", "RMWeapons.PiroCraftKnife", "RMWeapons.steinbeer", "Base.TanPlating", "Base.BluePlating", "Base.RedPlating", "Base.GoldGunPlating", "Base.RainbowPlating", "Base.DZPlating", "Base.RemingtonRiflesDarkCherryStock", "Base.WinterCamoPlating", "Base.WoodStyledPlating", "Base.PinkPlating", "Base.RedWhitePlating", "Base.GreenGoldPlating", "Base.AztecPlating", "Base.DesertEagleGoldPlating", "Base.GoldShotgunPlating", "Base.RainbowAnodizedPlating", "Base.GreenPlating", "Base.SteelDamascusPlating", "Base.SalvagedRagePlating", "Base.ZoidbergSpecialPlating", "Base.NerfPlating", "Base.BespokeEngravedPlating", "Base.SurvivalistPlating", "Base.MysteryMachinePlating", "Base.SalvagedBlackPlating", "Base.PlankPlating", "Base.BlackIcePlating", "Base.BlackDeathPlating", "Base.OrnateIvoryPlating", "Base.GildedAgePlating", "Base.TBDPlating", "Base.CannabisPlating", "Base.Mag9Drum", "Base.Mag57Drum", "Base.MagLugerDrum", "Base.Mag380Drum", "Base.Mag45Drum"}
	local kattaj = {"Base.Military_Shoes_Boots-Black", "Base.Military_Shoes_Boots-Desert", "Base.Military_Shoes_Boots-Green", "Base.Military_Shoes_Boots-White", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Pants_Classic-Black", "Base.Military_Pants_Classic-Black_RollUp", "Base.Military_Pants_Classic-Black_Tuck", "Base.Military_Pants_Classic-Desert", "Base.Military_Pants_Classic-Desert_RollUp", "Base.Military_Pants_Classic-Desert_Tuck", "Base.Military_Pants_Classic-Green", "Base.Military_Pants_Classic-Green_RollUp", "Base.Military_Pants_Classic-Green_Tuck", "Base.Military_Pants_Classic-White", "Base.Military_Pants_Classic-White_RollUp", "Base.Military_Pants_Classic-White_Tuck", "Base.Military_Pants_Cargo-Black", "Base.Military_Pants_Cargo-Black_RollUp", "Base.Military_Pants_Cargo-Black_Tuck", "Base.Military_Pants_Cargo-Desert", "Base.Military_Pants_Cargo-Desert_RollUp", "Base.Military_Pants_Cargo-Desert_Tuck", "Base.Military_Pants_Cargo-Green", "Base.Military_Pants_Cargo-Green_RollUp", "Base.Military_Pants_Cargo-Green_Tuck", "Base.Military_Pants_Cargo-White", "Base.Military_Pants_Cargo-White_RollUp", "Base.Military_Pants_Cargo-White_Tuck", "Base.Military_Pants_Capri-Black", "Base.Military_Pants_Capri-Desert", "Base.Military_Pants_Capri-Green", "Base.Military_Pants_Capri-White", "Base.Military_Pants_CapriSkinny-Black", "Base.Military_Pants_CapriSkinny-Desert", "Base.Military_Pants_CapriSkinny-Green", "Base.Military_Pants_CapriSkinny-White", "Base.Military_Pants_Skinny-Black", "Base.Military_Pants_Skinny-Desert", "Base.Military_Pants_Skinny-Green", "Base.Military_Pants_Skinny-White", "Base.Military_Pants_Shorts-Black", "Base.Military_Pants_Shorts-Desert", "Base.Military_Pants_Shorts-Green", "Base.Military_Pants_Shorts-White", "Base.Military_Pants_ShortsMini-Black", "Base.Military_Pants_ShortsMini-Desert", "Base.Military_Pants_ShortsMini-Green", "Base.Military_Pants_ShortsMini-White", "Base.Military_Pants_ShortsCargo-Black", "Base.Military_Pants_ShortsCargo-Desert", "Base.Military_Pants_ShortsCargo-Green", "Base.Military_Pants_ShortsCargo-White", "Base.Military_Pants_KneeLengthShorts-Black", "Base.Military_Pants_KneeLengthShorts-Desert", "Base.Military_Pants_KneeLengthShorts-Green", "Base.Military_Pants_KneeLengthShorts-White", "Base.Military_Pants_KneeLengthShortsSkinny-Black", "Base.Military_Pants_KneeLengthShortsSkinny-Desert", "Base.Military_Pants_KneeLengthShortsSkinny-Green", "Base.Military_Pants_KneeLengthShortsSkinny-White", "Base.Military_TShirt_TankTop-Black", "Base.Military_TShirt_TankTop-Desert", "Base.Military_TShirt_TankTop-Green", "Base.Military_TShirt_TankTop-White", "Base.Military_TShirt_TankTopShort-Black", "Base.Military_TShirt_TankTopShort-Desert", "Base.Military_TShirt_TankTopShort-Green", "Base.Military_TShirt_TankTopShort-White", "Base.Military_TShirt_TShirt-Black", "Base.Military_TShirt_TShirt-Black_Man", "Base.Military_TShirt_TShirt-Desert", "Base.Military_TShirt_TShirt-Desert_Man", "Base.Military_TShirt_TShirt-Green", "Base.Military_TShirt_TShirt-Green_Man", "Base.Military_TShirt_TShirt-White", "Base.Military_TShirt_TShirt-White_Man", "Base.Military_TShirt_TShirtShort-Black", "Base.Military_TShirt_TShirtShort-Desert", "Base.Military_TShirt_TShirtShort-Green", "Base.Military_TShirt_TShirtShort-White", "Base.Military_TShirt_LongSleeve-Black", "Base.Military_TShirt_LongSleeve-Black_Man", "Base.Military_TShirt_LongSleeve-Desert", "Base.Military_TShirt_LongSleeve-Desert_Man", "Base.Military_TShirt_LongSleeve-Green", "Base.Military_TShirt_LongSleeve-Green_Man", "Base.Military_TShirt_LongSleeve-White", "Base.Military_TShirt_LongSleeve-White_Man", "Base.Military_TShirt_LongSleeveShort-Black", "Base.Military_TShirt_LongSleeveShort-Desert", "Base.Military_TShirt_LongSleeveShort-Green", "Base.Military_TShirt_LongSleeveShort-White", "Base.Military_TShirt_Sleeveless-Black", "Base.Military_TShirt_Sleeveless-Black_Man", "Base.Military_TShirt_Sleeveless-Desert", "Base.Military_TShirt_Sleeveless-Desert_Man", "Base.Military_TShirt_Sleeveless-Green", "Base.Military_TShirt_Sleeveless-Green_Man", "Base.Military_TShirt_Sleeveless-White", "Base.Military_TShirt_Sleeveless-White_Man", "Base.Military_TShirt_SleevelessShort-Black", "Base.Military_TShirt_SleevelessShort-Desert", "Base.Military_TShirt_SleevelessShort-Green", "Base.Military_TShirt_SleevelessShort-White", "Base.Military_TShirt_OneShoulder-Black", "Base.Military_TShirt_OneShoulder-Black_Man", "Base.Military_TShirt_OneShoulder-Desert", "Base.Military_TShirt_OneShoulder-Desert_Man", "Base.Military_TShirt_OneShoulder-Green", "Base.Military_TShirt_OneShoulder-Green_Man", "Base.Military_TShirt_OneShoulder-White", "Base.Military_TShirt_OneShoulder-White_Man", "Base.Military_TShirt_OneShoulderShort-Black", "Base.Military_TShirt_OneShoulderShort-Desert", "Base.Military_TShirt_OneShoulderShort-Green", "Base.Military_TShirt_OneShoulderShort-White", "Base.Military_TShirt_Neckholder-Black", "Base.Military_TShirt_Neckholder-Desert", "Base.Military_TShirt_Neckholder-Green", "Base.Military_TShirt_Neckholder-White", "Base.Military_TShirt_NeckholderShort-Black", "Base.Military_TShirt_NeckholderShort-Desert", "Base.Military_TShirt_NeckholderShort-Green", "Base.Military_TShirt_NeckholderShort-White", "Base.Military_Gloves_Grips-Black", "Base.Military_Gloves_Grips-Desert", "Base.Military_Gloves_Grips-Green", "Base.Military_Gloves_Grips-White", "Base.Military_Gloves_GripFingerless-Black", "Base.Military_Gloves_GripFingerless-Desert", "Base.Military_Gloves_GripFingerless-Green", "Base.Military_Gloves_GripFingerless-White", "Base.Military_Shirt_Classic-Black", "Base.Military_Shirt_Classic-Desert", "Base.Military_Shirt_Classic-Green", "Base.Military_Shirt_Classic-White", "Base.Military_Shirt_ShortSleeveShirt-Black", "Base.Military_Shirt_ShortSleeveShirt-Desert", "Base.Military_Shirt_ShortSleeveShirt-Green", "Base.Military_Shirt_ShortSleeveShirt-White", "Base.Military_BagFront_ChestPouches_Small-Black", "Base.Military_BagFront_ChestPouches_Small-Desert", "Base.Military_BagFront_ChestPouches_Small-Green", "Base.Military_BagFront_ChestPouches_Small-White", "Base.Military_BagFront_ChestPouches_Medium-Black", "Base.Military_BagFront_ChestPouches_Medium-Desert", "Base.Military_BagFront_ChestPouches_Medium-Green", "Base.Military_BagFront_ChestPouches_Medium-White", "Base.Military_BagFront_ChestPouches_Large-Black", "Base.Military_BagFront_ChestPouches_Large-Desert", "Base.Military_BagFront_ChestPouches_Large-Green", "Base.Military_BagFront_ChestPouches_Large-White", "Base.Military_BagBack_StormPack_Small-Black", "Base.Military_BagBack_StormPack_Small-Desert", "Base.Military_BagBack_StormPack_Small-Green", "Base.Military_BagBack_StormPack_Small-White", "Base.Military_BagBack_StormPack_Small-Medic", "Base.Military_BagBack_StormPack_Medium-Black", "Base.Military_BagBack_StormPack_Medium-Desert", "Base.Military_BagBack_StormPack_Medium-Green", "Base.Military_BagBack_StormPack_Medium-White", "Base.Military_BagBack_StormPack_Large-Black", "Base.Military_BagBack_StormPack_Large-Desert", "Base.Military_BagBack_StormPack_Large-Green", "Base.Military_BagBack_StormPack_Large-White", "Base.Military_BagBack_StormPack_Large-Medic", "Base.Military_ThermalUnderwear-Black", "Base.Military_ThermalUnderwear-Desert", "Base.Military_ThermalUnderwear-Green", "Base.Military_ThermalUnderwear-White", "Base.Military_Holster_Defender-Black_HipLeft", "Base.Military_Holster_Defender-Black_HipArmorLeft", "Base.Military_Holster_Defender-Black_BeltLeft", "Base.Military_Holster_Defender-Black_HipRight", "Base.Military_Holster_Defender-Black_HipArmorRight", "Base.Military_Holster_Defender-Black_BeltRight", "Base.Military_Holster_Defender-Desert_HipLeft", "Base.Military_Holster_Defender-Desert_HipArmorLeft", "Base.Military_Holster_Defender-Desert_BeltLeft", "Base.Military_Holster_Defender-Desert_HipRight", "Base.Military_Holster_Defender-Desert_HipArmorRight", "Base.Military_Holster_Defender-Desert_BeltRight", "Base.Military_Holster_Defender-Green_HipLeft", "Base.Military_Holster_Defender-Green_HipArmorLeft", "Base.Military_Holster_Defender-Green_BeltLeft", "Base.Military_Holster_Defender-Green_HipRight", "Base.Military_Holster_Defender-Green_HipArmorRight", "Base.Military_Holster_Defender-Green_BeltRight", "Base.Military_Holster_Defender-White_HipLeft", "Base.Military_Holster_Defender-White_HipArmorLeft", "Base.Military_Holster_Defender-White_BeltLeft", "Base.Military_Holster_Defender-White_HipRight", "Base.Military_Holster_Defender-White_HipArmorRight", "Base.Military_Holster_Defender-White_BeltRight", "Base.Military_MaskHelmet_GasMask-M80", "Base.Military_Sheath_Defender-Black_HipArmorLeft", "Base.Military_Sheath_Defender-Black_BeltLeft", "Base.Military_Sheath_Defender-Black_HipRight", "Base.Military_Sheath_Defender-Black_HipArmorRight", "Base.Military_Sheath_Defender-Black_BeltRight", "Base.Military_Sheath_Defender-Black_Back", "Base.Military_Sheath_Defender-Desert_HipArmorLeft", "Base.Military_Sheath_Defender-Desert_BeltLeft", "Base.Military_Sheath_Defender-Desert_HipRight", "Base.Military_Sheath_Defender-Desert_HipArmorRight", "Base.Military_Sheath_Defender-Desert_BeltRight", "Base.Military_Sheath_Defender-Desert_Back", "Base.Military_Sheath_Defender-Green_HipArmorLeft", "Base.Military_Sheath_Defender-Green_BeltLeft", "Base.Military_Sheath_Defender-Green_HipRight", "Base.Military_Sheath_Defender-Green_HipArmorRight", "Base.Military_Sheath_Defender-Green_BeltRight", "Base.Military_Sheath_Defender-Green_Back", "Base.Military_Sheath_Defender-White_HipArmorLeft", "Base.Military_Sheath_Defender-White_BeltLeft", "Base.Military_Sheath_Defender-White_HipRight", "Base.Military_Sheath_Defender-White_HipArmorRight", "Base.Military_Sheath_Defender-White_BeltRight", "Base.Military_Sheath_Defender-White_Back", "Base.Military_Skirt_KnifePleated-Black", "Base.Military_Skirt_KnifePleated-Desert", "Base.Military_Skirt_KnifePleated-Green", "Base.Military_Skirt_KnifePleated-White", "Base.Military_Skirt_KnifePleated-Press", "Base.Military_Skirt_KnifePleatedShort-Black", "Base.Military_Skirt_KnifePleatedShort-Desert", "Base.Military_Skirt_KnifePleatedShort-Green", "Base.Military_Skirt_KnifePleatedShort-White", "Base.Military_Skirt_KnifePleatedShort-Press", "Base.Military_Skirt_KnifePleatedMini-Black", "Base.Military_Skirt_KnifePleatedMini-Desert", "Base.Military_Skirt_KnifePleatedMini-Green", "Base.Military_Skirt_KnifePleatedMini-White", "Base.Military_Skirt_KnifePleatedMini-Press", "Base.Military_Stockings-Black", "Base.Military_Stockings-Desert", "Base.Military_Stockings-Green", "Base.Military_Stockings-White", "Base.Military_Stockings-Press", "Base.Military_Mask_Balaclava1-Black", "Base.Military_Mask_Balaclava1-Desert", "Base.Military_Mask_Balaclava1-Green", "Base.Military_Mask_Balaclava1-White", "Base.Military_Mask_Balaclava2-Black", "Base.Military_Mask_Balaclava2-Desert", "Base.Military_Mask_Balaclava2-Green", "Base.Military_Mask_Balaclava2-White", "Base.Military_Mask_Balaclava3-Black", "Base.Military_Mask_Balaclava3-Desert", "Base.Military_Mask_Balaclava3-Green", "Base.Military_Mask_Balaclava3-White", "Base.Military_Mask_BandanaMask-Black", "Base.Military_Mask_BandanaMask-Desert", "Base.Military_Mask_BandanaMask-Green", "Base.Military_Mask_BandanaMask-White", "Base.Military_Jacket_Classic-Black", "Base.Military_Jacket_Classic-Black_Open", "Base.Military_Jacket_Classic-Black_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Black_RolledUpSleeves", "Base.Military_Jacket_Classic-Desert_Open", "Base.Military_Jacket_Classic-Desert_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Desert_RolledUpSleeves", "Base.Military_Jacket_Classic-Green", "Base.Military_Jacket_Classic-Green_Open", "Base.Military_Jacket_Classic-Green_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Green_RolledUpSleeves", "Base.Military_Jacket_Classic-White", "Base.Military_Jacket_Classic-White_Open", "Base.Military_Jacket_Classic-White_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-White_RolledUpSleeves", "Base.Military_Jacket_Lightweight-Black", "Base.Military_Jacket_Lightweight-Desert_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-Desert_RolledUpSleeves", "Base.Military_Jacket_Lightweight-Green", "Base.Military_Jacket_Lightweight-Green_Open", "Base.Military_Jacket_Lightweight-Green_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-Green_RolledUpSleeves", "Base.Military_Jacket_Lightweight-White", "Base.Military_Jacket_Lightweight-White_Open", "Base.Military_Jacket_Lightweight-White_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-White_RolledUpSleeves", "Base.Military_Jacket_WinterHood-Black_DOWN", "Base.Military_Jacket_WinterHood-Black_DOWN_Open", "Base.Military_Jacket_WinterHood-Black_Up", "Base.Military_Jacket_WinterHood-Black_Up_Open", "Base.Military_Jacket_WinterHood-Desert_DOWN", "Base.Military_Jacket_WinterHood-Desert_DOWN_Open", "Base.Military_Jacket_WinterHood-Desert_Up", "Base.Military_Jacket_WinterHood-Desert_Up_Open", "Base.Military_Jacket_WinterHood-Green_DOWN", "Base.Military_Jacket_WinterHood-Green_DOWN_Open", "Base.Military_Jacket_WinterHood-Green_Up", "Base.Military_Jacket_WinterHood-Green_Up_Open", "Base.Military_Jacket_WinterHood-White_DOWN", "Base.Military_Jacket_WinterHood-White_DOWN_Open", "Base.Military_Jacket_WinterHood-White_Up", "Base.Military_Jacket_WinterHood-White_Up_Open", "Base.Military_Backpack_Pocket_Small-Black", "Base.Military_Backpack_Pocket_Small-Black_Tight", "Base.Military_Backpack_Pocket_Small-Green", "Base.Military_Backpack_Pocket_Small-Green_Tight", "Base.Military_Backpack_Pocket_Small-Desert", "Base.Military_Backpack_Pocket_Small-Desert_Tight", "Base.Military_Backpack_Pocket_Small-White", "Base.Military_Backpack_Pocket_Small-White_Tight", "Base.Military_Backpack_Strategist_Medium-Black", "Base.Military_Backpack_Strategist_Medium-Black_Tight", "Base.Military_Backpack_Strategist_Medium-Green", "Base.Military_Backpack_Strategist_Medium-Green_Tight", "Base.Military_Backpack_Strategist_Medium-Desert", "Base.Military_Backpack_Strategist_Medium-Desert_Tight", "Base.Military_Backpack_Strategist_Medium-White", "Base.Military_Backpack_Strategist_Medium-White_Tight", "Base.Military_Backpack_Echo_Radio-Black", "Base.Military_Backpack_Echo_Radio-Black_Tight", "Base.Military_Backpack_Echo_Radio-Green", "Base.Military_Backpack_Echo_Radio-Green_Tight", "Base.Military_Backpack_Echo_Radio-Desert", "Base.Military_Backpack_Echo_Radio-Desert_Tight", "Base.Military_Backpack_Echo_Radio-White", "Base.Military_Backpack_Echo_Radio-White_Tight", "Base.Military_Backpack_Ranger_Large-Black", "Base.Military_Backpack_Ranger_Large-Black_Tight", "Base.Military_Backpack_Ranger_Large-Green", "Base.Military_Backpack_Ranger_Large-Green_Tight", "Base.Military_Backpack_Ranger_Large-Desert", "Base.Military_Backpack_Ranger_Large-Desert_Tight", "Base.Military_Backpack_Ranger_Large-White", "Base.Military_Backpack_Ranger_Large-White_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Black", "Base.Military_Backpack_Colossus_VeryLarge-Black_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Green", "Base.Military_Backpack_Colossus_VeryLarge-Green_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Desert", "Base.Military_Backpack_Colossus_VeryLarge-Desert_Tight", "Base.Military_Backpack_Colossus_VeryLarge-White", "Base.Military_Backpack_Colossus_VeryLarge-White_Tight", "Base.Military_Glasses_ShatterShield", "Base.Military_BagLeg_MagSecure_Small-Black_Left", "Base.Military_BagLeg_MagSecure_Small-Black_Right", "Base.Military_BagLeg_MagSecure_Small-Black_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Black_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-Desert_Left", "Base.Military_BagLeg_MagSecure_Small-Desert_Right", "Base.Military_BagLeg_MagSecure_Small-Desert_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Desert_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-Green_Left", "Base.Military_BagLeg_MagSecure_Small-Green_Right", "Base.Military_BagLeg_MagSecure_Small-Green_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Green_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-White_Left", "Base.Military_BagLeg_MagSecure_Small-White_Right", "Base.Military_BagLeg_MagSecure_Small-White_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-White_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Black_Left", "Base.Military_BagLeg_Utility_Medium-Black_Right", "Base.Military_BagLeg_Utility_Medium-Black_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Black_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Desert_Left", "Base.Military_BagLeg_Utility_Medium-Desert_Right", "Base.Military_BagLeg_Utility_Medium-Desert_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Desert_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Green_Left", "Base.Military_BagLeg_Utility_Medium-Green_Right", "Base.Military_BagLeg_Utility_Medium-Green_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Green_ArmorRight", "Base.Military_BagLeg_Utility_Medium-White_Left", "Base.Military_BagLeg_Utility_Medium-White_Right", "Base.Military_BagLeg_Utility_Medium-White_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-White_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Medic_Left", "Base.Military_BagLeg_Utility_Medium-Medic_Right", "Base.Military_BagLeg_Utility_Medium-Medic_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Medic_ArmorRight", "Base.Military_Hat_WarComms-Black", "Base.Military_Hat_WarComms-Desert", "Base.Military_Hat_WarComms-Green", "Base.Military_Hat_WarComms-White", "Base.Military_Hat_Beret-Black", "Base.Military_Hat_Beret-Desert", "Base.Military_Hat_Beret-Green", "Base.Military_Hat_Beret-White", "Base.Military_Hat_Beret-Red", "Base.Military_Hat_BaseballCapM-Black", "Base.Military_Hat_BaseballCapM-Desert", "Base.Military_Hat_BaseballCapM-Green", "Base.Military_Hat_BaseballCapM-White"}
	--skill books
	local skillbooks1 = {"BookTrapping1", "BookFishing1", "BookCarpentry1", "BookMechanic1", "BookFirstAid1", "BookBlacksmith1", "BookMetalWelding1", "BookElectrician1", "BookCooking1", "BookFarming1", "BookForaging1", "BookTailoring1"}
	local skillbooks2 = {"BookTrapping2", "BookFishing2", "BookCarpentry2", "BookMechanic2", "BookFirstAid2", "BookBlacksmith2", "BookMetalWelding2", "BookElectrician2", "BookCooking2", "BookFarming2", "BookForaging2", "BookTailoring2"}
	local skillbooks3 = {"BookTrapping3", "BookFishing3", "BookCarpentry3", "BookMechanic3", "BookFirstAid3", "BookBlacksmith3", "BookMetalWelding3", "BookElectrician3", "BookCooking3", "BookFarming3", "BookForaging3", "BookTailoring3"}
	local skillbooks4 = {"BookTrapping4", "BookFishing4", "BookCarpentry4", "BookMechanic4", "BookFirstAid4", "BookBlacksmith4", "BookMetalWelding4", "BookElectrician4", "BookCooking4", "BookFarming4", "BookForaging4", "BookTailoring4"}	
	local skillbooks5 = {"BookTrapping5", "BookFishing5", "BookCarpentry5", "BookMechanic5", "BookFirstAid5", "BookBlacksmith5", "BookMetalWelding5", "BookElectrician5", "BookCooking5", "BookFarming5", "BookForaging5", "BookTailoring5"}	
	
	--foods
	local baseFoods = {"Base.Lard", "Base.Pasta", "Base.DriedKidneyBeans", "Base.Margarine", "Base.Butter", "Base.DriedBlackBeans", "Base.DriedLentils", "Base.Rice", "Base.DriedChickpeas", "Base.DriedWhiteBeans", "Base.PeanutButter", "Base.OilOlive", "Base.Cereal", "Base.DriedSplitPeas", "Base.OilVegetable", "Base.WhiskeyFull", "Base.OatsRaw", "Base.Ketchup", "Base.MapleSyrup", "Base.Chocolate", "Base.CannedCornedBeef", "Base.Crisps", "Base.Crisps2", "Base.Crisps3", "Base.Crisps4", "Base.Macandcheese", "Base.TVDinner", "Base.Honey", "Base.JamFruit", "Base.JamMarmalade", "Base.CannedBolognese", "Base.DoughRolled", "Base.Wine2", "Base.Mustard", "Base.CandyPackage", "Base.Dogfood", "Base.Wine", "Base.CannedMilk", "Base.Hotsauce", "Base.TortillaChips", "Base.PopBottle", "Base.Sugar", "Base.TunaTin", "Base.Marinara", "Base.CinnamonRoll", "Base.SugarBrown", "Base.CannedCorn", "Base.CannedPeas", "Base.CannedChili", "Base.CannedFruitCocktail", "Base.CannedFruitBeverage", "Base.CannedPeaches", "Base.CannedPineapple"}
	local sapphFoods = {"SapphCooking.Tortellini", "SapphCooking.ArborioRice", "SapphCooking.BrownRice", "SapphCooking.PeanutOil", "SapphCooking.CanolaOil", "SapphCooking.AvocadoOil", "SapphCooking.ChocolateEgg_Large", "SapphCooking.WhiteChocolate", "SapphCooking.ChickenBroth", "SapphCooking.BeefBroth", "SapphCooking.VegetableBroth", "SapphCooking.Syrup_Chocolate", "SapphCooking.Syrup_Strawberry", "SapphCooking.Syrup_Caramel", "SapphCooking.PastaSheets", "SapphCooking.PastryDough", "SapphCooking.CachacaFull", "SapphCooking.RolledPastaDough", "SapphCooking.FilledMeatPastaDough", "SapphCooking.Gingerbread_House", "SapphCooking.BananaBread_Dough", "SapphCooking.ColaBottle", "SapphCooking.CannedBread", "SapphCooking.PipingBag_PastryDough", "SapphCooking.Vermouth", "SapphCooking.WokPan_YakisobaEvolved", "SapphCooking.GinFull", "SapphCooking.TequilaFull", "SapphCooking.VodkaFull", "SapphCooking.SapphDoughnutChocolate", "SapphCooking.ChocolateEgg_Medium", "SapphCooking.SapphTortillaChips", "SapphCooking.CannedSausages", "SapphCooking.CannedBacon", "SapphCooking.CanofBeets", "SapphCooking.BagofFlourTortillas"}
	--print("--------------------------------------------")
	--print("SD5 Modification to Loot Distribution Start.")
	--print("--------------------------------------------")
	
	--set items to zero to effectively yeet off table
	for i=1,#yeetItems do
		modifyItemWeight(yeetItems[i], 0)
	end
	
	--1/8 chance to set to 10% spawn rate, otherwise sets to 0. #kattaj has 391 items and is very bloated.
	for i=1,#kattaj do
		if ZombRand(8) == 0 then
			modifyItemWeight(kattaj[i], 0.05)
		else
			modifyItemWeight(kattaj[i], 0)
		end
	end
	
	--reduce spawn rates of these foods
	for i=1,#baseFoods do
		modifyItemWeight(baseFoods[i], 0.15)
	end
	
	for i=1,#sapphFoods do
		modifyItemWeight(sapphFoods[i], 0.15)
	end

	--modification to skillbooks (12 skillbooks in #1-#5)
	for i=1,#skillbooks1 do
		modifyItemWeight(skillbooks1[i], 0.1)
		modifyItemWeight(skillbooks2[i], 0.08)
		modifyItemWeight(skillbooks3[i], 0.06)
		modifyItemWeight(skillbooks4[i], 0.04)
		modifyItemWeight(skillbooks5[i], 0.02)
	end

	--modification to Books, otherwise it will outbloat skillbooks
	modifyItemWeight("Book", 0.125)
	--modifier to Caches. because I'm lazy
	--modifyItemWeight("WeaponCache", 1.0)
	--modifyItemWeight("AmmoCache", 2.0)
	--modifyItemWeight("MetalworkCache", 0.5)
	--modifyItemWeight("MechanicCache", 1.0)
	--modifyItemWeight("MedicalCache", 2.0)
	--modifier to Propane Tanks for rarity
	modifyItemWeight("PropaneTank", 0)
	--modifier to Workshop Large Propane Tank for rarity
	modifyItemWeight("TW.LargePropaneTank", 0)
	--modifier to Biofuel Industrial Propane Tank for rarity
	modifyItemWeight("Biofuel.IndustrialPropaneTank", 0)
	
	table.remove(ProceduralDistributions.list.GarageMetalwork.junk.items, 1)
	table.remove(ProceduralDistributions.list.GarageMetalwork.junk.items, 1)

	--print("-----------------------------------------------")
	--print("SD5 Modification to Loot Distribution Complete.")
	--print("-----------------------------------------------")
	
end

Events.OnPostDistributionMerge.Add(OnPostDistributionMergeSD5)
