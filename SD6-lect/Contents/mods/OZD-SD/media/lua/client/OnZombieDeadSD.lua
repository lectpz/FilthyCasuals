----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
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

local function zPerks(player, tierzone, zombieSprinterValue)
	if player:isSeatedInVehicle() then return end
	player:getXp():AddXP(Perks.Strength, tierzone*5*(1+zombieSprinterValue/100));
	player:getXp():AddXP(Perks.Fitness, tierzone*5*(1+zombieSprinterValue/100));
	player:getXp():AddXP(Perks.Sprinting, tierzone*5*(zombieSprinterValue/100));
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
	
	local eventenabled = SandboxVars.SDevents.enabled	
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
	local n5 = #table4
	local t5 = ZombRand(n5)+1
	
	local rmwtable4 = splitString(SandboxVars.RWC.table4)
	local rmwn4 = #rmwtable4 
	local rmwt4 = ZombRand(rmwn4)+1	
	
	local rmwtable5 = splitString(SandboxVars.RWC.table5)
	local rmwn5 = #rmwtable5 
	local rmwt5 = ZombRand(rmwn5)+1	
	
	local bling = {"Hat_Beret", "Hat_BaseballCapBlue", "Hat_BaseballCap", "Tie_Worn", "Hat_BaseballCap_Reverse", "Hat_BaseballCapKY", "OHI_8", "Necklace_Silver", "NecklaceLong_Silver", "NoseRing_Silver", "NoseStud_Silver", "Earring_LoopLrg_Silver", "Earring_LoopMed_Silver", "Earring_LoopSmall_Silver_Both", "Earring_LoopSmall_Silver_Top", "Earring_Stud_Silver", "Ring_Right_MiddleFinger_Silver", "Ring_Left_MiddleFinger_Silver", "Ring_Right_RingFinger_Silver", "Ring_Left_RingFinger_Silver", "Bracelet_BangleRightSilver", "Bracelet_BangleLeftSilver", "Bracelet_ChainRightSilver", "Bracelet_ChainLeftSilver", "NoseStud_Gold", "Necklace_Gold", "NecklaceLong_Gold", "NoseRing_Gold", "Earring_LoopLrg_Gold", "Earring_LoopMed_Gold", "Earring_LoopSmall_Gold_Both", "Earring_LoopSmall_Gold_Top", "Earring_Stud_Gold", "Ring_Right_MiddleFinger_Gold", "Ring_Left_MiddleFinger_Gold", "Ring_Right_RingFinger_Gold", "Ring_Left_RingFinger_Gold", "Bracelet_BangleRightGold", "Bracelet_BangleLeftGold", "Bracelet_ChainRightGold", "Bracelet_ChainLeftGold", "Necklace_GoldDiamond", "Necklace_SilverDiamond", "NecklaceLong_GoldDiamond", "NecklaceLong_SilverDiamond", "Necklace_Choker_Diamond", "Earring_Dangly_Diamond", "Ring_Right_MiddleFinger_SilverDiamond", "Ring_Left_MiddleFinger_SilverDiamond", "Ring_Right_RingFinger_SilverDiamond", "Ring_Left_RingFinger_SilverDiamond", "Ring_Right_MiddleFinger_GoldDiamond", "Ring_Left_MiddleFinger_GoldDiamond", "Ring_Right_RingFinger_GoldDiamond", "Ring_Left_RingFinger_GoldDiamond", "Necklace_GoldRuby", "Necklace_SilverSapphire", "Necklace_Pearl", "NecklaceLong_SilverEmerald", "NecklaceLong_SilverSapphire", "Necklace_Choker_Sapphire", "Earring_Stone_Sapphire", "Earring_Stone_Emerald", "Earring_Stone_Ruby", "Earring_Pearl", "Earring_Dangly_Sapphire", "Earring_Dangly_Emerald", "Earring_Dangly_Ruby", "Earring_Dangly_Pearl", "Ring_Right_MiddleFinger_GoldRuby", "Ring_Left_MiddleFinger_GoldRuby", "Ring_Right_RingFinger_GoldRuby", "Ring_Left_RingFinger_GoldRuby", "Necklace_SilverCrucifix", "Necklace_Crucifix", "Necklace_YingYang", "NecklaceLong_Amber", "Necklace_Choker_Amber", "Bracelet_RightFriendshipTINT", "Bracelet_LeftFriendshipTINT", "Necklace_Choker", "BellyButton_DangleGold", "BellyButton_DangleGold", "BellyButton_DangleGoldRuby", "BellyButton_DangleGoldRuby", "BellyButton_DangleSilver", "BellyButton_DangleSilverDiamond", "BellyButton_RingGold", "BellyButton_RingGold", "BellyButton_RingGoldDiamond", "BellyButton_RingGoldDiamond", "BellyButton_RingGoldRuby", "BellyButton_RingGoldRuby", "BellyButton_RingSilver", "BellyButton_RingSilverAmethyst", "BellyButton_RingSilverDiamond", "BellyButton_RingSilverRuby", "BellyButton_StudGold", "BellyButton_StudGold", "BellyButton_StudGoldDiamond", "BellyButton_StudGoldDiamond", "BellyButton_StudSilver", "BellyButton_StudSilverDiamond", "Glasses_Aviators", "Necklace_DogTag", "Glasses", "Glasses_Normal", "Glasses_Reading", "Glasses_Shooting", "Glasses_Sun", "Glasses_SwimmingGoggles", "WristWatch_Right_DigitalBlack", "WristWatch_Right_ClassicBlack", "WristWatch_Right_ClassicBrown", "WristWatch_Right_ClassicGold", "WristWatch_Right_DigitalDress", "WristWatch_Right_DigitalRed", "WristWatch_Right_ClassicMilitary", "WristWatch_Left_DigitalBlack", "WristWatch_Left_ClassicBlack", "WristWatch_Left_ClassicBrown", "WristWatch_Left_ClassicGold", "WristWatch_Left_DigitalDress", "WristWatch_Left_DigitalRed", "WristWatch_Left_ClassicMilitary"}
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

	local t1roll = ZombRand(math.max(SandboxVars.OZD.roll1 - math.floor(zombieSprinterValue*0.25) - 0.25*(controlMod + toxicMod + luckValue), 1))
	local t2roll = ZombRand(math.max(SandboxVars.OZD.roll2 - math.floor(zombieSprinterValue*0.5) - 0.5*(controlMod + toxicMod + luckValue), 1))
	local t3roll = ZombRand(math.max(SandboxVars.OZD.roll3 - math.floor(zombieSprinterValue*1.25) - controlMod - toxicMod - luckValue, 1))
	local t4roll = ZombRand(math.max(SandboxVars.OZD.roll4 - math.floor(zombieSprinterValue*2) - controlMod - toxicMod - luckValue, 1))
	local t5roll = ZombRand(math.max(SandboxVars.OZD.roll5 - math.floor(zombieSprinterValue*2.5) - controlMod - toxicMod - luckValue, 1))
	
