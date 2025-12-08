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
		["Louisville Central"]={12930,2881,13654,3242,5,"Subnested",nil,20,25,25,5},
		["CC"]={10800,8750,11332,9072,1,nil,nil,0,0,0,2.35},
		["West Point West"]={10220,6600,11850,7800,1,nil,nil,5,5,10,2.35},
		["West Point East"]={11850,6600,12900,7800,2,nil,nil,10,10,15,2.9},
		["Riverside"]={5250,5175,7500,6775,1,nil,nil,5,5,10,2.35},
		["Rosewood"]={7500,11400,9300,12600,1,nil,nil,5,5,10,2.35},
		["March Ridge"]={9750,12410,10500,13200,1,nil,nil,5,5,10,2.35},
		["Lake Ivy"]={8700,9300,9600,10800,1,nil,nil,5,5,10,2.35},
		["Fort Redstone"]={5400,11700,6000,12300,3,nil,nil,15,20,20,3.3},
		["Raven Creek Military Hospital"]={2400,11100,2700,12000,6,"Subnested","Toxic",100,35,25,4.5},
		["Raven Creek PD"]={3000,11100,3300,12000,4,"Subnested",nil,35,100,100,3.9},
		["Eerie Irvington"]={11161,17788,11770,18300,6,"Subnested",nil,20,75,25,3.2},
		["Eerie PowerPlant"]={9900,13879,10966,15292,3,"Subnested",nil,35,100,100,3.1},
		["Eerie Capitol"]={8970,16600,9600,17300,4,"Subnested","Toxic",35,50,50,3},
		["Eerie MilitaryBase"]={8101,17063,8527,17610,5,"Subnested","Toxic",100,75,75,5.5},
		["Eerie Country"]={7500,13500,12300,18300,2,"Nested",nil,15,100,20,2.8},
		["Big Bear Lake Mili"]={4800,6900,5556,7160,6,"Subnested",nil,100,100,100,3.7},
		["Big Bear Lake West"]={5000,7800,5700,8200,4,"Subnested",nil,25,25,50,3.4},
		["Big Bear Lake East"]={5903,7475,6611,7855,3,"Subnested",nil,20,20,50,3},
		["Big Bear Lake"]={4800,6900,6900,8400,2,"Nested",nil,10,20,25,2.7},
		["Chestown"]={4500,6600,4800,6900,2,nil,nil,15,20,25,2.7},
		["LC Bunker"]={17775,6300,18300,6900,6,"Subnested","Toxic",100,100,100,4.5},
		["LC"]={15000,6300,18300,8100,3,"Nested",nil,15,20,25,3.3},
		["Taylorsville"]={9000,6300,10220,7200,2,nil,nil,15,20,25,2.9},
		["Grapeseed"]={7200,11100,7500,11400,2,nil,nil,15,20,25,2.9},
		["Rosewood Expansion"]={7970,10820,8790,11400,2,nil,nil,10,10,20,2.9},
		["Valley Stream Mall"]={13491,5598,14103,5985,3,nil,nil,15,35,50,3.1},
		["Shortrest City South"]={13500,6900,14250,7475,2,nil,nil,15,20,15,2.9},
		["Shortrest City East"]={14250,6900,14700,7475,3,nil,nil,20,35,25,3.1},
		["Pineville"]={3650,9000,4500,10200,2,nil,nil,15,15,15,2.9},
		["Wilbore"]={4550,9900,5100,10400,3,nil,nil,20,30,25,3.1},
		["Leavenburg"]={4800,3300,7500,4900,3,nil,nil,20,25,25,3.3},
		["New Albany T5"]={13670,430,14100,900,5,"Subnested",nil,35,50,50,4.5},
		["New Albany T4"]={12590,0,15000,900,4,"Nested",nil,25,35,35,3.75},
		["New Albany T3"]={12000,0,12590,900,3,"Nested",nil,20,25,25,3.3},
		["Greenport"]={8100,7200,8700,7800,3,nil,nil,15,20,30,3.3},
		["Green Valley Lake"]={6300,11100,7200,12000,3,nil,nil,15,30,30,2.35},
		["Ashenwood"]={11400,11130,11700,11700,3,nil,nil,20,40,30,3.3},
		["Guston"]={3650,6600,4500,9000,2,nil,nil,10,20,20,2.7},
		["Doe Valley"]={6900,8100,7500,8700,1,nil,nil,5,5,10,2.35},
		["Bridge Town"]={11400,3600,11999,4499,3,"Nested",nil,15,50,50,4},
		["RC East"]={3900,11100,4199,11999,3,"Subnested",nil,30,75,75,6},
		["RC T5"]={2700,11100,2999,11999,5,"Subnested",nil,50,100,100,2.1},
		["RC Docks"]={2400,12000,2999,12899,6,"Subnested",nil,100,75,75,6},
		["RC Central Residential"]={3300,12000,3899,12299,2,"Subnested",nil,15,25,25,2.1},
		["Road to New Albany"]={11400,600,11999,3599,2,nil,nil,10,75,100,5},
		["Skidrow West"]={12900,11100,13200,14099,3,"Subnested",nil,15,35,35,2.1},
		["Muldraugh"]={9900,9072,11050,11200,1,nil,nil,5,5,10,2.35},
		["PV Bus"]={10300,12123,10500,12410,5,nil,nil,100,100,100,12},
		["Petro North"]={10500,11400,11400,11700,5,nil,nil,0,0,0,30},
		["Inside Petro"]={10800,11700,11400,12330,6,"Subnested","Toxic",100,100,100,4.5},
		["Petroville"]={10500,11700,11700,12899,5,"Nested",nil,100,100,100,3.9},
		["Raven Creek"]={2400,11100,5100,13800,3,"Nested",nil,20,25,25,3.1},
		["RC Residential"]={3447,13052,3915,13199,1,"Subnested",nil,5,15,15,2.1},
		["Skidrow Railyard"]={13290,12600,13800,13700,5,"Subnested",nil,45,100,100,6.5},
		["Skidrow Downtown"]={14670,11800,15630,12297,6,"Subnested",nil,35,100,100,6},
		["Sikdrow Airfield"]={14670,11400,15630,11800,6,"Subnested","Toxic",100,100,100,4.5},
		["Skidrow"]={13200,11100,15900,14099,4,"Nested",nil,25,35,35,3.75},
		["Shortrest City West"]={13200,6450,13500,7475,1,nil,nil,5,5,5,2.35},
		["Shortrest City North"]={13500,6450,14700,6900,1,nil,nil,5,5,5,2.35},
		["LC Downtown West"]={16200,6300,16800,6900,5,"Subnested",nil,25,35,30,3.5},
		["LC Downtown South"]={16200,6900,16990,7730,5,"Subnested",nil,25,25,25,3.1},
		["LC Downtown"]={16800,6300,17775,6900,6,"Subnested",nil,35,50,50,3.9},
		["LCU"]={16990,6900,17720,7730,4,"Subnested",nil,15,25,35,3.1},
		["LC South"]={15530,7561,16103,7994,4,"Subnested",nil,35,100,50,5.5},
		["Louisville East"]={13200,1800,15000,4500,4,"Nested",nil,20,25,25,3.5},
		["Louisville West"]={12000,1800,13200,4500,4,"Nested",nil,20,25,25,3.5},
		["Louisville PD"]={12000,900,12590,1800,6,nil,"Toxic",100,100,100,4.5},
		["Louisville Mall"]={12590,900,13900,1800,6,nil,nil,100,35,50,3.9},
		["The Fort Approach"]={13900,1200,15000,1800,6,nil,nil,50,50,50,4.1},
		["The Fort"]={15000,1200,15600,1800,6,nil,"Toxic",100,75,75,4.5},
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

