----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

-- define zones (towns/maps)
zonetier = {1, 2, 3, 4, 5, 6}
zonetierno = #zonetier

-- zone input, overall zones are on top, nested zones are on bottom
-- order of this table is random, therefore i need to check for nested zones specifically otherwise it may not detect nested areas.

Zone = {
	list = {
		["LouisvillePD"]={12000,900,12590,1650,6,nil,"Toxic",100,100,100,4.5},
		["LouisvilleMallArea"]={12590,900,15000,1650,5,nil,nil,100,35,50,3.9},
		["Louisville West"]={12000,1650,13200,4360,4,"Nested",nil,20,25,25,3.5},
		["Louisville East"]={13200,1650,15000,4360,4,"Nested",nil,20,25,25,3.5},
		["Louisville Central"]={12930,2881,13654,3242,5,"Subnested",nil,20,25,25,5},
		["CC"]={10800,8750,11332,9072,1,nil,nil,0,0,0,2.35},
		["Muldraugh"]={9900,9072,11050,11400,1,nil,nil,5,5,10,2.35},
		["WestPointWest"]={10220,6600,11850,7800,1,nil,nil,5,5,10,2.35},
		["WestPointEast"]={11850,6600,12900,7800,2,nil,nil,10,10,15,2.9},
		["Riverside"]={5250,5175,7500,6775,1,nil,nil,5,5,10,2.35},
		["Rosewood"]={7500,11400,9300,12600,1,nil,nil,5,5,10,2.35},
		["MarchRidge"]={9750,12410,10500,13200,1,nil,nil,5,5,10,2.35},
		["InsidePetro"]={10930,11740,11400,12330,6,"Subnested","Toxic",100,100,100,4.5},
		["Petroville"]={10500,11400,11400,12600,5,"Nested",nil,100,100,100,3.9},
		["LakeIvy"]={8700,9300,9600,10800,1,nil,nil,5,5,10,2.35},
		["FortRedstone"]={5400,11700,6000,12300,3,nil,nil,15,20,20,3.3},
		["RavenCreekMilitaryHospital"]={3000,11100,3350,11545,5,"Subnested","Toxic",100,35,25,4.5},
		["RavenCreekPD"]={3350,11100,3870,12000,4,"Subnested",nil,35,100,100,3.9},
		["RavenCreekEast"]={3870,11100,4183,12000,3,"Subnested",nil,30,35,25,3.5},
		["RavenCreekRes2"]={4050,12970,4500,13175,1,"Subnested",nil,5,5,5,2.35},
		["RavenCreek"]={3000,11100,4800,13500,3,"Nested",nil,20,25,25,3.1},
		["EerieIrvington"]={11161,17788,11700,18299,4,"Subnested",nil,20,75,25,3.2},
		["EeriePowerPlant"]={9900,13879,10966,15292,3,"Subnested",nil,35,100,100,3.1},
		["EerieCapitol"]={8970,16600,9600,17300,6,"Subnested","Toxic",35,50,50,3},
		["EerieMilitaryBase"]={8101,17063,8527,17610,5,"Subnested","Toxic",100,75,75,5.5},
		["EerieCountry"]={7500,13500,12300,18300,2,"Nested",nil,15,100,20,2.8},
		["BigBearLakeMili"]={4800,6900,5556,7160,6,"Subnested",nil,100,100,100,3.7},
		["BigBearLakeWest"]={5000,7800,5700,8200,4,"Subnested",nil,25,25,50,3.4},
		["BigBearLakeEast"]={5903,7475,6611,7855,3,"Subnested",nil,20,20,50,3},
		["BigBearLake"]={4800,6900,6900,8400,2,"Nested",nil,10,20,25,2.7},
		["Chestown"]={4500,6600,4800,6900,2,nil,nil,15,20,25,2.7},
		["LCBunker"]={17775,6300,18300,6900,6,"Subnested","Toxic",100,100,100,4.5},
		["LCDowntown"]={16800,6300,17775,6900,5,"Subnested",nil,35,50,50,3.9},
		["LCDowntownWest"]={16300,6300,16800,7050,4,"Subnested",nil,25,35,30,3.5},
		["LCSouth1"]={15847,7561,16103,7994,4,"Subnested",nil,35,100,50,8},
		["LC"]={15000,6300,18300,8100,3,"Nested",nil,15,20,25,3.3},
		["Taylorsville"]={9000,6300,10220,7200,2,nil,nil,15,20,25,2.9},
		["Grapeseed"]={7200,11100,7500,11400,2,nil,nil,15,20,25,2.9},
		["RosewoodX"]={7970,10820,8790,11400,2,nil,nil,10,10,20,2.9},
		["ValleyStreamMall"]={13491,5598,14103,5985,3,nil,nil,15,35,50,3.1},
		["ShortrestCityRes1"]={13200,6450,13500,7475,1,nil,nil,5,5,5,2.35},
		["ShortrestCityRes2"]={13500,6450,14250,6900,1,nil,nil,5,5,5,2.35},
		["ShortrestCitySouth"]={13500,6900,14250,7475,2,nil,nil,15,20,15,2.9},
		["ShortrestCityEast"]={14250,6900,14700,7475,3,nil,nil,20,35,25,3.1},
		["Pineville"]={3650,9000,4500,10200,2,nil,nil,15,15,15,2.9},
		["Wilbore"]={4550,9900,5100,10400,3,nil,nil,20,30,25,3.1},
		["ShortestCityRes3"]={14250,6450,14700,6900,1,nil,nil,5,10,10,2.35},
		["Leavenburg"]={4800,3300,7500,4900,3,nil,nil,20,25,25,3.3},
		["New Albany T5"]={13670,430,14100,900,5,"Subnested",nil,35,50,50,4.5},
		["New Albany T4"]={12590,0,15000,900,4,"Nested",nil,25,35,35,3.75},
		["New Albany T3"]={12000,0,12590,900,3,"Nested",nil,20,25,25,3.3},
		--["Over The River South"]={11100,5700,12300,6335,6,nil,nil,40,60,80,8},
		--["Over The River North"]={11100,3000,12000,4360,3,nil,nil,25,30,30,3.3},
		--["Over The River Central"]={11100,4360,12300,5700,4,nil,nil,25,30,30,3.5},
		["Greenport"]={8100,7200,8700,7800,3,nil,nil,15,20,30,3.3},
		["Constown"]={5100,10800,6300,11700,2,nil,nil,10,20,20,2.7},
		["Green Valley Lake"]={6300,11100,7200,12000,3,nil,nil,15,30,30,2.35},
		--["Elliot Pond West"]={3900,13500,6200,14400,6,nil,nil,100,50,50,3.9},
		--["Elliot Pond East"]={6200,13500,7500,15600,4,nil,nil,25,60,60,3.1},
		--["Utopia"]={7200,9500,7600,9900,4,nil,nil,30,50,50,3.9},
		["Ashenwood"]={11400,11130,11700,11700,3,nil,nil,20,40,30,3.3},
		["Shepherdsville"]={14700,7900,15000,8300,2,nil,nil,5,10,10,2.35},
		["Guston"]={3650,6600,4500,9000,2,nil,nil,10,20,20,2.7},
		["RavenCreekResidential"]={3870,12000,4367,12335,3,"Subnested",nil,15,30,20,2.1},
		["The Fort"]={15001,1200,15599,1799,6,nil,"Toxic",100,75,75,4},
		--["Boat Toxic "]={11100,6334,11400,6593,6,nil,"Toxic",100,75,80,8},
		--["Bananas"]={9236,4861,9573,5108,4,nil,nil,0,0,0,5.6},
		["PV Bus"]={10300,12123,10500,12410,3,nil,nil,50,50,100,2.1},
		--["Elliot Pond Road"]={7195,13200,10800,13500,3,nil,nil,10,55,55,2.1},
		--["jasperville"]={4800,1500,7499,3299,3,nil,nil,20,25,25,3.3},
		["Doe Valley"]={6900,8100,7500,8700,1,nil,nil,5,5,10,2.35},
	}
}

