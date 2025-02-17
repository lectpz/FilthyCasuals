local ISFirearmRadialMenu_getWeapon = ISFirearmRadialMenu.getWeapon
function ISFirearmRadialMenu:getWeapon()
	local weapon = self.character:getPrimaryHandItem()
	if weapon and instanceof(weapon, "HandWeapon") and (weapon:isAimedFirearm() or weapon:isRanged()) then
		local wMD = weapon:getModData()
		wMD.MeleeSwap = nil
		return weapon
	end
	ISFirearmRadialMenu_getWeapon(self)
end

local function noMeleeInit(player)
	Events.OnPlayerUpdate.Remove(noMeleeInit)
	local weapon = player:getPrimaryHandItem()
	if weapon and instanceof(weapon, "HandWeapon") and (weapon:isAimedFirearm() or weapon:isRanged()) then
		local wMD = weapon:getModData()
		wMD.MeleeSwap = nil
		return weapon
	end
end
Events.OnPlayerUpdate.Add(noMeleeInit)