--------------------------------------------------
--This mod created for Project Apocalypse server--
--mod by lect-------------------------------------
--------------------------------------------------
if isClient() then return end
--[[
local function OnInitGlobalModData()
	if not ModData.exists("zonesData") then
		local zonesGMD = ModData.create("zonesData")
		zonesGMD = {}
	else

		local FactionControlledZones = ModData.getOrCreate("FactionControlledZones")
		local zonesGMD = ModData.getOrCreate("zonesData") or {}
		
		local sortedData = {}
		local function sortData(t)
			for zone, factions in pairs(t) do
				local factionData = {}
				for faction, killCount in pairs(factions) do
					table.insert(factionData, {faction = faction, killCount = killCount})
				end
				table.sort(factionData, function(a, b) return a.killCount > b.killCount end)
				sortedData[zone] = factionData
			end
		end
		
		sortData(zonesGMD)
		
		for zone, factions in pairs(zonesGMD) do
			for factionName, killCount in pairs(factions) do
				local reduxMulti = 1
				if FactionControlledZones[zone] == factionName then reduxMulti = 0.9 end
				zonesGMD[zone][factionName] = math.floor(killCount * 0.9 * reduxMulti)
			end
		end
	end
end]]
--Events.OnInitGlobalModData.Add(OnInitGlobalModData)

--[[local function countDaysPassed()
	if not ModData.exists("countDaysPassed") then
		daysPassed = ModData.create("countDaysPassed")
		daysPassed["count"] = 0
	else
		daysPassed = ModData.getOrCreate("countDaysPassed")
		if not daysPassed["count"] then daysPassed["count"] = 0 end
		if daysPassed["count"] > ZombRand(24,48) then
			ModData.remove("zonesData")
			ModData.remove("FactionControlledZones")
			daysPassed["count"] = 0
		else
			daysPassed["count"] = daysPassed["count"] + 1
		end
	end
end
Events.EveryDays.Add(countDaysPassed)]]

local zonesGMD = {}
local function OnServerStarted()
	zonesGMD = ModData.getOrCreate("zonesData")
end
Events.OnServerStarted.Add(OnServerStarted)

local function OnReceiveGlobalModData(key, modData)
	if key == "clientKillTally" and modData and type(modData) == "table" then
		local zoneKillCount = modData
		
		for zone, factions in pairs(zoneKillCount) do
			for factionName, kills in pairs(factions) do
				if not zonesGMD[zone] then zonesGMD[zone] = {} end
				if not zonesGMD[zone][factionName] then zonesGMD[zone][factionName] = 0 end
				zonesGMD[zone][factionName] = zonesGMD[zone][factionName] + zoneKillCount[zone][factionName]
				
				local globalFaction = factionName.."_global"
				if not zonesGMD[globalFaction] then zonesGMD[globalFaction] = 0 end--added 20250630
				zonesGMD[globalFaction] = zonesGMD[globalFaction] + zoneKillCount[zone][factionName]--added 20250630
			end
		end
	end
end
Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData)

--[[
local function syncKills()
	if ModData.exists("FactionControlledZones") then ModData.remove("FactionControlledZones") end
	local FactionControlledZones = ModData.getOrCreate("FactionControlledZones")

	local sortedData = {}
	local function sortData(t)
		for zone, factions in pairs(t) do
			local factionData = {}
			for faction, killCount in pairs(factions) do
				table.insert(factionData, {faction = faction, killCount = killCount})
			end
			table.sort(factionData, function(a, b) return a.killCount > b.killCount end)
			sortedData[zone] = factionData
		end
	end
	
	sortData(zonesGMD)
	
	for zone, _ in pairs(sortedData) do
		FactionControlledZones[zone] = FactionControlledZones[zone] or {}
		for k, v in pairs(sortedData[zone]) do
			FactionControlledZones[zone] = v.faction
			break
		end
	end
end]]
--Events.EveryTenMinutes.Add(syncKills)