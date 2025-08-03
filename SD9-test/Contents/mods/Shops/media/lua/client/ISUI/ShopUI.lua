local Nfunction = require "Nfunction"
ShopUI = ISCollapsableWindow:derive("ShopUI");
ShopUI.instance = nil;
ShopUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
ShopUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
ShopUI.removeButtonX = 380
ShopUI.previewButtonX = ShopUI.removeButtonX + 25
ShopUI.shopItemsCache = {}
ShopUI.total = 0
ShopUI.totalSpecial = 0
ShopUI.actionInProgress = false
ShopUI.reloadItems = false
ShopUI.lastTab = "none"
ShopUI.ItemInstanceCache = {}
local posX = 0
local posY = 0

local removeBtn = Shop.textures.RemoveButton;
local previewBtn = Shop.textures.PreviewButton;
local cartImg = Shop.textures.Cart;
local width = 995
local height = 550

function ShopUI:show(player,viewMode,shop)
    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if ShopUI.instance==nil then
        ShopUI.instance = ShopUI:new (0, 0, width, height, player);
        ShopUI.instance.shop = shop
        ShopUI.instance.viewMode = viewMode
        ShopUI.instance:initialise();
        ShopUI.instance:instantiate();
    end
    ShopUI.instance.pinButton:setVisible(false)
    ShopUI.instance.collapseButton:setVisible(false)
    ShopUI.instance:addToUIManager();
    ShopUI.instance:setVisible(true);
    return ShopUI.instance;
end

function ShopUI:update()
    if not self.viewMode then
        local player = self.player
        if player:DistTo(posX, posY) > 2 then
            self:close()
        end
    end
    local username = self.player:getUsername()    
    local coin,specialCoin = Balance.getUserBalance(username)
    local coinFormatted = Currency.format(coin)
    self.balanceCoinLabel:setName(""..coinFormatted)
    local specialCoinFormatted = Currency.format(specialCoin)
    self.balanceSpecialCoinLabel:setName(""..specialCoinFormatted)
    if self.actionInProgress then 
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(false)
        self.sellCartButton.enable = false
        self.sellCartButton:setVisible(false)
        self.cancelBuyButton.enable = true
        self.cancelBuyButton:setVisible(true)
        return 
    end
    self:updateTotal()
end

function ShopUI:doDrawCartItem(y, item, alt)
    local baseItemDY = 0
    if item.item.name then
        baseItemDY = self.SMALL_FONT_HGT
        item.height = self.itemheight + baseItemDY
    end

    if y + self:getYScroll() >= self.height then return y + item.height end
    if y + item.height + self:getYScroll() <= 0 then return y + item.height end

    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), item.height - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15);
    end

    local quantity = ""
    if item.item.quantity then
        quantity = " ("..item.item.quantity..")"
    end
    self:drawText(item.item.name..quantity, 40, y + 10, 1, 1, 1, a, UIFont.Small);
    if item.item.price then
        local coinImg = Currency.CoinsTexture.Coin
        if item.item.specialCoin then coinImg = Currency.CoinsTexture.SpecialCoin end
        self:drawTextureScaledAspect(coinImg.texture, 300, y + 10, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
        local priceFormatted = Currency.format(item.item.price)
        self:drawText(""..priceFormatted, 320, y + 8, 1, 1, 1, a, UIFont.Small);
    end

    if item.item.invItem or item.item.texture then
        local texture = item.item.texture
        if not texture then
            texture = item.item.invItem:getTex()
        end
        self:drawTextureScaledAspect(texture, 6, y+5, 30, 30, 1, 1, 1, 1)
    end

    self:drawTextureScaledAspect(removeBtn.texture, self.parent.removeButtonX, y + 10, removeBtn.scale, removeBtn.scale, 1, 1, 1, 1)

    if item.item.VehicleID then
        self:drawTextureScaledAspect(previewBtn.texture, self.parent.previewButtonX, y + 10, previewBtn.scale, previewBtn.scale, 1, 1, 1, 1)
    end

    return y + item.height;
end

function ShopUI:onMouseMove(dx, dy)
    self.mouseOver = true;
	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end
    if ShopUI.instance.panel.activeView.view.shopItems:isMouseOver() then return end
    if ShopUI.instance.cartItems:isMouseOver() then return end
    ShopUI.instance:toggleTooltip(false)
end

function ShopUI:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self,x, y)
    if PreviewUI.instance then PreviewUI.instance:close() end
