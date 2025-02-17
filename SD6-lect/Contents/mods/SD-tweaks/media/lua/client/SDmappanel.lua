require "SDZoneCheck"

SDmap = {}
SDmap.MapPanel = ISPanel:derive("SDmap.MapPanel")
SDmap.CreateNewZone = ISPanel:derive("SDmap.CreateNewZone")
local ModDataMapDrawTierZones = ModData.getOrCreate("MapDrawTierZones")

local function splitString(var)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in var:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function SDmap.MapPanel:initialise()
	ISPanel.initialise(self);
end

function SDmap.MapPanel:noBackground()
	self.background = false;
end

function SDmap.MapPanel:close()
	self:setVisible(false);
    self:removeFromUIManager()
end

function SDmap.MapPanel:drawzone()
	local x1y1 = splitString(self.x1y1:getInternalText())
	local x2y2 = splitString(self.x2y2:getInternalText())
	local tier = tonumber(self.ztier:getInternalText())
	local _zname = self.zname:getInternalText()
	local _nested = nil
	if self.znested.selected[1] then _nested = "Nested" end
	if self.zsubnested.selected[1] then _nested = "Subnested" end
	local _toxic = nil
	if self.ztoxic.selected[1] then _toxic = "Toxic" end
	local sprinter = math.max(math.min(tonumber(self.zsprinter:getInternalText()),100),0)
	local pinpoint = math.max(math.min(tonumber(self.zpinpoint:getInternalText()),100),0)
	local cognition = math.max(math.min(tonumber(self.zcognition:getInternalText()),100),0)
	local zombieHealth = math.max(math.min(tonumber(self.zhealth:getInternalText()),30),1.5)
	local x1, y1, x2, y2 = tonumber(x1y1[1]), tonumber(x1y1[2]), tonumber(x2y2[1]), tonumber(x2y2[2])
	--print(x1, y1, x2, y2, tier, nested, toxic, sprinter, pinpoint, cognition)
	--print(zonename)
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	MDZ[self.zone[6]] = "DELETE"
	MDZ[_zname] = nil
	Zone.list[self.zone[6]] = nil
	NestedZone.list[self.zone[6]] = nil
	--if not MDZ[_zname] then MDZ[_zname] = {} end
	MDZ[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	Zone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	if _nested == "Subnested" then
		NestedZone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	end
	--zonesGMD["test"] = { 9856,3851,10561,4502, 4, nil, nil, 20, 20, 20 }
	--Zone.list["test"] = { 9856,3851,10561,4502, 4, nil, nil, 20, 20, 20 }
	self.x1y1 = nil
	self.x2y2 = nil

	populateZoneNames()
	
	local symbolsAPI = self.mapAPI:getSymbolsAPI()
	for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
		local symbol = symbolsAPI:getSymbolByIndex(i)
		if symbol:getSymbolID() == "Asterisk" then
			symbolsAPI:removeSymbolByIndex(i)
		end
	end
	
	for i=1,#ZoneNames do
		drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
	end

	ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
	ModData.transmit("MoreDifficultZones")
	self:close()
end


function SDmap.MapPanel:onClickNested(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.MapPanel:onClickSubnested(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.MapPanel:onClickToxic(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.MapPanel:createChildren()
	
    ISPanel.createChildren(self)
	local mx, my, zoneinfo, zoneXY, zonename = self.zone[1], self.zone[2], self.zone[3], self.zone[4], self.zone[6]
	local zl = Zone.list[zonename]
	local x1, y1, x2, y2, tier = zl[1], zl[2], zl[3], zl[4], zl[5]
	local nested, toxic = zl[6], zl[7]
	local sprinter, pinpoint, cognition, z_health = zl[8] or 0, zl[9] or 0, zl[10] or 0, zl[11] or 2.1
	
    local emptyheight = self.height/80
    local lblheight = self.height/12.5
    self.lbl = ISLabel:new(3*emptyheight, emptyheight, lblheight, "[T"..tier.."] "..zonename, 1, 1, 1, 1.0, UIFont.Large, true);
    self.lbl:initialise();
    self.lbl:instantiate();
    self:addChild(self.lbl);


    local buttonheight = self.height/12
    local buttonwidth = self.width - 66*emptyheight

					 --ISButton:new (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
    self.buttonclose = ISButton:new(50*emptyheight, self.height -emptyheight -buttonheight-0 ,buttonwidth,buttonheight , "Close", self, self.close);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);
	
	local buttonheight = self.height/12
    local buttonwidth = self.width - 66*emptyheight

					 --ISButton:new (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
    self.buttonclose = ISButton:new(3*emptyheight, self.height -emptyheight -buttonheight-0 ,buttonwidth,buttonheight , "Update", self, self.drawzone);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);

    local buttonnewy = 2*emptyheight + lblheight+5
	local buttonwidth = 160
	local buttonoffset = 70
	local buttonheight = 16

	self.x1y1 = ISTextEntryBox:new(x1 .. "," .. y1, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.x1y1.anchorTop = false
    self.x1y1.anchorBottom = false
	self.x1y1:initialise();
	self.x1y1:instantiate();
	self:addChild(self.x1y1);
	
	buttonnewy = buttonnewy + lblheight
	self.x2y2 = ISTextEntryBox:new(x2 .. "," .. y2, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.x2y2.anchorTop = false
    self.x2y2.anchorBottom = false
	self.x2y2:initialise();
	self.x2y2:instantiate();
	self:addChild(self.x2y2);
	
	buttonnewy = buttonnewy + lblheight
	self.ztier = ISTextEntryBox:new(tostring(tier), buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.ztier.anchorTop = false
    self.ztier.anchorBottom = false
	self.ztier:initialise();
	self.ztier:instantiate();
	self:addChild(self.ztier);
	
	buttonnewy = buttonnewy + lblheight
	self.zname = ISTextEntryBox:new(zonename, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zname.anchorTop = false
    self.zname.anchorBottom = false
	self.zname:initialise();
	self.zname:instantiate();
	self:addChild(self.zname);
	
	--[[buttonnewy = buttonnewy + lblheight
	if not nested then nested = "nil" end
	self.znested = ISTextEntryBox:new(nested, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.znested.anchorTop = false
    self.znested.anchorBottom = false
	self.znested:initialise();
	self.znested:instantiate();
	self:addChild(self.znested);]]
	
	buttonnewy = buttonnewy + lblheight
	self.znested = ISTickBox:new(buttonoffset+3*emptyheight, buttonnewy, 20, 18, "", self, self.onClickNested);
	self.znested:initialise();
	self.znested:instantiate();
	self.znested.selected[1] = false;
	if nested == "Nested" then self.znested.selected[1] = true end
	self.znested:addOption("");
	self:addChild(self.znested);
	
	self.zsubnested = ISTickBox:new(2*buttonoffset+12*emptyheight, buttonnewy, 20, 18, "", self, self.onClickSubnested);
	self.zsubnested:initialise();
	self.zsubnested:instantiate();
	self.zsubnested.selected[1] = false;
	if nested == "Subnested" then self.zsubnested.selected[1] = true end
	self.zsubnested:addOption("");
	self:addChild(self.zsubnested);
	
	buttonnewy = buttonnewy + lblheight
	--[[if not toxic then toxic = "nil" end
	self.ztoxic = ISTextEntryBox:new(toxic, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.ztoxic.anchorTop = false
    self.ztoxic.anchorBottom = false
	self.ztoxic:initialise();
	self.ztoxic:instantiate();
	self:addChild(self.ztoxic);]]
	self.ztoxic = ISTickBox:new(buttonoffset+3*emptyheight, buttonnewy, 20, 18, "", self, self.onClickToxic);
	self.ztoxic:initialise();
	self.ztoxic:instantiate();
	self.ztoxic.selected[1] = false;
	if toxic == "Toxic" then self.ztoxic.selected[1] = true end
	self.ztoxic:addOption("");
	self:addChild(self.ztoxic);
	
	buttonnewy = buttonnewy + lblheight
	self.zsprinter = ISTextEntryBox:new(tostring(sprinter), buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zsprinter.anchorTop = false
    self.zsprinter.anchorBottom = false
	self.zsprinter:initialise();
	self.zsprinter:instantiate();
	self:addChild(self.zsprinter);
	
	buttonnewy = buttonnewy + lblheight
	self.zpinpoint = ISTextEntryBox:new(tostring(pinpoint), buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zpinpoint.anchorTop = false
    self.zpinpoint.anchorBottom = false
	self.zpinpoint:initialise();
	self.zpinpoint:instantiate();
	self:addChild(self.zpinpoint);
	
	buttonnewy = buttonnewy + lblheight
	self.zcognition = ISTextEntryBox:new(tostring(cognition), buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zcognition.anchorTop = false
    self.zcognition.anchorBottom = false
	self.zcognition:initialise();
	self.zcognition:instantiate();
	self:addChild(self.zcognition);
	
	buttonnewy = buttonnewy + lblheight
	self.zhealth = ISTextEntryBox:new(tostring(z_health), buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zhealth.anchorTop = false
    self.zhealth.anchorBottom = false
	self.zhealth:initialise();
	self.zhealth:instantiate();
	self:addChild(self.zhealth);

end


--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--

function SDmap.MapPanel:prerender()

	if self.background then
		self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
		self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end
	
	local emptyheight = math.floor(2*self.height/50);
	local lblheight = self.height/11.5
	lblheight = emptyheight + lblheight
	self:drawText("               X1,Y1:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("               X2,Y2:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("                 Tier#:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("               Name:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("            Nested:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	self:drawText("                                                 Sub Nested:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("             Toxic:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("    Sprinter%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("   Pinpoint%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("Cognition%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("             Health:", emptyheight, lblheight,1,1,1,1,UIFont.Small);

end

function SDmap.MapPanel:onMouseUp(x, y)
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

function SDmap.MapPanel:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function SDmap.MapPanel:onMouseDown(x, y)
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

function SDmap.MapPanel:onMouseMoveOutside(dx, dy)
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

function SDmap.MapPanel:onMouseMove(dx, dy)
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
--**
--************************************************************************--
function SDmap.MapPanel:new(x, y, width, height, zone, mapAPI)
	local o = {}
	--o.data = {}
	local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	o.mapAPI = mapAPI
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
	o.zone = zone
   return o
end


---------------------------------------------------------------------------------------------------------------
function SDmap.CreateNewZone:initialise()
	ISPanel.initialise(self);
	--[[self.znested = ISTickBox:new(50, 50, 20, 18, "", self, self.onClickNested);
	self.znested:initialise();
	self.znested:instantiate();
	self.znested.selected[1] = false;
	self.znested.selected[2] = true;
	self.znested:addOption("Test");
	self:addChild(self.claimOptions);]]
end

function SDmap.CreateNewZone:noBackground()
	self.background = false;
end

function SDmap.CreateNewZone:close()
	self:setVisible(false);
    self:removeFromUIManager()
end

function SDmap.CreateNewZone:drawzone()
	local x1y1 = splitString(self.x1y1:getInternalText())
	local x2y2 = splitString(self.x2y2:getInternalText())
	local tier = tonumber(self.ztier:getInternalText())
	local _zname = self.zname:getInternalText()
	local _nested = nil
	if self.znested.selected[1] then _nested = "Nested" end
	if self.zsubnested.selected[1] then _nested = "Subnested" end
	local _toxic = nil
	if self.ztoxic.selected[1] then _toxic = "Toxic" end
	local sprinter = math.max(math.min(tonumber(self.zsprinter:getInternalText()),100),0)
	local pinpoint = math.max(math.min(tonumber(self.zpinpoint:getInternalText()),100),0)
	local cognition = math.max(math.min(tonumber(self.zcognition:getInternalText()),100),0)
	local zombieHealth = math.max(math.min(tonumber(self.zhealth:getInternalText()),30),1.5)
	local x1, y1, x2, y2 = tonumber(x1y1[1]), tonumber(x1y1[2]), tonumber(x2y2[1]), tonumber(x2y2[2])
	--print(x1, y1, x2, y2, tier, nested, toxic, sprinter, pinpoint, cognition)
	--print(zonename)
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	MDZ[_zname] = nil
	Zone.list[_zname] = nil
	NestedZone.list[_zname] = nil
	if not MDZ[_zname] then MDZ[_zname] = {} end
	MDZ[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	Zone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	if _nested == "Subnested" then
		NestedZone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth }
	end
	--zonesGMD["test"] = { 9856,3851,10561,4502, 4, nil, nil, 20, 20, 20 }
	--Zone.list["test"] = { 9856,3851,10561,4502, 4, nil, nil, 20, 20, 20 }
	self.x1y1 = nil
	self.x2y2 = nil

	populateZoneNames()
	
	local symbolsAPI = self.mapAPI:getSymbolsAPI()
	for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
		local symbol = symbolsAPI:getSymbolByIndex(i)
		if symbol:getSymbolID() == "Asterisk" then
			symbolsAPI:removeSymbolByIndex(i)
		end
	end
	
	for i=1,#ZoneNames do
		drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
	end

	ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
	ModData.transmit("MoreDifficultZones")
	self:close()
end


function SDmap.CreateNewZone:onClickNested(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.CreateNewZone:onClickSubnested(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.CreateNewZone:onClickToxic(_clickedOption, _ticked)
	if _clickedOption == 1 then
		self.fullHighlight = _ticked;
	end;
end

function SDmap.CreateNewZone:createChildren()
	
    ISPanel.createChildren(self)
	
	local newzone = "Zone #" .. ZombRand(1,10000)
	
    local emptyheight = self.height/80
    local lblheight = self.height/12.5
    self.lbl = ISLabel:new(26.5*emptyheight, emptyheight+3, lblheight, "New Zone", 1, 1, 1, 1.0, UIFont.Large, true);
    self.lbl:initialise();
    self.lbl:instantiate();
    self:addChild(self.lbl);


    local buttonheight = self.height/12
    local buttonwidth = self.width - 66*emptyheight

					 --ISButton:new (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
    self.buttonclose = ISButton:new(50*emptyheight, self.height -emptyheight -buttonheight-0 ,buttonwidth,buttonheight , "Close", self, self.close);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);
	
	local buttonheight = self.height/12
    local buttonwidth = self.width - 66*emptyheight

					 --ISButton:new (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
    self.buttonclose = ISButton:new(3*emptyheight, self.height -emptyheight -buttonheight-0 ,buttonwidth,buttonheight , "Draw Zone", self, self.drawzone);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);

    local buttonnewy = 2*emptyheight + lblheight+5
	local buttonwidth = 160
	local buttonoffset = 70
	local buttonheight = 16

	self.x1y1 = ISTextEntryBox:new(self.x1 .. "," .. self.y1, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.x1y1.anchorTop = false
    self.x1y1.anchorBottom = false
	self.x1y1:initialise();
	self.x1y1:instantiate();
	self:addChild(self.x1y1);
	
	buttonnewy = buttonnewy + lblheight
	self.x2y2 = ISTextEntryBox:new(self.x2 .. "," .. self.y2, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.x2y2.anchorTop = false
    self.x2y2.anchorBottom = false
	self.x2y2:initialise();
	self.x2y2:instantiate();
	self:addChild(self.x2y2);
	
	buttonnewy = buttonnewy + lblheight
	self.ztier = ISTextEntryBox:new("3", buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.ztier.anchorTop = false
    self.ztier.anchorBottom = false
	self.ztier:initialise();
	self.ztier:instantiate();
	self:addChild(self.ztier);
	
	buttonnewy = buttonnewy + lblheight
	self.zname = ISTextEntryBox:new(newzone, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zname.anchorTop = false
    self.zname.anchorBottom = false
	self.zname:initialise();
	self.zname:instantiate();
	self:addChild(self.zname);
	
	--[[buttonnewy = buttonnewy + lblheight
	if not nested then nested = "nil" end
	self.znested = ISTextEntryBox:new(nested, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.znested.anchorTop = false
    self.znested.anchorBottom = false
	self.znested:initialise();
	self.znested:instantiate();
	self:addChild(self.znested);]]
	
	buttonnewy = buttonnewy + lblheight
	self.znested = ISTickBox:new(buttonoffset+3*emptyheight, buttonnewy, 20, 18, "", self, self.onClickNested);
	self.znested:initialise();
	self.znested:instantiate();
	self.znested.selected[1] = false;
	self.znested:addOption("");
	self:addChild(self.znested);
	
	self.zsubnested = ISTickBox:new(2*buttonoffset+12*emptyheight, buttonnewy, 20, 18, "", self, self.onClickSubnested);
	self.zsubnested:initialise();
	self.zsubnested:instantiate();
	self.zsubnested.selected[1] = false;
	self.zsubnested:addOption("");
	self:addChild(self.zsubnested);
	
	buttonnewy = buttonnewy + lblheight
	--[[if not toxic then toxic = "nil" end
	self.ztoxic = ISTextEntryBox:new(toxic, buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.ztoxic.anchorTop = false
    self.ztoxic.anchorBottom = false
	self.ztoxic:initialise();
	self.ztoxic:instantiate();
	self:addChild(self.ztoxic);]]
	self.ztoxic = ISTickBox:new(buttonoffset+3*emptyheight, buttonnewy, 20, 18, "", self, self.onClickToxic);
	self.ztoxic:initialise();
	self.ztoxic:instantiate();
	self.ztoxic.selected[1] = false;
	self.ztoxic:addOption("");
	self:addChild(self.ztoxic);
	
	buttonnewy = buttonnewy + lblheight
	self.zsprinter = ISTextEntryBox:new("0", buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zsprinter.anchorTop = false
    self.zsprinter.anchorBottom = false
	self.zsprinter:initialise();
	self.zsprinter:instantiate();
	self:addChild(self.zsprinter);
	
	buttonnewy = buttonnewy + lblheight
	self.zpinpoint = ISTextEntryBox:new("0", buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zpinpoint.anchorTop = false
    self.zpinpoint.anchorBottom = false
	self.zpinpoint:initialise();
	self.zpinpoint:instantiate();
	self:addChild(self.zpinpoint);
	
	buttonnewy = buttonnewy + lblheight
	self.zcognition = ISTextEntryBox:new("0", buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zcognition.anchorTop = false
    self.zcognition.anchorBottom = false
	self.zcognition:initialise();
	self.zcognition:instantiate();
	self:addChild(self.zcognition);
	
	buttonnewy = buttonnewy + lblheight
	self.zhealth = ISTextEntryBox:new("2.1", buttonoffset+3*emptyheight, buttonnewy, buttonwidth, buttonheight);
	self.zhealth.anchorTop = false
    self.zhealth.anchorBottom = false
	self.zhealth:initialise();
	self.zhealth:instantiate();
	self:addChild(self.zhealth);

end

--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--

function SDmap.CreateNewZone:prerender()

	if self.background then
		self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
		self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end
	
	local emptyheight = math.floor(2*self.height/50);
	local lblheight = self.height/11.5
	lblheight = emptyheight + lblheight
	self:drawText("               X1,Y1:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("               X2,Y2:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("                 Tier#:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("               Name:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("            Nested:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	self:drawText("                                                 Sub Nested:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("             Toxic:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("    Sprinter%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("   Pinpoint%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("Cognition%:", emptyheight, lblheight,1,1,1,1,UIFont.Small);
	
	lblheight = 2*emptyheight + lblheight
	self:drawText("      Health:", emptyheight, lblheight,1,1,1,1,UIFont.Small);

end

function SDmap.CreateNewZone:onMouseUp(x, y)
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

function SDmap.CreateNewZone:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function SDmap.CreateNewZone:onMouseDown(x, y)
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

function SDmap.CreateNewZone:onMouseMoveOutside(dx, dy)
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

function SDmap.CreateNewZone:onMouseMove(dx, dy)
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
--**
--************************************************************************--
function SDmap.CreateNewZone:new(x, y, width, height, x1, y1, x2, y2, mapAPI)
	local o = {}
	--o.data = {}
	local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	self.mapAPI = mapAPI
	o.x = x;
	o.y = y;
	o.x1 = x1;
	o.y1 = y1;
	o.x2 = x2;
	o.y2 = y2;
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
	o.zone = zone
   return o
end