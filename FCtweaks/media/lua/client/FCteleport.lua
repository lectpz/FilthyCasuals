function FCteleport(items, result, player)

	local safehouse = SafeHouse.hasSafehouse(player)
	
	if safehouse then
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		player:setX(x1)
		player:setY(y1)
		player:setLx(x1)
		player:setLy(y1)
	else
		return
	end	

end