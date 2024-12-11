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
local tiers = 5
for i=1,tiers do
	MF.createMoodle("SD6Tier"..i)
end

MF.createMoodle("SundayDriversControl");
MF.createMoodle("COG");
MF.createMoodle("VW");
MF.createMoodle("Ranger");

local function setTierMoodle(moodleno, strength)
	for i=1,5 do
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
		
		if tier_no == 5 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 4 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 3 then
			setTierMoodle(tier_no, 0.4)
		elseif tier_no == 2 then
			setTierMoodle(tier_no, 0.7)
		elseif tier_no == 1 then
			setTierMoodle(tier_no, 1.0)
		end
		
		local pMD = player:getModData()
		local faction = pMD.faction
		--[[if faction == "COG" then
			local gmd_faction = ModData.getOrCreate("COG")
			--gmd_facton[getOnlineUsername()] = true
			gmd_faction["lect"] = true
			ModData.transmit("COG")
			ModData.remove("COG")
		end]]

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
		
	end
	
end

Events.EveryOneMinute.Add(EveryOneMinuteSD)