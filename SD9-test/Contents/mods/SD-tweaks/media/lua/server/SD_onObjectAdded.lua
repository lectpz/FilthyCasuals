local function OnObjectAdded(object)
	--if isAdmin() or isDebugEnabled() then return end
	if not instanceof(object, "IsoThumpable") then return end
	local sq = object:getSquare()
	if not sq then return end
	if sq:isOutside() or SafeHouse.getSafeHouse(sq) then return end
	local tier, zone = checkZoneAtXY(sq:getX(), sq:getY())
	if zone == "CC" then return end
	object:setHealth(0.1)
end

Events.OnObjectAdded.Add(OnObjectAdded)