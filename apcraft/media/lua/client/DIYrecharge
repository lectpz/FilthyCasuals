function DIYrecharge(items, result, player)
    for i = 1, #items do
        local item = items[i]
        if (item:getType() == "CarBattery1" or item:getType() == "CarBattery2" or item:getType() == "CarBattery3") then
            return item:setUsedDelta(0)
        end
    end
end
