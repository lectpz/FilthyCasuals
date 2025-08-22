local abuseTable = {}

local function resetCounter()
	abuseTable = {}
end

local function OnWeaponHitThumpable(playerObj, handWeapon, object)
	local weapon = handWeapon:getType()
	if not weapon then return end
	if weapon == "BareHands" then
		if instanceof(object, "IsoDoor") or instanceof(object, "IsoWindow") or instanceof(object, "IsoBarricade") then
			if not abuseTable[playerObj] then abuseTable[playerObj] = 0 end
			abuseTable[playerObj] = abuseTable[playerObj] + 1
			if abuseTable[playerObj] >= 10 then
				local args = { }
				args.player_username = playerObj:getUsername()

				print("[sdLogger] Player [" .. args.player_username .. "] caught shoving a door/window " .. abuseTable[playerObj] .. "times at: " .. playerObj:getX() .. "," .. playerObj:getY() .. "," .. playerObj:getZ())
				sendServerCommand(playerObj, 'SDthings', 'OnWeaponHitThumpable', args);
				abuseTable[playerObj] = 0

				print("[sdLogger] Player [" .. args.player_username .. "] has had their weapon unequipped.")
			end
		end
	end
end

Events.OnWeaponHitThumpable.Add(OnWeaponHitThumpable)
Events.EveryTenMinutes.Add(resetCounter)