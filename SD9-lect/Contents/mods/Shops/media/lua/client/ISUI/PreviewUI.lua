PreviewUI = ISCollapsableWindow:derive("PreviewUI");
PreviewUI.instance = nil;

local width = 400
local height = 250

PreviewScene = ISUI3DScene:derive("PreviewScene")
SwitchScene = ISUI3DScene:derive("SwitchScene")

function PreviewScene:new(x, y, width, height)
	local o = ISUI3DScene.new(self, x, y, width, height)
	return o
end

function SwitchScene:new(scene,x, y, width, height)
	local o = ISUI3DScene.new(self, x, y, width, height)
    o.previewScene = scene
	return o
end

function SwitchScene:onMouseMove(dx, dy)
    if self:getView() ~= self.previewScene:getView() then
        self.previewScene:setView(self:getView())
    end
    return
end

function PreviewUI:show(name,vehicleId)
    if PreviewUI.instance==nil then
        PreviewUI.instance = PreviewUI:new (0, 0, width, height,name,vehicleId);
        PreviewUI.instance:initialise();
        PreviewUI.instance:instantiate();
    end
    PreviewUI.instance.pinButton:setVisible(false)
    PreviewUI.instance.collapseButton:setVisible(false)
    PreviewUI.instance:addToUIManager();
    PreviewUI.instance:setVisible(true);
    return PreviewUI.instance;
end

function PreviewUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 10
    local y = 30

    local preview = PreviewScene:new(x, y, 380, 200)
    preview:initialise()
    preview:instantiate()
    preview:setAnchorTop(false)
    preview:setAnchorRight(false)
    preview:setAnchorBottom(true)
    preview:setView("Right")
    preview.javaObject:fromLua1("setZoom", 4)
    preview.javaObject:fromLua1("setDrawGrid", false)
    preview.javaObject:fromLua1("createVehicle", "previewVeh")
    preview.javaObject:fromLua2("setVehicleScript", "previewVeh", self.vehicleId)
    self:addChild(preview)

    local scenesNames = {'Left', 'Right', 'Top', 'Bottom', 'Front', 'Back'}
    for _,k in ipairs(scenesNames) do
		local view = SwitchScene:new(preview,x+40, 200, 40, 20)
		view:initialise()
		view:instantiate()
		view:setAnchorTop(false)
		view:setAnchorRight(false)
		view:setAnchorBottom(true)
		view:setView(k)
		view.javaObject:fromLua1("setZoom", 4)
		view.javaObject:fromLua1("setDrawGrid", false)
		view.javaObject:fromLua1("createVehicle", "switchView")
        view.javaObject:fromLua2("setVehicleScript", "switchView", self.vehicleId)
		self:addChild(view)
        x = x + 50
	end
    self:bringToTop()
end

function PreviewUI:close()
	ISCollapsableWindow.close(self);
    PreviewUI.instance:removeFromUIManager()
    PreviewUI.instance = nil
    self:removeFromUIManager()
end

function PreviewUI:new(x, y, width, height,name,vehicleId)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.title = name;
    o.vehicleId = vehicleId;
    o.resizable = false;
    return o
end