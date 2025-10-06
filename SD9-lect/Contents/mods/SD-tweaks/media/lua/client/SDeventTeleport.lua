local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "

local SDeventTP = {}
SDeventTP.teleport = ISPanel:derive("SDeventTP.teleport")

local coords = {
	11200, 8806, 11280, 8883,--east shops
	11108, 8778, 11152, 8816,--north shops
	11165, 8775, 11233, 8796,--north shops 2
	11120, 8885, 11139, 8933,--south shops 1
	11139, 8885, 11280, 8991,--south shops 2
	11247, 8771, 11327, 8994,--east shops 2
}

local function checkCCshopCoords(x, y, coords)
	for i=1, #coords, 4 do
		local xa, ya, xb, yb = coords[i], coords[i+1], coords[i+2], coords[i+3]
		if x >= xa and y >= ya and x <= xb and y <= yb then return true end
	end
	return false
end

local function splitString(_string)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in _string:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

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

local eventtp = false
local shoptp = false
local addShop = false
local removeShop = false

function SDeventTP.teleport:modal(button)
	if eventtp then
		if button.internal == "YES" then
			eventtp = false
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

	if shoptp then
		if button.internal == "OK" then
			shoptp = false
			local coordinates = button.parent.entry:getText()
			local playerObj = getSpecificPlayer(0)
			
			local shopcoords = splitString(coordinates)
			local x,y,z = tonumber(shopcoords[1]), tonumber(shopcoords[2]), tonumber(shopcoords[3])
			if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
				playerObj:Say("I need to use numbers.")
				return
			end
			
			if not checkCCshopCoords(x, y, coords) then
				playerObj:Say("I can only teleport to the shops at CC.")
				return
			end	

			playerObj:setX(x)
			playerObj:setY(y)
			playerObj:setZ(0)
			playerObj:setLx(x)
			playerObj:setLy(y)
			playerObj:setLz(0)
		end
	end
	
	if addShop then
		addShop = false
		local coordinates = button.parent.entry:getText()
		local playerObj = getSpecificPlayer(0)
		local shopcoords = splitString(coordinates)
		local x,y,z,name = tonumber(shopcoords[1]), tonumber(shopcoords[2]), 0, shopcoords[4]
		
		if name == nil then name = "Unknown" end
		
		if not checkCCshopCoords(x, y, coords) then
			playerObj:Say("These coordinates are not in the shop zones of CC.")
			return
		end	
		
		local favshops = ModData.getOrCreate("favshops")
		favshops[name] = {x, y, 0}
		playerObj:Say("Added shop entry: " .. name .. " (" .. x .. "," .. y .. "," .. z .. ")")
	end
	
	if removeShop then
		removeShop = false
		local name = button.parent.entry:getText()
		local playerObj = getSpecificPlayer(0)
		
		local favshops = ModData.getOrCreate("favshops")
		if favshops[name] then
			favshops[name] = nil
			playerObj:Say("Removed shop entry: " .. name)
		else
			playerObj:Say("Shop entry does not exist for: " .. name)
		end
	end
end

function SDeventTP.teleport:eventteleport()
	eventtp = true
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

function SDeventTP.teleport:shopteleport()
	local tier, zone = checkZone()
	if zone ~= "CC" then
		getSpecificPlayer(0):Say("I need to be in CC to use this.")
		return
	end
	shoptp = true
	--print(shoptp)
	local width = 280
	local height = 180
	local modal = ISTextBox:new(getPlayerScreenWidth(0)/2-0.5*width, getPlayerScreenHeight(0)/2-0.5*height, width, height, "Teleport to shop (x,y,z):", "11121, 8884, 0", nil, SDeventTP.teleport.modal, nil, 1,1,self)
    modal:initialise()
    modal:addToUIManager()
end

function SDeventTP.teleport:ccteleport()
	shoptp = false
	local tier, zone = checkZone()
	local playerObj = getSpecificPlayer(0)
	if zone ~= "CC" then
		playerObj:Say("I need to be in CC to use this.")
		return
	end
	
	local x,y,z = 11072, 8851, 0
	
	playerObj:setX(x)
	playerObj:setY(y)
	playerObj:setZ(z)
	playerObj:setLx(x)
	playerObj:setLy(y)
	playerObj:setLz(z)
end

function SDeventTP.teleport:favteleport()
	local tier, zone = checkZone()
	local playerObj = getSpecificPlayer(0)
	if zone ~= "CC" then
		playerObj:Say("I need to be in CC to use this.")
		return
	end
	
	--local x = args.x
	--local y = args.y
	--local z = args.z
	
	playerObj:setX(x)
	playerObj:setY(y)
	playerObj:setZ(0)
	playerObj:setLx(x)
	playerObj:setLy(y)
	playerObj:setLz(0)
end

function SDeventTP.teleport:assignShops()
	addShop = true
	--print(shoptp)
	local width = 400
	local height = 180
	local modal = ISTextBox:new(getPlayerScreenWidth(0)/2-0.5*width, getPlayerScreenHeight(0)/2-0.5*height, width, height, "Add player shop (x,y,z, NAME):", "11121, 8884, 0, SHOP_OWNER_NAME", nil, SDeventTP.teleport.modal, nil, 1,1,self)
    modal:initialise()
    modal:addToUIManager()
end

