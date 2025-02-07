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

local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "

local white = " <RGB:1,1,1> "

local function colorItem(augmentNo)
    if augmentNo >= 4 then
        return gold
    elseif augmentNo == 3 then
        return purple
    elseif augmentNo == 2 then
        return yellow
    elseif augmentNo == 1 then
        return blue
    else
        return white
    end
end

local function space(str)
    return str ~= "" and " " or ""
end

local function weaponName(weaponModData, scriptItem)
	local prefix = ""
	if weaponModData.prefix1 and weaponModData.prefix1 ~= "" then
		prefix = prefix .. weaponModData.prefix1 .. space(weaponModData.prefix1)
	end
	if weaponModData.prefix2 and weaponModData.prefix2 ~= "" then
		prefix = prefix .. weaponModData.prefix2 .. "'s" .. space(weaponModData.prefix2)
	end
	
	local suffix = ""
	if weaponModData.suffix1 and weaponModData.suffix1 ~= "" or 
	   weaponModData.suffix2 and weaponModData.suffix2 ~= "" then

		suffix = " of the " .. (weaponModData.suffix1 or "") .. " " .. (weaponModData.suffix2 or "")
	end
	
    --local color = colorItem(weaponModData.Augments)
	local name =  prefix .. scriptItem:getDisplayName() .. suffix
    return name
end

local function isAugmented()
	local isAugmented = weaponModData.Augments or nil
	if isAugmented then
		weaponModData.Augments = isAugmented + 1
	else
		weaponModData.Augments = 1
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
	elseif statName == "getConditionMax" then
		return multiplier
	elseif statName == "getConditionLowerChance" then
		return multiplier
	elseif statName == "getEnduranceMod" then
		return (scriptItem:getEnduranceMod() * multiplier)
	elseif statName == "getMaxHitCount" then
		return (scriptItem:getMaxHitCount() + multiplier)
	end
end

local function getStat(_fix, name, statName, multiplier, desc)
    return function(item)
        local scriptItem = ScriptManager.instance:getItem(item:getFullType())
		
		local n_stat = checkStatName(scriptItem, statName, multiplier)
		
        --print(name .. " arg: " .. statName .. " = " .. n_stat)
		
        local description = gold .. _fix .. " Modifier: " .. name .. green .. 
                            " <LINE> " .. 
                            string.format("%.0f", (multiplier * 100) - 100) .. 
                            desc

        return description, scriptItem, n_stat
    end
end

local function setStat(upgradeName, statName, descno, description, scriptItem, n_stat)
    return function(item, description, scriptItem, n_stat)
		local weaponModData = item:getModData()
        --print(upgradeName .. "arg: " .. statName .. " = " .. n_stat)  -- Debugging output
		if descno     == "p1_desc" then
            weaponModData.prefix1 = upgradeName
        elseif descno == "s1_desc" then
            weaponModData.suffix1 = upgradeName
        elseif descno == "p2_desc" then
            weaponModData.prefix2 = upgradeName
        elseif descno == "s2_desc" then
            weaponModData.suffix2 = upgradeName
        else
            print("No prefix or suffix in args.")
            return
        end
		
		if statName == "getMinDamage" then
			if weaponModData.soulForgeMinDmgMulti ~= nil then
				weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * n_stat
			else
				weaponModData.soulForgeMinDmgMulti = n_stat -- Set the default value if nil
			end
		elseif statName == "getMaxDamage" then
			if weaponModData.soulForgeMaxDmgMulti ~= nil then
				weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * n_stat
			else
				weaponModData.soulForgeMaxDmgMulti = n_stat
			end
		elseif statName == "getCriticalChance" then
			if weaponModData.soulForgeCritRate ~= nil then
				weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate * n_stat
			else
				weaponModData.soulForgeCritRate = n_stat
			end
		elseif statName == "getCritDmgMultiplier" then
			if weaponModData.soulForgeCritMulti ~= nil then
				weaponModData.soulForgeCritMulti = weaponModData.soulForgeCritMulti * n_stat
			else
				weaponModData.soulForgeCritMulti = n_stat
			end
		elseif statName == "getConditionMax" then
			if weaponModData.MaxCondition ~= nil then
				weaponModData.MaxCondition = weaponModData.MaxCondition * n_stat
			else
				weaponModData.MaxCondition = n_stat
			end
			--print("Max Condition modifier: " .. weaponModData.MaxCondition)
			item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
		elseif statName == "getConditionLowerChance" then
			if weaponModData.ConditionLowerChance ~= nil then
				weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * n_stat
			else
				weaponModData.ConditionLowerChance = n_stat
			end
			--print("Condition Lower Chance modifier: " .. weaponModData.ConditionLowerChance)
			item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
		elseif statName == "getEnduranceMod" then
			weaponModData.EnduranceMod = item:setEnduranceMod(n_stat)
			item:setEnduranceMod(n_stat)
		end

        isAugmented()
        weaponModData.Name = weaponName(weaponModData, scriptItem)
		item:setName(weaponModData.Name)
        weaponModData[descno] = description
    end
