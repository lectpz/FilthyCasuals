require "ISUI/ISCollapsableWindow"
require "ISUI/ISLayoutManager"

DistilleryWindow = ISCollapsableWindow:derive("DistilleryWindow")

function DistilleryWindow:createChildren()
	ISCollapsableWindow.createChildren(self);
	local th = self:titleBarHeight()
	self.panel = ISTabPanel:new(0, th, self.width, self.height-th);
	self.panel:initialise();
	self.panel.tabPadX = 15;
	self.panel.equalTabWidth = false;
	self:addChild(self.panel);
	--self.panel:setOnTabTornOff(self, DistilleryWindow.onTabTornOff)

	self.detailsView = DistilleryWindowDetails:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.panel:addView(getText("IGUI_Distillery_Window_Details_TabTitle"), self.detailsView)

	ISLayoutManager.RegisterWindow('DistilleryWindow', DistilleryWindow, self)
end

function DistilleryWindow:new(x, y, width, height)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	o:setResizable(false)
	o.title = getText("IGUI_Distillery_Window_Title")

	DistilleryWindow.instance = o
	return o
end

function DistilleryWindow.OnOpenPanel(worldobjects,square,player)
	local instance = DistilleryWindow.instance or DistilleryWindow:new(100, 100, 580, 400)
	instance:addToUIManager()

	instance.square = square
	instance.luaDis = CDistillerySystem.instance:getLuaObjectAt(square:getX(),square:getY(),square:getZ())
	instance.playerNum = player
	instance.player = getSpecificPlayer(player)
end

function DistilleryWindow:close()
	self:removeFromUIManager()
end