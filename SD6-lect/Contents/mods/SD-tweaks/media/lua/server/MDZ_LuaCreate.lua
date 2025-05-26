local lectRand = newrandom()
local rngSum = 0

local function gaussianRandom()
	local u1 = lectRand:random()
	local u2 = lectRand:random()
	local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)--Box-Mueller Transform
	return z0
end


local function scaledNormal()
	local z = gaussianRandom() 
	z = math.max(-2.5, math.min(2.5, z)) 

	local scaledValue = (z + 2.5) / 50
	scaledValue = scaledValue^0.875 --shift normal distribution to the left. set to 1.0 for a traditional normal distribution.
	rngSum = rngSum + scaledValue
	return scaledValue + 1
end

local hfoVanilla = {
	["Base.Pistol"] = "Beretta M9 Pistol",
	["Base.Pistol2"] = "Colt 1911 Pistol",
	["Base.Pistol3"] = "Desert Eagle MK VII Pistol",
	["Base.Revolver_Short"] = "Smith & Wesson Model 36 Revolver",
	["Base.Revolver"] = "Smith & Wesson Model 625 Revolver",
	["Base.Revovler_Long"] = "Colt Anaconda Revolver",
	["Base.VarmintRifle"] = "Remington Model 700 Rifle",
	["Base.HuntingRifle"] = "Remington Model 788 Rifle",
	["Base.AssaultRifle"] = "Colt M16 Assault Rifle",
	["Base.AssaultRifle2"] = "Springfield Armory M14 Rifle",
	["Base.Shotgun"] = "Remington Model 870 Shotgun",
	["Base.DoubleBarrelShotgun"] = "Remington SPR 220 Shotgun",
	["Base.ShotgunSawnoff"] = "Remington Model 870 Sawnoff Shotgun",
	["Base.DoubleBarrelShotgunSawnoff"] = "Remington SPR 220 Sawnoff Shotgun",
}

local isMultiplayer = true
if getWorld():getGameMode() ~= "Multiplayer" then isMultiplayer = false end

MDZ_OnCreate_RangedWeaponVariance = function(item, cache)
	
	if not isServer() and isMultiplayer and not cache and not isAdmin() then return end
	if not item then return end
	local iMD = item:getModData()
	
	iMD.CriticalChance				= iMD.CriticalChance or item:getCriticalChance()
	iMD.CritDmgMultiplier			= iMD.CritDmgMultiplier or item:getCritDmgMultiplier()
	iMD.MinDamage					= iMD.MinDamage or item:getMinDamage()
	iMD.MaxDamage					= iMD.MaxDamage or item:getMaxDamage()
	iMD.AimingPerkHitChanceModifier = iMD.AimingPerkHitChanceModifier or item:getAimingPerkHitChanceModifier()
	iMD.AimingPerkCritModifier 		= iMD.AimingPerkCritModifier or item:getAimingPerkCritModifier()
	iMD.AimingPerkRangeModifier 	= iMD.AimingPerkRangeModifier or item:getAimingPerkRangeModifier()
	iMD.AimingTime					= iMD.AimingTime or item:getAimingTime()
	iMD.ReloadTime					= iMD.ReloadTime or item:getReloadTime()
	iMD.RecoilDelay					= iMD.RecoilDelay or item:getRecoilDelay()
	iMD.Name						= item:getName()
	iMD.MeleeSwap 					= nil
	iMD.SD7_1						= true
	
	iMD.mdzMaxDmg = iMD.mdzMaxDmg or scaledNormal()
	iMD.mdzMinDmg = iMD.mdzMinDmg or scaledNormal()
	iMD.mdzAimingTime = iMD.mdzAimingTime or scaledNormal()
	iMD.mdzReloadTime = iMD.mdzReloadTime or (1 / scaledNormal())
	iMD.mdzRecoilDelay = iMD.mdzRecoilDelay or (1 / scaledNormal())
	iMD.mdzCriticalChance = iMD.mdzCriticalChance or scaledNormal()
	iMD.mdzCritDmgMultiplier = iMD.mdzCritDmgMultiplier or scaledNormal()
	
	item:setMaxDamage(iMD.mdzMaxDmg * iMD.MaxDamage)
	item:setMinDamage(iMD.mdzMinDmg * iMD.MinDamage)
	item:setCriticalChance(iMD.mdzCriticalChance * iMD.CriticalChance)
	item:setCritDmgMultiplier(iMD.mdzCritDmgMultiplier * iMD.CritDmgMultiplier)
	item:setAimingTime(iMD.mdzAimingTime * iMD.AimingTime)
	item:setReloadTime(iMD.mdzReloadTime * iMD.ReloadTime)
	item:setRecoilDelay(iMD.mdzRecoilDelay * iMD.RecoilDelay)
	--[[print("=====================MDZ OnCreate ModData")
	for k,v in pairs(item:getModData()) do print(k,v) end
	print("=====================MDZ Oncreate ModData")]]
	
	local itemPower = rngSum / 7
	local itemPrefix = "Ordinary"
	if itemPower >= 0.09 then
		itemPrefix = "Exemplary"
	elseif itemPower > 0.075 then
		itemPrefix = "Exceptional"
	elseif itemPower > 0.06 then
		itemPrefix = "Superior"
	elseif itemPower > 0.045 then
		itemPrefix = "Refined"
	end
	iMD.mdzPrefix = iMD.mdzPrefix or itemPrefix
	local iFT = item:getFullType()
	if hfoVanilla[iFT] then iMD.Name = hfoVanilla[iFT] end
	item:setName(iMD.mdzPrefix .. " " .. iMD.Name)
	rngSum = 0
	--print("MDZ ON LUA CREATE RANGED =========================")
