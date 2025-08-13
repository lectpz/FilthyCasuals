local vanillaRemoveAll = ISInventoryPane.removeAll

function ISInventoryPane:removeAll(player)
	local playerObj = getSpecificPlayer(0)
    local isInSafeHouse = false
    local isInCC = false

    local isOwnSafeHouse = SafeHouse.hasSafehouse(playerObj)
    local x = playerObj:getX()
    local y = playerObj:getY()

    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX() - 15
        local shy1 = isOwnSafeHouse:getY() - 15
        local shx2 = isOwnSafeHouse:getW() + shx1 + 15
        local shy2 = isOwnSafeHouse:getH() + shy1 + 15

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
            isInSafeHouse = true
        else
            isInSafeHouse = false
        end
    end

    local tier, zone = checkZone()

    if zone == "CC" then
        isInCC = true
    else
        isInCC = false
    end

    if isInSafeHouse or isInCC then
        vanillaRemoveAll(self, player)
    else
        local object = self.inventory:getParent()
        local args = { x = object:getX(), y = object:getY(), z = object:getZ(), index = object:getObjectIndex() }
        sendClientCommand(playerObj, 'object', 'emptyTrash', args)
    end
end