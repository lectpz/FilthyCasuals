require "BGunTweaker"
require "BGunModelChange"
require "ISUI/ISFirearmRadialMenu"
require "Reloading/ISReloadableWeapon"
require "TimedActions/ISBaseTimedAction"
require "TimedActions/ISReloadWeaponAction"

local function sdCopyModData(weaponModData, rMD)
	for k,v in pairs(weaponModData) do
		if k == "mdzMaxDmg" 
		or k == "mdzMinDmg"
		or k == "mdzCriticalChance"
		or k == "mdzCritDmgMultiplier"
		or k == "mdzAimingTime"
		or k == "mdzRecoilDelay"
		or k == "mdzReloadTime"
		or k == "mdzPrefix"
		or k == "soulForgeAmmoPerShoot"
		or k == "soulForgeAimingPerkCritModifier"
		or k == "soulForgeAimingPerkHitChanceModifier"
		or k == "soulForgeAimingPerkRangeModifier"
		or k == "soulForgeAimingTime"
		or k == "soulForgeProjectileCount"
		or k == "MaxHitCount"
		or k == "isPiercingBullets"
		or k == "soulForgeMinDmgMulti"
		or k == "soulForgeMaxDmgMulti"
		or k == "soulForgeCritRate"
		or k == "soulForgeCritMulti"
		or k == "CriticalChance"
		or k == "CritDmgMultiplier"
		or k == "ReloadTime"
		or k == "RecoilDelay"
		or k == "EngravedName"
		or k == "KillCount"
		or k == "SoulForged"
		or k == "SoulWrought"
		or k == "Augments"
		or k == "PlayerKills"
		or k == "p1_desc"
		or k == "p2_desc"
		or k == "s1_desc"
		or k == "s2_desc"
		or k == "Tier"
		or k == "Name"
		or k == "prefix1"
		or k == "prefix2"
		or k == "suffix1"
		or k == "suffix2"
		or k == "AimingPerkHitChanceModifier"
		or k == "AimingPerkCritModifier"
		or k == "AimingPerkRangeModifier"
		or k == "AimingTime"
		then
			rMD[k] = v
			--print(k,v)
		end
	end
end
	
local function sdSetModData(inventoryItem, weaponModData)
	local mdzMaxDmg = weaponModData.mdzMaxDmg or 1
	local mdzMinDmg = weaponModData.mdzMinDmg or 1
	local mdzAimingTime = weaponModData.mdzAimingTime or 1
	local mdzReloadTime = weaponModData.mdzReloadTime or 1
	local mdzRecoilDelay = weaponModData.mdzRecoilDelay or 1
	local mdzCriticalChance = weaponModData.mdzCriticalChance or 1
	local mdzCritDmgMultiplier = weaponModData.mdzCritDmgMultiplier or 1
	
	local soulForgeAmmoPerShoot = weaponModData.soulForgeAmmoPerShoot or 1
	local soulForgeAimingPerkCritModifier = weaponModData.soulForgeAimingPerkCritModifier or 1
	local soulForgeAimingPerkHitChanceModifier = weaponModData.soulForgeAimingPerkHitChanceModifier or 1
	local soulForgeAimingPerkRangeModifier = weaponModData.soulForgeAimingPerkRangeModifier or 1
	local soulForgeAimingTime = weaponModData.soulForgeAimingTime or 1
	local soulForgeProjectileCount = weaponModData.soulForgeProjectileCount or 1
	local isPiercingBullets = weaponModData.isPiercingBullets or false
	
	if isPiercingBullets then
		inventoryItem:setPiercingBullets(true)
	else
		inventoryItem:setProjectileCount(soulForgeProjectileCount)
	end
	
	local soulForgeMinDmgMulti = weaponModData.soulForgeMinDmgMulti or 1
	local soulForgeMaxDmgMulti = weaponModData.soulForgeMaxDmgMulti or 1
	local soulForgeCritRate = weaponModData.soulForgeCritRate or 1
	local soulForgeCritMulti = weaponModData.soulForgeCritMulti or 1
	
	if weaponModData.CriticalChance then inventoryItem:setCriticalChance(weaponModData.CriticalChance * soulForgeCritRate * mdzCriticalChance) end
	if weaponModData.CritDmgMultiplier then inventoryItem:setCritDmgMultiplier(weaponModData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier) end
	inventoryItem:setMinDamage(weaponModData.MinDamage * soulForgeMinDmgMulti * mdzMinDmg)
	inventoryItem:setMaxDamage(weaponModData.MaxDamage * soulForgeMaxDmgMulti * mdzMaxDmg)
	if weaponModData.ReloadTime then inventoryItem:setReloadTime(weaponModData.ReloadTime * mdzReloadTime) end
	if weaponModData.RecoilDelay then inventoryItem:setRecoilDelay(weaponModData.RecoilDelay * mdzRecoilDelay) end
	
	inventoryItem:setAimingTime(weaponModData.AimingTime * mdzAimingTime * soulForgeAimingTime)
	inventoryItem:setAimingPerkHitChanceModifier(weaponModData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier)
	inventoryItem:setAimingPerkCritModifier(weaponModData.AimingPerkCritModifier * soulForgeAimingPerkCritModifier)
	inventoryItem:setAimingPerkRangeModifier(weaponModData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier)
	
	local engravedName = weaponModData.EngravedName
	if engravedName then 
		inventoryItem:setName(engravedName)
	else
		local mdzPrefix = ""
		local soulWrought = weaponModData.SoulWrought or ""
		if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
		inventoryItem:setName(mdzPrefix .. soulWrought .. weaponModData.Name)
	end
