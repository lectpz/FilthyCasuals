local gmd_xmas2024
local function OnServerStarted()
	gmd_xmas2024 = ModData.getOrCreate("XMAS2024reward")
end
--Events.OnServerStarted.Add(OnServerStarted)

local function XMAS2024_GMD(key, modData)
	if key == "transmit_XMAS2024reward"  and modData and type(modData)=="table" then
		for steamID, bool in pairs(modData) do
			gmd_xmas2024[steamID] = true
		end
	end
end
--if not isClient() then Events.OnReceiveGlobalModData.Add(XMAS2024_GMD) end