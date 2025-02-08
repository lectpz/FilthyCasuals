if not isServer() then return end

ZoneLogger = {}
ZoneLogger.fileName = "static/zoneData.txt"

local function writeToFile(line)
    local file = getFileWriter(ZoneLogger.fileName, true, false)
    file:write(line .. "\n")
    file:close()
end

local function onEveryTenMinutes()
    writeTimeToFile()
end

Events.OnServerStarted.Add(function()
    for k,v in pairs(Zone.list) do
        local line = string.format("%s,%d,%d,%d,%d", k, v[1], v[2], v[3], v[4])
        writeToFile(line)
    end
end)