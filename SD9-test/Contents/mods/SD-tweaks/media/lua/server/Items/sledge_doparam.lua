local function SDvanillaweaptweak()

	local vanillaweap = {"Sledgehammer", "Sledgehammer2"}

	for i=1,#vanillaweap do

		local item = ScriptManager.instance:getItem(vanillaweap[i])
		if item then
			item:DoParam("Weight = 3.3")
			item:DoParam("CritDmgMultiplier = 3")
			item:DoParam("CriticalChance = 65")
			item:DoParam("MaxRange = 1.45")
			item:DoParam("MinAngle = 0.75")
			item:DoParam("CantAttackWithLowestEndurance = FALSE")
		end
		
	end

end
Events.OnInitGlobalModData.Add(SDvanillaweaptweak)