end

HFO = HFO or {};
local sVars = SandboxVars.HFO;
-- I learned a lot myself through reviewing other's code and appreciate others who provide comments for clarifying their code
-- Added a lot more comments in this file than I normally would hoping it may help others in the future or at least shed some light on how things work in the mod

------------------------------
-- IN GAME TEXT FOR ACTIONS --
------------------------------

if getActivatedMods():contains("BTSE_Base") then
    if PARP then
        function PARP:sayCustomMessage(message)
            local r, g, b = 0.2, 0.7, 0.7
            PARP:sayHaloMessage(message, PARP:getPlayer(), r, g, b)
        end
    else
        --print("PARP module not found. Custom function cannot be added.")
    end
else
   --print("BTSE_Base mod is not activated.")
end

-- Define the PlayerSay function with a conditional check
local function PlayerSay(text)
    if getActivatedMods():contains("BTSE_Base") and PARP then -- checking for the mod to hook into chat function
        PARP:sayCustomMessage(text)
    else
        getSpecificPlayer(0):addLineChatElement(text) -- base game chat hook for text indicators 
    end
end

---------------------------------
-- CHECK FOR PLAYER AND WEAPON --
---------------------------------

local function getPlayerAndWeapon() 
    local player = getSpecificPlayer(0)
    if not player then
        return nil, nil
    end

    local weapon = player:getPrimaryHandItem()
    if not weapon then
        return nil, nil
    end

    return player, weapon
end

-----------------------
-- CHECK FOR FIREARM --
-----------------------

local function isAimedFirearm(weapon)
    return weapon and instanceof(weapon, "HandWeapon") and weapon:isAimedFirearm()
end

-------------------------------
-- CHECK FOR EQUIPPED RESULT --
-------------------------------

local function handleEquippedWeapon(player, weapon, result)
	local player, weapon = getPlayerAndWeapon()
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

local function checkHotbar(weapon, result)  
	local hotbar = getPlayerHotbar(0)  
	if hotbar == nil then -- make sure there is a hotbar to check
		return
	end

	local weaponSlot = weapon:getAttachedSlot() 
	local slot = hotbar.availableSlot[weaponSlot]
	if slot and result and not hotbar:isInHotbar(result) and hotbar:canBeAttached(slot, result) then -- check for weapon on hotbar and take it off before it is transformed and put back on afterwards
		hotbar:removeItem(weapon, false)
		local attachmentType = result:getAttachmentType()
		local attachment = slot.def.attachments[attachmentType]
		hotbar:attachItem(result, attachment, weaponSlot, slot.def, false)
	end
end

------------------------------------
-- WEAPON STAT RETENTION FUNCTION --
------------------------------------

sVars.ConditionStats = sVars.ConditionStats or 10;
local conditionStats = sVars.ConditionStats

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

local function applyWeaponStats(weapon, result, conditionStats)
    -- Stats that are always applied
    result:setContainsClip(weapon:isContainsClip())
    result:setMaxAmmo(weapon:getMaxAmmo())
    result:setCurrentAmmoCount(weapon:getCurrentAmmoCount())
    result:setCondition(weapon:getCondition() * (conditionStats / 10))
    result:setHaveBeenRepaired(weapon:getHaveBeenRepaired())
    result:setFireMode(weapon:getFireMode())

    -- Additional stats for Gun to Gun
    if isAimedFirearm(weapon) and isAimedFirearm(result) then
        local partsToAttach = { -- identifying all attachments
            {get = "getScope", attach = "attachWeaponPart"},
            {get = "getSling", attach = "attachWeaponPart"},
            {get = "getCanon", attach = "attachWeaponPart"},
            {get = "getStock", attach = "attachWeaponPart"},
            {get = "getRecoilpad", attach = "attachWeaponPart"},
            {get = "getClip", attach = "attachWeaponPart"}
        }

        for _, part in ipairs(partsToAttach) do   -- applying found attachments to the result item 
            local weaponPart = weapon[part.get](weapon)
            if weaponPart ~= nil then
                result[part.attach](result, weaponPart)
            end
        end

        local modData = result:getModData()
        local weaponModData = weapon:getModData()
		
        --Retention of name if ever customized 
        if weaponModData.currentName == nil or weaponModData.currentName ~= weapon:getName() then
            weaponModData.currentName = weapon:getName()
        end

        local suffix = getSuffix(result:getType())

		local currentName = modData.currentName or weaponModData.currentName
		if string.find(currentName, "[%[%]]") then
			currentName = string.gsub(currentName, "%s*%[.*%]$", "")
		end
		currentName = currentName .. suffix
		
		if modData.SoulForged or weaponModData.SoulForged then
			local engravedName = modData.EngravedName or weaponModData.EngravedName
			if engravedName then 
				result:setName(engravedName)
			else
				local mdzPrefix = modData.mdzPrefix or weaponModData.mdzPrefix or ""
				local soulWrought = modData.SoulWrought or weaponModData.SoulWrought or ""
				if mdzPrefix ~= "" then mdzPrefix = mdzPrefix .. " " end
				result:setName(mdzPrefix .. soulWrought .. modData.Name)
			end
		else
			result:setName(currentName)
		end

        modData.LightOn = weaponModData.LightOn
		modData.currentName = weaponModData.currentName
        modData.currentAmmoType = weaponModData.currentAmmoType

        if weaponModData.currentMagType then -- should apply correctly during mag swapping BUT this enforces the update on all weapon changes
            modData.currentMagType = weaponModData.currentMagType
            result:setMagazineType(modData.currentMagType)
            result:setMaxAmmo(weapon:getMaxAmmo())
        end
    end

    if weapon:isJammed() then result:setJammed(true) end -- this is added so you can't swap to melee and back to unjam a gun
