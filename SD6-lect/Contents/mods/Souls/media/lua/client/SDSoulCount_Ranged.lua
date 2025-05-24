----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

--require "SDZoneCheck"

local function KillCountSD(player)
	return player:getZombieKills()
end

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,1,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "


local function space(str)
    return str ~= "" and " " or ""
end

local function weaponName(wMD, scriptItem)
	local prefix = ""
	if wMD.prefix1 and wMD.prefix1 ~= "" then
		prefix = prefix .. wMD.prefix1 .. space(wMD.prefix1)
	end
	if wMD.prefix2 and wMD.prefix2 ~= "" then
		prefix = prefix .. wMD.prefix2 .. "'s" .. space(wMD.prefix2)
	end
	
	local suffix = ""
	if wMD.suffix1 and wMD.suffix1 ~= "" or 
	   wMD.suffix2 and wMD.suffix2 ~= "" then

		suffix = " of the " .. (wMD.suffix1 or "") .. " " .. (wMD.suffix2 or "")
	end

	local name =  prefix .. scriptItem:getDisplayName() .. suffix
    return name
end

local function isAugmented()
	local isAugmented = wMD.Augments or nil
	if isAugmented then
		wMD.Augments = isAugmented + 1
	else
		wMD.Augments = 1
	end
end

local function checkStatName(scriptItem, statName, multiplier)
	if statName 	== "getMinDamage" then 
		return multiplier
	elseif statName == "getMaxDamage" then 
		return multiplier
	elseif statName == "getCriticalChance" then
		return multiplier
	elseif statName == "getCritDmgMultiplier" then
		return multiplier
	elseif statName == "getAmmoPerShoot" then 
		return multiplier
	elseif statName == "getAimingPerkCritModifier" then 
		return multiplier
	elseif statName == "getAimingPerkHitChanceModifier" then
		return multiplier
	elseif statName == "getAimingTime" then
		return multiplier
	elseif statName == "getAimingPerkRangeModifier" then
		return multiplier
	elseif statName == "getProjectileCount" then
		return (scriptItem:getProjectileCount() + multiplier)
	elseif statName == "getMaxHitCount" then
		return (scriptItem:getMaxHitCount() + multiplier)
	elseif statName == "isPiercingBullets" then
		return true
	end
end

local function getStat(_fix, name, statName, multiplier, desc)
    return function(item)
        local scriptItem = ScriptManager.instance:getItem(item:getFullType())
		local n_stat = checkStatName(scriptItem, statName, multiplier)
        local description = gold .. _fix .. " Modifier: " .. name .. green .. 
                            " <LINE> " .. 
                            string.format("%.0f", (multiplier * 100) - 100) .. 
                            desc

        return description, scriptItem, n_stat
    end
end

local function setStat(upgradeName, statName, descno, description, scriptItem, n_stat)
    return function(item, description, scriptItem, n_stat)
		local wMD = item:getModData()
		if descno     == "p1_desc" then
            wMD.prefix1 = upgradeName
        elseif descno == "s1_desc" then
            wMD.suffix1 = upgradeName
        elseif descno == "p2_desc" then
            wMD.prefix2 = upgradeName
        elseif descno == "s2_desc" then
            wMD.suffix2 = upgradeName
        else
            print("No prefix or suffix in args.")
            return
        end
		
		if statName == "getAmmoPerShoot" then
			if wMD.soulForgeAmmoPerShoot ~= nil then
				wMD.soulForgeAmmoPerShoot = true
			else
				wMD.soulForgeAmmoPerShoot = true -- Set the default value if nil
			end
		elseif statName == "getAimingPerkCritModifier" then
			if wMD.soulForgeAimingPerkCritModifier ~= nil then
				wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier * n_stat
			else
				wMD.soulForgeAimingPerkCritModifier = n_stat
			end
		elseif statName == "getAimingPerkHitChanceModifier" then
			if wMD.soulForgeAimingPerkHitChanceModifier ~= nil then
				wMD.soulForgeAimingPerkHitChanceModifier = wMD.soulForgeAimingPerkHitChanceModifier * n_stat
			else
				wMD.soulForgeAimingPerkHitChanceModifier = n_stat
			end
		elseif statName == "getAimingTime" then
			if wMD.soulForgeAimingTime ~= nil then
				wMD.soulForgeAimingTime = wMD.soulForgeAimingTime * n_stat
			else
				wMD.soulForgeAimingTime = n_stat
			end
		elseif statName == "getAimingPerkRangeModifier" then
			if wMD.soulForgeAimingPerkRangeModifier ~= nil then
				wMD.soulForgeAimingPerkRangeModifier = wMD.soulForgeAimingPerkRangeModifier * n_stat
			else
				wMD.soulForgeAimingPerkRangeModifier = n_stat
			end
		elseif statName == "getProjectileCount" then
			if wMD.soulForgeProjectileCount ~= nil then
				wMD.soulForgeProjectileCount = n_stat
			else
				wMD.soulForgeProjectileCount = n_stat
			end
		elseif statName == "getMaxHitCount" then
			wMD.MaxHitCount = item:getMaxHitCount() + n_stat
			item:setMaxHitCount(wMD.MaxHitCount)
		elseif statName == "getMinDamage" then
			if wMD.soulForgeMinDmgMulti ~= nil then
				wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti * n_stat
			else
				wMD.soulForgeMinDmgMulti = n_stat -- Set the default value if nil
			end
		elseif statName == "getMaxDamage" then
			if wMD.soulForgeMaxDmgMulti ~= nil then
				wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * n_stat
			else
				wMD.soulForgeMaxDmgMulti = n_stat
			end
		elseif statName == "getCriticalChance" then
			if wMD.soulForgeCritRate ~= nil then
				wMD.soulForgeCritRate = wMD.soulForgeCritRate * n_stat
			else
				wMD.soulForgeCritRate = n_stat
			end
		elseif statName == "getCritDmgMultiplier" then
			if wMD.soulForgeCritMulti ~= nil then
				wMD.soulForgeCritMulti = wMD.soulForgeCritMulti * n_stat
			else
				wMD.soulForgeCritMulti = n_stat
			end
		elseif statName == "isPiercingBullets" then
			wMD.isPiercingBullets = true
			item:setPiercingBullets(true)
		end

        isAugmented()
        wMD.Name = weaponName(wMD, scriptItem)
		local mdzPrefix = ""
		if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
		item:setName(mdzPrefix .. wMD.Name)
        wMD[descno] = description
    end
end

