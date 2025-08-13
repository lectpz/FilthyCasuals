----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "

local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "

local white = " <RGB:1,1,1> "

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local zombieDeathRattle = {
    "You... don't get... to... stay alive...",
	"Dad... is that... you?",
	"Mom-my..? I missed... you...",
	"Where.... is... my... son...",
	"Where.... is... my... daughter...",
	"Shop... at... McCrae's...",
	"I'm... not... bitten... please... stay...",
	"Tell... dodous... I want... mannequin... back....",
	"Your... cities... will... lie... in... dust...",
	"I... need... about... tree fiddy...",
	"SD... is... too... easy...",
	"GoofyGooberBill... Enjoyer",
	"How's... Petros... house...",
	"We've been trying... to reach you about your cars... extended warranty...",
	"Where.. is your.. face? Where's mine..",
	"Peel it.. off..",
	"Get.. away from me..",
	"There.. was a.. knife fight..",
	"Can I.. join your.. faction?",
	"I.. crave brains.. you.. seem safe..",
	"Hello .. fellow.. human",
	"How many.. times.. do you.. wipe?",
	"Deals.. to die for.. at.. at..",
	"Ayo... That's toxic!",
	"Urgggh...Pain...",
	"Suffering...constant...",
	"End me...",
	"In Hell...",
	"Can't...stop...hunger...",
	"Lake Cumberland...bunker...",
	"Big Bear Lake... hidden base...",
	"Take...your...skin...",
	"Give me...flesh...",
	"Eternal...suffering...end...me...",
	"Not in...control...stop...me...",
	"...Why...",
	"...Help...",
	"Petroville...is...safe...",
	"You...can't run...",
	"We will...find you...",
	"Died...at...Sunny...Event...",
	"I...miss...my...cats...",
	"Blood...is on...fire...help...",
	"No more... cat... gifs...",
	"Deep inside... Petro... vi-",
}

