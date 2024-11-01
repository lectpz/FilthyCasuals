----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

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
	Brave = getStat("Prefix", "Brave", "getMinDamage", 1.1, posDesc("getMinDamage")),
	Cromulent = getStat("Prefix", "Cromulent", "getConditionLowerChance", 1.1, posDesc("getConditionLowerChance")),
	Desensitized = getStat("Prefix", "Desensitized", "getCriticalChance", 1.1, posDesc("getCriticalChance")),
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
	Dedicated = getStat("Suffix", "Dedicated", "getMinDamage", 1.1, posDesc("getMinDamage")),
	Enlightened = getStat("Suffix", "Enlightened", "getMaxDamage", 1.1, posDesc("getMaxDamage")),
	Indifferent = getStat("Suffix", "Indifferent", "getConditionMax", 1.1, posDesc("getConditionMax")),
	Malding = getStat("Suffix", "Malding", "getCritDmgMultiplier", 1.1, posDesc("getCritDmgMultiplier")),
	Savage = getStat("Suffix", "Savage", "getCriticalChance", 1.1, posDesc("getCriticalChance")),
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
						
						local sm1, sm2, sm3 = 1.1, 1.1, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						local maxCondition = sm3
						
						--print("Absolutionist arg: maxDamage = " .. maxDamage)
						--print("Absolutionist arg: minDamage = " .. minDamage)
						--print("Absolutionist arg: maxCondition = " .. maxCondition)

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
						
						--print("Decimator arg: maxDamage = " .. maxDamage)
						--print("Decimator arg: conditionLowerChance = " .. conditionLowerChance)
						--print("Decimator arg: maxCondition = " .. maxCondition)

						local description = gold .. "Prefix Modifer: Decimator" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, conditionLowerChance, maxCondition
					end,
	
	Perfectionist =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.1, 1.1, 1
						
						local maxCondition = sm1
						local minDamage = sm2
						local maxDamage = sm3
						
						--print("Perfectionist arg: maxCondition = " .. maxCondition)
						--print("Perfectionist arg: minDamage = " .. minDamage)
						--print("Perfectionist arg: maxDamage = " .. maxDamage)

						local description = gold .. "Prefix Modifer: Perfectionist" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Weapon Condition" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage <LINE> "
								--orange .. " <LINE> " .. string.format("%.0f", (100-sm3*100))  .. "% Less Maximum Damage <LINE> "
						return description, scriptItem, maxCondition, minDamage, maxDamage
					end,
	
	Reaver 		=	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.2, 1.05, 1
						
						local maxDamage = sm1
						local minDamage = sm2
						local conditionLowerChance = sm3
						
						--print("Reaver arg: maxDamage = " .. maxDamage)
						--print("Reaver arg: minDamage = " .. minDamage)
						--print("Reaver arg: conditionLowerChance = " .. conditionLowerChance)

						local description = gold .. "Prefix Modifer: Reaver" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Minimum Damage <LINE> "
								--orange .. " <LINE> " .. string.format("%.0f", (100-sm3*100))  .. "% Less Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, minDamage, conditionLowerChance
					end,

}

local pref2_setstat = {
    Absolutionist =	function(item, description, scriptItem, maxDamage, minDamage, maxCondition)
						
						--print("Absolutionist arg: maxDamage = " .. maxDamage)
						--print("Absolutionist arg: minDamage = " .. minDamage)
						--print("Absolutionist arg: maxCondition = " .. maxCondition)
						
						
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
						
						--print("Decimator setstat: maxDamage = " .. maxDamage)
						--print("Decimator setstat: conditionLowerChance = " .. conditionLowerChance)
						--print("Decimator setstat: maxCondition = " .. maxCondition)
						
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
						
						--print("weapon condition lower chance :" .. weaponModData.ConditionLowerChance)
						--print("weapon condition max :" .. weaponModData.MaxCondition)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setName(weaponModData.Name)
					end,

    Perfectionist =	function(item, description, scriptItem, maxCondition, minDamage, maxDamage)
						
						--print("Perfectionist setstat: maxCondition = " .. maxCondition)
						--print("Perfectionist setstat: minDamage = " .. minDamage)
						--print("Perfectionist setstat: maxDamage = " .. maxDamage)
						
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
						
						print("weapon condition max :" .. weaponModData.MaxCondition)
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setName(weaponModData.Name)
					end,
					
    Reaver =	function(item, description, scriptItem, maxDamage, minDamage, conditionLowerChance)
						
						--print("Reaver setstat: maxDamage = " .. maxDamage)
						--print("Reaver setstat: minDamage = " .. minDamage)
						--print("Reaver setstat: conditionLowerChance = " .. conditionLowerChance)
						
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
						
						print("weapon condition lower chance :" .. weaponModData.ConditionLowerChance)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
}

