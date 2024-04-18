----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"
--require "LootCacheFC"
--require "RikuWeaponCacheFC"

-- moodle framework stuff
require "MF_ISMoodle"
MF.createMoodle("Tier1");
--MF.getMoodle("Tier1"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("Tier2");
--MF.getMoodle("Tier2"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("Tier3");
--MF.getMoodle("Tier3"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

MF.createMoodle("Tier4");
--MF.getMoodle("Tier4"):setThresholds(0.1, 0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1.0)

-- function for checking zone OnPlayerUpdate and updating moodles and checking for lootboxes
--function OnPlayerMoveFC(player)
function EveryOneMinuteFC()
	player = getPlayer()
	if player ~= nil then
	--if player ~= nil and player == getPlayer() then
	
		local checkMoodle = checkZone()
--		MF.getMoodle("Tier1"):setValue(0.5);
--		MF.getMoodle("Tier2"):setValue(0.5);
--		MF.getMoodle("Tier3"):setValue(0.5);
--		MF.getMoodle("Tier4"):setValue(0.5);
		
		if checkMoodle == 4 then
			--if ZombRand(3) == 0 then player:Say("The dead were the lucky ones...") elseif ZombRand(3) == 1 then player:Say("They say people in hell want ice water... Who am I kidding? This is hell and I want ice water.") else player:Say("I've run out of pithy quotes.") end
			MF.getMoodle("Tier4"):setValue(0.1);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);
--			MF.getMoodle("Tier4"):doWiggle();
		elseif checkMoodle == 3 then
			--if ZombRand(3) == 0 then player:Say("The air here is thick with death...") elseif ZombRand(3) == 1 then player:Say("It's as if I'm walking deeper into the maw of hell...") else player:Say("There is no hope here.") end
			MF.getMoodle("Tier3"):setValue(0.4);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier4"):setValue(0.5);			
--			MF.getMoodle("Tier3"):doWiggle();
		elseif checkMoodle == 2 then
			--if ZombRand(3) == 0 then player:Say("Is it just me or do they seem... stronger?") elseif ZombRand(3) == 1 then player:Say("They're somehow... different here...") else player:Say("You'd think that death would slow these things down a bit...") end
			MF.getMoodle("Tier2"):setValue(0.6);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier4"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);			
--			MF.getMoodle("Tier2"):doWiggle();
		elseif checkMoodle == 1 then
			MF.getMoodle("Tier1"):setValue(1.0);
			MF.getMoodle("Tier4"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);			
--			MF.getMoodle("Tier1"):doWiggle();
		end

		--searchItems = player:getInventory():GetItemsFromFullType("Container")
		--print(table.concat(searchItems, ", "))


		--if player:getInventory():contains("WeaponCache") then
		--	player:getInventory():Remove("WeaponCache")
		--	player:Say("The Weapon Cache disintegrates and leaves it's contents behind...")
		--	RikuWeaponCacheFC()
		--elseif player:getInventory():contains("MetalworkCache") then
		--	player:getInventory():Remove("MetalworkCache")
		--	player:Say("The Metalwork Cache disintegrates and leaves it's contents behind...")
		--	MetalworkCacheFC()		
		--elseif player:getInventory():contains("MechanicCache") then	
		--	player:getInventory():Remove("MechanicCache")
		--	player:Say("The Mechanic Cache disintegrates and leaves it's contents behind...")
		--	MechCacheFC()
		--end
		
	end
	
end

--Events.OnPlayerMove.Add(OnPlayerMoveFC)
Events.EveryOneMinute.Add(EveryOneMinuteFC)