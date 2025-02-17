local function OnObjectAdded(object)
	if isAdmin() or isDebugEnabled() then 
		object:setCanPassThrough(false)
		object:setIsThumpable(false);
		object:transmitCompleteItemToServer()
		object:transmitCompleteItemToClients()
		return
	end
	local sq = object:getSquare()
	if SafeHouse.getSafeHouse(sq) then return end
	object:setHealth(0.1)
end

Events.OnObjectAdded.Add(OnObjectAdded)