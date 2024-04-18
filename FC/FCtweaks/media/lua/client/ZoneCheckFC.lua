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
--		["Riverside"] = {5015, 5263, 7503, 6550, zonetier[1]},
--		["Rosewood"] = {7422, 11213, 8581, 12326, zonetier[1]},
--		["Muldraugh"] = {9963, 9206, 11062, 10633, zonetier[1]},
--		["Westpoint"] = {10821, 6577, 12358, 7214, zonetier[1]},
--		["Lake Ivy"] = {8700, 9600, 9600, 10500, zonetier[1]},
--		["Ekron"] = {7050, 8150, 7500, 8575, zonetier[1]},
		["Southwood"] = {3583, 5698, 4511, 6600, zonetier[2]},
		["Leavenburg"] = {5567, 3937, 6352, 4444, zonetier[2]},
		["Wilbore"] = {4500, 9900, 5097, 10222, zonetier[2]},
		["Grapeseed"] = {7200, 11000, 7500, 11400, zonetier[2]},
		["Greenport"] = {8100, 7458, 8700, 7800, zonetier[2]},
		["Nettle Township"] = {6600, 9000, 7200, 9600, zonetier[2]},
		["Chinatown"] = {10800, 8400, 11400, 9300, zonetier[2]},
		["Old Pine Village"] = {10200, 12900, 10800, 14700, zonetier[2]},
		["Raven Creek South"] = {3000, 12000, 4200, 13490, zonetier[2]},
		["Louisville International Airport"] = {12870, 4204, 13464, 4798, zonetier[2]},
		["Louisville South"] = {11701, 3201, 14999, 4226, zonetier[2]},
		["Louisville North"] = {11701, 904, 14999, 3200, zonetier[3], "Nested"},
		["Raven Creek North"] = {3000, 11100, 4200, 11999, zonetier[3], "Nested"},
		["Trelai"] = {6600, 6600, 7800, 7800, zonetier[3], "Nested"},
		["Lake Cumberland"] = {15300, 6300, 18000, 8100, zonetier[2], "Nested"},
	}
}

NestedZone = {
	list = {
		["Louisville Main PD / Pawnshops"] = {12292, 1345, 12614, 1807, zonetier[4], "Nested"},
		["Louisville Mall Area"] = {12905, 1230, 13800, 1800, zonetier[4], "Nested"},
		["Lake Cumberland Bunker"] = {17100, 6301, 17999, 6900, zonetier[4], "Nested"},
		["Lake Cumberland Downtown"] = {16500, 6300, 18000, 7500, zonetier[3], "Nested"},
		["Raven Creek Main PD / Military Hospital"] = {3514, 11355, 3946, 11922, zonetier[4], "Nested"},
		["Trelai Prison"] = {6620, 7200, 7000, 7770, zonetier[4], "Nested"},
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
		local x = 5000
		local y = 5000
	end
	-- move this outside the checks so that it returns t1 zone if player is nil or if you're not in the rectangular boundary zones of any defined towns
	return zonetier[1]
end