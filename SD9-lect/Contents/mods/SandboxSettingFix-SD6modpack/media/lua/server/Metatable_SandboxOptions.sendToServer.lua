--[[local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

local metatable = __classmetatables[SandboxOptions.class].__index
local old_SendToServer = metatable.sendToServer
local scheduledRefresh
function metatable.sendToServer(self)
    old_SendToServer(self)
    if isServer() then
        Daikon.SandboxOptionsSyncing.UpdateGlobalModData()
        Daikon.SandboxOptionsSyncing.ForceClientsToUpdate()
    end
    if isClient() then
        scheduledRefresh = getTimestamp()+2

    end

end

local lastTimestamp
local function tryRefresh()
    local timestamp = getTimestamp()
    if lastTimestamp ~=timestamp then
        lastTimestamp = timestamp
        if scheduledRefresh and scheduledRefresh < timestamp then
            Daikon.SandboxOptionsSyncing.Commands["RefreshModData"]({})
            scheduledRefresh = nil
        end
    end
end

Events.OnTick.Add(tryRefresh)]]

local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

local metatable = __classmetatables[SandboxOptions.class].__index
local old_SendToServer = metatable.sendToServer
local scheduledRefresh
function metatable.sendToServer(self)
    old_SendToServer(self)
    if isServer() then
        Daikon.SandboxOptionsSyncing.UpdateGlobalModData()
        Daikon.SandboxOptionsSyncing.ForceClientsToUpdate()
    end
    if isClient() then
        scheduledRefresh = true
    end
end


local function tryRefresh()
	if scheduledRefresh then--and scheduledRefresh < timestamp then
		Daikon.SandboxOptionsSyncing.Commands["RefreshModData"]({})
		scheduledRefresh = nil
	end
end

--Events.OnTick.Add(tryRefresh)
Events.EveryOneMinute.Add(tryRefresh)