end

----------------------------
-- WEAPON LIGHT FUNCTIONS --
----------------------------

local lightLevels = { -- create tables for the strength of attached lights and establish which items have which light level. None may not be necessary but it makes it easier to get back to the 0,0 stats
    none =  {distance = 0, strength = 0},
    low = {distance = 8, strength = 1.5},
    medium = {distance = 10, strength = 1.2},
    high = {distance = 15, strength = 1.0},
}

local stockTypeSettings = {
    LaserRed = "medium",
    LaserGreen = "medium",
    LaserNoLight = "medium",
	WeaponLightMedium = "low",
    WeaponLight = "high",
    GunLight = "low",
}

local function getLightSettings(stockType)  -- attach light level to item type for stock attachments
    return lightLevels[stockTypeSettings[stockType] or "none"] or lightLevels.none
end

local function WeaponLight()
	local player, weapon = getPlayerAndWeapon()

	local stock = nil
    if isAimedFirearm(weapon) then -- all checks up to here are for making sure the player is there, that they have a weapon, that it is a firearm
		stock = weapon:getStock()
	else
		return -- early exit if not a firearm with stock
    end

    if stock then
		if stockTypeSettings[stock:getType()] and weapon:getModData().LightOn == true then -- checks if the firearm has the appropriate attachment and that the light is on
			local lightLevel = stockTypeSettings[stock:getType()] or "none"
			local lightSettings = lightLevels[lightLevel]

			if lightSettings then
				if player:isAiming() then
					weapon:setTorchCone(true)
					weapon:setLightDistance(lightSettings.distance)
					weapon:setLightStrength(lightSettings.strength)
				else -- Handle the case where the player is not aiming
					weapon:setTorchCone(false)
					weapon:setLightDistance(2.5)
					weapon:setLightStrength(0.5)
				end
			end
		else -- Handle the case where the stock type does not have a defined light level
			weapon:setTorchCone(false)
			weapon:setLightDistance(0)
			weapon:setLightStrength(0)
		end   
	end
end

local function WeaponLightHotkey(keyNum)
	local player, weapon = getPlayerAndWeapon()

    if keyNum == getCore():getKey("WeaponLight") then  -- establish function based on hotkey
		local stock = nil
		if isAimedFirearm(weapon) then
			stock = weapon:getStock()
		end

		if stock then
            local stockType = stock:getType()
            local lightLevel = stockTypeSettings[stockType] or "none"
            if lightLevel ~= "none" then  -- function moves through the check if the item has the light attachment and that a light level has been defined. If the light is on it will turn off but if found off will turn on
				weapon:getModData().LightOn = not weapon:getModData().LightOn
            end
        end
    end
end

-------------------------------
-- SELECT FIREMODE FUNCTION --
-------------------------------

local weaponRecoilDelays = {} -- Table to store default recoil delays for weapons

local function FiremodeHotkey(keyNum)

	local player, weapon = getPlayerAndWeapon()

    if keyNum == getCore():getKey("FireMode") then  -- establish function based on hotkey
        if isAimedFirearm(weapon) then
            local firemode = weapon:getFireMode()
            local possibilities = weapon:getFireModePossibilities()

            if possibilities ~= nil and possibilities:size() > 1 then 
                local fireModes = {}  -- to store the order of fire modes
                for i = 0, possibilities:size() - 1 do
                    local firemodeOption = possibilities:get(i) 
                    table.insert(fireModes, firemodeOption)
                end

                local currentFireModeIndex = 1
                for i = 1, #fireModes do
                    if fireModes[i] == firemode then
                        currentFireModeIndex = i
                        break
                    end
                end

                local nextFireModeIndex = currentFireModeIndex + 1
                if nextFireModeIndex > #fireModes then
                    nextFireModeIndex = 1
                end

                local nextFireMode = fireModes[nextFireModeIndex]
                weapon:setFireMode(nextFireMode)
                player:playSound("LightSwitch")
                print("Switched to fire mode: " .. nextFireMode)

                local weaponID = weapon:getType() -- Store the weapon's ID or a unique reference for recoil storage

                if weaponRecoilDelays[weaponID] == nil then -- If recoil delay for the weapon hasn't been saved, store it
                    weaponRecoilDelays[weaponID] = weapon:getRecoilDelay()
                    print("Stored default recoil delay: " .. weaponRecoilDelays[weaponID])
                end

                local minRecoilDelay = 7 -- Ensure recoil delay doesn't go below 7

                if nextFireMode == "FullAuto" then -- Adjust recoil delay based on fire mode
                    local newRecoilDelay = math.max(minRecoilDelay, weaponRecoilDelays[weaponID] - 5)
                    weapon:setRecoilDelay(newRecoilDelay)
                elseif nextFireMode == "SMGFullAuto" then
                    local newRecoilDelay = math.max(minRecoilDelay, weaponRecoilDelays[weaponID] - 3)
                    weapon:setRecoilDelay(newRecoilDelay)
                else
                    weapon:setRecoilDelay(weaponRecoilDelays[weaponID]) -- For any other fire modes, restore the default recoil delay
                    weaponRecoilDelays[weaponID] = nil -- Cleanup: remove entry for the weapon once it's restored to the default mode
                end
            else
                return
            end
        else
            return
        end
    end
end

--------------------------
-- MELEE MODE FUNCTION --
--------------------------

