require "ISUI/ISPanelJoypad"

require "BioGasUI/HBGUI"
local rGood, gGood, bGood, rBad, gBad, bBad = BioGasMenu.getRGB()

BioGasWindowDetails = ISPanelJoypad:derive("BioGasWindowDetails")

function BioGasWindowDetails:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, BioGasWindowDetails.measureWidth(), height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    BioGasWindowDetails.instance = o
    return o
end

function BioGasWindowDetails:setVisible(visible)
    ISPanelJoypad.setVisible(self,visible)
    if visible then
        self:setWidthAndParentWidth(self.width)
    end
end

function BioGasWindowDetails:render()
    local bg = self.parent.parent.luaHBG
    if not (bg and bg:getIsoObject()) then print("HBG no Lua Obj"); return BioGasStatusWindow.instance:close() end

    local textX = 10
    local textXr = self.width -10
    local textY = 10
    local borderX, borderY, borderW, borderH = 5,0,self.width-10,0
    local fontHeightSm = getTextManager():getFontHeight(UIFont.Small)
    local fontHeightMed = getTextManager():getFontHeight(UIFont.Medium)

    bg:updateFromIsoObject()
    local player = self.parent.parent.player
    local maxWaste = SandboxVars.BioGas.MaxBiowaste
 
    if bg then
        borderY, borderH = textY-3, fontHeightSm * 3 + 6
        self:drawRect(borderX, borderY, borderW, borderH, 0.7, 0.2, 0.2, 0.2)
        self:drawRectBorder(borderX, borderY, borderW, borderH, 1, 0.3, 0.3, 0.3)

        if bg.biowaste == 0 then
            self:drawText(getText("IGUI_BioGas_Window_Details_Waste"), textX, textY, rBad, gBad, bBad, 1, UIFont.Small)
            self:drawTextRight(tostring(round((bg.biowaste / SandboxVars.BioGas.MaxBiowaste) * 100) .. "%"), textXr, textY, rBad, gBad, bBad, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            self:drawText(getText("IGUI_BioGas_Window_Details_Waste"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawTextRight(tostring(round((bg.biowaste / SandboxVars.BioGas.MaxBiowaste) * 100) .. "%"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end

        if bg.methane == SandboxVars.BioGas.MaxMethane then
            self:drawText(getText("IGUI_BioGas_Window_Details_Methane"), textX, textY, rBad, gBad, bBad, 1, UIFont.Small)
            self:drawTextRight(tostring(round(bg.methane,2) .. " Units"), textXr, textY, rBad, gBad, bBad, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            self:drawText(getText("IGUI_BioGas_Window_Details_Methane"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawTextRight(tostring(round(bg.methane,2) .. " Units"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end

        if bg.fertilizer == SandboxVars.BioGas.MaxFertilizer then
            self:drawText(getText("IGUI_BioGas_Window_Details_Fertilizer"), textX, textY, rBad, gBad, bBad, 1, UIFont.Small)
            self:drawTextRight(tostring(round(bg.fertilizer,2) .. " Units"), textXr, textY, rBad, gBad, bBad, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            self:drawText(getText("IGUI_BioGas_Window_Details_Fertilizer"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawTextRight(tostring(round(bg.fertilizer,2) .. " Units"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end
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
        max = math.max(max + 35,len)
    end
    return max
end

function BioGasWindowDetails.measureWidth()
    local varTexts = {
        {"%s 100%%","IGUI_BioGas_Window_Details_Waste"},
        {"%s 999.99 Units","IGUI_BioGas_Window_Details_Methane"},
        {"%s 999.99 Units","IGUI_BioGas_Window_Details_Fertilizer"},
    }
    local max = maxWidthOfVarTexts(varTexts)
    
    return max
end
