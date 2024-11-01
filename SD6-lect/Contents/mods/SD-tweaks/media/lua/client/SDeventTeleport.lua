local SDeventTP = {}
SDeventTP.teleport = ISPanel:derive("SDeventTP.teleport")


--************************************************************************--
--** ISPanel:initialise
--************************************************************************--

function SDeventTP.teleport:initialise()
	ISPanel.initialise(self);
end

function SDeventTP.teleport:noBackground()
	self.background = false;
end

function SDeventTP.teleport:close()
	self:setVisible(false);
    self:removeFromUIManager()
end

function SDeventTP.teleport:modal(button)

	if button.internal == "YES" then
		local playerObj = getSpecificPlayer(0)
		local x = SandboxVars.SDevents.tpX-- or 19650
		local y = SandboxVars.SDevents.tpY-- or 150
		local z = SandboxVars.SDevents.tpZ-- or 0
		
		local z_vis = playerObj:getStats():getNumVisibleZombies() or 0
		local z_chase = playerObj:getStats():getNumChasingZombies() or 0
		local z_close = playerObj:getStats():getNumVeryCloseZombies() or 0
		
		if z_vis > 0 or z_chase > 0 or z_close > 0 then playerObj:Say("I need to be in a safe place to do that...") return end
		
		playerObj:setX(x)
		playerObj:setY(y)
		playerObj:setZ(z)
		playerObj:setLx(x)
		playerObj:setLy(y)
		playerObj:setLz(z)
	end
end

function SDeventTP.teleport:teleport()
	local player = 0
	local width = 350;
	local x = getPlayerScreenLeft(player) + (getPlayerScreenWidth(player) - width) / 2
	local height = 120;
	local y = getPlayerScreenTop(player) + (getPlayerScreenHeight(player) - height) / 2
	local modal = ISModalDialog:new(x,y, width, height, "Teleport to event?", true, self, SDeventTP.teleport.modal, player);
	modal:initialise()
	modal:addToUIManager()
	if JoypadState.players[player+1] then
		modal.prevFocus = JoypadState.players[player+1].focus
		setJoypadFocus(player, modal)
	end
end

--************************************************************************--
--** ISPanel:render
--************************************************************************--

function SDeventTP.teleport:prerender()

end

function SDeventTP.teleport:onMouseUp(x, y)
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

function SDeventTP.teleport:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function SDeventTP.teleport:onMouseDown(x, y)
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

function SDeventTP.teleport:onMouseMoveOutside(dx, dy)
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

function SDeventTP.teleport:onMouseMove(dx, dy)
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
function SDeventTP.teleport:new (x, y, width, height,object,character)
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
    o.stoneobject = object;
    o.character = character;
   return o
end

local function SDevent_teleport(object,playerObj,sq)
	local x = SandboxVars.SDevents.tpX-- or 19650
	local y = SandboxVars.SDevents.tpY --or 150
	local z = SandboxVars.SDevents.tpZ --or 0
	playerObj:setX(x)
	playerObj:setY(y)
	playerObj:setZ(z)
	playerObj:setLx(x)
	playerObj:setLy(y)
	playerObj:setLz(z)
end

local function eventTeleport(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(0)
	if SandboxVars.SDevents.teleportenabled then
		for i,v in pairs(worldobjects) do
			local isosprite = v:getSprite()
			if isosprite then
				local sq = v:getSquare()
				local submenu = context:addOption("TAKE ME TO THE EVENT!!!", v, SDeventTP.teleport.teleport,playerObj,sq)
				--local submenu = context:insertOptionAfter(getText("ContextMenu_SitGround"), "Take me to the event!!!", SDevent_teleport,v,playerObj,sq)
				return
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(eventTeleport);