local isChambered = false

local function MeleeModeHotkey(keyNum)

	local player, weapon = getPlayerAndWeapon()

	if keyNum == getCore():getKey("MeleeMode") then -- establish function based on hotkey

		local meleeMode = nil

		if isAimedFirearm(weapon) then -- check for appropriate weapon
			local meleeSwap = weapon:getModData().MeleeSwap 
			meleeMode = meleeSwap or meleeMode
			if meleeMode == nil then -- check if the weapon has a melee item to swap to in custom ModData MeleeSwap...no MeleeSwap = no Melee Mode
				--print("No Melee Mode")
			else
				local result = InventoryItemFactory.CreateItem(meleeMode); -- if swap is available save contents of firearm to be transfered to melee version and place this into the inventory of the player
				if (not string.find(weapon:getType(), "Melee")) and weapon:haveChamber() and weapon:isRoundChambered() then
					isChambered = true -- this is to help from losing a bullet when swapping to melee and back as it is unchambered in the process
				end

				applyWeaponStats(weapon, result, conditionStats)
			
				local scriptItem = result:getScriptItem()
				local maxRange	= scriptItem:getMaxRange()
				local maxDamage	= result:getMaxDamage()
				local minDamage	= result:getMinDamage()	
				local critChance	= result:getCriticalChance()
				local impactSound	= result:getImpactSound()
				local bayonetRange = 0 -- create a base number to be influenced by bayonet attachment

				if result:isAimedHandWeapon() then
					local canon = result:getCanon()
					if canon then
						if string.find(canon:getType(), "Bayonnet") or string.find(canon:getType(), "Bayonet") then -- the vanilla game incorrectly spelled Bayonnet so referencing both is needed
							maxDamage = 1
							minDamage = 0.6
							critChance = 10
							bayonetRange = 0.4
							impactSound	= HuntingKnifeHit
						end
					end
					local meleeRange = scriptItem:getMaxRange() + bayonetRange
					result:setMaxRange(meleeRange)  -- this is so you can keep attachments between melee and ranged without the attachments influencing the max range amount, while increasing range a little if bayonet is attached
					result:setRoundChambered(false)
					result:setMaxDamage(maxDamage)
					result:setMinDamage(minDamage)
					result:setCriticalChance(critChance)
					result:setImpactSound(impactSound)
					BWTweaks:checkForModelChange(result) -- reference to bikinihorst great code to retain model sprite changes so that even going from melee to range keeps everything set correctly
				else
					result:setRoundChambered(isChambered)
				end

				player:getInventory():AddItem(result);

				BWTweaks:checkForModelChange(result) -- reference to bikinihorst great code to retain model sprite changes so that even going from melee to range keeps everything set correctly
				handleEquippedWeapon(player, weapon, result)
				checkHotbar(weapon, result)
				player:getInventory():DoRemoveItem(weapon)
			end
		else --print("Not Firearm")
			return
		end
	end
end

-------------------------------
-- FOLD AND UNFOLD FUNCTION --
-------------------------------

local function FoldUnfoldHotkey(keyNum)

	local player, weapon = getPlayerAndWeapon()

	if keyNum == getCore():getKey("FoldUnfold") then

		local foldMode = nil

		if isAimedFirearm(weapon) then
			local FoldSwap = weapon:getModData().FoldSwap 
			foldMode = FoldSwap or foldMode
			if foldMode == nil then 
				--print("No Fold Mode")
			else
				local result = InventoryItemFactory.CreateItem(foldMode);
				local itemID = result:getID()
				player:getInventory():AddItem(result)
				local inventoryItem = player:getInventory():getItemWithID(itemID)
				local rMD = inventoryItem:getModData()
				local weaponModData = weapon:getModData()
				
				sdCopyModData(weaponModData, rMD)
				
				applyWeaponStats(weapon, result, conditionStats)
				
				sdSetModData(inventoryItem, weaponModData)
				
				if result:haveChamber() and weapon:haveChamber() and weapon:isRoundChambered() then 
					result:setRoundChambered(true)
				end

				BWTweaks:checkForModelChange(result) 
				handleEquippedWeapon(player, weapon, result)
				checkHotbar(weapon, result)
				player:getInventory():DoRemoveItem(weapon)
			end
		else --print("Not Firearm")
			return
		end
	end
end

----------------------------
-- INTEGRATED FUNCTION --
----------------------------

local function IntegratedHotkey(keyNum)

	local player, weapon = getPlayerAndWeapon()

	if keyNum == getCore():getKey("Integrated") then

		local integratedMode = nil

		if isAimedFirearm(weapon) then
			local integratedSwap = weapon:getModData().IntegratedSwap 
			integratedMode = integratedSwap or integratedMode
			if integratedMode == nil then 
				--print("No Integrated Mode")
			else
				local result = InventoryItemFactory.CreateItem(integratedMode);
				--result:copyModData(weapon:getModData())
				local itemID = result:getID()
				player:getInventory():AddItem(result)
				local inventoryItem = player:getInventory():getItemWithID(itemID)
				local rMD = inventoryItem:getModData()
				local weaponModData = weapon:getModData()
				
				sdCopyModData(weaponModData, rMD)
				
				applyWeaponStats(weapon, result, conditionStats)
				
				sdSetModData(inventoryItem, weaponModData)
				
				if result:haveChamber() and weapon:haveChamber() and weapon:isRoundChambered() then 
					result:setRoundChambered(true)
				end

				BWTweaks:checkForModelChange(result) 
				handleEquippedWeapon(player, weapon, result)
				checkHotbar(weapon, result)
				player:getInventory():DoRemoveItem(weapon)
				
			end
		else --print("Not Firearm")
			return	
		end
	end
