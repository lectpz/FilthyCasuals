local Config = require('SoulForgedJewelryConfig')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local BuffSystem = require('SoulForgedJewelryBuffs')
local function SoulForgedJewelryUpgrade(player, context, items)
    if isAdmin() or isDebugEnabled() then
    
		if not items or #items == 0 then return end
		local _items = ISInventoryPane.getActualItems(items)
		local item = _items[1]
		
		local soulForgeOption = context:addOption("Soul Forge Modify", worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context)
		context:addSubMenu(soulForgeOption, subMenu)
		
		local function onSelectBuff(worldobjects, item, buffId)
			item:getModData().SoulBuff = buffId
			item:getModData().SoulBuffs = nil
			
			if not item:getModData().Tier then
				item:getModData().Tier = 1
			end
			ItemGenerator.SetResultName(item)
			getPlayer():Say("Set " .. item:getName() .. " buff to " .. Config.buffDisplayNames[buffId])
		end
		
		local function onSelectMultipleBuff(worldobjects, item, buffId)
			local modData = item:getModData()
			if not modData.SoulBuffs then
				modData.SoulBuffs = {}
			end
			
			local alreadyHas = false
			for i, existingBuff in ipairs(modData.SoulBuffs) do
				if existingBuff == buffId then
					table.remove(modData.SoulBuffs, i)
					alreadyHas = true
					break
				end
			end
			
			if not alreadyHas then
				table.insert(modData.SoulBuffs, buffId)
			end
			
			modData.SoulBuff = nil
			
			if not modData.Tier then
				modData.Tier = 1
			end
			ItemGenerator.SetResultName(item)
			
			local action = alreadyHas and "Removed" or "Added"
			getPlayer():Say(action .. " " .. Config.buffDisplayNames[buffId] .. " buff " .. (alreadyHas and "from" or "to") .. " " .. item:getName())
		end
		
		local function onSelectTier(worldobjects, item, tier)
			item:getModData().Tier = tier
			
			if not item:getModData().SoulBuff then
				item:getModData().SoulBuff = "luck"
			end
			ItemGenerator.SetResultName(item)
			getPlayer():Say("Set " .. item:getName() .. " tier to " .. tier)
		end
		
		local function onSelectIndividualBuffTier(worldobjects, item, buffId, tier)
			BuffSystem.setBuffTier(item, buffId, tier)
			ItemGenerator.SetResultName(item)
			getPlayer():Say("Set " .. Config.buffDisplayNames[buffId] .. " tier to " .. tier .. " on " .. item:getName())
		end
		
		local buffOption = subMenu:addOption("Set Single Buff", worldobjects, nil)
		local buffSubMenu = ISContextMenu:getNew(subMenu)
		context:addSubMenu(buffOption, buffSubMenu)
		
		for buffId, buffName in pairs(Config.buffDisplayNames) do
			buffSubMenu:addOption(buffName, worldobjects, onSelectBuff, item, buffId)
		end
		
		local multiBuffOption = subMenu:addOption("Toggle Multiple Buffs", worldobjects, nil)
		local multiBuffSubMenu = ISContextMenu:getNew(subMenu)
		context:addSubMenu(multiBuffOption, multiBuffSubMenu)
		
		for buffId, buffName in pairs(Config.buffDisplayNames) do
			local currentBuffs = item:getModData().SoulBuffs or {}
			local hasThisBuff = false
			for _, existingBuff in ipairs(currentBuffs) do
				if existingBuff == buffId then
					hasThisBuff = true
					break
				end
			end
			local displayName = hasThisBuff and "[X] " .. buffName or "[ ] " .. buffName
			multiBuffSubMenu:addOption(displayName, worldobjects, onSelectMultipleBuff, item, buffId)
		end
		
		local tierOption = subMenu:addOption("Set Tier", worldobjects, nil)
		local tierSubMenu = ISContextMenu:getNew(subMenu)
		context:addSubMenu(tierOption, tierSubMenu)
		
		for i = 1, 5 do
			tierSubMenu:addOption("Tier " .. i, worldobjects, onSelectTier, item, i)
		end
		
		-- Individual buff tier management for items with multiple buffs
		local modData = item:getModData()
		if modData.SoulBuffs and #modData.SoulBuffs > 0 then
			local individualTierOption = subMenu:addOption("Set Individual Buff Tiers", worldobjects, nil)
			local individualTierSubMenu = ISContextMenu:getNew(subMenu)
			context:addSubMenu(individualTierOption, individualTierSubMenu)
			
			for _, buffId in ipairs(modData.SoulBuffs) do
				local buffName = Config.buffDisplayNames[buffId] or buffId
				local currentTier = BuffSystem.getBuffTier(item, buffId)
				local buffTierOption = individualTierSubMenu:addOption(buffName .. " (T" .. currentTier .. ")", worldobjects, nil)
				local buffTierSubMenu = ISContextMenu:getNew(individualTierSubMenu)
				context:addSubMenu(buffTierOption, buffTierSubMenu)
				
				for tier = 1, 5 do
					local tierLabel = "Tier " .. tier
					if tier == currentTier then
						tierLabel = tierLabel .. " [CURRENT]"
					end
					buffTierSubMenu:addOption(tierLabel, worldobjects, onSelectIndividualBuffTier, item, buffId, tier)
				end
			end
		end
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(SoulForgedJewelryUpgrade)
