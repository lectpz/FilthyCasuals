----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"

function MechCacheFC(items, result, player)

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
	local function splitString(sandboxvar, delimiter)
		local ztable = {}
		local pattern = "%S+"

		for match in sandboxvar:gmatch(pattern) do
			table.insert(ztable, match)
		end
		return ztable
	end
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local windows = splitString("Windshield1 Windshield2 Windshield3 RearWindshield1 RearWindshield2 RearWindshield3 FrontWindow1 FrontWindow2 FrontWindow3 RearWindow1 RearWindow2 RearWindow3")
	local windowsno = #windows
	
	local regbrakes = splitString("NormalBrake1 NormalBrake2 NormalBrake3")
	local regbrakesno = #regbrakes
	
	local regsuspension = splitString("NormalSuspension1 NormalSuspension2 NormalSuspension3")
	local regsuspensionno = #regsuspension
	
	local modbrakes = splitString("ModernBrake1 ModernBrake2 ModernBrake3")
	local modbrakesno = #modbrakes
	
	local modsuspension = splitString("ModernSuspension1 ModernSuspension2 ModernSuspension3")
	local modsuspensionno = #modsuspension
	
			
	if tierzone == 4 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(12)+2)
		getPlayer():getInventory():AddItems("EngineParts", ZombRand(17)+2)
		getPlayer():getInventory():AddItem(windows[ZombRand(#windows)+1])
		getPlayer():getInventory():AddItem(modbrakes[ZombRand(#modbrakes)+1])
		getPlayer():getInventory():AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 3 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(9)+2)
		getPlayer():getInventory():AddItems("EngineParts", ZombRand(13)+2)
		getPlayer():getInventory():AddItem(windows[ZombRand(#windows)+1])
		getPlayer():getInventory():AddItem(modbrakes[ZombRand(#modbrakes)+1])
		getPlayer():getInventory():AddItem(modsuspension[ZombRand(#modsuspension)+1])
	elseif tierzone == 2 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(6)+2)
		getPlayer():getInventory():AddItems("EngineParts", ZombRand(9)+2)
		getPlayer():getInventory():AddItem(windows[ZombRand(#windows)+1])
		getPlayer():getInventory():AddItem(regbrakes[ZombRand(#regbrakes)+1])
		getPlayer():getInventory():AddItem(regsuspension[ZombRand(#regsuspension)+1])
	elseif tierzone == 1 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(3)+2)
		getPlayer():getInventory():AddItems("EngineParts", ZombRand(5)+2)
		getPlayer():getInventory():AddItem(windows[ZombRand(#windows)+1])
	end
	
end

function MetalworkCacheFC(items, result, player)

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
	local function splitString(sandboxvar, delimiter)
		local ztable = {}
		local pattern = "%S+"

		for match in sandboxvar:gmatch(pattern) do
			table.insert(ztable, match)
		end
		return ztable
	end
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
			
	if tierzone == 4 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(13)+4)
		getPlayer():getInventory():AddItems("MetalPipe", ZombRand(5)+2)
		getPlayer():getInventory():AddItems("MetalBar", ZombRand(5)+2)
		getPlayer():getInventory():AddItems("SmallSheetMetal", ZombRand(5)+2)
		getPlayer():getInventory():AddItem("SheetMetal")
		getPlayer():getInventory():AddItem("SheetMetal")
	elseif tierzone == 3 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(10)+4)
		getPlayer():getInventory():AddItems("MetalPipe", ZombRand(4)+2)
		getPlayer():getInventory():AddItems("MetalBar", ZombRand(4)+2)
		getPlayer():getInventory():AddItems("SmallSheetMetal", ZombRand(4)+2)
		getPlayer():getInventory():AddItem("SheetMetal")
		if ZombRand(2) == 0 then getPlayer():getInventory():AddItem("SheetMetal") else return end
	elseif tierzone == 2 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(7)+4)
		getPlayer():getInventory():AddItems("MetalPipe", ZombRand(3)+2)
		getPlayer():getInventory():AddItems("MetalBar", ZombRand(3)+2)
		getPlayer():getInventory():AddItems("SmallSheetMetal", ZombRand(3)+2)
		getPlayer():getInventory():AddItem("SheetMetal")
		if ZombRand(3) == 0 then getPlayer():getInventory():AddItem("SheetMetal") else return end
	elseif tierzone == 1 then
		getPlayer():getInventory():AddItems("ScrapMetal", ZombRand(4)+4)
		getPlayer():getInventory():AddItems("MetalPipe", ZombRand(2)+2)
		getPlayer():getInventory():AddItems("MetalBar", ZombRand(2)+2)
		getPlayer():getInventory():AddItems("SmallSheetMetal", ZombRand(2)+2)
		getPlayer():getInventory():AddItem("SheetMetal")
		if ZombRand(4) == 0 then getPlayer():getInventory():AddItem("SheetMetal") else return end
	end
	
end

function FarmerCacheFC(items, result, player)

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
	local function splitString(sandboxvar, delimiter)
		local ztable = {}
		local pattern = "%S+"

		for match in sandboxvar:gmatch(pattern) do
			table.insert(ztable, match)
		end
		return ztable
	end
	
-- tiered rolling, checks zone and adds item
	local tierzone = checkZone()
	
	local farmingseeds = splitString("farming.CarrotBagSeed farming.BroccoliBagSeed farming.RedRadishBagSeed farming.StrewberrieBagSeed farming.TomatoBagSeed farming.PotatoBagSeed farming.CabbageBagSeed")
	local farmingseedsno = #farmingseeds
	
		if tierzone == 4 then
		getPlayer():getInventory():AddItems("CompostBag", ZombRand(5)+2)
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem("Fertilizer")
		getPlayer():getInventory():AddItem("Fertilizer")
	elseif tierzone == 3 then
		getPlayer():getInventory():AddItems("CompostBag", ZombRand(4)+2)
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem("Fertilizer")
		if ZombRand(2) == 0 then getPlayer():getInventory():AddItem("Fertilizer") else return end
	elseif tierzone == 2 then
		getPlayer():getInventory():AddItems("CompostBag", ZombRand(3)+2)
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem("Fertilizer")
		if ZombRand(3) == 0 then getPlayer():getInventory():AddItem("Fertilizer") else return end
	elseif tierzone == 1 then
		getPlayer():getInventory():AddItems("CompostBag", ZombRand(2)+2)
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem(farmingseeds[ZombRand(#farmingseeds)+1])
		getPlayer():getInventory():AddItem("Fertilizer")
		if ZombRand(4) == 0 then getPlayer():getInventory():AddItem("Fertilizer") else return end
	end
	
end