local function posDesc(statName)
	if statName 	== "getAmmoPerShoot" then 
		return "% chance to not use ammo <LINE> "
	elseif statName == "getAimingPerkCritModifier" then 
		return "% More Aiming Perk Critical Chance Modifier <LINE> "
	elseif statName == "getAimingPerkHitChanceModifier" then
		return "% More Aiming Perk Hit Chance Modifier <LINE> "
	elseif statName == "getAimingPerkRangeModifier" then
		return "% More Aiming Perk Range Modifier <LINE> "
	elseif statName == "getAimingTime" then
		return "% More Aiming Perk Aiming Time Modifier <LINE> "
	elseif statName == "getProjectileCount" then
		return "+1 Additional Projectile Count <LINE> "
	elseif statName == "getMaxHitCount" then
		return "+1 Additional Max Hit Count <LINE> "
	elseif statName == "getMinDamage" then 
		return "% More Minimum Damage <LINE> "
	elseif statName == "getMaxDamage" then 
		return "% More Maximum Damage <LINE> "
	elseif statName == "getCriticalChance" then
		return "% More Critical Chance <LINE> "
	elseif statName == "getCritDmgMultiplier" then
		return "% More Critical Damage Multiplier <LINE> "
	elseif statName == "isPiercingBullets" then
		return "Piercing Bullets <LINE> "
	end
end

local pref1_args = {
	Accurate = getStat("Prefix", "Accurate", "getAimingPerkHitChanceModifier", 1.2, posDesc("getAimingPerkHitChanceModifier")),
	Honed = getStat("Prefix", "Honed", "getAimingPerkCritModifier", 1.2, posDesc("getAimingPerkCritModifier")),
	Quick = getStat("Prefix", "Quick", "getAimingTime", 1.2, posDesc("getAimingTime")),
	Steady = getStat("Prefix", "Steady", "getAimingPerkRangeModifier", 1.2, posDesc("getAimingPerkRangeModifier")),
	--Amplified = getStat("Prefix", "Amplified", "getMinDamage", 1.1, posDesc("getMinDamage")),
	Bolstered = getStat("Prefix", "Bolstered", "getMaxDamage", 1.05, posDesc("getMaxDamage")),
}

local pref1_setstat = {
	Accurate = setStat("Accurate", "getAimingPerkHitChanceModifier", "p1_desc", description, scriptItem, n_stat),
	Honed = setStat("Honed", "getAimingPerkCritModifier", "p1_desc", description, scriptItem, n_stat),
	Quick = setStat("Quick", "getAimingTime", "p1_desc", description, scriptItem, n_stat),
	Steady = setStat("Steady", "getAimingPerkRangeModifier", "p1_desc", description, scriptItem, n_stat),
	--Amplified = setStat("Amplified", "getMinDamage", "p1_desc", description, scriptItem, n_stat),
	Bolstered = setStat("Bolstered", "getMaxDamage", "p1_desc", description, scriptItem, n_stat),
}

local suff1_args = {
	Focused = getStat("Suffix", "Focused", "getAimingPerkHitChanceModifier", 1.2, posDesc("getAimingPerkHitChanceModifier")),
	Deadly = getStat("Suffix", "Deadly", "getAimingPerkCritModifier", 1.2, posDesc("getAimingPerkCritModifier")),
	Swift = getStat("Suffix", "Swift", "getAimingTime", 1.2, posDesc("getAimingTime")),
	Precise = getStat("Suffix", "Precise", "getAimingPerkRangeModifier", 1.2, posDesc("getAimingPerkRangeModifier")),
	--Empowered = getStat("Suffix", "Empowered", "getMinDamage", 1.1, posDesc("getMinDamage")),
	Charged = getStat("Suffix", "Charged", "getMaxDamage", 1.05, posDesc("getMaxDamage")),
}

local suff1_setstat = {
	Focused = setStat("Focused", "getAimingPerkHitChanceModifier", "s1_desc", description, scriptItem, n_stat),
	Deadly = setStat("Deadly", "getAimingPerkCritModifier", "s1_desc", description, scriptItem, n_stat),
	Swift = setStat("Swift", "getAimingTime", "s1_desc", description, scriptItem, n_stat),
	Precise = setStat("Precise", "getAimingPerkRangeModifier", "s1_desc", description, scriptItem, n_stat),
	--Empowered = setStat("Empowered", "getMinDamage", "s1_desc", description, scriptItem, n_stat),
	Charged = setStat("Charged", "getMaxDamage", "s1_desc", description, scriptItem, n_stat),
}

local pref2_args = {
    Berserker	=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.05, 1.05, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						if item:isPiercingBullets() then
							sm3 = true
							local soulForgePiercing = sm3
							local description = gold .. "Prefix Modifer: Berserker" ..
									green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
									green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage" .. 
									green .. " <LINE> " .. "Piercing Bullets <LINE> "
							return description, scriptItem, maxDamage, minDamage, soulForgePiercing
						else
							local soulForgeProjectileCount = item:getProjectileCount() + sm3
							local description = gold .. "Prefix Modifer: Berserker" ..
									green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
									green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage" .. 
									green .. " <LINE> " .. "+1 to Projectile Count <LINE> "
							return description, scriptItem, maxDamage, minDamage, soulForgeProjectileCount
						end
					end,
	
	Deadeye		=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.3, 1.05, 1
						
						local soulForgeAimingPerkCritModifier = sm1
						local maxDamage = sm2
						if item:isPiercingBullets() then
							sm3 = true
							local soulForgePiercing = sm3
							local description = gold .. "Prefix Modifer: Deadeye" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Critical Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. "Piercing Bullets <LINE> "
							return description, scriptItem, soulForgeAimingPerkCritModifier, maxDamage, soulForgePiercing
						else
							local soulForgeProjectileCount = item:getProjectileCount() + sm3
							local description = gold .. "Prefix Modifer: Deadeye" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Critical Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. "+1 to Projectile Count <LINE> "
							return description, scriptItem, soulForgeAimingPerkCritModifier, maxDamage, soulForgeProjectileCount
						end
					end,

	Marksman	=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.25, 1
						
						local soulForgeAimingPerkHitChanceModifier = sm1
						local soulForgeAimingTime = sm2
						if item:isPiercingBullets() then
							sm3 = true
							local soulForgePiercing = sm3
							local description = gold .. "Prefix Modifer: Deadeye" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Hit Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Time" ..
								green .. " <LINE> " .. "Piercing Bullets <LINE> "
							return description, scriptItem, soulForgeAimingPerkHitChanceModifier, soulForgeAimingTime, soulForgePiercing
						else
							local soulForgeProjectileCount = item:getProjectileCount() + sm3
							local description = gold .. "Prefix Modifer: Deadeye" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Hit Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Time" ..
								green .. " <LINE> " .. "+1 to Projectile Count <LINE> "
							return description, scriptItem, soulForgeAimingPerkHitChanceModifier, soulForgeAimingTime, soulForgeProjectileCount
						end
					end,
					
	Bandit		=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.3, 1.2, 1
						
						local soulForgeAimingPerkCritModifier = sm1
						local soulForgeAimingPerkRangeModifier = sm2
						if item:isPiercingBullets() then
							sm3 = true
							local soulForgePiercing = sm3
							local description = gold .. "Prefix Modifer: Bandit" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Crit Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Range Modifier" ..
								green .. " <LINE> " .. "Piercing Bullets <LINE> "
							return description, scriptItem, soulForgeAimingPerkCritModifier, soulForgeAimingPerkRangeModifier, soulForgePiercing
						else
							local soulForgeProjectileCount = item:getProjectileCount() + sm3
							local description = gold .. "Prefix Modifer: Deadeye" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Aiming Perk Crit Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Range Modifier" ..
								green .. " <LINE> " .. "+1 to Projectile Count <LINE> "
							return description, scriptItem, soulForgeAimingPerkCritModifier, soulForgeAimingPerkRangeModifier, soulForgeProjectileCount
						end
					end,
}

