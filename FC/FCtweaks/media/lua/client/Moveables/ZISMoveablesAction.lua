local oldISMoveablesAction=ISMoveablesAction.isValid

function ISMoveablesAction:isValid()
	if not (isAdmin()) then
		local x = getPlayer():getX()
		local y = getPlayer():getY()
		
		local x1cc = 19639
		local y1cc = 127
		
		local x1 = x1cc-3
		local y1 = y1cc-3
		local x2 = x1cc+3
		local y2 = y1cc+3

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			--self:stop();
			return false
		else
			return oldISMoveablesAction(self)
		end
	else 
		return oldISMoveablesAction(self)
	end
end