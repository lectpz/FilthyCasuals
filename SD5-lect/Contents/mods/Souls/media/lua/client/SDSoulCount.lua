----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

local function KillCountSD(player)
	return player:getZombieKills()
end
--[[
local responseCraft = {
	"I expected nothing and I'm still disappointed.",
	"This DLC is not yet available in your region.",
	"... Huh? Estee is too easy? Who the hell is Estee?",
	"We require additional pylons.",
	"Yes... that's right... ALL of the burritos...",
	"What's that? Set fire to everything...?! No... not yet, my love.",
}

SoulWeaponUpgradeSD = function(item, player)
	local playerObj = getSpecificPlayer(player)
	local weaponModData = item:getModData()
	local weaponMaxCond = item:getConditionMax()
	local weaponCondLowerChance = item:getConditionLowerChance()
	local soulsRequired = weaponMaxCond * weaponCondLowerChance * 2
	local soulsFreed = weaponModData.KillCount
	if soulsFreed < soulsRequired then
		playerObj:Say("I need more souls to do that.")
	else
	--choose prefix or suffix
	--change moddata name based on prefix or suffix
	--change moddata item stats based on prefix or suffix
	--add moddata to weapon to indicate if prefix or suffix is added
	--
	--set item stats based on new prefix or suffix
	--set item name based on new Name
	--reset weapon kill counter
		playerObj:Say(responseCraft[ZombRand(#responseCraft)+1])
		--playerObj:Say("This will be added at a later date.")
	end
end
]]--
--context menu option add

local function SoulContextSD(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:IsWeapon() and not item:isRanged() then
			weaponModData = item:getModData()
			weaponMaxCond = item:getConditionMax()
			weaponCondLowerChance = item:getConditionLowerChance()
			weaponRepairedStack = item:getHaveBeenRepaired()
			soulsRequired = weaponMaxCond * weaponCondLowerChance * 3
			soulsFreed = weaponModData.KillCount or nil
			if not soulsFreed then return end
			soulsContext = context:addOption("Soul Power: " .. soulsFreed .. "/" .. soulsRequired, item, nil, player)
			--if isAdmin() then
			--	context:addOption("[ADMIN] Current Repair Stacks: " .. weaponRepairedStack .. "x", item, nil, player)
			--end

			if soulsFreed ~= nil then
			
				function modifySouls(item, player, amount)
					weaponModData.KillCount = soulsFreed + amount
					soulsFreed = weaponModData.KillCount
				end
				--[[
				if isAdmin() then
					soulgain = 1000
					context:addOption("[Admin] Add " .. soulgain .. " Soul Power To Weapon", item, modifySouls(item, player, soulgain), player)
				end
				hasStoredSouls = playerObj:getInventory():containsTypeRecurse("SoulForge.StoredSouls")
				
				function addSouls(item, player, amount)
					weaponModData.KillCount = soulsFreed + amount
					--soulsFreed = weaponModData.KillCount
					playerInv:RemoveOneOf("SoulForge.StoredSouls")
					playerInv:AddItem("SoulForge.EmptySoulFlaskWhite")
				end
				
				if hasStoredSouls then
					soulgain = 1000
					context:addOption("Add " .. soulgain .. " Soul Power To Weapon", item, addSouls(item, player, soulgain), player)
				end
				]]--
				if soulsFreed < soulsRequired then
					soulsContext.notAvailable = true;
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. "You need to free more souls."
					soulsContext.toolTip = tooltip
				else
					submenu = ISContextMenu:getNew(context)
					context:addSubMenu(soulsContext, submenu)
					
					------------------------------------------------------------------------------------------------------
					--soul storage (1000 souls)
					------------------------------------------------------------------------------------------------------
					function updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
						local n_soulsFreed = math.max(soulsFreed - math.floor(soulsRequired/((math.min(5, weaponRepairedStack) -1)/2)),0)
						return n_soulsFreed
					end
					
					n_soulsFreed = updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
					--[[
					soulFlaskEmpty = playerObj:getInventory():containsTypeRecurse("SoulForge.EmptySoulFlaskWhite")
					soulstored = -1000
					
					function storeSouls(item, player, amount)
						weaponModData.KillCount = soulsFreed + amount
						--soulsFreed = weaponModData.KillCount
						playerInv:RemoveOneOf("SoulForge.EmptySoulFlaskWhite")
						playerInv:AddItem("SoulForge.StoredSouls")
					end
										
					option_storesouls = submenu:addOption("Store souls: (" .. soulstored .." souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, storeSouls(item, player, soulstored), player)
					
					if not soulFlaskEmpty then
						option_storesouls.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_storesouls.toolTip = tooltip
					end
					]]--
					------------------------------------------------------------------------------------------------------
					--repair stack option
					------------------------------------------------------------------------------------------------------
					new_weaponRepairStack = function(item, player)
						item:setHaveBeenRepaired(weaponRepairedStack - 1)
						weaponModData.KillCount = n_soulsFreed
						--soulsFreed = weaponModData.KillCount
					end
					
					function calcsoulDiff(soulsRequired, weaponRepairedStack)
						local soulDiff = math.floor(soulsRequired/(math.min(5, weaponRepairedStack-1) -1))*2
						return soulDiff
					end
					
					soulDiff = calcsoulDiff(soulsRequired, weaponRepairedStack)
					
					option_repairstack = submenu:addOption("Remove 1x repair stack. (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponRepairStack, player)
					
					if weaponRepairedStack < 5 then
					
						option_repairstack.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_repairstack.toolTip = tooltip
					end
					------------------------------------------------------------------------------------------------------
					--weapon condition option
					------------------------------------------------------------------------------------------------------
					weaponCurrentCondition = item:getCondition()
					weaponCondRepairAmount = math.ceil(weaponMaxCond/3)
					weaponNewCondition = math.min((weaponCurrentCondition + weaponCondRepairAmount), weaponMaxCond)
					
					new_weaponCondition = function(item, player)
						item:setCondition(weaponNewCondition)
						weaponModData.KillCount = n_soulsFreed
						--soulsFreed = weaponModData.KillCount
					end
					
					option_weaponCondition = submenu:addOption("Repair weapon to: " .. weaponNewCondition .. "/" .. weaponMaxCond .. " (-" .. soulDiff .. " souls.) New Soul Power: " .. n_soulsFreed .. "/" .. soulsRequired, item, new_weaponCondition, player)
					
					if weaponRepairedStack < 5 or (weaponCurrentCondition == weaponMaxCond) then
						option_weaponCondition.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "This weapon is still serviceable. Higher repair stack requires less souls to mend."
						option_weaponCondition.toolTip = tooltip
					end
					------------------------------------------------------------------------------------------------------
					------------------------------------------------------------------------------------------------------
				end
			end
		end
		break
	end
end

Events.OnFillInventoryObjectContextMenu.Add(SoulContextSD) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option

function SoulCountSD(character, handWeapon)

	local player = character
	local tierzone = checkZone()

	if player ~= nil and not handWeapon:isRanged() and player:getPrimaryHandItem() ~= nil then
		local weaponModData = handWeapon:getModData()
		local weaponSouls = weaponModData.KillCount or nil
		local weaponPlayerKC = weaponModData.PlayerKills or nil
		
		if weaponSouls == nil then
			weaponModData.KillCount = 1 --SD write initial killcount to weapon (zero). in case a weapon does not have an internal kill counter.
			weaponSouls = weaponModData.KillCount
		end
		
		if weaponPlayerKC == nil then
			weaponModData.PlayerKills = KillCountSD(player) --SD snapshot kill count of player who equips weapon. in case a weapon does not have a snapshot kill count for the player.
			weaponPlayerKC = weaponModData.PlayerKills
		end
		
		--character:Say("old kills: " .. weaponSouls)
		--character:Say("old player kills: " .. weaponPlayerKC)
		local n_killcount = KillCountSD(player) --updated kill count

		
		local killDiff = n_killcount - weaponPlayerKC -- calculate difference in kill count
		--character:Say("kill diff: " .. killDiff)
		
		if killDiff > 0 then
			weaponModData.KillCount = weaponSouls + killDiff + math.floor(tierzone/2) --calculate and set new kill counter on weapon, 
			weaponModData.PlayerKills = n_killcount --update player kill counter on weapon
			--character:Say("new kills: " .. weaponModData.KillCount)
			--character:Say("new player kills: " .. weaponModData.PlayerKills)
		end
	
	end

end

Events.OnPlayerAttackFinished.Add(SoulCountSD)