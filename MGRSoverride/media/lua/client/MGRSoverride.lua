require "ISUI/Maps/ISWorldMap"

local ISWorldMap_ShowWorldMap = ISWorldMap.ShowWorldMap
function ISWorldMap.ShowWorldMap(playerNum)
    ISWorldMap_ShowWorldMap(playerNum)
    if ISWorldMap_instance then ISWorldMap_instance:setShowCellGrid(false) end
end