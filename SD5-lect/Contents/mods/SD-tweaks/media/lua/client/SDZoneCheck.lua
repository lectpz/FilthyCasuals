----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

-- define zones (towns/maps)
zonetier = {1, 2, 3, 4}
zonetierno = #zonetier

-- zone input, overall zones are on top, nested zones are on bottom
Zone = {
	list = {
		["Louisville"] = {11700, 900, 15000, 6600, zonetier[3], "Nested"},
		--["CC"] = {11100, 8700, 11400, 9300, zonetier[1]},
		--["Muldraugh"] = {9900, 8400, 12300, 11400, zonetier[1]},
		["WestPoint"] = {9900, 6300, 12900, 7800, zonetier[2]},
		--["Riverside"] = {5400, 5100, 7800, 6300, zonetier[1]},	
		--["Rosewood"] = {7500, 10800, 9300, 12600, zonetier[1]},	
		--["MarchRidge"] = {9600, 12300, 10500, 13500, zonetier[1]},	
		["Petroville"] = {10500, 11400, 11400, 13500, zonetier[4]},	
		--["LakeIvy"] = {8700, 9300, 9600, 10800, zonetier[1]},	
		["FortRedstone"] = {5400, 11700, 6000, 12300, zonetier[2]},	
		["ResearchFacility"] = {5400, 12300, 6000, 12900, zonetier[2]},	
		["RavenCreek"] = {3000, 11100, 6000, 13500, zonetier[3], "Nested"},	
		["EerieCountry"] = {7200, 13500, 12300, 18300, zonetier[2]},
		["BigBearLake"] = {4800, 6900, 6900, 8400, zonetier[2]},
		["Chestown"] = {4500, 6600, 4800, 6900, zonetier[2]},
		["LC"] = {15000, 6300, 18300, 8100, zonetier[2], "Nested"},
		--["Dirker1"] = {1500, 1800, 3000, 3300, zonetier[2]},
		--["Dirker2"] = {3000, 1800, 7500, 6900, zonetier[2]},
		--["Dirker3"] = {7500, 1800, 9300, 6900, zonetier[2]},
		--["Dirker4"] = {9300, 2400, 10500, 6300, zonetier[2]},
		["Saint Paulo Hammer"] = {3601, 9001, 5099, 10799, zonetier[3]},
		["Greenport"] = {8101, 7201, 8700, 7800, zonetier[2]},
		["Taylorsville"] = {9001, 6301, 10220, 7200, zonetier[2]},
	}
}

NestedZone = {
	list = {
		["Louisville Main PD / Pawnshops"] = {12002, 1201, 12676, 1863, zonetier[4], "Nested"},
		["Louisville Mall Area"] = {12905, 1230, 13800, 1800, zonetier[4], "Nested"},
		["LCBunker"] = {17700, 6300, 18300, 6900, zonetier[4], "Nested"},
		["LCDowntown"] = {17100, 6300, 17700, 6900, zonetier[3], "Nested"},
		["Raven Creek Main PD / Military Hospital"] = {3000, 11100, 3946, 11922, zonetier[4], "Nested"},
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


-- check zone function. check town zones first, then check nested zones if element 6 in arraytable is not nil.
-- check zones first, if the return zone is not tagged nested, it won't trigger a nested check. this is to avoid checking nested areas for non-nested zones.
function checkZone()
	-- set local player parameters
	local player = getPlayer()
	-- check if player and coordinates are not nil
	if player ~= nil then
		local x = player:getX()
		local y = player:getY()
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
					return Zone.list[ZoneNames[i]][5] 
				else
					for j = 1, NestedZoneNo do
						-- check if player is inside nested zone boundaries, redefine local parameters as something different
						local xx1 = NestedZone.list[NestedZoneNames[j]][1]
						local yy1 = NestedZone.list[NestedZoneNames[j]][2]
						local xx2 = NestedZone.list[NestedZoneNames[j]][3]
						local yy2 = NestedZone.list[NestedZoneNames[j]][4]
						if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
							return NestedZone.list[NestedZoneNames[j]][5] 
						end
					end
					--print(ZoneNames[i])
					return Zone.list[ZoneNames[i]][5] 
				end
			end
		end
	else
		-- if the check doesn't match any of the zones or if player is nil, it just defaults to zonetier[1] and sets x = 5000 and y = 5000 to avoid errors
		local x = 11250
		local y = 9000
	end
	-- move this outside the checks so that it returns t1 zone if player is nil or if you're not in the rectangular boundary zones of any defined towns
	return zonetier[1]
end