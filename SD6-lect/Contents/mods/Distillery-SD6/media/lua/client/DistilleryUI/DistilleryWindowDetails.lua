require "ISUI/ISPanelJoypad"

require "DistilleryUI/DisUI"
local rGood, gGood, disood, rBad, gBad, bBad = DistilleryMenu.getRGB()

DistilleryWindowDetails = ISPanelJoypad:derive("DistilleryWindowDetails")

function DistilleryWindowDetails:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, DistilleryWindowDetails.measureWidth(), height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    DistilleryWindowDetails.instance = o
    return o
end

function DistilleryWindowDetails:setVisible(visible)
    ISPanelJoypad.setVisible(self,visible)
    if visible then
        self:setWidthAndParentWidth(self.width)
    end
end

function DistilleryWindowDetails:render()
    local dis = self.parent.parent.luaDis
    if not (dis and dis:getIsoObject()) then print("Dis no Lua Obj"); return DistilleryWindow.instance:close() end

    local textX = 10
    local textXr = self.width -10
    local textY = 10
    local borderX, borderY, borderW, borderH = 5,0,self.width-10,0
    local fontHeightSm = getTextManager():getFontHeight(UIFont.Small)
    local fontHeightMed = getTextManager():getFontHeight(UIFont.Medium)

    dis:updateFromIsoObject()
    local player = self.parent.parent.player
    local maxAmount = SandboxVars.Distillery.maxTankAmount

    if dis then
        local active = "Off"
        local power = "Check Power"
        local mode = "None"

        if dis.active then
            active = "On"
        end

        if dis.hasPower then
            power = "Power Connected"
        end

        if dis.mode == "moonshine" then
            mode = "Moonshine"
        elseif dis.mode == "ethanol" then
            mode = "Ethanol"
        else
            mode = "None"
        end

        borderY, borderH = textY-3, fontHeightSm * 3 + 20
        self:drawRect(borderX, borderY, borderW, borderH, 0.7, 0.2, 0.2, 0.2)
        self:drawRectBorder(borderX, borderY, borderW, borderH, 1, 0.3, 0.3, 0.3)
        if dis.hasPower then
            self:drawText(getText("IGUI_Distillery_Window_Details_Power"), textX, textY, rGood, gGood, disood, 1, UIFont.Small)
            self:drawTextRight(tostring(power), textXr, textY, rGood, gGood, disood, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            self:drawText(getText("IGUI_Distillery_Window_Details_Power"), textX, textY, rBad, gBad, bBad, 1, UIFont.Small)
            self:drawTextRight(tostring(power), textXr, textY, rBad, gBad, bBad, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end
        if dis.active then
            self:drawText(getText("IGUI_Distillery_Window_Details_Status"), textX, textY, rGood, gGood, disood, 1, UIFont.Small)
            self:drawTextRight(tostring(active), textXr, textY, rGood, gGood, disood, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            self:drawText(getText("IGUI_Distillery_Window_Details_Status"), textX, textY, rBad, gBad, bBad, 1, UIFont.Small)
            self:drawTextRight(tostring(active), textXr, textY, rBad, gBad, bBad, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end

        self:drawText(getText("IGUI_Distillery_Window_Details_Mode"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(tostring(mode), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm

        self:drawText(getText("IGUI_Distillery_Window_Details_Tank"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(tostring(round((dis.tank / maxAmount) * 100) .. "%"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        --self:drawRect(5, borderY, self.width-10, textY-borderY+3, 0.18, 1, 1, 1)
    else
        self:drawText(getText("IGUI_ISAWindow_Details_CantSee"), textX, textY, rBad, gBad, bBad, 1, UIFont.Medium)
        textY = textY + fontHeightMed
    end

    --self:setScrollHeight(textY+10)
    self:setHeightAndParentHeight(textY+10)
end

local function maxWidthOfTexts(texts)
    local max = 0
    for _,text in ipairs(texts) do
        local width = getTextManager():MeasureStringX(UIFont.Small, getText(text))
        max = math.max(max, width)
    end
    return max
end

local function maxWidthOfVarTexts(varTexts)
    local max = 0
    for _,textVars in ipairs(varTexts) do
        local len = getTextManager():MeasureStringX(UIFont.Small, string.format(textVars[1],getText(textVars[2])))
        max = math.max(max + 50,len)
    end
    return max
end

function DistilleryWindowDetails.measureWidth()
    local varTexts = {
        {"%s 100%% Full","IGUI_Distillery_Window_Details_Power"},
        {"%s 999.99 Units","IGUI_Distillery_Window_Details_Mode"},
        {"%s 999.99 Units","IGUI_Distillery_Window_Details_Tank"},
    }
    local max = maxWidthOfVarTexts(varTexts)
    
    return max
end