local suff2_args = {
    SundayDriver =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1.1, 1
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local minDamage = sm2
						local EnduranceMod = scriptItem:getEnduranceMod() * sm3
						
						--print("Sunday Driver arg: maxHitCount = " .. maxHitCount)
						--print("Sunday Driver arg: minDamage = " .. minDamage)
						--print("Sunday Driver arg: conditionLowerChance = " .. conditionLowerChance)

						local description = gold .. "Suffix Modifer: Sunday Driver" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100)) .. "% More Minimum Damage <LINE> "
						return description, scriptItem, maxHitCount, minDamage, EnduranceMod
					end,

    FilthyCasual =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1, 1, 1.1
						
						local maxHitCount = scriptItem:getMaxHitCount() + sm1
						local EnduranceMod = scriptItem:getEnduranceMod() * sm2
						local maxDamage = sm3
						
						--print("Filthy Casual arg: EnduranceMod = " .. EnduranceMod)
						--print("Filthy Casual arg: minDamage = " .. minDamage)
						--print("Filthy Casual arg: maxDamage = " .. maxDamage)

						local description = gold .. "Suffix Modifer: Filthy Casual" ..
								green .. " <LINE> Max Hit Count +" .. sm1 ..
								--orange .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Endurance Used" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Maximum Damage <LINE> "
						return description, scriptItem, maxHitCount, EnduranceMod, maxDamage
					end,

    ApocalypseEnjoyer =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.15, 1.1, 1
						
						local maxDamage = sm1
						local maxCondition = sm2
						local conditionLowerChance = sm3
						
						--print("Apocalypse Enjoyer arg: maxDamage = " .. maxDamage)
						--print("Apocalypse Enjoyer arg: maxCondition = " .. maxCondition)
						--print("Apocalypse Enjoyer arg: conditionLowerChance = " .. conditionLowerChance)

						local description = gold .. "Suffix Modifer: Apocalypse Enjoyer" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm2*100-100))  .. "% More Maximum Weapon Condition <LINE> "
								--orange .. " <LINE> " .. string.format("%.0f", (100-sm3*100))  .. "% Less Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, maxCondition, conditionLowerChance
					end,
					
	AscendedPath =	function(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						
						local sm1, sm2, sm3 = 1.15, 1, 1.1
						
						local maxDamage = sm1
						local minDamage = sm2
						local conditionLowerChance = sm3
						
						--print("Ascended Path arg: maxDamage = " .. maxDamage)
						--print("Ascended Path arg: minDamage = " .. minDamage)
						--print("Ascended Path arg: conditionLowerChance = " .. conditionLowerChance)

						local description = gold .. "Suffix Modifer: Ascended Path" ..
								green .. " <LINE> " .. string.format("%.0f", (sm1*100-100))  .. "% More Maximum Damage" ..
								--orange .. " <LINE> " .. string.format("%.0f", (100-sm2*100))  .. "% Less Minimum Damage" ..
								green .. " <LINE> " .. string.format("%.0f", (sm3*100-100))  .. "% More Weapon Condition Lower Chance <LINE> "
						return description, scriptItem, maxDamage, minDamage, conditionLowerChance
					end,
}

