local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function RMWadjust()
	local RMWacritchance = {
		["RMWeapons.firelink"] = 27,
		["RMWeapons.themauler"] = 31,
		["RMWeapons.warhammer40k"] = 30,
		["RMWeapons.MizutsuneSword"] = 29,
		["RMWeapons.Nikabo"] = 32,
		["RMWeapons.falchion"] = 35,
		["RMWeapons.spinecrusher"] = 28,
		["RMWeapons.thunderbreaker"] = 31
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


local function SDvanillaweaptweak()

	local vanillaweap = splitString("PickAxe Axe Machete WoodAxe")

	for i=1,#vanillaweap do

		local item = ScriptManager.instance:getItem(vanillaweap[i])
		if item then
			item:DoParam("CritDmgMultiplier = 4")
		end
		
	end
	
	local item = ScriptManager.instance:getItem("WoodAxe")
	if item then
		item:DoParam("CriticalChance	=	25")
	end

end
Events.OnInitGlobalModData.Add(FCvanillaweaptweak)