end

local function posDesc(statName)
	if statName 	== "getMinDamage" then 
		return "% More Minimum Damage <LINE> "
	elseif statName == "getMaxDamage" then 
		return "% More Maximum Damage <LINE> "
	elseif statName == "getCriticalChance" then
		return "% More Critical Chance <LINE> "
	elseif statName == "getCritDmgMultiplier" then
		return "% More Critical Damage Multiplier <LINE> "
	elseif statName == "getConditionMax" then
		return "% More Weapon Condition <LINE> "
	elseif statName == "getConditionLowerChance" then
		return "% More Weapon Condition Lower Chance <LINE> "
	elseif statName == "getEnduranceMod" then
		return "% Less Endurance Used <LINE> "
	elseif statName == "getMaxHitCount" then
		return " : New Max Hit Count"
	end
end

local function negDesc(statName)
	if statName 	== "getMinDamage" then 
		return "% Less Minimum Damage <LINE> "
	elseif statName == "getMaxDamage" then 
		return "% Less Maximum Damage <LINE> "
	elseif statName == "getCriticalChance" then
		return "% Less Critical Chance <LINE> "
	elseif statName == "getCritDmgMultiplier" then
		return "% Less Critical Damage Multiplier <LINE> "
	elseif statName == "getConditionMax" then
		return "% Less Weapon Condition <LINE> "
	elseif statName == "getConditionLowerChance" then
		return "% Less Weapon Condition Lower Chance <LINE> "
	elseif statName == "getEnduranceMod" then
		return "% More Endurance Used <LINE> "
	elseif statName == "getMaxHitCount" then
		return " : New Max Hit Count"
	end
end

local pref1_args = {
	Brave = getStat("Prefix", "Brave", "getMinDamage", 1.2, posDesc("getMinDamage")),
	Cromulent = getStat("Prefix", "Cromulent", "getConditionLowerChance", 1.1, posDesc("getConditionLowerChance")),
	Desensitized = getStat("Prefix", "Desensitized", "getCriticalChance", 1.15, posDesc("getCriticalChance")),
	Embiggened = getStat("Prefix", "Embiggened", "getCritDmgMultiplier", 1.1, posDesc("getCritDmgMultiplier")),
	Enraged = getStat("Prefix", "Enraged", "getMaxDamage", 1.1, posDesc("getMaxDamage")),
	Nonplussed = getStat("Prefix", "Nonplussed", "getConditionMax", 1.1, posDesc("getConditionMax")),
}

local pref1_setstat = {
	Brave = setStat("Brave", "getMinDamage", "p1_desc", description, scriptItem, n_stat),
	Cromulent = setStat("Cromulent", "getConditionLowerChance", "p1_desc", description, scriptItem, n_stat),
	Desensitized = setStat("Desensitized", "getCriticalChance", "p1_desc", description, scriptItem, n_stat),
	Embiggened = setStat("Embiggened", "getCritDmgMultiplier", "p1_desc", description, scriptItem, n_stat),
	Enraged = setStat("Enraged", "getMaxDamage", "p1_desc", description, scriptItem, n_stat),
	Nonplussed = setStat("Nonplussed", "getConditionMax", "p1_desc", description, scriptItem, n_stat),
}

local suff1_args = {
	Careful = getStat("Suffix", "Careful", "getConditionLowerChance", 1.1, posDesc("getConditionLowerChance")),
	Dedicated = getStat("Suffix", "Dedicated", "getMinDamage", 1.2, posDesc("getMinDamage")),
	Enlightened = getStat("Suffix", "Enlightened", "getMaxDamage", 1.1, posDesc("getMaxDamage")),
	Indifferent = getStat("Suffix", "Indifferent", "getConditionMax", 1.1, posDesc("getConditionMax")),
	Malding = getStat("Suffix", "Malding", "getCritDmgMultiplier", 1.1, posDesc("getCritDmgMultiplier")),
	Savage = getStat("Suffix", "Savage", "getCriticalChance", 1.15, posDesc("getCriticalChance")),
}