local suff2_setstat = {
    SundayDriver =	function(item, description, scriptItem, maxHitCount, minDamage, EnduranceMod)
						
						--print("Sunday Driver setstat: maxHitCount = " .. maxHitCount)
						--print("Sunday Driver setstat: minDamage = " .. minDamage)
						--print("Sunday Driver setstat: conditionLowerChance = " .. conditionLowerChance)
						
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
						
						--print("Filthy Casual setstat: EnduranceMod = " .. EnduranceMod)
						--print("Filthy Casual setstat: minDamage = " .. minDamage)
						--print("Filthy Casual setstat: maxDamage = " .. maxDamage)
						
						weaponModData.MaxHitCount = maxHitCount
						
						local isEnduranceMod = weaponModData.EnduranceMod or nil
						if isEnduranceMod then
							weaponModData.EnduranceMod = item:setEnduranceMod(EnduranceMod)
						else
							weaponModData.EnduranceMod = scriptItem:getEnduranceMod()
						end
						
						--weaponModData.EnduranceMod = item:setEnduranceMod(EnduranceMod)
						
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
						
						--print("Apocalypse Enjoyer setstat: maxDamage = " .. maxDamage)
						--print("Apocalypse Enjoyer setstat: maxCondition = " .. maxCondition)
						--print("Apocalypse Enjoyer setstat: conditionLowerChance = " .. conditionLowerChance)
						
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
						
						print("weapon condition lower chance :" .. weaponModData.ConditionLowerChance)
						print("weapon condition max :" .. weaponModData.MaxCondition)
						item:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
					
    AscendedPath =	function(item, description, scriptItem, maxDamage, minDamage, conditionLowerChance)
						
						--print("Ascended Path setstat: maxDamage = " .. maxDamage)
						--print("Ascended Path setstat: minDamage = " .. minDamage)
						--print("Ascended Path setstat: conditionLowerChance = " .. conditionLowerChance)
						
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
						
						print("weapon condition lower chance :" .. weaponModData.ConditionLowerChance)
						item:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
						item:setName(weaponModData.Name)
					end,
}

