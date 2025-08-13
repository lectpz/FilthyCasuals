local o_upgradewpn = ISUpgradeWeapon.perform
function ISUpgradeWeapon:perform()
	local wMD = self.weapon:getModData()
	
	local attachedDmg = self.part:getDamage()
	local attachedAim = self.part:getAimingTime()
	local attachedRecoil = self.part:getRecoilDelay()
	local attachedReload = self.part:getReloadTime()
	
	--[[print(attachedDmg)
	print(attachedAim)
	print(attachedRecoil)
	print(attachedReload)]]
	
	if not wMD.attachedDmg then wMD.attachedDmg = 0 end
	if not wMD.attachedAim then wMD.attachedAim = 0 end
	if not wMD.attachedRecoil then wMD.attachedRecoil = 0 end
	if not wMD.attachedReload then wMD.attachedReload = 0 end
	
	if attachedDmg then wMD.attachedDmg = wMD.attachedDmg + attachedDmg end
	if attachedAim then wMD.attachedAim = wMD.attachedAim + attachedAim end
	if attachedRecoil then wMD.attachedRecoil = wMD.attachedRecoil + attachedRecoil end
	if attachedReload then wMD.attachedReload = wMD.attachedReload + attachedReload end
	
	--[[print(wMD.attachedDmg)
	print(wMD.attachedAim)
	print(wMD.attachedRecoil)
	print(wMD.attachedReload)]]
	
	o_upgradewpn(self)
end

local o_removeupgradewpn = ISRemoveWeaponUpgrade.perform
function ISRemoveWeaponUpgrade:perform()
	local wMD = self.weapon:getModData()
	
	local attachedDmg = self.part:getDamage()
	local attachedAim = self.part:getAimingTime()
	local attachedRecoil = self.part:getRecoilDelay()
	local attachedReload = self.part:getReloadTime()
	
	--[[print(attachedDmg)
	print(attachedAim)
	print(attachedRecoil)
	print(attachedReload)]]
	
	--compatibility for weapons that spawn with an attachment
	if attachedDmg and not wMD.attachedDmg then wMD.attachedDmg = attachedDmg end
	if attachedAim and not wMD.attachedAim then wMD.attachedAim = attachedAim end
	if attachedRecoil and not wMD.attachedRecoil then wMD.attachedRecoil = attachedRecoil end
	if attachedReload and not wMD.attachedReload then wMD.attachedReload = attachedReload end
	
	if attachedDmg then wMD.attachedDmg = wMD.attachedDmg - attachedDmg end
	if attachedAim then wMD.attachedAim = wMD.attachedAim - attachedAim end
	if attachedRecoil then wMD.attachedRecoil = wMD.attachedRecoil - attachedRecoil end
	if attachedReload then wMD.attachedReload = wMD.attachedReload - attachedReload end
	
	--[[print(wMD.attachedDmg)
	print(wMD.attachedAim)
	print(wMD.attachedRecoil)
	print(wMD.attachedReload)]]
	
	o_removeupgradewpn(self)
end