local suff1_setstat = {
	Careful = setStat("Careful", "getConditionLowerChance", "s1_desc", description, scriptItem, n_stat),
	Dedicated = setStat("Dedicated", "getMinDamage", "s1_desc", description, scriptItem, n_stat),
	Enlightened = setStat("Enlightened", "getMaxDamage", "s1_desc", description, scriptItem, n_stat),
	Indifferent = setStat("Indifferent", "getConditionMax", "s1_desc", description, scriptItem, n_stat),
	Malding = setStat("Malding", "getCritDmgMultiplier", "s1_desc", description, scriptItem, n_stat),
	Savage = setStat("Savage", "getCriticalChance", "s1_desc", description, scriptItem, n_stat),
}

local pref2_args = {

    Absolutionist =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.1, 1.15, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						local maxCondition = sm3

						local description = gold .. "Prefix Modifer: Absolutionist" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxDamage, minDamage, maxCondition
					end,
	
	Decimator	 =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.1, 1.1, 1
						
						local maxDamage = sm1
						local conditionLowerChance = sm2
						local maxCondition = sm3

						local description = gold .. "Prefix Modifer: Decimator" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, conditionLowerChance, maxCondition
					end,

	Deviant 	=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.1, 1
						
						local soulForgeCritRate = sm1
						local maxDamage = sm2
						local conditionLowerChance = sm3

						local description = gold .. "Prefix Modifer: Deviant" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Critical Chance" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Maximum Damage <LINE> "
						return description, scriptItem, soulForgeCritRate, maxDamage, conditionLowerChance
					end,
					
	Perfectionist =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.1, 1.15, 1
						
						local maxCondition = sm1
						local minDamage = sm2
						local maxDamage = sm3

						local description = gold .. "Prefix Modifer: Perfectionist" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Weapon Condition" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxCondition, minDamage, maxDamage
					end,
	
	Reaver 		=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.1, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						local conditionLowerChance = sm3

						local description = gold .. "Prefix Modifer: Reaver" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxDamage, minDamage, conditionLowerChance
					end,
	
	Zealot 		=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.2, 1
						
						local soulForgeCritRate = sm1
						local soulForgeCritMulti = sm2
						local conditionLowerChance = sm3

						local description = gold .. "Prefix Modifer: Zealot" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Critical Chance" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Critical Damage Multiplier <LINE> "
						return description, scriptItem, soulForgeCritRate, soulForgeCritMulti, conditionLowerChance
					end,
}

local pref2_setstat = {
    Absolutionist =	function(item, description, scriptItem, maxDamage, minDamage, maxCondition)
						
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if weaponModData.MaxCondition ~= nil then
							weaponModData.MaxCondition = weaponModData.MaxCondition * maxCondition
						else
							weaponModData.MaxCondition = maxCondition
						end
						
						weaponModData.prefix2 = "Absolutionist"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description
						
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setName(weaponModData.Name)
					end,

    Decimator =	function(item, description, scriptItem, maxDamage, conditionLowerChance, maxCondition)
												
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end

						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						
						if weaponModData.MaxCondition ~= nil then
							weaponModData.MaxCondition = weaponModData.MaxCondition * maxCondition
						else
							weaponModData.MaxCondition = maxCondition
						end

						weaponModData.prefix2 = "Decimator"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description

						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setName(weaponModData.Name)
					end,

    Deviant =	function(item, description, scriptItem, soulForgeCritRate, maxDamage, conditionLowerChance)
												
						if weaponModData.soulForgeCritRate ~= nil then
							weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate * soulForgeCritRate
						else
							weaponModData.soulForgeCritRate = soulForgeCritRate -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						

						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						

						weaponModData.prefix2 = "Deviant"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description

						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,

    Perfectionist =	function(item, description, scriptItem, maxCondition, minDamage, maxDamage)
												
						if weaponModData.MaxCondition ~= nil then
							weaponModData.MaxCondition = weaponModData.MaxCondition * maxCondition
						else
							weaponModData.MaxCondition = maxCondition
						end
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						weaponModData.prefix2 = "Perfectionist"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description

						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setName(weaponModData.Name)
					end,
					
    Reaver =	function(item, description, scriptItem, maxDamage, minDamage, conditionLowerChance)
												
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						
						weaponModData.prefix2 = "Reaver"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description
						
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
	
	Zealot =	function(item, description, scriptItem, soulForgeCritRate, soulForgeCritMulti, conditionLowerChance)
												
						if weaponModData.soulForgeCritRate ~= nil then
							weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate * soulForgeCritRate
						else
							weaponModData.soulForgeCritRate = soulForgeCritRate -- Set the default value if nil
						end
						
						if weaponModData.soulForgeCritMulti ~= nil then
							weaponModData.soulForgeCritMulti = weaponModData.soulForgeCritMulti * soulForgeCritMulti
						else
							weaponModData.soulForgeCritMulti = soulForgeCritMulti -- Set the default value if nil
						end
						
						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						
						weaponModData.prefix2 = "Zealot"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.p2_desc = description
						
						item:setName(weaponModData.Name)
					end,
}

