local gmd_compensation20250910
local function OnServerStarted()
	--ModData.remove("compensation20250910reward")
	gmd_compensation20250910 = ModData.getOrCreate("compensation20250910reward")
end
--Events.OnServerStarted.Add(OnServerStarted)

local function compensation20250910_GMD(key, modData)
	if key == "transmit_compensation20250910reward"  and modData and type(modData)=="table" then
		for steamID, bool in pairs(modData) do
			gmd_compensation20250910[steamID] = true
		end
	end
	--[[if key == "resetRewards" then
		ModData.remove("compensation20250910reward")
		gmd_compensation20250910 = ModData.getOrCreate("compensation20250910reward")
	end]]
end
--if isServer() then Events.OnReceiveGlobalModData.Add(compensation20250910_GMD) end