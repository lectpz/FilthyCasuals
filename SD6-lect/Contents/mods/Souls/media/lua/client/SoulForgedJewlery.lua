local soulForgeBuffWeights = {
    ["luck"] = 5,
    ["SoulSmith"] = 5,
    ["SoulThirst"] = 5,
    ["SoulStrength"] = 1,
    ["SoulDexterity"] = 1,
    ["MaxCondition"] = 10,
    ["ConditionLowerChance"] = 10,
    ["CritRate"] = 10,
    ["CritMulti"] = 20,
    ["MaxDmg"] = 15,
 }
 
 local tierBuffs = {
    T1 = {"CritMulti", "SoulDexterity"},
    T2 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith"},
    T3 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition"},
    T4 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate"},
    T5 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate", "SoulStrength", "MaxDmg"}
 }
 
 local buffDisplayNames = {
    luck = "Luck",
    SoulSmith = "Soul Smith",
    SoulThirst = "Soul Thirst",
    SoulStrength = "Strength",
    SoulDexterity = "Dexterity",
    MaxCondition = "Durability",
    ConditionLowerChance = "Resilience",
    CritRate = "Critical Chance",
    CritMulti = "Critical Multiplier",
    MaxDmg = "Maximum Damage"
 }
 
 local BUFF_CALCULATIONS = {
    SoulStrength = {
        format = "+%d Strength",
        getDisplayValue = function(tier) return 1 end,
        getBonus = function(tier) return 1 end,
        modData = "PermaSoulForgeStrengthBonus",
        apply = function(player, value, isEquipping)
            if isEquipping and not player:getModData().originalMaxWeightBase then
                player:getModData().originalMaxWeightBase = player:getMaxWeightBase()
            end
            local originalWeight = player:getModData().originalMaxWeightBase or player:getMaxWeightBase()
            player:setMaxWeightBase(originalWeight + (player:getModData().PermaSoulForgeStrengthBonus or 0))
        end
    },
    SoulDexterity = {
        format = "+%d%% Transfer Speed",
        getDisplayValue = function(tier) return 1.6 * tier end,
        getBonus = function(tier) return 0.016 * tier end,
        modData = "PermaSoulForgeDexterityBonus"
    },
    SoulSmith = {
        format = "+%d%% Soul Smith Bonus",
        getDisplayValue = function(tier) return 5 * tier end,
        getBonus = function(tier) return 5 * tier end,
        modData = "PermaSoulSmithValue"
    },
    SoulThirst = {
        format = "+%d%% Soul Thirst Bonus",
        getDisplayValue = function(tier) return 10 * tier end,
        getBonus = function(tier) return 0.1 * tier end,
        modData = "PermaSoulThirstValue"
    },
    MaxCondition = {
        format = "+%d Durability",
        getDisplayValue = function(tier) return math.ceil(0.5 * tier) end,
        getBonus = function(tier) return math.ceil(0.5 * tier) end,
        modData = "PermaMaxConditionBonus"
    },
    luck = {
        format = "+%d Luck",
        getDisplayValue = function(tier) return 10 * tier end,
        getBonus = function(tier) return 10 * tier end,
        modData = "PermaSoulForgeLuckBonus"
    },
    ConditionLowerChance = {
        format = "+%d Condition Resilience",
        getDisplayValue = function() return 2 end,
        getBonus = function() return 2 end,
        modData = "PermaSoulForgeConditionBonus"
    },
    CritRate = {
        format = "+%.1f%% Critical Strike Chance",
        getDisplayValue = function(tier) return 2 * tier end,
        getBonus = function(tier) return 0.02 * tier end,
        modData = "PermaSoulForgeCritRateBonus"
    },
    CritMulti = {
        format = "+%.1f%% Critical Strike Multiplier",
        getDisplayValue = function(tier) return 3 * tier end,
        getBonus = function(tier) return 0.03 * tier end,
        modData = "PermaSoulForgeCritMultiBonus"
    },
    MaxDmg = {
        format = "+%.1f%% Maximum Damage",
        getDisplayValue = function(tier) return 2 * tier end,
        getBonus = function(tier) return 0.02 * tier end,
        modData = "PermaSoulForgeMaxDmgBonus"
    }
 }
 
 -- Utility functions
 local function getTierNumber(item)
    local modData = item:getModData()
    
    if not modData.Tier then 
        print("getTierNumber: modData.Tier is nil")
        return 1 
    end
 
    if type(modData.Tier) == "number" then
        return modData.Tier
    end
    
    local tierMatch = string.match(modData.Tier, "T(%d)")
    
    return tonumber(tierMatch) or 1
 end
 
 local function getWeightedBuff(tier)
    local availableBuffs = tierBuffs[tier]
    local totalWeight = 0
    local buffWeights = {}
 
    for _, buff in ipairs(availableBuffs) do
        local weight = soulForgeBuffWeights[buff] or 0
        totalWeight = totalWeight + weight
        table.insert(buffWeights, {
            buff = buff,
            weight = weight
        })
    end
 
    local roll = ZombRand(totalWeight)
    local currentWeight = 0
 
    for _, buffData in ipairs(buffWeights) do
        currentWeight = currentWeight + buffData.weight
        if roll < currentWeight then
            return buffData.buff
        end
    end
 
    return buffWeights[1].buff
 end
 
 function OnTest_CheckInInventory(item)
    local player = getSpecificPlayer(0)

    local isOwnSafeHouse = SafeHouse.hasSafehouse(player)
    local x = player:getX()
    local y = player:getY()

    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX()
        local shy1 = isOwnSafeHouse:getY()-15
        local shx2 = isOwnSafeHouse:getW() + shx1
        local shy2 = isOwnSafeHouse:getH() + shy1

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
            return true
        end
    end
    
    if not item:isInPlayerInventory() then return false end

    return true
 end
 
 function ApplyBaseItemProperties(result)
    if not result then return end
    local modData = result:getModData()
    local selectedBuff = modData.SoulBuff

    if not modData.BaseItem then return end

    local baseItem = InventoryItemFactory.CreateItem(modData.BaseItem)
    
    local displayBuffName = buffDisplayNames[selectedBuff] or selectedBuff
    local itemName = result:getName() .. " of " .. displayBuffName

    result:setName(itemName)