local suff2_args = {
    SundayDriver =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.15, 1
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local minDamage = sm2
						local EnduranceMod = scriptItem:getEnduranceMod() * sm3
						
						local description = gold .. "Suffix Modifer: Sunday Driver" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100)) .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxHitCount, minDamage, EnduranceMod
					end,

    FilthyCasual =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1, 1.15
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local EnduranceMod = scriptItem:getEnduranceMod() * sm2
						local maxDamage = sm3
						
						local description = gold .. "Suffix Modifer: Filthy Casual" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Maximum Damage <LINE> "
						return description, scriptItem, maxHitCount, EnduranceMod, maxDamage
					end,

    ApocalypseEnjoyer =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.15, 1.1, 1
						
						local maxDamage = sm1
						local maxCondition = sm2
						local conditionLowerChance = sm3
						
						local description = gold .. "Suffix Modifer: Apocalypse Enjoyer" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Maximum Weapon Condition <LINE> "
						return description, scriptItem, maxDamage, maxCondition, conditionLowerChance
					end,
					
	AscendedPath =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.15, 1, 1.1
						
						local maxDamage = sm1
						local minDamage = sm2
						local conditionLowerChance = sm3
						
						local description = gold .. "Suffix Modifer: Ascended Path" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, minDamage, conditionLowerChance
					end,
	
	ToxicProgenitor=function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.15, 1, 1.2
						
						local maxDamage = sm1
						local minDamage = sm2
						local soulForgeCritRate = sm3
						
						local description = gold .. "Suffix Modifer: Toxic Progenitor" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Critical Chance <LINE> "
						return description, scriptItem, maxDamage, minDamage, soulForgeCritRate
					end,
					
	UnhingedTryhard=function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1, 1.2
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local minDamage = sm2
						local soulForgeCritRate = sm3
						
						local description = gold .. "Suffix Modifer: Unhinged Tryhard" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Critical Chance <LINE> "
						return description, scriptItem, maxHitCount, minDamage, soulForgeCritRate
					end,
}

