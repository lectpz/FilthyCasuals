Events.OnInitGlobalModData.Add(function()
    local scriptManager = getScriptManager()
    local item = scriptManager:getItem("Biofuel.UnfermentedSlurry")

	local freshSlurry = tostring(SandboxVars.Distillery.UnfermentedCornSlurryDaysFresh)
	local rottenSlurry = tostring(SandboxVars.Distillery.UnfermentedCornSlurryDaysTotallyRotten)
    if item then
        item:DoParam("DaysFresh = " .. freshSlurry)
        item:DoParam("DaysTotallyRotten = " .. rottenSlurry)
    end
end);

