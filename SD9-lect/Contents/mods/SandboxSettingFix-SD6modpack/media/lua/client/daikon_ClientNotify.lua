local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

Daikon.SandboxOptionsSyncing.DownloadSettingsInitial = function ()
    Daikon.SandboxOptionsSyncing.DownloadSettings()
    Events.OnPlayerUpdate.Remove(Daikon.SandboxOptionsSyncing.DownloadSettingsInitial)
end

Daikon.SandboxOptionsSyncing.DownloadSettings = function ()
    ModData.request("UdderlyDaikonSandboxSyncFix")
end
Daikon.SandboxOptionsSyncing.SyncSettings = function(tableName, options)
    if tableName ~= "UdderlyDaikonSandboxSyncFix" then
        return
    end
    print("Syncing the sandbox options")    --code for loading Sandbox options from Mod Data by Udderly Evelyn
    local currentOptions = SandboxOptions.getInstance()
    if options ~= nil then
        for key,value in pairs(options) do
            ---@type SandboxOptions.SandboxOption
            local option = currentOptions:getOptionByName(key)
            if option ~= nil then
                if option:getType() == "string" then
                    if string.sub(value,1,1) == "\"" and string.sub(value,-1,-1) == "\"" then
                        value = string.sub(value,2,-2)
                    end
                end
                option:asConfigOption():parse(value)
                ---@type ConfigOption
                option = option:asConfigOption()
                --[[if isDebugEnabled() then
                    print("Updated Sandbox Value: "..key.." -> "..value)

                end]]
            end
        end
        print("Finished syncing the options")
        currentOptions:toLua()
    else
        print("No sandbox options to sync yet")
    end
end


Events.OnPlayerUpdate.Add(Daikon.SandboxOptionsSyncing.DownloadSettingsInitial)
Events.OnReceiveGlobalModData.Add(Daikon.SandboxOptionsSyncing.SyncSettings)
return Daikon ---> REMEMBER THIS NEEDS TO BE AT THE END OF THE FILE