require "ISObjectClickHandler"

function ISObjectClickHandler.doClickLightSwitch(object, playerNum, playerObj)
    if false then
        ISWorldObjectContextMenu.onToggleLight(nil, object, playerNum)
        return true
    end
    local playerSq = playerObj:getCurrentSquare()
    if object:getSquare():DistToProper(playerObj) >= 2 then return false end
    if playerSq:isWallTo(object:getSquare()) then return false end
    object:toggle()
	sendClientCommand(playerObj, 'mg_commands', 'update_generators', {sync=false})
    return true
end
