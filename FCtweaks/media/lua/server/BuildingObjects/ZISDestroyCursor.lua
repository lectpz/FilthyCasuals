local oldCanDestroy = ISDestroyCursor.canDestroy
function ISDestroyCursor:canDestroy(object)
	if not (isAdmin()) then
		local x = object:getX()
		local y = object:getY()
	
		local x1cc = 19639
		local y1cc = 127
		
		local x1 = x1cc-3
		local y1 = y1cc-3
		local x2 = x1cc+3
		local y2 = y1cc+3

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			--print("stopped from destroying")
			--self:stop();
			return false
		else
			return oldCanDestroy(self,object)
		end
	end
	return oldCanDestroy(self,object)
end