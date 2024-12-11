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
		
		modData.CriticalChance		= inventoryItem:getCriticalChance()
		modData.CritDmgMultiplier	= inventoryItem:getCritDmgMultiplier()
		modData.MinDamage			= inventoryItem:getMinDamage()
		modData.MaxDamage			= inventoryItem:getMaxDamage()
		modData.MaxHitCount			= inventoryItem:getMaxHitCount()
		modData.Name				= character:getPrimaryHandItem():getName()
		modData.SD6_2				= true
	elseif not modData.SD6_2 then
		scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())

		inventoryItem:setMaxRange(scriptItem:getMaxRange())
		
		modData.MinDamage 			= scriptItem:getMinDamage()
		modData.MaxDamage 			= scriptItem:getMaxDamage()
		modData.SD6_2 				= true
	end
end

local function initRangedStats(modData, inventoryItem, character)
	if 	modData.AimingPerkHitChanceModifier == nil and
		modData.AimingPerkCritModifier 		== nil and
		modData.AimingPerkRangeModifier 	== nil and
		modData.AimingTime 					== nil and
		--modData.ReloadTime 				== nil and
		--modData.RecoilDelay				== nil and
		modData.Name						== nil then
		
		modData.AimingPerkHitChanceModifier = inventoryItem:getAimingPerkHitChanceModifier()
		modData.AimingPerkCritModifier 		= inventoryItem:getAimingPerkCritModifier()
		modData.AimingPerkRangeModifier 	= inventoryItem:getAimingPerkRangeModifier()
		modData.AimingTime					= inventoryItem:getAimingTime()
		--modData.ReloadTime				= inventoryItem:getReloadTime()
		--modData.RecoilDelay				= inventoryItem:getRecoilDelay()
		modData.Name						= character:getPrimaryHandItem():getName()
	end
end

local function SDOnWeaponSwing(character, handWeapon)
	if character:getPrimaryHandItem() == nil then return end
	
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
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or nil
		local soulForgeEnduranceMod = modData.EnduranceMod or 1
		local soulForgeMaxCondition = modData.MaxCondition or nil
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		local soulWrought = modData.SoulWrought or ""
		
		inventoryItem:setCriticalChance(((basecritrate + addCritChance) * localcritrate) * modeMultiplier * soulForgeCritRate)
		inventoryItem:setCritDmgMultiplier(((basecritmulti + addCritMulti) * localcritmulti) * modeMultiplier * soulForgeCritMulti)
		inventoryItem:setMinDamage((basemindmg * localdmgmulti) * modeMultiplier * soulForgeMinDmgMulti)
		inventoryItem:setMaxDamage(((basemaxdmg + addMaxDmg) * localdmgmulti) * modeMultiplier * soulForgeMaxDmgMulti)
		inventoryItem:setName(soulWrought..basename .. " [T" .. tostring(tierzone) .. "]")

		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition) end
		
		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			if mhc ~= inventoryItem:getMaxHitCount() then inventoryItem:setMaxHitCount(mhc) end
		end
	elseif tierzone and handWeapon:isRanged() then
		initRangedStats(modData, inventoryItem, character)
		local rangedmulti = 1.0
		
		if character:HasTrait("Brave")			then rangedmulti = rangedmulti - 0.125 end
		if character:HasTrait("Desensitized")	then rangedmulti = rangedmulti - 0.25 end
		if character:HasTrait("Cowardly")		then rangedmulti = rangedmulti + 0.15 end
		if character:HasTrait("ShortSighted")	then rangedmulti = rangedmulti + 0.1 end
		if character:HasTrait("EagleEyed")		then rangedmulti = rangedmulti - 0.1 end

		rangedmulti = rangedmulti - character:getPerkLevel(Perks.Aiming)/20
		
		--if character:isSeatedInVehicle() then rangedmulti = 2.0 end
		
		inventoryItem:setAimingTime(modData.AimingTime * (localdmgmulti/tierzone) ^ rangedmulti)
		--inventoryItem:setReloadTime(modData.ReloadTime * localdmgmulti ^ rangedmulti)
		--inventoryItem:setRecoilDelay(modData.RecoilDelay * localdmgmulti ^ rangedmulti)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setName(modData.Name .. " [T" .. tostring(tierzone) .. "]")
	end
end
Events.OnWeaponSwing.Add(SDOnWeaponSwing)

local function SDWeaponCheck(character, inventoryItem)
	if inventoryItem == nil then return end
	local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
	
	local tierzone = checkZone()
	
	local modData = inventoryItem:getModData()
	
	if inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
		inventoryItem:setCriticalChance(modData.CriticalChance)
		inventoryItem:setCritDmgMultiplier(modData.CritDmgMultiplier)
		inventoryItem:setMinDamage(modData.MinDamage)
		inventoryItem:setMaxDamage(modData.MaxDamage)
		inventoryItem:setName(modData.Name)
		
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
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or nil
		local soulForgeEnduranceMod = modData.EnduranceMod or 1
		local soulForgeMaxCondition = modData.MaxCondition or nil
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		local soulWrought = modData.SoulWrought or ""
		
		inventoryItem:setCriticalChance((basecritrate + addCritChance) * soulForgeCritRate)
		inventoryItem:setCritDmgMultiplier((basecritmulti + addCritMulti) * soulForgeCritMulti)
		inventoryItem:setMinDamage(basemindmg * soulForgeMinDmgMulti)
		inventoryItem:setMaxDamage((basemaxdmg + addMaxDmg) * soulForgeMaxDmgMulti)
		inventoryItem:setName(soulWrought..basename)
		
		if soulForgeMaxHitCount then inventoryItem:setMaxHitCount(math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)) end
		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition) end
	elseif inventoryItem:IsWeapon() and inventoryItem:isRanged() then
		initRangedStats(modData, inventoryItem, character)
		
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier)
		inventoryItem:setAimingTime(modData.AimingTime)
		--inventoryItem:setRecoilDelay(modData.RecoilDelay)
		--inventoryItem:setReloadTime(modData.ReloadTime)
		inventoryItem:setName(modData.Name)
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