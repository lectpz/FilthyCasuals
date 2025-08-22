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
			
			-- Clear NameModified flag so name can be updated
			modData.NameModified = nil
			
			if not modData.Tier then
				modData.Tier = 1
			end
			ItemGenerator.SetResultName(item)
			
			local action = alreadyHas and "Removed" or "Added"
			getPlayer():Say(action .. " " .. Config.buffDisplayNames[buffId] .. " buff " .. (alreadyHas and "from" or "to") .. " " .. item:getName())
		end
		
		
		local function onSelectIndividualBuffTier(worldobjects, item, buffId, tier)
			BuffSystem.setBuffTier(item, buffId, tier)
			-- Clear NameModified flag so name can be updated
			item:getModData().NameModified = nil
			ItemGenerator.SetResultName(item)
			getPlayer():Say("Set " .. Config.buffDisplayNames[buffId] .. " tier to " .. tier .. " on " .. item:getName())
		end
		
		local multiBuffOption = subMenu:addOption("Toggle Buffs", worldobjects, nil)
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