local pref2_setstat = {
    Berserker 	=	function(item, description, scriptItem, maxDamage, minDamage, third_stat)
						
						
						if wMD.soulForgeMinDmgMulti ~= nil then
							wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti * minDamage
						else
							wMD.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * maxDamage
						else
							wMD.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if third_stat == true then
							wMD.isPiercingBullets = true
						else
							wMD.soulForgeProjectileCount = item:getProjectileCount() + 1
						end
						
						wMD.prefix2 = "Berserker"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.p2_desc = description
						
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,

    Deadeye 	=	function(item, description, scriptItem, soulForgeAimingPerkCritModifier, maxDamage, third_stat)
												
						if wMD.soulForgeAimingPerkCritModifier ~= nil then
							wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier * soulForgeAimingPerkCritModifier
						else
							wMD.soulForgeAimingPerkCritModifier = soulForgeAimingPerkCritModifier -- Set the default value if nil
						end

						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * maxDamage
						else
							wMD.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if third_stat == true then
							wMD.isPiercingBullets = true
						else
							wMD.soulForgeProjectileCount = item:getProjectileCount() + 1
						end

						wMD.prefix2 = "Deadeye"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.p2_desc = description

						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,

	Marksman 	=	function(item, description, scriptItem, soulForgeAimingPerkHitChanceModifier, soulForgeAimingTime, third_stat)
												
						if wMD.soulForgeAimingPerkHitChanceModifier ~= nil then
							wMD.soulForgeAimingPerkHitChanceModifier = wMD.soulForgeAimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier
						else
							wMD.soulForgeAimingPerkHitChanceModifier = soulForgeAimingPerkHitChanceModifier -- Set the default value if nil
						end

						if wMD.soulForgeAimingTime ~= nil then
							wMD.soulForgeAimingTime = wMD.soulForgeAimingTime * soulForgeAimingTime
						else
							wMD.soulForgeAimingTime = soulForgeAimingTime
						end
						
						if third_stat == true then
							wMD.isPiercingBullets = true
						else
							wMD.soulForgeProjectileCount = item:getProjectileCount() + 1
						end

						wMD.prefix2 = "Marksman"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.p2_desc = description

						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,
	
	Bandit 		=	function(item, description, scriptItem, soulForgeAimingPerkCritModifier, soulForgeAimingPerkRangeModifier, third_stat)
												
						if wMD.soulForgeAimingPerkCritModifier ~= nil then
							wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier * soulForgeAimingPerkCritModifier
						else
							wMD.soulForgeAimingPerkCritModifier = soulForgeAimingPerkCritModifier -- Set the default value if nil
						end

						if wMD.soulForgeAimingPerkRangeModifier ~= nil then
							wMD.soulForgeAimingPerkRangeModifier = wMD.soulForgeAimingPerkRangeModifier * soulForgeAimingPerkRangeModifier
						else
							wMD.soulForgeAimingPerkRangeModifier = soulForgeAimingPerkRangeModifier
						end
						
						if third_stat == true then
							wMD.isPiercingBullets = true
						else
							wMD.soulForgeProjectileCount = item:getProjectileCount() + 1
						end

						wMD.prefix2 = "Bandit"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.p2_desc = description

						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,
}

local suff2_args = {
    SundayDriver =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.3, 1.05
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local soulForgeAimingTime = sm2
						local maxDamage = sm3
						
						local description = gold .. "Suffix Modifer: Sunday Driver" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Time" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Maximum Damage <LINE> "
						return description, scriptItem, maxHitCount, soulForgeAimingTime, maxDamage
					end,
	
	FilthyCasual =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.3, 1.05
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local soulForgeAimingPerkRangeModifier = sm2
						local minDamage = sm3
						
						local description = gold .. "Suffix Modifer: Filthy Casual" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Range Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxHitCount, soulForgeAimingPerkRangeModifier, minDamage
					end,

    ApocalypseEnjoyer =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.3, 1.3
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local soulForgeAimingPerkCritModifier = sm2
						local soulForgeAimingPerkHitChanceModifier = sm3
						
						local description = gold .. "Suffix Modifer: Apocalypse Enjoyer" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Critical Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Aiming Perk Hit Chance Modifier <LINE> "
						return description, scriptItem, maxHitCount, soulForgeAimingPerkCritModifier, soulForgeAimingPerkHitChanceModifier
					end,
					
	AscendedPath =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.35, 1.35
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local soulForgeAimingPerkCritModifier = sm2
						local soulForgeAimingPerkRangeModifier = sm3
						
						local description = gold .. "Suffix Modifer: Ascended Path" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Critical Chance Modifier" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Aiming Perk Range Modifier <LINE> "
						return description, scriptItem, maxHitCount, soulForgeAimingPerkCritModifier, soulForgeAimingPerkRangeModifier
					end,
	
	--[[ToxicProgenitor=function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.2, 1.2
						
						local maxDamage = sm1
						local minDamage = sm2
						local soulForgeAimingTime = sm3
						
						local description = gold .. "Suffix Modifer: Toxic Progenitor" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Minimum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Time <LINE> " ..
						return description, scriptItem, maxDamage, minDamage, soulForgeAimingTime
					end,
					
	UnhingedTryhard=function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.35, 1.35, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						local soulForgeAimingPerkCritModifier = sm3
						
						local description = gold .. "Suffix Modifer: Unhinged Tryhard" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Minimum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Aiming Perk Critical Chance Modifier <LINE> " ..
						return description, scriptItem, maxDamage, minDamage, soulForgeAimingTime
					end,]]
}