end

----------------------------
-- SWAP MAGAZINES FUNCTION --
----------------------------

local function SwapMagazineHotkey(keyNum)
    local player, weapon = getPlayerAndWeapon()

    if keyNum == getCore():getKey("SwapMagazine") then
		if isAimedFirearm(weapon) then
            local modData = weapon:getModData()
            local magBase = modData.MagBase
            local magTypes = {"MagExtSm", "MagExtLg", "MagDrum"}
            local magSequence = {}

            if magBase ~= nil then
                table.insert(magSequence, magBase) -- Insert magBase at the beginning
            else
                return -- No Additional Mags
            end
    
            if weapon:isContainsClip() then 
                ISTimedActionQueue.add(ISEjectMagazine:new(player, weapon))
				--PlayerSay("Ejecting Current Magazine")
                return
            end

            for _, magType in ipairs(magTypes) do
                if modData[magType] then
                    table.insert(magSequence, modData[magType])
                end
            end

            local currentMag = weapon:getMagazineType()

            local currentMagIndex = 0
            for i, magType in ipairs(magSequence) do
                if magType == currentMag then
                    currentMagIndex = i
                    break
                end
            end
    
            local nextIndex = currentMagIndex % #magSequence + 1
            local nextMagazineType = magSequence[nextIndex] -- Find the next valid magazine type in the sequence

            if nextMagazineType then
                local result = InventoryItemFactory.CreateItem(weapon:getType())
                local newMag = InventoryItemFactory.CreateItem(nextMagazineType)

                if newMag then
                    local magazineTranslationMap = {
                        [modData.MagBase] = getText("IGUI_HFO_DefaultMag"),
                        [modData.MagExtSm] = getText("IGUI_HFO_ExtSm"),
                        [modData.MagExtLg] = getText("IGUI_HFO_ExtLg"),
                        [modData.MagDrum] = getText("IGUI_HFO_Drum")
                    }
    
                    local magazineTranslation = magazineTranslationMap[nextMagazineType]
                    PlayerSay("Swapping to " .. magazineTranslation)
					
					--local itemID = result:getID()
                    --player:getInventory():AddItem(result)
					--local inventoryItem = player:getInventory():getItemWithID(itemID)
					local rMD = result:getModData()
					local weaponModData = weapon:getModData()
					sdCopyModData(weaponModData, rMD)
					
					applyWeaponStats(weapon, result, conditionStats)
    
                    result:setMagazineType(nextMagazineType)
                    result:setMaxAmmo(newMag:getMaxAmmo())
                    result:getModData().currentMagType = nextMagazineType
    
                    if result:haveChamber() and weapon:haveChamber() and weapon:isRoundChambered() then
                        result:setRoundChambered(true)
                    end
    
                    BWTweaks:checkForModelChange(result)
					
					local itemID = result:getID()
                    player:getInventory():AddItem(result)
					local inventoryItem = player:getInventory():getItemWithID(itemID)
					--local rMD = inventoryItem:getModData()
					--local weaponModData = weapon:getModData()
					--sdCopyModData(weaponModData, rMD)
					sdSetModData(inventoryItem, weaponModData)		
					
                    handleEquippedWeapon(player, weapon, result)
                    checkHotbar(weapon, result)
                    player:getInventory():DoRemoveItem(weapon)  

					if weapon:isContainsClip() ~= true then
						local playerObj = getSpecificPlayer(0)
						local weapon = playerObj:getPrimaryHandItem()
						ISReloadWeaponAction.BeginAutomaticReload(playerObj, weapon)
					end
					
                end
            end
        else -- print("Not a firearm")
            return
        end
    end
end

----------------------------------
--  EXTENDED MAGS + MODDATA WORK -
----------------------------------

local oldModelCheck = BWTweaks["checkForModelChange"];

function BWTweaks:checkForModelChange(item)

	oldModelCheck(self, item);

	local player, weapon = getPlayerAndWeapon()

	if isAimedFirearm(weapon) then  -- check for appropriate weapon and define assorted modData to be called
		local currentMagType = weapon:getModData().currentMagType 
		local currentName = weapon:getModData().currentName
		local clipLoaded = weapon:isContainsClip()

		if currentMagType ~= nil then
			weapon:setMagazineType(currentMagType)
			weapon:setMaxAmmo(InventoryItemFactory.CreateItem(currentMagType):getMaxAmmo())
		end

		if clipLoaded then
			local magBase = weapon:getModData().MagBase
			local magExtSm = weapon:getModData().MagExtSm
			local magExtLg = weapon:getModData().MagExtLg
			local magDrum  = weapon:getModData().MagDrum
			local magPart

			if not weapon:getClip() then -- this is avoid running this block of code and continously creating mags when not needed
				if currentMagType and currentMagType ~= "" then
					if currentMagType == magExtSm then
						magPart = InventoryItemFactory.CreateItem(magExtSm)
					elseif currentMagType == magExtLg then
						magPart = InventoryItemFactory.CreateItem(magExtLg)
					elseif currentMagType == magDrum then
						magPart = InventoryItemFactory.CreateItem(magDrum)
					end
				end
			end

			if magPart and not weapon:getClip() then
				weapon:attachWeaponPart(magPart)  -- this takes the defined magPart and attaches it directly to the weapon so that it can be seen like other attachments on the gun model and also apply penalities to aim time and recoil delay						
			end

		elseif weapon:getClip() then
			weapon:detachWeaponPart(weapon:getWeaponPart("Clip")) -- this deletes the attachment and throws it into the void since ejecting the magazine returns the actual inserted mag (stop the dupes)
		end

		if weapon:getCondition() > weapon:getConditionMax() then --assures that any changes to condition via sandbox doesn't allow for the condition to be higher than max condition ever
			weapon:setCondition(weapon:getConditionMax())
		end	

		local suffix = getSuffix(weapon:getType())

		if currentName ~= nil and currentName ~= weapon:getName() then  --retention of custom name of firearm
			if string.find(currentName, "[%[%]]") then
				currentName = string.gsub(currentName, "%s*%[.*%]$", "")
			end
			currentName = currentName .. suffix
			weapon:setName(currentName)
		end
    end
