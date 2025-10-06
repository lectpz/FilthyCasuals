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

    local items = ScriptManager.instance:getAllItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getEnduranceMod() > 1 then
            item:DoParam("EnduranceMod = 1")
        end
		if item:getChanceToFall() > 0 then
            item:DoParam("ChanceToFall = 0")
        end
    end
end
Events.OnInitGlobalModData.Add(SDvanillaweaptweak)

local function frogTweak()
	local frogItem = ScriptManager.instance:getItem("Base.paleSkinLegacy")
	if frogItem then
		frogItem:DoParam("BodyLocation = SWSuit")
		frogItem:DoParam("BloodLocation = Trousers;Jumper;Head;Neck;Hands;Shoes")
	end
end
Events.OnInitGlobalModData.Add(frogTweak)