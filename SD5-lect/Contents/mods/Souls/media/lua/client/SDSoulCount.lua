----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

local function KillCountSD(player)
	return player:getZombieKills()
end

local soulsghs = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local soulsbhs = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "


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
			
			local function itemStats()
				soulPower = math.min(soulsFreed / soulsRequired, 1) or 0
				tooltip.description = tooltip.description .. soulsghs .. " <LINE> <LINE> Stat modifiers to weapon: <LINE> "
				tooltip.description = tooltip.description .. soulsghs .. " <LINE> Extra Base Maximum Damage: +" .. math.floor(soulPower * 10)/10 .. " <LINE> "
				tooltip.description = tooltip.description .. soulsghs .. "Extra Base Critical Chance: +" .. math.floor(soulPower * 50)/10 .. "% <LINE> "
				tooltip.description = tooltip.description .. soulsghs .. "Extra Base Critical Multi: +" .. math.floor(soulPower * 50)/100 .. "x <LINE> "
			end
			
			if not soulsFreed then return end
			soulsContext = context:addOption("Soul Power: " .. soulsFreed .. "/" .. soulsRequired, item, nil, player)

			if soulsFreed ~= nil then
			
				function modifySouls(item, player, amount)
					weaponModData.KillCount = soulsFreed + amount
					soulsFreed = weaponModData.KillCount
				end

				if soulsFreed < soulsRequired then
					soulsContext.notAvailable = true;
					tooltip = ISWorldObjectContextMenu.addToolTip();
					tooltip.description = tooltip.description .. "You need to free more souls."
					soulsContext.toolTip = tooltip
					if weaponModData.SoulForged then itemStats() end
				else
					submenu = ISContextMenu:getNew(context)
					context:addSubMenu(soulsContext, submenu)
					
					function updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
						local n_soulsFreed = math.max(soulsFreed - math.floor(soulsRequired/((math.min(5, weaponRepairedStack) -1)/2)),0)
						return n_soulsFreed
					end
					
					n_soulsFreed = updatesoulsFreed(soulsFreed, soulsRequired, weaponRepairedStack)
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
					--infuse weapon
					------------------------------------------------------------------------------------------------------
					local function removeWeaponsNotEquipped(playerObj, item)
						local inv = playerObj:getInventory()
						local items = inv:getItemsFromFullType(item:getFullType(), true)
						for i=1,items:size() do
							local invItem = items:get(i-1)
							if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
								if invItem ~= playerObj:getPrimaryHandItem() then
									if not invItem:getModData().SoulForged then
										playerInv:Remove(invItem)
										break
									end
								end
							end
						end
					end
					
					local function countWeapons(playerObj, item)
						local inv = playerInv
						local items = inv:getItemsFromFullType(item:getFullType(), true)
						local count = 0
						for i=1,items:size() do
							local invItem = items:get(i-1)
							if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
								if not invItem:getModData().SoulForged then
									count = count + 1
								end
							end
						end
						return count
					end
					
					local function itemToolTipMats(material)
						local scriptItem = ScriptManager.instance:getItem(material)
						local itemdisplayname = scriptItem:getDisplayName()
						tooltip.description = tooltip.description .. " <LINE> "
						if not playerInv:contains(material) then
							option_soulForgeWeapon.notAvailable = true;
							--tooltip = ISWorldObjectContextMenu.addToolTip();
							tooltip.description = tooltip.description .. soulsbhs .. itemdisplayname .. " 0/1" ;
						else
							count = playerInv:getCountTypeRecurse(material)
							tooltip.description = tooltip.description .. soulsghs .. itemdisplayname .. " " .. count .. "/1" ;
						end
					end
					
						
					
					local function soulForgeWeapon(item, player)
						print(item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName()
						weaponModData.MinDamage = scriptItem:getMinDamage()
						weaponModData.MaxDamage = scriptItem:getMaxDamage()
						weaponModData.SoulForged = true
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT1")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT2")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT3")
						playerInv:RemoveOneOf("SoulForge.SoulCrystalT4")
						removeWeaponsNotEquipped(playerObj, item)
						removeWeaponsNotEquipped(playerObj, item)
						item:setName(weaponModData.Name)
					end
					
					option_soulForgeWeapon = submenu:addOption("Soul Forge Weapon", item, soulForgeWeapon, player)
					
					local forged = weaponModData.SoulForged or false

					if forged then
						submenu:removeOptionByName("Soul Forge Weapon")
						tooltip = ISWorldObjectContextMenu.addToolTip();
						option_soulForgeModifiers = submenu:addOption("Soul Forged Modifiers", item, nil, player)
						option_soulForgeModifiers.toolTip = tooltip
						itemStats()
					elseif (weaponCurrentCondition ~= weaponMaxCond or soulsFreed < soulsRequired) then
						print("elseif")
						option_soulForgeWeapon.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "Requires " .. soulsRequired .. " Soul Power and full weapon condition to Soul Forge. <LINE> "
						option_soulForgeWeapon.toolTip = tooltip
						itemStats()
					else
						--option_soulForgeWeapon.notAvailable = true;
						tooltip = ISWorldObjectContextMenu.addToolTip();
						tooltip.description = tooltip.description .. "Materials required: <LINE> "
						option_soulForgeWeapon.toolTip = tooltip
						
						itemToolTipMats("SoulForge.SoulCrystalT1")
						itemToolTipMats("SoulForge.SoulCrystalT2")
						itemToolTipMats("SoulForge.SoulCrystalT3")
						itemToolTipMats("SoulForge.SoulCrystalT4")
						
						count = countWeapons(playerObj, item)
						local scriptItem = ScriptManager.instance:getItem(item:getFullType())
						if count < 3 then
							option_soulForgeWeapon.notAvailable = true;
							tooltip.description = tooltip.description .. soulsbhs .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. math.max(0,count-1) .. "/2" ;
						elseif count >= 3 then
							tooltip.description = tooltip.description .. soulsghs .. " <LINE> " .. scriptItem:getDisplayName() .. " " .. count-1 .. "/2" ;
						end
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
			weaponModData.KillCount = 0 --SD write initial killcount to weapon (zero). in case a weapon does not have an internal kill counter.
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