function SDeventTP.teleport:removeShops()
	removeShop = true
	--print(shoptp)
	local width = 280
	local height = 180
	local modal = ISTextBox:new(getPlayerScreenWidth(0)/2-0.5*width, getPlayerScreenHeight(0)/2-0.5*height, width, height, "Remove player shop (NAME):", "SHOP_OWNER_NAME", nil, SDeventTP.teleport.modal, nil, 1,1,self)
    modal:initialise()
    modal:addToUIManager()
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
				local submenu = context:addOption("TAKE ME TO THE EVENT!!!", v, SDeventTP.teleport.eventteleport,playerObj,sq)
				--local submenu = context:insertOptionAfter(getText("ContextMenu_SitGround"), "Take me to the event!!!", SDevent_teleport,v,playerObj,sq)
				return
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(eventTeleport);

local function favTP(args)
	local playerObj = getSpecificPlayer(0)
	local tier, zone = checkZone()
	if zone ~= "CC" then
		playerObj:Say("I need to be in CC to use this.")
		return
	end

	playerObj:setX(x)
	playerObj:setY(y)
	playerObj:setZ(0)
	playerObj:setLx(x)
	playerObj:setLy(y)
	playerObj:setLz(0)
end

local function shopTeleport(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(0)
	local tier, zone = checkZone()
	
	if zone ~= "CC" then return end

	for i,v in pairs(worldobjects) do
		local isosprite = v:getSprite()
		if isosprite then
			local sq = v:getSquare()
			local option = context:addOption("Sunday Drivers Shops", v, nil,sq)
			local sub_menu = ISContextMenu:getNew(context)
			context:addSubMenu(option, sub_menu);
			
			local sub_1 = sub_menu:addOption("Return me to CC Main Building", v, SDeventTP.teleport.ccteleport, sq)
			tooltip = ISWorldObjectContextMenu.addToolTip();
			tooltip.description = tooltip.description .. green .. "Teleport player back to CC bus stop. <LINE> "
			sub_1.toolTip = tooltip
			
			local sub_2 = sub_menu:addOption("Teleport me to a shop coordinate", v, SDeventTP.teleport.shopteleport, sq)
			tooltip = ISWorldObjectContextMenu.addToolTip();
			tooltip.description = tooltip.description .. green .. "Teleport player to shop coordinates at X,Y,Z. <LINE> "
			tooltip.description = tooltip.description .. green .. " <LINE> Visit " .. gold .. "https://sundaydrivers.pro/" .. green .. " to search for items and get the coordinates! <LINE> "
			sub_2.toolTip = tooltip
			--local submenu = context:insertOptionAfter(getText("ContextMenu_SitGround"), "Take me to the event!!!", SDevent_teleport,v,playerObj,sq)
			
			local option_sm1 = sub_menu:addOption("Teleport me to my favorite shops", v, nil, sq)
			local sm1 = ISContextMenu:getNew(sub_menu)
			sub_menu:addSubMenu(option_sm1, sm1);
			

			local favshops = ModData.getOrCreate("favshops")
			local shop_names = {}
			
			for k,v in pairs(favshops) do
				table.insert(shop_names, k)
				table.sort(shop_names)
			end
			
			if #shop_names > 0 then 
				for i=1,#shop_names do
					local name = shop_names[i]
					local shop = favshops[shop_names[i]]
					local x = shop[1]
					local y = shop[2]
					local z = 0
										
					local sub_sm1 = sm1:addOption(name .. "'s shop (" .. x .. "," .. y .. "," .. z .. ")", v, 	function()
																													local playerObj = getSpecificPlayer(0)
																													if zone ~= "CC" then
																														playerObj:Say("I need to be in CC to use this.")
																														return
																													end

																													playerObj:setX(x)
																													playerObj:setY(y)
																													playerObj:setZ(z)
																													playerObj:setLx(x)
																													playerObj:setLy(y)
																													playerObj:setLz(z)
																													playerObj:Say("Teleported to " .. name .. "'s shop at (" .. x .. "," .. y .. "," .. z .. ")")
																												end, sq)
				end	
			else
				option_sm1.notAvailable = true
			end

			local sub_3 = sub_menu:addOption("Add favorite shops", v, SDeventTP.teleport.assignShops, sq)
			tooltip = ISWorldObjectContextMenu.addToolTip();
			--tooltip.description = tooltip.description .. green .. "Teleport player to shop coordinates at X,Y,Z, PLAYER_NAME. <LINE> "
			tooltip.description = tooltip.description .. green .. "Visit " .. gold .. "https://sundaydrivers.pro/" .. green .. " to search for items and get the coordinates and shop owner's name! <LINE> "
			sub_3.toolTip = tooltip
			
			local option_sm3 = sub_menu:addOption("Remove favorite shops", v, nil, sq)
			local sm3 = ISContextMenu:getNew(sub_menu)
			sub_menu:addSubMenu(option_sm3, sm3);
			if #shop_names > 0 then 
				for i=1,#shop_names do
					local name = shop_names[i]
					local shop = favshops[shop_names[i]]
					local x = shop[1]
					local y = shop[2]
					local z = 0
										
					local sub_sm3 = sm3:addOption("Remove " ..  name .. "'s shop (" .. x .. "," .. y .. "," .. z .. ")", v, 	function()
																																	favshops[name] = nil
																																end, sq)
				end	
			else
				option_sm3.notAvailable = true
			end
			
			return
		end
	end

end

Events.OnFillWorldObjectContextMenu.Add(shopTeleport);