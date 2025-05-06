----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

local function initMeleeStats(modData, inventoryItem, character)
	if	modData.CriticalChance		== nil and
		modData.CritDmgMultiplier	== nil and
		modData.MinDamage			== nil and
		modData.MaxDamage			== nil and
		modData.MaxHitCount			== nil and
		modData.Name				== nil then
		
		local newItem = InventoryItemFactory.CreateItem(inventoryItem:getFullType())
		
		modData.CriticalChance		= newItem:getCriticalChance()
		modData.CritDmgMultiplier	= newItem:getCritDmgMultiplier()
		modData.MinDamage			= newItem:getMinDamage()
		modData.MaxDamage			= newItem:getMaxDamage()
		modData.MaxHitCount			= newItem:getMaxHitCount()
		modData.Name				= character:getPrimaryHandItem():getName()
		modData.SD7_1				= true
	elseif not modData.SD7_1 then
		scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())

		inventoryItem:setMaxRange(scriptItem:getMaxRange())
		
		modData.MinDamage 			= scriptItem:getMinDamage()
		modData.MaxDamage 			= scriptItem:getMaxDamage()
		modData.SD7_1 				= true
	end
end

local function initRangedStats(modData, inventoryItem, character)
	if 	modData.AimingPerkHitChanceModifier == nil and
		modData.AimingPerkCritModifier 		== nil and
		modData.AimingPerkRangeModifier 	== nil and
		modData.AimingTime 					== nil and
		modData.ReloadTime 					== nil and
		modData.RecoilDelay					== nil and
		modData.Name						== nil and
		modData.CriticalChance				== nil and
		modData.CritDmgMultiplier			== nil and
		modData.MinDamage					== nil and
		modData.MaxDamage					== nil and
		modData.MaxHitCount					== nil then
		
		local newItem = InventoryItemFactory.CreateItem(inventoryItem:getFullType())
		
		modData.CriticalChance				= newItem:getCriticalChance()
		modData.CritDmgMultiplier			= newItem:getCritDmgMultiplier()
		modData.MinDamage					= newItem:getMinDamage()
		modData.MaxDamage					= newItem:getMaxDamage()
		modData.AimingPerkHitChanceModifier = newItem:getAimingPerkHitChanceModifier()
		modData.AimingPerkCritModifier 		= newItem:getAimingPerkCritModifier()
		modData.AimingPerkRangeModifier 	= newItem:getAimingPerkRangeModifier()
		modData.AimingTime					= newItem:getAimingTime()
		modData.ReloadTime					= newItem:getReloadTime()
		modData.RecoilDelay					= newItem:getRecoilDelay()
		modData.Name						= character:getPrimaryHandItem():getName()
		modData.SD7_1						= true
	elseif not modData.SD7_1 then
		modData.MinDamage					= inventoryItem:getScriptItem():getMinDamage()
		modData.MaxDamage					= inventoryItem:getScriptItem():getMaxDamage()
		modData.SD7_1 						= true
	end
	modData.MeleeSwap = nil
end

