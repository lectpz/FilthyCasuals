----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

local function KillCountSD(player)
	return player:getZombieKills()
end

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

--context menu option add
local function SoulContextSD(player, context, items) -- # When an inventory item context menu is opened
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:IsWeapon() and not item:isRanged() then
			local weaponModData = item:getModData()
			local weaponMaxCond = item:getConditionMax()
			local weaponCondLowerChance = item:getConditionLowerChance()
			local soulsRequired = weaponMaxCond * weaponCondLowerChance * 3
			local soulsFreed = weaponModData.KillCount or nil
			if soulsFreed ~= nil then
				context:addOption("Soul Power: " .. soulsFreed .. "/" .. soulsRequired, item, SoulWeaponUpgradeSD, player)
			end
			break
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(SoulContextSD) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option

function SoulCountSD(character, handWeapon)

	local player = character
	local tierzone = checkZone()
	local weaponModData = handWeapon:getModData()

	if player ~= nil and not handWeapon:isRanged() and player:getPrimaryHandItem() ~= nil then
	
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

--[[
function SDWeaponCheck(character, inventoryItem)
	--character:Say("SDWeaponCheck")

	if inventoryItem == nil then
		--character:Say("Inventory Item is Nil")
		--return
	elseif inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		
		local modData = inventoryItem:getModData()
	
		if	modData.CriticalChance	== nil and
			modData.CritDmgMultiplier	== nil and
			modData.MinDamage		== nil and
			modData.MaxDamage		== nil and
			modData.Name			== nil then
			
			local o_critrate 	=	inventoryItem:getCriticalChance()
			local o_critmulti	=	inventoryItem:getCritDmgMultiplier()
			local o_mindmg		=	inventoryItem:getMinDamage()
			local o_maxdmg		=	inventoryItem:getMaxDamage()
			local o_name		=	character:getPrimaryHandItem():getName()
			--print(o_name .. " base name")

			modData.CriticalChance	= o_critrate
			modData.CritDmgMultiplier	= o_critmulti
			modData.MinDamage		= o_mindmg
			modData.MaxDamage		= o_maxdmg
			modData.Name			= o_name
			--character:Say("mod data stored")
		else
			--character:Say("mod data already exists, nothing needs to be done")
		end
		--character:Say("Inventory Item exists")
		local basecritrate 	= modData.CriticalChance
		local basecritmulti = modData.CritDmgMultiplier
		local basemindmg 	= modData.MinDamage
		local basemaxdmg 	= modData.MaxDamage
		local basename		= modData.Name
		
		inventoryItem:setCriticalChance(basecritrate)
		inventoryItem:setCritDmgMultiplier(basecritmulti)
		inventoryItem:setMinDamage(basemindmg)
		inventoryItem:setMaxDamage(basemaxdmg)
		inventoryItem:setName(basename)
		
		if modData.KillCount == nil then
			modData.KillCount = 0
		end
		
		modData.PlayerKills = KillCountSD(character)
		
	end
	
end

Events.OnEquipPrimary.Add(SDWeaponCheck)
]]--