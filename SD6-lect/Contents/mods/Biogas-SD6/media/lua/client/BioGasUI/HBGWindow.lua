require "ISUI/ISCollapsableWindow"
require "ISUI/ISLayoutManager"

BioGasStatusWindow = ISCollapsableWindow:derive("BioGasStatusWindow")

function BioGasStatusWindow:createChildren()
	ISCollapsableWindow.createChildren(self);
	local th = self:titleBarHeight()
	self.panel = ISTabPanel:new(0, th, self.width, self.height-th);
	self.panel:initialise();
	self.panel.tabPadX = 15;
	self.panel.equalTabWidth = false;
	self:addChild(self.panel);
	--self.panel:setOnTabTornOff(self, BioGasStatusWindow.onTabTornOff)

	self.detailsView = BioGasWindowDetails:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.panel:addView(getText("IGUI_BioGas_Window_Details_TabTitle"), self.detailsView)

	ISLayoutManager.RegisterWindow('BioGasStatusWindow', BioGasStatusWindow, self)
end

function BioGasStatusWindow:new(x, y, width, height)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	o:setResizable(false)
	o.title = getText("IGUI_BioGas_Window_Title")

	BioGasStatusWindow.instance = o
	return o
end

function BioGasStatusWindow.OnOpenPanel(worldobjects,square,player)
	local instance = BioGasStatusWindow.instance or BioGasStatusWindow:new(100, 100, 580, 400)
	instance:addToUIManager()

	instance.square = square
	instance.luaHBG = CBioGasSystem.instance:getLuaObjectAt(square:getX(),square:getY(),square:getZ())
	instance.playerNum = player
	instance.player = getSpecificPlayer(player)
end

function BioGasStatusWindow:close()
	self:removeFromUIManager()
end