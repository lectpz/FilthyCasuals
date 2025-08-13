local fontConfig = {
    Small   = {y=17,iconY=1},
    Medium  = {y=20,iconY=3},
    Large   = {y=20,iconY=4},
}

local function injectTooltip(self)
    local item = self.item
    local belongsTo =  item:getModData().belongsTo
    local price = item:getModData().price
    if not (price or belongsTo) then return end
    local isSpecialCoin = item:getModData().specialCoin
    local fontSize = getCore():getOptionTooltipFont();
    local th = self.tooltip:getHeight();
    local height = fontConfig[fontSize].y
    local coinImg = Currency.CoinsTexture.Coin
    local x = 15
    local y = -20
    if price then
        if PlayerShopUI.instance then return end
        self:setY(self.tooltip:getY()-25);
        self:setHeight(height);
        self:drawRect(0, 0, self.width, self.height+10, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
        self:drawRectBorder(0, 0, self.width, self.height+10, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
        if isSpecialCoin then coinImg = Currency.CoinsTexture.SpecialCoin end
        self.tooltip:DrawTextureScaledAspect(coinImg.texture, x-10, y+fontConfig[fontSize].iconY, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
        price = Currency.format(price)
        self.tooltip:DrawText(self.tooltip:getFont(),""..price, x+10, y-fontConfig[fontSize].iconY, 1,1,1,1);
        self:setY(self.tooltip:getY());
    end
    if not belongsTo then return end
    y = th+5
    local player = getPlayer()
    local username = player:getUsername()
    local account = Balance.getUserAccount(username)
    if not account then return end
    local renderBalance = true
    local rows = 3
    if not Currency.UseSpecialCoin then
        rows = 2
    end
    if not (account.linkedTo == item:getModData().linkedTo) then 
        rows = 1
        renderBalance = false
    end

    fontSize = getCore():getOptionTooltipFont();
    th = self.tooltip:getHeight();
    height = fontConfig[fontSize].y*rows

    self:setY(self.tooltip:getY()+th);
    self:setHeight(height);
    self:drawRect(0, 0, self.width, self.height+10, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height+10, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    local wallet = Currency.WalletTexture.Account
    self.tooltip:DrawTextureScaledAspect(wallet.texture, x-10, y+fontConfig[fontSize].iconY, wallet.scale, wallet.scale, 1, 1, 1, 1)
    self.tooltip:DrawText(self.tooltip:getFont(),belongsTo, x+10, y, 1,1,0.8,self.borderColor.a);

    if not renderBalance then return end
    local coin = account.coin
    y=y+fontConfig[fontSize].y
    coinImg = Currency.CoinsTexture.Coin
    self.tooltip:DrawTextureScaledAspect(coinImg.texture, x-10, y+fontConfig[fontSize].iconY, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
    local coinFormatted = Currency.format(coin)
    self.tooltip:DrawText(self.tooltip:getFont(),""..coinFormatted, x+10, y, 1,1,1,1);
    y=y+fontConfig[fontSize].y
    coinImg = Currency.CoinsTexture.SpecialCoin
    if Currency.UseSpecialCoin then
        local specialCoin = account.specialCoin
        local specialCoinFormatted = Currency.format(specialCoin)
        self.tooltip:DrawTextureScaledAspect(coinImg.texture, x-10, y+fontConfig[fontSize].iconY, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
        self.tooltip:DrawText(self.tooltip:getFont(),""..specialCoinFormatted, x+10, y, 1,1,1,1);
    end
end

local oldRender = ISToolTipInv.render
function ISToolTipInv:render()
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        injectTooltip(self)
        oldRender(self)
    end
end