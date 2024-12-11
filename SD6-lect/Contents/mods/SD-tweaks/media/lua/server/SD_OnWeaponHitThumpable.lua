local abuseTable = {}

local function resetCounter()
	abuseTable = {}
end

local function OnWeaponHitThumpable(playerObj, handWeapon, object)
	if handWeapon:getType() == "BareHands" then
		if instanceof(object, "IsoDoor") or instanceof(object, "IsoWindow") then
			if not abuseTable[playerObj] then abuseTable[playerObj] = 0 end
			abuseTable[playerObj] = abuseTable[playerObj] + 1
			if abuseTable[playerObj] >= 10 then
				local args = { }
				args.player_username = playerObj:getUsername()
				local online_players = getOnlinePlayers();
				for i = 0, online_players:size() - 1 do
					local player = online_players:get(i);
					local username = player:getUsername()
					if username == args.player_username then
						print("[sdLogger] Player [" .. args.player_username .. "] caught shoving a door/window " .. abuseTable[playerObj] .. "times at: " .. playerObj:getX() .. "," .. playerObj:getY() .. "," .. playerObj:getZ())
						sendServerCommand(player, 'SDthings', 'OnWeaponHitThumpable', args);
						abuseTable[playerObj] = 0
						break
					end
				end
				print("[sdLogger] Player [" .. args.player_username .. "] has had their weapon unequipped.")
			end
		end
	end
end

Events.OnWeaponHitThumpable.Add(OnWeaponHitThumpable)
Events.EveryTenMinutes.Add(resetCounter)