end

Events.OnGameStart.Add(function()
	local player, weapon = getPlayerAndWeapon()
	if isAimedFirearm(weapon) then
		BWTweaks:checkForModelChange(weapon) --cycle through the above code block to initilize the custom mags if a gun has them
	end
end)

local originalOnRemoveUpgradeWeapon = ISInventoryPaneContextMenu.onRemoveUpgradeWeapon

function ISInventoryPaneContextMenu.onRemoveUpgradeWeapon(weapon, part, player)
    if part:getPartType() == "Clip" then -- Prevent detachment of magazines so players can't duplicate the "weaponpart" and eject current mag
		PlayerSay("Detachment of magazines is not allowed!")
        return
    end
    -- Call the original function for other parts
    originalOnRemoveUpgradeWeapon(weapon, part, player)
end

----------------------------
-- SWAP CALIBER FUNCTION --
----------------------------

---------------------
-- SWAP AMMO TYPE  --
---------------------

-----------------------
-- SWAP RELOAD TYPE  --
-----------------------

--------------------------
-- SUPPRESSOR FUNCTION --
--------------------------

local function suppress(player, weapon)

	local player, weapon = getPlayerAndWeapon()

	if not isAimedFirearm(weapon) then
		return
	end

	local pistolLevels = sVars.PistolSuppressionLevels or 10
	local rifleLevels = sVars.RifleSuppressionLevels or 15
	local sniperLevels = sVars.SniperSuppressionLevels or 25

	local suppressors = {
		["SuppressorPistol"] = {soundVolume = pistolLevels, soundRadius = pistolLevels, swingSound = 'SuppressorPistol'},
		["SuppressorRifle"] = {soundVolume = rifleLevels, soundRadius = rifleLevels, swingSound = 'SuppressorRifle'},
		["SuppressorSniper"] = {soundVolume = sniperLevels, soundRadius = sniperLevels, swingSound = 'SuppressorSniper'}
	}
    
    local scriptItem = weapon:getScriptItem()
    local soundVolume, soundRadius, swingSound = scriptItem:getSoundVolume(), scriptItem:getSoundRadius(), scriptItem:getSwingSound()
	
	local canon = weapon:getCanon()
	local suppressorFound = false  -- Add a flag to track if a suppressor is found

	if canon and (string.find(canon:getType(), "Suppressor")) then
		local currentCondition = canon:getCondition()
		if currentCondition > 0 then
			for suppressor, properties in pairs(suppressors) do
				if string.find(canon:getType(), suppressor) then
					soundVolume, soundRadius, swingSound = math.floor(soundVolume * (1 - (properties.soundVolume / 100))), math.floor(soundRadius * (1 - (properties.soundRadius / 100))), properties.swingSound
					suppressorFound = true  -- Set the flag to true if a suppressor is found
					break 
				end
			end
		else	
			weapon:detachWeaponPart(canon)
			player:getInventory():AddItem(canon)
			player:resetEquippedHandsModels()
			weapon:setSwingSound(scriptItem:getSwingSound())
		end
	end
	
    if not suppressorFound then-- Reset sound and stats to their normal values when suppressor is not found
        soundVolume, soundRadius, swingSound = scriptItem:getSoundVolume(), scriptItem:getSoundRadius(), scriptItem:getSwingSound()
	end

	weapon:setSoundVolume(soundVolume)
	weapon:setSoundRadius(soundRadius)
	weapon:setSwingSound(swingSound)
end

Events.OnEquipPrimary.Add(suppress);

Events.OnGameStart.Add(function()
	local player, weapon = getPlayerAndWeapon()
    suppress(player, weapon)
end)

----------------------------------
-- SUPPRESSOR BREAKAGE FUNCTION --
----------------------------------
sVars.SuppressorBreak = sVars.SuppressorBreak or 20;

