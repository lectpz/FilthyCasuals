ISRemoveGlass.o_perform = ISRemoveGlass.perform
function ISRemoveGlass:perform()
	self:o_perform()
	local charSq = self.character:getSquare()
	local worldItems = charSq:getObjects();
	for i=0, worldItems:size()-1 do
		item = worldItems:get(i)
		if instanceof(item,"IsoBrokenGlass") then
			brokenGlass = item
			--ISTimedActionQueue.add(ISPickupBrokenGlass:new(self.character, brokenGlass, 1));
			local moveable = ISMoveableTools.isObjectMoveable(brokenGlass)
			moveable:pickUpMoveable( self.character, charSq, brokenGlass, true )
			break
		end
	end
end