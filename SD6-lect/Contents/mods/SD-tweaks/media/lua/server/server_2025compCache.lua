local gmd_compensation20250610
local function OnServerStarted()
	gmd_compensation20250610 = ModData.getOrCreate("compensation20250610reward")
end
Events.OnServerStarted.Add(OnServerStarted)

local function compensation20250610_GMD(key, modData)
	if key == "transmit_compensation20250610reward"  and modData and type(modData)=="table" then
		for steamID, bool in pairs(modData) do
			gmd_compensation20250610[steamID] = true
		end
	end
end
if isServer() then Events.OnReceiveGlobalModData.Add(compensation20250610_GMD) end