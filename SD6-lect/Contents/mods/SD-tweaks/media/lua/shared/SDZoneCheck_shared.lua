----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

-- define zones (towns/maps)
zonetier = {1, 2, 3, 4, 5}
zonetierno = #zonetier

-- zone input, overall zones are on top, nested zones are on bottom
-- order of this table is random, therefore i need to check for nested zones specifically otherwise it may not detect nested areas.

Zone = {
	list = {
		["LouisvillePD"] = {12000, 1200, 12700, 1650, 5, nil, "Toxic", 100, 50, 100},
		["LouisvilleMallArea"] = {12700, 1200, 15000, 1650, 5, nil, nil, 100, 35, 50},
		["Louisville"] = {12000, 1650, 15000, 4200, 4, nil, nil, 20, 25, 25},
		["CC"] = {10800, 8750, 11332, 9072, 1, nil, nil, 0, 0, 0},
		["Muldraugh"] = {9900, 9072, 11050, 11400, 1, nil, nil, 5, 5, 10},
		["WestPointWest"] = {10220, 6600, 11850, 7800, 1, nil, nil, 5, 5, 10},
		["WestPointEast"] = {11850, 6600, 12900, 7800, 2, nil, nil, 10, 10, 15},
		["Riverside"] = {5400, 5100, 7800, 6300, 1, nil, nil, 5, 5, 10},
		["Rosewood"] = {7500, 11400, 9300, 12600, 1, nil, nil, 5, 5, 10},
		["MarchRidge"] = {9600, 12300, 10500, 13500, 1, nil, nil, 5, 5, 10},
		["InsidePetro"] = {10930, 11740, 11400, 12330, 5, "Subnested", nil, 100, 100, 100},
		["Petroville"] = {10500, 11400, 11400, 12600, 4, "Nested", nil, 100, 50, 100},
		["LakeIvy"] = {8700, 9300, 9600, 10800, 1, nil, nil, 5, 5, 10},
		["FortRedstone"] = {5400, 11700, 6000, 12300, 2, nil, nil, 15, 20, 20},
		["RavenCreekMilitaryHospital"] = {3000, 11100, 3350, 11545, 5, "Subnested", "Toxic", 100, 35, 25},
		["RavenCreekPD"] = {3350, 11100, 3870, 12000, 5, "Subnested", nil, 35, 100, 100},
		["RavenCreekEast"] = {3870, 11100, 4183, 12000, 4, "Subnested", nil, 25, 35, 25},
		["RavenCreekCentral"] = {3570, 12300, 4300, 12900, 4, "Subnested", nil, 25, 50, 30},
		["RavenCreekRes1"] = {3900, 12000, 4500, 12300, 1, "Subnested", nil, 5, 5, 5},
		["RavenCreekRes2"] = {4050, 12970, 4500, 13175, 1, "Subnested", nil, 5, 5, 5},
		["RavenCreek"] = {3000, 11100, 5400, 13500, 3, "Nested", nil, 20, 25, 25},
		["EerieIrvington"] = {11161, 17788, 11700, 18299, 4, "Subnested", nil, 20, 20, 25},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, 3, "Subnested", nil, 20, 20, 25},
		["EerieCapitol"] = {8970, 16600, 9600, 17300, 4, "Subnested", nil, 35, 50, 50},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, 5, "Subnested", "Toxic", 100, 25, 35},
		["EerieCountry"] = {7200, 13500, 12300, 18300, 2, "Nested", nil, 15, 20, 20},
		["BigBearLakeMili"] = {4800, 6900, 5556, 7160, 5, "Subnested", nil, 100, 100, 100},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, 4, "Subnested", nil, 25, 25, 50},
		["BigBearLakeEast"] = {5903, 7475, 6611, 7855, 3, "Subnested", nil, 20, 20, 50},
		["BigBearLake"] = {4800, 6900, 6900, 8400, 2, "Nested", nil, 10, 20, 25},
		["Chestown"] = {4500, 6600, 4800, 6900, 2, nil, nil, 15, 20, 25},
		["LCBunker"] = {17775, 6300, 18300, 6900, 5, "Subnested", "Toxic", 100, 100, 100},
		["LCDowntown"] = {16800, 6300, 17775, 6900, 5, "Subnested", nil, 35, 50, 50},
		["LCDowntownWest"] = {16300, 6300, 16800, 7050, 4, "Subnested", nil, 25, 35, 30},
		["LCSouth1"] = {15783, 7420, 16103, 7994, 4, "Subnested", nil, 25, 35, 50},
		["LCSouth2"] = {16475, 7190, 17013, 7653, 4, "Subnested", nil, 25, 35, 50},
		["LC"] = {15000, 6300, 18300, 8100, 3, "Nested", nil, 15, 20, 25},
		["Taylorsville"] = {9000, 6300, 10220, 7200, 2, nil, nil, 15, 20, 25},
		["Grapeseed"] = {7200, 11100, 7500, 11400, 2, nil, nil, 15, 20, 25},
		["LVshipping"] = {12250, 4500, 12750, 4950, 2, nil, nil, 10, 15, 20},
		["LVairport"] = {12750, 4200, 13500, 4800, 2, nil, nil, 10, 15, 20},
		["OaksdaleU"] = {12000, 11314, 12810, 12050, 3, nil, nil, 15, 25, 35},
		["Nettle"] = {6470, 8880, 7280, 9700, 3, nil, nil, 15, 25, 35},
		["RosewoodX"] = {7970, 10820, 8790, 11400, 2, nil, nil, 10, 10, 20},
		["DirkerTownSouthT3"] = {8869, 5662, 9256, 5961, 3, nil, nil, 25, 35, 50},
		--["DirkerTownSouthT4"] = {8940, 5700, 9075, 5825, 4, "Subnested", "Toxic", 50, 50, 50},
		["DirkerTownSouthEastT3"] = {8990, 4680, 9389, 4869, 3, "Nested", nil, 25, 35, 50},
		["DirkerTownSouthEastT4"] = {9050, 4770, 9279, 4839, 4, "Subnested", "Toxic", 50, 50, 50},
		["DirkerCityT3N"] = {6400, 2100, 8800, 2648, 3, nil, nil, 25, 35, 50},
		["DirkerCityT3West"] = {6400, 2648, 6770, 4156, 3, nil, nil, 25, 35, 50},
		["DirkerCityT3South"] = {6400, 4156, 8800, 5100, 3, nil, nil, 25, 35, 50},
		["DirkerCityT4NW"] = {6770, 2648, 7150, 3150, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4N"] = {7150, 2648, 8150, 3150, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4NE"] = {8150, 2648, 8800, 3150, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4W"] = {6770, 3150, 7150, 3650, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4E"] = {8150, 3150, 8800, 3650, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4SW"] = {6770, 3650, 7150, 4156, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4S"] = {7150, 3650, 8150, 4156, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4SE"] = {8150, 3650, 8800, 4156, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT4EE"] = {8800, 3150, 9270, 3650, 4, nil, "Toxic", 50, 50, 50},
		["DirkerCityT5W"] = {7150, 3150, 7650, 3650, 5, nil, "Toxic", 100, 100, 100},
		["DirkerCityT5E"] = {7650, 3150, 8150, 3650, 5, nil, "Toxic", 100, 100, 100},
		["DirkerTownNorthWestT3"] = {2100, 2450, 2900, 3100, 3, "Nested", nil, 25, 35, 50},
		["DirkerTownNorthWestT4"] = {2300, 2650, 2700, 2900, 4, "Subnested", "Toxic", 25, 35, 50},
		["DirkerEncampment"] = {9812, 3304, 10277, 3630, 3, nil, nil, 25, 35, 50},
		["ValleyStreamMall"] = {13491, 5598, 14103, 5985, 3, nil, nil, 20, 35, 50},
		["ShortrestCityRes1"] = {13200, 6450, 13500, 7475, 1, nil, nil, 5, 5, 5},
		["ShortrestCityRes2"] = {13500, 6450, 14250, 6900, 1, nil, nil, 5, 5, 5},
		["ShortrestCitySouth"] = {13500, 6900, 14250, 7475, 2, nil, nil, 15, 20, 15},
		["ShortrestCityEast"] = {14250, 6450, 14700, 7475, 3, nil, nil, 20, 35, 25},
		["Elroy"] = {3600, 7850, 4250, 8650, 2, nil, nil, 15, 15, 15},
		["CathayaValley"] = {3600, 8650, 4250, 9150, 2, nil, nil, 15, 15, 15},
		["Pineville"] = {3900, 9150, 4350, 10200, 2, nil, nil, 15, 15, 15},
		["Wilbore"] = {4550, 9900, 5100, 10350, 3, nil, nil, 20, 30, 25},
	}
}

