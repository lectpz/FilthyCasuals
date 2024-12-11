local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "

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

local function itemToolTipMats(tooltip, material, option, quantity)
	local playerObj = getSpecificPlayer(0)
	local playerInv = playerObj:getInventory()
	local scriptItem = ScriptManager.instance:getItem(material)
	local itemdisplayname = scriptItem:getDisplayName()
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

local function needToEatItAll(character, percent)
	if percent < 1 then character:Say("I need to eat the whole thing to receive the buff.") end
end

local function dPr(msg)
	if isDebugEnabled() then getSpecificPlayer(0):Say("Debug: " .. msg) end
end

local tickLength = 54 -- 45 irl minutes

local alertDenom = 80
local fortitudeDenom = 25
local IronChefDenom = 0.4
local luckDenom = 0.01
local SoulSmithDenom = 0.8
local SoulThirstDenom = 0.02
local shard = { "SoulForge.SoulShardT1", "SoulForge.SoulShardT2", "SoulForge.SoulShardT3", "SoulForge.SoulShardT4", "SoulForge.SoulShardT5" }

function decayAlertness()
	local pMD = getSpecificPlayer(0):getModData()
	local alertnessValue = pMD.alertnessValue or 0
	if not pMD.alertnessTimer or not pMD.alertnessValue then 
		pMD.alertnessTimer = 0
		pMD.alertnessValue = 0
		Events.EveryTenMinutes.Remove(decayAlertness) 
		return 
	end
	pMD.alertnessTimer = pMD.alertnessTimer - 1
	local stats = getPlayer():getStats()
	local fatigue = stats:getFatigue()
	stats:setFatigue(math.max(fatigue - alertnessValue,0))
	if pMD.alertnessTimer <= 0 then
		Events.EveryTenMinutes.Remove(decayAlertness)
		alertnessValue = 0
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Alert Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("Alert Decay - " .. pMD.alertnessTimer)
end

