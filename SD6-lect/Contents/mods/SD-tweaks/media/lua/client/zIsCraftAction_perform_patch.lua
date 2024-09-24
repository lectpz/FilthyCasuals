local ISCraftAction_o_perform = ISCraftAction.perform
function ISCraftAction:perform()
	local player = self.character
	local x = player:getX()
	local y = player:getY()
	local x1, y1 = 11107, 8773
	local x2, y2 = 11239, 8942
	local sqObj = getCell():getOrCreateGridSquare(x,y,0);

	local isOwnSafeHouse = SafeHouse.hasSafehouse(player)

	if ISTradingUI.instance and ISTradingUI.instance:isVisible() then
		player:Say("It's rude to do that during a trade.")
	elseif SafeHouse.getSafeHouse(sqObj) then
		if isOwnSafeHouse then
			local shx1 = isOwnSafeHouse:getX()
			local shy1 = isOwnSafeHouse:getY()
			local shx2 = isOwnSafeHouse:getW() + shx1
			local shy2 = isOwnSafeHouse:getH() + shy1
			
			if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
				ISCraftAction_o_perform(self)
				return
			end
		end
		player:Say("I cannot perform any crafting actions while inside someone else's SafeHouse limits.")
		self.character:StopAllActionQueue();
		local queue = ISTimedActionQueue.getTimedActionQueue(self.character);
		queue:clearQueue();
		self.character:PlayAnim("Idle")
		return
	elseif x >= x1 and y >= y1 and x <= x2 and y <= y2 then
		--player:setHaloNote("I cannot bulk pack or unpack items while inside the CC shop area.", 236, 131, 190, 50)
		player:Say("I cannot perform any crafting actions while inside the CC shop area.")
	else
		ISCraftAction_o_perform(self)
	end
end
--ISTradingUI.instance and ISTradingUI.instance:isVisible()