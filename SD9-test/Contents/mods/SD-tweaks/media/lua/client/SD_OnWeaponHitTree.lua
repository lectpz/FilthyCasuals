local abuseTable = {}

local function resetCounter()
	abuseTable = {}
end

local function OnWeaponHitTree(attacker, weapon)
	if weapon:getType() == "BareHands" then
		if not abuseTable[attacker] then abuseTable[attacker] = 0 end
		abuseTable[attacker] = abuseTable[attacker] + 1
		if abuseTable[attacker] >= 10 then
			
			attacker:setPrimaryHandItem(nil)
			attacker:setSecondaryHandItem(nil)
			attacker:getInventory():setDrawDirty(true)

		end
	end
end

Events.OnWeaponHitTree.Add(OnWeaponHitTree)
Events.EveryTenMinutes.Add(resetCounter)