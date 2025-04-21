local TooltipSystem = {}
local BuffSystem = require('SoulForgedJewelryBuffs')

-- Color definitions for different tooltip states
local colors = {
    background = {
        normal = {a=1, r=1, g=0.8, b=1},
        positive = {a=1, r=0, g=0.8, b=0},
        negative = {a=1, r=0.8, g=0, b=0}
    }
}

function TooltipSystem.getEquippedInSlot(player, bodyLocation)
    local inventory = player:getInventory()
    local equipped = inventory:getItems()
    
    for i = 0, equipped:size() - 1 do
        local item = equipped:get(i)
        if item:isEquipped() and item:getBodyLocation() == bodyLocation then
            return item
        end
    end
    return nil
end

-- Calculate total excluding an item
function TooltipSystem.calculateBuffTotal(player, buffType, options)
    
    options = options or {}
    local total = 0
    local inventory = player:getInventory()
    local equipped = inventory:getItems()
    
    -- Process equipped items
    for i = 0, equipped:size() - 1 do
        local item = equipped:get(i)
        
        -- Check if item should be counted based on options
        local shouldCount = item:isEquipped() and 
                           item:getModData().SoulBuff == buffType and
                           (not options.excludeItem or item ~= options.excludeItem) and
                           (not options.bodyLocation or item:getBodyLocation() == options.bodyLocation)
        
        if shouldCount then
            local tier = BuffSystem.getTierNumber(item)
            local buffCalc = BuffSystem.BUFF_CALCULATIONS[buffType]
            if buffCalc then
                total = total + buffCalc.getDisplayValue(tier)
            end
        end
    end
    
    -- Add potential new item if specified
    if options.includeItem and options.includeItem:getModData().SoulBuff == buffType then
        local tier = BuffSystem.getTierNumber(options.includeItem)
        local buffCalc = BuffSystem.BUFF_CALCULATIONS[buffType]
        if buffCalc then
            total = total + buffCalc.getDisplayValue(tier)
        end
    end
    
    return total
end

function TooltipSystem.createTooltip(item)
    if not item then return "", false end
    
    local modData = item:getModData()
    if not modData or not modData.SoulBuff then return "", false end
    
    local buff = modData.SoulBuff
    local tier = BuffSystem.getTierNumber(item)
    
    local buffCalc = BuffSystem.BUFF_CALCULATIONS[buff]
    if not buffCalc then return "Invalid Buff", false end
    
    local value = buffCalc.getDisplayValue(tier)
    
    -- Format the main value string based on buff type
    local mainText
    if buff == "luck" or buff == "SoulStrength" then
        mainText = string.format("[T%d] %+.1f %s", tier, value, buffCalc.format)
    else 
        mainText = string.format("[T%d] %+.1f%% %s", tier, value, buffCalc.format)
    end
    
    local tooltip = mainText
    local player = getPlayer()
    local currentTotal = TooltipSystem.calculateBuffTotal(player, buff)
    
    -- Track if this would be a downgrade
    local isDowngrade = false
    
    -- Add total info based on equipped state and buff type
    local hasLostBuff = false  -- Flag to track if we have a lost buff line
    
    -- Check if buff has a maximum value
    local hasMaxValue = buffCalc.maxValue ~= nil
    local isAtMax = hasMaxValue and currentTotal >= buffCalc.maxValue
    
    -- Add total info based on equipped state and buff type
    if item:isEquipped() then
        if buff == "luck" or buff == "SoulStrength" then
            tooltip = tooltip .. string.format("\nCurrent Total: %+.1f", currentTotal)
            -- Add max value indicator if applicable
            if hasMaxValue then
                tooltip = tooltip .. string.format(" (Max: %+.1f)", buffCalc.maxValue)
                if isAtMax then
                    tooltip = tooltip .. " [MAXED]"
                end
            end
        else
            tooltip = tooltip .. string.format("\nCurrent Total: %+.1f%%", currentTotal)
            -- Add max value indicator if applicable
            if hasMaxValue then
                tooltip = tooltip .. string.format(" (Max: %+.1f%%)", buffCalc.maxValue)
                if isAtMax then
                    tooltip = tooltip .. " [MAXED]"
                end
            end
        end
    else
        -- Get currently equipped item in same slot
        local equippedItem = TooltipSystem.getEquippedInSlot(player, item:getBodyLocation())
        local baseTotal = currentTotal
        local newTotal = baseTotal
        
        -- Only add the value if we're not already at max
        if not hasMaxValue or baseTotal < buffCalc.maxValue then
            newTotal = math.min(baseTotal + value, hasMaxValue and buffCalc.maxValue or (baseTotal + value))
        end
        
        -- Determine if this would be a downgrade
        if equippedItem and equippedItem:getModData().SoulBuff == buff then
            local equippedValue = BuffSystem.BUFF_CALCULATIONS[buff].getDisplayValue(BuffSystem.getTierNumber(equippedItem))
            isDowngrade = value < equippedValue
        end
        
        if buff == "luck" or buff == "SoulStrength" then
            tooltip = tooltip .. string.format("\nTotal: %+.1f -> %+.1f", baseTotal, newTotal)
            -- Add max value indicator if applicable
            if hasMaxValue then
                tooltip = tooltip .. string.format(" (Max: %+.1f)", buffCalc.maxValue)
                if newTotal >= buffCalc.maxValue then
                    tooltip = tooltip .. " [MAXED]"
                end
            end
        else
            tooltip = tooltip .. string.format("\nTotal: %+.1f%% -> %+.1f%%", baseTotal, newTotal)
            -- Add max value indicator if applicable
            if hasMaxValue then
                tooltip = tooltip .. string.format(" (Max: %+.1f%%)", buffCalc.maxValue)
                if newTotal >= buffCalc.maxValue then
                    tooltip = tooltip .. " [MAXED]"
                end
            end
        end
        
        -- Add info about different buff being replaced
        if equippedItem and equippedItem:getModData().SoulBuff and equippedItem:getModData().SoulBuff ~= buff then
            hasLostBuff = true  -- Set flag when we add a lost buff line
            local oldBuff = equippedItem:getModData().SoulBuff
            local oldBuffCalc = BuffSystem.BUFF_CALCULATIONS[oldBuff]
            local oldValue = oldBuffCalc.getDisplayValue(BuffSystem.getTierNumber(equippedItem))
            local oldTotal = TooltipSystem.calculateBuffTotal(player, oldBuff)
            local newOldTotal = oldTotal - oldValue
            
            -- Format the lost buff line
            if oldBuff == "luck" or oldBuff == "SoulStrength" then
                tooltip = tooltip .. string.format("\n%s: %+.1f -> %+.1f", oldBuffCalc.format, oldTotal, newOldTotal)
            else
                tooltip = tooltip .. string.format("\n%s: %+.1f%% -> %+.1f%%", oldBuffCalc.format, oldTotal, newOldTotal)
            end
        end
    end
    
    return tooltip, isDowngrade, hasLostBuff
