local oldIsRemoveButtonVisible = ISInventoryPage.isRemoveButtonVisible
function ISInventoryPage:isRemoveButtonVisible()
	local obj = self.inventory:getParent()
    if not obj or not instanceof(obj, "IsoObject") then return false end
	local container = obj:getContainer()
    if container then
        local parent = container:getParent()
        if parent and parent:getModData().owner then
            return false
        end
    end
    return oldIsRemoveButtonVisible(self)
end