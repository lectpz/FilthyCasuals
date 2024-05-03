local Nfunction = require "Nfunction"
PlayerShopUI = ISCollapsableWindow:derive("PlayerShopUI");
PlayerShopUI.instance = nil;
PlayerShopUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
PlayerShopUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
PlayerShopUI.removeButtonX = 380
PlayerShopUI.previewButtonX = PlayerShopUI.removeButtonX + 25
PlayerShopUI.shopItemsCache = {}
PlayerShopUI.total = 0
PlayerShopUI.totalSpecial = 0
PlayerShopUI.actionInProgress = false
PlayerShopUI.cvUis = {}

local removeBtn = Shop.textures.RemoveButton;
local previewBtn = Shop.textures.PreviewButton;
local cartImg = Shop.textures.Cart;
local browseBtn = Shop.textures.Browse;
local width = 995
local height = 550
local posX = 0
local posY = 0

function PlayerShopUI:show(player,shop)
    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if PlayerShopUI.instance==nil then
        local shopOwner = shop:getModData().owner
        PlayerShopUI.instance = PlayerShopUI:new (0, 0, width, height, player,shopOwner);
        PlayerShopUI.instance.shop = shop
        PlayerShopUI.instance.shopOwner = shopOwner
        PlayerShopUI.instance:initialise();
        PlayerShopUI.instance:instantiate();
    end
    PlayerShopUI.instance.pinButton:setVisible(false)
    PlayerShopUI.instance.collapseButton:setVisible(false)
    PlayerShopUI.instance:addToUIManager();
    PlayerShopUI.instance:setVisible(true);
    PlayerShop.toggleBusy(shop,player:getUsername(),true)
    return PlayerShopUI.instance;
end

function PlayerShopUI:update()
    local player = self.player
	if player:DistTo(posX, posY) > 2 then
		self:close()
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
        self.cancelBuyButton.enable = true
        self.cancelBuyButton:setVisible(true)
        return 
    end
    self:updateTotal()
end

function PlayerShopUI:doDrawCartItem(y, item, alt)
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

    self:drawText(item.item.name, 40, y + 10, 1, 1, 1, a, UIFont.Small);
    if item.item.price then
        local coinImg = Currency.CoinsTexture.Coin
        if item.item.specialCoin then coinImg = Currency.CoinsTexture.SpecialCoin end
        self:drawTextureScaledAspect(coinImg.texture, 300, y + 10, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
        local priceFormatted = Currency.format(item.item.price)
        self:drawText(""..priceFormatted, 320, y + 8, 1, 1, 1, a, UIFont.Small);
    end

    if item.item.invItem then
        self:drawTextureScaledAspect(item.item.invItem:getTex(), 6, y+5, 30, 30, 1, 1, 1, 1)
        if item.item.invItem:IsInventoryContainer() then
            self:drawTextureScaledAspect(browseBtn.texture, self.parent.previewButtonX, y + 10, browseBtn.scale, browseBtn.scale, 1, 1, 1, 1)
        end
    end

    self:drawTextureScaledAspect(removeBtn.texture, self.parent.removeButtonX, y + 10, removeBtn.scale, removeBtn.scale, 1, 1, 1, 1)

    if item.item.VehicleID then
        self:drawTextureScaledAspect(previewBtn.texture, self.parent.previewButtonX, y + 10, previewBtn.scale, previewBtn.scale, 1, 1, 1, 1)
    end

    return y + item.height;
end

function PlayerShopUI:onMouseMove(dx, dy)
    self.mouseOver = true;
	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end
    if PlayerShopUI.instance.panel.activeView.view.shopItems:isMouseOver() then return end
    if PlayerShopUI.instance.cartItems:isMouseOver() then return end
    PlayerShopUI.instance:toggleTooltip(false)
end

function PlayerShopUI:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self,x, y)
    if PreviewUI.instance then PreviewUI.instance:close() end
end

function PlayerShopUI:onMouseDownCartItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
    if PreviewUI.instance then PreviewUI.instance:close() end
    if ContainerViewerUI.instance then ContainerViewerUI.instance:close() end
	if self.selectedRow then
        local selectedRow = self.items[self.selectedRow]
        if not selectedRow then return end
        if self.previewBtn then
            if selectedRow.item.invItem:IsInventoryContainer() then
                ContainerViewerUI:show(selectedRow.item.invItem)
                return
            end
            if not selectedRow.item.VehicleID then return end
            PreviewUI:show(selectedRow.item.name,selectedRow.item.VehicleID)
            return
        end
        if self.removeBtn then
		    PlayerShopUI.instance:removeFromCart(selectedRow)
        end
    end
end

