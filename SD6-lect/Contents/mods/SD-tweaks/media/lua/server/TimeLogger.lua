if not isServer() then return end

TimeLogger = {}
TimeLogger.fileName = "static/gameTime.txt"

local function getFormattedTime()
    local gameTime = getGameTime()
    local year = gameTime:getYear()
    local month = gameTime:getMonth() + 1
    local day = gameTime:getDay()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    
    return string.format("%d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
end

local function writeTimeToFile()
    local timeStr = getFormattedTime()
    local file = getFileWriter(TimeLogger.fileName, true, false)
    file:write(timeStr)
    file:close()
end

local function onEveryTenMinutes()
    writeTimeToFile()
end

Events.EveryTenMinutes.Add(onEveryTenMinutes)