function OnEat_Alert(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.alertnessTimer and pMD.alertnessTimer > 0 then
			Events.EveryTenMinutes.Remove(decayAlertness)
		end
		
		pMD.alertnessValue = hunger/alertDenom
		pMD.alertnessTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayAlertness)
		HaloTextHelper.addTextWithArrow(character, "Alert Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
	dPr("Alert Eat")
end

function decayFortitude()
	local pMD = getSpecificPlayer(0):getModData()
	local fortitudeValue = pMD.fortitudeValue or 0
	if not pMD.fortitudeTimer or not pMD.fortitudeValue then 
		pMD.fortitudeTimer = 0
		pMD.fortitudeValue = 0
		Events.EveryTenMinutes.Remove(decayFortitude) 
		return 
	end
	pMD.fortitudeTimer = pMD.fortitudeTimer - 1
	local stats = getPlayer():getStats()
	local endurance = stats:getEndurance()
	stats:setEndurance(math.min(endurance + fortitudeValue,1))
	if pMD.fortitudeTimer <= 0 then
		Events.EveryTenMinutes.Remove(decayFortitude)
		pMD.fortitudeValue = 0
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Fortitude Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("Fortitude Decay - " .. pMD.fortitudeTimer)
end

function OnEat_Fortitude(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.fortitudeTimer and pMD.fortitudeTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.fortitudeValue = hunger/fortitudeDenom
		pMD.fortitudeTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayFortitude)
		HaloTextHelper.addTextWithArrow(character, "Fortitude Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
	dPr("Fortitude Eat")
end

function decayIronChef()
	local pMD = getSpecificPlayer(0):getModData()
	if not pMD.IronChefTimer or not pMD.IronChefValue then 
		pMD.IronChefTimer = 0
		pMD.IronChefValue = 0
		Events.EveryTenMinutes.Remove(decayIronChef) 
		return 
	end
	pMD.IronChefTimer = pMD.IronChefTimer - 1
	if pMD.IronChefTimer <= 0 then
		Events.EveryTenMinutes.Remove(decayIronChef)
		pMD.IronChefValue = 0
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Iron Chef Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("IronChef Decay - " .. pMD.IronChefTimer)
end

function OnEat_IronChef(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.IronChefTimer and pMD.IronChefTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.IronChefValue = hunger/IronChefDenom
		pMD.IronChefTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayIronChef)
		HaloTextHelper.addTextWithArrow(character, "Iron Chef Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
	dPr("IronChef Eat")
end

function decayLuck()
	local pMD = getSpecificPlayer(0):getModData()
	if not pMD.luckTimer or not pMD.luckValue then 
		pMD.luckTimer = 0
		pMD.luckValue = 0
		Events.EveryTenMinutes.Remove(decayLuck) 
		return 
	end
	pMD.luckTimer = pMD.luckTimer - 1
	if pMD.luckTimer <= 0 then
		Events.EveryTenMinutes.Remove(decayLuck)
		pMD.luckValue = 0
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Luck Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("Luck Decay - " .. pMD.luckTimer)
end

function OnEat_Luck(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.luckTimer and pMD.luckTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.luckValue = hunger/luckDenom
		pMD.luckTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decayLuck)
		HaloTextHelper.addTextWithArrow(character, "Luck Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
	dPr("Luck Eat")
end

function SoulSmithOnWeaponHitXP(player, handWeapon, character, damageSplit)
	if handWeapon:getType() == "BareHands" then return end
	local SoulSmithValue = player:getModData().SoulSmithValue
	if SoulSmithValue then
		if ZombRand(0,100) < SoulSmithValue then
			local weapRestore = ZombRand(2)+1
			handWeapon:setCondition(math.floor(handWeapon:getCondition() + weapRestore + 0.5))
			HaloTextHelper.addTextWithArrow(player, "+" .. weapRestore .. " weapon condition restored.", true, HaloTextHelper.getColorGreen());
		end
	end
	dPr("Soul Smith Hit")
end

function decaySoulSmith()
	local pMD = getSpecificPlayer(0):getModData()
	if not pMD.SoulSmithTimer or not pMD.SoulSmithValue then 
		pMD.SoulSmithTimer = 0
		pMD.SoulSmithValue = 0
		Events.EveryTenMinutes.Remove(decaySoulSmith) 
		return 
	end
	pMD.SoulSmithTimer = pMD.SoulSmithTimer - 1
	if pMD.SoulSmithTimer <= 0 then
		Events.EveryTenMinutes.Remove(decaySoulSmith)
		pMD.SoulSmithValue = 0
		Events.OnWeaponHitXp.Remove(SoulSmithOnWeaponHitXP)
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Soul Smith Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("Soul Smith Decay - " .. pMD.SoulSmithTimer)
end

function OnEat_SoulSmith(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.SoulSmithTimer and pMD.SoulSmithTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulSmith) --remove previous hook
			Events.OnWeaponHitXp.Remove(SoulSmithOnWeaponHitXP)
		end
		
		pMD.SoulSmithValue = hunger/SoulSmithDenom
		pMD.SoulSmithTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulSmith)
		Events.OnWeaponHitXp.Add(SoulSmithOnWeaponHitXP)
		HaloTextHelper.addTextWithArrow(character, "Soul Smith Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
end

function decaySoulThirst()
	local pMD = getSpecificPlayer(0):getModData()
	if not pMD.SoulThirstTimer or not pMD.SoulThirstValue then 
		pMD.SoulThirstTimer = 0
		pMD.SoulThirstValue = 0
		Events.EveryTenMinutes.Remove(decaySoulThirst) 
		return 
	end
	pMD.SoulThirstTimer = pMD.SoulThirstTimer - 1
	if pMD.SoulThirstTimer <= 0 then
		Events.EveryTenMinutes.Remove(decaySoulThirst)
		pMD.SoulThirstValue = 0
		HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Soul Thirst Buff Removed. ", false, HaloTextHelper.getColorRed());
	end
	dPr("Soul Thirst Decay - " .. pMD.SoulThirstTimer)
end

function OnEat_SoulThirst(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local hunger = food:getModData().hungerChange
		local pMD = character:getModData()
		
		if pMD.SoulThirstTimer and pMD.SoulThirstTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulThirst) --remove previous hook
		end
		
		pMD.SoulThirstValue = hunger/SoulThirstDenom
		pMD.SoulThirstTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulThirst)
		HaloTextHelper.addTextWithArrow(character, "Soul Thirst Buff Active. ", true, HaloTextHelper.getColorGreen());
	end
end

function infuseOnGameStart()
	local pMD = getSpecificPlayer(0):getModData()
	if pMD.alertnessTimer 	and pMD.alertnessTimer	> 0 then Events.EveryTenMinutes.Add(decayAlertness) end
	if pMD.IronChefTimer	and pMD.IronChefTimer 	> 0 then Events.EveryTenMinutes.Add(decayIronChef) end
	if pMD.fortitudeTimer 	and pMD.fortitudeTimer	> 0 then Events.EveryTenMinutes.Add(decayFortitude) end
	if pMD.luckTimer 		and pMD.luckTimer		> 0 then Events.EveryTenMinutes.Add(decayLuck) end
	if pMD.SoulSmithTimer 	and pMD.SoulSmithTimer	> 0 then Events.EveryTenMinutes.Add(decaySoulSmith) end
	if pMD.SoulThirstTimer 	and pMD.SoulThirstTimer	> 0 then Events.EveryTenMinutes.Add(decaySoulThirst) end
end
Events.OnGameStart.Add(infuseOnGameStart)

function infuseAlert(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_Alert")
	itemModData.setOnEat = "OnEat_Alert"
	itemModData.hungerChange = item:getHungerChange() * -1
	local playerInv = playerObj:getInventory()
	for i=1,3 do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end

function infuseFortitude(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_Fortitude")
	itemModData.setOnEat = "OnEat_Fortitude"
	itemModData.hungerChange = item:getHungerChange() * -1
	for i=1,4 do
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end

function infuseIronChef(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_IronChef")
	itemModData.setOnEat = "OnEat_IronChef"
	itemModData.hungerChange = item:getHungerChange() * -1
	for i=1,3 do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end

function infuseLuck(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_Luck")
	itemModData.setOnEat = "OnEat_Luck"
	itemModData.hungerChange = item:getHungerChange() * -1
	for i=1,4 do
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,15 do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end

function infuseSoulSmith(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_SoulSmith")
	itemModData.setOnEat = "OnEat_SoulSmith"
	itemModData.hungerChange = item:getHungerChange() * -1
	for i=1,4 do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,15 do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end

function infuseSoulThirst(item, playerObj)
	local itemModData = item:getModData()
	item:setOnEat("OnEat_SoulThirst")
	itemModData.setOnEat = "OnEat_SoulThirst"
	itemModData.hungerChange = item:getHungerChange() * -1
	for i=1,3 do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,10 do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
end


local function soulInfuse(player, context, _items)
	local playerObj = getSpecificPlayer(player)
	items = ISInventoryPane.getActualItems(_items)

	for i=1, #items do
		item = items[i]
		if instanceof(item, "Food") then
			local iMD = item:getModData()
			--dPr("Hunger Change value: " .. item:getHungerChange())
			local setOnEatFlag = iMD.setOnEat or false
			if setOnEatFlag then 
				item:setOnEat(setOnEatFlag) 
				if setOnEatFlag == "OnEat_Alert" then
					local hasAlertness = context:addOption("Soul-Infused (Alertness)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will recover " .. math.floor(iMD.hungerChange/alertDenom*54*100) .. "%  of fatigue bar over 45 minutes. <LINE> "
					hasAlertness.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_Fortitude" then
					local hasFortitude = context:addOption("Soul-Infused (Fortitude)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will recover " .. math.floor(iMD.hungerChange/fortitudeDenom*54*100) .. "% of endurance bar over 45 minutes. <LINE> "
					hasFortitude.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_IronChef" then
					local hasIronChef = context:addOption("Soul-Infused (IronChef)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will elevate your cooking skills. Foods cooked while this buff is active will last " .. math.floor(iMD.hungerChange/IronChefDenom*100)/100 .. "% longer. This buff lasts 45 minutes. <LINE> "
					hasIronChef.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_Luck" then
					local hasLuck = context:addOption("Soul-Infused (Luck)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will increase your luck by " .. math.floor(iMD.hungerChange/luckDenom*100)/100 .. " for 45 minutes. <LINE> "
					hasLuck.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_SoulSmith" then
					local hasSoulSmith	= context:addOption("Soul-Infused (SoulSmith)", item, infuseSoulSmith, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(iMD.hungerChange/SoulSmithDenom*100)/100 .. "% chance to repair your weapon with each successful hit for 45 minutes. <LINE> "
					hasSoulSmith.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_SoulThirst" then
					local hasSoulThirst	= context:addOption("Soul-Infused (SoulThirst)", item, infuseSoulThirst, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(iMD.hungerChange/SoulThirstDenom*100)/100 .. "% chance to gain an additional soul on kill. This buff lasts for 45 minutes. <LINE> "
					hasSoulThirst.toolTip = tooltip
				end
				break
			end
			if not item:getOnEat() then
				infuseCtx 	= context:addOption("Infuse Food with Souls", item, nil, playerObj)
				submenu 	= ISContextMenu:getNew(context)
				context:addSubMenu(infuseCtx, submenu)
				
				Alertness 	= submenu:addOption("Infuse Food with Souls (Alertness)", item, infuseAlert, playerObj)
				Fortitude 	= submenu:addOption("Infuse Food with Souls (Fortitude)", item, infuseFortitude, playerObj)
				IronChef 	= submenu:addOption("Infuse Food with Souls (IronChef)", item, infuseIronChef, playerObj)
				Luck		= submenu:addOption("Infuse Food with Souls (Luck)", item, infuseLuck, playerObj)
				SoulSmith	= submenu:addOption("Infuse Food with Souls (SoulSmith)", item, infuseSoulSmith, playerObj)
				SoulThirst	= submenu:addOption("Infuse Food with Souls (SoulThirst)", item, infuseSoulThirst, playerObj)
				
				local iMD = item:getModData()
				local setOnEatFlag = iMD.setOnEat or false
				
				local AlertnessMatNo = {3,3}
				alerttooltip = ISWorldObjectContextMenu.addToolTip();
				alerttooltip.description = alerttooltip.description .. green .. "Eating this infused food will recover " .. math.floor(-1*item:getHungerChange()/alertDenom*54*100) .. "% of fatigue bar over 45 minutes. <LINE> "
				alerttooltip.description = alerttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Alertness:"
				itemToolTipMats(alerttooltip, shard[1], Alertness, AlertnessMatNo[1])
				itemToolTipMats(alerttooltip, shard[2], Alertness, AlertnessMatNo[2])
				Alertness.toolTip = alerttooltip
				
				local FortitudeMatNo = {4,4}
				forttooltip = ISWorldObjectContextMenu.addToolTip();
				forttooltip.description = forttooltip.description .. green .. "Eating this infused food will recover " .. math.floor(-1*item:getHungerChange()/fortitudeDenom*54*100) .. "% of endurance bar over 45 minutes. <LINE> "
				forttooltip.description = forttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Fortitude:"
				itemToolTipMats(forttooltip, shard[2], Fortitude, FortitudeMatNo[1])
				itemToolTipMats(forttooltip, shard[3], Fortitude, FortitudeMatNo[2])
				Fortitude.toolTip = forttooltip
				
				local IronChefMatNo = {3,3}
				ironcheftooltip = ISWorldObjectContextMenu.addToolTip();
				ironcheftooltip.description = ironcheftooltip.description .. green .. "Eating this infused food will elevate your cooking skills. Foods cooked while this buff is active will last " .. math.floor(-1*item:getHungerChange()/IronChefDenom*100)/100 .. "% longer. This buff lasts 45 minutes. <LINE> "
				ironcheftooltip.description = ironcheftooltip.description .. " <LINE> " .. gold .. "Materials required to infuse IronChef:"
				itemToolTipMats(ironcheftooltip, shard[1], IronChef, IronChefMatNo[1])
				itemToolTipMats(ironcheftooltip, shard[2], IronChef, IronChefMatNo[2])
				IronChef.toolTip = ironcheftooltip
				
				local LuckMatNo = {4,4,15}
				lucktooltip = ISWorldObjectContextMenu.addToolTip();
				lucktooltip.description = lucktooltip.description .. green .. "Eating this infused food will increase your luck by " .. math.floor(-1*item:getHungerChange()/luckDenom*100)/100 .. " for 45 minutes. <LINE> "
				lucktooltip.description = lucktooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Luck:"
				itemToolTipMats(lucktooltip, shard[2], Luck, LuckMatNo[1])
				itemToolTipMats(lucktooltip, shard[3], Luck, LuckMatNo[2])
				itemToolTipMats(lucktooltip, "Base.ScrapMetal", Luck, LuckMatNo[3])
				Luck.toolTip = lucktooltip

				local SoulSmithMatNo = {4,4,4,15}
				soulsmithtooltip = ISWorldObjectContextMenu.addToolTip();
				soulsmithtooltip.description = soulsmithtooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(-1*item:getHungerChange()/SoulSmithDenom*100)/100 .. "% chance to repair your weapon with each successful hit for 45 minutes. <LINE> "
				soulsmithtooltip.description = soulsmithtooltip.description .. " <LINE> " .. gold .. "Materials required to infuse SoulSmith:"
				itemToolTipMats(soulsmithtooltip, shard[1], SoulSmith, SoulSmithMatNo[1])
				itemToolTipMats(soulsmithtooltip, shard[2], SoulSmith, SoulSmithMatNo[2])
				itemToolTipMats(soulsmithtooltip, shard[3], SoulSmith, SoulSmithMatNo[3])
				itemToolTipMats(soulsmithtooltip, "Base.ScrapMetal", SoulSmith, SoulSmithMatNo[4])
				SoulSmith.toolTip = soulsmithtooltip
				
				local SoulThirstMatNo = {3,3,3,10}
				soulthirsttooltip = ISWorldObjectContextMenu.addToolTip();
				soulthirsttooltip.description = soulthirsttooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(-1*item:getHungerChange()/SoulThirstDenom*100)/100 .. "% chance to gain an additional soul on kill. This buff lasts for 45 minutes. <LINE> "
				soulthirsttooltip.description = soulthirsttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse SoulThirst:"
				itemToolTipMats(soulthirsttooltip, shard[1], SoulThirst, SoulThirstMatNo[1])
				itemToolTipMats(soulthirsttooltip, shard[2], SoulThirst, SoulThirstMatNo[2])
				itemToolTipMats(soulthirsttooltip, shard[3], SoulThirst, SoulThirstMatNo[3])
				itemToolTipMats(soulthirsttooltip, "Base.ScrapMetal", SoulThirst, SoulThirstMatNo[4])
				SoulThirst.toolTip = soulthirsttooltip
				
				break
			end
		end
	end
end

Events.OnPreFillInventoryObjectContextMenu.Add(soulInfuse)

local o_doContextualDblClick = ISInventoryPane.doContextualDblClick
function ISInventoryPane:doContextualDblClick(item)
	if instanceof(item, "Food") then
		local iMD = item:getModData()
		--dPr("Hunger Change value: " .. item:getHungerChange())
		local setOnEatFlag = iMD.setOnEat or false
		if setOnEatFlag then 
			item:setOnEat(setOnEatFlag) 
			dPr("Set flag: " .. setOnEatFlag)
		end
	end
	o_doContextualDblClick(self,item)
end