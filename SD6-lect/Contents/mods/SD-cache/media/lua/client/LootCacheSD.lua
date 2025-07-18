----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

--require "SDZoneCheck"

local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local EventHandlers = require('SoulForgedJewelryEventHandlers')

local VAitems = {
				"HS_VenenosusAer.VA_Charcoal_Tablets", "HS_VenenosusAer.VA_Filter_LowGrade", "HS_VenenosusAer.VA_Filter_MediumGrade", "HS_VenenosusAer.VA_Filter_HighGrade",
				"Packing.5pkVA_Charcoal_Tablets", "Packing.5pkVA_Filter_LowGrade", "Packing.5pkVA_Filter_MediumGrade", "Packing.5pkVA_Filter_HighGrade", 
				"Packing.10pkVA_Charcoal_Tablets", "Packing.10pkVA_Filter_LowGrade", "Packing.10pkVA_Filter_MediumGrade", "Packing.10pkVA_Filter_HighGrade", 
				}

local VAweight = {  
				9, 27, 18, 9,
				3, 9, 6, 3,
				1, 3, 2, 1,
				}

local function getTotalTableWeight(_table)
	local count = 0
	for i=1,#_table do
		count = count + _table[i]
	end
	return count
end

local function getWeightedItem(tableno, tableweight, rollvalue)
	local countnext = 0
	for i=1,#tableweight do
		countnext = countnext + tableweight[i]
		if rollvalue <= countnext then
			return tableno[i]
		end
	end
end

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local args = {}

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addItemsToPlayer(loot, amount)
	getSpecificPlayer(0):getInventory():AddItems(loot, amount)
	addToArgs(loot, amount)
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function randomrollSD(zoneroll, loot, itemname)
	if ZombRand(zoneroll) == 0 then
		getSpecificPlayer(0):getInventory():AddItem(loot)
		local itemname = itemname or loot
		addToArgs(loot, 1, itemname)
	end
end

local function gaussianRandom()
	-- Generate two random integers between 0 and 999
	local u1 = ZombRand(1000) / 1000
	local u2 = ZombRand(1000) / 1000
	local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)--Box-Mueller Transform
	return z0
end


local function scaledNormal()
	local z = gaussianRandom() 

	z = math.max(-2.5, math.min(2.5, z)) 

	-- Scale and shift to the 0-1 range
	local scaledValue = (z + 2.5) / 5
	scaledValue = scaledValue^1.75 --shift normal distribution to the left. set to 1.0 for a traditional normal distribution.
	scaledValue = math.floor(scaledValue * 10 + 0.5) / 10
	return scaledValue
end

function MechCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	local zoneroll = 7-zonetier
	
	local ki5parts = splitString("damnCraft.SteelRimSmall damnCraft.SteelRimMedium damnCraft.SteelRimLarge damnCraft.TireRubberNewSmall damnCraft.TireRubberUsedSmall damnCraft.TireRubberDestroyedSmall damnCraft.TireRubberNewLarge damnCraft.TireRubberUsedLarge damnCraft.TireRubberDestroyedLarge damnCraft.TireRubberMountSmall damnCraft.TireRubberMountedSmall damnCraft.TireRubberMountLarge damnCraft.TireRubberMountedLarge damnCraft.GlassPaneSmall damnCraft.GlassPaneLarge damnCraft.HandleClassic damnCraft.HandleModern damnCraft.HingeSmall damnCraft.HingeLarge damnCraft.RubberStrip damnCraft.SeatFabric damnCraft.SeatFoam damnCraft.SeatFrameSmall damnCraft.SeatFrameLarge damnCraft.TireRepairKit damnCraft.TireRepairTools damnCraft.TireRepairRubberSolution damnCraft.TireRepairStrips damnCraft.PlasticWeldingKit damnCraft.PlasticWeldingGun damnCraft.PlasticWeldingStaples100Pack damnCraft.SmallTire1 damnCraft.SmallTire2")
	
	local regbrakes = splitString("NormalBrake1 NormalBrake2 NormalBrake3")
	
	local regsuspension = splitString("NormalSuspension1 NormalSuspension2 NormalSuspension3")
	
	local modbrakes = splitString("ModernBrake1 ModernBrake2 ModernBrake3")
	
	local modsuspension = splitString("ModernSuspension1 ModernSuspension2 ModernSuspension3")
	
	local newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
	local gascan = InventoryItemFactory.CreateItem("Base.PetrolCan")
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Mechanic Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 6 then
		addItemToPlayer("Base.PetrolCan")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		addItemToPlayer(ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		addItemToPlayer(modbrakes[ZombRand(#modbrakes)+1])
		addItemToPlayer(modsuspension[ZombRand(#modsuspension)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.6, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.6, scaledNormal()))
	elseif zonetier == 5 then
		addItemToPlayer("Base.PetrolBleachBottle")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		addItemToPlayer(ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		addItemToPlayer(modbrakes[ZombRand(#modbrakes)+1])
		addItemToPlayer(modsuspension[ZombRand(#modsuspension)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.5, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.5, scaledNormal()))
		randomrollSD(zoneroll, gascan, "Base.PetrolCan")
	elseif zonetier == 4 then
		addItemToPlayer("Base.WhiskeyPetrol")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		addItemToPlayer(ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		addItemToPlayer(modbrakes[ZombRand(#modbrakes)+1])
		addItemToPlayer(modsuspension[ZombRand(#modsuspension)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.4, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.4, scaledNormal()))
		randomrollSD(zoneroll, gascan, "Base.PetrolCan")
	elseif zonetier == 3 then
		addItemToPlayer("Base.WinePetrol")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])		
		addItemToPlayer(modbrakes[ZombRand(#modbrakes)+1])
		addItemToPlayer(modsuspension[ZombRand(#modsuspension)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.3, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.3, scaledNormal()))
		randomrollSD(zoneroll, gascan, "Base.PetrolCan")
	elseif zonetier == 2 then
		addItemToPlayer("Base.PetrolPopBottle")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, regbrakes[ZombRand(#regbrakes)+1])
		randomrollSD(zoneroll, regsuspension[ZombRand(#regsuspension)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.3, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.2, scaledNormal()))
		randomrollSD(zoneroll, gascan, "Base.PetrolCan")
	elseif zonetier == 1 then
		addItemToPlayer("Base.WaterBottlePetrol")
		addItemsToPlayer("EngineParts", ZombRand(zonetier*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, regsuspension[ZombRand(#regsuspension)+1])
		randomrollSD(zoneroll, regbrakes[ZombRand(#regbrakes)+1])
		randomrollSD(zoneroll, "BlowTorch")
		newtank:setUsedDelta(math.min(0.3, scaledNormal()))
		randomrollSD(zoneroll, newtank, "Base.PropaneTank")
		gascan:setUsedDelta(math.min(0.1, scaledNormal()))
		randomrollSD(zoneroll, gascan, "Base.PetrolCan")
	end
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function MetalworkCacheSD(items, result, player)
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
		
	local zoneroll = 8-zonetier
	
	local newtank = InventoryItemFactory.CreateItem("Biofuel.IndustrialPropaneTank")
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Metalwork Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 6 then
		newtank:setUsedDelta(math.min(0.4, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier)+1)
		addItemsToPlayer("MetalBar", ZombRand(zonetier)+1)
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier)+1)
		--addItemToPlayer("SheetMetal")
		--addItemToPlayer("BlowTorch")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif zonetier == 5 then
		newtank:setUsedDelta(math.min(0.3, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier)+1)
		addItemsToPlayer("MetalBar", ZombRand(zonetier)+1)
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier)+1)
		--addItemToPlayer("SheetMetal")
		--addItemToPlayer("BlowTorch")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif zonetier == 4 then
		newtank:setUsedDelta(math.min(0.25, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier)+1)
		addItemsToPlayer("MetalBar", ZombRand(zonetier)+1)
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier)+1)
		--addItemToPlayer("SheetMetal")
		--addItemToPlayer("BlowTorch")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif zonetier == 3 then
		newtank:setUsedDelta(math.min(0.2, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier)+1)
		addItemsToPlayer("MetalBar", ZombRand(zonetier)+1)
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier))
		--addItemToPlayer("SheetMetal")
		--addItemToPlayer("BlowTorch")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif zonetier == 2 then
		newtank:setUsedDelta(math.min(0.15, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier)+1)
		addItemsToPlayer("MetalBar", ZombRand(zonetier)+1)
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier))
		--addItemToPlayer("SheetMetal")
		--addItemToPlayer("BlowTorch")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SmallSheetMetal")
	elseif zonetier == 1 then
		newtank:setUsedDelta(math.min(0.1, scaledNormal()))
		addItemsToPlayer("ScrapMetal", ZombRand(zonetier*2)+3)
		addItemsToPlayer("MetalPipe", ZombRand(zonetier))
		addItemsToPlayer("MetalBar", ZombRand(zonetier))
		addItemsToPlayer("SmallSheetMetal", ZombRand(zonetier))
		--addItemToPlayer("SheetMetal")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank, "Biofuel.IndustrialPropaneTank")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SmallSheetMetal")
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function MedicalCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	
	local medicalitems = { "HS_VenenosusAer.VA_Charcoal_Tablets", "HS_VenenosusAer.VA_Filter_LowGrade", "HS_VenenosusAer.VA_Filter_MediumGrade", "HS_VenenosusAer.VA_Filter_HighGrade", "CDCRR.Zedalis", "CDCRR.Zomboflex", "CDCRR.Bitezapro", "CDCRR.Salivix", "CDCRR.Viazom", "CDCRR.Fevarax", "CDCRR.Humanox", "CDCRR.WeatheredPills", "CDCRR.ConsumerViralTestPackage", "CDCRR.PremiumViralTestPackage", "CDCRR.WeatheredViralTestPackage",  "CDCRR.CDCFamilyPack", "SoulForge.LacerationHealing", "SoulForge.DeepWoundHealing", "SoulForge.BiteHealing", "SoulForge.FractureHealing", "SoulForge.BurnHealing"}
		
	local zoneroll = 12-zonetier
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Medical Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 6 then
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack1")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
	elseif zonetier == 5 then
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack1")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
	elseif zonetier == 4 then
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack1")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 3 then
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack1")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
	elseif zonetier == 2 then
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack3")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
	elseif zonetier == 1 then
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCProPack3")
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		addItemToPlayer(medicalitems[ZombRand(#medicalitems)+1])
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function AmmoCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	local gunpowder = InventoryItemFactory.CreateItem("Base.GunPowder")
	--gunpowder:setUsedDelta(math.min(0.1, scaledNormal()))
	--randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
	
	local ammo = splitString("Base.Bullets45Box Base.ShotgunShellsBox Base.308Box Base.556Box Base.Bullets9mmBox Base.762x54rBox Base.762Box Base.50BMGBox Base.57Box Base.545Box Base.380Box Base.223Box")
	local hfoMag = {"Base.Mag9ExtSm",
					"Base.Mag9ExtLg",
					"Base.Mag57ExtLg",
					"Base.MagLugerExtSm",
					"Base.MagLugerExtLg",
					"Base.Mag380ExtSm",
					"Base.Mag380ExtLg",
					"Base.Mag44ExtSm",
					"Base.Mag44ExtLg",
					"Base.Mag45ExtSm",
					"Base.Mag45ExtLg",
					"Base.Mag223ExtLg",
					"Base.MagMosinNagantExtSm",
					"Base.MagPM63RAKExtLg",
					"Base.MagM1GarandExtSm",
					"Base.Mag3006ExtLg",
					"Base.Mag308ExtSm",
					"Base.MagSVDExtSm",
					"Base.Mag50BMGExtSm",
					"Base.MagMP28ExtLg",
					"Base.Mag9x39ExtLg",
					"Base.Mag9Drum",
					"Base.Mag57Drum",
					"Base.MagLugerDrum",
					"Base.Mag380Drum",
					"Base.Mag45Drum",}
	
	local zoneroll = 8-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Ammo Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 6 then
		gunpowder:setUsedDelta(math.min(1, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		--randomrollSD(zoneroll, hfoMag[ZombRand(#hfoMag)+1])
		addItemToPlayer(hfoMag[ZombRand(#hfoMag)+1])
		addItemToPlayer(hfoMag[ZombRand(#hfoMag)+1])
	elseif zonetier == 5 then
		gunpowder:setUsedDelta(math.min(1, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		--randomrollSD(zoneroll, hfoMag[ZombRand(#hfoMag)+1])
		addItemToPlayer(hfoMag[ZombRand(#hfoMag)+1])
	elseif zonetier == 4 then
		gunpowder:setUsedDelta(math.min(0.9, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, hfoMag[ZombRand(#hfoMag)+1])
	elseif zonetier == 3 then
		gunpowder:setUsedDelta(math.min(0.8, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, hfoMag[ZombRand(#hfoMag)+1])
	elseif zonetier == 2 then
		gunpowder:setUsedDelta(math.min(0.7, scaledNormal()))
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		randomrollSD(1, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif zonetier == 1 then
		gunpowder:setUsedDelta(math.min(0.6, scaledNormal()))
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		randomrollSD(1, gunpowder, "Base.GunPowder")
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function ArmorCachePatriotSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	
	local zoneroll = 8-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Armor Cache (Patriot)",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local loot = splitString("Base.Military_ArmsProtectionLower_Patriot_Light-Black Base.Military_ArmsProtectionLower_Patriot_Light-Desert Base.Military_ArmsProtectionLower_Patriot_Light-Green Base.Military_ArmsProtectionLower_Patriot_Light-White Base.Military_ArmsProtectionUpper_Patriot_Light-Black Base.Military_ArmsProtectionUpper_Patriot_Light-Desert Base.Military_ArmsProtectionUpper_Patriot_Light-Green Base.Military_ArmsProtectionUpper_Patriot_Light-White Base.Military_BulletproofVest_Patriot_Light-Black Base.Military_BulletproofVest_Patriot_Light-Desert Base.Military_BulletproofVest_Patriot_Light-Green Base.Military_BulletproofVest_Patriot_Light-White Base.Military_BulletproofVest_Patriot_Light-Press Base.Military_Helmet_Patriot-Black Base.Military_Helmet_Patriot-Desert Base.Military_Helmet_Patriot-Green Base.Military_Helmet_Patriot-White Base.Military_Helmet_Patriot-Press Base.Military_LegsProtectionLower_Patriot_Light-Black Base.Military_LegsProtectionLower_Patriot_Light-Desert Base.Military_LegsProtectionLower_Patriot_Light-Green Base.Military_LegsProtectionLower_Patriot_Light-White Base.Military_LegsProtectionUpper_Patriot_Light-Black Base.Military_LegsProtectionUpper_Patriot_Light-Desert Base.Military_LegsProtectionUpper_Patriot_Light-Green Base.Military_LegsProtectionUpper_Patriot_Light-White")
	
	if zonetier == 6 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(1, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 5 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 4 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 3 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 2 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 1 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function ArmorCacheDefenderSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	
	local zoneroll = 8-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Armor Cache (Defender)",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local loot = splitString("Base.Military_ArmsProtectionLower_Defender_Medium-Black Base.Military_ArmsProtectionLower_Defender_Medium-Desert Base.Military_ArmsProtectionLower_Defender_Medium-Green Base.Military_ArmsProtectionLower_Defender_Medium-White Base.Military_ArmsProtectionUpper_Defender_Medium-Black Base.Military_ArmsProtectionUpper_Defender_Medium-Desert Base.Military_ArmsProtectionUpper_Defender_Medium-Green Base.Military_ArmsProtectionUpper_Defender_Medium-White Base.Military_ArmsProtectionUpper_Defender_Medium-Press Base.Military_BulletproofVest_Defender_Medium-Black Base.Military_BulletproofVest_Defender_Medium-Desert Base.Military_BulletproofVest_Defender_Medium-Green Base.Military_BulletproofVest_Defender_Medium-White Base.Military_Helmet_Defender-Black Base.Military_Helmet_Defender-Desert Base.Military_Helmet_Defender-Green Base.Military_Helmet_Defender-White Base.Military_LegsProtectionLower_Defender_Medium-Black Base.Military_LegsProtectionLower_Defender_Medium-Desert Base.Military_LegsProtectionLower_Defender_Medium-Green Base.Military_LegsProtectionLower_Defender_Medium-White Base.Military_LegsProtectionUpper_Defender_Medium-Black Base.Military_LegsProtectionUpper_Defender_Medium-Desert Base.Military_LegsProtectionUpper_Defender_Medium-Green Base.Military_LegsProtectionUpper_Defender_Medium-White Base.Military_LegsProtectionUpper_Defender_Medium-Press")
	
	if zonetier == 6 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(1, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 5 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 4 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 3 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 2 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 1 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
	
end

function ArmorCacheVanguardSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	
	local zoneroll = 8-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Armor Cache (Vanguard)",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local loot = splitString("Base.Military_ArmsProtectionLower_Vanguard_Heavy-Black Base.Military_ArmsProtectionLower_Vanguard_Heavy-Desert Base.Military_ArmsProtectionLower_Vanguard_Heavy-Green Base.Military_ArmsProtectionLower_Vanguard_Heavy-White Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Black Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Desert Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Green Base.Military_ArmsProtectionUpper_Vanguard_Heavy-White Base.Military_BulletproofVest_Vanguard_Heavy-Black Base.Military_BulletproofVest_Vanguard_Heavy-Desert Base.Military_BulletproofVest_Vanguard_Heavy-Green Base.Military_BulletproofVest_Vanguard_Heavy-White Base.Military_FullHelmet_Vanguard-Black Base.Military_FullHelmet_Vanguard-Desert Base.Military_FullHelmet_Vanguard-Green Base.Military_FullHelmet_Vanguard-White Base.Military_LegsProtectionLower_Vanguard_Heavy-Black Base.Military_LegsProtectionLower_Vanguard_Heavy-Desert Base.Military_LegsProtectionLower_Vanguard_Heavy-Green Base.Military_LegsProtectionLower_Vanguard_Heavy-White Base.Military_LegsProtectionUpper_Vanguard_Heavy-Black Base.Military_LegsProtectionUpper_Vanguard_Heavy-Desert Base.Military_LegsProtectionUpper_Vanguard_Heavy-Green Base.Military_LegsProtectionUpper_Vanguard_Heavy-White")
	
	if zonetier == 6 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(1, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 5 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+1, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 4 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, "Base.Military_MaskHelmet_GasMask-M80")
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+2, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 3 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+3, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 2 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		randomrollSD(zoneroll+4, loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	elseif zonetier == 1 then
		addItemToPlayer(loot[ZombRand(#loot)+1])
		
		randomrollSD(zoneroll, getWeightedItem(VAitems, VAweight, ZombRand(1,getTotalTableWeight(VAweight))))
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

local function addSpiffoToPlayer(loot, itemname)
	getSpecificPlayer(0):getInventory():AddItem("Moveables.Moveable"):ReadFromWorldSprite(loot)
	addToArgs(loot, 1, itemname)
end

local SpiffoTable = {
	"00ATOX-Spiffos_0", 
	"00ATOX-Spiffos_1", 
	"00ATOX-Spiffos_2", 
	"00ATOX-Spiffos_3", 
	"00ATOX-Spiffos_4", 
	"00ATOX-Spiffos_5", 
	"00ATOX-Spiffos_6", 
	"00ATOX-Spiffos_7", 
	"00ATOX-Spiffos_8", 
	"00ATOX-Spiffos_9", 
	"00ATOX-Spiffos_10", 
	"00ATOX-Spiffos_11", 
	"00ATOX-Spiffos_12", 
	"00ATOX-Spiffos_13", 
	"00ATOX-Spiffos_14", 
	"00ATOX-Spiffos_15", 
	"00ATOX-Spiffos_16", 
	"00ATOX-Spiffos_17", 
	"00ATOX-Spiffos_18", 
	"00ATOX-Spiffos_19", 
	"00ATOX-Spiffos_20", 
	"00ATOX-Spiffos_21", 
	"00ATOX-Spiffos_22", 
	"00ATOX-Spiffos_23", 
	"00ATOX-Spiffos_24", 
	"00ATOX-Spiffos_25", 
	"00ATOX-Spiffos_26", 
	"00ATOX-Spiffos_27", 
	"00ATOX-Spiffos_28", 
	"00ATOX-Spiffos_29", 
	"00ATOX-Spiffos_30", 
	"00ATOX-Spiffos_31", 
	"00ATOX-Spiffos_32", 
	"00ATOX-Spiffos_33", 
	"00ATOX-Spiffos_34", 
}

local SpiffoName = {
	"Vader Spiffo",
	"UUee Spiffo",
	"Freddy Krueger Spiffo",
	"Batman Spiffo",
	"Swamp Monster Spiffo",
	"Dross 2 Spiffo",
	"Dross 1 Spiffo",
	"Frankenstein Spiffo",
	"Kiss Spiffo",
	"Heisenberg Spiffo",
	"Bandaged Spiffo",
	"Hunter S. Thompson Spiffo",
	"Jaison Spiffo",
	"Wolf Spiffo",
	"Doctor Spiffo",
	"Military Spiffo",
	"Mummy Spiffo",
	"Nerd Spiffo",
	"Patch Spiffo",
	"Chemical Spiffo",
	"King Spiffo",
	"Billionare Spiffo",
	"Terminator Spiffo",
	"Tio Sam - I want you Spiffo",
	"Builder Spiffo",
	"Dracula Spiffo",
	"Zombie Spiffo",
	"Bomb Spiffo",
	"Ash Spiffo",
	"Ripped Spiffo",
	"Lincoln Spiffo",
	"Alien Spiffo",
	"Oktoberfest Spiffo",
	"Speaking Spiffo",
	"Lumberjack Spiffo",
}

function SpiffoCacheSD(items, result, player)

	local zonetier, zonename, x, y = checkZone()
	
	local zoneroll = 6-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Spiffo Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local randomnumber = ZombRand(#SpiffoTable)+1
	local loot = SpiffoTable[randomnumber]
	local itemname = SpiffoName[randomnumber]
	
	if zonetier >= 5 then
		addSpiffoToPlayer(SpiffoTable[ZombRand(#SpiffoTable)+1], SpiffoName[ZombRand(#SpiffoTable)+1])
		addSpiffoToPlayer(SpiffoTable[ZombRand(#SpiffoTable)+1], SpiffoName[ZombRand(#SpiffoTable)+1])
		addItemToPlayer("CanteensAndBottles.GymBottleSpiffoade")
	elseif zonetier == 4 then
		addSpiffoToPlayer(loot, itemname)
		addItemToPlayer("CanteensAndBottles.GymBottleSpiffoade")
	elseif zonetier == 3 then
		if ZombRand(zoneroll) == 0 then
			addSpiffoToPlayer(loot, itemname)
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		else
			addItemToPlayer("Base.SpiffoBig")
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		end
	elseif zonetier == 2 then
		if ZombRand(zoneroll) == 0 then
			addSpiffoToPlayer(loot, itemname)
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		else
			addItemToPlayer("Base.Spiffo")
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		end
	elseif zonetier == 1 then
		if ZombRand(zoneroll) == 0 then
			addSpiffoToPlayer(loot, itemname)
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		else
			addItemToPlayer("Base.Spiffo")
			randomrollSD(zoneroll, "CanteensAndBottles.GymBottleSpiffoade")
		end
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function EventSpiffoCacheSD(items, result, player)
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Spiffo Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}

	local randomnumber = ZombRand(#SpiffoTable)+1
	local loot = SpiffoTable[randomnumber]
	local itemname = SpiffoName[randomnumber]

	addSpiffoToPlayer(loot, itemname)
	addItemToPlayer("CanteensAndBottles.GymBottleSpiffoade")
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

local function addPokemonTileToPlayer(loot, itemname)
	getSpecificPlayer(0):getInventory():AddItem("Moveables.Moveable"):ReadFromWorldSprite(loot)
	addToArgs(loot, 1, itemname)
end

function PokemonCacheSD(items, result, player)
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Pokemon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local startno = 280
	local endno = 431 --432 to 583 gives shinies
	
	local randompokemon = ZombRand(endno - startno + 1) + startno
	local loot = "Aza_01_" .. randompokemon
	addPokemonTileToPlayer(loot, loot)
	
--	for i = startno, endno do
--		local loot = "Aza_01_" .. i
--		addPokemonTileToPlayer(loot, loot)
--	end
	
	randompokemon = ZombRand(endno - startno + 1) + startno
	loot = "Aza_01_" .. randompokemon
	addPokemonTileToPlayer(loot, loot)
	
	if zonetier >= 5 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")
		for i=1, 2 do
			randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
			randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
			randomrollSD(zoneroll, "pkmncards.boosterpack")
		end
	elseif zonetier == 4 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")

		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")

	elseif zonetier == 3 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	elseif zonetier == 2 then
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	elseif zonetier == 1 then
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	end

	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
	player:getEmitter():playSoundImpl("s_pokemon", nil)
end

function ShinyPokemonCacheSD(items, result, player)
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Shiny Pokemon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local startno = 432
	local endno = 583 --432 to 583 gives shinies
	
	local randompokemon = ZombRand(endno - startno + 1) + startno
	local loot = "Aza_01_" .. randompokemon
	addPokemonTileToPlayer(loot, loot)
	
--	for i = startno, endno do
--		local loot = "Aza_01_" .. i
--		addPokemonTileToPlayer(loot, loot)
--	end
	
	if zonetier >= 5 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")
		for i=1, 2 do
			randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
			randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
			randomrollSD(zoneroll, "pkmncards.boosterpack")
		end
	elseif zonetier == 4 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")

		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")

	elseif zonetier == 3 then
		addItemToPlayer("pkmncards.boosterpackfossil")
		addItemToPlayer("pkmncards.boosterpackjungle")
		addItemToPlayer("pkmncards.boosterpack")
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	elseif zonetier == 2 then
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	elseif zonetier == 1 then
		randomrollSD(zoneroll, "pkmncards.boosterpackfossil")
		randomrollSD(zoneroll, "pkmncards.boosterpackjungle")
		randomrollSD(zoneroll, "pkmncards.boosterpack")
	end
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
	player:getEmitter():playSoundImpl("s_pokemon", nil)
end

local function rollJewelry(tier, playerObj)
	shard = ItemGenerator.getTierSoulShardExplicit(tier)
	SoulForgedJewelryOnCreate(shard, "Base.Dice", playerObj)
end

function OnCreate_JewelryCache(items, result, player)
	local zonetier, zonename, x, y = checkZone()
	local zoneroll = 8-zonetier
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Jewelry Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 6 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(5, player)
			end
		end
		rollJewelry(5, player)
	elseif zonetier == 5 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(zonetier, player)
			end
		end
		rollJewelry(zonetier, player)
	elseif zonetier == 4 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(zonetier, player)
			end
		end
		rollJewelry(zonetier, player)
	elseif zonetier == 3 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(zonetier, player)
			end
		end
		rollJewelry(zonetier, player)
	elseif zonetier == 2 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(zonetier, player)
			end
		end
		rollJewelry(zonetier, player)
	elseif zonetier == 1 then
		for i=1,zonetier do
			if ZombRand(zoneroll) == 0 then
				rollJewelry(zonetier, player)
			end
		end
		rollJewelry(zonetier, player)
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function OnCreate_SoulForgeCache(items, result, player)
-- tiered rolling, checks zone and adds item
	local zonetier, zonename, x, y = checkZone()
	local zoneroll = 8-zonetier
	
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", "SoulForge.AimingTimeTicket", "SoulForge.AimingPerkHitTicket", "SoulForge.AimingPerkCritTicket"}
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, 2, 4, 4}
	
	local soulFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSoulsSD_new")
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "SoulForge Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}

	if zonetier == 6 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
			randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
			randomrollSD(zoneroll, "SoulForge.WeightedDiceT"..zonetier)
		end
		addItemToPlayer(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer("SoulForge.WeightedDiceT5")
	elseif zonetier == 5 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
			randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
			randomrollSD(zoneroll, "SoulForge.WeightedDiceT"..zonetier)
		end
		addItemToPlayer(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer("SoulForge.WeightedDiceT"..zonetier)
	elseif zonetier == 4 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
			randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
			randomrollSD(zoneroll, "SoulForge.WeightedDiceT"..zonetier)
		end
		addItemToPlayer(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer("SoulForge.WeightedDiceT"..zonetier)
	elseif zonetier == 3 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
			randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
			randomrollSD(zoneroll, "SoulForge.WeightedDiceT"..zonetier)
		end
		randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer("SoulForge.WeightedDiceT"..zonetier)
	elseif zonetier == 2 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
			randomrollSD(zoneroll, "SoulForge.WeightedDiceT"..zonetier)
		end
		randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
		addItemToPlayer("SoulForge.WeightedDiceT"..zonetier)
	elseif zonetier == 1 then
		soulFlask:setUsedDelta(math.min(scaledNormal()/10, zonetier/50))
		randomrollSD(10, soulFlask, "SoulForge.StoredSoulsSD_new")
		for i=1,3 do
			randomrollSD(zoneroll, "SoulForge.SoulShardT"..zonetier)
		end
		randomrollSD(zoneroll, getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function OnCreate_WeatheredAmmoBoxSD(items, result, player)
	
	local gunpowder = InventoryItemFactory.CreateItem("Base.GunPowder")

	gunpowder:setUsedDelta(math.max(0.1, scaledNormal()/3))
	player:getInventory():AddItem(gunpowder)
	for i=1,10 do
		randomrollSD(4, "Base.ScrapMetalBits")
	end

end