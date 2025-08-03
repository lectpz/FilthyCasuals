PlayerShopTabUI = ISPanelJoypad:derive("PlayerShopTabUI");
PlayerShopTabUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
PlayerShopTabUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
PlayerShopTabUI.addButtonX = 380
PlayerShopTabUI.previewButtonX = PlayerShopTabUI.addButtonX + 25

local addBtn = Shop.textures.AddButton;
local previewBtn = Shop.textures.PreviewButton;
local browseBtn = Shop.textures.Browse;

function PlayerShopTabUI:initialise()
    ISPanelJoypad.initialise(self);
    self:create();
end

function PlayerShopTabUI:setShopUI(instance)
    self.ShopUI = instance
end

function PlayerShopTabUI:onFilterChange()
    self.parent:filter()
end

function PlayerShopTabUI:setCategoryType(tabType)
    self.tabType = tabType
end

function PlayerShopTabUI:doDrawShopItem(y, item, alt)
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
        self:drawText(""..item.item.price, 320, y + 8, 1, 1, 1, a, UIFont.Small);
    end

    if item.item.invItem then
        self:drawTextureScaledAspect(item.item.invItem:getTex(), 6, y+5, 30, 30, 1, 1, 1, 1)
        if item.item.invItem:IsInventoryContainer() then
            self:drawTextureScaledAspect(browseBtn.texture, self.parent.previewButtonX, y + 10, previewBtn.scale, previewBtn.scale, 1, 1, 1, 1)
        end
    end

    self:drawTextureScaledAspect(addBtn.texture, self.parent.addButtonX, y + 10, addBtn.scale, addBtn.scale, 1, 1, 1, 1)

    if item.item.VehicleID then
        self:drawTextureScaledAspect(previewBtn.texture, self.parent.previewButtonX, y + 10, previewBtn.scale, previewBtn.scale, 1, 1, 1, 1)
    end

    return y + item.height;
end

function PlayerShopTabUI:onMouseDownShopItem(x, y)
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
        if self.addBtn then
		    self.parent:addToCart(self.selectedRow)
        end
    end
end

function PlayerShopTabUI:onMouseMoveShopItem(dx, dy)
    local list = self.parent.shopItems
    if not list then return end
    list.selectedRow = nil
    list.previewBtn = nil
    list.addBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then self.parent.ShopUI:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then self.parent.ShopUI:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then self.parent.ShopUI:toggleTooltip(false) return end
    list.selectedRow = rowIndex
    local mouseX = self:getMouseX()
    if mouseX > self.parent.addButtonX then
        list.addBtn = true
    end
    if mouseX > self.parent.previewButtonX then
        list.previewBtn = true
    end
    if not selectedRow.item then self.parent.ShopUI:toggleTooltip(false) return end
    self.parent.ShopUI:toggleTooltip(true,selectedRow.item)
end

function PlayerShopTabUI:prerender()
    self.shopItems.doDrawItem = PlayerShopTabUI.doDrawShopItem;
    self.shopItems.onMouseMove = PlayerShopTabUI.onMouseMoveShopItem;
    self.shopItems.onMouseDown = PlayerShopTabUI.onMouseDownShopItem;
end

function PlayerShopTabUI:addToCart(selectedRow)
    local item = self.shopItems.items[selectedRow]
    if self.ShopUI.actionInProgress then return end
    self.ShopUI:toggleTooltip(false)
    self.ShopUI.cartItems:addItem(item.text,item.item);
    self.shopItems:removeItemByIndex(selectedRow)
    self.ShopUI.cartItems:setYScroll(-10000);
end

function PlayerShopTabUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    local tabType = self.tabType
    self.shopItems.items = self.ShopUI.shopItemsCache[tabType]
    filterText = string.lower(filterText)
    local shopItems = self.shopItems.items
    self.shopItems:clear()
    for k,v in ipairs(shopItems) do
        if string.contains(string.lower(v.item.name), filterText) then
            self.shopItems:addItem(v.text,v.item);
        end
    end
end

function PlayerShopTabUI:create()
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
    self.filterEntry.onTextChange = PlayerShopTabUI.onFilterChange
    self:addChild(self.filterEntry);
    self.lastText = self.filterEntry:getInternalText();

    self.sortPriceButton = ISButton:new((self.width / 2)-160, y-30, 25,25,"",self, PlayerShopTabUI.sortPriceBtn);
    self.sortPriceButton.borderColor.a = 0.0;
    self.sortPriceButton.backgroundColor.a = 0;
    self.sortPriceButton.backgroundColorMouseOver.a = 0;
    self.sortPriceButton:setImage(Shop.textures.Sort.texture)
    self.sortPriceButton:initialise()
    self.sortPriceButton.enable = true
    self:addChild(self.sortPriceButton);
    
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
function PlayerShopTabUI:sortPriceBtn()
    local items = self.shopItems.items
    table.sort(items, function(v1,v2) if sortToggle then return v1.item.price<v2.item.price end return v1.item.price>v2.item.price end)
    self.shopItems.items = items
    sortToggle = not sortToggle
end

function PlayerShopTabUI:new (x, y, width, height)
    local o = {};
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o:noBackground();
    self.parent = o;
    return o;
end