end

function ShopUI:onMouseDownCartItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
    if PreviewUI.instance then PreviewUI.instance:close() end
	if self.selectedRow then
        local selectedRow = self.items[self.selectedRow]
        if not selectedRow then return end
        if self.previewBtn then
            if not selectedRow.item.VehicleID then return end
            PreviewUI:show(selectedRow.item.name,selectedRow.item.VehicleID)
            return
        end
        if self.removeBtn then
		    ShopUI.instance:removeFromCart(selectedRow)
        end
    end
end

local currentTooltip = nil
local invTooltip = nil
local itemPackTooltip = nil
function ShopUI:toggleTooltip(show,item)
    if item then
        if item.invItem then
            if not invTooltip then
                invTooltip = ISToolTipInv:new(item.invItem)
            end
            currentTooltip = invTooltip
            item = item.invItem
            if itemPackTooltip then
                itemPackTooltip:removeFromUIManager()
                itemPackTooltip:setVisible(false)
            end
        else
            if not itemPackTooltip then
                itemPackTooltip = ShopUITooltip:new();
            end
            if invTooltip then
                invTooltip:removeFromUIManager()
                invTooltip:setVisible(false)
            end
            currentTooltip = itemPackTooltip
        end
        currentTooltip:initialise();
        currentTooltip:addToUIManager()
        currentTooltip:setItem(item);
        currentTooltip:setOwner(self)
        currentTooltip:render();
        currentTooltip:setVisible(true)  
    end
    if not show and currentTooltip then
        currentTooltip:removeFromUIManager()
        currentTooltip:setVisible(false)
    end
end

function ShopUI:onMouseMoveCartItem(dx, dy)
    local list = ShopUI.instance.cartItems
    if not list then return end
    list.selectedRow = nil
    list.previewBtn = nil
    list.removeBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then ShopUI.instance:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then ShopUI.instance:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then ShopUI.instance:toggleTooltip(false) return end
    local mouseX = self:getMouseX()
    list.selectedRow = rowIndex
    if mouseX > self.parent.removeButtonX then
        list.removeBtn = true
    end
    if mouseX > self.parent.previewButtonX then
        list.previewBtn = true
    end
    if not selectedRow.item.items then ShopUI.instance:toggleTooltip(false) return end
    ShopUI.instance:toggleTooltip(true,selectedRow.item)
end

function ShopUI:createCategories()
    for k,v in pairs(Shop.Tabs) do 
        local tab = ShopTabUI:new(0, 0, self.width, self.panel.height - self.panel.tabHeight);
        tab:initialise();
        tab:setAnchorRight(true)
        tab:setAnchorBottom(true)
        tab:setShopUI(ShopUI.instance)
        tab:setCategoryType(k)
        self.panel:addView(v, tab);
        tab.parent = self;
    end
end

function ShopUI:getItemInstance(type)
    local item = self.ItemInstanceCache[type]
    if not item then
        item = InventoryItemFactory.CreateItem(type)
        if item then
            self.ItemInstanceCache[type] = item
        end
    end
    return item
end

