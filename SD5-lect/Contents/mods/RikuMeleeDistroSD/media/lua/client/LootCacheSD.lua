----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function randomrollSD(zoneroll, loot)
	if ZombRand(zoneroll) == 0 then getPlayer():getInventory():AddItem(loot) end
end

function MechCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	local zoneroll = 6-tierzone
	local player = getPlayer():getInventory()
	
	local ki5parts = splitString("damnCraft.GlassPaneLarge damnCraft.GlassPaneSmall damnCraft.HandleClassic damnCraft.HandleModern damnCraft.HingeLarge damnCraft.HingeSmall damnCraft.RubberStrip damnCraft.TireRepairKit damnCraft.TireRepairRubberSolution damnCraft.TireRepairStrips")
	
	local regbrakes = splitString("NormalBrake1 NormalBrake2 NormalBrake3")
	
	local regsuspension = splitString("NormalSuspension1 NormalSuspension2 NormalSuspension3")
	
	local modbrakes = splitString("ModernBrake1 ModernBrake2 ModernBrake3")
	
	local modsuspension = splitString("ModernSuspension1 ModernSuspension2 ModernSuspension3")
	
	if tierzone == 4 then
		player:AddItems("EngineParts", ZombRand(tierzone*2)+2)
		player:AddItem(ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 3 then
		player:AddItems("EngineParts", ZombRand(tierzone*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])		
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 2 then
		player:AddItems("EngineParts", ZombRand(tierzone*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, regbrakes[ZombRand(#regbrakes)+1])
		randomrollSD(zoneroll, regsuspension[ZombRand(#regsuspension)+1])
	elseif tierzone == 1 then
		player:AddItems("EngineParts", ZombRand(tierzone*2)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, regsuspension[ZombRand(#regsuspension)+1])
		randomrollSD(zoneroll, regbrakes[ZombRand(#regbrakes)+1])
	end
	
end

function MetalworkCacheSD(items, result, player)


	--normal distribution number generator, rounding down to nearest 0.1
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

-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
		
	local zoneroll = 8-tierzone
	local player = getPlayer():getInventory()
	
	local newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
	local newLargetank = InventoryItemFactory.CreateItem("TW.LargePropaneTank")
	
	if tierzone == 4 then
		newLargetank:setUsedDelta(math.min(1, scaledNormal() + tierzone/10))
		player:AddItems("ScrapMetal", ZombRand(tierzone*2)+3)
		player:AddItems("MetalPipe", ZombRand(tierzone)+1)
		player:AddItems("MetalBar", ZombRand(tierzone)+1)
		player:AddItems("SmallSheetMetal", ZombRand(tierzone)+1)
		player:AddItem("SheetMetal")
		player:AddItem("BlowTorch")
		randomrollSD(zoneroll, newLargetank)
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 3 then
		newLargetank:setUsedDelta(math.min(scaledNormal()))
		player:AddItems("ScrapMetal", ZombRand(tierzone*2)+3)
		player:AddItems("MetalPipe", ZombRand(tierzone)+1)
		player:AddItems("MetalBar", ZombRand(tierzone)+1)
		player:AddItems("SmallSheetMetal", ZombRand(tierzone)+1)
		player:AddItem("SheetMetal")
		player:AddItem("BlowTorch")
		randomrollSD(zoneroll, newLargetank)
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 2 then
		newtank:setUsedDelta(math.min(1, scaledNormal() + tierzone/10))
		player:AddItems("ScrapMetal", ZombRand(tierzone*2)+3)
		player:AddItems("MetalPipe", ZombRand(tierzone)+1)
		player:AddItems("MetalBar", ZombRand(tierzone)+1)
		player:AddItems("SmallSheetMetal", ZombRand(tierzone)+1)
		player:AddItem("SheetMetal")
		player:AddItem("BlowTorch")
		randomrollSD(zoneroll, newtank)
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 1 then
		newtank:setUsedDelta(math.min(1, scaledNormal()))
		player:AddItems("ScrapMetal", ZombRand(tierzone*2)+3)
		player:AddItems("MetalPipe", ZombRand(tierzone)+1)
		player:AddItems("MetalBar", ZombRand(tierzone)+1)
		player:AddItems("SmallSheetMetal", ZombRand(tierzone)+1)
		player:AddItem("SheetMetal")
		randomrollSD(zoneroll, "BlowTorch")
		randomrollSD(zoneroll, newtank)
		randomrollSD(zoneroll, "SheetMetal")
	end
	
end

function MedicalCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local medicalitems = splitString("CDCRR.Zedalis CDCRR.Zomboflex CDCRR.Bitezapro CDCRR.Salivix CDCRR.Viazom CDCRR.Fevarax CDCRR.Humanox CanteenAndBottles.GymBottleSpiffoade SapphCooking.ThermosCoffee CanteenAndBottles.MedicinalCAnteenGreenWhiteSerum CanteenAndBottles.MedicinalCAnteenWhiteGreenSerum")
		
	local zoneroll = 7-tierzone
	local player = getPlayer():getInventory()
	
	if tierzone == 4 then
		randomrollSD((zoneroll+2), "CDCRR.CDCRedAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 3 then
		randomrollSD((zoneroll+4), "CDCRR.CDCRedAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 2 then
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 1 then
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	end
	
end

function AmmoCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local ammo = splitString("Base.Bullets45Box Base.ShotgunShellsBox Base.308Box Base.556Box Base.Bullets9mmBox Base.762x54rBox Base.762Box Base.50BMGBox Base.57Box Base.545Box Base.380Box Base.223Box")
	
	local zoneroll = 6-tierzone
	local player = getPlayer():getInventory()
	
	if tierzone == 4 then
		player:AddItem(ammo[ZombRand(#ammo)+1])
		player:AddItem(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif tierzone == 3 then
		player:AddItem(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif tierzone == 2 then
		player:AddItem(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif tierzone == 1 then
		player:AddItem(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	end
end