local bling = {"Hat_Beret", "Hat_BaseballCapBlue", "Hat_BaseballCap", "Tie_Worn", "Hat_BaseballCap_Reverse", "Hat_BaseballCapKY", "OHI_8", "Necklace_Silver", "NecklaceLong_Silver", "NoseRing_Silver", "NoseStud_Silver", "Earring_LoopLrg_Silver", "Earring_LoopMed_Silver", "Earring_LoopSmall_Silver_Both", "Earring_LoopSmall_Silver_Top", "Earring_Stud_Silver", "Ring_Right_MiddleFinger_Silver", "Ring_Left_MiddleFinger_Silver", "Ring_Right_RingFinger_Silver", "Ring_Left_RingFinger_Silver", "Bracelet_BangleRightSilver", "Bracelet_BangleLeftSilver", "Bracelet_ChainRightSilver", "Bracelet_ChainLeftSilver", "NoseStud_Gold", "Necklace_Gold", "NecklaceLong_Gold", "NoseRing_Gold", "Earring_LoopLrg_Gold", "Earring_LoopMed_Gold", "Earring_LoopSmall_Gold_Both", "Earring_LoopSmall_Gold_Top", "Earring_Stud_Gold", "Ring_Right_MiddleFinger_Gold", "Ring_Left_MiddleFinger_Gold", "Ring_Right_RingFinger_Gold", "Ring_Left_RingFinger_Gold", "Bracelet_BangleRightGold", "Bracelet_BangleLeftGold", "Bracelet_ChainRightGold", "Bracelet_ChainLeftGold", "Necklace_GoldDiamond", "Necklace_SilverDiamond", "NecklaceLong_GoldDiamond", "NecklaceLong_SilverDiamond", "Necklace_Choker_Diamond", "Earring_Dangly_Diamond", "Ring_Right_MiddleFinger_SilverDiamond", "Ring_Left_MiddleFinger_SilverDiamond", "Ring_Right_RingFinger_SilverDiamond", "Ring_Left_RingFinger_SilverDiamond", "Ring_Right_MiddleFinger_GoldDiamond", "Ring_Left_MiddleFinger_GoldDiamond", "Ring_Right_RingFinger_GoldDiamond", "Ring_Left_RingFinger_GoldDiamond", "Necklace_GoldRuby", "Necklace_SilverSapphire", "Necklace_Pearl", "NecklaceLong_SilverEmerald", "NecklaceLong_SilverSapphire", "Necklace_Choker_Sapphire", "Earring_Stone_Sapphire", "Earring_Stone_Emerald", "Earring_Stone_Ruby", "Earring_Pearl", "Earring_Dangly_Sapphire", "Earring_Dangly_Emerald", "Earring_Dangly_Ruby", "Earring_Dangly_Pearl", "Ring_Right_MiddleFinger_GoldRuby", "Ring_Left_MiddleFinger_GoldRuby", "Ring_Right_RingFinger_GoldRuby", "Ring_Left_RingFinger_GoldRuby", "Necklace_SilverCrucifix", "Necklace_Crucifix", "Necklace_YingYang", "NecklaceLong_Amber", "Necklace_Choker_Amber", "Bracelet_RightFriendshipTINT", "Bracelet_LeftFriendshipTINT", "Necklace_Choker", "BellyButton_DangleGold", "BellyButton_DangleGold", "BellyButton_DangleGoldRuby", "BellyButton_DangleGoldRuby", "BellyButton_DangleSilver", "BellyButton_DangleSilverDiamond", "BellyButton_RingGold", "BellyButton_RingGold", "BellyButton_RingGoldDiamond", "BellyButton_RingGoldDiamond", "BellyButton_RingGoldRuby", "BellyButton_RingGoldRuby", "BellyButton_RingSilver", "BellyButton_RingSilverAmethyst", "BellyButton_RingSilverDiamond", "BellyButton_RingSilverRuby", "BellyButton_StudGold", "BellyButton_StudGold", "BellyButton_StudGoldDiamond", "BellyButton_StudGoldDiamond", "BellyButton_StudSilver", "BellyButton_StudSilverDiamond", "Glasses_Aviators", "Necklace_DogTag", "Glasses", "Glasses_Normal", "Glasses_Reading", "Glasses_Shooting", "Glasses_Sun", "Glasses_SwimmingGoggles", "WristWatch_Right_DigitalBlack", "WristWatch_Right_ClassicBlack", "WristWatch_Right_ClassicBrown", "WristWatch_Right_ClassicGold", "WristWatch_Right_DigitalDress", "WristWatch_Right_DigitalRed", "WristWatch_Right_ClassicMilitary", "WristWatch_Left_DigitalBlack", "WristWatch_Left_ClassicBlack", "WristWatch_Left_ClassicBrown", "WristWatch_Left_ClassicGold", "WristWatch_Left_DigitalDress", "WristWatch_Left_DigitalRed", "WristWatch_Left_ClassicMilitary"}

local function zPerks(player, tierzone, zombieSprinterValue)
	if player:isSeatedInVehicle() then return end
	player:getXp():AddXP(Perks.Strength, tierzone*5*(1+zombieSprinterValue/100));
	player:getXp():AddXP(Perks.Fitness, tierzone*5*(1+zombieSprinterValue/100));
	player:getXp():AddXP(Perks.Sprinting, tierzone*5*(zombieSprinterValue/100));
end

local function checkTier(tierzone)
	if tierzone == 6 then return true end
	return false
end