local function SDOnWeaponSwing(character, handWeapon)
	if character:getPrimaryHandItem() == nil then return end
	if character ~= getSpecificPlayer(0) then return end
	
	local tierzone = checkZone()
	
	local tiercritratemod	= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier2critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier3critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier4critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier5critrate)}
	local tiercritmultimod	= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier2critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier3critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier4critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier4critmulti)}
	local tierdmgmod		= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier2dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier3dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier4dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier5dmg)}
	
	local localdmgmulti, localcritrate, localcritmulti = tierdmgmod[tierzone], tiercritratemod[tierzone], tiercritmultimod[tierzone]
	
	local inventoryItem = handWeapon
	local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
	local modData = inventoryItem:getModData()
	
	if tierzone and not handWeapon:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
		local basecritrate, basecritmulti, basemindmg, basemaxdmg, basename = modData.CriticalChance, modData.CritDmgMultiplier, modData.MinDamage, modData.MaxDamage, modData.Name
		
		local isHardmode = modData.HardcoreMode or nil
		local modeMultiplier = 1.0
		
		if isHardmode then modeMultiplier = 0.5 end
		
		local isSoulForged = modData.SoulForged or false
		local hasSouls = modData.KillCount or false
		local augmentMulti = modData.Augments or 0
		local addMaxDmg, addCritChance, addCritMulti = 0, 0, 0
		local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		if isSoulForged and hasSouls then
			local weaponMaxCond = inventoryItem:getConditionMax()
			local weaponCondLowerChance = inventoryItem:getConditionLowerChance()
			local soulsRequired = weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage()
			local soulsFreed = modData.KillCount or nil
			local soulPower = math.min(soulsFreed / soulsRequired, 1)
			addMaxDmg = soulPower * 1 * augmentMulti/4
			addCritChance = soulPower * 5 * augmentMulti/4
			addCritMulti = soulPower * 0.5 * augmentMulti/4
		end
		
		local localdmgmulti, localcritrate, localcritmulti = (tierdmgmod[tierzone] * modeMultiplier), (tiercritratemod[tierzone] * modeMultiplier), (tiercritmultimod[tierzone] * modeMultiplier)
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or 1
		local soulForgeEnduranceMod = modData.EnduranceMod or 1
		local soulForgeMaxCondition = modData.MaxCondition or 1
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		local soulWrought = modData.SoulWrought or ""
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		local pMD = character:getModData()
		local permaCritRate = pMD.PermaSoulForgeCritRateBonus 
		local permaCritMulti = pMD.PermaSoulForgeCritMultiBonus
		local permaMaxDmg = pMD.PermaSoulForgeMaxDmgBonus
		local permaMaxCondition = pMD.PermaMaxConditionBonus
		local permaConditionLowerChance = pMD.PermaSoulForgeConditionBonus
		
		if permaCritRate and permaCritRate > 1 then soulForgeCritRate = soulForgeCritRate * permaCritRate end
		if permaCritMulti and permaCritMulti > 1 then soulForgeCritMulti = soulForgeCritMulti * permaCritMulti end
		if permaMaxDmg and permaMaxDmg > 1 then soulForgeMaxDmgMulti = soulForgeMaxDmgMulti * permaMaxDmg end
		if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
		if soulForgeConditionLowerChance and permaConditionLowerChance and permaConditionLowerChance > 1 then soulForgeConditionLowerChance = soulForgeConditionLowerChance * permaConditionLowerChance end
		
		local engravedName = modData.EngravedName
		
		inventoryItem:setCriticalChance(((basecritrate + addCritChance) * localcritrate) * modeMultiplier * soulForgeCritRate * mdzCriticalChance)
		inventoryItem:setCritDmgMultiplier(((basecritmulti + addCritMulti) * localcritmulti) * modeMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier)
		inventoryItem:setMinDamage((basemindmg * localdmgmulti) * modeMultiplier * soulForgeMinDmgMulti * mdzMinDmg)
		inventoryItem:setMaxDamage(((basemaxdmg + addMaxDmg) * localdmgmulti) * modeMultiplier * soulForgeMaxDmgMulti * mdzMaxDmg)
		
		if engravedName then
			inventoryItem:setName(engravedName .. " [T" .. tostring(tierzone) .. "]")
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			inventoryItem:setName(soulWrought.. mdzPrefix .. basename .. " [T" .. tostring(tierzone) .. "]")
		end

		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition) end
		
		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			if inventoryItem:getSwingAnim() == "Heavy" then mhc = soulForgeMaxHitCount end
			if mhc ~= inventoryItem:getMaxHitCount() then inventoryItem:setMaxHitCount(mhc) end
		end
		if soulForgeEnduranceMod then inventoryItem:setEnduranceMod(soulForgeEnduranceMod) end
	elseif tierzone and handWeapon:isRanged() and handWeapon:getSwingAnim() ~= "Handgun" then
		initRangedStats(modData, inventoryItem, character)
		local rangedmulti = 1.0
		
		if character:HasTrait("Brave")			then rangedmulti = rangedmulti - 0.1 end
		if character:HasTrait("Desensitized")	then rangedmulti = rangedmulti - 0.2 end
		if character:HasTrait("Cowardly")		then rangedmulti = rangedmulti + 0.1 end
		if character:HasTrait("EagleEyed")		then rangedmulti = rangedmulti - 0.1 end
		if character:HasTrait("ShortSighted")	then rangedmulti = rangedmulti + 0.05 end
		
		rangedmulti = rangedmulti - character:getPerkLevel(Perks.Aiming)/14.28571429
		
		--if character:isSeatedInVehicle() then rangedmulti = 2.0 end
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzAimingTime = modData.mdzAimingTime or 1
		local mdzReloadTime = modData.mdzReloadTime or 1
		local mdzRecoilDelay = modData.mdzRecoilDelay or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1

		local soulForgeAmmoPerShoot = modData.soulForgeAmmoPerShoot or 1
		local soulForgeAimingPerkCritModifier = modData.soulForgeAimingPerkCritModifier or 1
		local soulForgeAimingPerkHitChanceModifier = modData.soulForgeAimingPerkHitChanceModifier or 1
		local soulForgeAimingPerkRangeModifier = modData.soulForgeAimingPerkRangeModifier or 1
		local soulForgeAimingTime = modData.soulForgeAimingTime or 1
		local soulForgeProjectileCount = modData.soulForgeProjectileCount or 1
		local isPiercingBullets = modData.isPiercingBullets or false
		local soulWrought = modData.SoulWrought or ""
		local soulForgeMaxHitCount = modData.MaxHitCount or nil

		if isPiercingBullets then
			inventoryItem:setPiercingBullets(true)
		else
			inventoryItem:setProjectileCount(soulForgeProjectileCount)
		end

		if soulForgeMaxHitCount then
			inventoryItem:setMaxHitCount(soulForgeMaxHitCount)
		end
		
		local dmgMulti = tonumber(SandboxVars.SDOnWeaponSwing.RangedDamageMultiplier) or 1.5
		local rangedDmgMulti = 1 - (1 - localdmgmulti)^dmgMulti

		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		
		if modData.CriticalChance then inventoryItem:setCriticalChance(modData.CriticalChance * soulForgeCritRate * mdzCriticalChance * soulForgeAimingPerkCritModifier) end
		if modData.CritDmgMultiplier then inventoryItem:setCritDmgMultiplier(modData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier) end
		inventoryItem:setMinDamage(modData.MinDamage * soulForgeMinDmgMulti * mdzMinDmg * rangedDmgMulti)
		inventoryItem:setMaxDamage(modData.MaxDamage * soulForgeMaxDmgMulti * mdzMaxDmg * rangedDmgMulti)
		if modData.ReloadTime then inventoryItem:setReloadTime(modData.ReloadTime * mdzReloadTime) end
		if modData.RecoilDelay then inventoryItem:setRecoilDelay(modData.RecoilDelay * mdzRecoilDelay) end
		
		inventoryItem:setAimingTime(modData.AimingTime * mdzAimingTime * soulForgeAimingTime * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		
		local engravedName = modData.EngravedName
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			inventoryItem:setName(mdzPrefix .. soulWrought ..  modData.Name .. " [T" .. tostring(tierzone) .. "]")
		end
	end
end
Events.OnWeaponSwing.Add(SDOnWeaponSwing)

local function SDWeaponCheck(character, inventoryItem)
	if inventoryItem == nil then return end
	if character ~= getSpecificPlayer(0) then return end
	local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
	
	local tierzone = checkZone()
	
	local modData = inventoryItem:getModData()
	
	if inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
		local isHardmode = modData.HardcoreMode or nil
		local modeMultiplier = 1.0
		
		if isHardmode then modeMultiplier = 0.5 end
		
		local isSoulForged = modData.SoulForged or false
		local hasSouls = modData.KillCount or false
		local augmentMulti = modData.Augments or 0
		local addMaxDmg, addCritChance, addCritMulti = 0, 0, 0
		local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		if isSoulForged and hasSouls then
			local weaponMaxCond = inventoryItem:getConditionMax()
			local weaponCondLowerChance = inventoryItem:getConditionLowerChance()
			local soulsRequired = weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage()
			local soulsFreed = modData.KillCount or nil
			local soulPower = math.min(soulsFreed / soulsRequired, 1)
			addMaxDmg = soulPower * 1 * augmentMulti/4
			addCritChance = soulPower * 5 * augmentMulti/4
			addCritMulti = soulPower * 0.5 * augmentMulti/4
		end
		
		local basecritrate, basecritmulti, basemindmg, basemaxdmg, basename = modData.CriticalChance, modData.CritDmgMultiplier, modData.MinDamage, modData.MaxDamage, modData.Name
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or 1
		local soulForgeEnduranceMod = modData.EnduranceMod or 1
		local soulForgeMaxCondition = modData.MaxCondition or 1
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		local soulWrought = modData.SoulWrought or ""
		
		local pMD = character:getModData()
		local permaCritRate = pMD.PermaSoulForgeCritRateBonus 
		local permaCritMulti = pMD.PermaSoulForgeCritMultiBonus
		local permaMaxDmg = pMD.PermaSoulForgeMaxDmgBonus
		local permaMaxCondition = pMD.PermaMaxConditionBonus
		local permaConditionLowerChance = pMD.PermaSoulForgeConditionBonus
		
		if permaCritRate and permaCritRate > 1 then soulForgeCritRate = soulForgeCritRate * permaCritRate end
		if permaCritMulti and permaCritMulti > 1 then soulForgeCritMulti = soulForgeCritMulti * permaCritMulti end
		if permaMaxDmg and permaMaxDmg > 1 then soulForgeMaxDmgMulti = soulForgeMaxDmgMulti * permaMaxDmg end
		if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
		if soulForgeConditionLowerChance and permaConditionLowerChance and permaConditionLowerChance > 1 then soulForgeConditionLowerChance = soulForgeConditionLowerChance * permaConditionLowerChance end
		
		local engravedName = modData.EngravedName
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		inventoryItem:setCriticalChance((basecritrate + addCritChance) * soulForgeCritRate * mdzCriticalChance)
		inventoryItem:setCritDmgMultiplier((basecritmulti + addCritMulti) * soulForgeCritMulti * mdzCritDmgMultiplier)
		inventoryItem:setMinDamage(basemindmg * soulForgeMinDmgMulti * mdzMinDmg)
		inventoryItem:setMaxDamage((basemaxdmg + addMaxDmg) * soulForgeMaxDmgMulti * mdzMaxDmg)
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			inventoryItem:setName(soulWrought.. mdzPrefix .. basename)
		end
		
		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			if inventoryItem:getSwingAnim() == "Heavy" then mhc = soulForgeMaxHitCount end
			if mhc ~= inventoryItem:getMaxHitCount() then inventoryItem:setMaxHitCount(mhc) end
		end
		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition) end
		if soulForgeEnduranceMod then inventoryItem:setEnduranceMod(soulForgeEnduranceMod) end
		
		local args = {}
		args.critrate = soulForgeCritRate
		args.critmulti = soulForgeCritMulti
		args.mindmg = soulForgeMinDmgMulti
		args.maxdmg = soulForgeMaxDmgMulti
		args.name = soulWrought..basename
		args.endurancemod = soulForgeEnduranceMod
		args.hassouls = hasSouls
		args.player_name = getOnlineUsername()
		args.itemID = inventoryItem:getID()
		
		if isSoulForged then sendClientCommand(character, 'sdLogger', 'SoulForgeEquip', args) end
	elseif inventoryItem:IsWeapon() and inventoryItem:isRanged() then
		initRangedStats(modData, inventoryItem, character)
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzAimingTime = modData.mdzAimingTime or 1
		local mdzReloadTime = modData.mdzReloadTime or 1
		local mdzRecoilDelay = modData.mdzRecoilDelay or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		local soulForgeAmmoPerShoot = modData.soulForgeAmmoPerShoot or 1
		local soulForgeAimingPerkCritModifier = modData.soulForgeAimingPerkCritModifier or 1
		local soulForgeAimingPerkHitChanceModifier = modData.soulForgeAimingPerkHitChanceModifier or 1
		local soulForgeAimingPerkRangeModifier = modData.soulForgeAimingPerkRangeModifier or 1
		local soulForgeAimingTime = modData.soulForgeAimingTime or 1
		local soulForgeProjectileCount = modData.soulForgeProjectileCount or 1
		local isPiercingBullets = modData.isPiercingBullets or false
		local soulWrought = modData.SoulWrought or ""
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		
		if isPiercingBullets then
			inventoryItem:setPiercingBullets(true)
		else
			inventoryItem:setProjectileCount(soulForgeProjectileCount)
		end
		
		if soulForgeMaxHitCount then
			inventoryItem:setMaxHitCount(soulForgeMaxHitCount)
		end
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		
		if modData.CriticalChance then inventoryItem:setCriticalChance(modData.CriticalChance * soulForgeCritRate * mdzCriticalChance) end
		if modData.CritDmgMultiplier then inventoryItem:setCritDmgMultiplier(modData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier) end
		inventoryItem:setMinDamage(modData.MinDamage * soulForgeMinDmgMulti * mdzMinDmg)
		inventoryItem:setMaxDamage(modData.MaxDamage * soulForgeMaxDmgMulti * mdzMaxDmg)
		if modData.ReloadTime then inventoryItem:setReloadTime(modData.ReloadTime * mdzReloadTime) end
		if modData.RecoilDelay then inventoryItem:setRecoilDelay(modData.RecoilDelay * mdzRecoilDelay) end
		
		inventoryItem:setAimingTime(modData.AimingTime * mdzAimingTime * soulForgeAimingTime)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier * soulForgeAimingPerkCritModifier)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier)
		
		local engravedName = modData.EngravedName
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			inventoryItem:setName(mdzPrefix .. soulWrought .. modData.Name)
		end
		
		Events.OnPlayerUpdate.Add(worseVehicleRanged)
	end