local currentTooltip = nil
function PlayerShopUI:toggleTooltip(show,item)
    if item then
        if not currentTooltip then
            currentTooltip = ISToolTipInv:new(item.invItem)
            currentTooltip:initialise();
        else
            currentTooltip:addToUIManager()
            currentTooltip:setItem(item.invItem)
            currentTooltip:setVisible(true)
            currentTooltip:setOwner(self)
            currentTooltip:render();
        end
    end
    if not show and currentTooltip then
        currentTooltip:removeFromUIManager()
        currentTooltip:setVisible(false)
    end
end

function PlayerShopUI:onMouseMoveCartItem(dx, dy)
    local list = PlayerShopUI.instance.cartItems
    if not list then return end
    list.selectedRow = nil
    list.previewBtn = nil
    list.removeBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then PlayerShopUI.instance:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then PlayerShopUI.instance:toggleTooltip(false)  return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then PlayerShopUI.instance:toggleTooltip(false) return end
    local mouseX = self:getMouseX()
    list.selectedRow = rowIndex
    if mouseX > self.parent.removeButtonX then
        list.removeBtn = true
    end
    if mouseX > self.parent.previewButtonX then
        list.previewBtn = true
    end
    if not selectedRow.item then PlayerShopUI.instance:toggleTooltip(false) return end
    PlayerShopUI.instance:toggleTooltip(true,selectedRow.item)
end

function PlayerShopUI:createCategories()
    for k,v in pairs(PlayerShop.Tabs) do 
        local tab = PlayerShopTabUI:new(0, 0, self.width, self.panel.height - self.panel.tabHeight);
        tab:initialise();
        tab:setAnchorRight(true)
        tab:setAnchorBottom(true)
        tab:setShopUI(PlayerShopUI.instance)
        tab:setCategoryType(k)
        self.panel:addView(v, tab);
        tab.parent = self;
    end
end

function PlayerShopUI:onActivateView()
    local tabType = self.panel.activeView.view.tabType
    local shopItems = self.panel.activeView.view.shopItems
    local items = self.shop:getContainer():getItems()
    shopItems:clear()
    if self.cartItems then
        self.cartItems:clear()
    end
    for i=0, items:size() - 1 do
        local item = items:get(i)
        local v = {}
        local modData = item:getModData()
        local VehicleID = modData.VehicleID
        if modData.price then
            if VehicleID then v.VehicleID = VehicleID end
            v.type = item:getFullType()
            v.price = modData.price
            v.specialCoin = modData.specialCoin
            v.name = Nfunction.trimString(item:getName(),42)
            v.invItem = item
            shopItems:addItem(v.type,v);
        end
    end
    self.shopItemsCache[tabType] = shopItems.items
end

function PlayerShopUI:createChildren()
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

    self.clearCartButton = ISButton:new((self.width / 2)+380, y+280, 80,25,UIText.ClearCart,self, PlayerShopUI.clearCartBtn);
    self.clearCartButton:initialise()
    self:addChild(self.clearCartButton);

    self.buyCartButton = ISButton:new((self.width / 2)+200, y+350, 80,25,UIText.BuyCart,self, PlayerShopUI.buyCartBtn);
    self.buyCartButton:initialise()
    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(true)
    self:addChild(self.buyCartButton);

    self.cancelBuyButton = ISButton:new((self.width / 2)+200, y+350, 80,25,UIText.Cancel,self, PlayerShopUI.cancelBuyBtn);
    self.cancelBuyButton:initialise()
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    self:addChild(self.cancelBuyButton);

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
    self.cartItems.doDrawItem = PlayerShopUI.doDrawCartItem;
    self.cartItems.onMouseMove = PlayerShopUI.onMouseMoveCartItem;
    self.cartItems.onMouseDown = PlayerShopUI.onMouseDownCartItem;
    self:addChild(self.cartItems);

    self.balanceLabel = ISLabel:new(x+490, 20, PlayerShopUI.SMALL_FONT_HGT, UIText.Balance, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceLabel);

    local coinImg = Currency.CoinsTexture.Coin
    self.balanceCoinTex = ISImage:new(x+550, 20, 0, 0, coinImg.texture);
    self.balanceCoinTex.scaledWidth = coinImg.scale+5
    self.balanceCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceCoinTex);

    self.balanceCoinLabel = ISLabel:new(x+575, 20, PlayerShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceCoinLabel);

    self.coinTex = ISImage:new(x+535, y+280, 0, 0, coinImg.texture);
    self.coinTex.scaledWidth = coinImg.scale+5
    self.coinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.coinTex);

    self.totalLabel = ISLabel:new(x+490, y+280, PlayerShopUI.SMALL_FONT_HGT, UIText.Total, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalLabel);

    self.totalCoinLabel = ISLabel:new(x+560, y+280, PlayerShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalCoinLabel);

    coinImg = Currency.CoinsTexture.SpecialCoin
    self.balanceSpecialCoinTex = ISImage:new(x+550, 45, 0, 0, coinImg.texture);
    self.balanceSpecialCoinTex.scaledWidth = coinImg.scale+5
    self.balanceSpecialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceSpecialCoinTex);

    self.balanceSpecialCoinLabel = ISLabel:new(x+575, 45, PlayerShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceSpecialCoinLabel);

    self.specialCoinTex = ISImage:new(x+535, y+305, 0, 0, coinImg.texture);
    self.specialCoinTex.scaledWidth = coinImg.scale+5
    self.specialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.specialCoinTex);

    self.totalSpecialCoinLabel = ISLabel:new(x+560, y+305, PlayerShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalSpecialCoinLabel);

    if not Currency.UseSpecialCoin then
        self.balanceSpecialCoinTex:setVisible(false)
        self.balanceSpecialCoinLabel:setVisible(false)
        self.specialCoinTex:setVisible(false)
        self.totalSpecialCoinLabel:setVisible(false)
    end
    self:checkShopOwner()