NestedZone = {
	list = {
		["InsidePetro"] = {10930, 11740, 11400, 12330, 5, "Subnested", nil, 100, 100, 100},
		["LCBunker"] = {17775, 6300, 18300, 6900, 5, "Subnested", "Toxic", 100, 100, 100},
		["LCDowntown"] = {16800, 6300, 17775, 6900, 5, "Subnested", nil, 35, 50, 50},
		["LCDowntownWest"] = {16300, 6300, 16800, 7050, 4, "Subnested", nil, 25, 35, 30},
		["LCSouth1"] = {15783, 7420, 16103, 7994, 4, "Subnested", nil, 25, 35, 50},
		["LCSouth2"] = {16475, 7190, 17013, 7653, 4, "Subnested", nil, 25, 35, 50},
		["RavenCreekMilitaryHospital"] = {3000, 11100, 3350, 11545, 5, "Subnested", "Toxic", 100, 35, 25},
		["RavenCreekPD"] = {3350, 11100, 3870, 12000, 5, "Subnested", nil, 35, 100, 100},
		["RavenCreekEast"] = {3870, 11100, 4183, 12000, 4, "Subnested", nil, 25, 35, 25},
		["RavenCreekCentral"] = {3570, 12300, 4300, 12900, 4, "Subnested", nil, 25, 50, 30},
		["RavenCreekRes1"] = {3900, 12000, 4500, 12300, 1, "Subnested", nil, 5, 5, 5},
		["RavenCreekRes2"] = {4050, 12970, 4500, 13175, 1, "Subnested", nil, 5, 5, 5},
		["EerieIrvington"] = {11161, 17788, 11700, 18299, 4, "Subnested", nil, 20, 20, 25},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, 3, "Subnested", nil, 20, 20, 25},
		["EerieCapitol"] = {8970, 16600, 9600, 17300, 4, "Subnested", nil, 35, 50, 50},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, 5, "Subnested", "Toxic", 100, 25, 35},
		["BigBearLakeMili"] = {4800, 6900, 5556, 7160, 5, "Subnested", nil, 100, 100, 100},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, 4, "Subnested", nil, 25, 25, 50},
		["BigBearLakeEast"] = {5903, 7475, 6611, 7855, 3, "Subnested", nil, 20, 20, 50},
		--["DirkerTownSouthT4"] = {8940, 5700, 9075, 5825, 4, "Subnested", "Toxic", 50, 50, 50},
		["DirkerTownSouthEastT4"] = {9050, 4770, 9279, 4839, 4, "Subnested", "Toxic", 50, 50, 50},
		["DirkerTownNorthWestT4"] = {2300, 2650, 2700, 2900, 4, "Subnested", "Toxic", 25, 35, 50},
	}
}

