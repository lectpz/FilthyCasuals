local tsarlibModData = {}

local function tsarlibModData_patch()
	if isClient() then
		ModData.request("tsaranimations");
	end
end

Events.OnTick.Remove(tsarlibModData.main)
Events.EveryTenMinutes.Add(tsarlibModData_patch)