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
local fortitudeDenom = 15
local IronChefDenom = 0.5
local luckDenom = 0.0125
local SoulSmithDenom = 0.6
local SoulThirstDenom = 0.02
local shard = { "SoulForge.SoulShardT1", "SoulForge.SoulShardT2", "SoulForge.SoulShardT3", "SoulForge.SoulShardT4", "SoulForge.SoulShardT5" }

local buffTimer = {}

local function checkTimestamp(buff)
	local timestamp = getTimestamp()
	if buffTimer[buff] and (timestamp-buffTimer[buff] < 10) then
		buffTimer[buff] = timestamp
		return false
	end
	buffTimer[buff] = timestamp
	return true
end

function decayAlertness()
	if not checkTimestamp("Alert") then return end
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
		local fMD = food:getModData()
		local hunger = fMD.hungerChange
		local ironChefBuff = 1
		if fMD.ironChefBuff then ironChefBuff = fMD.ironChefBuff end
		local pMD = character:getModData()
		
		if pMD.alertnessTimer and pMD.alertnessTimer > 0 then
			Events.EveryTenMinutes.Remove(decayAlertness)
		end
		
		pMD.alertnessValue = hunger/alertDenom
		pMD.alertnessTimer = tickLength * ironChefBuff --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayAlertness)
		HaloTextHelper.addTextWithArrow(character, "Alert Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Alert"] = getTimestamp()
	end
	dPr("Alert Eat")
end

function decayFortitude()
	if not checkTimestamp("Fortitude") then return end
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
		local fMD = food:getModData()
		local hunger = fMD.hungerChange
		local ironChefBuff = 1
		if fMD.ironChefBuff then ironChefBuff = fMD.ironChefBuff end
		local pMD = character:getModData()
		
		if pMD.fortitudeTimer and pMD.fortitudeTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.fortitudeValue = hunger/fortitudeDenom
		pMD.fortitudeTimer = tickLength * ironChefBuff --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayFortitude)
		HaloTextHelper.addTextWithArrow(character, "Fortitude Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Fortitude"] = getTimestamp()
	end
	dPr("Fortitude Eat")
end

function decayIronChef()
	if not checkTimestamp("IronChef") then return end
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
		local fMD = food:getModData()
		local hunger = fMD.hungerChange
		local pMD = character:getModData()
		
		if pMD.IronChefTimer and pMD.IronChefTimer > 0 then
			Events.EveryTenMinutes.Remove(decayIronChef)
		end
		
		pMD.IronChefValue = hunger/IronChefDenom
		pMD.IronChefTimer = tickLength --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		Events.EveryTenMinutes.Add(decayIronChef)
		HaloTextHelper.addTextWithArrow(character, "Iron Chef Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["IronChef"] = getTimestamp()
	end
	dPr("IronChef Eat")
end

function decayLuck()
	if not checkTimestamp("Luck") then return end
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
		local fMD = food:getModData()
		local ironChefBuff = 1
		if fMD.ironChefBuff then ironChefBuff = fMD.ironChefBuff end
		local hunger = fMD.hungerChange
		local pMD = character:getModData()
		
		if pMD.luckTimer and pMD.luckTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.luckValue = hunger/luckDenom
		pMD.luckTimer = tickLength * ironChefBuff --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decayLuck)
		HaloTextHelper.addTextWithArrow(character, "Luck Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Luck"] = getTimestamp()
	end
	dPr("Luck Eat")
end