function ShopUI:onActivateView()
    local character = self.player
    if not character:getModData().shopFavorites then
        character:getModData().shopFavorites = {}
    end
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    local shopItems = tab.shopItems

    if self.reloadItems then
        shopItems:clear() 
    end

    if self.lastTab == Tab.Sell or tabType == Tab.Sell then
        self.cartItems:clear()
    end
    self.lastTab = tabType

    if tabType == Tab.Sell then
        tab.moveAllButton.enable = true
        tab.moveAllButton:setVisible(true)
        shopItems:clear()
        if not self.viewMode then
            self.sellCartButton.enable = false
            self.sellCartButton:setVisible(true)
            self.buyCartButton.enable = false
            self.buyCartButton:setVisible(false)
        end
        local inventory = character:getInventory():getItems()
        for i = 0, inventory:size() -1 do
            local item = inventory:get(i)
            local itemType = item:getFullType()
            local itemSell = Shop.Sell[itemType]
            local isBroken = item:isBroken()
            if not (Shop.SellisBlacklist and itemSell) then
                if not (item:isEquipped() or item:isFavorite() or Currency.Coins[itemType]) then
                    if not (itemSell and itemSell.blacklisted) then
                        local v = {}
                        v.type = itemType
                        local price = Shop.defaultPrice
                        if isBroken then price = Shop.defaultPriceBroken end
                        if itemSell then
                            v.specialCoin = itemSell.specialCoin
                            if isBroken then
                                price = itemSell.priceBroken or Shop.defaultPriceBroken
                            else
                                price = itemSell.price or Shop.defaultPrice
                            end
                        end
                        v.priceFull = price
                        price = Nfunction.drainablePrice(item,price)
                        v.price = price
                        v.id = item:getID()
                        v.name = Nfunction.trimString(item:getName(),42)
                        v.invItem = item
                        if price > 0 then
                            if Shop.SellisWhitelist then 
                                if itemSell then
                                    shopItems:addItem(itemType,v);
                                end
                            else
                                shopItems:addItem(itemType,v);
                            end
                        end
                    end
                end
            end
        end
        return
    else
        if self.sellCartButton then
            self.sellCartButton.enable = false
            self.sellCartButton:setVisible(false)
            self.buyCartButton:setVisible(true)
        end
    end

    if tabType == Tab.Favorite then
        shopItems:clear()
        local shopFavorites = character:getModData().shopFavorites
        for k,v in pairs(shopFavorites) do
            local shopItemDef = Shop.Items[k]
            local item = self:getItemInstance(k)
            if shopItemDef then
                v.price = shopItemDef.price
            end
            if item then
                local VehicleID = item:getModData().VehicleID
                if VehicleID then v.VehicleID = VehicleID end
                v.favorite = true
                v.type = k
                if not v.items then
                    v.invItem = item
                else
                    v.texture = item:getTex()
                end
                v.name = Nfunction.trimString(item:getName(),42)
                shopItems:addItem(k,v);
            else
                character:getModData().shopFavorites[k] = nil
            end
        end
        self.shopItemsCache[tabType] = shopItems.items
        return  
    end

    if shopItems.count > 0 then return end

    if not self.reloadItems then
        if self.shopItemsCache[tabType] then shopItems.items = self.shopItemsCache[tabType] return end
    end
    
    for k,v in pairs(Shop.Items) do
        if v and (v.tab == tabType or tabType == Tab.All) then 
            local item = self:getItemInstance(k)
            if item then
                local VehicleID = item:getModData().VehicleID
                if VehicleID then v.VehicleID = VehicleID end
                v.favorite = character:getModData().shopFavorites[k]
                v.type = k
                if not v.items then
                    v.invItem = item
                else
                    v.texture = item:getTex()
                end
                v.name = Nfunction.trimString(item:getName(),42)
                shopItems:addItem(k,v);
            end
        end
    end
    self.shopItemsCache[tabType] = shopItems.items
    self.reloadItems = false 
end

function ShopUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 30
    local y = 85

    local th = self:titleBarHeight();
    self.panel = ISTabPanel:new(0, th, (self.width/2)-25, self.height-10);
    self.panel:initialise();
    self.panel:setAnchorRight(true)
    self.panel:setAnchorBottom(true)
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0};
    self.panel.onActivateView = self.onActivateView;
    self.panel.target = self;
    self.panel:setEqualTabWidth(false)
    self:addChild(self.panel);
    self:createCategories()
    self:activateFirstTab()

    self.clearCartButton = ISButton:new((self.width / 2)+380, y+280, 80,25,UIText.ClearCart,self, ShopUI.clearCartBtn);
    self.clearCartButton:initialise()
    self:addChild(self.clearCartButton);

    if not self.viewMode then 
        self.buyCartButton = ISButton:new((self.width / 2)+200, y+350, 80,25,UIText.BuyCart,self, ShopUI.buyCartBtn);
        self.buyCartButton:initialise()
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(true)
        self:addChild(self.buyCartButton);

        self.sellCartButton = ISButton:new((self.width / 2)+200, y+350, 80,25,UIText.Sell,self, ShopUI.sellCartBtn);
        self.sellCartButton:initialise()
        self.sellCartButton.enable = false
        self.sellCartButton:setVisible(false)
        self:addChild(self.sellCartButton);

        self.cancelBuyButton = ISButton:new((self.width / 2)+200, y+350, 80,25,UIText.Cancel,self, ShopUI.cancelBuyBtn);
        self.cancelBuyButton:initialise()
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
        self:addChild(self.cancelBuyButton);
    else
        self.balanceLabel = ISLabel:new((self.width / 2)+150, y+350, ShopUI.SMALL_FONT_HGT, UIText.ShopViewOnly, 1, 1, 1, 1, UIFont.Medium, true)
        self:addChild(self.balanceLabel);
    end

    self.cartTex = ISImage:new(x+905, y-35, 0, 0, cartImg.texture);
    self.cartTex.scaledWidth = cartImg.scale
    self.cartTex.scaledHeight = cartImg.scale
    self:addChild(self.cartTex);

    self.cartItems = ISScrollingListBox:new(x+490, y, (self.width / 3) + 110, self.height/2);
    self.cartItems:initialise();
    self.cartItems:instantiate();
    self.cartItems:setAnchorRight(false)
    self.cartItems:setAnchorBottom(true)
    self.cartItems.font = UIFont.NewSmall;
    self.cartItems.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.cartItems.selected = 1;
    self.cartItems.joypadParent = self;
    self.cartItems.drawBorder = false;
    self.cartItems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.cartItems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self.cartItems.doDrawItem = ShopUI.doDrawCartItem;
    self.cartItems.onMouseMove = ShopUI.onMouseMoveCartItem;
    self.cartItems.onMouseDown = ShopUI.onMouseDownCartItem;
    self:addChild(self.cartItems);

    self.balanceLabel = ISLabel:new(x+490, 20, ShopUI.SMALL_FONT_HGT, UIText.Balance, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceLabel);

    local coinImg = Currency.CoinsTexture.Coin
    self.balanceCoinTex = ISImage:new(x+550, 20, 0, 0, coinImg.texture);
    self.balanceCoinTex.scaledWidth = coinImg.scale+5
    self.balanceCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceCoinTex);

    self.balanceCoinLabel = ISLabel:new(x+575, 20, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceCoinLabel);

    self.coinTex = ISImage:new(x+535, y+280, 0, 0, coinImg.texture);
    self.coinTex.scaledWidth = coinImg.scale+5
    self.coinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.coinTex);

    self.totalLabel = ISLabel:new(x+490, y+280, ShopUI.SMALL_FONT_HGT, UIText.Total, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalLabel);

    self.totalCoinLabel = ISLabel:new(x+560, y+280, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalCoinLabel);

    coinImg = Currency.CoinsTexture.SpecialCoin
    self.balanceSpecialCoinTex = ISImage:new(x+550, 45, 0, 0, coinImg.texture);
    self.balanceSpecialCoinTex.scaledWidth = coinImg.scale+5
    self.balanceSpecialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceSpecialCoinTex);

    self.balanceSpecialCoinLabel = ISLabel:new(x+575, 45, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceSpecialCoinLabel);

    self.specialCoinTex = ISImage:new(x+535, y+305, 0, 0, coinImg.texture);
    self.specialCoinTex.scaledWidth = coinImg.scale+5
    self.specialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.specialCoinTex);

    self.totalSpecialCoinLabel = ISLabel:new(x+560, y+305, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalSpecialCoinLabel);

    if not Currency.UseSpecialCoin then
        self.balanceSpecialCoinTex:setVisible(false)
        self.balanceSpecialCoinLabel:setVisible(false)
        self.specialCoinTex:setVisible(false)
        self.totalSpecialCoinLabel:setVisible(false)
    end
end

function ShopUI:activateFirstTab()
    for k,v in pairs(Shop.Tabs) do 
        self.panel:activateView(v)
        break;
    end
end

