-- Set local
local FitnessLvl
local NimbleLvl
local LightfootedLvl
local SprintingLvl
local SneakLvl

local SOTOSbvars = SandboxVars.SOTO;

-- Checking skill levels
function checkskillslevel()
	local player = getPlayer();
	if player == nil then
		return
	end

	FitnessLvl = player:getPerkLevel(Perks.Fitness);
	SneakLvl = player:getPerkLevel(Perks.Sneak);
	NimbleLvl = player:getPerkLevel(Perks.Nimble);
	SprintingLvl = player:getPerkLevel(Perks.Sprinting);
	LightfootedLvl = player:getPerkLevel(Perks.Lightfoot);

end

Events.OnGameStart.Add(checkskillslevel);
Events.LevelPerk.Add(checkskillslevel);
Events.OnCreatePlayer.Add(checkskillslevel);
Events.OnCreateLivingCharacter.Add(checkskillslevel);

--- INCREASE AND DECREASE STATS ---
-- DRUNKENNESS
function SODecDrunkenness(player, chance, drunkenness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentDrunkenness = player:getStats():getDrunkenness();
		player:getStats():setDrunkenness(currentDrunkenness - drunkenness);
		if player:getStats():getDrunkenness() < 0 then
			player:getStats():setDrunkenness(0);
		end
	end
end

-- BOREDOM
function SODecBoredom(player, chance, boredom)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentBoredom = player:getBodyDamage():getBoredomLevel();
		player:getBodyDamage():setBoredomLevel(currentBoredom - boredom);
		if player:getBodyDamage():getBoredomLevel() < 0 then
			player:getBodyDamage():setBoredomLevel(0);
		end
	end
end

-- HUNGER
function SOAddHunger(player, chance, hunger)
	local HundredChance = ZombRand(100);
	local HeartyAppititeMult = 1
	local LightEaterMult = 1
	if HundredChance <= chance then
		local currentHunger = player:getStats():getHunger();
		if player:HasTrait("HeartyAppitite") then
			HeartyAppititeMult = 1.50
		end
		if player:HasTrait("LightEater") then
			LightEaterMult = 0.75
		end
		player:getStats():setHunger(currentHunger + (hunger * (HeartyAppititeMult * LightEaterMult)));
		if player:getStats():getHunger() > 0.999 then
			player:getStats():setHunger(0.999);
		end
	end
end
function SODecHunger(player, chance,  hunger)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentHunger = player:getStats():getHunger();
		player:getStats():setHunger(currentHunger - hunger);
		if player:getStats():getHunger() < 0 then
			player:getStats():setHunger(0);
		end
	end
end

-- THIRST
function SOAddThirst(player, chance,  thirst)
	local HundredChance = ZombRand(100);
	local HighThirstMult = 1
	local LowThirstMult = 1
	if HundredChance <= chance then
		local currentThirst = player:getStats():getThirst();
		if player:HasTrait("HighThirst") then
			HighThirstMult = 2.0
		end
		if player:HasTrait("LowThirst") then
			LowThirstMult = 0.50
		end
		player:getStats():setThirst(currentThirst + (thirst * (HighThirstMult * LowThirstMult)));
		if player:getStats():getThirst() > 0.999 then
			player:getStats():setThirst(0.999);
		end
	end
end
function SODecThirst(player, chance,  thirst)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentThirst = player:getStats():getThirst();
		player:getStats():setThirst(currentThirst - thirst);
		if player:getStats():getThirst() < 0 then
			player:getStats():setThirst(0);
		end
	end
end

-- WETNESS
function SOAddWetness(player, chance, wetness)
	local HundredChance = ZombRand(100);
	local OverweightMult = 1
	local ObeseMult = 1
	if HundredChance <= chance then
		local currentWetness = player:getBodyDamage():getWetness();
		if player:HasTrait("Overweight") then
			OverweightMult = 1.2
		end
		if player:HasTrait("Obese") then
			ObeseMult = 1.4
		end
		player:getBodyDamage():setWetness(currentWetness + (wetness * (OverweightMult * ObeseMult)));
		if player:getBodyDamage():getWetness() > 99 then
			player:getBodyDamage():setWetness(99);
		end
	end
end
function SODecWetness(player, chance, wetness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentWetness = player:getBodyDamage():getWetness();
		local OverweightMult = 1
		local ObeseMult = 1
		if player:HasTrait("Overweight") then
			OverweightMult = 0.8
		end
		if player:HasTrait("Obese") then
			ObeseMult = 0.6
		end
		player:getBodyDamage():setWetness(currentWetness - (wetness * (OverweightMult * ObeseMult)));
		if player:getBodyDamage():getWetness() < 0 then
			player:getBodyDamage():setWetness(0);
		end
	end
end

-- STRESS
function SOAddStress(player, chance,  stress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentStress = player:getStats():getStress();
		player:getStats():setStress(currentStress + stress);
		if player:getStats():getStress() > 0.999 then
			player:getStats():setStress(0.999);
		end
	end
end
function SODecStress(player, chance,  stress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentStress = player:getStats():getStress();
		player:getStats():setStress(currentStress - stress);
		if player:getStats():getStress() < 0 then
			player:getStats():setStress(0);
		end
	end
end

-- CIGARETTES STRESS
function SOAddCigStress(player, chance,  cigstress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentCigarettesStress = player:getStats():getStressFromCigarettes();
		player:getStats():setStressFromCigarettes(currentCigarettesStress + cigstress);
		if player:getStats():getStressFromCigarettes() > 0.999 then
			player:getStats():setStressFromCigarettes(0.999);
		end
	end
end
function SODecCigStress(player, chance,  cigstress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentCigarettesStress = player:getStats():getStressFromCigarettes();
		player:getStats():setStressFromCigarettes(currentCigarettesStress - cigstress);
		if player:getStats():getStressFromCigarettes() < 0 then
			player:getStats():setStressFromCigarettes(0);
		end
	end
end

-- UNHAPPYNESS
function SOAddUnhappyness(player, chance,  unhappyness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentUnhappyness = player:getBodyDamage():getUnhappynessLevel();
		player:getBodyDamage():setUnhappynessLevel(currentUnhappyness + unhappyness);
		if player:getBodyDamage():getUnhappynessLevel() > 99 then
			player:getBodyDamage():setUnhappynessLevel(99);
		end
	end
end
function SODecUnhappyness(player, chance,  unhappyness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentUnhappyness = player:getBodyDamage():getUnhappynessLevel();
		player:getBodyDamage():setUnhappynessLevel(currentUnhappyness - unhappyness);
		if player:getBodyDamage():getUnhappynessLevel() < 0 then
			player:getBodyDamage():setUnhappynessLevel(0);
		end
	end
end

-- PANIC
function SOAddPanic(player, chance, panic)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentPanic = player:getStats():getPanic();
		player:getStats():setPanic(currentPanic + panic);
		if player:getStats():getPanic() > 99 then
			player:getStats():setPanic(99);
		end
	end
end

-- FATIGUE
function SOAddFatigue(player, chance, fatigue)
	local HundredChance = ZombRand(100);
	local FitnessLvlValues = {
		[0] 	= 1.0,
		[1]		= 0.95,
		[2] 	= 0.92,
		[3] 	= 0.89,
		[4] 	= 0.87,
		[5] 	= 0.85,
		[6] 	= 0.83,
		[7] 	= 0.81,
		[8] 	= 0.79,
		[9] 	= 0.77,
		[10]	= 0.75
	}
	local x = FitnessLvl;
	local FitnessFatGainMult = FitnessLvlValues[x];
	if HundredChance <= chance then
		local currentFatigue = player:getStats():getFatigue();
		local SleepyheadMult = 1
		local WakefulMult = 1
		if player:HasTrait("NeedsMoreSleep") then
			SleepyheadMult = 1.3
		end
		if player:HasTrait("NeedsLessSleep") then
			WakefulMult = 0.7
		end
		player:getStats():setFatigue(currentFatigue + (((fatigue * FitnessFatGainMult) * (SleepyheadMult * WakefulMult))));
		if player:getStats():getFatigue() > 0.999 then
			player:getStats():setFatigue(0.999);
		end
	end
end
function SODecFatigue(player, chance, fatigue)
	local HundredChance = ZombRand(100);
	local SleepyheadMult = 1
	local WakefulMult = 1
	if HundredChance <= chance then
		local currentFatigue = player:getStats():getFatigue();
		if player:HasTrait("NeedsMoreSleep") then
			SleepyheadMult = 0.7
		end
		if player:HasTrait("NeedsLessSleep") then
			WakefulMult = 1.3
		end
		player:getStats():setFatigue(currentFatigue - ((fatigue * (SleepyheadMult * WakefulMult))));
		if player:getStats():getFatigue() < 0 then
			player:getStats():setFatigue(0);
		end
	end
end

-- FOOD NAUSEA
function SOAddFoodSickness(player, chance, foodsickness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
	local currentFoodSickness = player:getBodyDamage():getFoodSicknessLevel();
		if player:HasTrait("WeakStomach") then
			player:getBodyDamage():setFoodSicknessLevel(currentFoodSickness + (foodsickness * 1.3));
		elseif player:HasTrait("IronGut") then
			player:getBodyDamage():setFoodSicknessLevel(currentFoodSickness + (foodsickness * 0.7));
		else
			player:getBodyDamage():setFoodSicknessLevel(currentFoodSickness + foodsickness);
		end
		if player:getBodyDamage():getFoodSicknessLevel() > 99 then
			player:getBodyDamage():setFoodSicknessLevel(99);
		end
	end
end

-- PAIN
function SOAddPain(player, chance, bodyPart, pain)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local bodyPartAux = BodyPartType.FromString(bodyPart);
		local playerBodyPart = player:getBodyDamage():getBodyPart(bodyPartAux);
		local currentPain = playerBodyPart:getPain();
		playerBodyPart:setAdditionalPain(currentPain + pain);
		if playerBodyPart:getPain() > 99 then
			playerBodyPart:setAdditionalPain(99);
		end
	end
end

-- ENDURANCE
function SOAddEndurance(player, chance, endurance)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentEndurance = player:getStats():getEndurance();
		player:getStats():setEndurance(currentEndurance + endurance);
		if player:getStats():getEndurance() > 0.999 then
			player:getStats():setEndurance(0.999);
		end
--	print("Restored");
	end
end

function SODecEndurance(player, chance, endurance)
	local HundredChance = ZombRand(100);
	local FitnessLvlValues = {
		[0] 	= 0.9,
		[1]		= 0.8,
		[2] 	= 0.75,
		[3] 	= 0.7,
		[4] 	= 0.65,
		[5] 	= 0.60,
		[6] 	= 0.57,
		[7] 	= 0.53,
		[8] 	= 0.49,
		[9] 	= 0.46,
		[10]	= 0.43
	}
	local x = FitnessLvl;
	local FitnessEndLossMult = FitnessLvlValues[x];
	if HundredChance <= chance then
		local currentEndurance = player:getStats():getEndurance();
		player:getStats():setEndurance(currentEndurance - (endurance * FitnessEndLossMult));
		if player:getStats():getEndurance() < 0 then
			player:getStats():setEndurance(0);
		end
	end
end

--------------------------------

-- STRONG BACK AND WEAK BACK TRAIT - MAIN
function SOcheckWeight()
	local player = getPlayer();
	if getActivatedMods():contains("AliceSPack") == true then
		if player:HasTrait("Metalstrongback") and  player:HasTrait("StrongBack") then
		player:setMaxWeightBase(13);
		elseif player:HasTrait("Metalstrongback2") and  player:HasTrait("StrongBack") then
		player:setMaxWeightBase(13);
		elseif player:HasTrait("Strongback") and  player:HasTrait("StrongBack") then
		player:setMaxWeightBase(10);
		elseif player:HasTrait("Strongback2") and  player:HasTrait("StrongBack") then
		player:setMaxWeightBase(10);
		elseif player:HasTrait("Metalstrongback") then
		player:setMaxWeightBase(12);
		elseif player:HasTrait("Metalstrongback2") then
		player:setMaxWeightBase(12);
		elseif player:HasTrait("StrongBack") then
		player:setMaxWeightBase(10);
		elseif player:HasTrait("Strongback2") then
		player:setMaxWeightBase(10);
		elseif player:HasTrait("WeakBack") then
		player:setMaxWeightBase(7);
		else
		player:setMaxWeightBase(8);
		end
	end
	if getActivatedMods():contains("AliceSPack") == false then
		if player:HasTrait("StrongBack") then
		player:setMaxWeightBase(9);
		elseif player:HasTrait("WeakBack") then
		player:setMaxWeightBase(7);
		else
		player:setMaxWeightBase(8);
		end
	end

--[[	if getActivatedMods():contains("AliceSPack") == false then
		if player:HasTrait("StrongBack") then
		player:setMaxWeightDelta(1.15);
		player:setMaxWeightBase(8);
		elseif player:HasTrait("WeakBack") then
		player:setMaxWeightDelta(0.86);
		player:setMaxWeightBase(8);
		else
		player:setMaxWeightDelta(1);
		player:setMaxWeightBase(8);
		end
	end	]]

end

-- WEATHER SENSITIVE TRAIT - MAIN
function weathersensitivetrait()
    local player = getPlayer();
	local clim = getClimateManager();
	local forecaster = clim:getClimateForecaster();
	local todayforecast = forecaster:getForecast(0);
	local tomorrowforecast = forecaster:getForecast(1);
	local Head = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Head"));

	if player:getModData().SOhoursSinceLastRain == nil then
		player:getModData().SOhoursSinceLastRain = 0;
	end

	-- one hour = 6
	if 	player:HasTrait("WeatherSensitive") then
		if todayforecast:isHasBlizzard() or todayforecast:isHasTropicalStorm() or todayforecast:isHasStorm() or todayforecast:isHasHeavyRain() then
--		player:Say("today rain +");
		player:getModData().SOhoursSinceLastRain = player:getModData().SOhoursSinceLastRain + 1;
			elseif not todayforecast:isHasBlizzard() and not todayforecast:isHasTropicalStorm() and not  todayforecast:isHasStorm() and not todayforecast:isHasHeavyRain() then
--		player:Say("today no rain -");
			player:getModData().SOhoursSinceLastRain = player:getModData().SOhoursSinceLastRain - 1;
		end

		if tomorrowforecast:isHasBlizzard() or tomorrowforecast:isHasTropicalStorm() or tomorrowforecast:isHasStorm() or tomorrowforecast:isHasHeavyRain() then
--		player:Say("tomorrow rain +");
		player:getModData().SOhoursSinceLastRain = player:getModData().SOhoursSinceLastRain + 2;
			elseif not tomorrowforecast:isHasBlizzard() and not tomorrowforecast:isHasTropicalStorm() and not  tomorrowforecast:isHasStorm() and not tomorrowforecast:isHasHeavyRain() then
--		player:Say("tomorrow no rain -");
			player:getModData().SOhoursSinceLastRain = player:getModData().SOhoursSinceLastRain - (ZombRand(1)+2);
		end
	end

	if 	player:HasTrait("WeatherSensitive") then
		if todayforecast:isHasBlizzard() or todayforecast:isHasTropicalStorm() or todayforecast:isHasStorm() or todayforecast:isHasHeavyRain() then
			if Head:getPain() <= 8 and ZombRand(19) == 0 then
--				player:Say("today rain pain");
				SOAddPain(player, 100, "Head", (ZombRand(27)+27));
				player:playEmote("soheadache");
--				print("1");
			end
		end
		if tomorrowforecast:isHasBlizzard() or tomorrowforecast:isHasTropicalStorm() or tomorrowforecast:isHasStorm() or tomorrowforecast:isHasHeavyRain() then
			if player:getModData().SOhoursSinceLastRain <= 143 and Head:getPain() <= 26 then
--			player:Say("tomorrow rain+ pain");
			SOAddPain(player, 25, "Head", ZombRand(45));
				if ZombRand(11) == 0 then
--				print("2");
				player:playEmote("soheadache");
				end
			end
		end
		if not tomorrowforecast:isHasBlizzard() and not tomorrowforecast:isHasTropicalStorm() and not  tomorrowforecast:isHasStorm() and not tomorrowforecast:isHasHeavyRain() then
			if 	player:getModData().SOhoursSinceLastRain >= 144 and Head:getPain() <= 22 then
--			player:Say("tomorrow no rain pain");
			SOAddPain(player, 25, "Head", ZombRand(40));
				if ZombRand(11) == 0 then
--				print("3");
				player:playEmote("soheadache");
				end
			end
		end
	end

	if player:getModData().SOhoursSinceLastRain > 288 then
		player:getModData().SOhoursSinceLastRain = 288;
		elseif player:getModData().SOhoursSinceLastRain < 0 then
			player:getModData().SOhoursSinceLastRain = 0;
	end
--	print("player:getModData().SOhoursSinceLastRain: " .. player:getModData().SOhoursSinceLastRain);
end

-- LARK TRAIT - MAIN
function larkpersontrait()
	local player = getPlayer();
	local gameTime = getGameTime();
	local currentHour = gameTime:getHour();
 	if player:HasTrait("LarkPerson") and not player:isAsleep() then
		if currentHour >= 5 and currentHour <= 9 then
			SODecFatigue(player, 50, 0.005)
		end
		if currentHour >= 17 and currentHour <= 21 then
			SOAddFatigue(player, 50, 0.005)
		end
	end
end

-- OWL TRAIT - MAIN
function owlpersontrait()
	local player = getPlayer();
	local gameTime = getGameTime();
	local currentHour = gameTime:getHour();
 	if player:HasTrait("OwlPerson") and not player:isAsleep() then
		if currentHour >= 17 and currentHour <= 21 then
			SODecFatigue(player, 50, 0.005)
		end
		if currentHour >= 5 and currentHour <= 9 then
			SOAddFatigue(player, 50, 0.005)
		end
	end
end

-- RELENTLESS TRAIT - MAIN
function relentlesstrait(player, weapon)
	local player = getPlayer();
	local currentFatigue
	local FatigueMult
	local OverweightMult
	local ObeseMult
	if player:HasTrait("Relentless") then
		-- return if Bare Hands
		if weapon:getType() == "BareHands" then
			return
		end
		-- get item stats
		local WeaponInPrimaryHand = player:getPrimaryHandItem();
		local WeaponInSecondaryHand = player:getSecondaryHandItem();
		-- if no mainhaind weapon then return
		if WeaponInPrimaryHand == nil then
			return
		end

		local WeaponEndMod = WeaponInPrimaryHand:getEnduranceMod();
		local WeaponWeight = WeaponInPrimaryHand:getWeight();

		if player:HasTrait("Overweight") then
			OverweightMult = 0.7
				else OverweightMult = 1
		end
		if player:HasTrait("Obese") then
			ObeseMult = 0.4
				else ObeseMult = 1
		end

		currentFatigue = player:getStats():getFatigue();
		FatigueMult = 1.0 - currentFatigue
		FatigueMult = round(FatigueMult,2)
		-- Endurance formula
		local RWeaponEndCost = (((WeaponWeight * 0.003) * WeaponEndMod) * (OverweightMult * ObeseMult)) * FatigueMult;
		local RWeaponEndCost = round(RWeaponEndCost,6)
		-- Restoring 50% of RWeaponEndCost while swing with 25% chance
		SOAddEndurance(player, 20, (RWeaponEndCost * 0.5));
	--	print("Relentless: " ..  (RWeaponEndCost * 0.5))
	--	print("FatigueMult: " ..  FatigueMult)
		end
end

-- MARATHON RUNNER TRAIT - MAIN
function marathonrunnertrait ()
	local player = getPlayer();
	if player == nil then
		return
	end
	local currentFatigue
	local FatigueMult
	local OverweightMult
	local ObeseMult
	local AthleticPenalty
	if player:HasTrait("MarathonRunner") then
--		local EndRegenChance = 100;
		local FitnessMult = 0.7 + (FitnessLvl * 0.1)

		if player:HasTrait("Overweight") then
			OverweightMult = 0.7
			else OverweightMult = 1
		end
		if player:HasTrait("Obese") then
			ObeseMult = 0.4
			else ObeseMult = 1
		end
		if FitnessLvl >= 9 then
			AthleticPenalty = 0.4
			else AthleticPenalty = 1
		end

		currentFatigue = player:getStats():getFatigue();
		FatigueMult = 1.0 - currentFatigue
		FatigueMult = round(FatigueMult,2)
		local MRRunER = (((0.00065 * FitnessMult) * AthleticPenalty) * (OverweightMult * ObeseMult)) * FatigueMult;
		local MRRunER = round(MRRunER,6)
		-- Running and Sprinting
		if player:IsRunning() == true or player:isSprinting() == true then
			if player:isPlayerMoving() and player:isSneaking() == false then
				SOAddEndurance(player, 100, MRRunER);
		--		print("MR Endurance: " ..  MRRunER)
			end
		end
	end
end

-- BETWEEN THE SHADOWS - MAIN
function ninjawaytrait ()
	local player = getPlayer();
	if player == nil then
		return
	end
	local currentFatigue
	local currentEndurance
	local FatigueMult
	local OverweightMult
	local ObeseMult
	local AthleticPenalty
	local FitnessLvlValues = {
		[0] 	= 0.7,
		[1]		= 0.8,
		[2] 	= 0.9,
		[3] 	= 1.0,
		[4] 	= 1.1,
		[5] 	= 1.2,
		[6] 	= 1.3,
		[7] 	= 1.4,
		[8] 	= 1.5,
		[9] 	= 1.55,
		[10]	= 1.6
	}
	local x = FitnessLvl;
	local FitnessMult = FitnessLvlValues[x];
	if player:HasTrait("NinjaWay") and not player:isAsleep() then
		if player:HasTrait("Overweight") then
			OverweightMult = 0.7
				else OverweightMult = 1
		end
		if player:HasTrait("Obese") then
			ObeseMult = 0.4
				else ObeseMult = 1
		end
		if FitnessLvl >= 9 then
			AthleticPenalty = 0.4
				else AthleticPenalty = 1
		end
		currentEndurance = player:getStats():getEndurance();
		currentFatigue = player:getStats():getFatigue();
		FatigueMult = 1.0 - currentFatigue
		FatigueMult = round(FatigueMult,2)
		local BtSEnduranceRUN = (((0.00065 * FitnessMult) * AthleticPenalty)* (OverweightMult * ObeseMult)) * FatigueMult;
		local BtSEnduranceRUN = round(BtSEnduranceRUN,6)
		local BtSEnduranceRegen = ((0.00065 * FitnessMult) * (OverweightMult * ObeseMult)) * FatigueMult;
		local BtSEnduranceRegen = round(BtSEnduranceRegen,6)
		if player:isSneaking() == true then
			-- Sneaking NOT MOVING
			if not player:isPlayerMoving() and currentEndurance <= 0.99 then
				if not player:getCurrentState() == PlayerAimState.instance() or player:isSitOnGround() == false then
					SOAddEndurance(player, 100, (BtSEnduranceRegen * 2));
	--				print("BtS stand: " ..  (BtSEnduranceRegen * 2))
				end
			end
			-- Sneaking WALK
			if player:isPlayerMoving() and player:IsRunning() == false then
				if player:IsAiming() == false then
					SOAddEndurance(player, 100, BtSEnduranceRegen);
	--				print("BtS Walk: " ..  BtSEnduranceRegen)
				end
			end
			-- Sneaking RUN
			if player:isPlayerMoving() and player:IsRunning() == true then
				SOAddEndurance(player, 100, (BtSEnduranceRUN * 2));
	--			print("BtS Run: " ..  (BtSEnduranceRUN * 2))
			end
		end
	end
end

-- BREATHING TECHNIQUE TRAIT - MAIN
function breathingtechtrait()
	local player = getPlayer();
	if player == nil then
		return
	end
	local currentEndurance
	local currentFatigue
	local FatigueMult
	local OverweightMult
	local ObeseMult
	local FitnessLvlValues = {
		[0] 	= 0.7,
		[1]		= 0.8,
		[2] 	= 0.9,
		[3] 	= 1.0,
		[4] 	= 1.1,
		[5] 	= 1.2,
		[6] 	= 1.3,
		[7] 	= 1.4,
		[8] 	= 1.5,
		[9] 	= 1.55,
		[10]	= 1.6
	}
	local x = FitnessLvl;
	local FitnessMult = FitnessLvlValues[x];
	if player:HasTrait("BreathingTech") then
		if player:HasTrait("Overweight") then
			OverweightMult = 0.7
				else OverweightMult = 1
		end
		if player:HasTrait("Obese") then
			ObeseMult = 0.4
				else ObeseMult = 1
		end
		currentEndurance = player:getStats():getEndurance();
		currentFatigue = player:getStats():getFatigue();
		FatigueMult = 1.0 - currentFatigue
		FatigueMult = round(FatigueMult,2)
		local BTEndRestoringAmount = ((0.0025 * FitnessMult) * (OverweightMult * ObeseMult)) * FatigueMult;
		local BTEndRestoringAmount = round(BTEndRestoringAmount,6)
		if not player:isAsleep() and currentEndurance <= 0.999 then
			-- if not moving stand
			if not player:isPlayerMoving() and player:isSitOnGround() == false then
				SOAddEndurance(player, 100, BTEndRestoringAmount);
	--			print("BThq stand: " ..  BTEndRestoringAmount)
			end
			-- if not moving sitting
			if not player:isPlayerMoving() and player:isSitOnGround() == true then
				SOAddEndurance(player, 100, (BTEndRestoringAmount * 3));
	--			print("BThq sitting: " ..  (BTEndRestoringAmount * 3))
			end
		end
	end
end

-- SORE LEGS - MAIN
function sorelegstrait()
	local player = getPlayer();
	if player == nil then
		return
	end
	if player:HasTrait("SoreLegs") then
		local Foot_L = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Foot_L"));
		local Foot_R = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Foot_R"));
		local WalkPain = 2 - (LightfootedLvl * 0.1);
		local RunPain = 5 - (SprintingLvl * 0.3);
		local SprintPain = 20 - SprintingLvl;
		local EnduranceLoss = 0.03 - (SprintingLvl * 0.002);
		-- Walking pain
		if player:isPlayerMoving() and not player:IsRunning() == true and not player:isSprinting() == true then
			if Foot_L:getPain() <= 17 then
			SOAddPain(player, 100, "Foot_L", WalkPain);
			end
			if Foot_R:getPain() <= 17 then
			SOAddPain(player, 100, "Foot_R", WalkPain);
			end
		end
		-- Running pain
		if player:IsRunning() == true and player:isPlayerMoving() then
			SOAddPain(player, 10, "UpperLeg_L", RunPain);
			SOAddPain(player, 10, "UpperLeg_R", RunPain);
			SOAddPain(player, 20, "LowerLeg_L", RunPain);
			SOAddPain(player, 20, "LowerLeg_R", RunPain);
			if Foot_L:getPain() <= 35 then
			SOAddPain(player, 30, "Foot_L", RunPain);
			end
			if Foot_R:getPain() <= 35 then
			SOAddPain(player, 30, "Foot_R", RunPain);
		end
		-- Sprinting pain
		end
		if player:isSprinting() == true and player:isPlayerMoving() then
			SOAddPain(player, 10, "UpperLeg_L", SprintPain);
			SOAddPain(player, 10, "UpperLeg_R", SprintPain);
			SOAddPain(player, 20, "LowerLeg_L", SprintPain);
			SOAddPain(player, 20, "LowerLeg_R", SprintPain);
			SOAddPain(player, 30, "Foot_L", SprintPain);
			SOAddPain(player, 30, "Foot_R", SprintPain);
			SODecEndurance(player, 100, EnduranceLoss);
		end
	end
end
-- SORE LEGS TRAIT - STOMP PAIN
function sorellegsstomppain(player, weapon)
	local player = getPlayer();
	if player:HasTrait("SoreLegs")then
--		LightfootedLvl = player:getPerkLevel(Perks.Lightfoot);
		local Foot_R = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Foot_R"));
		if weapon:getCategories():contains("Unarmed") and player:isAimAtFloor() and Foot_R:getPain() <= 50 then
			local LightfootedStompPain = 6 - (LightfootedLvl * 0.3);
			SOAddPain(player, 100, "Foot_R", LightfootedStompPain);
		end
	end
end

-- LIQUID BLOOD TRAIT - MAIN
function liquidbloodtrait()
	local player = getPlayer();
	if player:HasTrait("LiquidBlood") then
		local bodydamage = player:getBodyDamage();
		local bleeding = bodydamage:getNumPartsBleeding();
		if bleeding > 0 then
			for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
				local b = player:getBodyDamage():getBodyParts():get(i);
				if b:bleeding() and b:IsBleedingStemmed() == false then
					local damage = 0.0055;
					if b:getType() == BodyPartType.Neck then
						damage = damage * 4;
					end
					b:ReduceHealth(damage);
				end
			end
		end
	end
end

-- THICK BLOOD TRAIT - MAIN
function thickbloodtrait()
	local player = getPlayer();
		if player:HasTrait("ThickBlood") then
			local bodydamage = player:getBodyDamage();
			local bleeding = bodydamage:getNumPartsBleeding();
				if bleeding > 0 then
				for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
				local b = player:getBodyDamage():getBodyParts():get(i);
					if b:bleeding() and b:IsBleedingStemmed() == false then
					local damage = 0.0014;
					if b:getType() == BodyPartType.Neck then
					damage = damage * 6;
					end
				b:AddHealth(damage);
				end
			end
		end
	end
end

-- ALCOHOLIC TRAIT - NEGATIVE EFFECTS
function SOalcoholictrait()
    local player = getPlayer();
	if player:getModData().SOtenminutesSinceLastDrink == nil then
		player:getModData().SOtenminutesSinceLastDrink = 0;
	end
	if player:getModData().SOtenminutesToObtainAlcoholic == nil then
		player:getModData().SOtenminutesToObtainAlcoholic = 0;
	end
	-- Abstinence
	if player:HasTrait("SOAlcoholic") then
		-- one hour = 6
		local hourstosuffeifnotdrinksafe = 144; -- 24 hours
		local hourstosuffeifnotdrinkhalf = 288; -- 48 hours
		local hourstosuffeifnotdrinkfull = 576; -- 96 hours
		if player:getModData().SOtenminutesSinceLastDrink >= hourstosuffeifnotdrinksafe then
			if not player:isAsleep() and player:getStats():getStress() <= 0.55 then
				SOAddStress(player, 100, 0.005);
			end
		end
		if player:getModData().SOtenminutesSinceLastDrink >= hourstosuffeifnotdrinkhalf then
			if not player:isAsleep() then
				SOAddThirst(player, 33,  0.0001);
				SOAddStress(player, 100, 0.0035);
			end
		end
		if player:getModData().SOtenminutesSinceLastDrink >= hourstosuffeifnotdrinkfull then
			if not player:isAsleep() then
				SOAddThirst(player, 33,  0.0001);
				SOAddFatigue(player, 33, 0.0001);
			end
			SOAddPain(player, 10, "Head", (ZombRand(5)+2));
			if player:getBodyDamage():getFoodSicknessLevel() <= 40 then
				SOAddFoodSickness(player, 10, (ZombRand(5)));
			end
		end
	end
end

-- ALCOHOLIC TRAIT - REMOVE ADD
function SOalcoholictrait2()
    local player = getPlayer();
	if player:getModData().SOtenminutesSinceLastDrink == nil then
		player:getModData().SOtenminutesSinceLastDrink = 0;
	end
	if player:getModData().SOtenminutesToObtainAlcoholic == nil then
		player:getModData().SOtenminutesToObtainAlcoholic = 0;
	end
	-- increasing SOtenminutesSinceLastDrink amount if alcoholic
	if player:HasTrait("SOAlcoholic") then
		player:getModData().SOtenminutesSinceLastDrink = player:getModData().SOtenminutesSinceLastDrink + 1;
	end
	-- reducing SOtenminutesToObtainAlcoholic amount if not alcoholic
	if not player:HasTrait("SOAlcoholic") then
		player:getModData().SOtenminutesToObtainAlcoholic = player:getModData().SOtenminutesToObtainAlcoholic - 1;
	end
	-- Lose Alcoholic trait
	if player:HasTrait("SOAlcoholic") then
	local tenminutestoremovealcoholic = 6192 + ZombRand(576); -- 43-45-47 days
		if player:getModData().SOtenminutesSinceLastDrink >= tenminutestoremovealcoholic then
			getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50);
			player:getTraits():remove("SOAlcoholic");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_soalcoholic"), false, HaloTextHelper.getColorGreen());
			player:getModData().SOtenminutesToObtainAlcoholic = 0;
			player:getModData().SOtenminutesSinceLastDrink = 0;
		end
	end
	-- Gain Alcoholic trait
	if not player:HasTrait("SOAlcoholic") then
		local tenminutestoobtainalcoholic = 6192 + ZombRand(576); -- around 30 bottles
		if player:getModData().SOtenminutesToObtainAlcoholic >= tenminutestoobtainalcoholic then
			player:getTraits():add("SOAlcoholic");
			player:getModData().SOtenminutesToObtainAlcoholic = 0;
			player:getModData().SOtenminutesSinceLastDrink = 0;
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_soalcoholic"), true, HaloTextHelper.getColorRed());
		end
	end

	if player:getModData().SOtenminutesSinceLastDrink > 6768 then
		player:getModData().SOtenminutesSinceLastDrink = 6768;
		elseif player:getModData().SOtenminutesSinceLastDrink < 0 then
			player:getModData().SOtenminutesSinceLastDrink = 0;
	end
	if player:getModData().SOtenminutesToObtainAlcoholic > 6048 then
		player:getModData().SOtenminutesToObtainAlcoholic = 6048;
		elseif player:getModData().SOtenminutesToObtainAlcoholic < 0 then
		player:getModData().SOtenminutesToObtainAlcoholic = 0;
	end
--	Debug
--	print("player:getModData().SOtenminutesSinceLastDrink: " .. player:getModData().SOtenminutesSinceLastDrink);
--	print("player:getModData().SOtenminutesToObtainAlcoholic: " .. player:getModData().SOtenminutesToObtainAlcoholic);
end

function alcoholbottlesdrinked()
	local player = getPlayer();
	if player:getModData().SOAlcoholBottlesDrinked == nil then
		player:getModData().SOAlcoholBottlesDrinked = 0;
	end
	player:getModData().SOAlcoholBottlesDrinked = player:getModData().SOAlcoholBottlesDrinked - 1

	if player:getModData().SOAlcoholBottlesDrinked <= 0 then
		player:getModData().SOAlcoholBottlesDrinked = 0
	end

	if player:getSleepingTabletEffect() <= 0 then
		player:setSleepingTabletEffect(0)
	end
--	print("alcoholbottlesscale: " .. player:getModData().SOAlcoholBottlesDrinked);
end

-- ALCOHOLIC - ANIMATION
function SOalcoholicAnimshaking(player)
	local player = getPlayer();
	if player:HasTrait("SOAlcoholic") and player:getModData().SOtenminutesSinceLastDrink >= 576 and not player:isAsleep() then
		if ZombRand(10) == 0 and player:isSneaking() == false then
		player:playEmote("sosway");
		end
	end
end

-- SENSITIVE DIGESTION TRAIT - MAIN
function sensitivedigestiontrait()
	local player = getPlayer();
	if player:HasTrait("SensitiveDigestion") then
		local FoodEatenLevel = player:getMoodles():getMoodleLevel(MoodleType.FoodEaten)
		if FoodEatenLevel >= 1 then
			SOAddPain(player, 100, "Torso_Lower", 1.5);
			SOAddFoodSickness(player, 100, 0.8);
		end
	end
end

-- PANIC ATTACKS TRAIT - MAIN
function panicattackstrait ()
	local player = getPlayer();
	local playersurvivedhours = player:getHoursSurvived();
	local stats = player:getStats();
	local panic = stats:getPanic();
	local speedcontrolforpa = UIManager.getSpeedControls();
	local gamespeedforpa = speedcontrolforpa:getCurrentGameSpeed();

	if player:HasTrait("PanicAttacks") then

		PAchancecalc = 720 + (playersurvivedhours * 0.2);
		PAchance = ZombRand(PAchancecalc);

		if PAchance == 0 then
	--	Panic attack while sleeping
		if player:isAsleep() then
			forceAwakechance = ZombRand(5);
			if forceAwakechance == 0 then
				player:forceAwake();
				getSoundManager():PlaySound("ZombieSurprisedPlayer", false, 0):setVolume(0.50);
				player:playEmote("soshiver");
				SOAddPanic(player, 100, (ZombRand(21)+80));
				SOAddStress(player, 100, 0.60);
				SOAddWetness(player, 100, (ZombRand(31)+20));
			end
		end
	--	Panic attack not sleeping
		if not player:isAsleep() then
			if gamespeedforpa <= 3 then
				getSoundManager():PlaySound("ZombieSurprisedPlayer", false, 0):setVolume(0.25);
			end
			player:playEmote("soshiver");
			SOAddPanic(player, 100, (ZombRand(31)+70));
			SOAddStress(player, 100, 0.30);
--			SOAddWetness(player, 100, (ZombRand(31)+10));
			end
		end
	--	Panic increase
		if panic >= 10 and panic <= 49 then
			SOAddPanic (player, 100, (ZombRand(3)+1));
		end
		if panic >= 50 and panic <= 79 then
			SOAddPanic (player, 66, (ZombRand(5)+1));
		end
		if panic >= 80 then
			SOAddPanic (player, 33, (ZombRand(10)+1));
		end
	--	print("PAchancecalc: " .. PAchancecalc);
	--	print("PAchance: " .. PAchance);
	end
end

-- ALLERGIC TRAIT - MAIN
function allergictrait ()
	local player = getPlayer();
	if player:HasTrait("Allergic") and not player:isAsleep() then
	local itemmh = player:getPrimaryHandItem()
	local itemsh = player:getSecondaryHandItem()
		if player:HasTrait("ProneToIllness") then
		AllergicSneezeChance = 230
			else AllergicSneezeChance = 288
		end
--		print("AllergicSneezeChance: " .. AllergicSneezeChance);
		if ZombRand(AllergicSneezeChance) == 0 then
			-- Sneezing
			if not player:hasEquipped("Base.ToiletPaper") and not player:hasEquipped("Base.Tissue") then
			player:Say(getText("IGUI_PlayerText_Sneeze"));
			if not player:isOutside() then
			addSound(player, player:getX(), player:getY(), player:getZ(), 25, 50); -- range, then volume
				else
				addSound(player, player:getX(), player:getY(), player:getZ(), 50, 100); -- range, then volume
			end
			player:playEmote("sosneeze");
			end
			-- Sneezing Toilet Paper
			if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
				if ZombRand(2) == 0 then
					if itemmh and itemmh:getType() == "ToiletPaper" then
					itemmh:Use()
						elseif itemsh and itemsh:getType() == "ToiletPaper" then
						itemsh:Use()
							elseif itemmh and itemmh:getType() == "Tissue" then
							itemmh:Use()
								elseif itemsh and itemsh:getType() == "Tissue" then
								itemsh:Use()
					end
				end
			player:Say(getText("IGUI_PlayerText_SneezeMuffled"));
			addSound(player, player:getX(), player:getY(), player:getZ(), 5, 10); -- range, then volume
			player:playEmote("sosneeze");
			end
		end
	end
end

-- SNORER TRAIT - MAIN
function snorertrait ()
	local player = getPlayer();
	if player:HasTrait("Snorer") and player:isAsleep() then
		if ZombRand(30) == 0 then
			if not player:isOutside() then
			addSound(player, player:getX(), player:getY(), player:getZ(), 10, 50); -- range, then volume
				else
				addSound(player, player:getX(), player:getY(), player:getZ(), 20, 50); -- range, then volume
			end
		end
		if ZombRand(300) == 0 then
			if not player:isOutside() then
			addSound(player, player:getX(), player:getY(), player:getZ(), 15, 80); -- range, then volume
				else
				addSound(player, player:getX(), player:getY(), player:getZ(), 30, 80); -- range, then volume
			end
		end
	end
end

-- SMOKER TRAIT - MAIN
function smokertraitmain ()
	local player = getPlayer();
	local EnduranceMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.Endurance);
	if player:HasTrait("Smoker") and not player:isAsleep() then
		if EnduranceMoodleLevel >= 1 then
			local AsthmaticMult	= 1
			local EndSmokeScale = 1
			local EndSmokeCoughRange = 20
			if player:HasTrait("Asthmatic") then AsthmaticMult = 0.7 end
			if EnduranceMoodleLevel == 1 then
				EndSmokeCoughChance = 1;
				EndSmokeCoughRange = 20;
				elseif EnduranceMoodleLevel == 2 then
				EndSmokeCoughChance = 0.8;
				EndSmokeCoughRange = 23;
				elseif EnduranceMoodleLevel == 3 then
				EndSmokeCoughChance = 0.6;
				EndSmokeCoughRange = 26;
				elseif EnduranceMoodleLevel == 4 then
				EndSmokeCoughChance = 0.4;
				EndSmokeCoughRange = 30;
			end

			local SmokerCoughChance = (50 * AsthmaticMult * EndSmokeScale) -- 2.0% per min
			if ZombRand(SmokerCoughChance) == 0 then
				-- Coughing
				if not player:hasEquipped("Base.ToiletPaper") and not player:hasEquipped("Base.Tissue") then
				player:Say(getText("IGUI_PlayerText_Cough"));
				if not player:isOutside() then
				addSound(player, player:getX(), player:getY(), player:getZ(), (EndSmokeCoughRange * 0.5), 50); -- range, then volume
					else
					addSound(player, player:getX(), player:getY(), player:getZ(), EndSmokeCoughRange, 100); -- range, then volume
				end
				player:playEmote("socough");
				end
				-- Coughing Muffled
				if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
					if ZombRand(2) == 0 then
						if itemmh and itemmh:getType() == "ToiletPaper" then
						itemmh:Use()
							elseif itemsh and itemsh:getType() == "ToiletPaper" then
							itemsh:Use()
								elseif itemmh and itemmh:getType() == "Tissue" then
								itemmh:Use()
									elseif itemsh and itemsh:getType() == "Tissue" then
									itemsh:Use()
						end
					end
				player:Say(getText("IGUI_PlayerText_CoughMuffled"));
				addSound(player, player:getX(), player:getY(), player:getZ(), (EndSmokeCoughRange * 0.1), 10); -- range, then volume
				player:playEmote("socough");
				end
			end
		end

		-- ENDURANCE LOSS IF RUNNING
		if player:isPlayerMoving() and player:IsRunning() == true then
			-- player:Say("smoke run");
			SODecEndurance(player, 50, 0.0005);
		end
	end
end

function smokeroftenandhunger()
	local player = getPlayer();
	if player:HasTrait("Smoker") and not player:isAsleep() then
		local TimeSinceLastSmoke = player:getTimeSinceLastSmoke();
		-- Smoke more often
		if ZombRand(24) == 0 and TimeSinceLastSmoke <= 9 then
			player:setTimeSinceLastSmoke(TimeSinceLastSmoke + 1);
			elseif TimeSinceLastSmoke > 10 then
			player:setTimeSinceLastSmoke(10);
		end
		-- Smoker reduce hunger
		if TimeSinceLastSmoke <= 6 then
			SODecHunger(player, 50,  0.0005);
		end
		-- Smoker increase hunger
		if TimeSinceLastSmoke >= 9 then
			SOAddHunger(player, 25,  0.0005);
		end
	end
end

-- SMOKER TRAIT - ATTACK ENDUR LOSS
function smokerattack(player, weapon)
	local player = getPlayer();
	if player:HasTrait("Smoker") and not weapon:getCategories():contains("Unarmed") then
		if weapon:getCategories():contains("Blunt") or weapon:getCategories():contains("LongBlade") or weapon:getCategories():contains("Spear") or weapon:getCategories():contains("Axe") then
			SODecEndurance(player, 12, 0.0005);
		end
		if weapon:getCategories():contains("SmallBlunt") then
			SODecEndurance(player, 8, 0.0005);
		end
		if weapon:getCategories():contains("SmallBlade") then
			SODecEndurance(player, 4, 0.0005);
		end
	end
end

-- HIKER TRAIT - MAIN REGEN
function hikertrait ()
	local player = getPlayer();
	if player:getModData().SOminutesWalking == nil then
		player:getModData().SOminutesWalking = 0;
	end
	if player:HasTrait("Hiker") then
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == false and player:isSneaking() == false then
			player:getModData().SOminutesWalking = player:getModData().SOminutesWalking + 1;
			else
				player:getModData().SOminutesWalking = player:getModData().SOminutesWalking - 3;
		end
		if player:getModData().SOminutesWalking >= 10 then
			SODecFatigue(player, 20, 0.0005);
			SODecThirst(player, 20, 0.0005);
			SODecHunger(player, 20, 0.0005);
		end
		if player:getModData().SOminutesWalking > 13 then
			player:getModData().SOminutesWalking = 13;
			elseif player:getModData().SOminutesWalking < 0 then
			player:getModData().SOminutesWalking = 0;
		end
	end
end

-- OPTIMIST TRAIT - HOURS UNTIL DEPRESSION
function hoursindepression ()
	local player = getPlayer();
	if player:getModData().SOhoursUntilDepression == nil then
		player:getModData().SOhoursUntilDepression = 0;
	end
	if player:HasTrait("Optimist") then
		if player:getBodyDamage():getUnhappynessLevel() >= 39 then
			player:getModData().SOhoursUntilDepression = player:getModData().SOhoursUntilDepression + 1;
			else
				player:getModData().SOhoursUntilDepression = player:getModData().SOhoursUntilDepression - 2;
		end
		if player:getModData().SOhoursUntilDepression > 168 then
		player:getModData().SOhoursUntilDepression = 168;
			elseif player:getModData().SOhoursUntilDepression < 0 then
			player:getModData().SOhoursUntilDepression = 0;
		end
--	print("SOhoursUntilDepression = " .. player:getModData().SOhoursUntilDepression)
	end
end

-- OPTIMIST TRAIT - MAIN
function optimisttrait ()
	local player = getPlayer();
	local currentUnhappyness = player:getBodyDamage():getUnhappynessLevel();
	if player:getModData().SOhoursUntilDepression == nil then
		player:getModData().SOhoursUntilDepression = 0;
	end
	if player:HasTrait("Optimist") and not player:isAsleep() and player:getModData().SOhoursUntilDepression <= 32 then
		if player:getBodyDamage():getUnhappynessLevel() >= 50 then
			player:getBodyDamage():setUnhappynessLevel(49);
		end
	end
end

-- OPTIMIST TRAIT - BOREDOOM
function optimistraitbored ()
	local player = getPlayer();
	local boredoommod = 0.045;
	if player:HasTrait("Optimist") then
		--	passive reducing boredoom
		if not player:isAsleep() then
			SODecBoredom(player, 100, boredoommod);
		end
		--	more reducing boredoom while sleeping
		if player:isAsleep() then
			SODecBoredom(player, 25, (boredoommod * 2));
		end
	end
end

-- DEPRESSIVE TRAIT - MAIN
function depressivemoodtrait ()
	local player = getPlayer();
	if player:HasTrait("Depressive") and not player:isAsleep() then
		SOAddUnhappyness(player, 5, (ZombRand(5)+1));
		if ZombRand(1036) == 0 then
			SOAddUnhappyness(player, 100, (ZombRand(31)+70));
		end
	end
end

-- COMMERCIAL DRIVER TRAIT - MAIN
function commdrivertrait()
	local player = getPlayer();
--    local playerdata = player:getModData();
	if player:HasTrait("CommDriver") then
		if  player:isDriving() == true then
			-- player:Say("wroom");
			SODecFatigue(player, 50, 0.0015);
		end
	end
end

-- USED TO CORPSES TRAIT - MAIN
function gravemanjob(player)
	local player = getPlayer();
	local bodydamage = player:getBodyDamage();
	local foodSickness = bodydamage:getFoodSicknessLevel();
	local poison = bodydamage:getPoisonLevel();
	local infected = bodydamage:IsInfected();
	local newSickness = foodSickness - 1;
	if player:HasTrait("UsedToCorpses") and infected == false then
		if poison == 0 then
			if foodSickness > 0 and foodSickness < 20 then
				bodydamage:setFoodSicknessLevel(newSickness);
			end
		end
	end
	if newSickness < 0 then
		newSickness = 0
	end
--	print("poison = " ..  bodydamage:getPoisonLevel())
end

-- LOW SWEATING - MAIN
function lesssweatytrait()
	local player = getPlayer();
	local currentWetness = player:getBodyDamage():getWetness();
    local climateManager = getClimateManager();
    local currRainIntensity = climateManager:getRainIntensity();
 	if player:HasTrait("LessSweaty") and currentWetness > 0 and not player:isAsleep() then
		--If inside house or vehicle
		if not player:isOutside() or not player:getVehicle() == nil then
			if player:IsRunning() == false and player:isSprinting() == false then
				SODecWetness(player, 30, ZombRand(2));
			end
			if player:IsRunning() == true then
				SODecWetness(player, 20, ZombRand(2));
			end
			if player:isSprinting() == true then
				SODecWetness(player, 20, ZombRand(4));
			end
		end
		--If outside house or vehicle
		if player:isOutside() and player:getVehicle() == nil and currRainIntensity < 0.10 then
			if player:IsRunning() == false and player:isSprinting() == false then
				SODecWetness(player, 30, ZombRand(2));
			end
			if player:IsRunning() == true then
				SODecWetness(player, 20, ZombRand(2));
			end
			if player:isSprinting() == true then
				SODecWetness(player, 20, ZombRand(4));
			end
		end
		--If outside house or vehicle and rain
		if player:isOutside() and player:getVehicle() == nil and currRainIntensity > 0.10 then
			if player:IsRunning() == false and player:isSprinting() == false then
				SODecWetness(player, 15, ZombRand(2));
			end
			if player:IsRunning() == true then
				SODecWetness(player, 10, ZombRand(2));
			end
			if player:isSprinting() == true then
				SODecWetness(player, 10, ZombRand(4));
			end
		end
	end
end

-- EXCESSIVE SWEATING TRAIT - MAIN
function highsweatytrait()
	local player = getPlayer();
	if player:HasTrait("HighSweaty") then
		local climateManager = getClimateManager();
		local currRainIntensity = climateManager:getRainIntensity();
		local stats = player:getStats();
		local currpanic = stats:getPanic();
		-- if panic more than 25
		if currpanic >= 25 then
			SOAddWetness(player, 25, 0.5);
		end
		-- if panic more than 50
		if currpanic >= 50 then
			SOAddWetness(player, 25, 0.5);
		end
		-- always
		if player:IsRunning() == false and player:isSprinting() == false then
		SOAddThirst(player, 10,  0.0001);
		SOAddWetness(player, 25, 0.25);
		end
		-- if running
		if player:IsRunning() == true then
		SOAddThirst(player, 25,  0.0002);
		SOAddWetness(player, 50, 0.5);
		end
		-- if sprinting
		if player:isSprinting() == true then
		SOAddThirst(player, 50,  0.0003);
		SOAddWetness(player, 100, 1);
		end
	end
end
-- EXCESSIVE SWEATING TRAIT - ATTACK
function highsweatyattack(player, weapon)
	local player = getPlayer();
	if player:HasTrait("HighSweaty") and not player:isAsleep() then
		if not weapon:getCategories():contains("Unarmed") then
			if weapon:getCategories():contains("Blunt") or weapon:getCategories():contains("LongBlade") or weapon:getCategories():contains("Spear") or weapon:getCategories():contains("Axe") then
				SOAddThirst(player, 28,  0.0001);
				SOAddWetness(player, 50, 1)
			end
			if weapon:getCategories():contains("SmallBlunt") then
				SOAddThirst(player, 14,  0.0001);
				SOAddWetness(player, 50, 0.5)
			end
			if weapon:getCategories():contains("SmallBlade") then
				SOAddThirst(player, 7,  0.0001);
				SOAddWetness(player, 50, 0.25)
			end
		end
		if weapon:getCategories():contains("Unarmed") then
			if not player:isAimAtFloor() then
			SOAddThirst(player, 28,  0.0001);
			SOAddWetness(player, 33, 0.5)
			end
			if player:isAimAtFloor() then
			SOAddThirst(player, 28,  0.0001);
			SOAddWetness(player, 33, 0.5)
			end
		end
	end
end

-- PRONE TO ILLNESS - COLD
function pronetoillnesscold()
	local player = getPlayer();
	local ChanceToCatchACold
	if player:HasTrait("ProneToIllness") and player:isOutside() then
		if player:HasTrait("Outdoorsman") then
			ChanceToCatchACold = 1440000 -- 0.1% per 24 hours with Outdoorsman
			else ChanceToCatchACold = 144000 -- 1.0% per 24 hours
		end
		if ZombRand(ChanceToCatchACold) == 0 and not player:getBodyDamage():isHasACold() then
--			player:Say("cold +");
			local currentColdStrength = player:getBodyDamage():getColdStrength();
			local AddColdStrength = 35;
			player:getBodyDamage():setHasACold(true);
			player:getBodyDamage():setColdStrength(currentColdStrength + AddColdStrength);
		end
	end
end

-- ENJOY THE RIDE TRAIT - MAIN
function enjoytheridetrait()
	local player = getPlayer();
    if player:HasTrait("EnjoytheRide") then
        if player:isDriving() == true then
		local vehicle = player:getVehicle();
			if vehicle:getCurrentSpeedKmHour() >= 60 then
			SODecUnhappyness(player, 100, (ZombRand(5)+1));
			SODecBoredom(player, 100, 10);
			SODecStress(player, 100, 0.1);
			end
		end
	end
end

-- FEAR OF THE DARK TRAIT - MAIN
function fearofthedarktrait()
    local player = getPlayer();
	local stats = player:getStats();
	local currpanic = stats:getPanic();
	local currstress = stats:getStress();
	if player:HasTrait("FearoftheDark") and not player:isAsleep() then
		local currsquare = player:getCurrentSquare();
		if currsquare == nil then
		return
		end
		local lightLevel = currsquare:getLightLevel(player:getPlayerNum());
		if lightLevel <= 0.36 then
			if currpanic <= 15 then
				player:getStats():setPanic(currpanic + 5.9);
			end
			if player:HasTrait("Cowardly") then
				if currpanic >= 1 and currpanic <= 35 then
				player:getStats():setPanic(currpanic + (ZombRand(11)+20));
		--		player:getStats():setPanic(25);
					if currstress <= 0.3 then
					SOAddStress(player, 100, 0.05);
					end
				end
				else
					if currpanic >= 1 and currpanic <= 12 then
					player:getStats():setPanic(currpanic + (ZombRand(6)+15));
			--		player:getStats():setPanic(25);
						if currstress <= 0.3 then
						SOAddStress(player, 100, 0.05);
						end
					end
			end
			if player:getStats():getPanic() > 99 then
				player:getStats():setPanic(99);
			end
			if player:getStats():getPanic() < 0 then
				player:getStats():setPanic(0);
			end
		end
	end
--	print("lightLevel: " .. lightLevel);
end

-- BRAWLER TRAIT - MAIN
function brawlerweapontrait(actor, target, weapon)
	local player = getPlayer();
	if player:HasTrait("Brawler") then
		if actor == player and target:isZombie() == true then
			if weapon:getCategories():contains("Blunt") or weapon:getCategories():contains("LongBlade") or weapon:getCategories():contains("Spear") or weapon:getCategories():contains("Axe") then
				SODecUnhappyness(player, 15, (ZombRand(5)+1));
			end
			if weapon:getCategories():contains("SmallBlunt") then
				SODecUnhappyness(player, 15, (ZombRand(3)+1));
			end
			if weapon:getCategories():contains("SmallBlade") or weapon:getCategories():contains("Unarmed") then
				SODecUnhappyness(player, 10, (ZombRand(2)+1));
			end
		end
	end
end

-- STRONG GRIP TRAIT - MAIN
--[[function stronggtiptrait()
	local player = getPlayer();
	local inventory = player:getInventory();
	if player:HasTrait("DemoStrongGrip") then
		if player:getPrimaryHandItem() ~= nil then
			if player:getPrimaryHandItem():getType() == "Sledgehammer"
			or player:getPrimaryHandItem():getType() == "Sledgehammer2"
			then
			local sledgehammer = player:getPrimaryHandItem();
			sledgehammer:setEnduranceMod(2.0);
			sledgehammer:setBaseSpeed(1.2);
			sledgehammer:setCantAttackWithLowestEndurance(false);
			sledgehammer:setTooltip(getText("Tooltip_SOTO_StrongGripSledgehammer"));
			end
		end
	end
    if player:HasItem("Sledgehammer") == true or player:HasItem("Sledgehammer2") == true then
		local skip = false;
		if player:getPrimaryHandItem() ~= null then
			if player:getPrimaryHandItem():getTooltip() == getText("Tooltip_SOTO_StrongGripSledgehammer")
			or player:getPrimaryHandItem():getType() == "Sledgehammer"
			or player:getPrimaryHandItem():getType() == "Sledgehammer2"
			then
				skip = true;
			end
		end
		if skip == false then
			for i = 0, inventory:getItems():size() - 1 do
				local item = inventory:getItems():get(i);
				if item:getTooltip() == getText("Tooltip_SOTO_StrongGripSledgehammer") then
				local sledgehammer = item;
				sledgehammer:setEnduranceMod(4);
				sledgehammer:setBaseSpeed(0.9);
				sledgehammer:setCantAttackWithLowestEndurance(true);
				sledgehammer:setTooltip(null);
				break ;
				end
			end
		end
	end
end]]
function stronggtiptrait() --modded weapons compatibility
    local player = getSpecificPlayer(0)
    if player then
        local handItem = player:getPrimaryHandItem()
        if handItem and handItem:IsWeapon() then
            local swingAnim = handItem:getSwingAnim()
            if swingAnim and swingAnim == "Heavy" then
                local category = handItem:getCategories()
                if category:contains("Blunt") then
                    if player:HasTrait("DemoStrongGrip") then
                        handItem:setEnduranceMod(0.9)
                    else
                        handItem:setEnduranceMod(1.0)
                    end
                end
            end
        end
    end
end

-- WOOD AXE MY BELOVED TRAIT - MAIN
--[[function woodaxemybelovedtrait()
	local player = getPlayer();
	local inventory = player:getInventory();
	if player:HasTrait("WoodAxeMyBeloved") then
		if player:getPrimaryHandItem() ~= nil then
			if player:getPrimaryHandItem():getType() == "WoodAxe" then
			local woodaxe = player:getPrimaryHandItem();
			woodaxe:setBaseSpeed(1.1);
			woodaxe:setEnduranceMod(1.5);
			woodaxe:setTooltip(getText("Tooltip_SOTO_MyBelovedWoodAxe"));
			end
		end
	end
	if player:HasItem("WoodAxe") == true then
		local skip = false;
		if player:getPrimaryHandItem() ~= null then
			if player:getPrimaryHandItem():getTooltip() == getText("Tooltip_SOTO_MyBelovedWoodAxe") or player:getPrimaryHandItem():getType() == "WoodAxe" then
				skip = true;
			end
		end
		if skip == false then
--			local inv = player:getInventory();
			for i = 0, inventory:getItems():size() - 1 do
				local item = inventory:getItems():get(i);
				if item:getTooltip() == getText("Tooltip_SOTO_MyBelovedWoodAxe") then
				local woodaxe = item;
				woodaxe:setBaseSpeed(1);
				woodaxe:setEnduranceMod(3);
				woodaxe:setTooltip(null);
				break ;
				end
			end
		end
	end
end]]
function woodaxemybelovedtrait() --modded weapons compatibility
    local player = getSpecificPlayer(0)
    if player then
        local handItem = player:getPrimaryHandItem()
        if handItem and handItem:IsWeapon() then
            local swingAnim = handItem:getSwingAnim()
            if swingAnim and swingAnim == "Heavy" then
                local category = handItem:getCategories()
                if category:contains("Axe") then
                    if player:HasTrait("WoodAxeMyBeloved") then
                        handItem:setEnduranceMod(0.9)
                    else
                        handItem:setEnduranceMod(1.0)
                    end
                end
            end
        end
    end
end

-- CHOP TREE EXP
--[[function choptreesexp(player, weapon)
	local player = getPlayer();
	if weapon:getCategories():contains("Axe") then
		local WeaponTreeDamage = player:getPrimaryHandItem():getTreeDamage();
	--	print("WeaponTreeDamage: " .. WeaponTreeDamage);
			TreeAxeChopXP = 0.007 * WeaponTreeDamage;
		if player:HasTrait("WoodAxeMyBeloved") then
			TreeAxeChopXP = TreeAxeChopXP * 2;
		end
		TreeAxeChopXP = round(TreeAxeChopXP,3) -- round number to 0.000
		player:getXp():AddXP(Perks.Axe, TreeAxeChopXP);
	--	print("TreeAxeChopXP: " .. TreeAxeChopXP);
	end
end

-- RUNNING FITNESS EXP
function runningfitnessxp()
	local player = getPlayer();
	if SOTOSbvars.AddFitXPWhileRun == true then
		if FitnessLvl <= 9 and player:isPlayerMoving() and player:IsRunning() == true then
			if ZombRand(3) == 0 then
				player:getXp():AddXP(Perks.Fitness, 1);
	--			print("Fitness XP");
			end
		end
	end
end]]
function choptreesexp(player, weapon)
end

-- BLADE TOOLS - MAIN
function bladetoolstrait(player, perk, amount)
	local player = getPlayer();
	local modifier = 0.15;-- +15%
	if player:HasTrait("BladeTools") then
		if perk == Perks.LongBlade then
			amount = amount * modifier;
			player:getXp():AddXP(Perks.SmallBlade, amount, false, false, false);
		end
		if perk == Perks.SmallBlade then
			amount = amount * modifier;
			player:getXp():AddXP(Perks.LongBlade, amount, false, false, false);
		end
	end
end

-- MINER'S ENDURANCE TRAIT - MAIN
function minersednurancetrait()
	local player = getPlayer();
	local inventory = player:getInventory();
	if player:HasTrait("MinersEndurance") then
		if player:getPrimaryHandItem() ~= nil then
			if player:getPrimaryHandItem():getType() == "PickAxe" then
			local pickaxe = player:getPrimaryHandItem();
			pickaxe:setEnduranceMod(0.8);
			pickaxe:setBaseSpeed(0.9);
			pickaxe:setTooltip(getText("Tooltip_SOTO_MinersEndurancePickAxe"));
			end
		end
	end
	if player:HasItem("PickAxe") == true then
		local skip = false;
		if player:getPrimaryHandItem() ~= null then
			if player:getPrimaryHandItem():getTooltip() == getText("Tooltip_SOTO_MinersEndurancePickAxe")
			or player:getPrimaryHandItem():getType() == "PickAxe" then
				skip = true;
			end
		end
		if skip == false then
--			local inv = player:getInventory();
			for i = 0, inventory:getItems():size() - 1 do
			local item = inventory:getItems():get(i);
			if item:getTooltip() == getText("Tooltip_SOTO_MinersEndurancePickAxe") then
			local pickaxe = item;
			pickaxe:setEnduranceMod(1);
			pickaxe:setBaseSpeed(0.8);
			pickaxe:setTooltip(null);
			break ;
			end
			end
		end
	end
end

-- WEAK BACK - PAIN
function weakbackpain()
	local player = getPlayer();
	if player:HasTrait("WeakBack") then
		local Neck = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Neck"));
		if Neck:getPain() <= 15 and player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad) == 4 then
			SOAddPain(player, 100, "Neck", (ZombRand(3)+2));
			elseif Neck:getPain() <= 15 and player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad) == 3 then
			SOAddPain(player, 100, "Neck", (ZombRand(2)+1));
		end
	end
end

-- FRAGILE HEALT TRAIT - HEAVY LOAD
function fragilehealthheavyload()
	local player = getPlayer();
	if player == nil then
		return
	end
    if player:HasTrait("FragileHealth") and not player:isAsleep() then
		local HeavyLoadMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad);
		if HeavyLoadMoodleLevel >= 3 then
			if player:getBodyDamage():getOverallBodyHealth() >= 49.25 then
				for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
				local b = player:getBodyDamage():getBodyParts():get(i);
				b:AddDamage(0.25);
				end
			end
		end
	end
end

-- CALORIES TRAITS - MAIN
function caloriestraits()
	local player = getPlayer();
	if player == nil then
		return
	end
	local currcalories = player:getNutrition():getCalories()
	local weight = player:getNutrition():getWeight()

	-- calories spend PER HOUR x 60
	local CalSleeping	= 0.18
	local CalIdling		= 0.96
	local CalWalking	= 1.73
	local CalRunning	= 7.80
	local CalSprinting	= 10.14
	-- calories modifier
	local CalMod 		= 0.30 -- plus or minus 30% calories when doing actions

	-- adjusting calories
	-- callories when sleeping
	if player:isAsleep() then
		if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
			player:getNutrition():setCalories(currcalories + (CalSleeping * CalMod))
		end
		if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
			player:getNutrition():setCalories(currcalories - (CalSleeping * CalMod))
		end
		if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
			if weight >= 82 then -- loses weight faster when over 82+ weight
				player:getNutrition():setCalories(currcalories - (CalSleeping * CalMod))
			end
			if weight <= 78 then -- gains weight faster when below 78- weight
				player:getNutrition():setCalories(currcalories + (CalSleeping * CalMod))
			end
		end
	end
	-- callories when not sleeping
	if not player:isAsleep() then
		-- callories when idling
		if not player:isPlayerMoving() then
			if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
				player:getNutrition():setCalories(currcalories + (CalIdling * CalMod))
			end
			if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
				player:getNutrition():setCalories(currcalories - (CalIdling * CalMod))
			end
			if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
				if weight >= 82 then -- loses weight faster when over 82+ weight
					player:getNutrition():setCalories(currcalories - (CalIdling * CalMod))
				end
				if weight <= 78 then -- gains weight faster when below 78- weight
					player:getNutrition():setCalories(currcalories + (CalIdling * CalMod))
				end
			end

		end

		-- callories when walking
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == false then
			if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
				player:getNutrition():setCalories(currcalories + (CalWalking * CalMod))
			end
			if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
				player:getNutrition():setCalories(currcalories - (CalWalking * CalMod))
			end
			if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
				if weight >= 82 then -- loses weight faster when over 82+ weight
					player:getNutrition():setCalories(currcalories - (CalWalking * CalMod))
				end
				if weight <= 78 then -- gains weight faster when below 78- weight
					player:getNutrition():setCalories(currcalories + (CalWalking * CalMod))
				end
			end
		end

		-- callories when running
		if player:isPlayerMoving() and player:IsRunning() == true and player:isSprinting() == false then
			if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
				player:getNutrition():setCalories(currcalories + (CalRunning * CalMod))
			end
			if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
				player:getNutrition():setCalories(currcalories - (CalRunning * CalMod))
			end
			if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
				if weight >= 82 then -- loses weight faster when over 82+ weight
					player:getNutrition():setCalories(currcalories - (CalRunning * CalMod))
				end
				if weight <= 78 then -- gains weight faster when below 78- weight
					player:getNutrition():setCalories(currcalories + (CalRunning * CalMod))
				end
			end
		end

		-- callories when sprinting
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == true then
			if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
				player:getNutrition():setCalories(currcalories + (CalSprinting * CalMod))
			end
			if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
				player:getNutrition():setCalories(currcalories - (CalSprinting * CalMod))
			end
			if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
				if weight >= 82 then -- loses weight faster when over 82+ weight
					player:getNutrition():setCalories(currcalories - (CalSprinting * CalMod))
				end
				if weight <= 78 then -- gains weight faster when below 78- weight
					player:getNutrition():setCalories(currcalories + (CalSprinting * CalMod))
				end
			end
		end
	end
end
-- CALORIES TRAITS - SWING
function caloriestraitsswing(player, weapon)
	local player = getPlayer();
	if player == nil then
		return
	end
	local currcalories = player:getNutrition():getCalories()
	local weight = player:getNutrition():getWeight()

	local calswingcost	 = 2.0
	local calmod		 = 0.3

	if weapon:getSwingAnim() == Heavy then calswingcost = 6.0 end

	if player:HasTrait("Endomorph") and weight <= 90 then -- Gain weight faster when below 90 weight
		player:getNutrition():setCalories(currcalories + (calswingcost * calmod))
	end
	if player:HasTrait("Ectomorph") and weight >= 70 then -- Losing weight faster when weight over 70
		player:getNutrition():setCalories(currcalories - (calswingcost * calmod))
	end
	if player:HasTrait("AccMetabolism") then -- Losing weight faster when weight over 70
		if weight >= 82 then -- loses weight faster when over 82+ weight
			player:getNutrition():setCalories(currcalories - (calswingcost * calmod))
		end
		if weight <= 78 then -- gains weight faster when below 78- weight
			player:getNutrition():setCalories(currcalories + (calswingcost * calmod))
		end
	end
end

-- CRUELTY - MAIN
function crueltytrait(player, perk, amount)
	local player = getPlayer();
	local modifier = 0.20; -- +20%
	if player:HasTrait("Cruelty") then
		if perk == Perks.Axe
		or perk == Perks.Blunt
		or perk == Perks.SmallBlunt
		or perk == Perks.LongBlade
		or perk == Perks.SmallBlade
		or perk == Perks.Spear
		or perk == Perks.Maintenance
		or perk == Perks.Aiming
		then
--			print("Xp amount: " .. amount);
			amount = amount * modifier;
			player:getXp():AddXP(perk, amount, false, false, false);
--			print("Cruel newamount: " .. amount);
		end
	end
end

-- XP BODY TYPE TRAITS
function bodytypetraitsxp(player, perk, amount)

	local player = getPlayer();
	local stats = player:getStats();
	local hunger = stats:getHunger();

	if player:HasTrait("Ectomorph") then
		local modifier = 0.30;
		if perk == Perks.Strength then
			amount = (amount * modifier) * -1;-- -30%
			player:getXp():AddXP(perk, amount, false, false, false);
		end
		if perk == Perks.Fitness then
			amount = (amount * modifier);-- +30%
			player:getXp():AddXP(perk, amount, false, false, false);
		end
	end
	if player:HasTrait("Endomorph") then
		local modifier = 0.30;
		if perk == Perks.Fitness then
			amount = (amount * modifier) * -1;-- -30%
			player:getXp():AddXP(perk, amount, false, false, false);
		end
		if perk == Perks.Strength then
			amount = (amount * modifier);-- +30%
			player:getXp():AddXP(perk, amount, false, false, false);
		end
	end
	if player:HasTrait("FragileHealth") then
		local modifier = 0.30;
		if perk == Perks.Fitness or perk == Perks.Strength then
			amount = (amount * modifier) * -1;-- -30%
			player:getXp():AddXP(perk, amount, false, false, false);
		end
	end
	if player:HasTrait("AccMetabolism") and hunger < 0.249 then
		local modifier = 0.30; -- +30%
		if perk == Perks.Fitness or perk == Perks.Strength then
			amount = amount * modifier;
			player:getXp():AddXP(perk, amount, false, false, false);
		end
	end
end

-- DEPRESSIVE TRAIT - XP ALWAYS SHOULD BE LAST!
function depressivexp(player, perk, amount)

	if player:HasTrait("Depressive") then
		local UnhappyMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.Unhappy);
		local UnhappyXPMod = 0

		if UnhappyMoodleLevel == 2 then UnhappyXPMod = 0.03;
		elseif UnhappyMoodleLevel == 3 then UnhappyXPMod = 0.06;
		elseif UnhappyMoodleLevel == 4 then UnhappyXPMod = 0.10;
		end

		if UnhappyMoodleLevel >= 2 then
			amount = -(amount * UnhappyXPMod)
			player:getXp():AddXP(perk, amount, false, false, false);
		end
	end
end

-- EVENTS --
-- ON HIT TREE
--Events.OnWeaponHitTree.Add(choptreesexp);
-- ON HIT
Events.OnWeaponHitCharacter.Add(brawlerweapontrait);
-- ON SWING
--OnWeaponSwing
Events.OnWeaponSwingHitPoint.Add(relentlesstrait);
Events.OnWeaponSwingHitPoint.Add(sorellegsstomppain);
Events.OnWeaponSwingHitPoint.Add(highsweatyattack);
Events.OnWeaponSwingHitPoint.Add(smokerattack);
Events.OnWeaponSwingHitPoint.Add(caloriestraitsswing);
-- ON PLAYER UPDATE
Events.OnPlayerUpdate.Add(liquidbloodtrait);
Events.OnPlayerUpdate.Add(thickbloodtrait);
Events.OnPlayerUpdate.Add(optimisttrait);
-- EVERY ONE MINUTE
Events.EveryOneMinute.Add(runningfitnessxp);
Events.EveryOneMinute.Add(marathonrunnertrait);
Events.EveryOneMinute.Add(ninjawaytrait);
Events.EveryOneMinute.Add(sorelegstrait);
Events.EveryOneMinute.Add(panicattackstrait);
Events.EveryOneMinute.Add(allergictrait);
Events.EveryOneMinute.Add(commdrivertrait);
Events.EveryOneMinute.Add(optimistraitbored);
Events.EveryOneMinute.Add(smokertraitmain);
Events.EveryOneMinute.Add(hikertrait);
Events.EveryOneMinute.Add(lesssweatytrait);
Events.EveryOneMinute.Add(highsweatytrait);
Events.EveryOneMinute.Add(fearofthedarktrait);
Events.EveryOneMinute.Add(enjoytheridetrait);
Events.EveryOneMinute.Add(breathingtechtrait);
Events.EveryOneMinute.Add(weakbackpain);
Events.EveryOneMinute.Add(sensitivedigestiontrait);
Events.EveryOneMinute.Add(snorertrait);
Events.EveryOneMinute.Add(pronetoillnesscold);
Events.EveryOneMinute.Add(fragilehealthheavyload);
Events.EveryOneMinute.Add(caloriestraits);
Events.EveryOneMinute.Add(alcoholbottlesdrinked);
Events.EveryOneMinute.Add(SOalcoholictrait);
-- EVERY TEN MINUTES
Events.EveryTenMinutes.Add(weathersensitivetrait);
Events.EveryTenMinutes.Add(larkpersontrait);
Events.EveryTenMinutes.Add(owlpersontrait);
Events.EveryTenMinutes.Add(depressivemoodtrait);
Events.EveryTenMinutes.Add(gravemanjob);
Events.EveryTenMinutes.Add(smokeroftenandhunger);
Events.EveryTenMinutes.Add(SOalcoholictrait2);
Events.EveryTenMinutes.Add(SOalcoholicAnimshaking);
-- EVERY HOUR
Events.EveryHours.Add(hoursindepression);
Events.EveryHours.Add(SOcheckWeight);
-- ADD EXP
--Events.AddXP.Add(accmetabolismtrait);
Events.AddXP.Add(crueltytrait);
Events.AddXP.Add(bladetoolstrait);
Events.AddXP.Add(depressivexp);
Events.AddXP.Add(bodytypetraitsxp);
--
--
-- CHANGING ITEM STATS
-- EQUIP PRIMARY
Events.OnEquipPrimary.Add(stronggtiptrait);
Events.OnEquipPrimary.Add(woodaxemybelovedtrait);
Events.OnEquipPrimary.Add(minersednurancetrait);
-- EVERY TEN MINUTES
Events.EveryTenMinutes.Add(stronggtiptrait);
Events.EveryTenMinutes.Add(woodaxemybelovedtrait);
Events.EveryTenMinutes.Add(minersednurancetrait);
-- ON GAME START
Events.OnGameStart.Add(SOcheckWeight);
Events.OnGameStart.Add(stronggtiptrait);
Events.OnGameStart.Add(woodaxemybelovedtrait);
Events.OnGameStart.Add(minersednurancetrait);
-- ON CREATE PLAYER
Events.OnCreatePlayer.Add(SOcheckWeight);
Events.OnCreatePlayer.Add(stronggtiptrait);
Events.OnCreatePlayer.Add(woodaxemybelovedtrait);
Events.OnCreatePlayer.Add(minersednurancetrait);
--

-- add Mesomorph for old players (for few patches)
function addmesomorph()
	local player = getPlayer();
	if not player:HasTrait("Endomorph") and not player:HasTrait("Ectomorph") then
		if not player:HasTrait("Mesomorph") then
			player:getTraits():add("Mesomorph");
		end
	end
end
Events.OnGameStart.Add(addmesomorph);
Events.OnCreatePlayer.Add(addmesomorph);

--[[
function debugeveryonemin()
	local player = getPlayer();
	local bodydamage = player:getBodyDamage();
	local STEffect = player:getSleepingTabletEffect()
	local PillsTaken = player:getSleepingPillsTaken()
	print("STEffect = " .. STEffect)
	print("PillsTaken = " .. PillsTaken)
--	print("Every one min");
end
Events.EveryOneMinute.Add(debugeveryonemin);]]
