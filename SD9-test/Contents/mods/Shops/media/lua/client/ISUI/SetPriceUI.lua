SetPriceUI = ISCollapsableWindow:derive("SetPriceUI");
SetPriceUI.instance = nil;
SetPriceUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
SetPriceUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
SetPriceUI.removeButtonX = 300
SetPriceUI.transferInProgress = false

local width = 220
local height = 150

function SetPriceUI:show(player,items,container)
    if SetPriceUI.instance==nil then
        SetPriceUI.instance = SetPriceUI:new (0, 0, width, height, player,items);
        SetPriceUI.instance.container = container
        SetPriceUI.instance:initialise();
        SetPriceUI.instance:instantiate();
    end
    SetPriceUI.instance.pinButton:setVisible(false)
    SetPriceUI.instance.collapseButton:setVisible(false)
    SetPriceUI.instance:addToUIManager();
    SetPriceUI.instance:setVisible(true);
    return SetPriceUI.instance;
end

local function twoDecimal(self)
    local quantity = self:getInternalText()
    local isNumber = tonumber(quantity)
	if not isNumber then return end
    local curPos = self:getCursorPos()
    if string.find(quantity,"%.") then
        self:setText(string.format('%.02f', quantity))
        self:setCursorPos(curPos)
    end
end

function SetPriceUI:onCoinChange()
    twoDecimal(self)
end

function SetPriceUI:onSpecialCoinChange()
    twoDecimal(self)
end

function SetPriceUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 40
    
    local coinImg = Currency.CoinsTexture.Coin
    self.coinTex = ISImage:new(x, 40, 0, 0, coinImg.texture);
    self.coinTex.scaledWidth = coinImg.scale+5
    self.coinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.coinTex);

    self.coin = ISTextEntryBox:new("0", x+30, 38, 100, 20);
    self.coin.font = UIFont.Medium
	self.coin:initialise();
	self.coin:instantiate();
	self.coin:setOnlyNumbers(true);
    self.coin.onTextChange = SetPriceUI.onCoinChange
	self:addChild(self.coin);

    coinImg = Currency.CoinsTexture.SpecialCoin
    self.specialCoinTex = ISImage:new(x, 70, 0, 0, coinImg.texture);
    self.specialCoinTex.scaledWidth = coinImg.scale+5
    self.specialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.specialCoinTex);
    
    self.specialCoin = ISTextEntryBox:new("0", x+30, 68, 100, 20);
    self.specialCoin.font = UIFont.Medium
	self.specialCoin:initialise();
	self.specialCoin:instantiate();
    self.specialCoin.onTextChange = SetPriceUI.onSpecialCoinChange
	self.specialCoin:setOnlyNumbers(true);
	self:addChild(self.specialCoin);

    self.setButton = ISButton:new(x+40, 110, 60,25,"Set",self, SetPriceUI.setButton);
    self.setButton:initialise()
    self.setButton.enable = true
    self:addChild(self.setButton);

    if not Currency.UseSpecialCoin then
        self.specialCoin:setVisible(false)
        self.specialCoinTex:setVisible(false)
    end
end

function SetPriceUI:setButton()
    local coin = tonumber(self.coin:getInternalText())
    local specialCoin = tonumber(self.specialCoin:getInternalText())
    if not coin or not specialCoin then return end
    if coin < 0 or specialCoin < 0 then return end
    local price = coin
    local isSpecialCoin = false
    if specialCoin > coin then
        price = specialCoin
        isSpecialCoin = true
    end
    for k,v in pairs(self.items) do
        if price == 0 then
            price = nil
            isSpecialCoin = nil
        end
        v:getModData().price = price
        v:getModData().specialCoin = isSpecialCoin
    end
    self:close()
end

function SetPriceUI:close()
	ISCollapsableWindow.close(self);
    SetPriceUI.instance:removeFromUIManager()
    SetPriceUI.instance = nil
    self:removeFromUIManager()
end

function SetPriceUI:new(x, y, width, height, player,items)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.title = UIText.SetPricePlayerShop;
    o.player = player
    o.items = items
    o.resizable = false;
    return o
end