require "recipecode"

HFO = HFO or {};

local sVars = SandboxVars.HFO;
sVars.ConditionStats = sVars.ConditionStats or 10;
local conditionStats = sVars.ConditionStats

-------------------------------
-- CHECK FOR EQUIPPED RESULT --
-------------------------------

local function handleEquippedWeapon(player, result)
	if (instanceof(result, "HandWeapon")) then
		player:setPrimaryHandItem(result) 
		if (result:isRequiresEquippedBothHands() or result:isTwoHandWeapon()) then
			player:setSecondaryHandItem(result)
		else
			player:setSecondaryHandItem(nil)
		end
	end
end

------------------------
-- CHECK HOTBAR ITEMS --
------------------------

local function checkHotbar(item, result)  
	local hotbar = getPlayerHotbar(0)  
	if hotbar == nil then -- make sure there is a hotbar to check
		return
	end

	local itemSlot = item:getAttachedSlot() 
	local slot = hotbar.availableSlot[itemSlot]
	if slot and result and not hotbar:isInHotbar(result) and hotbar:canBeAttached(slot, result) then -- check for weapon on hotbar and take it off before it is transformed and put back on afterwards
		hotbar:removeItem(item, false)
		local attachmentType = result:getAttachmentType()
		local attachment = slot.def.attachments[attachmentType]
		hotbar:attachItem(result, attachment, itemSlot, slot.def, false)
	end
end

----------------------------------
-- ITEM STAT RETENTION FUNCTION --
----------------------------------

local suffixes = {
	{swaptype = "_Extended_Melee", suffix = " [Melee Extended]"},
    {swaptype = "_Folded_Melee", suffix = " [Melee Folded]"},
    {swaptype = "_GripExtended", suffix = " [Grip & Extended]"},
    {swaptype = "_Melee", suffix = " [Melee]"},
    {swaptype = "_Bipod", suffix = " [Bipod]"},
    {swaptype = "_Grip", suffix = " [Grip]"},
    {swaptype = "_Extended", suffix = " [Extended]"},
    {swaptype = "_Folded", suffix = " [Folded]"},
}

local function getSuffix(weaponType)
    for _, suffixInfo in ipairs(suffixes) do
        if string.find(weaponType, suffixInfo.swaptype) then
            return suffixInfo.suffix
        end
    end
    return ""
end

local function applyItemStats(item, result)
    -- Stats that are always applied

	result:setContainsClip(item:isContainsClip())
    result:setMaxAmmo(item:getMaxAmmo())
	result:setCurrentAmmoCount(item:getCurrentAmmoCount())
    result:setFireMode(item:getFireMode())

	local partsToAttach = { 
		{get = "getScope", attach = "attachWeaponPart"},
		{get = "getSling", attach = "attachWeaponPart"},
		{get = "getCanon", attach = "attachWeaponPart"},
		{get = "getStock", attach = "attachWeaponPart"},
		{get = "getRecoilpad", attach = "attachWeaponPart"},
		{get = "getClip", attach = "attachWeaponPart"}
	}

	for _, part in ipairs(partsToAttach) do
		local weaponPart = item[part.get](item)
		if weaponPart ~= nil then
			result[part.attach](result, weaponPart)
		end
	end

	local modData = result:getModData()
	local weaponModData = item:getModData()
	--result:copyModData(weaponModData)

	--Retention of name if ever customized 
	if weaponModData.currentName == nil or weaponModData.currentName ~= item:getName() then
		weaponModData.currentName = item:getName()
	end

	local suffix = getSuffix(result:getType())

	local currentName = modData.currentName or weaponModData.currentName
	if string.find(currentName, "[%[%]]") then
		currentName = string.gsub(currentName, "%s*%[.*%]$", "")
	end

	currentName = currentName .. suffix
	result:setName(currentName)

	modData.LightOn = weaponModData.LightOn
	modData.currentName = weaponModData.currentName
	modData.currentAmmoType = weaponModData.currentAmmoType

	if weaponModData.currentMagType then
		modData.currentMagType = weaponModData.currentMagType
		result:setMagazineType(modData.currentMagType)
		result:setMaxAmmo(item:getMaxAmmo())
	end
end
--------------------------------------------------------------------
-- KEEP FIREARM SETUP ON CREATE SHOTGUN SAWN OFF OVERRIDE VANILLA --
--------------------------------------------------------------------

