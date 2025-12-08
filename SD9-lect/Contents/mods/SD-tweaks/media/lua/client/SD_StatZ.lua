local StatZSettings = require("StatZSettings")

local StatZSettings_LoadFromFile = StatZSettings.LoadFromFile
function StatZSettings:LoadFromFile()
    StatZSettings_LoadFromFile(self)
    if self.updateRate < 20 then
        self.updateRate = 20
    end
end

local StatZSettings_new = StatZSettings.new
function StatZSettings:new()
local o = StatZSettings_new(self)
    o.updateRate = 30
    return o
end

local StatZValuePanel = require("StatZValuePanel")
local StatZValuePanel_show = StatZValuePanel.show
function StatZValuePanel:show()
	StatZValuePanel_show(self)
	local StatZ_toggle = ModData.getOrCreate("StatZ_toggle")
	StatZ_toggle["toggle"] = false
end

local StatZValuePanel_hide = StatZValuePanel.hide
function StatZValuePanel:hide()
	StatZValuePanel_hide(self)
	local StatZ_toggle = ModData.getOrCreate("StatZ_toggle")
	StatZ_toggle["toggle"] = true
end

local StatZValuePanel_initialise = StatZValuePanel.initialise
function StatZValuePanel:initialise()
	local StatZ_toggle = ModData.getOrCreate("StatZ_toggle")
	if StatZ_toggle and StatZ_toggle["toggle"] then
		ISPanel.initialise(self)
		ISLayoutManager.RegisterWindow('StatZValuePanel', StatZValuePanel, self)
		self:create()
		--self:show()
	else
		StatZValuePanel_initialise(self)
	end
end