end

function PlayerShopUI:activateFirstTab()
    for k,v in pairs(PlayerShop.Tabs) do 
        self.panel:activateView(v)
        break;
    end
end

function PlayerShopUI:removeFromCart(selectedRow)
    if self.actionInProgress then return end
    self:toggleTooltip(false)
    local tab = self.panel.activeView.view
    tab.shopItems:addItem(selectedRow.item.type,selectedRow.item)
    self.cartItems:removeItem(selectedRow.text)
end

function PlayerShopUI:clearCartBtn()
    if self.actionInProgress then return end
    local tab = self.panel.activeView.view
    self.cartItems:clear()
    self:activateFirstTab()
end

function PlayerShopUI:cancelBuyBtn()
    self.buyCartButton.enable = true
    self.buyCartButton:setVisible(true)
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "PlayerShopBuyAction") then return end
    currentAction.action:forceStop()
end

function PlayerShopUI:buyCartBtn()

    local shop = PlayerShopUI.instance.shop
    local username = self.player:getUsername()
    if not PlayerShop.isBlockByUser(shop,username) then
        self:close()
    end

    self.actionInProgress = true
    local ticket = {}
    ticket.coin = self.total
    ticket.specialCoin = self.totalSpecial
    local action = PlayerShopBuyAction:new(self.player,self,ticket);
    ISTimedActionQueue.add(action);
    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(false)
    self.cancelBuyButton.enable = true
    self.cancelBuyButton:setVisible(true)
end

function PlayerShopUI:render()
    ISCollapsableWindow.render(self);
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then self.actionInProgress = false return end
    if not (currentAction.Type == "PlayerShopBuyAction") then self.actionInProgress = false return end
    self:drawProgressBar((self.width / 2)+180, 420, 120, 10, currentAction.action:getJobDelta(), self.fgBar)
end

function PlayerShopUI:updateTotal()
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

    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(true)
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    self.total = total
    self.totalSpecial = totalSpecial
    self:checkShopOwner()
    if total == 0 and totalSpecial == 0 then return end

    local username = self.player:getUsername()
    local coin,specialCoin = Balance.getUserBalance(username)
    if coin >= total and specialCoin >= totalSpecial then
        self.buyCartButton.enable = true
        self.buyCartButton:setVisible(true)
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
    end
    self:checkShopOwner()
end

function PlayerShopUI:checkShopOwner()
    if not PlayerShopUI.instance then
        return
    end
    local shopOwner = PlayerShopUI.instance.shopOwner
    local playerName = self.player:getUsername()
    if shopOwner == playerName then
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(false)
    end
end

function PlayerShopUI:close()
	ISCollapsableWindow.close(self);
    local shop = PlayerShopUI.instance.shop
    local username = self.player:getUsername()
    if PlayerShop.isBlockByUser(shop,username) then
        PlayerShop.toggleBusy(shop,username,false)
    end
    if PreviewUI.instance then PreviewUI.instance:close() end
    if ContainerViewerUI.instance then ContainerViewerUI.instance:close() end
    for k,v in pairs(PlayerShopUI.cvUis) do
        if v then
            v:close()
        end
    end
    PlayerShopUI.cvUis = {}
    PlayerShopUI.instance:removeFromUIManager()
    PlayerShopUI.instance = nil
    self:removeFromUIManager()
end

function PlayerShopUI:new(x, y, width, height, player,shopOwner)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    local shopTitle = getText("IGUI_TitlePlayerShop",shopOwner)
    o.title = shopTitle
    o.player = player
    o.resizable = false;
    return o
end