function ShotgunSawnoff_OnCreate(items, result, player)
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:isAimedFirearm() then 
			player:getInventory():AddItem(result);
            result:setCondition(item:getCondition() * (conditionStats / 10))
            result:setHaveBeenRepaired(item:getHaveBeenRepaired())
			
			local itemID = result:getID()
			player:getInventory():AddItem(result)
			local inventoryItem = player:getInventory():getItemWithID(itemID)
			local rMD = inventoryItem:getModData()
			local weaponModData = item:getModData()
			
			for k,v in pairs(weaponModData) do
				if k == "mdzMaxDmg" 
				or k == "mdzMinDmg"
				or k == "mdzCriticalChance"
				or k == "mdzCritDmgMultiplier"
				or k == "mdzAimingTime"
				or k == "mdzRecoilDelay"
				or k == "mdzReloadTime"
				or k == "mdzPrefix"
				then
					rMD[k] = v
					print(k,v)
				end
			end
			
			inventoryItem:setMaxDamage(weaponModData.mdzMaxDmg * weaponModData.MaxDamage)
			inventoryItem:setMinDamage(weaponModData.mdzMinDmg * weaponModData.MinDamage)
			inventoryItem:setCriticalChance(weaponModData.mdzCriticalChance * weaponModData.CriticalChance)
			inventoryItem:setCritDmgMultiplier(weaponModData.mdzCritDmgMultiplier * weaponModData.CritDmgMultiplier)
			inventoryItem:setAimingTime(weaponModData.mdzAimingTime * weaponModData.AimingTime)
			inventoryItem:setReloadTime(weaponModData.mdzReloadTime * weaponModData.ReloadTime)
			inventoryItem:setRecoilDelay(weaponModData.mdzRecoilDelay * weaponModData.RecoilDelay)
			inventoryItem:setName(weaponModData.mdzPrefix .. " " .. weaponModData.Name)
			
            print("Applying item stats...")
            applyItemStats(item, result)
            print("Item stats applied.")

			if item:isJammed() then item:setJammed(true) end -- if you are cleaning you will remove a jam

			if result:haveChamber() and item:haveChamber() and item:isRoundChambered() then 
				result:setRoundChambered(true)
			end

			local recoil = item:getRecoilpad()
			if recoil then
				if recoil:getFullType() == "Base.RecoilPad" then
					result:detachWeaponPart(recoil)
					player:getInventory():AddItem(recoil)
				end
			end

			BWTweaks:checkForModelChange(result)
			handleEquippedWeapon(player, result)
			return
		else --print("not a firearm")
			return
		end
	end
end

----------------------------------------------------------------------------------
-- KEEP FIREARM SETUP ON CREATE DOUBLE BARREL SHOTGUN SAWN OFF OVERRIDE VANILLA --
----------------------------------------------------------------------------------

function DblBarrelhotgunSawnoff_OnCreate(items, result, player)
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:isAimedFirearm() then 
			player:getInventory():AddItem(result);
            result:setCondition(item:getCondition() * (conditionStats / 10))
            result:setHaveBeenRepaired(item:getHaveBeenRepaired())

			local itemID = result:getID()
			player:getInventory():AddItem(result)
			local inventoryItem = player:getInventory():getItemWithID(itemID)
			local rMD = inventoryItem:getModData()
			local weaponModData = item:getModData()
			
			for k,v in pairs(weaponModData) do
				if k == "mdzMaxDmg" 
				or k == "mdzMinDmg"
				or k == "mdzCriticalChance"
				or k == "mdzCritDmgMultiplier"
				or k == "mdzAimingTime"
				or k == "mdzRecoilDelay"
				or k == "mdzReloadTime"
				or k == "mdzPrefix"
				then
					rMD[k] = v
					print(k,v)
				end
			end
			
			inventoryItem:setMaxDamage(weaponModData.mdzMaxDmg * weaponModData.MaxDamage)
			inventoryItem:setMinDamage(weaponModData.mdzMinDmg * weaponModData.MinDamage)
			inventoryItem:setCriticalChance(weaponModData.mdzCriticalChance * weaponModData.CriticalChance)
			inventoryItem:setCritDmgMultiplier(weaponModData.mdzCritDmgMultiplier * weaponModData.CritDmgMultiplier)
			inventoryItem:setAimingTime(weaponModData.mdzAimingTime * weaponModData.AimingTime)
			inventoryItem:setReloadTime(weaponModData.mdzReloadTime * weaponModData.ReloadTime)
			inventoryItem:setRecoilDelay(weaponModData.mdzRecoilDelay * weaponModData.RecoilDelay)
			inventoryItem:setName(weaponModData.mdzPrefix .. " " .. weaponModData.Name)

			
            print("Applying item stats...")
            applyItemStats(item, result)
            print("Item stats applied.")

			if item:isJammed() then item:setJammed(true) end -- if you are cleaning you will remove a jam

			if result:haveChamber() and item:haveChamber() and item:isRoundChambered() then 
				result:setRoundChambered(true)
			end

			local recoil = item:getRecoilpad()
			if recoil then
				if recoil:getFullType() == "Base.RecoilPad" then
					result:detachWeaponPart(recoil)
					player:getInventory():AddItem(recoil)
				end
			end

			BWTweaks:checkForModelChange(result)
			handleEquippedWeapon(player, result)
			return
		else --print("not a firearm")
			return
		end
	end