function getZoneNames(zonelist)
	local zoneNames = {}
	for zoneName, _ in pairs(zonelist) do
		table.insert(zoneNames, zoneName)
	end
	return zoneNames
end

ZoneNames = {}
NestedZoneNames = {}
function populateZoneNames()
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	for k,v in pairs(MDZ) do
		if v == "DELETE" then
			Zone.list[k] = nil
			NestedZone.list[k] = nil
		else
			Zone.list[k] = v
			if v[6] == "Subnested" then
				NestedZone.list[k] = v
			end
		end
	end
	ZoneNames = getZoneNames(Zone.list)
	NestedZoneNames = getZoneNames(NestedZone.list)
end
function initZoneNames()
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	for k,v in pairs(MDZ) do
		if not Zone.list[k] and v == "DELETE" then
			MDZ[k] = nil
		elseif v == "DELETE" then
			Zone.list[k] = nil
			NestedZone.list[k] = nil
		else
			Zone.list[k] = v
			if v[6] == "Subnested" then
				NestedZone.list[k] = v
			end
		end
	end
	ZoneNames = getZoneNames(Zone.list)
	NestedZoneNames = getZoneNames(NestedZone.list)
end
Events.OnGameStart.Add(initZoneNames)
Events.OnServerStarted.Add(initZoneNames)

--------------------------------------------------------------
--------------------------------------------------------------
local ZoneOverride = {}
if not isServer() then
	if ModData.exists("FactionControlledZones") then ModData.remove("FactionControlledZones") end
	if ModData.exists("zonesData") then ModData.remove("zonesData") end
	if ModData.exists("MoreDifficultZones") then ModData.remove("MoreDifficultZones") end
end

local controlledZones = {}

function tick_populateZoneNames()
	Events.OnPlayerUpdate.Remove(tick_populateZoneNames)
	populateZoneNames()
end

