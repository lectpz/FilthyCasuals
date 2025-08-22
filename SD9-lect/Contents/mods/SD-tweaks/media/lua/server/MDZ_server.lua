if isClient() then return end

local function transmitMDZ()
	ModData.transmit("MoreDifficultZones")
	Events.EveryOneMinute.Remove(transmitMDZ)
end

local function MDZ_server_sync(key, modData)
	if key == "MoreDifficultZones" and modData and type(modData) == "table" then
		ModData.add("MoreDifficultZones", modData)
		populateZoneNames()
		ModData.transmit("MoreDifficultZones")
		--Events.EveryOneMinute.Add(transmitMDZ)
	end
end
Events.OnReceiveGlobalModData.Add(MDZ_server_sync)