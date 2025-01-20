local TooltipSystem = {}
local BuffSystem = require('SoulForgedJeweleryBuffs')

-- Color definitions for different tooltip states
local colors = {
    background = {
        normal = {a=1, r=1, g=0.8, b=1},
        positive = {a=1, r=0, g=0.8, b=0},
        negative = {a=1, r=0.8, g=0, b=0}
    }
}

-- Creates tooltip content for an item
function TooltipSystem.createTooltip(item)
    if not item then return "" end
    
    local modData = item:getModData()
    if not modData or not modData.SoulBuff then return "" end
    
    local buff = modData.SoulBuff
    local tier = BuffSystem.getTierNumber(item)
    
    local buffCalc = BuffSystem.BUFF_CALCULATIONS[buff]
    if not buffCalc then return "Invalid Buff" end
    
    local value = buffCalc.getDisplayValue(tier)
    return string.format(buffCalc.format, value)
end

-- Helper function to draw tooltip text with specific color
local function drawTooltipText(tooltip, pos_y, value, font)
    local color = colors.background.positive
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

    -- Calculate dimensions
    local toolwidth = tooltip:getWidth()
    local toolheight = tooltip:getHeight()
    local draw_height = getTextManager():MeasureStringY(drawFont, "XYZ")
    local box_height = draw_height + 16

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

    -- Get and draw content
    local tooltipContent = TooltipSystem.createTooltip(tooltip.item)
    drawTooltipText(tooltip, toolheight + 4, tooltipContent, drawFont)
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