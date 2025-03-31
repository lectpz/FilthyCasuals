require "Items/ItemPicker"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

local function removeBaseFromFullType(ItemFullType)
	return string.gsub(ItemFullType, "^Base.", "")
end

local function getSandboxItems(sandboxvar)
	local ztable = {}
	local pattern = "[^ %;]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function getItemandChance(sandboxvar)
	local ztable = {}
	local pattern = "[^ %:]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

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
		table.insert(ProceduralDistributions.list[distribution].items, "ChiikuCache")
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
		--table.insert(ProceduralDistributions.list[distribution].items, "SoulForgeCache")
		--table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------		
	local armorCacheData = {	
		CampingStoreGear = 0.0001,
		PawnShopGunsSpecial = 0.0001,
		PoliceStorageOutfit = 0.0001,
		PoliceLockers = 0.0001,
		PoliceStorageGuns = 0.0001,
		WardrobeWoman = 0.00001,
		ArmySurplusOutfit = 0.0001,
		LockerArmyBedroom = 0.0001,
		ArmyStorageOutfit = 0.0001,
		GunStoreAmmunition = 0.0001,
		WardrobeMan = 0.00001,
		GunStoreDisplayCase = 0.0001,
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
	local jewelryData = {
		DepartmentStoreJewelry = 0.001,
		DepartmentStoreWatches = 0.001,
		JewelryGems = 0.001,
		JewelryGold = 0.001,
		JewelryNavelRings = 0.001,
		JewelryOthers = 0.001,
		JewelrySilver = 0.001,
		JewelryStorageAll = 0.001,
		JewelryWeddingRings = 0.001,
		JewelryWrist = 0.001,
	}
	
	for distribution, chance in pairs(jewelryData) do
		table.insert(ProceduralDistributions.list[distribution].items, "JewelryCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)

	end
----------------------------------------------------------------------------------------	
	local barData = {
		StoreShelfWhiskey = 0.000001,
		BarCounterWeapon = 0.0001,
		BarCounterLiquor = 0.0001,
		BarShelfLiquor = 0.0001,
		WhiskeyBottlingFull = 0.0000001,
		JanitorMisc = 0.000001,
		PrisonCellRandom = 0.0001,
	}
	
	for distribution, chance in pairs(barData) do
		table.insert(ProceduralDistributions.list[distribution].items, "SoulForgeCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end
----------------------------------------------------------------------------------------
	local toyData = {
		CrateToys = 0.001,
		GigamartToys = 0.001,
		WardrobeChild = 0.001,
		Hobbies = 0.001,
		Gifts = 0.001,
		DaycareShelves = 0.001,
		DaycareDesk = 0.001,
		DaycareCounter = 0.001,
		CrateToys = 0.001,
	}
	
	for distribution, chance in pairs(toyData) do
		table.insert(ProceduralDistributions.list[distribution].items, "SpiffoCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "PokemonCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
		table.insert(ProceduralDistributions.list[distribution].items, "ShinyPokemonCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end		
----------------------------------------------------------------------------------------
end
	
Events.OnPreDistributionMerge.Add(preDistributionMergeSD5)


local function editDistributions()
	local itemIndex = {}
	local containerIndex = {}

	for containerName, containerData in pairs(ProceduralDistributions.list) do
		if containerData.items then
			for i = 1, #containerData.items, 2 do
				local itemName = containerData.items[i]
				itemIndex[itemName] = itemIndex[itemName] or {}
				table.insert(itemIndex[itemName], { container = containerName, type = "items" })
			end
		end

		if containerData.junk and containerData.junk.items then
			for i = 1, #containerData.junk.items, 2 do
				local itemName = containerData.junk.items[i]
				itemIndex[itemName] = itemIndex[itemName] or {}
				table.insert(itemIndex[itemName], { container = containerName, type = "junk" })
			end
		end

		containerIndex[containerName] = {
			rolls = containerData.rolls, 
			items = {}
		}

		if containerData.items then
			for i = 1, #containerData.items, 2 do
				local itemName = containerData.items[i]
				table.insert(containerIndex[containerName].items, itemName)
			end
		end
	end

	local function yeetItem(item)
		local itemName = item
		if itemIndex[itemName] then
			for j=1,#itemIndex[itemName] do
				containerInfo = itemIndex[itemName][j]
				containerJunk = ""
				local itemDistro = ProceduralDistributions.list[containerInfo.container][containerInfo.type]
				if containerInfo.type == "junk" then
					containerJunk = ".items"
					itemDistro = ProceduralDistributions.list[containerInfo.container][containerInfo.type]["items"]
				end
				for k=#itemDistro,1,-1 do
					if itemDistro[k] == itemName then
						table.remove(itemDistro, k)
						table.remove(itemDistro, k)
						--print("Removing " .. itemName .." from ProceduralDistributions.list."..containerInfo.container.."."..containerInfo.type..containerJunk)
					end
				end
			end
		end
	end

	local function findItem(item)
		local itemName = item
		if itemIndex[itemName] then
			for i=1,#itemIndex[itemName] do
				containerInfo = itemIndex[itemName][i]
				containerJunk = ""
				if containerInfo.type == "junk" then
					containerJunk = ".items"
				end
				--print("Found " .. itemName .." from ProceduralDistributions.list."..containerInfo.container.."."..containerInfo.type..containerJunk)
			end
		else
			print(itemName .. " not found!")
		end
	end

	local function findItemInDistribution(item)
		local itemName = item
		if itemIndex[itemName] then
			for i=1,#itemIndex[itemName] do
				containerInfo = itemIndex[itemName][i]
				containerJunk = nil
				if containerInfo.type == "junk" then
					containerJunk = "items"
				end
				pdl = ProceduralDistributions.list[containerInfo.container][containerInfo.type]
				--print("Found " .. itemName .." from ProceduralDistributions.list."..containerInfo.container.."."..containerInfo.type..containerJunk)
				if not containerJunk then 
					for k=1, #pdl, 2 do
						if pdl[k] == itemName then print("Item found in " .. containerInfo.container .. " container:" .. pdl[k] .. "," .. pdl[k+1]) end
					end
				else
					--print(ProceduralDistributions.list[containerInfo.container][containerInfo.type].items)
					for k=1, #pdl.items, 2 do
						if pdl.items[k] == itemName then print("Item found in " .. containerInfo.container.. " junk container:" ..  pdl.items[k], pdl.items[k+1]) end
					end
				end
			end
		end
	end

	local function modifyItemWeight(itemName, multiplier)
		if itemIndex[itemName] then
			local processedContainers = {}
			for j=1, #itemIndex[itemName] do
				containerInfo = itemIndex[itemName][j]
				local containerName = containerInfo.container
				if not processedContainers[containerName] then
					local containerData = ProceduralDistributions.list[containerName]
					if containerInfo.type == "items" then
						for i = 1, #containerData.items, 2 do
							if containerData.items[i] == itemName then
								containerData.items[i+1] = containerData.items[i+1] * multiplier
								--print("Modifying " .. itemName .. " weight to: " .. containerData.items[i+1] .. " from ProceduralDistributions.list."..containerInfo.container.."."..containerInfo.type)
							end 
						end
					elseif containerInfo.type == "junk" then
						for i = 1, #containerData.junk.items, 2 do
							if containerData.junk.items[i] == itemName then
								containerData.junk.items[i+1] = containerData.junk.items[i+1] * multiplier
								--print("Modifying " .. itemName .. " weight to: " .. containerData.junk.items[i+1] .. " from ProceduralDistributions.list."..containerInfo.container.."."..containerInfo.type..".items")
							end
						end
					end
					processedContainers[containerName] = true
				end
			end
		end
	end
	
	--foodContainers = { "Bakery", "BakeryBread", "BakeryCake", "BakeryDoughnuts", "BakeryKitchenBaking", "BakeryKitchenFridge", "BakeryKitchenFreezer", "BakeryMisc", "BakeryPie", "BarCounterGlasses", "BarCounterLiquor", "BarCounterMisc", "BarCounterWeapon", "BreweryBottles", "BreweryCans", "BreweryEmptyBottles", "BurgerKitchenButcher", "BurgerKitchenFridge", "BurgerKitchenFreezer", "BurgerKitchenSauce", "ButcherChicken", "ButcherChops", "ButcherFish", "ButcherFreezer", "ButcherGround", "ButcherSnacks", "ButcherSmoked", "ButcherTools", "CafeKitchenFridge", "CafeteriaDrinks", "CafeteriaFruit", "CafeteriaSandwiches", "CafeteriaSnacks", "CandyStoreSnacks", "ChineseKitchenBaking", "ChineseKitchenButcher", "ChineseKitchenFreezer", "ChineseKitchenFridge", "ChineseKitchenSauce", "CrepeKitchenBaking", "CrepeKitchenFridge", "CrepeKitchenSauce", "DeepFryKitchenFridge", "DeepFryKitchenFreezer", "DinerKitchenFridge", "DinerKitchenFreezer", "FishChipsKitchenButcher", "FishChipsKitchenFridge", "FishChipsKitchenFreezer", "FoodGourmet", "FreezerGeneric", "FreezerIceCream", "FreezerRich", "FreezerTrailerPark", "FridgeBeer", "FridgeBottles", "FridgeGeneric", "FridgeOffice", "FridgeOther", "FridgeSnacks", "FridgeSoda", "FridgeTrailerPark", "GigamartBakingMisc", "GigamartBottles", "GigamartCandy", "GigamartCannedFood", "GigamartCrisps", "GigamartDryGoods", "GigamartFarming", "GigamartHousewares", "GigamartLightbulb", "GigamartPots", "GigamartSauce", "GigamartSchool", "GigamartToys", "GroceryStandFruits1", "GroceryStandFruits2", "GroceryStandFruits3", "GroceryStandLettuce", "GroceryStandVegetables1", "GroceryStandVegetables2", "GroceryStandVegetables3", "GroceryStandVegetables4", "GroceryStorageCrate1", "GroceryStorageCrate2", "GroceryStorageCrate3", "ItalianKitchenBaking", "ItalianKitchenButcher", "ItalianKitchenFridge", "ItalianKitchenFreezer", "JaysKitchenBaking", "JaysKitchenBags", "JaysKitchenButcher", "JaysKitchenFridge", "JaysKitchenFreezer", "KitchenBaking", "KitchenBottles", "KitchenBreakfast", "KitchenDishes", "KitchenDryFood", "KitchenPots", "KitchenRandom", "Meat", "MexicanKitchenBaking", "MexicanKitchenButcher", "MexicanKitchenFridge", "MexicanKitchenFreezer", "MexicanKitchenSauce", "MotelFridge", "PizzaKitchenBaking", "PizzaKitchenButcher", "PizzaKitchenCheese", "PizzaKitchenFridge", "PizzaKitchenSauce", "ProduceStorageApples", "ProduceStorageBellPeppers", "ProduceStorageBroccoli", "ProduceStorageCabbages", "ProduceStorageCarrots", "ProduceStorageCherries", "ProduceStorageCorn", "ProduceStorageEggplant", "ProduceStorageLettuce", "ProduceStorageLeeks", "ProduceStorageOnions", "ProduceStoragePeaches", "ProduceStoragePear", "ProduceStoragePotatoes", "ProduceStorageRadishes", "ProduceStorageStrawberries", "ProduceStorageTomatoes", "ProduceStorageWatermelons", "RestaurantKitchenFreezer", "SeafoodKitchenButcher", "SeafoodKitchenFridge", "SeafoodKitchenFreezer", "SeafoodKitchenSauce", "ServingTrayBiscuits", "ServingTrayBurgers", "ServingTrayBurritos", "ServingTrayChicken", "ServingTrayChickenNuggets", "ServingTrayCornbread", "ServingTrayFish", "ServingTrayFries", "ServingTrayGravy", "ServingTrayHotdogs", "ServingTrayMaki", "ServingTrayNoodleSoup", "ServingTrayOmelettes", "ServingTrayOnionRings", "ServingTrayOnigiri", "ServingTrayOysters", "ServingTrayPancakes", "ServingTrayPerogies", "ServingTrayPizza", "ServingTrayPotatoPancakes", "ServingTrayRefriedBeans", "ServingTrayScrambledEggs", "ServingTrayShrimp", "ServingTrayShrimpDumplings", "ServingTraySpringRolls", "ServingTraySushiEgg", "ServingTraySushiFish", "ServingTrayTaco", "ServingTrayTofuFried", "ServingTrayWaffles", "SpiffosKitchenBags", "SpiffosKitchenCounter", "SpiffosKitchenFridge", "SpiffosKitchenFreezer", "SushiKitchenBaking", "SushiKitchenButcher", "SushiKitchenCutlery", "SushiKitchenFridge", "SushiKitchenFreezer", "SushiKitchenSauce" } 
	gunContainers = { "ArmyStorageAmmunition", "ArmyStorageGuns", "FirearmWeapons", "GarageFirearms", "GunStoreAmmunition", "GunStoreCounter", "GunStoreDisplayCase", "GunStoreMagazineRack", "GunStoreShelf", "HuntingLockers", "PawnShopGuns", "PawnShopGunsSpecial", "PlankStashGun", "PoliceStorageAmmunition", "PoliceStorageGuns", "PawnShopCases", "PawnShopGuns", "PawnShopGunsSpecial", "PawnShopKnives" } 

	function setRollValue(containerList, newRollValue)
	  --for _, containerName in ipairs(containerList) do
	  for i=1, #containerList do
		containerName = containerList[i]
		if ProceduralDistributions.list[containerName] then
		  ProceduralDistributions.list[containerName].rolls = newRollValue
		end
	  end
	end

	-- Set rolls to 1 for food containers
	--setRollValue(foodContainers, 1)
	-- Set rolls to 2 for gun/ammo/weapon containers
	--setRollValue(gunContainers, 2)
	
	local yeetBool = SandboxVars.SpawnChanceModifier.yeetBool
	local yeetItems = getSandboxItems(SandboxVars.SpawnChanceModifier.yeetItems)
	if yeetBool and #yeetItems > 0 then
		for i=1,#yeetItems do
			yeetItem(yeetItems[i])
			yeetItem(removeBaseFromFullType(yeetItems[i]))
		end
	end
	
	local modifyBool = SandboxVars.SpawnChanceModifier.modifyBool
	local modifyItems = getSandboxItems(SandboxVars.SpawnChanceModifier.modifyItems)
	if modifyBool and #modifyItems > 0 then
		for i=1,#modifyItems do
			local item_and_chance = getItemandChance(modifyItems[i])
			modifyItemWeight(item_and_chance[1], item_and_chance[2])
			modifyItemWeight(removeBaseFromFullType(item_and_chance[1]), item_and_chance[2])
		end
	end
	
	local removeItems = {"RMWeapons.NulBlade", "RMWeapons.bassax", "RMWeapons.crabspear", "RMWeapons.themauler", "RMWeapons.warhammer40k", "RMWeapons.MizutsuneSword", "RMWeapons.Nikabo", "RMWeapons.firelink", "RMWeapons.mace1", "RMWeapons.Falx", "RMWeapons.kindness", "RMWeapons.Crimson1Sword", "RMWeapons.MorningStar", "RMWeapons.BrushAxe", "RMWeapons.sword40k", "RMWeapons.LastHope", "RMWeapons.sawbat1", "RMWeapons.spikedleg", "RMWeapons.TrenchShovel", "RMWeapons.CrimsonLance", "RMWeapons.warhammer", "RMWeapons.MightCleaver", "RMWeapons.Thawk", "RMWeapons.bonkhammer", "RMWeapons.club1", "RMWeapons.PiroCraftKnife", "RMWeapons.steinbeer", "Base.TanPlating", "Base.BluePlating", "Base.RedPlating", "Base.GoldGunPlating", "Base.RainbowPlating", "Base.DZPlating", "Base.RemingtonRiflesDarkCherryStock", "Base.WinterCamoPlating", "Base.WoodStyledPlating", "Base.PinkPlating", "Base.RedWhitePlating", "Base.GreenGoldPlating", "Base.AztecPlating", "Base.DesertEagleGoldPlating", "Base.GoldShotgunPlating", "Base.RainbowAnodizedPlating", "Base.GreenPlating", "Base.SteelDamascusPlating", "Base.SalvagedRagePlating", "Base.ZoidbergSpecialPlating", "Base.NerfPlating", "Base.BespokeEngravedPlating", "Base.SurvivalistPlating", "Base.MysteryMachinePlating", "Base.SalvagedBlackPlating", "Base.PlankPlating", "Base.BlackIcePlating", "Base.BlackDeathPlating", "Base.OrnateIvoryPlating", "Base.GildedAgePlating", "Base.TBDPlating", "Base.CannabisPlating", "Base.Mag9Drum", "Base.Mag57Drum", "Base.MagLugerDrum", "Base.Mag380Drum", "Base.Mag45Drum"}
	local kattaj = {"Base.Military_Shoes_Boots-Black", "Base.Military_Shoes_Boots-Desert", "Base.Military_Shoes_Boots-Green", "Base.Military_Shoes_Boots-White", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Shoes_TacticalBoots", "Base.Military_Pants_Classic-Black", "Base.Military_Pants_Classic-Black_RollUp", "Base.Military_Pants_Classic-Black_Tuck", "Base.Military_Pants_Classic-Desert", "Base.Military_Pants_Classic-Desert_RollUp", "Base.Military_Pants_Classic-Desert_Tuck", "Base.Military_Pants_Classic-Green", "Base.Military_Pants_Classic-Green_RollUp", "Base.Military_Pants_Classic-Green_Tuck", "Base.Military_Pants_Classic-White", "Base.Military_Pants_Classic-White_RollUp", "Base.Military_Pants_Classic-White_Tuck", "Base.Military_Pants_Cargo-Black", "Base.Military_Pants_Cargo-Black_RollUp", "Base.Military_Pants_Cargo-Black_Tuck", "Base.Military_Pants_Cargo-Desert", "Base.Military_Pants_Cargo-Desert_RollUp", "Base.Military_Pants_Cargo-Desert_Tuck", "Base.Military_Pants_Cargo-Green", "Base.Military_Pants_Cargo-Green_RollUp", "Base.Military_Pants_Cargo-Green_Tuck", "Base.Military_Pants_Cargo-White", "Base.Military_Pants_Cargo-White_RollUp", "Base.Military_Pants_Cargo-White_Tuck", "Base.Military_Pants_Capri-Black", "Base.Military_Pants_Capri-Desert", "Base.Military_Pants_Capri-Green", "Base.Military_Pants_Capri-White", "Base.Military_Pants_CapriSkinny-Black", "Base.Military_Pants_CapriSkinny-Desert", "Base.Military_Pants_CapriSkinny-Green", "Base.Military_Pants_CapriSkinny-White", "Base.Military_Pants_Skinny-Black", "Base.Military_Pants_Skinny-Desert", "Base.Military_Pants_Skinny-Green", "Base.Military_Pants_Skinny-White", "Base.Military_Pants_Shorts-Black", "Base.Military_Pants_Shorts-Desert", "Base.Military_Pants_Shorts-Green", "Base.Military_Pants_Shorts-White", "Base.Military_Pants_ShortsMini-Black", "Base.Military_Pants_ShortsMini-Desert", "Base.Military_Pants_ShortsMini-Green", "Base.Military_Pants_ShortsMini-White", "Base.Military_Pants_ShortsCargo-Black", "Base.Military_Pants_ShortsCargo-Desert", "Base.Military_Pants_ShortsCargo-Green", "Base.Military_Pants_ShortsCargo-White", "Base.Military_Pants_KneeLengthShorts-Black", "Base.Military_Pants_KneeLengthShorts-Desert", "Base.Military_Pants_KneeLengthShorts-Green", "Base.Military_Pants_KneeLengthShorts-White", "Base.Military_Pants_KneeLengthShortsSkinny-Black", "Base.Military_Pants_KneeLengthShortsSkinny-Desert", "Base.Military_Pants_KneeLengthShortsSkinny-Green", "Base.Military_Pants_KneeLengthShortsSkinny-White", "Base.Military_TShirt_TankTop-Black", "Base.Military_TShirt_TankTop-Desert", "Base.Military_TShirt_TankTop-Green", "Base.Military_TShirt_TankTop-White", "Base.Military_TShirt_TankTopShort-Black", "Base.Military_TShirt_TankTopShort-Desert", "Base.Military_TShirt_TankTopShort-Green", "Base.Military_TShirt_TankTopShort-White", "Base.Military_TShirt_TShirt-Black", "Base.Military_TShirt_TShirt-Black_Man", "Base.Military_TShirt_TShirt-Desert", "Base.Military_TShirt_TShirt-Desert_Man", "Base.Military_TShirt_TShirt-Green", "Base.Military_TShirt_TShirt-Green_Man", "Base.Military_TShirt_TShirt-White", "Base.Military_TShirt_TShirt-White_Man", "Base.Military_TShirt_TShirtShort-Black", "Base.Military_TShirt_TShirtShort-Desert", "Base.Military_TShirt_TShirtShort-Green", "Base.Military_TShirt_TShirtShort-White", "Base.Military_TShirt_LongSleeve-Black", "Base.Military_TShirt_LongSleeve-Black_Man", "Base.Military_TShirt_LongSleeve-Desert", "Base.Military_TShirt_LongSleeve-Desert_Man", "Base.Military_TShirt_LongSleeve-Green", "Base.Military_TShirt_LongSleeve-Green_Man", "Base.Military_TShirt_LongSleeve-White", "Base.Military_TShirt_LongSleeve-White_Man", "Base.Military_TShirt_LongSleeveShort-Black", "Base.Military_TShirt_LongSleeveShort-Desert", "Base.Military_TShirt_LongSleeveShort-Green", "Base.Military_TShirt_LongSleeveShort-White", "Base.Military_TShirt_Sleeveless-Black", "Base.Military_TShirt_Sleeveless-Black_Man", "Base.Military_TShirt_Sleeveless-Desert", "Base.Military_TShirt_Sleeveless-Desert_Man", "Base.Military_TShirt_Sleeveless-Green", "Base.Military_TShirt_Sleeveless-Green_Man", "Base.Military_TShirt_Sleeveless-White", "Base.Military_TShirt_Sleeveless-White_Man", "Base.Military_TShirt_SleevelessShort-Black", "Base.Military_TShirt_SleevelessShort-Desert", "Base.Military_TShirt_SleevelessShort-Green", "Base.Military_TShirt_SleevelessShort-White", "Base.Military_TShirt_OneShoulder-Black", "Base.Military_TShirt_OneShoulder-Black_Man", "Base.Military_TShirt_OneShoulder-Desert", "Base.Military_TShirt_OneShoulder-Desert_Man", "Base.Military_TShirt_OneShoulder-Green", "Base.Military_TShirt_OneShoulder-Green_Man", "Base.Military_TShirt_OneShoulder-White", "Base.Military_TShirt_OneShoulder-White_Man", "Base.Military_TShirt_OneShoulderShort-Black", "Base.Military_TShirt_OneShoulderShort-Desert", "Base.Military_TShirt_OneShoulderShort-Green", "Base.Military_TShirt_OneShoulderShort-White", "Base.Military_TShirt_Neckholder-Black", "Base.Military_TShirt_Neckholder-Desert", "Base.Military_TShirt_Neckholder-Green", "Base.Military_TShirt_Neckholder-White", "Base.Military_TShirt_NeckholderShort-Black", "Base.Military_TShirt_NeckholderShort-Desert", "Base.Military_TShirt_NeckholderShort-Green", "Base.Military_TShirt_NeckholderShort-White", "Base.Military_Gloves_Grips-Black", "Base.Military_Gloves_Grips-Desert", "Base.Military_Gloves_Grips-Green", "Base.Military_Gloves_Grips-White", "Base.Military_Gloves_GripFingerless-Black", "Base.Military_Gloves_GripFingerless-Desert", "Base.Military_Gloves_GripFingerless-Green", "Base.Military_Gloves_GripFingerless-White", "Base.Military_Shirt_Classic-Black", "Base.Military_Shirt_Classic-Desert", "Base.Military_Shirt_Classic-Green", "Base.Military_Shirt_Classic-White", "Base.Military_Shirt_ShortSleeveShirt-Black", "Base.Military_Shirt_ShortSleeveShirt-Desert", "Base.Military_Shirt_ShortSleeveShirt-Green", "Base.Military_Shirt_ShortSleeveShirt-White", "Base.Military_BagFront_ChestPouches_Small-Black", "Base.Military_BagFront_ChestPouches_Small-Desert", "Base.Military_BagFront_ChestPouches_Small-Green", "Base.Military_BagFront_ChestPouches_Small-White", "Base.Military_BagFront_ChestPouches_Medium-Black", "Base.Military_BagFront_ChestPouches_Medium-Desert", "Base.Military_BagFront_ChestPouches_Medium-Green", "Base.Military_BagFront_ChestPouches_Medium-White", "Base.Military_BagFront_ChestPouches_Large-Black", "Base.Military_BagFront_ChestPouches_Large-Desert", "Base.Military_BagFront_ChestPouches_Large-Green", "Base.Military_BagFront_ChestPouches_Large-White", "Base.Military_BagBack_StormPack_Small-Black", "Base.Military_BagBack_StormPack_Small-Desert", "Base.Military_BagBack_StormPack_Small-Green", "Base.Military_BagBack_StormPack_Small-White", "Base.Military_BagBack_StormPack_Small-Medic", "Base.Military_BagBack_StormPack_Medium-Black", "Base.Military_BagBack_StormPack_Medium-Desert", "Base.Military_BagBack_StormPack_Medium-Green", "Base.Military_BagBack_StormPack_Medium-White", "Base.Military_BagBack_StormPack_Large-Black", "Base.Military_BagBack_StormPack_Large-Desert", "Base.Military_BagBack_StormPack_Large-Green", "Base.Military_BagBack_StormPack_Large-White", "Base.Military_BagBack_StormPack_Large-Medic", "Base.Military_ThermalUnderwear-Black", "Base.Military_ThermalUnderwear-Desert", "Base.Military_ThermalUnderwear-Green", "Base.Military_ThermalUnderwear-White", "Base.Military_Holster_Defender-Black_HipLeft", "Base.Military_Holster_Defender-Black_HipArmorLeft", "Base.Military_Holster_Defender-Black_BeltLeft", "Base.Military_Holster_Defender-Black_HipRight", "Base.Military_Holster_Defender-Black_HipArmorRight", "Base.Military_Holster_Defender-Black_BeltRight", "Base.Military_Holster_Defender-Desert_HipLeft", "Base.Military_Holster_Defender-Desert_HipArmorLeft", "Base.Military_Holster_Defender-Desert_BeltLeft", "Base.Military_Holster_Defender-Desert_HipRight", "Base.Military_Holster_Defender-Desert_HipArmorRight", "Base.Military_Holster_Defender-Desert_BeltRight", "Base.Military_Holster_Defender-Green_HipLeft", "Base.Military_Holster_Defender-Green_HipArmorLeft", "Base.Military_Holster_Defender-Green_BeltLeft", "Base.Military_Holster_Defender-Green_HipRight", "Base.Military_Holster_Defender-Green_HipArmorRight", "Base.Military_Holster_Defender-Green_BeltRight", "Base.Military_Holster_Defender-White_HipLeft", "Base.Military_Holster_Defender-White_HipArmorLeft", "Base.Military_Holster_Defender-White_BeltLeft", "Base.Military_Holster_Defender-White_HipRight", "Base.Military_Holster_Defender-White_HipArmorRight", "Base.Military_Holster_Defender-White_BeltRight", "Base.Military_MaskHelmet_GasMask-M80", "Base.Military_Sheath_Defender-Black_HipArmorLeft", "Base.Military_Sheath_Defender-Black_BeltLeft", "Base.Military_Sheath_Defender-Black_HipRight", "Base.Military_Sheath_Defender-Black_HipArmorRight", "Base.Military_Sheath_Defender-Black_BeltRight", "Base.Military_Sheath_Defender-Black_Back", "Base.Military_Sheath_Defender-Desert_HipArmorLeft", "Base.Military_Sheath_Defender-Desert_BeltLeft", "Base.Military_Sheath_Defender-Desert_HipRight", "Base.Military_Sheath_Defender-Desert_HipArmorRight", "Base.Military_Sheath_Defender-Desert_BeltRight", "Base.Military_Sheath_Defender-Desert_Back", "Base.Military_Sheath_Defender-Green_HipArmorLeft", "Base.Military_Sheath_Defender-Green_BeltLeft", "Base.Military_Sheath_Defender-Green_HipRight", "Base.Military_Sheath_Defender-Green_HipArmorRight", "Base.Military_Sheath_Defender-Green_BeltRight", "Base.Military_Sheath_Defender-Green_Back", "Base.Military_Sheath_Defender-White_HipArmorLeft", "Base.Military_Sheath_Defender-White_BeltLeft", "Base.Military_Sheath_Defender-White_HipRight", "Base.Military_Sheath_Defender-White_HipArmorRight", "Base.Military_Sheath_Defender-White_BeltRight", "Base.Military_Sheath_Defender-White_Back", "Base.Military_Skirt_KnifePleated-Black", "Base.Military_Skirt_KnifePleated-Desert", "Base.Military_Skirt_KnifePleated-Green", "Base.Military_Skirt_KnifePleated-White", "Base.Military_Skirt_KnifePleated-Press", "Base.Military_Skirt_KnifePleatedShort-Black", "Base.Military_Skirt_KnifePleatedShort-Desert", "Base.Military_Skirt_KnifePleatedShort-Green", "Base.Military_Skirt_KnifePleatedShort-White", "Base.Military_Skirt_KnifePleatedShort-Press", "Base.Military_Skirt_KnifePleatedMini-Black", "Base.Military_Skirt_KnifePleatedMini-Desert", "Base.Military_Skirt_KnifePleatedMini-Green", "Base.Military_Skirt_KnifePleatedMini-White", "Base.Military_Skirt_KnifePleatedMini-Press", "Base.Military_Stockings-Black", "Base.Military_Stockings-Desert", "Base.Military_Stockings-Green", "Base.Military_Stockings-White", "Base.Military_Stockings-Press", "Base.Military_Mask_Balaclava1-Black", "Base.Military_Mask_Balaclava1-Desert", "Base.Military_Mask_Balaclava1-Green", "Base.Military_Mask_Balaclava1-White", "Base.Military_Mask_Balaclava2-Black", "Base.Military_Mask_Balaclava2-Desert", "Base.Military_Mask_Balaclava2-Green", "Base.Military_Mask_Balaclava2-White", "Base.Military_Mask_Balaclava3-Black", "Base.Military_Mask_Balaclava3-Desert", "Base.Military_Mask_Balaclava3-Green", "Base.Military_Mask_Balaclava3-White", "Base.Military_Mask_BandanaMask-Black", "Base.Military_Mask_BandanaMask-Desert", "Base.Military_Mask_BandanaMask-Green", "Base.Military_Mask_BandanaMask-White", "Base.Military_Jacket_Classic-Black", "Base.Military_Jacket_Classic-Black_Open", "Base.Military_Jacket_Classic-Black_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Black_RolledUpSleeves", "Base.Military_Jacket_Classic-Desert_Open", "Base.Military_Jacket_Classic-Desert_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Desert_RolledUpSleeves", "Base.Military_Jacket_Classic-Green", "Base.Military_Jacket_Classic-Green_Open", "Base.Military_Jacket_Classic-Green_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-Green_RolledUpSleeves", "Base.Military_Jacket_Classic-White", "Base.Military_Jacket_Classic-White_Open", "Base.Military_Jacket_Classic-White_OpenRolledUpSleeves", "Base.Military_Jacket_Classic-White_RolledUpSleeves", "Base.Military_Jacket_Lightweight-Black", "Base.Military_Jacket_Lightweight-Desert_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-Desert_RolledUpSleeves", "Base.Military_Jacket_Lightweight-Green", "Base.Military_Jacket_Lightweight-Green_Open", "Base.Military_Jacket_Lightweight-Green_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-Green_RolledUpSleeves", "Base.Military_Jacket_Lightweight-White", "Base.Military_Jacket_Lightweight-White_Open", "Base.Military_Jacket_Lightweight-White_OpenRolledUpSleeves", "Base.Military_Jacket_Lightweight-White_RolledUpSleeves", "Base.Military_Jacket_WinterHood-Black_DOWN", "Base.Military_Jacket_WinterHood-Black_DOWN_Open", "Base.Military_Jacket_WinterHood-Black_Up", "Base.Military_Jacket_WinterHood-Black_Up_Open", "Base.Military_Jacket_WinterHood-Desert_DOWN", "Base.Military_Jacket_WinterHood-Desert_DOWN_Open", "Base.Military_Jacket_WinterHood-Desert_Up", "Base.Military_Jacket_WinterHood-Desert_Up_Open", "Base.Military_Jacket_WinterHood-Green_DOWN", "Base.Military_Jacket_WinterHood-Green_DOWN_Open", "Base.Military_Jacket_WinterHood-Green_Up", "Base.Military_Jacket_WinterHood-Green_Up_Open", "Base.Military_Jacket_WinterHood-White_DOWN", "Base.Military_Jacket_WinterHood-White_DOWN_Open", "Base.Military_Jacket_WinterHood-White_Up", "Base.Military_Jacket_WinterHood-White_Up_Open", "Base.Military_Backpack_Pocket_Small-Black", "Base.Military_Backpack_Pocket_Small-Black_Tight", "Base.Military_Backpack_Pocket_Small-Green", "Base.Military_Backpack_Pocket_Small-Green_Tight", "Base.Military_Backpack_Pocket_Small-Desert", "Base.Military_Backpack_Pocket_Small-Desert_Tight", "Base.Military_Backpack_Pocket_Small-White", "Base.Military_Backpack_Pocket_Small-White_Tight", "Base.Military_Backpack_Strategist_Medium-Black", "Base.Military_Backpack_Strategist_Medium-Black_Tight", "Base.Military_Backpack_Strategist_Medium-Green", "Base.Military_Backpack_Strategist_Medium-Green_Tight", "Base.Military_Backpack_Strategist_Medium-Desert", "Base.Military_Backpack_Strategist_Medium-Desert_Tight", "Base.Military_Backpack_Strategist_Medium-White", "Base.Military_Backpack_Strategist_Medium-White_Tight", "Base.Military_Backpack_Echo_Radio-Black", "Base.Military_Backpack_Echo_Radio-Black_Tight", "Base.Military_Backpack_Echo_Radio-Green", "Base.Military_Backpack_Echo_Radio-Green_Tight", "Base.Military_Backpack_Echo_Radio-Desert", "Base.Military_Backpack_Echo_Radio-Desert_Tight", "Base.Military_Backpack_Echo_Radio-White", "Base.Military_Backpack_Echo_Radio-White_Tight", "Base.Military_Backpack_Ranger_Large-Black", "Base.Military_Backpack_Ranger_Large-Black_Tight", "Base.Military_Backpack_Ranger_Large-Green", "Base.Military_Backpack_Ranger_Large-Green_Tight", "Base.Military_Backpack_Ranger_Large-Desert", "Base.Military_Backpack_Ranger_Large-Desert_Tight", "Base.Military_Backpack_Ranger_Large-White", "Base.Military_Backpack_Ranger_Large-White_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Black", "Base.Military_Backpack_Colossus_VeryLarge-Black_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Green", "Base.Military_Backpack_Colossus_VeryLarge-Green_Tight", "Base.Military_Backpack_Colossus_VeryLarge-Desert", "Base.Military_Backpack_Colossus_VeryLarge-Desert_Tight", "Base.Military_Backpack_Colossus_VeryLarge-White", "Base.Military_Backpack_Colossus_VeryLarge-White_Tight", "Base.Military_Glasses_ShatterShield", "Base.Military_BagLeg_MagSecure_Small-Black_Left", "Base.Military_BagLeg_MagSecure_Small-Black_Right", "Base.Military_BagLeg_MagSecure_Small-Black_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Black_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-Desert_Left", "Base.Military_BagLeg_MagSecure_Small-Desert_Right", "Base.Military_BagLeg_MagSecure_Small-Desert_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Desert_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-Green_Left", "Base.Military_BagLeg_MagSecure_Small-Green_Right", "Base.Military_BagLeg_MagSecure_Small-Green_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-Green_ArmorRight", "Base.Military_BagLeg_MagSecure_Small-White_Left", "Base.Military_BagLeg_MagSecure_Small-White_Right", "Base.Military_BagLeg_MagSecure_Small-White_ArmorLeft", "Base.Military_BagLeg_MagSecure_Small-White_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Black_Left", "Base.Military_BagLeg_Utility_Medium-Black_Right", "Base.Military_BagLeg_Utility_Medium-Black_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Black_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Desert_Left", "Base.Military_BagLeg_Utility_Medium-Desert_Right", "Base.Military_BagLeg_Utility_Medium-Desert_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Desert_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Green_Left", "Base.Military_BagLeg_Utility_Medium-Green_Right", "Base.Military_BagLeg_Utility_Medium-Green_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Green_ArmorRight", "Base.Military_BagLeg_Utility_Medium-White_Left", "Base.Military_BagLeg_Utility_Medium-White_Right", "Base.Military_BagLeg_Utility_Medium-White_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-White_ArmorRight", "Base.Military_BagLeg_Utility_Medium-Medic_Left", "Base.Military_BagLeg_Utility_Medium-Medic_Right", "Base.Military_BagLeg_Utility_Medium-Medic_ArmorLeft", "Base.Military_BagLeg_Utility_Medium-Medic_ArmorRight", "Base.Military_Hat_WarComms-Black", "Base.Military_Hat_WarComms-Desert", "Base.Military_Hat_WarComms-Green", "Base.Military_Hat_WarComms-White", "Base.Military_Hat_Beret-Black", "Base.Military_Hat_Beret-Desert", "Base.Military_Hat_Beret-Green", "Base.Military_Hat_Beret-White", "Base.Military_Hat_Beret-Red", "Base.Military_Hat_BaseballCapM-Black", "Base.Military_Hat_BaseballCapM-Desert", "Base.Military_Hat_BaseballCapM-Green", "Base.Military_Hat_BaseballCapM-White"}
	local japaneseClothing = {"Base.Japanese_Socks-Dyed", "Base.Japanese_Pants_Hakama-Dyed", "Base.Japanese_Pants_Hakama-Dyed_RollUp", "Base.Japanese_Jacket_Undershirt-Dyed", "Base.Japanese_Jacket_Undershirt-Dyed_Tuck", "Base.Japanese_Jacket_Undershirt-Beige", "Base.Japanese_Jacket_Undershirt-Beige_Tuck", "Base.Japanese_Socks-Black", "Base.Japanese_Shoes_Sandals-Dyed", "Base.Japanese_Shoes_Sandals-Straw", "Base.Japanese_Pants_Hakama-Brown", "Base.Japanese_Pants_Hakama-Brown_RollUp", "Base.Japanese_Jacket_Overshirt-Dyed", "Base.Japanese_Jacket_Overshirt-Dyed_Tuck", "Base.Japanese_Jacket_Overshirt-Black", "Base.Japanese_Jacket_Overshirt-Black_Tuck", "Base.Japanese_Belt-Dyed", "Base.Japanese_Belt-White"}
	--skill books
	local skillbooks1 = {"BookTrapping1", "BookFishing1", "BookCarpentry1", "BookMechanic1", "BookFirstAid1", "BookBlacksmith1", "BookMetalWelding1", "BookElectrician1", "BookCooking1", "BookFarming1", "BookForaging1", "BookTailoring1"}
	local skillbooks2 = {"BookTrapping2", "BookFishing2", "BookCarpentry2", "BookMechanic2", "BookFirstAid2", "BookBlacksmith2", "BookMetalWelding2", "BookElectrician2", "BookCooking2", "BookFarming2", "BookForaging2", "BookTailoring2"}
	local skillbooks3 = {"BookTrapping3", "BookFishing3", "BookCarpentry3", "BookMechanic3", "BookFirstAid3", "BookBlacksmith3", "BookMetalWelding3", "BookElectrician3", "BookCooking3", "BookFarming3", "BookForaging3", "BookTailoring3"}
	local skillbooks4 = {"BookTrapping4", "BookFishing4", "BookCarpentry4", "BookMechanic4", "BookFirstAid4", "BookBlacksmith4", "BookMetalWelding4", "BookElectrician4", "BookCooking4", "BookFarming4", "BookForaging4", "BookTailoring4"}	
	local skillbooks5 = {"BookTrapping5", "BookFishing5", "BookCarpentry5", "BookMechanic5", "BookFirstAid5", "BookBlacksmith5", "BookMetalWelding5", "BookElectrician5", "BookCooking5", "BookFarming5", "BookForaging5", "BookTailoring5"}	
	
	--foods
	local baseFoods = {"Lard", "Pasta", "DriedKidneyBeans", "Margarine", "Butter", "DriedBlackBeans", "DriedLentils", "Rice", "DriedChickpeas", "DriedWhiteBeans", "PeanutButter", "OilOlive", "Cereal", "DriedSplitPeas", "OilVegetable", "OatsRaw", "Ketchup", "MapleSyrup", "Chocolate", "CannedCornedBeef", "Crisps", "Crisps2", "Crisps3", "Crisps4", "Macandcheese", "TVDinner", "Honey", "JamFruit", "JamMarmalade", "CannedBolognese", "DoughRolled", "Wine2", "Mustard", "CandyPackage", "Dogfood", "Wine", "CannedMilk", "Hotsauce", "TortillaChips", "PopBottle", "Sugar", "TunaTin", "Marinara", "CinnamonRoll", "SugarBrown", "CannedCorn", "CannedPeas", "CannedChili", "CannedFruitCocktail", "CannedFruitBeverage", "CannedPeaches", "CannedPineapple"}
	local sapphFoods = {"SapphCooking.Tortellini", "SapphCooking.ArborioRice", "SapphCooking.BrownRice", "SapphCooking.PeanutOil", "SapphCooking.CanolaOil", "SapphCooking.AvocadoOil", "SapphCooking.ChocolateEgg_Large", "SapphCooking.WhiteChocolate", "SapphCooking.ChickenBroth", "SapphCooking.BeefBroth", "SapphCooking.VegetableBroth", "SapphCooking.Syrup_Chocolate", "SapphCooking.Syrup_Strawberry", "SapphCooking.Syrup_Caramel", "SapphCooking.PastaSheets", "SapphCooking.PastryDough", "SapphCooking.CachacaFull", "SapphCooking.RolledPastaDough", "SapphCooking.FilledMeatPastaDough", "SapphCooking.Gingerbread_House", "SapphCooking.BananaBread_Dough", "SapphCooking.ColaBottle", "SapphCooking.CannedBread", "SapphCooking.PipingBag_PastryDough", "SapphCooking.Vermouth", "SapphCooking.WokPan_YakisobaEvolved", "SapphCooking.GinFull", "SapphCooking.TequilaFull", "SapphCooking.VodkaFull", "SapphCooking.SapphDoughnutChocolate", "SapphCooking.ChocolateEgg_Medium", "SapphCooking.SapphTortillaChips", "SapphCooking.CannedSausages", "SapphCooking.CannedBacon", "SapphCooking.CanofBeets", "SapphCooking.BagofFlourTortillas"}
	
	for i=1,#kattaj do
		if ZombRand(8) == 0 then
			modifyItemWeight(kattaj[i], 0.05)
		else
			modifyItemWeight(kattaj[i], 0)
		end
	end
	
	for i=1,#japaneseClothing do
		if ZombRand(5) == 0 then
			modifyItemWeight(japaneseClothing[i], 0.05)
		else
			yeetItem(japaneseClothing[i])
		end
	end
	
	--for i=1,#baseFoods do
		--modifyItemWeight(baseFoods[i], 0.5)
	--end
	
	for i=1,#sapphFoods do
		modifyItemWeight(sapphFoods[i], 0.15)
	end

	for i=1,#skillbooks1 do
		modifyItemWeight(skillbooks1[i], 0.1)
		modifyItemWeight(skillbooks2[i], 0.08)
		modifyItemWeight(skillbooks3[i], 0.06)
		modifyItemWeight(skillbooks4[i], 0.04)
		modifyItemWeight(skillbooks5[i], 0.02)
	end

	--findItemInDistribution("PropaneTank")
	--findItemInDistribution("TW.LargePropaneTank")
	--findItemInDistribution("Biofuel.IndustrialPropaneTank")

	modifyItemWeight("Book", 0.125)
	modifyItemWeight("MetalworkCache", 2)
	modifyItemWeight("MechanicCache", 2)
	modifyItemWeight("MedicalCache", 2.5)
	yeetItem("PropaneTank")
	yeetItem("TW.LargePropaneTank")
	yeetItem("Biofuel.IndustrialPropaneTank")
	ItemPickerJava.Parse()
	
	--[[print("----------ITEMS YEETED-----------")
	findItemInDistribution("PropaneTank")
	findItemInDistribution("TW.LargePropaneTank")
	findItemInDistribution("Biofuel.IndustrialPropaneTank")
	print("----------ITEMS REMAIN-----------")]]
end

Events.OnPostDistributionMerge.Add(editDistributions)
