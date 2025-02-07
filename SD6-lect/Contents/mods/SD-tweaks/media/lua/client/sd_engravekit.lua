local RMWeapons = {}
RMWeapons.engrave = ISPanel:derive("RMWeapons.engrave")

local engravekititem = "Base.EngraveKit"

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function RMWeapons.engrave:initialise()
	ISPanel.initialise(self);
end

function RMWeapons.engrave:noBackground()
	self.background = false;
end

function RMWeapons.engrave:close()
	self:setVisible(false);
    self:removeFromUIManager()
end

function RMWeapons.engrave:modal(button, player)

    if button.internal ~= "OK" then return end

	local name = button.parent.entry:getText()
	local player = getSpecificPlayer(0)
	local playerInv = player:getInventory()
	
	if not playerInv:contains(engravekititem) then 
		player:setHaloNote("I seem to have misplaced my engraving kit.", 236, 131, 190, 50)
		return
	end
	
	local weapon = player:getPrimaryHandItem()
	if not weapon:IsWeapon() then return end
	local weaponName = weapon:getName()
	local engravedName = name .. "'s " .. weaponName 
	weapon:getModData().EngravedName = name
	weapon:setName(name)
	playerInv:RemoveOneOf(engravekititem)

end

function RMWeapons.engrave:engrave()
	local modal = ISTextBox:new(0, 0, 280, 180, "Engrave Name:", "CUSTOM WEAPON NAME HERE", nil, RMWeapons.engrave.modal, nil, 1,1,self)
	modal:initialise()
	modal:addToUIManager()
end

--************************************************************************--
--** ISPanel:render
--************************************************************************--

function RMWeapons.engrave:prerender()

end

function RMWeapons.engrave:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function RMWeapons.engrave:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function RMWeapons.engrave:onMouseDown(x, y)
    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return;
    end
    if not self:isMouseOver() then
        return -- this happens with setCapture(true)
    end
    
    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function RMWeapons.engrave:onMouseMoveOutside(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = false;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
    end
end

function RMWeapons.engrave:onMouseMove(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = true;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
        --ISMouseDrag.dragView = self;
    end
end

--************************************************************************--
--** ISPanel:new
--************************************************************************--
function RMWeapons.engrave:new (x, y, width, height,character)
	local o = {}
	--o.data = {}
	local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
	o.background = true;
	o.backgroundColor = {r=0, g=0, b=0, a=0.5};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
	o.height = height;
	o.anchorLeft = false;
	o.anchorRight = false;
	o.anchorTop = false;
	o.anchorBottom = false;
    o.moveWithMouse = true;
    o.character = character;
   return o
end

local function RMWengraveKit(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	weapon = playerObj:getPrimaryHandItem()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		itemFT = item:getFullType()
		if not playerInv:contains(itemFT) then return end
		if not weapon then return end
		if not weapon:IsWeapon() then return end
		if itemFT == engravekititem then
			context:addOption("Engrave Equipped Weapon", item, RMWeapons.engrave.engrave, player)
			break
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(RMWengraveKit)