end
 
 local function modifyBuff(player, item, isEquipping, buffType)
    local buff = BUFF_CALCULATIONS[buffType]
    if not buff then return end
    
    local tier = getTierNumber(item)
    local value = buff.getBonus(tier)
    local pMD = player:getModData()
    
    if isEquipping then
        pMD[buff.modData] = (pMD[buff.modData] or 0) + value
    else
        pMD[buff.modData] = (pMD[buff.modData] or 0) - value
    end
    
    if buff.apply then
        buff.apply(player, value, isEquipping)
    end
 end
 
 -- Event watchers
 function SoulForgedJewelryOnCreate(items, result, player)
    if not result then return end
    if not items then return end
    
    local tier = 1
    for i=0, items:size()-1 do
        local itemType = items:get(i):getFullType()
        if itemType == "SoulForge.SoulShardT5" then 
            tier = 5
            break
        elseif itemType == "SoulForge.SoulShardT4" then 
            tier = 4
        elseif itemType == "SoulForge.SoulShardT3" then 
            tier = 3
        elseif itemType == "SoulForge.SoulShardT2" then 
            tier = 2
        end
    end
    
    local selectedBuff = getWeightedBuff("T" .. tier)
    
    local resultBodyLocation = result:getBodyLocation()
    
    local allItems = getAllItems()
    local validItems = {}
    
    for i=0, allItems:size()-1 do
        local itemType = allItems:get(i)
        if itemType:getBodyLocation() == resultBodyLocation then
            table.insert(validItems, itemType:getFullName())
        end
    end
    
    if #validItems > 0 then
        local randomIndex = ZombRand(1, #validItems + 1)
        local selectedJewelry = validItems[randomIndex]
        result:getModData().BaseItem = selectedJewelry
        result:getModData().SoulBuff = selectedBuff
        result:getModData().Tier = tier
        
        ApplyBaseItemProperties(result)
    end
 end
 
 local function OnClothingUpdated(player)
    
    if not player:getModData().originalMaxWeightBase then
        player:getModData().originalMaxWeightBase = player:getMaxWeightBase()
    end
    
    for _, buff in pairs(BUFF_CALCULATIONS) do
        player:getModData()[buff.modData] = 0
    end
    player:setMaxWeightBase(player:getModData().originalMaxWeightBase)

    local playerWornItems = getPlayer():getWornItems()
    for i=0,playerWornItems:size()-1 do 
        local item = playerWornItems:get(i):getItem()
        local itemFT = item:getFullType()

        if string.find(itemFT, "SoulForgeJewelery") then
            local modData = item:getModData()
            local buff = modData.SoulBuff
            
            if buff and BUFF_CALCULATIONS[buff] then
                modifyBuff(player, item, true, buff)
            end
        end
    end
 end
 
 -- OverWrites
 local original_new = ISInventoryTransferAction.new
 function ISInventoryTransferAction:new(character, item, srcContainer, destContainer, time)
    local o = original_new(self, character, item, srcContainer, destContainer, time)
    local dexterityBonus = character:getModData().PermaSoulForgeDexterityBonus or 0
    
    if o and dexterityBonus > 0 then
        o.maxTime = o.maxTime - (o.maxTime * dexterityBonus);
    end
    
    return o
 end
 
 
 -- Tooltip logic
 local callback_render = ISToolTipInv.render;
 
 local bg = {a=1, r=1, g=0.8, b=1};
 local bg_green = {a=1, r=0, g=0.8, b=0};
 local bg_red = {a=1, r=0.8, g=0, b=0};
 
 function createTooltip(item)
    if not item then return "" end
    
    local modData = item:getModData()
    if not modData or not modData.SoulBuff then return "" end
    
    local buff = modData.SoulBuff
    local tier = getTierNumber(item)
    
    local buffCalc = BUFF_CALCULATIONS[buff]
    if not buffCalc then return "Invalid Buff" end
    
    local value = buffCalc.getDisplayValue(tier)
    return string.format(buffCalc.format, value)
 end
 
 local function draw_remaining(tooltip, pos_y, value, font)
    local selected_bg = bg_green;
    tooltip:drawText(value, 16, pos_y, selected_bg.r, selected_bg.g, selected_bg.b, selected_bg.a, font);
 end
 
 function drawTooltip(tooltip, modData)
    local font = getCore():getOptionTooltipFont();
    local drawFont = UIFont.Medium;
    if font == "Large" then drawFont = UIFont.Large; elseif font == "Small" then drawFont = UIFont.Small; end;
 
    local toolwidth = tooltip:getWidth();
    local toolheight = tooltip:getHeight();
    local draw_height = getTextManager():MeasureStringY(drawFont, "XYZ");
 
    local box_height = draw_height + 16;
 
    tooltip:drawRect(0, toolheight - 1, toolwidth, box_height, tooltip.backgroundColor.a, tooltip.backgroundColor.r, tooltip.backgroundColor.g, tooltip.backgroundColor.b);
    tooltip:drawRectBorder(0, toolheight - 1, toolwidth, box_height, tooltip.borderColor.a, tooltip.borderColor.r, tooltip.borderColor.g, tooltip.borderColor.b);
 
    local tooltipContent = createTooltip(tooltip.item);
 
    draw_remaining(tooltip, toolheight + 4, tooltipContent, drawFont);
 end
 
 function ISToolTipInv:render()
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        local itemObj = self.item;
        local modData = self.item:getModData()
        if itemObj and modData.SoulBuff then
            drawTooltip(self, modData)
        end
    end
 
    return callback_render(self);
 end
 
 -- Event bindings
 Events.EveryOneMinute.Add(function()
    OnClothingUpdated(getPlayer())
 end)