function SoulSmithOnWeaponHitXP(player, handWeapon, character, damageSplit)
	if player ~= getSpecificPlayer(0) then return end
	if handWeapon:getType() == "BareHands" or handWeapon:isRanged() then return end
	local weaponCondition = handWeapon:getCondition()
	local maxCondition = handWeapon:getConditionMax()
	if weaponCondition >= maxCondition*2 then return end
	local pMD = player:getModData()
	local permaSoulSmithValue = pMD.PermaSoulSmithValue
	local SoulSmithValue = pMD.SoulSmithValue or 0
	
	local faction = pMD.faction
	if handWeapon and handWeapon:getModData().suffix2 == "Ranger" then
		if faction == "Ranger" then SoulSmithValue = SoulSmithValue + 1.05 else SoulSmithValue = SoulSmithValue + 0.35 end
	end

	if SoulSmithValue and permaSoulSmithValue and permaSoulSmithValue > 0 then SoulSmithValue = SoulSmithValue + permaSoulSmithValue end
	if SoulSmithValue and SoulSmithValue > 0 then
		if ZombRand(0,10000) < SoulSmithValue*100 then
			local weapRestore = 1
			handWeapon:setCondition(math.floor(weaponCondition + weapRestore + 0.5))
			HaloTextHelper.addTextWithArrow(player, "+" .. weapRestore .. " weapon condition restored.", true, HaloTextHelper.getColorGreen());
			dPr("Soul Smith Hit")
		end
	end
end

function decaySoulSmith()
	if not checkTimestamp("SoulSmith") then return end
	local pMD = getSpecificPlayer(0):getModData()
	local permaSoulSmith = pMD.PermaSoulSmithValue
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
		--if not permaSoulSmith and not (permaSoulSmith > 0) then 
			--Events.OnWeaponHitXp.Remove(SoulSmithOnWeaponHitXP)
			HaloTextHelper.addTextWithArrow(getSpecificPlayer(0), "Soul Smith Food Buff Removed. ", false, HaloTextHelper.getColorRed());
		--end
	end
	dPr("Soul Smith Decay - " .. pMD.SoulSmithTimer)
end

function OnEat_SoulSmith(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local fMD = food:getModData()
		local hunger = fMD.hungerChange
		local ironChefBuff = 1
		if fMD.ironChefBuff then ironChefBuff = fMD.ironChefBuff end
		local pMD = character:getModData()
		local permaSoulSmith = pMD.PermaSoulSmithValue
		
		if pMD.SoulSmithTimer and pMD.SoulSmithTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulSmith) --remove previous hook
			--Events.OnWeaponHitXp.Remove(SoulSmithOnWeaponHitXP)
		end
		
		pMD.SoulSmithValue = hunger/SoulSmithDenom
		pMD.SoulSmithTimer = tickLength * ironChefBuff --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulSmith)
		--Events.OnWeaponHitXp.Add(SoulSmithOnWeaponHitXP)
		HaloTextHelper.addTextWithArrow(character, "Soul Smith Food Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["SoulSmith"] = getTimestamp()
	end
end

local function initSoulSmith(player)
	local pMD = player:getModData()
	local permaSoulSmith = pMD.PermaSoulSmithValue
	Events.OnWeaponHitXp.Add(SoulSmithOnWeaponHitXP)
	
	local handItem = player:getPrimaryHandItem()
	
	if (permaSoulSmith and permaSoulSmith > 0) or (pMD.SoulSmithTimer and pMD.SoulSmithTimer > 0) or (handItem and handItem:getModData().suffix2 == "Ranger") then
		HaloTextHelper.addTextWithArrow(player, "Soul Smith Active.", true, HaloTextHelper.getColorGreen());
	end
	Events.OnPlayerMove.Remove(initSoulSmith)
end
Events.OnPlayerMove.Add(initSoulSmith)

function decaySoulThirst()
	if not checkTimestamp("SoulThirst") then return end
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
		local fMD = food:getModData()
		local hunger = fMD.hungerChange
		local ironChefBuff = 1
		if fMD.ironChefBuff then ironChefBuff = fMD.ironChefBuff end
		local pMD = character:getModData()
		
		if pMD.SoulThirstTimer and pMD.SoulThirstTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulThirst) --remove previous hook
		end
		
		pMD.SoulThirstValue = hunger/SoulThirstDenom
		pMD.SoulThirstTimer = tickLength * ironChefBuff --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulThirst)
		HaloTextHelper.addTextWithArrow(character, "Soul Thirst Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["SoulThirst"] = getTimestamp()
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
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)

	local itemModData = item:getModData()
	local pMD = playerObj:getModData()
	
	itemModData.ironChefBuff = 1
	if pMD.IronChefValue and pMD.IronChefValue > 0 then
		itemModData.ironChefBuff = pMD.IronChefValue / 10 + 1
		item:setAge(-1000000)
		item:setOffAge(item:getOffAge() * 5 * itemModData.ironChefBuff)
		item:setOffAgeMax(item:getOffAgeMax() * 5 * itemModData.ironChefBuff)
	end
		
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_Alert")
	itemModData.setOnEat_new = "OnEat_Alert"
	itemModData.hungerChange = item:getHungerChange() * -1 * itemModData.ironChefBuff
	
	local playerInv = playerObj:getInventory()
	playerInv:RemoveOneOf(shard[1])
	playerInv:RemoveOneOf(shard[2])
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Alert Infused " .. item:getDisplayName())
end

