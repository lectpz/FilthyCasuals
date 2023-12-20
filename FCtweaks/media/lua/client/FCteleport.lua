function FCteleport()

	local player = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(player)
	
	if safehouse then
		local x = safehouse:getX()
		local y = safehouse:getY()
		player:setX(x)
		player:setY(y)
		player:setLx(x)
		player:setLy(y)
	else
		return
	end	

end

function testFCteleport(sourceItem, result)

	local player = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(player)
	
	if player:getStats():getNumVisibleZombies() > 0 or player:getStats():getNumChasingZombies() > 0 or player:getStats():getNumVeryCloseZombies() > 0 then
		player:Say("It doesn't feel safe to do that.")
		return false
	elseif not safehouse then
		player:Say("It would be nice if I had a Safehouse though.")
		return false
	else
		return true
	end
	
end