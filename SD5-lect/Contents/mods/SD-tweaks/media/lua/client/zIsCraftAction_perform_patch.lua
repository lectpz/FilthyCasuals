local ISCraftAction_o_perform = ISCraftAction.perform
function ISCraftAction:perform()
	local player = self.character
	local x = player:getX()
	local y = player:getY()
	local x1, y1 = 11280, 8778
	local x2, y2 = 11384, 8932
	
	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
		--player:setHaloNote("I cannot bulk pack or unpack items while inside the CC shop area.", 236, 131, 190, 50)
		player:Say("I cannot perform any crafting actions while inside the CC shop area.")
	else
		ISCraftAction_o_perform(self)
	end
end