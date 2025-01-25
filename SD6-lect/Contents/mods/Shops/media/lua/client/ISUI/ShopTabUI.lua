ShopTabUI = ISPanelJoypad:derive("ShopTabUI");
ShopTabUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
ShopTabUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
ShopTabUI.addButtonX = 380
ShopTabUI.previewButtonX = ShopTabUI.addButtonX + 25
ShopTabUI.favoriteButtonX = ShopTabUI.addButtonX - 20

local addBtn = Shop.textures.AddButton;
local previewBtn = Shop.textures.PreviewButton;

function ShopTabUI:initialise()
    ISPanelJoypad.initialise(self);
    self:create();
end

function ShopTabUI:setShopUI(instance)
    self.ShopUI = instance
end

function ShopTabUI:onFilterChange()
    self.parent:filter()
end

function ShopTabUI:setCategoryType(tabType)
    self.tabType = tabType
end

function ShopTabUI:doDrawShopItem(y, item, alt)
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
    
    if not (self.parent.tabType == Tab.Sell) then 
        local alpha = 0.3
        local favTexture = nil
        if item.index == self.selectedRow and not self:isMouseOverScrollBar() and self:isMouseOver() then
            local mouseX = self:getMouseX()
            favTexture = self.parent.favNotCheckedTex
            if mouseX > self.parent.favoriteButtonX and mouseX < (self.parent.favoriteButtonX+20) then
                favTexture = self.parent.favCheckedTex
                alpha = 1
            end
        end
        if item.item.favorite then
            favTexture = self.parent.favoriteStar
            alpha = 1 
        end
        if favTexture then
            self:drawTexture(favTexture,self.parent.favoriteButtonX,  y + 10,alpha,1,1,1);
        end
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
        self:drawText(""..item.item.price, 320, y + 8, 1, 1, 1, a, UIFont.Small);
    end

    if item.item.invItem or item.item.texture then
        local texture = item.item.texture
        if not texture then
            texture = item.item.invItem:getTex()
        end
        self:drawTextureScaledAspect(texture, 6, y+5, 30, 30, 1, 1, 1, 1)
    end

    self:drawTextureScaledAspect(addBtn.texture, self.parent.addButtonX, y + 10, addBtn.scale, addBtn.scale, 1, 1, 1, 1)

    if item.item.VehicleID then
        self:drawTextureScaledAspect(previewBtn.texture, self.parent.previewButtonX, y + 10, previewBtn.scale, previewBtn.scale, 1, 1, 1, 1)
    end

    return y + item.height;
end

function ShopTabUI:onMouseDownShopItem(x, y)
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
        if self.favoriteBtn then
            if not (self.parent.tabType == Tab.Sell) then 
                self.parent:manageFavorites(self.selectedRow)
            end
            return
        end
        if self.addBtn then
		    self.parent:addToCart(self.selectedRow)
        end
    end
end

function ShopTabUI:manageFavorites(selectedRow)
    local item = self.shopItems.items[selectedRow].item
    local shopFavorites = self.ShopUI.player:getModData().shopFavorites
    local check = not item.favorite
    if check then
        local data = copyTable(item)
        data.name = nil
        data.invItem = nil
        if item.items then
            data.items = item.items
        end
        shopFavorites[item.type] = data
    else
        if self.tabType == Tab.Favorite then
            self.shopItems:removeItemByIndex(selectedRow)
        end
        shopFavorites[item.type] = nil
    end
    item.favorite = check
    self.ShopUI.reloadItems = true
end

function ShopTabUI:onMouseMoveShopItem(dx, dy)
    local list = self.parent.shopItems
    if not list then return end
    list.selectedRow = nil
    list.previewBtn = nil
    list.favoriteBtn = nil
    list.addBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then self.parent.ShopUI:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then self.parent.ShopUI:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then self.parent.ShopUI:toggleTooltip(false) return end
    list.selectedRow = rowIndex
    local mouseX = self:getMouseX()
    if mouseX > self.parent.favoriteButtonX and mouseX < (self.parent.favoriteButtonX+20) then
        list.favoriteBtn = true
    end
    if mouseX > self.parent.addButtonX then
        list.addBtn = true
    end
    if mouseX > self.parent.previewButtonX then
        list.previewBtn = true
    end
    if not selectedRow.item then self.parent.ShopUI:toggleTooltip(false) return end
    self.parent.ShopUI:toggleTooltip(true,selectedRow.item)
end

function ShopTabUI:prerender()
    self.shopItems.doDrawItem = ShopTabUI.doDrawShopItem;
    self.shopItems.onMouseMove = ShopTabUI.onMouseMoveShopItem;
    self.shopItems.onMouseDown = ShopTabUI.onMouseDownShopItem;
