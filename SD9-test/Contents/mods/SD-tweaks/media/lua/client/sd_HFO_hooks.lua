local function sdCopyModData(weaponModData, rMD)
	for k,v in pairs(weaponModData) do
		if k == "mdzMaxDmg" 
		or k == "mdzMinDmg"
		or k == "mdzCriticalChance"
		or k == "mdzCritDmgMultiplier"
		or k == "mdzAimingTime"
		or k == "mdzRecoilDelay"
		or k == "mdzReloadTime"
		or k == "mdzPrefix"
		or k == "soulForgeAmmoPerShoot"
		or k == "soulForgeAimingPerkCritModifier"
		or k == "soulForgeAimingPerkHitChanceModifier"
		or k == "soulForgeAimingPerkRangeModifier"
		or k == "soulForgeAimingTime"
		or k == "soulForgeProjectileCount"
		or k == "MaxHitCount"
		or k == "isPiercingBullets"
		or k == "soulForgeMinDmgMulti"
		or k == "soulForgeMaxDmgMulti"
		or k == "soulForgeCritRate"
		or k == "soulForgeCritMulti"
		or k == "CriticalChance"
		or k == "CritDmgMultiplier"
		or k == "ReloadTime"
		or k == "RecoilDelay"
		or k == "EngravedName"
		or k == "KillCount"
		or k == "SoulForged"
		or k == "SoulWrought"
		or k == "Augments"
		or k == "PlayerKills"
		or k == "p1_desc"
		or k == "p2_desc"
		or k == "s1_desc"
		or k == "s2_desc"
		or k == "Tier"
		or k == "Name"
		or k == "prefix1"
		or k == "prefix2"
		or k == "suffix1"
		or k == "suffix2"
		or k == "AimingPerkHitChanceModifier"
		or k == "AimingPerkCritModifier"
		or k == "AimingPerkRangeModifier"
		or k == "AimingTime"
		then
			rMD[k] = v
			--print(k,v)
		end
	end
end
	
local function sdSetModData(inventoryItem, weaponModData)
	local mdzMaxDmg = weaponModData.mdzMaxDmg or 1
	local mdzMinDmg = weaponModData.mdzMinDmg or 1
	local mdzAimingTime = weaponModData.mdzAimingTime or 1
	local mdzReloadTime = weaponModData.mdzReloadTime or 1
	local mdzRecoilDelay = weaponModData.mdzRecoilDelay or 1
	local mdzCriticalChance = weaponModData.mdzCriticalChance or 1
	local mdzCritDmgMultiplier = weaponModData.mdzCritDmgMultiplier or 1
	
	local soulForgeAmmoPerShoot = weaponModData.soulForgeAmmoPerShoot or 1
	local soulForgeAimingPerkCritModifier = weaponModData.soulForgeAimingPerkCritModifier or 1
	local soulForgeAimingPerkHitChanceModifier = weaponModData.soulForgeAimingPerkHitChanceModifier or 1
	local soulForgeAimingPerkRangeModifier = weaponModData.soulForgeAimingPerkRangeModifier or 1
	local soulForgeAimingTime = weaponModData.soulForgeAimingTime or 1
	local soulForgeProjectileCount = weaponModData.soulForgeProjectileCount or 1
	local isPiercingBullets = weaponModData.isPiercingBullets or false
	
	if isPiercingBullets then
		inventoryItem:setPiercingBullets(true)
	else
		inventoryItem:setProjectileCount(soulForgeProjectileCount)
	end
	
	local soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti or 1
	local soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti or 1
	local soulForgeCritRate = weaponModData.soulForgeCritRate or 1
	local soulForgeCritMulti = weaponModData.soulForgeCritMulti or 1
	
	if weaponModData.CriticalChance then inventoryItem:setCriticalChance(weaponModData.CriticalChance * soulForgeCritRate * mdzCriticalChance) end
	if weaponModData.CritDmgMultiplier then inventoryItem:setCritDmgMultiplier(weaponModData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier) end
	if weaponModData.MinDamage then inventoryItem:setMinDamage(weaponModData.MinDamage * soulForgeMinDmgMulti * mdzMinDmg) end
	if weaponModData.MaxDamage then inventoryItem:setMaxDamage(weaponModData.MaxDamage * soulForgeMaxDmgMulti * mdzMaxDmg) end
	if weaponModData.ReloadTime then inventoryItem:setReloadTime(weaponModData.ReloadTime * mdzReloadTime) end
	if weaponModData.RecoilDelay then inventoryItem:setRecoilDelay(weaponModData.RecoilDelay * mdzRecoilDelay) end
	
	inventoryItem:setAimingTime(weaponModData.AimingTime * mdzAimingTime * soulForgeAimingTime)
	inventoryItem:setAimingPerkHitChanceModifier(weaponModData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier)
	inventoryItem:setAimingPerkCritModifier(weaponModData.AimingPerkCritModifier * soulForgeAimingPerkCritModifier)
	inventoryItem:setAimingPerkRangeModifier(weaponModData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier)
	
	local engravedName = weaponModData.EngravedName
	if engravedName then 
		inventoryItem:setName(engravedName)
	else
		local mdzPrefix = ""
		local soulWrought = weaponModData.SoulWrought or ""
		if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
		inventoryItem:setName(mdzPrefix .. soulWrought .. weaponModData.Name)
	end
end

--ongamestart, wrap HFO functions (ongamestart so it always fires after HFO is loaded)
Events.OnGameStart.Add(	function()
							local ISAmmoSwapAction_perform = ISAmmoSwapAction.perform
							function ISAmmoSwapAction:perform()
								local weaponModData = self.weapon:getModData()
								local muleTable = {}
								sdCopyModData(weaponModData, muleTable)--mule old weapon modData to mule table
								
								ISAmmoSwapAction_perform(self)--run original function, which will delete the old weapon and create self.result (new weapon)
								
								local inventoryItem = self.result
								local rMD = inventoryItem:getModData()
								
								sdCopyModData(muleTable, rMD)--move weapon modData from mule table over to result item
								sdSetModData(inventoryItem, muleTable)
							end

							local ISMagSwapAction_perform = ISMagSwapAction.perform
							function ISMagSwapAction:perform()
								local weaponModData = self.weapon:getModData()
								local muleTable = {}
								sdCopyModData(weaponModData, muleTable)--mule old weapon modData to mule table
								
								ISMagSwapAction_perform(self)--run original function, which will delete the old weapon and create self.result (new weapon)
								
								local inventoryItem = self.result
								local rMD = inventoryItem:getModData()
								
								sdCopyModData(muleTable, rMD)--move weapon modData from mule table over to result item
								sdSetModData(inventoryItem, muleTable)
							end
						end)