local suff2_setstat = {
    SundayDriver =	function(item, description, scriptItem, maxHitCount, minDamage, EnduranceMod)
												
						weaponModData.MaxHitCount = maxHitCount
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end

						local isEnduranceMod = weaponModData.EnduranceMod or nil
						if isEnduranceMod then
							weaponModData.EnduranceMod = item:setEnduranceMod(EnduranceMod)
						else
							weaponModData.EnduranceMod = scriptItem:getEnduranceMod()
						end
						weaponModData.suffix2 = "Sunday Driver"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description
						
						item:setMaxHitCount(maxHitCount)
						item:setEnduranceMod(EnduranceMod)
						item:setName(weaponModData.Name)
					end,

    FilthyCasual =	function(item, description, scriptItem, maxHitCount, EnduranceMod, maxDamage)
												
						weaponModData.MaxHitCount = maxHitCount
						
						local isEnduranceMod = weaponModData.EnduranceMod or nil
						if isEnduranceMod then
							weaponModData.EnduranceMod = item:setEnduranceMod(EnduranceMod)
						else
							weaponModData.EnduranceMod = scriptItem:getEnduranceMod()
						end
						
						
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end

						weaponModData.suffix2 = "Filthy Casual"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description
						
						item:setMaxHitCount(maxHitCount)
						item:setEnduranceMod(EnduranceMod)
						item:setName(weaponModData.Name)
					end,

    ApocalypseEnjoyer =	function(item, description, scriptItem, maxDamage, maxCondition, conditionLowerChance)
												
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						
						if weaponModData.MaxCondition ~= nil then
							weaponModData.MaxCondition = weaponModData.MaxCondition * maxCondition
						else
							weaponModData.MaxCondition = maxCondition
						end

						weaponModData.suffix2 = "Apocalypse Enjoyer"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description

						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
					
    AscendedPath =	function(item, description, scriptItem, maxDamage, minDamage, conditionLowerChance)
												
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * conditionLowerChance
						else
							weaponModData.ConditionLowerChance = conditionLowerChance
						end
						weaponModData.suffix2 = "Ascended Path"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description
						
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
	
	ToxicProgenitor=function(item, description, scriptItem, maxHitCount, minDamage, soulForgeCritRate)
												
						if weaponModData.soulForgeMaxDmgMulti ~= nil then
							weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti * maxDamage
						else
							weaponModData.soulForgeMaxDmgMulti = maxDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeCritRate ~= nil then
							weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate * soulForgeCritRate
						else
							weaponModData.soulForgeCritRate = soulForgeCritRate
						end
						weaponModData.suffix2 = "Toxic Progenitor"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description
						
						item:setName(weaponModData.Name)
					end,
					
	UnhingedTryhard=function(item, description, scriptItem, maxHitCount, minDamage, soulForgeCritRate)
												
						weaponModData.MaxHitCount = maxHitCount
						
						if weaponModData.soulForgeMinDmgMulti ~= nil then
							weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti * minDamage
						else
							weaponModData.soulForgeMinDmgMulti = minDamage -- Set the default value if nil
						end
						
						if weaponModData.soulForgeCritRate ~= nil then
							weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate * soulForgeCritRate
						else
							weaponModData.soulForgeCritRate = soulForgeCritRate
						end
						weaponModData.suffix2 = "Unhinged Tryhard"
						
						isAugmented()
						
						weaponModData.Name = weaponName(weaponModData, scriptItem)
						weaponModData.s2_desc = description
						
						item:setName(weaponModData.Name)
					end,
}

