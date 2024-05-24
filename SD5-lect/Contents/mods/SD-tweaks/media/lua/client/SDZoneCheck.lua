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
		["LouisvillePD"] = {12002, 1201, 12676, 1950, SandboxVars.SDZones.LouisvillePD},
		["LouisvilleMallArea"] = {12905, 1230, 13800, 1800, SandboxVars.SDZones.LouisvilleMallArea},
		["Louisville"] = {11700, 900, 15000, 6300, SandboxVars.SDZones.Louisville, "Nested"},
		["CC"] = {11100, 8700, 11400, 9300, SandboxVars.SDZones.CC},
		["Muldraugh"] = {9900, 8400, 12300, 11400, SandboxVars.SDZones.Muldraugh},
		["WestPoint"] = {10220, 6300, 12900, 7800, SandboxVars.SDZones.WestPoint},
		["Riverside"] = {5400, 5100, 7800, 6300, SandboxVars.SDZones.Riverside},	
		["Rosewood"] = {7500, 10800, 9300, 12600, SandboxVars.SDZones.Rosewood},	
		["MarchRidge"] = {9600, 12300, 10500, 13500, SandboxVars.SDZones.MarchRidge},	
		["Petroville"] = {10500, 11400, 11400, 13500, SandboxVars.SDZones.Petroville},	
		["LakeIvy"] = {8700, 9300, 9600, 10800, SandboxVars.SDZones.LakeIvy},	
		["FortRedstone"] = {5400, 11700, 6000, 12300, SandboxVars.SDZones.FortRedstone},	
		["ResearchFacility"] = {5400, 12300, 6000, 12900, SandboxVars.SDZones.ResearchFacility},	
		["RavenCreekPDMilitaryHospital"] = {3000, 11100, 3946, 11922, SandboxVars.SDZones.RavenCreekPDMilitaryHospital},
		["RavenCreek"] = {3000, 11100, 5400, 13500, SandboxVars.SDZones.RavenCreek, "Nested"},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, SandboxVars.SDZones.EeriePowerPlant},
		["EerieCapitol"] = {9000, 16800, 9600, 17225, SandboxVars.SDZones.EerieCapitol},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, SandboxVars.SDZones.EerieMilitaryBase},
		["EerieCountry"] = {7200, 13500, 12300, 18300, SandboxVars.SDZones.EerieCountry, "Nested"},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, SandboxVars.SDZones.BigBearLakeWest},
		["BigBearLake"] = {4800, 6900, 6900, 8400, SandboxVars.SDZones.BigBearLake, "Nested"},
		["Chestown"] = {4500, 6600, 4800, 6900, SandboxVars.SDZones.Chestown},
		["LCBunker"] = {17400, 6300, 18300, 6900, SandboxVars.SDZones.LCBunker},
		["LCDowntown"] = {16800, 6300, 17400, 6900, SandboxVars.SDZones.LCDowntown},
		["LC"] = {15000, 6300, 18300, 8100, SandboxVars.SDZones.LC, "Nested"},
		["SaintPaulosHammer"] = {3601, 9001, 5099, 10799, SandboxVars.SDZones.SaintPaulosHammer},
		["Greenport"] = {8101, 7201, 8700, 7800, SandboxVars.SDZones.Greenport},
		["Taylorsville"] = {9001, 6301, 10220, 7200, SandboxVars.SDZones.Taylorsville},
		["Grapeseed"] = {7200, 11100, 7500, 11400, SandboxVars.SDZones.Grapeseed}
	}
}

