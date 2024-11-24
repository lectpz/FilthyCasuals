local function OnWeaponHitThumpable(playerObj, handWeapon, object)
	if handWeapon:getType() == "BareHands" then
		if instanceof(object, "IsoDoor") or instanceof(object, "IsoWindow") then
			print("[sdLogger] Player [" .. playerObj:getUsername() .. "] is shoving a door/window at: " .. playerObj:getX() .. "," .. playerObj:getY() .. "," .. playerObj:getZ())
		end
	end
end

Events.OnWeaponHitThumpable.Add(OnWeaponHitThumpable)