end

----------------------------------------------------------------------------------
-- KEEP FIREARM SETUP ON CREATE DOUBLE BARREL SHOTGUN SAWN OFF OVERRIDE VANILLA --
----------------------------------------------------------------------------------

function GeneralSawnWeapon_OnCreate(items, result, player)
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:isAimedFirearm() then 
			player:getInventory():AddItem(result);
            result:setCondition(item:getCondition() * (conditionStats / 10))
            result:setHaveBeenRepaired(item:getHaveBeenRepaired())

			local itemID = result:getID()
			player:getInventory():AddItem(result)
			local inventoryItem = player:getInventory():getItemWithID(itemID)
			local rMD = inventoryItem:getModData()
			local weaponModData = item:getModData()
			
			for k,v in pairs(weaponModData) do
				if k == "mdzMaxDmg" 
				or k == "mdzMinDmg"
				or k == "mdzCriticalChance"
				or k == "mdzCritDmgMultiplier"
				or k == "mdzAimingTime"
				or k == "mdzRecoilDelay"
				or k == "mdzReloadTime"
				or k == "mdzPrefix"
				then
					rMD[k] = v
					print(k,v)
				end
			end
			
			inventoryItem:setMaxDamage(weaponModData.mdzMaxDmg * weaponModData.MaxDamage)
			inventoryItem:setMinDamage(weaponModData.mdzMinDmg * weaponModData.MinDamage)
			inventoryItem:setCriticalChance(weaponModData.mdzCriticalChance * weaponModData.CriticalChance)
			inventoryItem:setCritDmgMultiplier(weaponModData.mdzCritDmgMultiplier * weaponModData.CritDmgMultiplier)
			inventoryItem:setAimingTime(weaponModData.mdzAimingTime * weaponModData.AimingTime)
			inventoryItem:setReloadTime(weaponModData.mdzReloadTime * weaponModData.ReloadTime)
			inventoryItem:setRecoilDelay(weaponModData.mdzRecoilDelay * weaponModData.RecoilDelay)
			inventoryItem:setName(weaponModData.mdzPrefix .. " " .. weaponModData.Name)

            applyItemStats(item, result)

			if item:isJammed() then item:setJammed(true) end -- if you are cleaning you will remove a jam

			if result:haveChamber() and item:haveChamber() and item:isRoundChambered() then 
				result:setRoundChambered(true)
			end

			local recoil = item:getRecoilpad()
			if recoil then
				if recoil:getFullType() == "Base.RecoilPad" then
					result:detachWeaponPart(recoil)
					player:getInventory():AddItem(recoil)
				end
			end

			BWTweaks:checkForModelChange(result)
			handleEquippedWeapon(player, result)
			return
		else --print("not a firearm")
			return
		end
	end
end

---------------------------------
-- CLEANING FIREARMS ON CREATE --
---------------------------------

sVars.CleaningFail = sVars.CleaningFail or 0;
sVars.CleaningStats = sVars.CleaningStats or 0;
sVars.CleaningRepairRate = sVars.CleaningRepairRate or 4;