function ShopUI:removeFromCart(selectedRow)
    if self.actionInProgress then return end
    self:toggleTooltip(false)
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    if tabType == Tab.Sell then
        tab.shopItems:addItem(selectedRow.item.type,selectedRow.item)
    end
    self.cartItems:removeItem(selectedRow.text)
end

function ShopUI:clearCartBtn()
    if self.actionInProgress then return end
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    if tabType == Tab.Sell then
        for k,v in pairs(self.cartItems.items) do
            tab.shopItems:addItem(v.item.type,v.item)
        end
    end
    self.cartItems:clear()
end

function ShopUI:cancelBuyBtn()
    local tabType = self.panel.activeView.view.tabType
    if tabType == Tab.Sell then 
        self.sellCartButton.enable = true
        self.sellCartButton:setVisible(true)
    else
        self.buyCartButton.enable = true
        self.buyCartButton:setVisible(true)
    end
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "ShopBuyAction" or currentAction.Type == "ShopSellAction") then return end
    currentAction.action:forceStop()
end

function ShopUI:buyCartBtn()
    self.actionInProgress = true
    local ticket = {}
    ticket.coin = self.total
    ticket.specialCoin = self.totalSpecial
    local action = ShopBuyAction:new(self.player,self,ticket);
    ISTimedActionQueue.add(action);
    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(false)
    self.cancelBuyButton.enable = true
    self.cancelBuyButton:setVisible(true)
end

function ShopUI:sellCartBtn()
    self.actionInProgress = true
    local action = ShopSellAction:new(self.player,self);
    ISTimedActionQueue.add(action);
    self.sellCartButton.enable = false
    self.sellCartButton:setVisible(false)
    self.cancelBuyButton.enable = true
    self.cancelBuyButton:setVisible(true)
end

function ShopUI:render()
    ISCollapsableWindow.render(self);
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then self.actionInProgress = false return end
    if not (currentAction.Type == "ShopBuyAction" or currentAction.Type == "ShopSellAction") then self.actionInProgress = false return end
    self:drawProgressBar((self.width / 2)+180, 420, 120, 10, currentAction.action:getJobDelta(), self.fgBar)
end

function ShopUI:updateTotal()
    local total = 0
    local totalSpecial = 0
    self.totalCoinLabel:setName(""..total)
    self.totalSpecialCoinLabel:setName(""..totalSpecial)
    for k,v in pairs(self.cartItems.items) do
        local cost = v.item.price
        if not v.item.specialCoin then
            total = total + cost
        else
            totalSpecial = totalSpecial + cost
        end
    end
    if total > 0 then
        local totalFormat = Currency.format(total)
        self.totalCoinLabel:setName(""..totalFormat)
    end
    if totalSpecial > 0 then
        local totalSpecialFormat = Currency.format(totalSpecial)
        self.totalSpecialCoinLabel:setName(""..totalSpecialFormat)
    end
    if self.viewMode then return end

    local tabType = self.panel.activeView.view.tabType
    if tabType == Tab.Sell then
        self.sellCartButton.enable = false
        self.sellCartButton:setVisible(true)
    else
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(true)
    end
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    self.total = total
    self.totalSpecial = totalSpecial
    if total == 0 and totalSpecial == 0 then return end

    local username = self.player:getUsername()
    local coin,specialCoin = Balance.getUserBalance(username)
    if tabType == Tab.Sell and (total > 0 or totalSpecial > 0) then 
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(false)
        self.sellCartButton.enable = true
        self.sellCartButton:setVisible(true)
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
        return
    end
    if coin >= total and specialCoin >= totalSpecial and not (tabType==Tab.Sell) then
        self.buyCartButton.enable = true
        self.buyCartButton:setVisible(true)
        self.sellCartButton.enable = false
        self.sellCartButton:setVisible(false)
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
    end
end

function ShopUI:close()
	ISCollapsableWindow.close(self);
    if PreviewUI.instance then PreviewUI.instance:close() end
    ShopUI.instance:removeFromUIManager()
    ShopUI.instance = nil
    self:removeFromUIManager()
end

function ShopUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.title = UIText.ShopUITitle;
    o.player = player
    o.resizable = false;
    return o
end