local function itemdrop(item, player, zombie, shouldDrop)
	if not item then return end
	local scriptItem = ScriptManager.instance:getItem(item)
	local newItem = InventoryItemFactory.CreateItem(item)
	MDZ_OnCreate_MeleeWeaponVariance(newItem, true)
	if shouldDrop and ZombRand(4) == 0 then
		local weaponModData = newItem:getModData()
		
		weaponModData.KillCount = 0
		weaponModData.SoulForged = true
		weaponModData.PlayerKills = player:getZombieKills()
		weaponModData.ConditionLowerChance = 1.1
		weaponModData.MaxCondition = 1.1
		weaponModData.MaxHitCount = weaponModData.MaxHitCount + 1
		weaponModData.Augments = 1
		
		local rng = ZombRand(3)
		
		if rng == 0 then
			
			weaponModData.soulForgeMinDmgMulti = 1.15
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
							
			weaponModData.s2_desc = gold .. "Suffix Modifer: COG" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMinDmgMulti*100-100))  .. "% More Minimum Damage <LINE> "
			
			weaponModData.suffix2 = "COG"
			
			newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
			newItem:setMinDamage(newItem:getMinDamage() * weaponModData.soulForgeMinDmgMulti)
			
		elseif rng == 1 then
		
			weaponModData.soulForgeMaxDmgMulti = 1.15
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
		
			weaponModData.s2_desc = gold .. "Suffix Modifer: Voidwalker" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMaxDmgMulti*100-100))  .. "% More Maximum Damage <LINE> "
			
			weaponModData.suffix2 = "Voidwalker"
			
			newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
			newItem:setMinDamage(newItem:getMinDamage() * weaponModData.soulForgeMaxDmgMulti)
			
		elseif rng == 2 then
		
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.soulForgeCritMulti = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
			
			weaponModData.s2_desc = gold .. "Suffix Modifer: Ranger" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritMulti*100-100))  .. "% More Critical Damage Multiplier <LINE> "
			
			weaponModData.suffix2 = "Ranger"
			
			newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
			newItem:setCritDmgMultiplier(newItem:getCritDmgMultiplier() * weaponModData.soulForgeCritMulti)
			
		end
		
		local mdzPrefix = ""
		if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
		
		weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName() .. " of the " .. weaponModData.suffix2
		
		newItem:setName(mdzPrefix .. weaponModData.Name)
		newItem:setMaxHitCount(weaponModData.MaxHitCount)
		newItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
		newItem:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
		
	end
	zombie:getInventory():AddItem(newItem)
end	