local function SoulContextSD(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:IsWeapon() and not item:isRanged() then
			local o_scriptItem = ScriptManager.instance:getItem(item:getFullType())
			weaponModData = item:getModData()
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
				
				--tooltip.description = tooltip.description .. white .. " <LINE> DEBUG - Endurance Mod: " .. math.ceil(item:getEnduranceMod()*100)/100
				
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
					tooltip.description = tooltip.description .. "You need to free more souls."
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
					weaponCurrentCondition = item:getCondition()
					weaponCondRepairAmount = math.ceil(weaponMaxCond/4 * soulForgeMaxCondition)
					weaponNewCondition = math.floor(math.min((weaponCurrentCondition + weaponCondRepairAmount), weaponMaxCond*soulForgeMaxCondition)+0.5)
					
					new_weaponCondition = function(item, player)
						item:setCondition(weaponNewCondition)
						weaponModData.KillCount = n_soulsFreed
						--soulsFreed = weaponModData.KillCount
					end
					
					if weaponRepairedStack >= 5 then
						option_weaponCondition = submenu:addOption("Repair weapon to: " .. weaponNewCondition .. "/" .. weaponMaxCond .. " (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponCondition, player)
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
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT1")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT2")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT3")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT4")
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
																			playerInv:RemoveOneOf("SoulForge.SoulCrystalT1")
																			playerInv:RemoveOneOf("SoulForge.SoulCrystalT2")
																			playerInv:RemoveOneOf("SoulForge.SoulCrystalT3")
																			if _fix == pref2_setstat or _fix == suff2_setstat then playerInv:RemoveOneOf("SoulForge.SoulCrystalT4") end
																			
																			removeWeaponsNotEquipped(playerObj, item)
																			--[[if _fix == pref2_setstat or _fix == suff2_setstat then removeWeaponsNotEquipped(playerObj, item) end]]
																		end, player)
							
							tooltip = ISWorldObjectContextMenu.addToolTip();

							tooltip.description = tooltip.description .. description .. " <LINE> "
							tooltip.description = tooltip.description .. "Materials required: <LINE> "
							option_sm11_upgrade.toolTip = tooltip
							
							itemToolTipMats("SoulForge.SoulCrystalT1", option_sm11_upgrade)
							itemToolTipMats("SoulForge.SoulCrystalT2", option_sm11_upgrade)
							itemToolTipMats("SoulForge.SoulCrystalT3", option_sm11_upgrade)
							if _fix == pref2_setstat or _fix == suff2_setstat  then itemToolTipMats("SoulForge.SoulCrystalT4", option_sm11_upgrade) end
							
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
						
						if weaponModData.Augments and weaponModData.Augments >= 4 then
							submenu:removeOptionByName("Upgrade Soul Forged Weapon")
						else
							
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
								--[[addUpgradeOptions("prefix1", "Brave")
								addUpgradeOptions("prefix1", "Cromulent")
								addUpgradeOptions("prefix1", "Desensitized")
								addUpgradeOptions("prefix1", "Enraged")
								addUpgradeOptions("prefix1", "Nonplussed")]]
							end
							
							if not check_prefix2 then
								
								submenu11_prefix2 = submenu1:addOption("Major Prefix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_prefix2, submenu11)
								
								sortAndAddOptions("prefix2", pref2_args)
								--[[addUpgradeOptions("prefix2", "Absolutionist")
								addUpgradeOptions("prefix2", "Decimator")
								addUpgradeOptions("prefix2", "Perfectionist")
								addUpgradeOptions("prefix2", "Reaver")]]
							end
							
							if not check_suffix1 then
								
								submenu11_suffix1 = submenu1:addOption("Minor Suffix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_suffix1, submenu11)
								
								sortAndAddOptions("suffix1", suff1_args)
								--[[addUpgradeOptions("suffix1", "Careful")
								addUpgradeOptions("suffix1", "Enlightened")
								addUpgradeOptions("suffix1", "Indifferent")
								addUpgradeOptions("suffix1", "Malding")
								addUpgradeOptions("suffix1", "Savage")]]
							end
							
							if not check_suffix2 then
								
								submenu11_suffix2 = submenu1:addOption("Major Suffix", item, nil, player)
								submenu11 = ISContextMenu:getNew(submenu1)
								submenu1:addSubMenu(submenu11_suffix2, submenu11)
								
								sortAndAddOptions("suffix2", suff2_args)
								--[[addUpgradeOptions("suffix2", "SundayDriver")
								addUpgradeOptions("suffix2", "FilthyCasual")
								addUpgradeOptions("suffix2", "ApocalypseEnjoyer")
								addUpgradeOptions("suffix2", "AscendedPath")]]
							end

						end
						
					elseif (weaponCurrentCondition < (weaponMaxCond*soulForgeMaxCondition) or soulsFreed < soulsRequired) then
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
						
						itemToolTipMats("SoulForge.SoulCrystalT1", option_soulForgeWeapon)
						itemToolTipMats("SoulForge.SoulCrystalT2", option_soulForgeWeapon)
						itemToolTipMats("SoulForge.SoulCrystalT3", option_soulForgeWeapon)
						itemToolTipMats("SoulForge.SoulCrystalT4", option_soulForgeWeapon)
						
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

	local player = character
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

		
		local killDiff = n_killcount - weaponPlayerKC -- calculate difference in kill count
		--character:Say("kill diff: " .. killDiff)
		
		if killDiff > 0 then
			weaponModData.KillCount = weaponSouls + killDiff + math.floor(tierzone/2) --calculate and set new kill counter on weapon, 
			weaponModData.PlayerKills = n_killcount --update player kill counter on weapon
			--character:Say("new kills: " .. weaponModData.KillCount)
			--character:Say("new player kills: " .. weaponModData.PlayerKills)
		end
	
	end

end

Events.OnPlayerAttackFinished.Add(SoulCountSD)
