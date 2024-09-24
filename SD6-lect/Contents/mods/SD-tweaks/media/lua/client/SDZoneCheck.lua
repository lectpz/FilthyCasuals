----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

-- define zones (towns/maps)
zonetier = {1, 2, 3, 4}
zonetierno = #zonetier

-- zone input, overall zones are on top, nested zones are on bottom
-- order of this table is random, therefore i need to check for nested zones specifically otherwise it may not detect nested areas.

Zone = {
	list = {
		["LouisvillePD"] = {12000, 1200, 12700, 1950, SandboxVars.SDZones.LouisvillePD, nil, nil},
		["LouisvilleMallArea"] = {12700, 1200, 15000, 1950, SandboxVars.SDZones.LouisvilleMallArea, nil, nil},
		["Louisville"] = {11700, 900, 15000, 4200, SandboxVars.SDZones.Louisville, "Nested", nil},
		["CC"] = {11100, 8700, 11400, 9300, SandboxVars.SDZones.CC, nil, nil},
		["Muldraugh"] = {9900, 8400, 12300, 11400, SandboxVars.SDZones.Muldraugh, nil, nil},
		["WestPointWest"] = {10220, 6600, 11850, 7800, SandboxVars.SDZones.WestPointWest, nil, nil},
		["WestPointEast"] = {11850, 6600, 12900, 7800, SandboxVars.SDZones.WestPointEast, nil, nil},
		["Riverside"] = {5400, 5100, 7800, 6300, SandboxVars.SDZones.Riverside, nil, nil},
		["Rosewood"] = {7500, 10800, 9300, 12600, SandboxVars.SDZones.Rosewood, nil, nil},
		["MarchRidge"] = {9600, 12300, 10500, 13500, SandboxVars.SDZones.MarchRidge, nil, nil},
		["InsidePetro"] = {10930, 12100, 11110, 12330, SandboxVars.SDZones.InsidePetro, nil, nil},
		["Petroville"] = {10500, 11400, 11400, 13500, SandboxVars.SDZones.Petroville, "Nested", nil},
		["LakeIvy"] = {8700, 9300, 9600, 10800, SandboxVars.SDZones.LakeIvy, nil, nil},
		["FortRedstone"] = {5400, 11700, 6000, 12300, SandboxVars.SDZones.FortRedstone, nil, nil},
		["RavenCreekPDMilitaryHospital"] = {3000, 11100, 3670, 11950, SandboxVars.SDZones.RavenCreekPDMilitaryHospital, nil, nil},
		["RavenCreekEntrance"] = {3670, 11100, 4183, 11950, SandboxVars.SDZones.RavenCreekEntrance, nil, nil},
		["RavenCreek"] = {3000, 11100, 5400, 13500, SandboxVars.SDZones.RavenCreek, "Nested", nil},
		["EerieIrvington"] = {11161, 17788, 11700, 18299, SandboxVars.SDZones.EerieIrvington, nil, nil},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, SandboxVars.SDZones.EeriePowerPlant, nil, nil},
		["EerieCapitol"] = {8970, 16600, 9600, 17300, SandboxVars.SDZones.EerieCapitol, nil, nil},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, SandboxVars.SDZones.EerieMilitaryBase, nil, nil},
		["EerieCountry"] = {7200, 13500, 12300, 18300, SandboxVars.SDZones.EerieCountry, "Nested", nil},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, SandboxVars.SDZones.BigBearLakeWest, nil, nil},
		["BigBearLake"] = {4800, 6900, 6900, 8400, SandboxVars.SDZones.BigBearLake, "Nested", nil},
		["Chestown"] = {4500, 6600, 4800, 6900, SandboxVars.SDZones.Chestown, nil, nil},
		["LCBunker"] = {17400, 6300, 18300, 6900, SandboxVars.SDZones.LCBunker, nil, nil},
		["LCDowntown"] = {16800, 6300, 17400, 6900, SandboxVars.SDZones.LCDowntown, nil, nil},
		["LC"] = {15000, 6300, 18300, 8100, SandboxVars.SDZones.LC, "Nested", nil},
		["Taylorsville"] = {9000, 6300, 10220, 7200, SandboxVars.SDZones.Taylorsville, nil, nil},
		["Grapeseed"] = {7200, 11100, 7500, 11400, SandboxVars.SDZones.Grapeseed, nil, nil},
		["DirkerHard"] = {1500, 1800, 7658, 4807, SandboxVars.SDZones.DirkerHard, nil, "Toxic"},
		["DirkerMed"] = {7659, 1800, 10498, 4025, SandboxVars.SDZones.DirkerMed, nil, "Toxic"},
		["DirkerEasy"] = {7659, 4025, 10498, 5012, SandboxVars.SDZones.DirkerEasy, nil, "Toxic"},
		["OldStPaulo"] = {3350, 7610, 4800, 10450, SandboxVars.SDZones.OldStPaulo, nil, nil},
		["LVshipping"] = {12250, 4500, 12750, 4950, SandboxVars.SDZones.LVshipping, nil, nil},
		["LVairport"] = {12750, 4200, 13500, 4800, SandboxVars.SDZones.LVairport, nil, nil},
		["OaksdaleU"] = {12000, 11370, 12810, 12050, SandboxVars.SDZones.OaksdaleU, nil, nil},
		["Nettle"] = {6470, 8880, 7280, 9700, SandboxVars.SDZones.Nettle, nil, nil},
		["RosewoodX"] = {7970, 10820, 8790, 11410, SandboxVars.SDZones.RosewoodX, nil, nil},
	}
}

