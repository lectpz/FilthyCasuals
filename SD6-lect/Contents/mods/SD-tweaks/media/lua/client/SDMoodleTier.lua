----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"
--require "LootCacheFC"
--require "RikuWeaponCacheFC"

-- moodle framework stuff
require "MF_ISMoodle"
MF.createMoodle("SD6Tier1");
--MF.getMoodle("SD6Tier1"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("SD6Tier2");
--MF.getMoodle("SD6Tier2"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("SD6Tier3");
--MF.getMoodle("SD6Tier3"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("SD6Tier4");
--MF.getMoodle("SD6Tier4"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("SD6Tier5");
--MF.getMoodle("SD6Tier5"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

-- function for checking zone OnPlayerUpdate and updating moodles and checking for lootboxes
--function OnPlayerMoveFC(player)
local function EveryOneMinuteSD()
	local player = getSpecificPlayer(0)
	if player ~= nil then
	--if player ~= nil and player == getPlayer() then
	
		local checkMoodle = checkZone()
--		MF.getMoodle("SD6Tier1"):setValue(0.5);
--		MF.getMoodle("SD6Tier2"):setValue(0.5);
--		MF.getMoodle("SD6Tier3"):setValue(0.5);
--		MF.getMoodle("SD6Tier4"):setValue(0.5);
		
		if checkMoodle == 5 then
			--if ZombRand(3) == 0 then player:Say("The dead were the lucky ones...") elseif ZombRand(3) == 1 then player:Say("They say people in hell want ice water... Who am I kidding? This is hell and I want ice water.") else player:Say("I've run out of pithy quotes.") end
			MF.getMoodle("SD6Tier5"):setValue(0.1);
			MF.getMoodle("SD6Tier1"):setValue(0.5);
			MF.getMoodle("SD6Tier2"):setValue(0.5);
			MF.getMoodle("SD6Tier3"):setValue(0.5);
			MF.getMoodle("SD6Tier4"):setValue(0.5);
--			MF.getMoodle("SD6Tier4"):doWiggle();
		elseif checkMoodle == 4 then
			--if ZombRand(3) == 0 then player:Say("The dead were the lucky ones...") elseif ZombRand(3) == 1 then player:Say("They say people in hell want ice water... Who am I kidding? This is hell and I want ice water.") else player:Say("I've run out of pithy quotes.") end
			MF.getMoodle("SD6Tier4"):setValue(0.1);
			MF.getMoodle("SD6Tier1"):setValue(0.5);
			MF.getMoodle("SD6Tier2"):setValue(0.5);
			MF.getMoodle("SD6Tier3"):setValue(0.5);
			MF.getMoodle("SD6Tier5"):setValue(0.5);
--			MF.getMoodle("SD6Tier4"):doWiggle();
		elseif checkMoodle == 3 then
			--if ZombRand(3) == 0 then player:Say("The air here is thick with death...") elseif ZombRand(3) == 1 then player:Say("It's as if I'm walking deeper into the maw of hell...") else player:Say("There is no hope here.") end
			MF.getMoodle("SD6Tier3"):setValue(0.4);
			MF.getMoodle("SD6Tier1"):setValue(0.5);
			MF.getMoodle("SD6Tier2"):setValue(0.5);
			MF.getMoodle("SD6Tier4"):setValue(0.5);
			MF.getMoodle("SD6Tier5"):setValue(0.5);
--			MF.getMoodle("SD6Tier3"):doWiggle();
		elseif checkMoodle == 2 then
			--if ZombRand(3) == 0 then player:Say("Is it just me or do they seem... stronger?") elseif ZombRand(3) == 1 then player:Say("They're somehow... different here...") else player:Say("You'd think that death would slow these things down a bit...") end
			MF.getMoodle("SD6Tier2"):setValue(0.7);
			MF.getMoodle("SD6Tier1"):setValue(0.5);
			MF.getMoodle("SD6Tier4"):setValue(0.5);
			MF.getMoodle("SD6Tier3"):setValue(0.5);
			MF.getMoodle("SD6Tier5"):setValue(0.5);
--			MF.getMoodle("SD6Tier2"):doWiggle();
		elseif checkMoodle == 1 then
			MF.getMoodle("SD6Tier1"):setValue(1.0);
			MF.getMoodle("SD6Tier4"):setValue(0.5);
			MF.getMoodle("SD6Tier2"):setValue(0.5);
			MF.getMoodle("SD6Tier3"):setValue(0.5);
			MF.getMoodle("SD6Tier5"):setValue(0.5);
--			MF.getMoodle("SD6Tier1"):doWiggle();
		end
		
	end
	
end

Events.EveryOneMinute.Add(EveryOneMinuteSD)