function infuseFortitude(item, playerObj)
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)
	
	local itemModData = item:getModData()
	local pMD = playerObj:getModData()
	
	itemModData.ironChefBuff = 1
	if pMD.IronChefValue and pMD.IronChefValue > 0 then
		itemModData.ironChefBuff = pMD.IronChefValue / 10 + 1
		item:setAge(-1000000)
		item:setOffAge(item:getOffAge() * 5 * itemModData.ironChefBuff)
		item:setOffAgeMax(item:getOffAgeMax() * 5 * itemModData.ironChefBuff)
	end
	
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_Fortitude")
	itemModData.setOnEat_new = "OnEat_Fortitude"
	itemModData.hungerChange = item:getHungerChange() * -1 * itemModData.ironChefBuff
	
	local mats = 3
	local scrapmetal = 25
	
	if countItems(playerObj, shard[2]) < mats then return end
	if countItems(playerObj, shard[3]) < mats then return end
	
	for i=1,mats do
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Fortitude Infused " .. item:getDisplayName())
end

function infuseIronChef(item, playerObj)
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)
	
	local itemModData = item:getModData()
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_IronChef")
	itemModData.setOnEat_new = "OnEat_IronChef"
	itemModData.hungerChange = item:getHungerChange() * -1
	
	local mats = 4
	local scrapmetal = 25
	
	if countItems(playerObj, shard[1]) < mats then return end
	if countItems(playerObj, shard[2]) < mats then return end
	
	for i=1,mats do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Iron Chef Infused " .. item:getDisplayName())
end

function infuseLuck(item, playerObj)
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)
	
	local itemModData = item:getModData()
	local pMD = playerObj:getModData()
	
	itemModData.ironChefBuff = 1
	if pMD.IronChefValue and pMD.IronChefValue > 0 then
		itemModData.ironChefBuff = pMD.IronChefValue / 10 + 1
		item:setAge(-1000000)
		item:setOffAge(item:getOffAge() * 5 * itemModData.ironChefBuff)
		item:setOffAgeMax(item:getOffAgeMax() * 5 * itemModData.ironChefBuff)
	end
	
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_Luck")
	itemModData.setOnEat_new = "OnEat_Luck"
	itemModData.hungerChange = item:getHungerChange() * -1 * itemModData.ironChefBuff
	
	local mats = 6
	local scrapmetal = 25
	
	if countItems(playerObj, shard[1]) < mats then return end
	if countItems(playerObj, shard[2]) < mats then return end
	if countItems(playerObj, shard[3]) < mats then return end
	if countItems(playerObj, "Base.ScrapMetal") < scrapmetal then return end
	
	for i=1,mats do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,scrapmetal do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Luck Infused " .. item:getDisplayName())
end

