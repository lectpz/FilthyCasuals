if not isServer() then return end

ZoneLogger = {}
ZoneLogger.fileName = "static/zoneData.txt"

local function writeToFile(line)
    local startTime = getTimestampMs()
    local file = getFileWriter(ZoneLogger.fileName, true, false)
    file:write(line .. "\n")
    file:close()
    local endTime = getTimestampMs()
    print(string.format("Zone data write took %d ms", endTime - startTime))
end

Events.OnServerStarted.Add(function()
    local zoneLines = {}
    for k,v in pairs(Zone.list) do
        local line = string.format("%s,%d,%d,%d,%d", k, v[1], v[2], v[3], v[4])
        table.insert(zoneLines, line)
    end
    
    if #zoneLines > 0 then
        local startTime = getTimestampMs()
        local file = getFileWriter(ZoneLogger.fileName, true, false)
        for _, line in ipairs(zoneLines) do
            file:write(line .. "\n")
        end
        file:close()
        local endTime = getTimestampMs()
        print(string.format("Zone data write took %d ms for %d zones", endTime - startTime, #zoneLines))
    end

    saveAllItemsToFile()

    saveAllBusStopsToJsonFile()
end)

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

function saveAllItemsToFile()
    local startTime = getTimestampMs()
    local itemCount = 0
    local allItems = getAllItems()
    local itemsData = {}
    
    for i = 0, allItems:size() - 1 do
        local item = allItems:get(i)
        if item then
            local itemID = item:getFullName()
            local displayName = item:getDisplayName()
            
            if itemID and displayName then
                itemsData[itemID] = displayName
                itemCount = itemCount + 1
            end
        end
    end
    
    local file = getFileWriter("static/all_items.json", true, false)
    file:write("{\n")
    
    local isFirst = true
    for itemID, displayName in pairs(itemsData) do
        if not isFirst then
            file:write(",\n")
        end

        local escapedName = string.gsub(displayName, '"', '\\"')
        file:write(string.format('  "%s": "%s"', itemID, escapedName))
        isFirst = false
    end
    
    file:write("\n}")
    file:close()
    
    local endTime = getTimestampMs()
    print(string.format("Saved %d items to static/all_items.json in %d ms", itemCount, endTime - startTime))
end

function saveAllBusStopsToJsonFile()
    local startTime = getTimestampMs()
    local busStops = {}
    local busStopCount = 0
    
    local busStopsString = SandboxVars.SDbus.BusStops
    if not busStopsString or busStopsString == "" then
        print("No bus stops data found in sandbox")
        return
    end
    
    for busStop in busStopsString:gmatch("[^;]+") do
        if busStop and busStop ~= "" then
            local parts = {}
            for part in busStop:gmatch("[^:]+") do
                table.insert(parts, part)
            end
            
            if #parts >= 5 then
                local code = parts[1]
                local name = parts[2]
                local x = tonumber(parts[3])
                local y = tonumber(parts[4])
                local z = tonumber(parts[5])
                
                if code and name and x and y and z then
                    busStops[code] = {
                        name = name,
                        x = x,
                        y = y,
                        z = z
                    }
                    busStopCount = busStopCount + 1
                end
            end
        end
    end
    
    local file = getFileWriter("static/bus_stops.json", true, false)
    file:write("{\n")
    
    local isFirst = true
    for code, data in pairs(busStops) do
        if not isFirst then
            file:write(",\n")
        end
        
        local escapedName = string.gsub(data.name, '"', '\\"')
        
        file:write(string.format('  "%s": {\n', code))
        file:write(string.format('    "name": "%s",\n', escapedName))
        file:write(string.format('    "x": %d,\n', data.x))
        file:write(string.format('    "y": %d,\n', data.y))
        file:write(string.format('    "z": %d\n', data.z))
        file:write('  }')
        
        isFirst = false
    end
    
    file:write("\n}")
    file:close()
    
    local endTime = getTimestampMs()
    print(string.format("Saved %d bus stops to static/bus_stops.json in %d ms", busStopCount, endTime - startTime))
end