local factions = {"COG", "Ranger", "VoidWalker"}
local SDFactions = {}
for i=1,#factions do
	SDFactions[factions[i]]=true
end

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
	if not SDFactions[faction] then return nil end
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
						return NestedZone.list[_nestedZoneName][5], _nestedZoneName, x, y, control, NestedZone.list[_nestedZoneName][7], NestedZone.list[_nestedZoneName][8], NestedZone.list[_nestedZoneName][9], NestedZone.list[_nestedZoneName][10], NestedZone.list[_nestedZoneName][11], NestedZone.list[_nestedZoneName][12]
					end
				end
				local control = getControl(_zoneName, player, Zone.list[_zoneName][5])
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11], Zone.list[_zoneName][12]
			else
				local control = getControl(_zoneName, player, Zone.list[_zoneName][5])
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11], Zone.list[_zoneName][12]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, nil, nil, 1, 0, 0, base_health, nil
end

function checkZoneAtXY(x, y)
	local control = nil
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
						return NestedZone.list[_nestedZoneName][5], _nestedZoneName, x, y, control, NestedZone.list[_nestedZoneName][7], NestedZone.list[_nestedZoneName][8], NestedZone.list[_nestedZoneName][9], NestedZone.list[_nestedZoneName][10], NestedZone.list[_nestedZoneName][11], NestedZone.list[_nestedZoneName][12]
					end
				end
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11], Zone.list[_zoneName][12]
			else
				return Zone.list[_zoneName][5], _zoneName, x, y, control, Zone.list[_zoneName][7], Zone.list[_zoneName][8], Zone.list[_zoneName][9], Zone.list[_zoneName][10], Zone.list[_zoneName][11], Zone.list[_zoneName][12]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, control, nil, 1, 0, 0, base_health
end