local function checkForSuppressorBreak(weapon)
    if sVars.SuppressorBreak < 20 then
		local player, weapon = getPlayerAndWeapon()

        if isAimedFirearm(weapon) then
            local canon	= weapon:getCanon()

            if canon and (string.find(canon:getType(), "Suppressor")) then
				local breakChance = 400 * sVars.SuppressorBreak --approximately will be able to shoot around 100 * sVars.SuppressorBreak before full breakage
                local maxCondition = canon:getConditionMax()
                local currentCondition = canon:getCondition()
            	local chance = 10 * ((maxCondition - currentCondition) + 1)
                local sound = "PZ_MetalSnap"

                if ZombRand(breakChance) <= chance then
                    canon:setCondition(currentCondition - 1) -- when rolled to break then the suppressor loses 1 condition from its previous state. All items have a default 10 condition even if not defined in the item script

					local soundVolume = math.floor(weapon:getSoundVolume() * (1 + (sVars.SuppressorLevels * 0.01 )))  -- this is designed to account for any influence from the sandbox settings
					local soundRadius = math.floor(weapon:getSoundRadius() * (1 + (sVars.SuppressorLevels * 0.01 )))  -- will add on top 1-7 % (based on sandbox setting) more per condition loss which equates to 10% efficiency loss per condition loss
	
					weapon:setSoundVolume(soundVolume)
					weapon:setSoundRadius(soundRadius)

                    if currentCondition <= 0 then -- this occurs when the condition finally reaches 0 or if you attempt to put on a broken suppressor which is 0
					local scriptItem = weapon:getScriptItem()
                    weapon:detachWeaponPart(canon) -- will removed it from the attachment point
                    player:getInventory():AddItem(canon) -- will then add the removed item to the player inventory
                    player:resetEquippedHandsModels() -- will refresh the visual model after unattaching the broken suppressor
                    weapon:setSwingSound(scriptItem:getSwingSound()) -- will revert to unsuppress weapon script sound so it doesn't continue to sound like a suppressor
                    player:playSound(sound) 
                    player:setPrimaryHandItem(weapon)

                        if	(weapon:isRequiresEquippedBothHands() or weapon:isTwoHandWeapon()) then  
                            player:setSecondaryHandItem(weapon)
                        else
                            player:setSecondaryHandItem(nil)
                        end
                    end
                end
				BWTweaks:checkForModelChange(result) -- reference to bikinihorst great code to retain model sprite changes so that even going from melee to range keeps everything set correctly
            end
		end
	end
end

Events.OnPlayerAttackFinished.Add(function()
	local player, weapon = getPlayerAndWeapon()

    if isAimedFirearm(weapon) then
		local canon	= weapon:getCanon()

		if canon and (string.find(canon:getType(), "Suppressor")) then  -- this assures that on player attack if firearm has a canon attachment and that attachment is a suppressor it then will run the suppressor break code block
			checkForSuppressorBreak(weapon) 
		end
    end
end);

---------------------------
-- STRIPPER CLIP YEETING --
---------------------------

function CheckStripperClipOnUnload(weapon, player)
    if weapon:getFullType() == "Base.MosinNagant" or weapon:getFullType() == "Base.MosinNagantObrez" or weapon:getFullType() == "Base.MosinNagant_Melee" or weapon:getFullType() == "Base.MosinNagantObrez_Melee" then
        if weapon:isContainsClip() and weapon:getCurrentAmmoCount() == 0 then
			local currentMag = weapon:getMagazineType()
			if currentMag == "Base.762x54rStripperClip" then
                weapon:setContainsClip(false)
                weapon:setCurrentAmmoCount(0)
			end
        end
    end
end

Events.OnPlayerAttackFinished.Add(function(player, weapon)
    --print("Weapon fired event triggered.")
    CheckStripperClipOnUnload(weapon, player)
end)

---------------------------
-- RADIAL MENU FUNCTION --
---------------------------

function ISFirearmRadialMenu:getWeapon()  -- a call to pull up the firearms radial menu if function criteria is met
	local weapon = self.character:getPrimaryHandItem()
	if weapon and instanceof(weapon, "HandWeapon") then
		if weapon:isAimedFirearm() or weapon:isRanged() then --melee mode uses isAimedFirearm() since isRanged() cannot be used on a melee weapon but we still want to refer to isRanged for other weapons as the base game does
			return weapon
		end
	end
	return nil
end

local function addMenuItem(main, name, icons, functions, arguments)
	table.insert(main, {
		name = name,
		icons = icons,
		functions = functions,
		arguments = arguments
	})
end