NestedZone = {
	list = {
		["InsidePetro"] = {10930, 12100, 11110, 12330, SandboxVars.SDZones.InsidePetro, nil, nil},
		["LouisvillePD"] = {12000, 1200, 12700, 1950, SandboxVars.SDZones.LouisvillePD, nil, nil},
		["LouisvilleMallArea"] = {12700, 1200, 15000, 1950, SandboxVars.SDZones.LouisvilleMallArea, nil, nil},
		["LCBunker"] = {17400, 6300, 18300, 6900, SandboxVars.SDZones.LCBunker, nil, nil},
		["LCDowntown"] = {16800, 6300, 17400, 6900, SandboxVars.SDZones.LCDowntown, nil, nil},
		["RavenCreekPDMilitaryHospital"] = {3000, 11100, 3670, 11950, SandboxVars.SDZones.RavenCreekPDMilitaryHospital, nil, nil},
		["RavenCreekEntrance"] = {3670, 11100, 4183, 11900, SandboxVars.SDZones.RavenCreekEntrance, nil, nil},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, SandboxVars.SDZones.EeriePowerPlant, nil, nil},
		["EerieCapitol"] = {8970, 16600, 9600, 17300, SandboxVars.SDZones.EerieCapitol, nil, nil},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, SandboxVars.SDZones.EerieMilitaryBase, nil, nil},
		["EerieIrvington"] = {11161, 17788, 11700, 18299, SandboxVars.SDZones.EerieIrvington, nil, nil},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, SandboxVars.SDZones.BigBearLakeWest, nil, nil},
	}
}

function getZoneNames(zonelist)
	local zoneNames = {}
	for zoneName, _ in pairs(zonelist) do
		table.insert(zoneNames, zoneName)
	end
	return zoneNames
end

ZoneNames = getZoneNames(Zone.list)
ZoneNo = #ZoneNames

NestedZoneNames = getZoneNames(NestedZone.list)
NestedZoneNo = #NestedZoneNames

--------------------------------------------------------------
--------------------------------------------------------------
local ZoneOverride = {}
if isServer() then return end
if ModData.exists("FactionControlledZones") then ModData.remove("FactionControlledZones") end
if ModData.exists("zonesData") then ModData.remove("zonesData") end

local controlledZones = {}

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
		local zonesGMD = ModData.getOrCreate("zonesData")
		zonesGMD = modData
	end
end
--Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData)

local function FactionControlledZones()
	ModData.request("FactionControlledZones")
	--ModData.request("zoneOverride")
end
--Events.OnInitGlobalModData.Add(FactionControlledZones)
--Events.EveryTenMinutes.Add(FactionControlledZones)

--------------------------------------------------------------
--------------------------------------------------------------

local function overrideZone(zone, override)
	local override = override or false
	if override then
		for i=1,#NestedZoneNames do
			if NestedZoneNames[i] == zone then
				for j=1, #ZoneOverride do
					if ZoneOverride[j] == zone then
						return true
					end
				end
			end
		end
	else
		for i=1,#ZoneNames do
			if ZoneNames[i] == zone then
				for j=1, #ZoneOverride do
					if ZoneOverride[j] == zone then
						return true
					end
				end
			end
		end
	end
end

local function updateZoneTier(zoneName, override)
	local zone = Zone.list[zoneName]
	override = override or nil
	if zone and override and zone[5] == 4 then
		zone[5] = 5 
	elseif zone and override and zone[5] == 5 then
		return
	elseif zone and SandboxVars.SDZones[zoneName] then
		zone[5] = SandboxVars.SDZones[zoneName]
	end
end

local function updateNestedZoneTier(nestedzoneName, override)
	local nestedzone = NestedZone.list[nestedzoneName]
	override = override or nil
	if nestedzone and override and nestedzone[5] == 4 then 
		nestedzone[5] = 5 
	elseif nestedzone and override and nestedzone[5] == 5 then
		return
	elseif nestedzone and not override and SandboxVars.SDZones[nestedzoneName] then
		nestedzone[5] = SandboxVars.SDZones[nestedzoneName]
	end
end

local function getControl(zone, player)
	local faction
	if Faction.getPlayerFaction(player) then 
		faction = Faction.getPlayerFaction(player):getName()
	else
		faction = nil
	end
	if not controlledZones[zone] or not faction then return nil end
	if controlledZones[zone] == faction then
		if isDebugEnabled() then player:Say("DEBUG: Controlled Zone: " .. zone .. " by Faction: " .. faction) end
		return "control"
	else
		return nil
	end
