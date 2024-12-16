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
    local temperature = math.floor(getClimateManager():getTemperature() * 10) / 10
    
    return string.format("%d-%02d-%02d %02d:%02d %.1f°F", 
        year, month, day, hour, minute, temperature)
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