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
	
	local ki5parts = splitString("damnCraft.GlassPaneLarge damnCraft.GlassPaneSmall damnCraft.HandleClassic damnCraft.HandleModern damnCraft.HingeLarge damnCraft.HingeSmall damnCraft.RubberStrip")
	
	local regbrakes = splitString("NormalBrake1 NormalBrake2 NormalBrake3")
	
	local regsuspension = splitString("NormalSuspension1 NormalSuspension2 NormalSuspension3")
	
	local modbrakes = splitString("ModernBrake1 ModernBrake2 ModernBrake3")
	
	local modsuspension = splitString("ModernSuspension1 ModernSuspension2 ModernSuspension3")
	
	if tierzone == 4 then
		player:AddItems("EngineParts", ZombRand(10)+2)
		player:AddItem(ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 3 then
		player:AddItems("EngineParts", ZombRand(8)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 2 then
		player:AddItems("EngineParts", ZombRand(6)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, modbrakes[ZombRand(#modbrakes)+1])
		randomrollSD(zoneroll, modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 1 then
		player:AddItems("EngineParts", ZombRand(4)+2)
		randomrollSD(zoneroll, ki5parts[ZombRand(#ki5parts)+1])
		randomrollSD(zoneroll, regsuspension[ZombRand(#regsuspension)+1])
		randomrollSD(zoneroll, regbrakes[ZombRand(#regbrakes)+1])
	end
	
end

function MetalworkCacheSD(items, result, player)

-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
		
	local zoneroll = 8-tierzone
	local player = getPlayer():getInventory()
	
	if tierzone == 4 then
		player:AddItems("ScrapMetal", ZombRand(10)+4)
		player:AddItems("MetalPipe", ZombRand(5)+2)
		player:AddItems("MetalBar", ZombRand(5)+2)
		player:AddItems("SmallSheetMetal", ZombRand(5)+2)
		player:AddItem("SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 3 then
		player:AddItems("ScrapMetal", ZombRand(8)+4)
		player:AddItems("MetalPipe", ZombRand(4)+2)
		player:AddItems("MetalBar", ZombRand(4)+2)
		player:AddItems("SmallSheetMetal", ZombRand(4)+2)
		player:AddItem("SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 2 then
		player:AddItems("ScrapMetal", ZombRand(6)+4)
		player:AddItems("MetalPipe", ZombRand(3)+2)
		player:AddItems("MetalBar", ZombRand(3)+2)
		player:AddItems("SmallSheetMetal", ZombRand(3)+2)
		player:AddItem("SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
	elseif tierzone == 1 then
		player:AddItems("ScrapMetal", ZombRand(4)+4)
		player:AddItems("MetalPipe", ZombRand(2)+2)
		player:AddItems("MetalBar", ZombRand(2)+2)
		player:AddItems("SmallSheetMetal", ZombRand(2)+2)
		player:AddItem("SheetMetal")
		randomrollSD(zoneroll, "SheetMetal")
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
		randomrollSD(zoneroll, "CDCRR.CDCRedAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 3 then
		randomrollSD((zoneroll+2), "CDCRR.CDCRedAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 2 then
		randomrollSD(zoneroll, "CDCRR.CDCOrangeAirdrop")
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	elseif tierzone == 1 then
		randomrollSD(zoneroll, "CDCRR.CDCYellowAirdrop")
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
		player:AddItem(medicalitems[ZombRand(#medicalitems)+1])
	end
	
end

function AmmoCacheSD(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local ammo = splitString("Base.Bullets45Box Base.ShotgunShellsBox Base.308Box Base.556Box Base.762Box")
	
	local zoneroll = 6-tierzone
	local player = getPlayer():getInventory()
	
	if tierzone == 4 then
		player:AddItem(ammo[ZombRand(#ammo)+1])
		player:AddItem(ammo[ZombRand(#ammo)+1])
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