end

function checkZone(x,y)
	-- set local player parameters
	local player = getSpecificPlayer(0)
	-- check if player and coordinates are not nil
	local function coords(x,y)
		if not x or not y then
			if not player then return 10,10 end
			return player:getX(), player:getY()
		else
			return x, y
		end
	end

	local x, y = coords(x,y)
	
	--check if SD events is enabled, then check if player is in the coordinate for SD events. if not, then it does the rest of the zone check.
	if SandboxVars.SDevents.enabled then
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		local toxicevent = SandboxVars.SDevents.toxic or nil
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			return SandboxVars.SDevents.EventTier, "Event Zone", x, y, control, toxicevent
		end
	end
	
	-- iteratively check if player is in array and define zonetier based on zone, starting from the top of the list
	for i = 1, ZoneNo do
		local x1 = Zone.list[ZoneNames[i]][1]
		local y1 = Zone.list[ZoneNames[i]][2]
		local x2 = Zone.list[ZoneNames[i]][3]
		local y2 = Zone.list[ZoneNames[i]][4]
		-- check if player is inside rectangular zone boundary
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			-- check if its a tiered zone, if element 6 returns nil then it's not nested and returns the zone tier, otherwise it checks the NestedZone list
			-- check if its not nested first to avoid looping into the nested check if possible
			if not Zone.list[ZoneNames[i]][6] then 
				--print(ZoneNames[i])
				updateZoneTier(ZoneNames[i], overrideZone(ZoneNames[i]))
				local control = getControl(ZoneNames[i], player) or nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7]
			else
				for j = 1, NestedZoneNo do
					-- check if player is inside nested zone boundaries, redefine local parameters as something different
					local xx1 = NestedZone.list[NestedZoneNames[j]][1]
					local yy1 = NestedZone.list[NestedZoneNames[j]][2]
					local xx2 = NestedZone.list[NestedZoneNames[j]][3]
					local yy2 = NestedZone.list[NestedZoneNames[j]][4]
					if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
						updateNestedZoneTier(NestedZoneNames[j], overrideZone(NestedZoneNames[j], "Nested"))
						local control = getControl(NestedZoneNames[j], player) or nil
						return NestedZone.list[NestedZoneNames[j]][5], NestedZoneNames[j], x, y, control, NestedZone.list[NestedZoneNames[j]][7]
					end
				end
				--print(ZoneNames[i])
				updateZoneTier(ZoneNames[i], overrideZone(ZoneNames[i]), "Nested")
				local control = getControl(ZoneNames[i], player) or nil
				return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y, control, Zone.list[ZoneNames[i]][7]
			end
		end
	end
	return zonetier[1], "Unnamed Zone", x, y
end

function checkZoneAtXY(x, y)
	-- check if coordinates are not nil
	if x and y then
		
		--check if SD events is enabled, then check if player is in the coordinate for SD events. if not, then it does the rest of the zone check.
		if SandboxVars.SDevents.enabled then
			local x1 = SandboxVars.SDevents.Xcoord1
			local y1 = SandboxVars.SDevents.Ycoord1
			local x2 = SandboxVars.SDevents.Xcoord2
			local y2 = SandboxVars.SDevents.Ycoord2
			if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				return SandboxVars.SDevents.EventTier, "Event Zone", x, y
			end
		end
		
		-- iteratively check if player is in array and define zonetier based on zone, starting from the top of the list
		for i = 1, ZoneNo do
			local x1 = Zone.list[ZoneNames[i]][1]
			local y1 = Zone.list[ZoneNames[i]][2]
			local x2 = Zone.list[ZoneNames[i]][3]
			local y2 = Zone.list[ZoneNames[i]][4]
			-- check if player is inside rectangular zone boundary
			if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				-- check if its a tiered zone, if element 6 returns nil then it's not nested and returns the zone tier, otherwise it checks the NestedZone list
				-- check if its not nested first to avoid looping into the nested check if possible
				if not Zone.list[ZoneNames[i]][6] then 
					--print(ZoneNames[i])
					updateZoneTier(ZoneNames[i])
					return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y
				else
					for j = 1, NestedZoneNo do
						-- check if player is inside nested zone boundaries, redefine local parameters as something different
						local xx1 = NestedZone.list[NestedZoneNames[j]][1]
						local yy1 = NestedZone.list[NestedZoneNames[j]][2]
						local xx2 = NestedZone.list[NestedZoneNames[j]][3]
						local yy2 = NestedZone.list[NestedZoneNames[j]][4]
						if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
							updateNestedZoneTier(NestedZoneNames[j])
							return NestedZone.list[NestedZoneNames[j]][5], NestedZoneNames[j], x, y
						end
					end
					--print(ZoneNames[i])
					updateZoneTier(ZoneNames[i])
					return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y
				end
			end
		end
		return zonetier[1], "Unnamed Zone", x, y
	end
end