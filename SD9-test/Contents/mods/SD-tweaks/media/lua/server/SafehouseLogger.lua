if not isServer() then return end

local SafehouseLogger = {}
SafehouseLogger.config = {
    fileName = "static/safehouses.txt"
}


local function safehouseToString(safehouse)
    local owner = safehouse:getOwner()
    local members = {}
    
    for i = 0, safehouse:getPlayers():size() - 1 do
        table.insert(members, safehouse:getPlayers():get(i))
    end
    
    local x2 = safehouse:getX() + safehouse:getW()
    local y2 = safehouse:getY() + safehouse:getH()
    
    return string.format("%s, %d, %d, %d, %d, %s",
        tostring(owner),
        safehouse:getX(),
        safehouse:getY(),
        x2,
        y2,
        table.concat(members, ",")
    )
end

-- Export all safehouses
local function exportSafehouses()
    local safehouses = SafeHouse.getSafehouseList()
    if not safehouses then
        print("[SafehouseLogger] Error: Could not get safehouse list")
        return
    end
    
    -- Save to file
    local path = SafehouseLogger.config.fileName
    local file = getFileWriter(path, true, false)
    
    -- Write each safehouse on a new line
    for i = 0, safehouses:size() - 1 do
        local safehouse = safehouses:get(i)
        if safehouse then
            local line = safehouseToString(safehouse)
            file:write(line .. "\n")
        end
    end
    
    file:close()
    print("[SafehouseLogger] Exported safehouses to " .. path)
end

-- Initialize mod when Events is available
local function initializeMod()
    if Events then
        Events.OnServerStarted.Add(function()
            print("[SafehouseLogger] Mod initialized")
            exportSafehouses()
        end)

        Events.OnSafehousesChanged.Add(exportSafehouses)
        
        return true
    end
    return false
end

if not initializeMod() then
    Events.OnGameBoot.Add(function()
        initializeMod()
    end)
end

return SafehouseLogger