function Recipe.OnCreate.FirearmCleaning(items, result, player)
	player:getInventory():AddItem("Base.RippedSheetsDirty")
	for i=0,items:size()-1 do
		local item = items:get(i)
		
		if item:isAimedFirearm() then 
			--local result = InventoryItemFactory.CreateItem(item:getFullType())
			local result = item
			
			local condition = (item:getCondition())
			local conditionMax = (item:getConditionMax() * (conditionStats / 10))
			local repairCount = item:getHaveBeenRepaired()
			--result:copyModData(item:getModData())
			--[[local rMD = result:getModData()
			local weaponModData = item:getModData()
			
			rMD.mdzMaxDmg = weaponModData.mdzMaxDmg
			rMD.mdzMinDmg = weaponModData.mdzMinDmg
			rMD.mdzCriticalChance = weaponModData.mdzCriticalChance
			rMD.mdzCritDmgMultiplier = weaponModData.mdzCritDmgMultiplier
			rMD.mdzAimingTime = weaponModData.mdzAimingTime
			rMD.mdzRecoilDelay = weaponModData.mdzRecoilDelay
			rMD.mdzReloadTime = weaponModData.mdzReloadTime]]
			
			--[[print("===========FireArm ModData start")
			for k,v in pairs(result:getModData()) do print(k,v) end
			print("===========FireArm ModData end")]]
			
			--player:getInventory():AddItem(result);
			if condition < conditionMax then
				local failRate = sVars.CleaningFail;
				local r = ZombRand(1, 100);
				if r >= failRate then
					local newCondition = math.min(condition + (1 + sVars.CleaningStats), conditionMax)
					result:setCondition(newCondition)
				else
					-- No improvement, condition remains the same
					result:setCondition(condition)
				end
			elseif condition == conditionMax then
				--print("Weapon condition already at maximum.")
			end
			if repairCount ~= nil and repairCount > 1 then
				local aimingSkill = player:getPerkLevel(Perks.Aiming)
				local successRate = 0.05 + aimingSkill * (0.01 * sVars.CleaningRepairRate)
				local r = ZombRand(1, 100);
				if r <= successRate * 100 then
					result:setHaveBeenRepaired(repairCount - 1 )
				else
					result:setHaveBeenRepaired(repairCount)
				end
			else
				--print("Weapon has already been fully repaired.")
			end

			--[[applyItemStats(item, result)
			

			if item:isJammed() then item:setJammed(true) end -- if you are cleaning you will remove a jam

			if result:haveChamber() and item:haveChamber() and item:isRoundChambered() then 
				result:setRoundChambered(true)
			end

			BWTweaks:checkForModelChange(result)
			handleEquippedWeapon(player, result)
			checkHotbar(item, result)
			player:getInventory():DoRemoveItem(item)]]
			return
		else --print("not a firearm")
			return
		end
	end
end

---------------------------------
-- AMMO CAN ON CREATE --
---------------------------------

HFO.ammoOptions = {
    Handguns = {"Bullets9mm", "Bullets45", "Bullets44", "Bullets38"},
    Rifle = {"223Bullets", "308Bullets", "556Bullets"},
    Shotgun = {"ShotgunShells", "ShotgunShells"}
}

if getActivatedMods():contains("HayesFirearmsExtension") then
	HFO.ammoOptions.Handguns = {"Bullets9mm", "Bullets45", "Bullets44", "Bullets38", "380Bullets", "57Bullets"}
    HFO.ammoOptions.Rifle = {"3006Bullets", "223Bullets", "308Bullets", "556Bullets", "545Bullets", "762Bullets", "762x51Bullets", "762x54rBullets", "792x33Bullets", "50BMGBullets", "9x39Bullets"}
end

function Recipe.OnCreate.OpenAmmoCan(items, result, player)
	local inventory = player:getInventory();
	local spawns = {
	}

	function addRandomItem(oType, count)
        for i = 1, count or 1
        do
            table.insert(spawns, HFO.ammoOptions[oType][ZombRand(#HFO.ammoOptions[oType] + 1)]);
        end
    end

	local r = ZombRand(1, 100);

	if r <= 25
    then
        addRandomItem("Handguns", 8);
		addRandomItem("Handguns", 8);
    elseif r <= 50 
    then
        addRandomItem("Rifle", 6);
		addRandomItem("Rifle", 6);
    elseif r <= 75
    then
        addRandomItem("Shotgun", 5);
		addRandomItem("Shotgun", 5);
    elseif r <= 90
    then
        addRandomItem("Handguns", 8);
        addRandomItem("Rifle", 6);
    else
        addRandomItem("Handguns", 6);
        addRandomItem("Rifle", 5);
        addRandomItem("Shotgun", 4);
    end
    
    for i, itemId in ipairs(spawns)
    do
        inventory:AddItem("Base." .. itemId);
    end
end