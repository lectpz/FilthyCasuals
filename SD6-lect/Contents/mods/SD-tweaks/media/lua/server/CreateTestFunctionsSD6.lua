require "recipecode"

function Recipe.OnTest.checkFullUseDelta(item)
    if item:getUsedDelta() < 1 then
		return false
	else
		return true
	end
end