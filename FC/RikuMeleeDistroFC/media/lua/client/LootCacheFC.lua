----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function randomrollFC(zoneroll, loot)
	if ZombRand(zoneroll) == 0 then getPlayer():getInventory():AddItem(loot) end
end
	
function MechCacheFC(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	local player = getPlayer():getInventory()
	
	local windows = splitString("Windshield1 Windshield2 Windshield3 RearWindshield1 RearWindshield2 RearWindshield3 FrontWindow1 FrontWindow2 FrontWindow3 RearWindow1 RearWindow2 RearWindow3")
	
	local regbrakes = splitString("NormalBrake1 NormalBrake2 NormalBrake3")
	
	local regsuspension = splitString("NormalSuspension1 NormalSuspension2 NormalSuspension3")
	
	local modbrakes = splitString("ModernBrake1 ModernBrake2 ModernBrake3")
	
	local modsuspension = splitString("ModernSuspension1 ModernSuspension2 ModernSuspension3")
	
	if tierzone == 4 then
		player:AddItems("ScrapMetal", ZombRand(6)+2)
		player:AddItems("EngineParts", ZombRand(9)+2)
		player:AddItem(windows[ZombRand(#windows)+1])
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 3 then
		player:AddItems("ScrapMetal", ZombRand(5)+2)
		player:AddItems("EngineParts", ZombRand(7)+2)
		player:AddItem(windows[ZombRand(#windows)+1])
		player:AddItem(modbrakes[ZombRand(#modbrakes)+1])
		player:AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 2 then
		player:AddItems("ScrapMetal", ZombRand(4)+2)
		player:AddItems("EngineParts", ZombRand(5)+2)
		player:AddItem(windows[ZombRand(#windows)+1])
		player:AddItem(regbrakes[ZombRand(#regbrakes)+1])
		player:AddItem(regsuspension[ZombRand(#regsuspension)+1])
	elseif tierzone == 1 then
		player:AddItems("ScrapMetal", ZombRand(3)+2)
		player:AddItems("EngineParts", ZombRand(4)+2)
		player:AddItem(windows[ZombRand(#windows)+1])
	end
	
end

function MetalworkCacheFC(items, result, player)

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
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
	elseif tierzone == 3 then
		player:AddItems("ScrapMetal", ZombRand(8)+4)
		player:AddItems("MetalPipe", ZombRand(4)+2)
		player:AddItems("MetalBar", ZombRand(4)+2)
		player:AddItems("SmallSheetMetal", ZombRand(4)+2)
		player:AddItem("SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
	elseif tierzone == 2 then
		player:AddItems("ScrapMetal", ZombRand(6)+4)
		player:AddItems("MetalPipe", ZombRand(3)+2)
		player:AddItems("MetalBar", ZombRand(3)+2)
		player:AddItems("SmallSheetMetal", ZombRand(3)+2)
		player:AddItem("SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
	elseif tierzone == 1 then
		player:AddItems("ScrapMetal", ZombRand(4)+4)
		player:AddItems("MetalPipe", ZombRand(2)+2)
		player:AddItems("MetalBar", ZombRand(2)+2)
		player:AddItems("SmallSheetMetal", ZombRand(2)+2)
		player:AddItem("SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
		randomrollFC(zoneroll, "SheetMetal")
	end
	
end

function FarmerCacheFC(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local farmingseeds = splitString("farming.CarrotBagSeed farming.BroccoliBagSeed farming.RedRadishBagSeed farming.StrewberrieBagSeed farming.TomatoBagSeed farming.PotatoBagSeed farming.CabbageBagSeed")
		
	local zoneroll = 6-tierzone
	local player = getPlayer():getInventory()
	
	if tierzone == 4 then
		player:AddItems("CompostBag", ZombRand(5)+2)
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem("Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
	elseif tierzone == 3 then
		player:AddItems("CompostBag", ZombRand(4)+2)
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem("Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
	elseif tierzone == 2 then
		player:AddItems("CompostBag", ZombRand(3)+2)
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem("Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
	elseif tierzone == 1 then
		player:AddItems("CompostBag", ZombRand(2)+2)
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		player:AddItem("Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
		randomrollFC(zoneroll, "Fertilizer")
	end
	
end

function AmmoCacheFC(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local ammo = splitString("Base.Bullets45Box Base.ShotgunShellsBox Base.308Box Base.556Box Base.762Box")
	
	local zoneroll = 6-tierzone
	local player = getPlayer():getInventory()
	local ammoloot = ammo[ZombRand(#ammo)+1]
	
	if tierzone == 4 then
		player:AddItem(ammoloot)
		player:AddItem(ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
	elseif tierzone == 3 then
		player:AddItem(ammoloot)
		player:AddItem(ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
	elseif tierzone == 2 then
		player:AddItem(ammoloot)
		player:AddItem(ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
	elseif tierzone == 1 then
		player:AddItem(ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
		randomrollFC(zoneroll, ammoloot)
	end
end
	
---event cache 2023
function EventCacheXMAS2023FC(items, result, player)
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	local player = getPlayer():getInventory()
	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	--local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]
	
	--player:AddItem(table2[ZombRand(n2)+1])
	player:AddItem(table2[ZombRand(n2)+1])
	--player:AddItem("PepeCoin")
	player:AddItem("PepeCoin")
	player:AddItem("Biomass")
	player:AddItem("Biomass")
	player:AddItem("DIYWeldingKit")
	player:AddItems("ScrapMetal", 20)
end

---NewYear2024reward
function NewYear2024reward(items, result, player)
	
	local player = getPlayer():getInventory()
	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	--local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]
	
	--player:AddItem(table2[ZombRand(n2)+1])
	player:AddItem(table2[ZombRand(n2)+1])
	--player:AddItem("PepeCoin")
	player:AddItem("PepeCoin")
	player:AddItem("Wallet")
	player:AddItem("BlowTorch")
	player:AddItems("EngineParts", 10)
	player:AddItems("ScrapMetal", 10)
end