end
Events.OnEquipPrimary.Add(SDWeaponCheck)

local tick = 0
local function worseVehicleRanged(player)
	tick = tick + 1
	if tick < 100 then return end
	tick = 0
	local inventoryItem = player:getPrimaryHandItem()
	--check for bare hands or not a weapon or not a ranged weapon
	if 	inventoryItem == nil then 
		--player:Say("Not handweapon")
		Events.OnPlayerUpdate.Remove(worseVehicleRanged)
		return 
	end
	
	--if ranged weapon (need to check in case of weapon swap in car)
	if inventoryItem:IsWeapon() and inventoryItem:isRanged() then
		local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		if player:isSeatedInVehicle() then
			--player:Say("I'm in a vehicle")
			local z_chase = player:getStats():getNumChasingZombies() or 0
			local z_close = player:getStats():getNumVeryCloseZombies() or 0
			
			local n_z = 25--SandboxVars.SDOnWeaponSwing.numberzombies or 15--number of zombies
			
			local function checkZ(n_z, zchase, zclose)
				return z_chase > math.floor(n_z*zchase) or z_close > math.floor(n_z*zclose)
			end
			
			local slice = { 1, 0.8, 0.6, 0.4, 0.2, 0 }
			
			if 		checkZ(n_z, slice[1], slice[2]) then
				inventoryItem:setMaxHitCount(math.max(1,scriptItem:getMaxHitCount()-3))
				inventoryItem:setMinAngle(0.995)
				--player:Say("Hitcount and minangle:"..math.max(1,scriptItem:getMaxHitCount()-3) .. ", " .. 0.995)
			elseif 	checkZ(n_z, slice[2], slice[3]) then
				inventoryItem:setMaxHitCount(math.max(1,scriptItem:getMaxHitCount()-2))
				inventoryItem:setMinAngle(0.99)
				--player:Say("Hitcount and minangle:"..math.max(1,scriptItem:getMaxHitCount()-2) .. ", " .. 0.99)
			elseif 	checkZ(n_z, slice[3], slice[4]) then
				inventoryItem:setMaxHitCount(math.max(1,scriptItem:getMaxHitCount()-1))
				inventoryItem:setMinAngle(0.975)
				--player:Say("Hitcount and minangle:"..math.max(1,scriptItem:getMaxHitCount()-1) .. ", " .. 0.975)
			else
				inventoryItem:setMaxHitCount(scriptItem:getMaxHitCount())
				inventoryItem:setMinAngle(scriptItem:getMinAngle())
				--player:Say("Nothing")
			end
		else--not in vehicle, restore item stats
			inventoryItem:setMaxHitCount(scriptItem:getMaxHitCount())
			inventoryItem:setMinAngle(scriptItem:getMinAngle())
			Events.OnPlayerUpdate.Remove(worseVehicleRanged)--outside of vehicle, end hook
			--player:Say("Event hook removed")
		end
	end
end
Events.OnPlayerUpdate.Add(worseVehicleRanged)
--Events.EveryOneMinute.Add(worseVehicleRanged)

local function OnEnterVehicle(character)
	Events.OnPlayerUpdate.Add(worseVehicleRanged)
end
Events.OnEnterVehicle.Add(OnEnterVehicle)

local function OnExitVehicle(character)
	Events.OnPlayerUpdate.Add(worseVehicleRanged)
end
Events.OnExitVehicle.Add(OnExitVehicle)
