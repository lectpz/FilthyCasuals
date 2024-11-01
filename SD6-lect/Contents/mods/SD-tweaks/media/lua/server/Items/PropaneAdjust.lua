local function PropaneAdjust()

	local item = ScriptManager.instance:getItem("Base.BlowTorch")
	if item then
		item:DoParam("UseDelta = 0.04")
		item:DoParam("cantBeConsolided = false")
		item:DoParam("ConsolidateOption = ContextMenu_Merge")
	end
	
	local item = ScriptManager.instance:getItem("Base.PropaneTank")
	if item then
		item:DoParam("cantBeConsolided = false")
		item:DoParam("ConsolidateOption = ContextMenu_Merge")
	end
	
	local item = ScriptManager.instance:getItem("Biofuel.IndustrialPropaneTank")
	if item then
		item:DoParam("cantBeConsolided = false")
		item:DoParam("ConsolidateOption = ContextMenu_Merge")
	end
	
	local item = ScriptManager.instance:getItem("SapphCooking.WontonWrappers")
	if item then
		item:DoParam("Calories = 93")
	end
	
	local item = ScriptManager.instance:getItem("SapphCooking.ProteinBar")
	if item then
		item:DoParam("DaysFresh = 1000000000")
		item:DoParam("DaysTotallyRotten = 1000000000")
	end
end
Events.OnInitGlobalModData.Add(PropaneAdjust)