local suff2_setstat = {
    SundayDriver =	function(item, description, scriptItem, maxHitCount, soulForgeAimingTime, maxDamage)
												
						wMD.MaxHitCount = maxHitCount
						
						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * maxDamage
						else
							wMD.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end

						if wMD.soulForgeAimingTime ~= nil then
							wMD.soulForgeAimingTime = wMD.soulForgeAimingTime * soulForgeAimingTime
						else
							wMD.soulForgeAimingTime = soulForgeAimingTime
						end
						wMD.suffix2 = "Sunday Driver"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description
						
						item:setMaxHitCount(maxHitCount)
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,
					
	FilthyCasual =	function(item, description, scriptItem, maxHitCount, soulForgeAimingPerkRangeModifier, minDamage)
												
						wMD.MaxHitCount = maxHitCount
						
						if wMD.soulForgeAimingPerkRangeModifier ~= nil then
							wMD.soulForgeAimingPerkRangeModifier = wMD.soulForgeAimingPerkRangeModifier * soulForgeAimingPerkRangeModifier
						else
							wMD.soulForgeAimingPerkRangeModifier = soulForgeAimingPerkRangeModifier -- Set the default value if nil
						end
						
						if wMD.soulForgeMinDmgMulti ~= nil then
							wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti * minDamage
						else
							wMD.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end

						wMD.suffix2 = "Filthy Casual"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description
						
						item:setMaxHitCount(maxHitCount)
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,

    ApocalypseEnjoyer =	function(item, description, scriptItem, maxHitCount, soulForgeAimingPerkCritModifier, soulForgeAimingPerkHitChanceModifier)
												
						wMD.MaxHitCount = maxHitCount
						
						if wMD.soulForgeAimingPerkCritModifier ~= nil then
							wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier * soulForgeAimingPerkCritModifier
						else
							wMD.soulForgeAimingPerkCritModifier = soulForgeAimingPerkCritModifier -- Set the default value if nil
						end
						
						if wMD.soulForgeAimingPerkHitChanceModifier ~= nil then
							wMD.soulForgeAimingPerkHitChanceModifier = wMD.soulForgeAimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier
						else
							wMD.soulForgeAimingPerkHitChanceModifier = soulForgeAimingPerkHitChanceModifier
						end
						
						wMD.suffix2 = "Apocalypse Enjoyer"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description

						item:setMaxHitCount(maxHitCount)
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,
					
    AscendedPath =	function(item, description, scriptItem, maxHitCount, soulForgeAimingPerkCritModifier, soulForgeAimingPerkRangeModifier)
												
						wMD.MaxHitCount = maxHitCount
						
						if wMD.soulForgeAimingPerkCritModifier ~= nil then
							wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier * soulForgeAimingPerkCritModifier
						else
							wMD.soulForgeAimingPerkCritModifier = soulForgeAimingPerkCritModifier -- Set the default value if nil
						end
						
						if wMD.soulForgeAimingPerkRangeModifier ~= nil then
							wMD.soulForgeAimingPerkRangeModifier = wMD.soulForgeAimingPerkRangeModifier * soulForgeAimingPerkRangeModifier
						else
							wMD.soulForgeAimingPerkRangeModifier = soulForgeAimingPerkRangeModifier
						end
						wMD.suffix2 = "Ascended Path"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description
						
						item:setMaxHitCount(maxHitCount)
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end,
	
--[[	ToxicProgenitor=function(item, description, scriptItem, maxDamage, minDamage, soulForgeAimingTime)
												
						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * maxDamage
						else
							wMD.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if wMD.soulForgeMinDmgMulti ~= nil then
							wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti * minDamage
						else
							wMD.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if wMD.soulForgeAimingTime ~= nil then
							wMD.soulForgeAimingTime = wMD.soulForgeAimingTime * soulForgeAimingTime
						else
							wMD.soulForgeAimingTime = soulForgeAimingTime
						end
						wMD.suffix2 = "Toxic Progenitor"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description
						
						item:setName(wMD.Name)
					end,
					
	UnhingedTryhard=function(item, description, scriptItem, maxDamage, minDamage, soulForgeAimingTime)
												
						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * maxDamage
						else
							wMD.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if wMD.soulForgeMinDmgMulti ~= nil then
							wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti * minDamage
						else
							wMD.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if wMD.soulForgeAimingTime ~= nil then
							wMD.soulForgeAimingTime = wMD.soulForgeAimingTime * soulForgeAimingTime
						else
							wMD.soulForgeAimingTime = soulForgeAimingTime
						end
						wMD.suffix2 = "Unhinged Tryhard"
						
						isAugmented()
						
						wMD.Name = weaponName(wMD, scriptItem)
						wMD.s2_desc = description
						
						item:setName(wMD.Name)
					end,]]
}

