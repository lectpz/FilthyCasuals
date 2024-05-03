local oldIsValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local valid = oldIsValid(self)
    local isOwner = false
    if self.srcContainer then
        local parent = self.srcContainer:getParent()
        if parent and parent:getModData().owner then
            isOwner = self.character:getUsername() == parent:getModData().owner
            if isAdmin() then isOwner = true end
            return (valid and isOwner)
        end
    end
    return valid
end