-- function to add item
	local function itemdrop(item)
		--zombie:getSquare():AddWorldInventoryItem(item, 0, 0, 0) --use this if you want it items to drop onto the ground
		if not item then return end
		local newItem = InventoryItemFactory.CreateItem(item)
		MDZ_OnCreate_MeleeWeaponVariance(newItem)
		zombie:getInventory():AddItem(newItem) --use this if you want the items to spawn into a zombie body
	end	
	
	--check if player is in event zone, if event enabled and inside the zone then use event rolls, otherwise use the 
	--[[if eventenabled then
		local x = player:getX()
		local y = player:getY()
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			t1roll = ZombRand(math.max(SandboxVars.SDevents.roll1 - math.floor(zombieSprinterValue*0.25) - 0.25*(controlMod + toxicMod + luckValue), 1))
			t2roll = ZombRand(math.max(SandboxVars.SDevents.roll2 - math.floor(zombieSprinterValue*0.5) - 0.5*(controlMod + toxicMod + luckValue), 1))
			t3roll = ZombRand(math.max(SandboxVars.SDevents.roll3 - math.floor(zombieSprinterValue*1.25) - controlMod - toxicMod - luckValue, 1))
			t4roll = ZombRand(math.max(SandboxVars.SDevents.roll4 - math.floor(zombieSprinterValue*2) - controlMod - toxicMod - luckValue, 1))
			t5roll = ZombRand(math.max(SandboxVars.SDevents.roll5 - math.floor(zombieSprinterValue*2.5) - controlMod - toxicMod - luckValue, 1))
		end
	end]]
	
	--if isDebugEnabled() then player:Say("luck value: " .. luckValue) end
	
	local controlRNG = 5
	if control then controlRNG = 2 end
	
	if tierzone == 5 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t5roll == 0 then
			if ZombRand(controlRNG) == 0 then
				itemdrop(rmwtable5[rmwt5])
			else
				itemdrop(table5[t5])
			end
		elseif t4roll == 0 then
			if ZombRand(controlRNG) == 0 then
				itemdrop(rmwtable4[rmwt4])
			else
				itemdrop(table4[t4])
			end
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

		if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end

	elseif tierzone == 4 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t4roll == 0 then
			if ZombRand(5) == 0 then
				itemdrop(rmwtable4[rmwt4])
			else
				itemdrop(table4[t4])
			end
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

		if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end

	elseif tierzone == 3 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

		if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end

	elseif tierzone == 2 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

		if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end

	elseif tierzone == 1 then
		zPerks(player, tierzone, zombieSprinterValue)
		if t1roll == 0 then
			itemdrop(table1[t1])
		end

		if ZombRand(7-tierzone) == 0 then zombie:getInventory():AddItem(bling[ZombRand(#bling)+1]) end

	end
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)