local function SoulContextSDRanged(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:IsWeapon() and item:isRanged() then
			wMD = item:getModData()
			local o_scriptItem = ScriptManager.instance:getItem(item:getFullType())
			if not wMD.Tier then
				local itemPrefix = wMD.mdzPrefix
				if not itemPrefix then return end
				if itemPrefix == "Exemplary" then
					wMD.Tier = 5
				elseif itemPrefix == "Exceptional" then
					wMD.Tier = 4
				elseif itemPrefix == "Superior" then
					wMD.Tier = 3
				elseif itemPrefix == "Refined" then
					wMD.Tier = 2
				else
					wMD.Tier = 1				
				end
			end
			weaponMaxCond = o_scriptItem:getConditionMax()
			weaponCondLowerChance = o_scriptItem:getConditionLowerChance()
			weaponRepairedStack = item:getHaveBeenRepaired()
			soulsRequired = math.floor(weaponMaxCond * weaponCondLowerChance)
			soulsFreed = wMD.KillCount or nil
			numAugments = wMD.Augments or 0
			soulWrought = wMD.SoulWrought or nil
			local soulDenom = 200
			if soulWrought then soulDenom = 100 end
			
			local function itemStats()
				soulPower = math.min(soulsFreed / soulsRequired, 1) or 0
				tooltip.description = tooltip.description .. orange .. "Stat Modifiers: <LINE> "
				local tierColor = white
				local wTier = wMD.Tier
				if wTier then
					if wTier == 5 then
						tierColor = gold
					elseif wTier == 4 then
						tierColor = purple
					elseif wTier == 3 then
						tierColor = yellow
					elseif wTier == 2 then
						tierColor = blue
					end
				end
				
				if wMD.mdzPrefix then tooltip.description = tooltip.description .. white .. " <LINE> Weapon Quality: " .. tierColor .. wMD.mdzPrefix .. " <LINE> " end
				if wMD.mdzMinDmg then tooltip.description = tooltip.description .. green .. " <LINE> " .. string.format("%.2f", wMD.mdzMinDmg)  .. "x More Minimum Damage <LINE> " end
				if wMD.mdzMaxDmg then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzMaxDmg)  .. "x More Maximum Damage <LINE> " end
				if wMD.mdzAimingTime then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzAimingTime)  .. "x Less Aiming Time <LINE> " end
				if wMD.mdzReloadTime then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzReloadTime)  .. "x Less Reload Time <LINE> " end
				if wMD.mdzRecoilDelay then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzRecoilDelay)  .. "x Less Recoil Delay <LINE> " end
				if wMD.mdzCriticalChance then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzCriticalChance)  .. "x More Critical Chance <LINE> " end
				if wMD.mdzCritDmgMultiplier then tooltip.description = tooltip.description .. green .. string.format("%.2f", wMD.mdzCritDmgMultiplier)  .. "x More Critical Damage Multiplier <LINE> " end
				
				tooltip.description = tooltip.description .. orange .. " <LINE> SoulForge Modifiers: <LINE> "
				tooltip.description = tooltip.description .. green .. " <LINE> More Maximum Damage: " .. 1 + (math.floor(soulPower * 10)/soulDenom * numAugments/4) .. "x <LINE> "
				tooltip.description = tooltip.description .. green .. "More Critical Chance: " .. 1 + (math.floor(soulPower * 10)/soulDenom * numAugments/4) .. "x <LINE> "
				tooltip.description = tooltip.description .. green .. "More Critical Multi: " .. 1 + (math.floor(soulPower * 10)/soulDenom * numAugments/4) .. "x <LINE> "
				
				local isAugmented = wMD.Augments or nil
				
				if isAugmented then tooltip.description = tooltip.description .. white .. " <LINE> No. of Augments: " .. wMD.Augments .. " <LINE> <LINE> " end
				
				p1_desc = wMD.p1_desc or nil
				p2_desc = wMD.p2_desc or nil
				s1_desc = wMD.s1_desc or nil
				s2_desc = wMD.s2_desc or nil
				
				if p1_desc then tooltip.description = tooltip.description .. p1_desc .. " <LINE> " end
				if p2_desc then tooltip.description = tooltip.description .. p2_desc .. " <LINE> " end
				if s1_desc then tooltip.description = tooltip.description .. s1_desc .. " <LINE> " end
				if s2_desc then tooltip.description = tooltip.description .. s2_desc .. " <LINE> " end
				
			end
			
			if not soulsFreed then return end
			soulsContext = context:addOption("Soul Power: " .. soulsFreed .. "/" .. soulsRequired, item, nil, player)

			if soulsFreed ~= nil then
			
				function modifySouls(item, player, amount)
					wMD.KillCount = soulsFreed + amount
					soulsFreed = wMD.KillCount
				end

				if soulsFreed < soulsRequired then
					soulsContext.notAvailable = true;
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. "You need to free more souls. <LINE> "
					soulsContext.toolTip = tooltip
					if wMD.SoulForged then itemStats() end
				else
					submenu = ISContextMenu:getNew(context)
					context:addSubMenu(soulsContext, submenu)
					
					function updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
						local n_soulsFreed = math.max(soulsFreed - math.floor(soulsRequired/((math.min(5, weaponRepairedStack) -1)/2)),0)
						return n_soulsFreed
					end
					
					n_soulsFreed = updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
					------------------------------------------------------------------------------------------------------
					--repair stack option
					------------------------------------------------------------------------------------------------------
					new_weaponRepairStack = function(item, player)
						item:setHaveBeenRepaired(weaponRepairedStack - 1)
						wMD.KillCount = n_soulsFreed
						--soulsFreed = wMD.KillCount
					end
					
					function calcsoulDiff(soulsRequired, weaponRepairedStack)
						local soulDiff = math.floor(soulsRequired/(math.min(5, weaponRepairedStack-1) -1))*2
						return soulDiff
					end
					
					soulDiff = calcsoulDiff(soulsRequired, weaponRepairedStack)
					
					--[[if weaponRepairedStack >= 5 then
						option_repairstack = submenu:addOption("Remove 1x repair stack. (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponRepairStack, player)
					else
						option_repairstack = submenu:addOption("Requires repair stacks of 4x or greater to remove a repair stack.", item, nil, player)
					end
					
					if weaponRepairedStack < 5 then
					
						option_repairstack.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_repairstack.toolTip = tooltip
					end]]
					------------------------------------------------------------------------------------------------------
					--weapon condition option
					------------------------------------------------------------------------------------------------------
					local soulForgeMaxCondition = wMD.MaxCondition or 1.0
					local pMD = playerObj:getModData()
					local permaMaxCondition = pMD.PermaMaxConditionBonus
					if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
					weaponCurrentCondition = item:getCondition()
					weaponCondRepairAmount = math.ceil(weaponMaxCond/4 * soulForgeMaxCondition)
					weaponNewCondition = math.floor(math.min((weaponCurrentCondition + weaponCondRepairAmount), weaponMaxCond*soulForgeMaxCondition)+0.5)
					
					new_weaponCondition = function(item, player)
						item:setCondition(weaponNewCondition)
						wMD.KillCount = n_soulsFreed
						--soulsFreed = wMD.KillCount
					end
					
					--[[if weaponRepairedStack >= 5 then
						option_weaponCondition = submenu:addOption("Repair weapon to: " .. weaponNewCondition .. "/" .. math.floor(weaponMaxCond*soulForgeMaxCondition + 0.5) .. " (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponCondition, player)
					else
						option_weaponCondition = submenu:addOption("Requires repair stacks of 4x or greater to repair with souls.", item, nil, player)
					end
					
					if weaponRepairedStack < 5 or (weaponCurrentCondition == (weaponMaxCond * soulForgeMaxCondition)) then
						option_weaponCondition.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_weaponCondition.toolTip = tooltip
					end]]
					------------------------------------------------------------------------------------------------------
					--infuse weapon
					------------------------------------------------------------------------------------------------------
					local function removeWeaponsNotEquipped(playerObj, item)
						local inv = playerObj:getInventory()
						local items = inv:getItemsFromFullType(item:getFullType(), false)
						for i=1,items:size() do
							local invItem = items:get(i-1)
							if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
								if invItem ~= playerObj:getPrimaryHandItem() then
									if not invItem:getModData().SoulForged then
										playerInv:Remove(invItem)
										break
									end
								end
							end
						end
					end
					
					local function countWeapons(playerObj, item)
						local inv = playerInv
						local items = inv:getItemsFromFullType(item:getFullType(), false)
						local count = 0
						for i=1,items:size() do
							local invItem = items:get(i-1)
							if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
								if not invItem:getModData().SoulForged then
									count = count + 1
								end
							end
						end
						return count
					end
					
					local function itemToolTipMats(material, option)
						local scriptItem = ScriptManager.instance:getItem(material)
						local itemdisplayname = scriptItem:getDisplayName()
						tooltip.description = tooltip.description .. " <LINE> "
						if not playerInv:contains(material) then
							option.notAvailable = true;
							--tooltip = ISWorldObjectContextMenu.addToolTip();
							tooltip.description = tooltip.description .. red .. itemdisplayname .. " 0/1" ;
						else
							count = playerInv:getCountTypeRecurse(material)
							tooltip.description = tooltip.description .. green .. itemdisplayname .. " " .. count .. "/1" ;
						end
					end
					
					local function soulForgeWeapon(item, player)
						--print(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local weaponTier = wMD.Tier
						
						wMD.Name = "Soul Forged " .. scriptItem:getDisplayName()
						
						if wMD.soulForgeMaxDmgMulti ~= nil then
							wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti * 1.05
						else
							wMD.soulForgeMaxDmgMulti = 1.05
						end
						
						if wMD.soulForgeCritRate ~= nil then
							wMD.soulForgeCritRate = wMD.soulForgeCritRate * 1.05
						else
							wMD.soulForgeCritRate = 1.05
						end
						
						if wMD.soulForgeCritMulti ~= nil then
							wMD.soulForgeCritMulti = wMD.soulForgeCritMulti * 1.05
						else
							wMD.soulForgeCritMulti = 1.05
						end
						
						--wMD.MinDamage = scriptItem:getMinDamage()
						--wMD.MaxDamage = scriptItem:getMaxDamage()
						wMD.SoulForged = true
						if weaponTier >= 1 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT1") end
						if weaponTier >= 2 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT2") end
						if weaponTier >= 3 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT3") end
						if weaponTier >= 4 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT4") end
						--removeWeaponsNotEquipped(playerObj, item)
						--removeWeaponsNotEquipped(playerObj, item)
						local mdzPrefix = ""
						if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
						item:setName(mdzPrefix .. wMD.Name)
					end
					
					if item:isEquipped() then option_soulForgeWeapon = submenu:addOption("Soul Forge Weapon", item, soulForgeWeapon, player) else return end
					
					local forged = wMD.SoulForged or false

					if forged then
						submenu:removeOptionByName("Soul Forge Weapon")
						
						tooltip = ISWorldObjectContextMenu.addToolTip();
						option_soulForgeModifiers = submenu:addOption("Weapon Modifiers", item, nil, player)
						option_soulForgeModifiers.toolTip = tooltip
						itemStats()
						
						if item:isEquipped() then submenu1_soulForgedWeaponUpgrades = submenu:addOption("Upgrade Soul Forged Weapon", item, nil, player) end
						
						submenu1 = ISContextMenu:getNew(submenu)
						submenu:addSubMenu(submenu1_soulForgedWeaponUpgrades, submenu1)
						
						local function addUpgradeOptions(_fix, option)
							
							local _fix = _fix
							local option = option
							local description
							local scriptItem
							local new_stat
							local neg1
							local neg2
							
							if _fix == "prefix1" then
								_fix = pref1_setstat
								
								description, scriptItem, new_stat = pref1_args[option](item)
							elseif _fix == "prefix2" then
								_fix = pref2_setstat
								
								description, scriptItem, new_stat, neg1, neg2 = pref2_args[option](item)
							elseif _fix == "suffix1" then
								_fix = suff1_setstat
								
								description, scriptItem, new_stat = suff1_args[option](item)
							elseif _fix == "suffix2" then
								_fix = suff2_setstat
								
								description, scriptItem, new_stat, neg1, neg2 = suff2_args[option](item)
							else
								print("Error with prefix or suffix.")
								return
							end
							
							--print("addUpgradeOptions for " .. option .. " new_stat: " .. new_stat)
							--if _fix == pref2_setstat or _fix == suff2_setstat then print("addUpgradeOptions for " .. option .. " neg1: " .. neg1) end
							--if _fix == pref2_setstat or _fix == suff2_setstat then print("addUpgradeOptions for " .. option .. " neg2: " .. neg2) end
							
							--description, scriptItem, new_stat, neg1, neg2 = _args[option](item)
							
							local option_sm11_upgrade = submenu11:addOption(option, item, 
																		function ()
																			if _fix == pref2_setstat or _fix == suff2_setstat then _fix[option](item, description, scriptItem, new_stat, neg1, neg2) else _fix[option](item, description, scriptItem, new_stat) end
																			local wTier = wMD.Tier
																			
																			if wTier >= 1 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT1") end
																			if wTier >= 2 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT2") end
																			if wTier >= 3 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT3") end
																			if _fix == pref2_setstat or _fix == suff2_setstat then 
																				if wTier >= 4 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT4") end
																			end
																			removeWeaponsNotEquipped(playerObj, item)
																			--[[if _fix == pref2_setstat or _fix == suff2_setstat then removeWeaponsNotEquipped(playerObj, item) end]]
																		end, player)
							
							tooltip = ISWorldObjectContextMenu.addToolTip();

							tooltip.description = tooltip.description .. description .. " <LINE> "
							tooltip.description = tooltip.description .. "Materials required: <LINE> "
							option_sm11_upgrade.toolTip = tooltip
							local wTier = wMD.Tier
							
							if wTier >= 1 then itemToolTipMats("SoulForge.SoulCrystalT1", option_sm11_upgrade) end
							if wTier >= 2 then itemToolTipMats("SoulForge.SoulCrystalT2", option_sm11_upgrade) end
							if wTier >= 3 then itemToolTipMats("SoulForge.SoulCrystalT3", option_sm11_upgrade) end
							if _fix == pref2_setstat or _fix == suff2_setstat  then 
								if wTier >= 4 then itemToolTipMats("SoulForge.SoulCrystalT4", option_sm11_upgrade) end
							end
							
							--if _fix == pref2_setstat or _fix == suff2_setstat  then
								count = countWeapons(playerObj, item)
								local scriptItem = ScriptManager.instance:getItem(item:getFullType())
								if count < 1 then
									option_sm11_upgrade.notAvailable = true;
									tooltip.description = tooltip.description .. red .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. "0/1" ;
								elseif count >= 1 then
									tooltip.description = tooltip.description .. green .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. count .. "/1" ;
								end
							--end
						end
						
						if (wMD.Augments and wMD.Augments < 4) or not wMD.Augments then
							check_prefix1 = wMD.prefix1 or nil
							check_prefix2 = wMD.prefix2 or nil
							check_suffix1 = wMD.suffix1 or nil
							check_suffix2 = wMD.suffix2 or nil
							
							local function sortAndAddOptions(affix, array)
								local sortedKeys = {}
								for key, _ in pairs(array) do 
									table.insert(sortedKeys, key)  -- Store the keys in a new table
								end
								table.sort(sortedKeys)

								for _, key in ipairs(sortedKeys) do -- Use the sorted keys to iterate
									addUpgradeOptions(affix, key)  
								end
							end
							
							if not check_prefix1 then
								
								submenu11_prefix1 = submenu1:addOption("Minor Prefix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_prefix1, submenu11)
								
								sortAndAddOptions("prefix1", pref1_args)

							end
							
							if not check_prefix2 then
								
								submenu11_prefix2 = submenu1:addOption("Major Prefix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_prefix2, submenu11)
								
								sortAndAddOptions("prefix2", pref2_args)

							end
							
							if not check_suffix1 then
								
								submenu11_suffix1 = submenu1:addOption("Minor Suffix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_suffix1, submenu11)
								
								sortAndAddOptions("suffix1", suff1_args)

							end
							
							if not check_suffix2 then
								
								submenu11_suffix2 = submenu1:addOption("Major Suffix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_suffix2, submenu11)
								
								sortAndAddOptions("suffix2", suff2_args)

							end
						elseif wMD.Augments and wMD.Augments >= 4 and not wMD.SoulWrought then
							submenu:removeOptionByName("Upgrade Soul Forged Weapon")
							submenu1_soulWroughtWeaponUpgrades = submenu:addOption("Upgrade to Soul-Wrought Weapon", item, 	function()
																																local weaponFT = item:getFullType()
																																local weapon = item
																																local scriptItem = ScriptManager.instance:getItem(weaponFT)
																																local wMD = weapon:getModData()
																																local wTier = wMD.Tier
																																wMD.SoulWrought = "Soul-Wrought "
																																wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti/1.05*1.1 -- set to 10% more
																																wMD.soulForgeCritRate = wMD.soulForgeCritRate/1.05*1.1 -- set to 10% more
																																wMD.soulForgeCritMulti = wMD.soulForgeCritMulti/1.05*1.1 -- set to 10% more
																																
																																local mdzPrefix = ""
																																if wMD.mdzPrefix then mdzPrefix = wMD.mdzPrefix .. " " end
																																weapon:setName(mdzPrefix ..wMD.SoulWrought .. wMD.Name)
																																
																																if wTier >= 1 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT1") end
																																if wTier >= 2 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT2") end
																																if wTier >= 3 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT3") end
																																if wTier >= 4 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT4") end
																																playerInv:RemoveOneOf("SoulForge.SoulCrystalT5")
																																removeWeaponsNotEquipped(playerObj, item)
																																end, player)
							--submenu1_soulWroughtWeaponUpgrades.notAvailable = true
							tooltip = ISWorldObjectContextMenu.addToolTip();
							tooltip.description = tooltip.description .. white .. "Materials required: <LINE> "
							--submenu1_soulWroughtWeaponUpgrades.toolTip = tooltip
							local wTier = wMD.Tier
							
							if wTier >= 1 then itemToolTipMats("SoulForge.SoulCrystalT1", submenu1_soulWroughtWeaponUpgrades) end
							if wTier >= 2 then itemToolTipMats("SoulForge.SoulCrystalT2", submenu1_soulWroughtWeaponUpgrades) end
							if wTier >= 3 then itemToolTipMats("SoulForge.SoulCrystalT3", submenu1_soulWroughtWeaponUpgrades) end
							if wTier >= 4 then itemToolTipMats("SoulForge.SoulCrystalT4", submenu1_soulWroughtWeaponUpgrades) end
							itemToolTipMats("SoulForge.SoulCrystalT5", submenu1_soulWroughtWeaponUpgrades)
							
							local count = countWeapons(playerObj, item)
							local scriptItem = ScriptManager.instance:getItem(item:getFullType())
							if count < 1 then
								submenu1_soulWroughtWeaponUpgrades.notAvailable = true;
								tooltip.description = tooltip.description .. red .. " <LINE> " .. scriptItem:getDisplayName() .. " 0/1" ;
							elseif count >= 1 then
								tooltip.description = tooltip.description .. green .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. count .. "/1" ;
							end
							submenu1_soulWroughtWeaponUpgrades.toolTip = tooltip
						elseif wMD.Augments and wMD.Augments >= 4 and wMD.SoulWrought then
							submenu:removeOptionByName("Upgrade Soul Forged Weapon")
							
							submenu1_soulWroughtUpgrades = submenu:addOption("Upgrade Soul-Wrought Weapon", item, nil, player)
							submenu2 = ISContextMenu:getNew(submenu)
							submenu:addSubMenu(submenu1_soulWroughtUpgrades, submenu2)
							
							local function countItems(playerObj, item)
								local inv = playerObj:getInventory()
								local items = inv:getItemsFromFullType(item, false)
								local count = 0
								for i=1,items:size() do
									local invItem = items:get(i-1)
									if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
										count = count + 1
									end
								end
								return count
							end
							
							local function sw_itemToolTipMats(tooltip, material, option, quantity)
								local playerObj = getSpecificPlayer(0)
								local playerInv = playerObj:getInventory()
								local scriptItem = ScriptManager.instance:getItem(material)
								local itemdisplayname = scriptItem:getDisplayName()
								--print(scriptItem)
								tooltip.description = tooltip.description .. " <LINE> "
								if countItems(playerObj, material) < quantity then
									count = countItems(playerObj, material)
									option.notAvailable = true;
									--tooltip = ISWorldObjectContextMenu.addToolTip();
									tooltip.description = tooltip.description .. red .. itemdisplayname .. " " .. count .. "/" .. quantity ;
								else
									--count = playerInv:getCountTypeRecurse(material)
									count = countItems(playerObj, material)
									tooltip.description = tooltip.description .. green .. itemdisplayname .. " " .. count .. "/" .. quantity ;
								end
							end
							
							local shard = { "SoulForge.SoulShardT1", "SoulForge.SoulShardT2", "SoulForge.SoulShardT3", "SoulForge.SoulShardT4", "SoulForge.SoulShardT5" }
							
							local function sw_upgrade(upgrade_no, upgrade_mats, sw_ticket)
								tooltip = ISWorldObjectContextMenu.addToolTip();
								tooltip.description = tooltip.description .. " <LINE> " .. gold .. "Materials required:"
								for i=1,#upgrade_mats do
									sw_itemToolTipMats(tooltip, shard[i], upgrade_no, upgrade_mats[i])
								end
								sw_itemToolTipMats(tooltip, sw_ticket, upgrade_no, 2)
								upgrade_no.toolTip = tooltip
							end
							
							local function remove_swMats(mats)
								local playerObj = getSpecificPlayer(0)
								local playerInv = playerObj:getInventory()
								for i=1,#mats do
									for j=1,mats[i] do
										playerInv:RemoveOneOf(shard[i])
									end
								end
							end
							
							local Upgrade1MatNo = {7,6,5,4,3}
							local swUpgrade1 = submenu2:addOption("Add +1% to Minimum Damage Modifier", item, function()
																										if not wMD.soulForgeMinDmgMulti then wMD.soulForgeMinDmgMulti = 1 end
																										remove_swMats(Upgrade1MatNo)
																										playerInv:RemoveOneOf("SoulForge.MinDmgTicket")
																										playerInv:RemoveOneOf("SoulForge.MinDmgTicket")
																										wMD.soulForgeMinDmgMulti = wMD.soulForgeMinDmgMulti + 0.01
																										end, player)
							sw_upgrade(swUpgrade1, Upgrade1MatNo, "SoulForge.MinDmgTicket")
																										
							local Upgrade2MatNo = {7,6,5,4,3}
							local swUpgrade2 = submenu2:addOption("Add +1% to Maximum Damage Modifier", item, function()
																										if not wMD.soulForgeMaxDmgMulti then wMD.soulForgeMaxDmgMulti = 1 end
																										remove_swMats(Upgrade2MatNo)
																										playerInv:RemoveOneOf("SoulForge.MaxDmgTicket")
																										playerInv:RemoveOneOf("SoulForge.MaxDmgTicket")
																										wMD.soulForgeMaxDmgMulti = wMD.soulForgeMaxDmgMulti + 0.01
																										end, player)
							sw_upgrade(swUpgrade2, Upgrade2MatNo, "SoulForge.MaxDmgTicket")
																										
							local Upgrade3MatNo = {7,5,3,2}
							local swUpgrade3 = submenu2:addOption("Add +1% to Critical Chance Modifier", item, function()
																										if not wMD.soulForgeCritRate then wMD.soulForgeCritRate = 1 end
																										remove_swMats(Upgrade3MatNo)
																										playerInv:RemoveOneOf("SoulForge.CritChanceTicket")
																										wMD.soulForgeCritRate = wMD.soulForgeCritRate + 0.01
																										end, player)
							sw_upgrade(swUpgrade3, Upgrade3MatNo, "SoulForge.CritChanceTicket")
																										
							local Upgrade4MatNo = {5,4,3}
							local swUpgrade4 = submenu2:addOption("Add +1% to Critical Damage Multiplier Modifier", item, function()
																													if not wMD.soulForgeCritMulti then wMD.soulForgeCritMulti = 1 end
																													remove_swMats(Upgrade4MatNo)
																													playerInv:RemoveOneOf("SoulForge.CritMultiTicket")
																													wMD.soulForgeCritMulti = wMD.soulForgeCritMulti + 0.01
																													end, player)
							sw_upgrade(swUpgrade4, Upgrade4MatNo, "SoulForge.CritMultiTicket")
							
							local Upgrade5MatNo = {3,4,3,2}
							local swUpgrade5 = submenu2:addOption("Add +1% to Aiming Time Stat Modifier", item, function()
																											if not wMD.soulForgeAimingTime then wMD.soulForgeAimingTime = 1 end
																											remove_swMats(Upgrade5MatNo)
																											playerInv:RemoveOneOf("SoulForge.AimingTimeTicket")
																											wMD.soulForgeAimingTime = wMD.soulForgeAimingTime + 0.01
																											end, player)
							sw_upgrade(swUpgrade5, Upgrade5MatNo, "SoulForge.AimingTimeTicket")
							
							local Upgrade6MatNo = {3,4,3,2}
							local swUpgrade6 = submenu2:addOption("Add +1% to Aiming Perk Hit Chance Modifier", item, function()
																											if not wMD.soulForgeAimingPerkHitChanceModifier then wMD.soulForgeAimingPerkHitChanceModifier = 1 end
																											remove_swMats(Upgrade6MatNo)
																											playerInv:RemoveOneOf("SoulForge.AimingPerkHitTicket")
																											wMD.soulForgeAimingPerkHitChanceModifier = wMD.soulForgeAimingPerkHitChanceModifier + 0.01
																											end, player)
							sw_upgrade(swUpgrade6, Upgrade6MatNo, "SoulForge.AimingPerkHitTicket")
							
							local Upgrade7MatNo = {3,4,3,2}
							local swUpgrade7 = submenu2:addOption("Add +1% to Aiming Perk Crit Rate Modifier", item, function()
																											if not wMD.soulForgeAimingPerkCritModifier then wMD.soulForgeAimingPerkCritModifier = 1 end
																											remove_swMats(Upgrade7MatNo)
																											playerInv:RemoveOneOf("SoulForge.AimingPerkCritTicket")
																											wMD.soulForgeAimingPerkCritModifier = wMD.soulForgeAimingPerkCritModifier + 0.01
																											end, player)
							sw_upgrade(swUpgrade7, Upgrade7MatNo, "SoulForge.AimingPerkCritTicket")
							
						end
						
					elseif (weaponCurrentCondition < (weaponMaxCond) or soulsFreed < soulsRequired) then
						--print("elseif")
						option_soulForgeWeapon.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "Requires " .. soulsRequired .. " Soul Power and full weapon condition to Soul Forge. <LINE> "
						option_soulForgeWeapon.toolTip = tooltip
						--itemStats()
					else
						--option_soulForgeWeapon.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. white .. "Materials required: <LINE> "
						option_soulForgeWeapon.toolTip = tooltip
						local wTier = wMD.Tier
						
						if wTier >= 1 then itemToolTipMats("SoulForge.SoulCrystalT1", option_soulForgeWeapon) end
						if wTier >= 2 then itemToolTipMats("SoulForge.SoulCrystalT2", option_soulForgeWeapon) end
						if wTier >= 3 then itemToolTipMats("SoulForge.SoulCrystalT3", option_soulForgeWeapon) end
						if wTier >= 4 then itemToolTipMats("SoulForge.SoulCrystalT4", option_soulForgeWeapon) end
						
						--[[count = countWeapons(playerObj, item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						if count < 3 then
							option_soulForgeWeapon.notAvailable = true;
							tooltip.description = tooltip.description .. red .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. math.max(0,count-1) .. "/2" ;
						elseif count >= 3 then
							tooltip.description = tooltip.description .. green .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. count-1 .. "/2" ;
						end]]
						
					end
					------------------------------------------------------------------------------------------------------
					------------------------------------------------------------------------------------------------------
				end
			end
		end
		break
	end
end

Events.OnFillInventoryObjectContextMenu.Add(SoulContextSDRanged)

function RangedSoulCountSD(character, handWeapon)
	if getSpecificPlayer(0) ~= character then return end
	if not handWeapon then return end
	if handWeapon:getType() == "BareHands" then return end

	local player = character
	local pMD = player:getModData()
	local tierzone = checkZone()

	if player ~= nil and handWeapon ~= nil and handWeapon:isRanged() and player:getPrimaryHandItem() ~= nil then
		local wMD = handWeapon:getModData()
		local weaponSouls = wMD.KillCount or nil
		local weaponPlayerKC = wMD.PlayerKills or nil
		
		if weaponSouls == nil then
			wMD.KillCount = 0 --SD write initial killcount to weapon (zero). in case a weapon does not have an internal kill counter.
			weaponSouls = wMD.KillCount
		end
		
		if weaponPlayerKC == nil then
			wMD.PlayerKills = KillCountSD(player) --SD snapshot kill count of player who equips weapon. in case a weapon does not have a snapshot kill count for the player.
			weaponPlayerKC = wMD.PlayerKills
		end
		
		--character:Say("old kills: " .. weaponSouls)
		--character:Say("old player kills: " .. weaponPlayerKC)
		local n_killcount = KillCountSD(player) --updated kill count

		
		local killDiff = n_killcount - weaponPlayerKC -- calculate difference in kill count
		--character:Say("kill diff: " .. killDiff)
		
		if killDiff > 0 then
			local SoulThirstValue = pMD.SoulThirstValue or 0
			local SoulThirst = 0
			local pMD = player:getModData();
			local permaSoulThirst = pMD.PermaSoulThirstValue
			if permaSoulThirst then SoulThirstValue = SoulThirstValue + permaSoulThirst end
			if SoulThirstValue and SoulThirstValue > 0 then
				if ZombRand(0,100) <= SoulThirstValue then
					SoulThirst = 1
					HaloTextHelper.addTextWithArrow(character, "+" .. math.floor(killDiff*(math.floor(SoulThirst+1.25))-killDiff+0.5) .. " Additional Souls Gained", true, HaloTextHelper.getColorGreen());
				end
			end
			wMD.KillCount = weaponSouls + killDiff*(math.floor(SoulThirst+1.25)) + killDiff*math.floor(tierzone/2+0.25) --calculate and set new kill counter on weapon, 
			wMD.PlayerKills = n_killcount --update player kill counter on weapon
			--character:Say("new kills: " .. wMD.KillCount)
			
			--character:Say("new player kills: " .. wMD.PlayerKills)
		end
	
	end

end
Events.OnPlayerAttackFinished.Add(RangedSoulCountSD)
