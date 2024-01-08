function DIYtestcarbattery(item)
    if (item:getType() == "CarBattery1" or item:getType() == "CarBattery2" or item:getType() == "CarBattery3") and item:getUsedDelta() == 1 then
        return true
    else
        return false
    end
end