end

MDZ_OnCreate_MeleeWeaponVariance = function(item, cache)
	
	if isServer() then return end
	
	if cache and (isAdmin() or isDebugEnabled()) then return end-- if it's a cache and you're superuser, just close so you don't double dip and cause naming issues

	if not item then return end
	
	if cache or isAdmin() or isDebugEnabled() then--if player, then cache open will still function (but not unforge). if superuser, will work for cache and item spawn and unforge.
		local iMD = item:getModData()
		iMD.mdzMaxDmg = iMD.mdzMaxDmg or scaledNormal()
		iMD.mdzMinDmg = iMD.mdzMinDmg or scaledNormal()
		iMD.mdzCriticalChance = iMD.mdzCriticalChance or scaledNormal()
		iMD.mdzCritDmgMultiplier = iMD.mdzCritDmgMultiplier or scaledNormal()
		
		iMD.CriticalChance		= iMD.CriticalChance or item:getCriticalChance()
		iMD.CritDmgMultiplier	= iMD.CritDmgMultiplier or item:getCritDmgMultiplier()
		iMD.MinDamage			= iMD.MinDamage or item:getMinDamage()
		iMD.MaxDamage			= iMD.MaxDamage or item:getMaxDamage()
		iMD.MaxHitCount			= iMD.MaxHitCount or item:getMaxHitCount()
		iMD.Name				= item:getName()
		iMD.SD7_1				= true
			
		item:setMaxDamage(iMD.mdzMaxDmg * iMD.MaxDamage)
		item:setMinDamage(iMD.mdzMinDmg * iMD.MinDamage)
		item:setCriticalChance(iMD.mdzCriticalChance * iMD.CriticalChance)
		item:setCritDmgMultiplier(iMD.mdzCritDmgMultiplier * iMD.CritDmgMultiplier)
		
		local itemPower = rngSum / 4
		local itemPrefix = "Ordinary"
		if itemPower >= 0.09 then
			itemPrefix = "Exemplary"
		elseif itemPower > 0.075 then
			itemPrefix = "Exceptional"
		elseif itemPower > 0.06 then
			itemPrefix = "Superior"
		elseif itemPower > 0.045 then
			itemPrefix = "Refined"
		end
		iMD.mdzPrefix = iMD.mdzPrefix or itemPrefix
		item:setName(iMD.mdzPrefix .. " " .. iMD.Name)
		rngSum = 0
	end

end

local function MDZ_weapon_luaCreate()
	local items = getAllItems();
	for i = 0, items:size()-1, 1 do
		local testItem = items:get(i)
		if testItem then
			local itemType = testItem:getTypeString()
			if itemType == "Weapon" then
				local getLuaCreate = testItem:getLuaCreate() or nil
				if testItem:isRanged() then
					if not getLuaCreate then
						--print("[MoreDifficultZones] Ranged Weapon found! MDZ OnCreate Function added to - " .. testItem:getFullName() .. "(" .. testItem:getDisplayName() .. ")")
						testItem:DoParam("OnCreate = MDZ_OnCreate_RangedWeaponVariance")
					end
				elseif testItem:getModuleName() == "RMWeapons" then 
					if not getLuaCreate then
						--print("[MoreDifficultZones] Melee Weapon found! MDZ OnCreate Function added to - " .. testItem:getFullName() .. "(" .. testItem:getDisplayName() .. ")")
						testItem:DoParam("OnCreate = MDZ_OnCreate_MeleeWeaponVariance")
					end
				end
			end
		end
	end

end
--MDZ_weapon_luaCreate()
Events.OnInitGlobalModData.Add(MDZ_weapon_luaCreate)