require "ISUI/ISPanel"

MGGeneratorInfoWindow = ISPanel:derive("MGGeneratorInfoWindow");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function MGGeneratorInfoWindow:initialise()
    ISPanel.initialise(self);
    self:create();
end


function MGGeneratorInfoWindow:setVisible(visible)
    --    self.parent:setVisible(visible);
    self.javaObject:setVisible(visible);
end

function MGGeneratorInfoWindow:render()
--    local y = 20;
--    local splitPt = 100;
--
--    self:drawText(getText("IGUI_ItemEditor_Title"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_ItemEditor_Title")) / 2),y, 1,1,1,1, UIFont.Medium);
end

function MGGeneratorInfoWindow:prerender()
    ISPanel.prerender(self);
    local entryHgt = FONT_HGT_SMALL + 2 * 2
    local y = 15;
    local dy = math.max(20, entryHgt) + 10
    local splitPt = 100;

    local gx = self.generator:getX()
    local gy = self.generator:getY()
    local gz = self.generator:getZ()

    local vg = VirtualGenerator.Get (gx, gy, gz)
    if not vg then return end

    local fuel = self.generator:getFuel()
    local condition = self.generator:getCondition()

    local fuelLeft = ""
    if getActivatedMods():contains("GeneratorTimeRemaining") and self.generator:isActivated() then
        local fuelConsumption = getSandboxOptions():getOptionByName("GeneratorFuelConsumption"):getValue()
        local hoursDec = 100 / vg.realTotalPower * (fuel / 100) / fuelConsumption
        fuelLeft = hoursDec
        local hours = math.floor(hoursDec)
        local days = math.floor(hours / 24)
        
        if days >= 1 then
            hours = hours % 24
        end
        fuelLeft = MGGeneratorInfoWindow.Time2String(days, hours, hoursDec)
    end
    
    self:drawText(getText("IGUI_Generator_TypeGas"), 15, y, 1, 1, 1, 1, UIFont.Medium)
    
    y = y + 30;
    self:drawText(getText("IGUI_Generator_FuelAmount", string.format("%.3f", fuel)) .. fuelLeft, 90, y, 1, 1, 1, 1, UIFont.Small)

    y = y + FONT_HGT_SMALL + 1;
    self:drawText(getText("IGUI_Generator_Condition", condition), 90, y, 1, 1, 1, 1, UIFont.Small)

    local i = 0
    if self.generator:isActivated() then
        y = y + FONT_HGT_SMALL + 1 + 15;
        self:drawText(getText("IGUI_PowerConsumption") .. ":", 90, y, 1, 1, 1, 1, UIFont.Small)

        y = y + FONT_HGT_SMALL + 8;
        self:drawText("Device", 90, y, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Qty", 245, y, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Gens", 285, y, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Usage (L/h)", 325, y, 1, 1, 1, 1, UIFont.Small)

        y = y + FONT_HGT_SMALL + 4;
        self:drawText("Own consumption", 90, y, 1, 1, 1, 1, UIFont.Small)
        --self:drawText("1", 245, y, 1, 1, 1, 1, UIFont.Small)
        --self:drawText(tostring(item.div), 285, y, 1, 1, 1, 1, UIFont.Small)
        self:drawText("0.020", 325, y, 1, 1, 1, 1, UIFont.Small)
        self:drawRectBorder(90, y-1, 295, 0, 0.2, 1, 1, 1)

        for k, item in pairs(vg.groupPoweredItems) do
            y = y + FONT_HGT_SMALL + 4;
            self:drawText(item.name, 90, y, 1, 1, 1, 1, UIFont.Small)
            self:drawText(tostring(item.times), 245, y, 1, 1, 1, 1, UIFont.Small)
            self:drawText(tostring(item.div), 285, y, 1, 1, 1, 1, UIFont.Small)
            self:drawText(string.format("%.3f", item.realPower), 325, y, 1, 1, 1, 1, UIFont.Small)
            self:drawRectBorder(90, y-1, 295, 0, 0.2, 1, 1, 1)


        end
        y = y + FONT_HGT_SMALL + 4;
        self:drawText(getText("IGUI_Total"), 90, y, 1, 1, 1, 1, UIFont.Small)
        self:drawText(string.format("%.3f", vg.realTotalPower), 325, y, 1, 1, 1, 1, UIFont.Small)
        self:drawRectBorder(90, y-1, 295, 0, 0.2, 1, 1, 1)

        self.more:setVisible(true)
        self.more:setY(y + FONT_HGT_SMALL + 15)
        
        if self.more:isSelected(1) then
            local max = 0
            for k, v in pairs(vg.realTotalPowerHistory) do
                if v > max then max = v end
            end
            -- max - graphHeight
            -- v - x
        
            if max > 0 then
        
                local graphHeight = 84
                y = y + FONT_HGT_SMALL + 15
                y = y + graphHeight + FONT_HGT_SMALL + 25
        
                self:drawRectBorder(90, y-graphHeight, 288, graphHeight * 1/3, 1, 0.2, 0.2, 0.2) -- x
                self:drawRectBorder(90, y-graphHeight, 288, graphHeight * 2/3, 1, 0.2, 0.2, 0.2) -- x
                self:drawRectBorder(90, y-graphHeight, 288, graphHeight, 1, 0.2, 0.2, 0.2) -- x
        
                self:drawText(tostring(string.format("%.3f", max)), 55, y-graphHeight-7, 1, 1, 1, 0.5, UIFont.Small)
                self:drawText(tostring(string.format("%.3f", max * 2/3)), 55, y-graphHeight*2/3-7, 1, 1, 1, 0.5, UIFont.Small)
                self:drawText(tostring(string.format("%.3f", max * 1/3)), 55, y-graphHeight*1/3-7, 1, 1, 1, 0.5, UIFont.Small)
                self:drawText("0.000", 55, y-7, 1, 1, 1, 0.5, UIFont.Small)
        
                --self:drawRectBorder(90, y, 295, 0, 0.2, 1, 1, 1) -- x
                --self:drawRectBorder(90, y-graphHeight, 1, graphHeight, 0.2, 1, 1, 1) -- y
            
                for k, v in pairs(vg.realTotalPowerHistory) do
                    local h = math.floor(v * graphHeight / max)
                    self:drawRectBorder(89 + k, y - h, 1, 1, 0.4, 0, 1, 0)
                end
            end
        end
    else
        self.more:setVisible(false)
    end

    self:setHeight(y + 70);
    self.cancel:setY(y + 30)

end

function MGGeneratorInfoWindow:create()
    local btnWid = 150
    local btnHgt = FONT_HGT_SMALL + 2 * 4
    local entryHgt = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10
    local numberWidth = 50;
    local dy = math.max(20, entryHgt) + 10

    local y = 30;

    local texName = self.generator:getTextureName()
    self.image = ISImage:new(-15, -128, 64, 64, getTexture(texName))
    self.image:initialise()
    self.image:instantiate()
    self.image:setVisible(true)
    self:addChild(self.image)

    self.more = ISTickBox:new(90, 80, 10, 10, "", nil, nil)
    self.more:initialise()
    self.more:addOption("More")
    self.more:setWidthToFit()
    -- self.more:setX((self.width - self.more.width) / 2)
    -- self.more:setSelected(1, self.sensorModData.inv)
    self:addChild(self.more)

    self.cancel = ISButton:new(self:getWidth() - btnWid - 15, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_Exit"), self, MGGeneratorInfoWindow.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = self.buttonBorderColor;
    self:addChild(self.cancel);

end

function MGGeneratorInfoWindow:update()
    ISPanel.update(self)
    local player = getPlayer()
    local dist = math.sqrt(math.pow(player:getX() - self.generator:getX(), 2) + math.pow(player:getY() - self.generator:getY(), 2))
    if dist > 21 then self:removeFromUIManager() end
    
end

function MGGeneratorInfoWindow:onOptionMouseDown(button, x, y)
    self:setVisible(false)
    self:removeFromUIManager()
end

function MGGeneratorInfoWindow:close()
    self:removeFromUIManager()
end

function MGGeneratorInfoWindow:new(x, y, width, height, character, generator)
    local o = {};
    x = getMouseX() + 10;
    y = getMouseY() + 10;
    o = ISPanel:new(x, y, 400, height);
    setmetatable(o, self);
    self.__index = self;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = true;
    o.character = character;
    o.generator = generator;
    o.object = generator; -- compatibility to other mods
    -- o.sensorModData = GetSensorModData(sensor)
    MGGeneratorInfoWindow.instance = self;

    return o;
end

-- for compatibility
function MGGeneratorInfoWindow.getRichText (object, displayStats)
  return ""
end

-- wanted to use the original mod code but GTR was declared local so had to copy this here
function MGGeneratorInfoWindow.Time2String (days, hours, hoursDec)

    local str = ""
    --#region New format and switch-case
    if days > 1 then
      if hours > 1 then
        str = string.format(
          " (%.0f %s, %.0f %s)",
          days, getText("Tooltip_GTR_Days"),
          hours, getText("Tooltip_GTR_Hours")
        )
      elseif hours == 1 then
        str = string.format(
          " (%.0f %s, %.0f %s)",
          days, getText("Tooltip_GTR_Days"),
          hours, getText("Tooltip_GTR_Hour")
        )
      else
        str = string.format(
          " (%.0f %s)",
          days, getText("Tooltip_GTR_Days")
        )
      end
    elseif days == 1 then
      if hours > 1 then
        str = string.format(
          " (%.0f %s, %.0f %s)",
          days, getText("Tooltip_GTR_Day"),
          hours, getText("Tooltip_GTR_Hours")
        )
      elseif hours == 1 then
        str = string.format(
          " (%.0f %s, %.0f %s)",
          days, getText("Tooltip_GTR_Day"),
          hours, getText("Tooltip_GTR_Hour")
        )
      else
        str = string.format(
          " (%.0f %s)",
          days, getText("Tooltip_GTR_Day")
        )
      end
    else
      if hours > 1 then
        str = string.format(
          " (%.0f %s)",
          hours, getText("Tooltip_GTR_Hours")
        )
      elseif hours == 1 then
        str = string.format(
          " (%.0f %s)",
          hours, getText("Tooltip_GTR_Hour")
        )
      else
        str = string.format(
          " (%.0f %s)",
          hoursDec * 60, getText("Tooltip_GTR_Minutes")
        )
      end
    end
  
    return str
  end

  -- compatibility with other mods that manipulate this object
ISGeneratorInfoWindow = MGGeneratorInfoWindow