local function SoulContextSD(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:IsWeapon() and not item:isRanged() then
			weaponModData = item:getModData()
			local o_scriptItem = ScriptManager.instance:getItem(item:getFullType())
			if not weaponModData.Tier then
				local maxDmg = o_scriptItem:getMaxDamage()
				if maxDmg >= 5.25 then
					weaponModData.Tier = 5
				elseif maxDmg >= 4.375 then
					weaponModData.Tier = 4
				elseif maxDmg >= 3.5 then
					weaponModData.Tier = 3
				elseif maxDmg >= 2.625 then
					weaponModData.Tier = 2
				else
					weaponModData.Tier = 1
				end
			end
			weaponMaxCond = o_scriptItem:getConditionMax()
			weaponCondLowerChance = o_scriptItem:getConditionLowerChance()
			weaponRepairedStack = item:getHaveBeenRepaired()
			soulsRequired = math.floor(weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage())
			soulsFreed = weaponModData.KillCount or nil
			numAugments = weaponModData.Augments or 0
			soulWrought = weaponModData.SoulWrought or nil
			baseMaxCond = "10"
			if soulWrought then baseMaxCond = "50" end
			
			local function itemStats()
				soulPower = math.min(soulsFreed / soulsRequired, 1) or 0
				tooltip.description = tooltip.description .. green .. "Stat modifiers to weapon: <LINE> "
				tooltip.description = tooltip.description .. green .. " <LINE> Extra Base Maximum Damage: +" .. math.floor(soulPower * 10)/10 * numAugments/4 .. " <LINE> "
				tooltip.description = tooltip.description .. green .. "Extra Base Critical Chance: +" .. math.floor(soulPower * 50)/10 * numAugments/4 .. "% <LINE> "
				tooltip.description = tooltip.description .. green .. "Extra Base Critical Multi: +" .. math.floor(soulPower * 50)/100 * numAugments/4 .. "x <LINE> "
				tooltip.description = tooltip.description .. green .. "Extra Base Maximum Condition: +" .. baseMaxCond .. "% <LINE> "
				tooltip.description = tooltip.description .. green .. "Extra Base Condition Lower Chance: +" .. baseMaxCond .. "% <LINE> "
				
				tooltip.description = tooltip.description .. white .. " <LINE> Base Endurance Mod: " .. math.ceil(item:getEnduranceMod()*100)/100
				if weaponModData.EnduranceMod then tooltip.description = tooltip.description .. white .. " <LINE> SoulForged Endurance Modifier: " .. weaponModData.EnduranceMod end
				
				local isAugmented = weaponModData.Augments or nil
				
				if isAugmented then tooltip.description = tooltip.description .. white .. " <LINE> No. of Augments: " .. weaponModData.Augments .. " <LINE> <LINE> " end
				
				p1_desc = weaponModData.p1_desc or nil
				p2_desc = weaponModData.p2_desc or nil
				s1_desc = weaponModData.s1_desc or nil
				s2_desc = weaponModData.s2_desc or nil
				
				if p1_desc then tooltip.description = tooltip.description .. p1_desc .. " <LINE> " end
				if p2_desc then tooltip.description = tooltip.description .. p2_desc .. " <LINE> " end
				if s1_desc then tooltip.description = tooltip.description .. s1_desc .. " <LINE> " end
				if s2_desc then tooltip.description = tooltip.description .. s2_desc .. " <LINE> " end
				
			end
			
			if not soulsFreed then return end
			soulsContext = context:addOption("Soul Power: " .. soulsFreed .. "/" .. soulsRequired, item, nil, player)

			if soulsFreed ~= nil then
			
				function modifySouls(item, player, amount)
					weaponModData.KillCount = soulsFreed + amount
					soulsFreed = weaponModData.KillCount
				end

				if soulsFreed < soulsRequired then
					soulsContext.notAvailable = true;
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. "You need to free more souls. <LINE> "
					soulsContext.toolTip = tooltip
					if weaponModData.SoulForged then itemStats() end
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
						weaponModData.KillCount = n_soulsFreed
						--soulsFreed = weaponModData.KillCount
					end
					
					function calcsoulDiff(soulsRequired, weaponRepairedStack)
						local soulDiff = math.floor(soulsRequired/(math.min(5, weaponRepairedStack-1) -1))*2
						return soulDiff
					end
					
					soulDiff = calcsoulDiff(soulsRequired, weaponRepairedStack)
					
					if weaponRepairedStack >= 5 then
						option_repairstack = submenu:addOption("Remove 1x repair stack. (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponRepairStack, player)
					else
						option_repairstack = submenu:addOption("Requires repair stacks of 4x or greater to remove a repair stack.", item, nil, player)
					end
					
					if weaponRepairedStack < 5 then
					
						option_repairstack.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_repairstack.toolTip = tooltip
					end
					------------------------------------------------------------------------------------------------------
					--weapon condition option
					------------------------------------------------------------------------------------------------------
					local soulForgeMaxCondition = weaponModData.MaxCondition or 1.0
					local pMD = playerObj:getModData()
					local permaMaxCondition = pMD.PermaMaxConditionBonus
					if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
					weaponCurrentCondition = item:getCondition()
					weaponCondRepairAmount = math.ceil(weaponMaxCond/4 * soulForgeMaxCondition)
					weaponNewCondition = math.floor(math.min((weaponCurrentCondition + weaponCondRepairAmount), weaponMaxCond*soulForgeMaxCondition)+0.5)
					
					new_weaponCondition = function(item, player)
						item:setCondition(weaponNewCondition)
						weaponModData.KillCount = n_soulsFreed
						--soulsFreed = weaponModData.KillCount
					end
					
					if weaponRepairedStack >= 5 then
						option_weaponCondition = submenu:addOption("Repair weapon to: " .. weaponNewCondition .. "/" .. math.floor(weaponMaxCond*soulForgeMaxCondition + 0.5) .. " (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponCondition, player)
					else
						option_weaponCondition = submenu:addOption("Requires repair stacks of 4x or greater to repair with souls.", item, nil, player)
					end
					
					if weaponRepairedStack < 5 or (weaponCurrentCondition == (weaponMaxCond * soulForgeMaxCondition)) then
						option_weaponCondition.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_weaponCondition.toolTip = tooltip
					end
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
						
						local weaponTier = weaponModData.Tier
						
						weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName()
						
						if weaponModData.MaxCondition ~= nil then
							weaponModData.MaxCondition = weaponModData.MaxCondition * 1.1
						else
							weaponModData.MaxCondition = 1.1
						end
						--print("Max Condition modifier: " .. weaponModData.MaxCondition)
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						
						if weaponModData.ConditionLowerChance ~= nil then
							weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.1
						else
							weaponModData.ConditionLowerChance = 1.1
						end
						--print("Condition Lower Chance modifier: " .. weaponModData.ConditionLowerChance)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						
						--weaponModData.MinDamage = scriptItem:getMinDamage()
						--weaponModData.MaxDamage = scriptItem:getMaxDamage()
						weaponModData.SoulForged = true
						if weaponTier >= 1 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT1") end
						if weaponTier >= 2 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT2") end
						if weaponTier >= 3 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT3") end
						if weaponTier >= 4 then playerInv:RemoveOneOf("SoulForge.SoulCrystalT4") end
						--removeWeaponsNotEquipped(playerObj, item)
						--removeWeaponsNotEquipped(playerObj, item)
						item:setName(weaponModData.Name)
					end
					
					if item:isEquipped() then option_soulForgeWeapon = submenu:addOption("Soul Forge Weapon", item, soulForgeWeapon, player) else return end
					
					local forged = weaponModData.SoulForged or false

					if forged then
						submenu:removeOptionByName("Soul Forge Weapon")
						
						tooltip = ISWorldObjectContextMenu.addToolTip();
						option_soulForgeModifiers = submenu:addOption("Soul Forged Modifiers", item, nil, player)
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
																			local wTier = weaponModData.Tier
																			
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
							local wTier = weaponModData.Tier
							
							if wTier >= 1 then itemToolTipMats("SoulForge.SoulCrystalT1", option_sm11_upgrade) end
							if wTier >= 2 then itemToolTipMats("SoulForge.SoulCrystalT2", option_sm11_upgrade) end
							if wTier >= 3 then itemToolTipMats("SoulForge.SoulCrystalT3", option_sm11_upgrade) end
							if _fix == pref2_setstat or _fix == suff2_setstat  then 
								if wTier >= 5 then itemToolTipMats("SoulForge.SoulCrystalT4", option_sm11_upgrade) end
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
						
						if (weaponModData.Augments and weaponModData.Augments < 4) or not weaponModData.Augments then
							check_prefix1 = weaponModData.prefix1 or nil
							check_prefix2 = weaponModData.prefix2 or nil
							check_suffix1 = weaponModData.suffix1 or nil
							check_suffix2 = weaponModData.suffix2 or nil
							
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
						elseif weaponModData.Augments and weaponModData.Augments >= 4 and not weaponModData.SoulWrought then
							submenu:removeOptionByName("Upgrade Soul Forged Weapon")
							submenu1_soulWroughtWeaponUpgrades = submenu:addOption("Upgrade to Soul-Wrought Weapon", item, 	function()
																																local weaponFT = item:getFullType()
																																local weapon = item
																																local scriptItem = ScriptManager.instance:getItem(weaponFT)
																																local weaponModData = weapon:getModData()
																																local wTier = weaponModData.Tier
																																weaponModData.SoulWrought = "Soul-Wrought "
																																weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance/1.1*1.5 -- set to 50% more
																																weaponModData.MaxCondition = weaponModData.MaxCondition/1.1*1.5 -- set to 50% more
																																weapon:setName(weaponModData.SoulWrought .. weaponModData.Name)
																																weapon:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
																																weapon:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
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
							local wTier = weaponModData.Tier
							
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
						elseif weaponModData.Augments and weaponModData.Augments >= 4 and weaponModData.SoulWrought then
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
								sw_itemToolTipMats(tooltip, sw_ticket, upgrade_no, 1)
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

							
							local Upgrade1MatNo = {6,4,3,2,2}
							local swUpgrade1 = submenu2:addOption("Add +1% to Minimum Damage Modifier", item, function()
																										if not weaponModData.soulForgeMinDmgMulti then weaponModData.soulForgeMinDmgMulti = 1 end
																										remove_swMats(Upgrade1MatNo)
																										playerInv:RemoveOneOf("SoulForge.MinDmgTicket")
																										weaponModData.soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti + 0.01
																										end, player)
							sw_upgrade(swUpgrade1, Upgrade1MatNo, "SoulForge.MinDmgTicket")
																										
							local Upgrade2MatNo = {8,6,5}
							local swUpgrade2 = submenu2:addOption("Add +1% to Maximum Damage Modifier", item, function()
																										if not weaponModData.soulForgeMaxDmgMulti then weaponModData.soulForgeMaxDmgMulti = 1 end
																										remove_swMats(Upgrade2MatNo)
																										playerInv:RemoveOneOf("SoulForge.MaxDmgTicket")
																										weaponModData.soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti + 0.01
																										end, player)
							sw_upgrade(swUpgrade2, Upgrade2MatNo, "SoulForge.MaxDmgTicket")
																										
							local Upgrade3MatNo = {7,5,3,2}
							local swUpgrade3 = submenu2:addOption("Add +1% to Critical Chance Modifier", item, function()
																										if not weaponModData.soulForgeCritRate then weaponModData.soulForgeCritRate = 1 end
																										remove_swMats(Upgrade3MatNo)
																										playerInv:RemoveOneOf("SoulForge.CritChanceTicket")
																										weaponModData.soulForgeCritRate = weaponModData.soulForgeCritRate + 0.01
																										end, player)
							sw_upgrade(swUpgrade3, Upgrade3MatNo, "SoulForge.CritChanceTicket")
																										
							local Upgrade4MatNo = {5,4,3}
							local swUpgrade4 = submenu2:addOption("Add +1% to Critical Damage Multiplier Modifier", item, function()
																													if not weaponModData.soulForgeCritMulti then weaponModData.soulForgeCritMulti = 1 end
																													remove_swMats(Upgrade4MatNo)
																													playerInv:RemoveOneOf("SoulForge.CritMultiTicket")
																													weaponModData.soulForgeCritMulti = weaponModData.soulForgeCritMulti + 0.01
																													end, player)
							sw_upgrade(swUpgrade4, Upgrade4MatNo, "SoulForge.CritMultiTicket")
																													
							local Upgrade5MatNo = {8,7,6,5,2}
							local swUpgrade5 = submenu2:addOption("Add -0.1% to Endurance Usage Modifier", item, function()
																											if not weaponModData.EnduranceMod then weaponModData.EnduranceMod = o_scriptItem:getEnduranceMod() end
																											remove_swMats(Upgrade5MatNo)
																											playerInv:RemoveOneOf("SoulForge.EnduranceModTicket")
																											weaponModData.EnduranceMod = weaponModData.EnduranceMod - 0.001
																											end, player)
							sw_upgrade(swUpgrade5, Upgrade5MatNo, "SoulForge.EnduranceModTicket")
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
						local wTier = weaponModData.Tier
						
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

Events.OnFillInventoryObjectContextMenu.Add(SoulContextSD) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option

function SoulCountSD(character, handWeapon)
	if character ~= getSpecificPlayer(0) then return end

	if handWeapon:getType() == "BareHands" then return end

	local player = character
	local pMD = player:getModData()
	local tierzone = checkZone()

	if player ~= nil and handWeapon ~= nil and not handWeapon:isRanged() and player:getPrimaryHandItem() ~= nil then
		local weaponModData = handWeapon:getModData()
		local weaponSouls = weaponModData.KillCount or nil
		local weaponPlayerKC = weaponModData.PlayerKills or nil
		
		if weaponSouls == nil then
			weaponModData.KillCount = 0 --SD write initial killcount to weapon (zero). in case a weapon does not have an internal kill counter.
			weaponSouls = weaponModData.KillCount
		end
		
		if weaponPlayerKC == nil then
			weaponModData.PlayerKills = KillCountSD(player) --SD snapshot kill count of player who equips weapon. in case a weapon does not have a snapshot kill count for the player.
			weaponPlayerKC = weaponModData.PlayerKills
		end
		
		--character:Say("old kills: " .. weaponSouls)
		--character:Say("old player kills: " .. weaponPlayerKC)
		local n_killcount = KillCountSD(player) --updated kill count

		
		local killDiff = math.floor(n_killcount - weaponPlayerKC + 0.5) -- calculate difference in kill count
		--character:Say("kill diff: " .. killDiff)
		
		if killDiff > 0 then
			local SoulThirstValue = pMD.SoulThirstValue or 0
			local SoulThirst = 0
			local pMD = player:getModData();
			local permaSoulThirst = pMD.PermaSoulThirstValue
			if permaSoulThirst then SoulThirstValue = math.floor(SoulThirstValue + permaSoulThirst + 0.5) end
			if SoulThirstValue and SoulThirstValue > 0 then
				if ZombRand(0,100) <= SoulThirstValue then
					SoulThirst = 1
					HaloTextHelper.addTextWithArrow(character, "+" .. math.floor(killDiff*(math.floor(SoulThirst+1.25))-killDiff+0.5) .. " Additional Souls Gained", true, HaloTextHelper.getColorGreen());
				end
			end
			weaponModData.KillCount = weaponSouls + killDiff*(math.floor(SoulThirst+1.25)) + math.floor(tierzone/2+0.25) --calculate and set new kill counter on weapon, 
			weaponModData.PlayerKills = n_killcount --update player kill counter on weapon
			--character:Say("new kills: " .. weaponModData.KillCount)
			
			--character:Say("new player kills: " .. weaponModData.PlayerKills)
		end
	
	end

end

Events.OnPlayerAttackFinished.Add(SoulCountSD)
