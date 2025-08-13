ShopUITooltip = ISPanel:derive("ShopUITooltip");

local tooltipCache = {}
local packItemsCache = {}

function ShopUITooltip:initialise()
	ISPanel.initialise(self);
end

function ShopUITooltip:instantiate()
	ISPanel.instantiate(self)
	self.javaObject:setConsumeMouseEvents(false)
end

function ShopUITooltip:setItem(item)
	self.item = item;
end

function ShopUITooltip:onMouseDown(x, y)
	return false
end

function ShopUITooltip:onMouseUp(x, y)
	return false
end

function ShopUITooltip:onRightMouseDown(x, y)
	return false
end

function ShopUITooltip:onRightMouseUp(x, y)
	return false
end

function ShopUITooltip:prerender()
	if self.owner and not self.owner:isReallyVisible() then
		self:removeFromUIManager()
		self:setVisible(false)
		return
	end
	self:doLayout()
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
end

function ShopUITooltip:render()
	local mx = getMouseX() + 32
	local my = getMouseY() + 10
	if not self.followMouse then
		mx = self:getX()
		my = self:getY()
	end
	if self.desiredX and self.desiredY then
		mx = self.desiredX
		my = self.desiredY
	end
	self:setX(mx)
	self:setY(my)

	if self.contextMenu and self.contextMenu.joyfocus then
		local playerNum = self.contextMenu.player
		self:setX(getPlayerScreenLeft(playerNum) + 60);
		self:setY(getPlayerScreenTop(playerNum) + 60);
	elseif self.contextMenu and self.contextMenu.currentOptionRect then
		if self.contextMenu.currentOptionRect.height > 32 then
			self:setY(my + self.contextMenu.currentOptionRect.height)
		end
		self:adjustPositionToAvoidOverlap(self.contextMenu.currentOptionRect)
	elseif self.owner and self.owner.isButton then
		local ownerRect = { x = self.owner:getAbsoluteX(), y = self.owner:getAbsoluteY(), width = self.owner.width, height = self.owner.height }
		self:adjustPositionToAvoidOverlap(ownerRect)
	end

	self:drawRect(0, 0, self.width, self.height, 0.7, 0.05, 0.05, 0.05)
	self:drawRectBorder(0, 0, self.width, self.height, 0.5, 0.9, 0.9, 1)

	local itemName = self.item.name
	if itemName then
		self:drawText(itemName, 8, 5, 1, 1, 1, 1, UIFont.Medium)
	end

	local tooltip = tooltipCache[self.item.type]
	if tooltip then
		local y = 50
		local x = 20
		self:drawText(UIText.Contains..":", x-10, y-25, 1, 1, 1, 1, UIFont.Small)
		local quantity = nil
		for k,v in pairs(tooltip) do
			quantity = ""
			if v.quantity then
				quantity = " ("..v.quantity..")"
			end
			self:drawTextureScaled(v.texture, x-5, y, 15, 15, 1, 1, 1, 1)
			self:drawText(v.name..quantity, x+15, y, 1, 1, 1, 1, UIFont.Small)
			y = y+20
		end
		if self.item.drop then
			self:drawText(UIText.DropOnFloor, x-15, y+5, 1, 1, 1, 1, UIFont.Small)
		end
		return
	end

	local packItems = self.item.items
	if packItems then
		local inventoryItems = {}
		for k,v in pairs(packItems) do
			local item = InventoryItemFactory.CreateItem(v.item)
			if item then 
				local data = {}
				data.texture = item:getTex()
				data.name = item:getName()
				if v.quantity then
					data.quantity = v.quantity
				end
				table.insert(inventoryItems,data)
			end
		end
		tooltipCache[self.item.type] = inventoryItems
	end
end

function ShopUITooltip:doLayout()
	local itemNameWidth = getTextManager():MeasureStringX(UIFont.Medium, self.item.name)
	local defaultHeight = 60
	local itemsCount = #self.item.items
	if self.item.drop then
		local dropWidth = getTextManager():MeasureStringX(UIFont.Small, UIText.DropOnFloor)
		if dropWidth > itemNameWidth then
			itemNameWidth  = dropWidth
		end
		itemsCount = itemsCount + 1
	end

	if packItemsCache[self.item.type] then
		itemNameWidth = packItemsCache[self.item.type]
	else
		if itemsCount > 0 then
			local packItems = self.item.items
			for k,v in pairs(packItems) do
				local itemName = getItemNameFromFullType(v.item)
				local fixedWidth = getTextManager():MeasureStringX(UIFont.Medium, itemName)
				if fixedWidth > itemNameWidth then
					itemNameWidth = fixedWidth
				end
			end
			packItemsCache[self.item.type] = itemNameWidth
		end
	end

	itemNameWidth = itemNameWidth + 40
	local fixedHeight = defaultHeight + (getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()*itemsCount)
	self:setWidth(itemNameWidth)
	self:setHeight(fixedHeight)
end

function ShopUITooltip:setOwner(ui)
	self.owner = ui
end

local function setRGBA(rgba, r, g, b, a)
    rgba.r = r
    rgba.g = g
    rgba.b = b
    rgba.a = a
    return rgba
end

function ShopUITooltip:reset()
    self:setVisible(false)
    self:noBackground()
    self.footNote = nil
    setRGBA(self.borderColor, 0.4, 0.4, 0.4, 1.0)
    setRGBA(self.backgroundColor, 0.0, 0.0, 0.0, 0.0)
    self.width = 0
    self.height = 0
    self.maxLineWidth = nil
    self.desiredX = nil
    self.desiredY = nil
    self.anchorLeft = true
    self.anchorRight = false
    self.anchorTop = true
    self.anchorBottom = false
    self.owner = nil
    self.contextMenu = nil
    self.followMouse = true
end

function ShopUITooltip:new()
   local o = ISPanel.new(self, 0, 0, 0, 0);
   o:noBackground();
   o.name = nil;
   o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
   o.backgroundColor = {r=0, g=0, b=0, a=0};
   o.width = 0;
   o.height = 0;
   o.anchorLeft = true;
   o.anchorRight = false;
   o.anchorTop = true;
   o.anchorBottom = false;
   o.owner = nil
   o.followMouse = true
   return o;
end