end

-- Helper function to draw tooltip text with specific color
local function drawTooltipText(tooltip, pos_y, value, font, isRed)
    local color = isRed and {r=0.9, g=0.1, b=0.1, a=1} or {r=.1, g=1, b=.1, a=1}
    tooltip:drawText(value, 16, pos_y, color.r, color.g, color.b, color.a, font)
end

-- Draws the jewelry tooltip box and content
function TooltipSystem.drawTooltipJewelry(tooltip, modData)
    -- Get appropriate font based on game settings
    local font = getCore():getOptionTooltipFont()
    local drawFont = UIFont.Medium
    if font == "Large" then 
        drawFont = UIFont.Large 
    elseif font == "Small" then 
        drawFont = UIFont.Small 
    end

    -- Get tooltip content and whether it's a downgrade
    local tooltipContent, isDowngrade, hasLostBuff = TooltipSystem.createTooltip(tooltip.item)
    local lines = {}
    for line in tooltipContent:gmatch("[^\n]+") do
        table.insert(lines, line)
    end

    -- Calculate dimensions
    local draw_height = getTextManager():MeasureStringY(drawFont, "XYZ")
    local box_height = (draw_height * #lines) + 16
    local toolwidth = tooltip:getWidth()
    local toolheight = tooltip:getHeight()

    -- Draw background rectangle
    tooltip:drawRect(0, toolheight - 1, toolwidth, box_height, 
        tooltip.backgroundColor.a, 
        tooltip.backgroundColor.r, 
        tooltip.backgroundColor.g, 
        tooltip.backgroundColor.b)
    
    -- Draw border
    tooltip:drawRectBorder(0, toolheight - 1, toolwidth, box_height,
        tooltip.borderColor.a,
        tooltip.borderColor.r,
        tooltip.borderColor.g,
        tooltip.borderColor.b)

    -- Draw each line of text
    for i, line in ipairs(lines) do
        local y_pos = toolheight + 4 + ((i-1) * draw_height)
        -- Color logic: red if it's the downgrade line (line 2) or the lost buff line (last line if exists)
        local shouldBeRed = (isDowngrade and i == 2) or (hasLostBuff and i == #lines)
        drawTooltipText(tooltip, y_pos, line, drawFont, shouldBeRed)
    end
end


-- Override the default tooltip renderer
function TooltipSystem.setupTooltipRenderer()
    -- Store the original render function
    local original_render = ISToolTipInv.render
    
    -- Override with our custom renderer
    ISToolTipInv.render = function(self)
        if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
            local itemObj = self.item
            if itemObj and itemObj:getModData().SoulBuff then
                TooltipSystem.drawTooltipJewelry(self, itemObj:getModData())
            end
        end
        
        -- Call original renderer
        return original_render(self)
    end
end

return TooltipSystem