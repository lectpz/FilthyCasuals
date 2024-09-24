local originalOnConfirmDelete = ISInventoryPane.onConfirmDelete

function ISInventoryPane:onConfirmDelete(button)
	local obj = self.inventory:getParent()
    if not obj or not instanceof(obj, "IsoObject") then return false end
	local container = obj:getContainer()
    if container then
        local parent = container:getParent()
        if parent and parent:getModData().owner then
			self.removeAllDialog:close()
			self.removeAllDialog = nil
		else
			originalOnConfirmDelete(self, button)
		end
	end
end