function OnZombieDeadItemDrop(zombie)
	local player = zombie:getAttackedBy()
    if not player or not instanceof(player, "IsoPlayer") or not player:isLocalPlayer() then return end
	
	if player:isSeatedInVehicle() then 
		if ZombRand(8) == 0 then zombie:addLineChatElement("Lousy... Sunday... Drivers...") end
		return 
	end
	if ZombRand(15) == 0 then zombie:addLineChatElement(zombieDeathRattle[ZombRand(#zombieDeathRattle)+1]) end
	--player:Say("OZD TEST")
	local tierzone, zonename, playerx, playery, control, toxic = checkZone()
--	local tierzone = 4
	
	local controlMod = 0
	local toxicMod = 0
	if control then controlMod = 50 end
	if toxic  then toxicMod = 50 end
	
	local pMD = player:getModData()
	local luckValue = pMD.luckValue or 0
	local permaLuck = pMD.PermaSoulForgeLuckBonus 
	if permaLuck then luckValue = luckValue + permaLuck end

	local table1 = splitString(SandboxVars.OZD.table1)
	local n1 = #table1
	local t1 = ZombRand(n1)+1

	local table2 = splitString(SandboxVars.OZD.table2)
	local n2 = #table2
	local t2 = ZombRand(n2)+1

	local table3 = splitString(SandboxVars.OZD.table3)
	local n3 = #table3
	local t3 = ZombRand(n3)+1
	
	local table4 = splitString(SandboxVars.OZD.table4)
	local n4 = #table4
	local t4 = ZombRand(n4)+1
	
	local table5 = splitString(SandboxVars.OZD.table5)
	local n5 = #table5
	local t5 = ZombRand(n5)+1
	
	local rmwtable4 = splitString(SandboxVars.RWC.table4)
	local rmwn4 = #rmwtable4 
	local rmwt4 = ZombRand(rmwn4)+1	
	
	local rmwtable5 = splitString(SandboxVars.RWC.table5)
	local rmwn5 = #rmwtable5 
	local rmwt5 = ZombRand(rmwn5)+1	
	
-- calculate roll for tiers /// ZombRand(n) where n is the number of zombies to kill before that tier may drop
    
	local modData = zombie:getModData()
	local zombieSprinterValue = 0
	if modData.SDspeed == 1 then
		zombieSprinterValue = modData.SDSprinterZoneValue or 0
		--player:Say("killed a sprinter")
		--player:Say("sprinter zone value: " .. zombieSprinterValue)
	else
		zombieSprinterValue = 0
	end
	--adjust zombrand by subtracting sprinter zone values.
	
	local cappedRoll = { 100, 200, 300, 400, 500, 600 }
	if isAdmin() or isDebugEnabled() then cappedRoll = { 1, 1, 1, 1, 1, 1 } end

	local t1roll = ZombRand(math.max(SandboxVars.OZD.roll1 - math.floor(zombieSprinterValue*0.25) - 0.25*(controlMod + toxicMod + luckValue), cappedRoll[1] ))
	local t2roll = ZombRand(math.max(SandboxVars.OZD.roll2 - math.floor(zombieSprinterValue*0.5) - 0.5*(controlMod + toxicMod + luckValue), cappedRoll[2] ))
	local t3roll = ZombRand(math.max(SandboxVars.OZD.roll3 - math.floor(zombieSprinterValue*1.25) - controlMod - toxicMod - luckValue, cappedRoll[3] ))
	local t4roll = ZombRand(math.max(SandboxVars.OZD.roll4 - math.floor(zombieSprinterValue*2) - controlMod - toxicMod - luckValue, cappedRoll[4] ))
	local t5roll = ZombRand(math.max(SandboxVars.OZD.roll5 - math.floor(zombieSprinterValue*2.5) - controlMod - toxicMod - luckValue, cappedRoll[5] ))
	local t6roll = ZombRand(math.max(SandboxVars.OZD.roll6 - math.floor(zombieSprinterValue*3.0) - controlMod - toxicMod - luckValue, cappedRoll[6] ))

--[[	local function itemdrop(item, zombie)
		if not item then return end
		local scriptItem = ScriptManager.instance:getItem(item)
		local newItem = InventoryItemFactory.CreateItem(item)
		MDZ_OnCreate_MeleeWeaponVariance(newItem, true)
		if tierzone == 6 and ZombRand(5) == 0 then
			local weaponModData = newItem:getModData()
			
			weaponModData.KillCount = 0
			weaponModData.SoulForged = true
			weaponModData.PlayerKills = player:getZombieKills()
			weaponModData.ConditionLowerChance = 1.1
			weaponModData.MaxCondition = 1.1
			weaponModData.MaxHitCount = weaponModData.MaxHitCount + 1
			weaponModData.Augments = 1
			
			local rng = ZombRand(3)
			
			if rng == 0 then
				
				weaponModData.soulForgeMinDmgMulti = 1.15
				weaponModData.soulForgeCritRate = 1.2
				weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
				weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
								
				weaponModData.s2_desc = gold .. "Suffix Modifer: COG" ..
										green .. " <LINE> Max Hit Count +" .. 1 ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMinDmgMulti*100-100))  .. "% More Minimum Damage <LINE> "
				
				weaponModData.suffix2 = "COG"
				
				newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
				newItem:setMinDamage(newItem:getMinDamage() * weaponModData.soulForgeMinDmgMulti)
				
			elseif rng == 1 then
			
				weaponModData.soulForgeMaxDmgMulti = 1.15
				weaponModData.soulForgeCritRate = 1.2
				weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
				weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
			
				weaponModData.s2_desc = gold .. "Suffix Modifer: Voidwalker" ..
										green .. " <LINE> Max Hit Count +" .. 1 ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMaxDmgMulti*100-100))  .. "% More Maximum Damage <LINE> "
				
				weaponModData.suffix2 = "Voidwalker"
				
				newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
				newItem:setMinDamage(newItem:getMinDamage() * weaponModData.soulForgeMaxDmgMulti)
				
			elseif rng == 2 then
			
				weaponModData.soulForgeCritRate = 1.2
				weaponModData.soulForgeCritMulti = 1.2
				weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
				weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
				
				weaponModData.s2_desc = gold .. "Suffix Modifer: Ranger" ..
										green .. " <LINE> Max Hit Count +" .. 1 ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.ConditionLowerChance*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.MaxCondition*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
										green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritMulti*100-100))  .. "% More Critical Damage Multiplier <LINE> "
				
				weaponModData.suffix2 = "Ranger"
				
				newItem:setCriticalChance(newItem:getCriticalChance() * weaponModData.soulForgeCritRate)
				newItem:setCritDmgMultiplier(newItem:getCritDmgMultiplier() * weaponModData.soulForgeCritMulti)
				
			end
			
			local mdzPrefix = ""
			if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
			
			weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName() .. " of the " .. weaponModData.suffix2
			
			newItem:setName(mdzPrefix .. weaponModData.Name)
			newItem:setMaxHitCount(weaponModData.MaxHitCount)
			newItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
			newItem:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)
			
		end
		zombie:getInventory():AddItem(newItem)
	end	]]
	
	local controlRNG = 5
	if control then controlRNG = 2 end
	
	if tierzone == 6 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t6roll == 0 then
			if ZombRand(2) == 0 then
				itemdrop(rmwtable5[rmwt5], player, zombie, true)
			else
				itemdrop(table5[t5], player, zombie, true)
			end
		elseif t5roll == 0 then
			if ZombRand(controlRNG) == 0 then
				itemdrop(rmwtable5[rmwt5], player, zombie)
			else
				itemdrop(table5[t5], player, zombie)
			end
		elseif t4roll == 0 then
			if ZombRand(2) == 0 then
				itemdrop(rmwtable4[rmwt4], player, zombie)
			else
				itemdrop(table4[t4], player, zombie)
			end
		elseif t3roll == 0 then
			itemdrop(table3[t3], player, zombie)
		elseif t2roll == 0 then
			itemdrop(table2[t2], player, zombie)
		elseif t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end
		
	elseif tierzone == 5 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t5roll == 0 then
			if ZombRand(controlRNG) == 0 then
				itemdrop(rmwtable5[rmwt5], player, zombie)
			else
				itemdrop(table5[t5], player, zombie)
			end
		elseif t4roll == 0 then
			if ZombRand(controlRNG) == 0 then
				itemdrop(rmwtable4[rmwt4], player, zombie)
			else
				itemdrop(table4[t4], player, zombie)
			end
		elseif t3roll == 0 then
			itemdrop(table3[t3], player, zombie)
		elseif t2roll == 0 then
			itemdrop(table2[t2], player, zombie)
		elseif t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end

	elseif tierzone == 4 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t4roll == 0 then
			if ZombRand(5) == 0 then
				itemdrop(rmwtable4[rmwt4], player, zombie)
			else
				itemdrop(table4[t4], player, zombie)
			end
		elseif t3roll == 0 then
			itemdrop(table3[t3], player, zombie)
		elseif t2roll == 0 then
			itemdrop(table2[t2], player, zombie)
		elseif t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end

	elseif tierzone == 3 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t3roll == 0 then
			itemdrop(table3[t3], player, zombie)
		elseif t2roll == 0 then
			itemdrop(table2[t2], player, zombie)
		elseif t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end

	elseif tierzone == 2 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t2roll == 0 then
			itemdrop(table2[t2], player, zombie)
		elseif t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end

	elseif tierzone == 1 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t1roll == 0 then
			itemdrop(table1[t1], player, zombie)
		end

	end
	if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)