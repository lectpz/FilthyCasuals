----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

--require "SDZoneCheck"
--require "LootCacheFC"
--require "RikuWeaponCacheFC"

-- moodle framework stuff
require "MF_ISMoodle"
local tiers = 6
for i=1,tiers do
	MF.createMoodle("SD6Tier"..i)
end

MF.createMoodle("SundayDriversControl");
MF.createMoodle("COG");
MF.createMoodle("VW");
MF.createMoodle("Ranger");

local infusions = { "alertness", "IronChef", "fortitude", "luck", "SoulSmith", "SoulThirst" }

for i=1,#infusions do
	MF.createMoodle(infusions[i])
end

local function setInfusionMoodle(timer, infusion)
	if not timer then return end
	if timer and timer <= 0 then
		MF.getMoodle(infusion):setValue(0.5)
		return
	end
	
	if timer and timer > 39 then
		MF.getMoodle(infusion):setValue(0.9)--level4
	elseif timer and timer > 33 then
		MF.getMoodle(infusion):setValue(0.8)--level3
	elseif timer and timer > 26 then
		MF.getMoodle(infusion):setValue(0.7)--level2
	elseif timer and timer > 20 then
		MF.getMoodle(infusion):setValue(0.6)--level1
	elseif timer and timer > 13 then
		MF.getMoodle(infusion):setValue(0.4)--level1
	elseif timer and timer > 7 then
		MF.getMoodle(infusion):setValue(0.3)--level2
	elseif timer and timer > 1 then
		MF.getMoodle(infusion):setValue(0.2)--level3
	elseif timer and timer <= 1 then
		MF.getMoodle(infusion):setValue(0.1)--level4
		MF.getMoodle(infusion):doWiggle();
	end
end

local function setTierMoodle(moodleno, strength)
	for i=1,6 do
		if i == moodleno then
			MF.getMoodle("SD6Tier"..i):setValue(strength)
		else
			MF.getMoodle("SD6Tier"..i):setValue(0.5)
		end
	end
end

local function EveryOneMinuteSD()
	local player = getSpecificPlayer(0)
	if player ~= nil then

		local tier_no, zone, x, y, control, toxic = checkZone()

		if control then
			MF.getMoodle("SundayDriversControl"):setValue(1.0)
		else
			MF.getMoodle("SundayDriversControl"):setValue(0.5)
		end
		
		if tier_no == 6 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 5 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 4 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 3 then
			setTierMoodle(tier_no, 0.4)
		elseif tier_no == 2 then
			setTierMoodle(tier_no, 0.6)
		elseif tier_no == 1 then
			setTierMoodle(tier_no, 1.0)
		end
		
		local pMD = player:getModData()
		local faction = pMD.faction
		local DD_Faction = ModData.getOrCreate("DD_Faction")

		if faction then DD_Faction["Faction"] = faction end--compatibility so existing players save their faction pmd to gmd
		if not faction and type(DD_Faction["Faction"])=="string" then
			faction = DD_Faction["Faction"] 
			pMD.faction = DD_Faction["Faction"] 
		end--make factions persist on death

		if faction == "Cog" then
			DD_Faction["Faction"] = "COG"
			pMD.faction = "COG"
			faction = "COG"
		end

		if faction == "COG" then
			MF.getMoodle("COG"):setValue(1.0)
			MF.getMoodle("Ranger"):setValue(0.5)
			MF.getMoodle("VW"):setValue(0.5)
		elseif faction == "Ranger" then
			MF.getMoodle("COG"):setValue(0.5)
			MF.getMoodle("Ranger"):setValue(1.0)
			MF.getMoodle("VW"):setValue(0.5)
		elseif faction == "VoidWalker" then
			MF.getMoodle("COG"):setValue(0.5)
			MF.getMoodle("Ranger"):setValue(0.5)
			MF.getMoodle("VW"):setValue(1.0)
		else
			MF.getMoodle("COG"):setValue(0.5)
			MF.getMoodle("Ranger"):setValue(0.5)
			MF.getMoodle("VW"):setValue(0.5)
		end
		
		for i=1,#infusions do
			setInfusionMoodle(pMD[infusions[i].."Timer"], infusions[i])
		end
		
	end
	
end

Events.EveryOneMinute.Add(EveryOneMinuteSD)