end

function ShopTabUI:addToCart(selectedRow)
    local item = self.shopItems.items[selectedRow]
    if self.ShopUI.actionInProgress then return end
    self.ShopUI:toggleTooltip(false)
    self.ShopUI.cartItems:addItem(item.text,item.item);
    if self.tabType == Tab.Sell then
        self.shopItems:removeItemByIndex(selectedRow)
    end
    self.ShopUI.cartItems:setYScroll(-10000);
end

function ShopTabUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    local tabType = self.tabType
    self.shopItems.items = self.ShopUI.shopItemsCache[tabType]
    filterText = string.lower(filterText)
    local shopItems = self.shopItems.items
    self.shopItems:clear()
    for k,v in ipairs(shopItems) do
        if string.contains(string.lower(v.item.name), filterText) then
            if tabType == Tab.Favorite then
                if v.item.favorite then
                    self.shopItems:addItem(v.text,v.item);
                end
            else
                self.shopItems:addItem(v.text,v.item);
            end
        end
    end
end

function ShopTabUI:create()
    local x = 30
    local y = 50

    self.filterLabel = ISLabel:new(x, y-20, 1,UIText.Search,1,1,1,1,UIFont.Small, true);
    self:addChild(self.filterLabel);

    local width = ((self.width/3) - getTextManager():MeasureStringX(UIFont.Small, UIText.Search)) - 98;
    self.filterEntry = ISTextEntryBox:new("", getTextManager():MeasureStringX(UIFont.Small,UIText.Search) + 40, y-28, width, 1);
    self.filterEntry:initialise();
    self.filterEntry:instantiate();
    self.filterEntry:setText("");
    self.filterEntry:setClearButton(true);
    self.filterEntry.onTextChange = ShopTabUI.onFilterChange
    self:addChild(self.filterEntry);
    self.lastText = self.filterEntry:getInternalText();

    self.sortPriceButton = ISButton:new((self.width / 2)-160, y-30, 25,25,"",self, ShopTabUI.sortPriceBtn);
    self.sortPriceButton.borderColor.a = 0.0;
    self.sortPriceButton.backgroundColor.a = 0;
    self.sortPriceButton.backgroundColorMouseOver.a = 0;
    self.sortPriceButton:setImage(Shop.textures.Sort.texture)
    self.sortPriceButton:initialise()
    self.sortPriceButton.enable = true
    self:addChild(self.sortPriceButton);

    self.moveAllButton = ISButton:new((self.width / 2)-50, y-30, 25,25,"",self, ShopTabUI.moveAllBtn);
    self.moveAllButton.borderColor.a = 0.0;
    self.moveAllButton.backgroundColor.a = 0;
    self.moveAllButton.backgroundColorMouseOver.a = 0;
    self.moveAllButton:setImage(Shop.textures.MoveAll.texture)
    self.moveAllButton:initialise()
    self.moveAllButton.enable = false
    self.moveAllButton:setVisible(false)
    self:addChild(self.moveAllButton);
    
    self.shopItems = ISScrollingListBox:new(x, y, (self.width / 3) + 110, self.height - 100);
    self.shopItems:initialise();
    self.shopItems:instantiate();
    self.shopItems.font = UIFont.NewSmall;
    self.shopItems.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.shopItems.selected = 0;
    self.shopItems.joypadParent = self;
    self.shopItems.drawBorder = false;
    self.shopItems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.shopItems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self:addChild(self.shopItems);
end

local sortToggle = true
function ShopTabUI:sortPriceBtn()
    local items = self.shopItems.items
    table.sort(items, function(v1,v2) if sortToggle then return v1.item.price<v2.item.price end return v1.item.price>v2.item.price end)
    self.shopItems.items = items
    sortToggle = not sortToggle
end

function ShopTabUI:moveAllBtn()
    local items = self.shopItems.items
    for k,v in pairs(items) do
        self.ShopUI.cartItems:addItem(v.item.text,v.item);
    end
    self.shopItems:clear()
end

function ShopTabUI:new (x, y, width, height)
    local o = {};
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.favoriteStar = getTexture("media/ui/FavoriteStar.png");
    o.favCheckedTex = getTexture("media/ui/FavoriteStarChecked.png");
    o.favNotCheckedTex = getTexture("media/ui/FavoriteStarUnchecked.png");
    o.favWidth = o.favoriteStar and o.favoriteStar:getWidth() or 13
    o:noBackground();
    self.parent = o;
    return o;
end