NestedZone = {
	list = {
	}
}

for k,v in pairs(Zone.list) do
	if v[6] == "Subnested" then
		NestedZone.list[k]=v
	end
end

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
	if ModData.exists("globalzonesData") then ModData.getOrCreate("globalzonesData") end
	if ModData.exists("MoreDifficultZones") then ModData.remove("MoreDifficultZones") end
end

--local controlledZones = {}
local zonesData = {}--added 20250630

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
	
	--[[if key == "FactionControlledZones" and modData and type(modData) == "table" then
		controlledZones = modData
	end]]
	
	if key == "zonesData" and modData and type(modData) == "table" then
		ModData.add("zonesData", modData)
		zonesData = ModData.getOrCreate("zonesData")
	end
	
	if key == "globalzonesData" and modData and type(modData) == "table" then
		ModData.add("globalzonesData", modData)
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

--[[local function FactionControlledZones()
	ModData.request("FactionControlledZones")
	--ModData.request("zoneOverride")
end
if not isServer() then Events.OnInitGlobalModData.Add(FactionControlledZones) end
if not isServer() then Events.EveryTenMinutes.Add(FactionControlledZones) end]]
local function getZonesData()
	ModData.request("zonesData")
end
if not isServer() then Events.OnInitGlobalModData.Add(getZonesData) end
if not isServer() then Events.EveryTenMinutes.Add(getZonesData) end