function infuseSoulSmith(item, playerObj)
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)
	
	local itemModData = item:getModData()
	local pMD = playerObj:getModData()
	
	itemModData.ironChefBuff = 1
	if pMD.IronChefValue and pMD.IronChefValue > 0 then
		itemModData.ironChefBuff = pMD.IronChefValue / 10 + 1
		item:setAge(-1000000)
		item:setOffAge(item:getOffAge() * 5 * itemModData.ironChefBuff)
		item:setOffAgeMax(item:getOffAgeMax() * 5 * itemModData.ironChefBuff)
	end
	
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_SoulSmith")
	itemModData.setOnEat_new = "OnEat_SoulSmith"
	itemModData.hungerChange = item:getHungerChange() * -1 * itemModData.ironChefBuff
	
	local mats = 3
	local scrapmetal = 25
	
	if countItems(playerObj, shard[1]) < mats then return end
	if countItems(playerObj, shard[2]) < mats then return end
	if countItems(playerObj, shard[3]) < mats then return end
	if countItems(playerObj, "Base.ScrapMetal") < scrapmetal then return end
	
	for i=1,mats do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,scrapmetal do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Soul Smith Infused " .. item:getDisplayName())
end

function infuseSoulThirst(item, playerObj)
	--item:setOffAge(1000000000)
	--item:setOffAgeMax(1000000000)
	
	local itemModData = item:getModData()
	local pMD = playerObj:getModData()
	
	itemModData.ironChefBuff = 1
	if pMD.IronChefValue and pMD.IronChefValue > 0 then
		itemModData.ironChefBuff = pMD.IronChefValue / 10 + 1
		item:setAge(-1000000)
		item:setOffAge(item:getOffAge() * 5 * itemModData.ironChefBuff)
		item:setOffAgeMax(item:getOffAgeMax() * 5 * itemModData.ironChefBuff)
	end
	
	local playerInv = playerObj:getInventory()
	item:setOnEat("OnEat_SoulThirst")
	itemModData.setOnEat_new = "OnEat_SoulThirst"
	itemModData.hungerChange = item:getHungerChange() * -1 * itemModData.ironChefBuff
	
	local mats = 3
	local scrapmetal = 10
	
	if countItems(playerObj, shard[1]) < mats then return end
	if countItems(playerObj, shard[2]) < mats then return end
	if countItems(playerObj, shard[3]) < mats then return end
	if countItems(playerObj, "Base.ScrapMetal") < scrapmetal then return end
	
	for i=1,3 do
		playerInv:RemoveOneOf(shard[1])
		playerInv:RemoveOneOf(shard[2])
		playerInv:RemoveOneOf(shard[3])
		--playerInv:RemoveOneOf(shard[4])
	end
	for i=1,scrapmetal do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	getSoundManager():PlayWorldSoundImpl("infuseFood", false, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 0.2, 10, 0.05, false) ;
	item:setName("Soul Thirst Infused " .. item:getDisplayName())
end