local ISFirearmRadialMenu_fillMenu_Vanilla = ISFirearmRadialMenu.fillMenu 
function ISFirearmRadialMenu:fillMenu(submenu)
	local menu = getPlayerRadialMenu(self.playerNum)
	menu:clear() -- establish this specific players firearms radial menu and clears it before it is to be filled with all the menu options

	ISFirearmRadialMenu_fillMenu_Vanilla(self) 

	local weapon = self:getWeapon()
	local weaponIsRanged = weapon:isRanged()
	local weaponType = weapon:getType()
	local weaponMelee = weapon:getModData().MeleeSwap -- pull from the custom Melee Mod Data used for swapping ranged to melee back to range
	local weaponFold = weapon:getModData().FoldSwap
	local weaponIntegrated = weapon:getModData().IntegratedSwap
	local weaponMagType = weapon:getModData().currentMagType
	local weaponStock = weapon:getStock()
	local weaponLight = weapon:getModData().LightOn -- pulls from the light behavior information so we can check if the light is on or off of the appropriate attachment

	self.main = {} 

	--[[if weaponMelee then -- using ternary operators establish that if weaponIsRanged (since melee cant have that) then show Melee Ranged text and icon but if found false then show melee versions
		local weaponMeleeName = weaponIsRanged and getText("IGUI_HFO_MeleeMode")..'\n'..'['..getText("IGUI_HFO_MeleeRanged")..']' or getText("IGUI_HFO_MeleeMode")..'\n'..'['..getText("IGUI_HFO_MeleeMelee")..']'
		local weaponMeleeIcons = weaponIsRanged and getTexture("media/ui/HFO_MeleeMelee.png") or getTexture("media/ui/HFO_MeleeRanged.png")

		addMenuItem(self.main, weaponMeleeName, weaponMeleeIcons, function() MeleeModeHotkey(getCore():getKey("MeleeMode")) end, getCore():getKey("MeleeMode"))
	end]]

	if weaponFold then 
		local weaponFoldName = getText("IGUI_HFO_StockToggle")..'\n'..'['..((string.find(weaponType, "_Folded") or not string.find(weaponType, "Extended")) and getText("IGUI_HFO_StockFold") or getText("IGUI_HFO_StockExtended"))..']'

		addMenuItem(self.main, weaponFoldName, getTexture("media/ui/HFO_StockFold.png"), function() FoldUnfoldHotkey(getCore():getKey("FoldUnfold")) end, getCore():getKey("FoldUnfold"))
	end

	if weaponIntegrated then 
		local integratedType = string.find(weaponType, "_Grip") and "Grip" or string.find(weaponType, "_Bipod") and "Extended" or "Retracted"
		local weaponIntegratedName = getText("IGUI_HFO_IntegratedToggle")..'\n'..'['..getText("IGUI_HFO_Integrated"..integratedType)..']'
	
		addMenuItem(self.main, weaponIntegratedName, getTexture("media/ui/HFO_BipodFold.png"), function() IntegratedHotkey(getCore():getKey("Integrated")) end, getCore():getKey("Integrated"))
	end

	if weaponStock and stockTypeSettings[weaponStock:getType()] then 
		local weaponLightName = weaponLight and getText("IGUI_HFO_WeaponLight")..'\n'..'['..getText("IGUI_HFO_On")..']' or getText("IGUI_HFO_WeaponLight")..'\n'..'['..getText("IGUI_HFO_Off")..']'
		local weaponLightIcons = weaponLight and getTexture("media/ui/HFO_WeaponLightOn.png") or getTexture("media/ui/HFO_WeaponLightOff.png")
	
		addMenuItem(self.main, weaponLightName, weaponLightIcons, function() WeaponLightHotkey(getCore():getKey("WeaponLight")) end, getCore():getKey("WeaponLight"))
	end

	if weapon:getFireModePossibilities() then
		local fireMode = weapon:getFireMode()
		local fireModeVersion = "ContextMenu_FireMode_" .. fireMode
		local fireModeName = weapon:getFireMode() and (getText("IGUI_HFO_Firemode")..'\n'..'['..getText(fireModeVersion)..']') or getText("IGUI_HFO_Firemode")
		
		addMenuItem(self.main, fireModeName, getTexture("media/ui/HFO_Firemode.png"), function() FiremodeHotkey(getCore():getKey("FireMode")) end, getCore():getKey("FireMode"))
	end

	if weapon:getModData().MagBase ~= nil then
		local swapMagazineName = getText("IGUI_HFO_SwapMagazine")..'\n'.. getText("IGUI_HFO_DefaultMag")
		local swapMagazineIcon = getTexture("media/ui/HFO_swap_base.png")
		local currentMagType = weapon:getModData().currentMagType
	
		if currentMagType == nil or currentMagType == weapon:getModData().MagBase then
			swapMagazineIcon = getTexture("media/ui/HFO_swap_base.png") 
		elseif currentMagType == weapon:getModData().MagExtSm then
			swapMagazineName = getText("IGUI_HFO_SwapMagazine")..'\n'.. getText("IGUI_HFO_ExtSm")
			swapMagazineIcon = getTexture("media/ui/HFO_swap_sm.png")
		elseif currentMagType == weapon:getModData().MagExtLg then
			swapMagazineName = getText("IGUI_HFO_SwapMagazine")..'\n'.. getText("IGUI_HFO_ExtLg")
			swapMagazineIcon = getTexture("media/ui/HFO_swap_lg.png")
		elseif currentMagType == weapon:getModData().MagDrum then
			swapMagazineName = getText("IGUI_HFO_SwapMagazine")..'\n'.. getText("IGUI_HFO_Drum")
			swapMagazineIcon = getTexture("media/ui/HFO_swap_drum.png")
		end
	
		addMenuItem(self.main, swapMagazineName, swapMagazineIcon, function() SwapMagazineHotkey(getCore():getKey("SwapMagazine")) end, getCore():getKey("SwapMagazine"))
	end

	if not submenu then -- all of the information above allows for the info to be dynamically filled into the firearms radial menu depending if the weapon meets any of the necesary criteria for that specific slice
		for i,v in pairs(self.main) do
			if v.subMenu then
				menu:addSlice(v.name, v.icons, self.fillMenu, self, i)
			else 
				menu:addSlice(v.name, v.icons, v.functions, self, v.arguments)
			end
		end
	else
		menu:clear()
		for _,v in pairs(self.main[submenu].subMenu) do
			menu:addSlice(v.name, v.icons, v.functions, self, v.arguments)
		end
		menu:addSlice(getText("IGUI_Emote_Back"), getTexture("media/ui/emotes/back.png"), self.fillMenu, self)
	end
	self:display()
end

function ISFirearmRadialMenu.checkWeapon(playerObj)  -- a final check at the end that the slice function is being applied to an appropriate weapon
	local weapon = playerObj:getPrimaryHandItem()
	if not weapon or not instanceof(weapon, "HandWeapon") then 
		return false 
	end
	return weapon:isRanged() or weapon:isAimedFirearm()
end

Events.OnPlayerUpdate.Add(WeaponLight)
Events.OnKeyPressed.Add(WeaponLightHotkey)
--Events.OnKeyPressed.Add(MeleeModeHotkey)
Events.OnKeyPressed.Add(FoldUnfoldHotkey)
Events.OnKeyPressed.Add(IntegratedHotkey)
Events.OnKeyPressed.Add(FiremodeHotkey)
Events.OnKeyPressed.Add(SwapMagazineHotkey)