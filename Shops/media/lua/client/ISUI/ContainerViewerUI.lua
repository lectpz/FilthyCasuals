local Nfunction = require "Nfunction"
ContainerViewerUI = ISCollapsableWindow:derive("ContainerViewerUI");
ContainerViewerUI.instance = nil;
ContainerViewerUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
ContainerViewerUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
ContainerViewerUI.containerItemsCache = nil

local width = 300
local height = 400
local browseBtn = Shop.textures.Browse
local browseBtnX = 220
local containerId = nil

function ContainerViewerUI:show(container,reset)
    if PlayerShopUI.instance and PlayerShopUI.instance.cvUis[container:getID()] then
        return
    end
    if reset then ContainerViewerUI.instance=nil end
    if ContainerViewerUI.instance==nil then
        ContainerViewerUI.instance = ContainerViewerUI:new (0, 0, width, height,container);
        ContainerViewerUI.instance.container = container
        ContainerViewerUI.instance:initialise();
        ContainerViewerUI.instance:instantiate();
        containerId = container:getID()
    end
    ContainerViewerUI.instance.pinButton:setVisible(false)
    ContainerViewerUI.instance.collapseButton:setVisible(false)
    ContainerViewerUI.instance:addToUIManager();
    ContainerViewerUI.instance:setVisible(true);
    if PlayerShopUI.instance then
        PlayerShopUI.instance.cvUis[container:getID()] = ContainerViewerUI.instance
    end
    return ContainerViewerUI.instance;
end

function ContainerViewerUI:onFilterChange()
    self.parent:filter()
end

function ContainerViewerUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    self.containertems.items = self.containerItemsCache
    filterText = string.lower(filterText)
    local containertems = self.containertems.items
    self.containertems:clear()
    for k,v in ipairs(containertems) do
        if string.contains(string.lower(v.item:getName()), filterText) then
            self.containertems:addItem(v.item:getType(),v.item);
        end
    end
    local foundCount = Currency.format(#self.containertems.items)
    local label = UIText.Total.." : " ..foundCount
    self.totalFound:setName(label)
end

local currentTooltip = nil
function ContainerViewerUI:toggleTooltip(show,item)
    if item then
        if not currentTooltip then
            currentTooltip = ISToolTipInv:new(item)
            currentTooltip:initialise();
        else
            currentTooltip:addToUIManager()
            currentTooltip:setItem(item)
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

function ContainerViewerUI:onMouseMove(dx, dy)
    self.mouseOver = true;
	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end
    if PlayerShopUI.instance then
        PlayerShopUI.instance:toggleTooltip(false)
    end
    self:toggleTooltip(false)
end

function ContainerViewerUI:onMouseMoveContainerItem(dx, dy)
    local list = self
    if list:isMouseOver() then
        local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
        if not rowIndex then self.parent:toggleTooltip(false) return end
        local selectedRow = list.items[rowIndex]
        if not selectedRow then self.parent:toggleTooltip(false) return end
        self.parent:toggleTooltip(true,selectedRow.item)
    end
end

function ContainerViewerUI:onMouseDownContainerItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
    local list = self
    local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if rowIndex < 1 then return end
    local mouseX = self:getMouseX()
    if mouseX > browseBtnX then
        local item = self.items[rowIndex].item
        ContainerViewerUI:show(item,true)
    end
end

function ContainerViewerUI:doDrawItem(y, item, alt)
    local baseItemDY = 0
    if item.item:getName() then
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

    self:drawText(item.item:getName(), 30, y + 10, 1, 1, 1, a, UIFont.Small);
    self:drawTextureScaledAspect(item.item:getTex(), 6, y+8, 20, 20, 1, 1, 1, 1)
    if item.item:IsInventoryContainer() then
        self:drawTextureScaledAspect(browseBtn.texture, browseBtnX, y + 7, browseBtn.scale, browseBtn.scale, 1, 1, 1, 1)
    end

    return y + item.height;
end

function ContainerViewerUI:createChildren()
    ISCollapsableWindow.createChildren(self);

    local th = self:titleBarHeight();
    local rh = self.resizable and self:resizeWidgetHeight() or 0

    self.filterLabel = ISLabel:new(20, 50, 1,UIText.Search,1,1,1,1,UIFont.Small, true);
    self:addChild(self.filterLabel);

    local width = ((self.width/2) - getTextManager():MeasureStringX(UIFont.Small, UIText.Search)) - 100;
    self.filterEntry = ISTextEntryBox:new("", getTextManager():MeasureStringX(UIFont.Small,UIText.Search) + 30, 40, 120, 1);
    self.filterEntry:initialise();
    self.filterEntry:instantiate();
    self.filterEntry:setText("");
    self.filterEntry:setClearButton(true);
    self.filterEntry.onTextChange = ContainerViewerUI.onFilterChange
    self:addChild(self.filterEntry);

    self.containertems = ISScrollingListBox:new(25, 70, 250, 300);
    self.containertems:initialise();
    self.containertems:instantiate();
    self.containertems:setAnchorRight(false)
    self.containertems:setAnchorBottom(true)
    self.containertems.font = UIFont.NewSmall;
    self.containertems.itemheight = self.MEDIUM_FONT_HGT;
    self.containertems.selected = 1;
    self.containertems.joypadParent = self;
    self.containertems.drawBorder = false;
    self.containertems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.containertems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self.containertems.doDrawItem = ContainerViewerUI.doDrawItem;
    self.containertems.onMouseMove = ContainerViewerUI.onMouseMoveContainerItem;
    self.containertems.onMouseDown = ContainerViewerUI.onMouseDownContainerItem;
    self:addChild(self.containertems);

    local items = self.container:getInventory():getItems()

    for i=0,items:size()-1 do
        local item = items:get(i)
        self.containertems:addItem(item:getType(),item)
    end
    self.containerItemsCache = self.containertems.items

    local foundCount = Currency.format(#self.containertems.items)
    local label = UIText.Total.." : " ..foundCount
    self.totalFound = ISLabel:new(200, 45, ContainerViewerUI.SMALL_FONT_HGT, label, 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.totalFound);

    self:bringToTop()
end

function ContainerViewerUI:close()
	ISCollapsableWindow.close(self);
    if PlayerShopUI.instance then
        PlayerShopUI.instance.cvUis[containerId] = nil
    end
    ContainerViewerUI.instance = nil
    self:removeFromUIManager()
end

function ContainerViewerUI:new(x, y, width, height,container)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    local title = Nfunction.trimString(container:getName(),30)
    o.title = title;
    o.resizable = false;
    return o
end