local function soulInfuse(player, context, _items)
	local playerObj = getSpecificPlayer(player)
	items = ISInventoryPane.getActualItems(_items)
	local pMD = playerObj:getModData()

	for i=1, #items do
		item = items[i]
		--if not item:isInPlayerInventory() then return end
		if instanceof(item, "Food") then
			local iMD = item:getModData()
			local ironChefBuff = iMD.ironChefBuff or 1
			if pMD.IronChefValue and not iMD.ironChefBuff then ironChefBuff = pMD.IronChefValue / 10 + 1 end
			--print(ironChefBuff)
			
			--dPr("Hunger Change value: " .. item:getHungerChange())
			local setOnEatFlag = iMD.setOnEat_new or false
			if setOnEatFlag then 
				item:setOnEat(setOnEatFlag) 
				if setOnEatFlag == "OnEat_Alert" then
					local hasAlertness = context:addOption("Soul-Infused (Alertness)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will recover " .. math.floor(iMD.hungerChange/alertDenom*54*100) .. "%  of fatigue bar over " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
					hasAlertness.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_Fortitude" then
					local hasFortitude = context:addOption("Soul-Infused (Fortitude)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will recover " .. math.floor(iMD.hungerChange/fortitudeDenom*54*100) .. "% of endurance bar over " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
					hasFortitude.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_IronChef" then
					local hasIronChef = context:addOption("Soul-Infused (IronChef)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					local ironChefFoodBuff = math.floor(iMD.hungerChange/IronChefDenom*100)/100
					tooltip.description = tooltip.description .. green .. "Eating this infused food will elevate your cooking skills. Foods cooked while this buff is active will last longer. Bonus " .. ironChefFoodBuff*10 .. "% to Soul Infused foods cooked while buff is active. Bonus " .. 5*(ironChefFoodBuff/10) .. "% to Soul Infused food age timer while buff is active. This buff lasts 45 minutes. <LINE> "
					hasIronChef.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_Luck" then
					local hasLuck = context:addOption("Soul-Infused (Luck)", item, nil, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will increase your luck by " .. math.floor(iMD.hungerChange/luckDenom*100)/100 .. " for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
					hasLuck.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_SoulSmith" then
					local hasSoulSmith	= context:addOption("Soul-Infused (SoulSmith)", item, infuseSoulSmith, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(iMD.hungerChange/SoulSmithDenom*100)/100 .. "% chance to repair your weapon with each successful hit for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
					hasSoulSmith.toolTip = tooltip
				elseif setOnEatFlag == "OnEat_SoulThirst" then
					local hasSoulThirst	= context:addOption("Soul-Infused (SoulThirst)", item, infuseSoulThirst, playerObj)
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. green .. "Eating this infused food will give you a " .. math.min(100,math.floor(iMD.hungerChange/SoulThirstDenom*100)/100) .. "% chance to gain an additional soul on kill. This buff lasts for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
					hasSoulThirst.toolTip = tooltip
				end
				break
			end

			if not item:getOnEat() and item:isInPlayerInventory() then
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
				local setOnEatFlag = iMD.setOnEat_new or false
				
				local AlertnessMatNo = {1,1}
				alerttooltip = ISWorldObjectContextMenu.addToolTip();
				alerttooltip.description = alerttooltip.description .. green .. "Eating this infused food will recover " .. math.floor(-1*item:getHungerChange()/alertDenom*54*100)*ironChefBuff .. "% of fatigue bar over " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
				alerttooltip.description = alerttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Alertness:"
				itemToolTipMats(alerttooltip, shard[1], Alertness, AlertnessMatNo[1])
				itemToolTipMats(alerttooltip, shard[2], Alertness, AlertnessMatNo[2])
				Alertness.toolTip = alerttooltip
				
				local FortitudeMatNo = {3,3}
				forttooltip = ISWorldObjectContextMenu.addToolTip();
				forttooltip.description = forttooltip.description .. green .. "Eating this infused food will recover " .. math.floor(-1*item:getHungerChange()/fortitudeDenom*54*100)*ironChefBuff .. "% of endurance bar over " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
				forttooltip.description = forttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Fortitude:"
				itemToolTipMats(forttooltip, shard[2], Fortitude, FortitudeMatNo[1])
				itemToolTipMats(forttooltip, shard[3], Fortitude, FortitudeMatNo[2])
				Fortitude.toolTip = forttooltip
				
				local IronChefMatNo = {4,4}
				ironcheftooltip = ISWorldObjectContextMenu.addToolTip();
				local ironChefFoodBuff = math.floor(-item:getHungerChange()/IronChefDenom*100)/100
				ironcheftooltip.description = ironcheftooltip.description .. green .. "Eating this infused food will elevate your cooking skills. Foods cooked while this buff is active will last longer. Bonus " .. ironChefFoodBuff*10 .. "% hunger value to Soul Infused foods while buff is active. Bonus " .. 5*(ironChefFoodBuff*10) .. "% to Soul Infused food age timer while buff is active. This buff lasts 45 minutes. <LINE> "
				ironcheftooltip.description = ironcheftooltip.description .. " <LINE> " .. gold .. "Materials required to infuse IronChef:"
				itemToolTipMats(ironcheftooltip, shard[1], IronChef, IronChefMatNo[1])
				itemToolTipMats(ironcheftooltip, shard[2], IronChef, IronChefMatNo[2])
				IronChef.toolTip = ironcheftooltip
				
				local LuckMatNo = {6,6,6,25}
				lucktooltip = ISWorldObjectContextMenu.addToolTip();
				lucktooltip.description = lucktooltip.description .. green .. "Eating this infused food will increase your luck by " .. math.floor(-1*item:getHungerChange()/luckDenom*100)/100*ironChefBuff .. " for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
				lucktooltip.description = lucktooltip.description .. " <LINE> " .. gold .. "Materials required to infuse Luck:"
				itemToolTipMats(lucktooltip, shard[1], Luck, LuckMatNo[1])
				itemToolTipMats(lucktooltip, shard[2], Luck, LuckMatNo[2])
				itemToolTipMats(lucktooltip, shard[3], Luck, LuckMatNo[3])
				itemToolTipMats(lucktooltip, "Base.ScrapMetal", Luck, LuckMatNo[4])
				Luck.toolTip = lucktooltip

				local SoulSmithMatNo = {3,3,3,25}
				soulsmithtooltip = ISWorldObjectContextMenu.addToolTip();
				soulsmithtooltip.description = soulsmithtooltip.description .. green .. "Eating this infused food will give you a " .. math.floor(-1*item:getHungerChange()/SoulSmithDenom*100)/100*ironChefBuff .. "% chance to repair your weapon with each successful hit for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
				soulsmithtooltip.description = soulsmithtooltip.description .. " <LINE> " .. gold .. "Materials required to infuse SoulSmith:"
				itemToolTipMats(soulsmithtooltip, shard[1], SoulSmith, SoulSmithMatNo[1])
				itemToolTipMats(soulsmithtooltip, shard[2], SoulSmith, SoulSmithMatNo[2])
				itemToolTipMats(soulsmithtooltip, shard[3], SoulSmith, SoulSmithMatNo[3])
				itemToolTipMats(soulsmithtooltip, "Base.ScrapMetal", SoulSmith, SoulSmithMatNo[4])
				SoulSmith.toolTip = soulsmithtooltip
				
				local SoulThirstMatNo = {3,3,3,10}
				soulthirsttooltip = ISWorldObjectContextMenu.addToolTip();
				soulthirsttooltip.description = soulthirsttooltip.description .. green .. "Eating this infused food will give you a " .. math.min(100,math.floor(-1*item:getHungerChange()/SoulThirstDenom*100)/100*ironChefBuff) .. "% chance to gain an additional soul on kill. This buff lasts for " .. math.floor(45*ironChefBuff) .. " minutes. <LINE> "
				soulthirsttooltip.description = soulthirsttooltip.description .. " <LINE> " .. gold .. "Materials required to infuse SoulThirst:"
				itemToolTipMats(soulthirsttooltip, shard[1], SoulThirst, SoulThirstMatNo[1])
				itemToolTipMats(soulthirsttooltip, shard[2], SoulThirst, SoulThirstMatNo[2])
				itemToolTipMats(soulthirsttooltip, shard[3], SoulThirst, SoulThirstMatNo[3])
				itemToolTipMats(soulthirsttooltip, "Base.ScrapMetal", SoulThirst, SoulThirstMatNo[4])
				SoulThirst.toolTip = soulthirsttooltip
				--print(ironChefBuff)
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
		local setOnEatFlag = iMD.setOnEat_new or false
		if setOnEatFlag then 
			item:setOnEat(setOnEatFlag) 
			dPr("Set flag: " .. setOnEatFlag)
		end
	end
	o_doContextualDblClick(self,item)
end