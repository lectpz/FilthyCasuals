local gmd_welcomePackage
local function OnServerStarted()
	gmd_welcomePackage = ModData.getOrCreate("welcomePackage")
end
Events.OnServerStarted.Add(OnServerStarted)

local function welcomePackage_GMD(key, modData)
	if key == "transmit_welcomePackage"  and modData and type(modData)=="table" then
		for steamID, bool in pairs(modData) do
			gmd_welcomePackage[steamID] = true
		end
	end
	--[[if key == "resetRewards" then
		ModData.remove("welcomePackage")
		gmd_welcomePackage = ModData.getOrCreate("welcomePackage")
	end]]
end
if isServer() then Events.OnReceiveGlobalModData.Add(welcomePackage_GMD) end