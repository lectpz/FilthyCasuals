local Config = require('SoulForgedJewelryConfig')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')

local function SoulForgedJewelryUpgrade(player, context, items)
    if not isAdmin() or not isDebugEnabled() then return end
    
    if not items or #items == 0 then return end
    local _items = ISInventoryPane.getActualItems(items)
    local item = _items[1]
    
    local soulForgeOption = context:addOption("Soul Forge Modify", worldobjects, nil)
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(soulForgeOption, subMenu)
    
    local function onSelectBuff(worldobjects, item, buffId)
        item:getModData().SoulBuff = buffId
        
        if not item:getModData().Tier then
            item:getModData().Tier = 1
        end
        ItemGenerator.SetResultName(item)
        getPlayer():Say("Set " .. item:getName() .. " buff to " .. Config.buffDisplayNames[buffId])
    end
    
    local function onSelectTier(worldobjects, item, tier)
        item:getModData().Tier = tier
        
        if not item:getModData().SoulBuff then
            item:getModData().SoulBuff = "luck"
        end
        ItemGenerator.SetResultName(item)
        getPlayer():Say("Set " .. item:getName() .. " tier to " .. tier)
    end
    
    local buffOption = subMenu:addOption("Set Buff", worldobjects, nil)
    local buffSubMenu = ISContextMenu:getNew(subMenu)
    context:addSubMenu(buffOption, buffSubMenu)
    
    for buffId, buffName in pairs(Config.buffDisplayNames) do
        buffSubMenu:addOption(buffName, worldobjects, onSelectBuff, item, buffId)
    end
    
    local tierOption = subMenu:addOption("Set Tier", worldobjects, nil)
    local tierSubMenu = ISContextMenu:getNew(subMenu)
    context:addSubMenu(tierOption, tierSubMenu)
    
    for i = 1, 5 do
        tierSubMenu:addOption("Tier " .. i, worldobjects, onSelectTier, item, i)
    end
end

Events.OnPreFillInventoryObjectContextMenu.Add(SoulForgedJewelryUpgrade)