--[[
Zone = {
	list = {
		["LouisvillePD"] = {12002, 1201, 12676, 1863, zonetier[4]},
		["LouisvilleMallArea"] = {12905, 1230, 13800, 1800, zonetier[4]},
		["Louisville"] = {11700, 900, 15000, 6600, zonetier[3]},
		["CC"] = {11100, 8700, 11400, 9300, zonetier[1]},
		["Muldraugh"] = {9900, 8400, 12300, 11400, zonetier[1]},
		["WestPoint"] = {9900, 6300, 12900, 7800, zonetier[2]},
		["Riverside"] = {5400, 5100, 7800, 6300, zonetier[1]},	
		["Rosewood"] = {7500, 10800, 9300, 12600, zonetier[1]},	
		["MarchRidge"] = {9600, 12300, 10500, 13500, zonetier[1]},	
		["Petroville"] = {10500, 11400, 11400, 13500, zonetier[4]},	
		["LakeIvy"] = {8700, 9300, 9600, 10800, zonetier[1]},	
		["FortRedstone"] = {5400, 11700, 6000, 12300, zonetier[2]},	
		["ResearchFacility"] = {5400, 12300, 6000, 12900, zonetier[2]},	
		["RavenCreekPDMilitaryHospital"] = {3000, 11100, 3946, 11922, zonetier[4]},
		["RavenCreek"] = {3000, 11100, 5400, 13500, zonetier[3]},
		["EeriePowerPlant"] = {10277, 14731, 10588, 14997, zonetier[4]},
		["EerieMilitaryBase"] = {8102, 17165, 8501, 17513, zonetier[4]},
		["EerieCountry"] = {7200, 13500, 12300, 18300, zonetier[2]},
		["BigBearLake"] = {4800, 6900, 6900, 8400, zonetier[2]},
		["Chestown"] = {4500, 6600, 4800, 6900, zonetier[2]},
		["LCBunker"] = {17700, 6300, 18300, 6900, zonetier[4]},
		["LCDowntown"] = {17100, 6300, 17700, 6900, zonetier[3]},
		["LC"] = {15000, 6300, 18300, 8100, zonetier[2]},
		--["Dirker1"] = {1500, 1800, 3000, 3300, zonetier[2]},
		--["Dirker2"] = {3000, 1800, 7500, 6900, zonetier[2]},
		--["Dirker3"] = {7500, 1800, 9300, 6900, zonetier[2]},
		--["Dirker4"] = {9300, 2400, 10500, 6300, zonetier[2]},
		["SaintPaulosHammer"] = {3601, 9001, 5099, 10799, zonetier[3]},
		["Greenport"] = {8101, 7201, 8700, 7800, zonetier[2]},
		["Taylorsville"] = {9001, 6301, 10220, 7200, zonetier[2]},
		["Grapeseed"] = {7200, 11100, 7500, 11400, zonetier[2]}
	}
}]]

NestedZone = {
	list = {
		["LouisvillePD"] = {12002, 1201, 12676, 1950, SandboxVars.SDZones.LouisvillePD},
		["LouisvilleMallArea"] = {12905, 1230, 13800, 1800, SandboxVars.SDZones.LouisvilleMallArea},
		["LCBunker"] = {17400, 6300, 18300, 6900, SandboxVars.SDZones.LCBunker},
		["LCDowntown"] = {16800, 6300, 17400, 6900, SandboxVars.SDZones.LCDowntown},
		["RavenCreekPDMilitaryHospital"] = {3000, 11100, 3946, 11922, SandboxVars.SDZones.RavenCreekPDMilitaryHospital},
		["EeriePowerPlant"] = {9900, 13879, 10966, 15292, SandboxVars.SDZones.EeriePowerPlant},
		["EerieCapitol"] = {9000, 16800, 9600, 17225, SandboxVars.SDZones.EerieCapitol},
		["EerieMilitaryBase"] = {8101, 17063, 8527, 17610, SandboxVars.SDZones.EerieMilitaryBase},
		["BigBearLakeWest"] = {5000, 7800, 5700, 8200, SandboxVars.SDZones.BigBearLakeWest}
	}
}

-- get the zone names from the zone.list and turn it into an array for easy reference
function getZoneNames(zonelist)
	local zoneNames = {}
	for zoneName, _ in pairs(zonelist) do
		table.insert(zoneNames, zoneName)
	end
	return zoneNames
end

-- define zonename array and # of array values
ZoneNames = getZoneNames(Zone.list)
ZoneNo = #ZoneNames

NestedZoneNames = getZoneNames(NestedZone.list)
NestedZoneNo = #NestedZoneNames

--update sandbox variables for a specific zonename
--note that SD Dynamic Zombies locally stores the Zone.list coordinates on initial login, keep tiering system separate and do not call in the SD Dynamics Code
function updateZoneTier(zoneName)
    local zone = Zone.list[zoneName]
    if zone and SandboxVars.SDZones[zoneName] then
        zone[5] = SandboxVars.SDZones[zoneName]
    end
end

function updateNestedZoneTier(nestedzoneName)
    local nestedzone = NestedZone.list[nestedzoneName]
    if nestedzone and SandboxVars.SDZones[nestedzoneName] then
        nestedzone[5] = SandboxVars.SDZones[nestedzoneName]
    end
end

-- check zone function. check town zones first, then check nested zones if element 6 in arraytable is not nil.
-- check zones first, if the return zone is not tagged nested, it won't trigger a nested check. this is to avoid checking nested areas for non-nested zones.
function checkZone()
	-- set local player parameters
	local player = getSpecificPlayer(0)
	-- check if player and coordinates are not nil
	if player ~= nil then
		local x = player:getX()
		local y = player:getY()
		
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
	else
		-- if the check doesn't match any of the zones or if player is nil, it just defaults to zonetier[1] and sets x = 11250 and y = 9000 to avoid errors (CC coordinates)
		local x = 11250
		local y = 9000
		return zonetier[1], "Twilight Zone", x, y
	end
end