local function OnReceiveGlobalModData(key, modData)
	if key == "zoneOverride" then
		if type(modData) == "table" then
			ZoneOverride = modData
		end
	end
	
	if key == "FactionControlledZones" and modData and type(modData) == "table" then
		controlledZones = modData
	end
	
	if key == "zonesData" and modData and type(modData) == "table" then
		ModData.add("zonesData", modData)
	end
	
	if key == "MoreDifficultZones" and modData and type(modData) == "table" then
		ModData.add("MoreDifficultZones", modData)
		Events.OnPlayerUpdate.Add(tick_populateZoneNames)
	end
end
if not isServer() then Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData) end

local function getMoreDifficultZones()
	ModData.request("MoreDifficultZones")
end
if not isServer() then Events.OnInitGlobalModData.Add(getMoreDifficultZones) end

local function FactionControlledZones()
	ModData.request("FactionControlledZones")
	--ModData.request("zoneOverride")
end
if not isServer() then Events.OnInitGlobalModData.Add(FactionControlledZones) end
if not isServer() then Events.EveryTenMinutes.Add(FactionControlledZones) end

--------------------------------------------------------------
--------------------------------------------------------------

local function getControl(zone, player)
	local faction
	local pMD = player:getModData()
	if pMD.faction then 
		faction = pMD.faction
	else
		faction = nil
	end
	if not controlledZones[zone] or not faction then return nil end
	if controlledZones[zone] == faction then
		--if isDebugEnabled() then player:Say("DEBUG: Controlled Zone: " .. zone .. " by Faction: " .. faction) end
		return "control"
	else
		return nil
	end
end

function checkZone(x,y)
	local player = getSpecificPlayer(0)
	
	local x = x or player:getX()
	local y = y or player:getY()
	
	for i = 1, #ZoneNames do
		local x1 = Zone.list[ZoneNames[i]][1]
		local y1 = Zone.list[ZoneNames[i]][2]
		local x2 = Zone.list[ZoneNames[i]][3]
		local y2 = Zone.list[ZoneNames[i]][4]

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if Zone.list[ZoneNames[i]][6] == "Nested" then 
				for j = 1, #NestedZoneNames do
					local xx1 = NestedZone.list[NestedZoneNames[j]][1]
					local yy1 = NestedZone.list[NestedZoneNames[j]][2]
					local xx2 = NestedZone.list[NestedZoneNames[j]][3]
					local yy2 = NestedZone.list[NestedZoneNames[j]][4]
					if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
						local control = getControl(NestedZoneNames[j], player) or nil
						return NestedZone.list[NestedZoneNames[j]][5], NestedZoneNames[j], x, y, control, NestedZone.list[NestedZoneNames[j]][7], NestedZone.list[NestedZoneNames[j]][8], NestedZone.list[NestedZoneNames[j]][9], NestedZone.list[NestedZoneNames[j]][10]
					end
				end
				local control = getControl(ZoneNames[i], player) or nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7], Zone.list[ZoneNames[i]][8], Zone.list[ZoneNames[i]][9], Zone.list[ZoneNames[i]][10]
			else
				local control = getControl(ZoneNames[i], player) or nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7], Zone.list[ZoneNames[i]][8], Zone.list[ZoneNames[i]][9], Zone.list[ZoneNames[i]][10]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, nil, nil, 5, 5, 0
end

function checkZoneAtXY(x, y)
	local control = nil
	for i = 1, #ZoneNames do
		local x1 = Zone.list[ZoneNames[i]][1]
		local y1 = Zone.list[ZoneNames[i]][2]
		local x2 = Zone.list[ZoneNames[i]][3]
		local y2 = Zone.list[ZoneNames[i]][4]
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if Zone.list[ZoneNames[i]][6] == "Nested" then 
				for j = 1, #NestedZoneNames do
					local xx1 = NestedZone.list[NestedZoneNames[j]][1]
					local yy1 = NestedZone.list[NestedZoneNames[j]][2]
					local xx2 = NestedZone.list[NestedZoneNames[j]][3]
					local yy2 = NestedZone.list[NestedZoneNames[j]][4]
					if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
						return NestedZone.list[NestedZoneNames[j]][5], NestedZoneNames[j], x, y, control, NestedZone.list[NestedZoneNames[j]][7], NestedZone.list[NestedZoneNames[j]][8], NestedZone.list[NestedZoneNames[j]][9], NestedZone.list[NestedZoneNames[j]][10]
					end
				end
				local control = nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7], Zone.list[ZoneNames[i]][8], Zone.list[ZoneNames[i]][9], Zone.list[ZoneNames[i]][10]
			else
				local control = nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7], Zone.list[ZoneNames[i]][8], Zone.list[ZoneNames[i]][9], Zone.list[ZoneNames[i]][10]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, nil, nil, 5, 5, 0
end