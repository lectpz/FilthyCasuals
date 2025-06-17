local Config = require('SoulForgedJewelryConfig')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
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
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(SoulForgedJewelryUpgrade)