--------------------------------------------------------------
--------------------------------------------------------------

local function getControl(zone, player, tier)
	--[[local faction
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
	end]]
	
	local faction = nil
	local pMD = player:getModData()
	if pMD.faction then 
		faction = pMD.faction
	end
	if not faction then return nil end
	--if not zonesGMD[faction.."_global"] then return nil end
	
	--if zonesGMD[faction.."_global"] and zonesGMD[zone][faction] then
	if not zonesData[zone] then return nil end
	if zonesData[zone][faction] then
		--if isDebugEnabled() then player:Say("DEBUG: Controlled Zone: " .. zone .. " by Faction: " .. faction) end
		--local control = math.min(0.25,zonesGMD[zone][faction]/zonesGMD[faction.."_global"])
		local control = zonesData[zone][faction] / (tier*1000)
		if control >= 1 then return "control" end
	end
	
	return nil
end

local base_health = 2.1
function checkZone(x,y)
	local player = getSpecificPlayer(0)
	
	local x = x or player:getX()
	local y = y or player:getY()
	
	for i = 1, #ZoneNames do
		local _zoneName = ZoneNames[i]
		local x1 = Zone.list[_zoneName][1]
		local y1 = Zone.list[_zoneName][2]
		local x2 = Zone.list[_zoneName][3]
		local y2 = Zone.list[_zoneName][4]

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if Zone.list[_zoneName][6] == "Nested" then 
				for j = 1, #NestedZoneNames do
					local _nestedZoneName = NestedZoneNames[j]
					local xx1 = NestedZone.list[_nestedZoneName][1]
					local yy1 = NestedZone.list[_nestedZoneName][2]
					local xx2 = NestedZone.list[_nestedZoneName][3]
					local yy2 = NestedZone.list[_nestedZoneName][4]
					if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
						local control = getControl(_nestedZoneName, player, NestedZone.list[_nestedZoneName][5])
						return NestedZone.list[_nestedZoneName][5], _nestedZoneName, x, y, control, NestedZone.list[_nestedZoneName][7], NestedZone.list[_nestedZoneName][8], NestedZone.list[_nestedZoneName][9], NestedZone.list[_nestedZoneName][10], NestedZone.list[_nestedZoneName][11]
					end
				end
				local control = getControl(_zoneName, player, Zone.list[_zoneName][5])
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11]
			else
				local control = getControl(_zoneName, player, Zone.list[_zoneName][5])
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, 0, nil, 1, 0, 0, base_health
end

function checkZoneAtXY(x, y)
	local control = 0
	for i = 1, #ZoneNames do
		local _zoneName = ZoneNames[i]
		local x1 = Zone.list[_zoneName][1]
		local y1 = Zone.list[_zoneName][2]
		local x2 = Zone.list[_zoneName][3]
		local y2 = Zone.list[_zoneName][4]
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if Zone.list[_zoneName][6] == "Nested" then 
				for j = 1, #NestedZoneNames do
					local _nestedZoneName = NestedZoneNames[j]
					local xx1 = NestedZone.list[_nestedZoneName][1]
					local yy1 = NestedZone.list[_nestedZoneName][2]
					local xx2 = NestedZone.list[_nestedZoneName][3]
					local yy2 = NestedZone.list[_nestedZoneName][4]
					if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
						return NestedZone.list[_nestedZoneName][5], _nestedZoneName, x, y, control, NestedZone.list[_nestedZoneName][7], NestedZone.list[_nestedZoneName][8], NestedZone.list[_nestedZoneName][9], NestedZone.list[_nestedZoneName][10], NestedZone.list[_nestedZoneName][11]
					end
				end
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11]
			else
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, control, nil, 1, 0, 0, base_health
end
