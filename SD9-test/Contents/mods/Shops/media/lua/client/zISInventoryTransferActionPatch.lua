local oldIsValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local valid = oldIsValid(self)
    local isOwner = false
    if self.srcContainer then
        local parent = self.srcContainer:getParent()
        if parent and parent:getModData().owner and not instanceof(parent, "BaseVehicle") then
            isOwner = self.character:getUsername() == parent:getModData().owner
            if isAdmin() then isOwner = true end
            return (valid and isOwner)
        end
    end
    
	if not self.item then return false end
	if isAdmin() or isDebugEnabled() then return valid end
	if self.destContainer then
		local parent = self.destContainer:getParent()
		if parent and parent:getModData().owner and not instanceof(parent, "BaseVehicle") and not self.item:getModData().price then
			self.character:Say("I cannot place unpriced items into a shop container.")
			return false
		end
	end	
	return valid
end