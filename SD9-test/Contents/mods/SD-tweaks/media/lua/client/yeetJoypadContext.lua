local function yeetJoypadContext(player, context, worldobjects, _)
	if isAdmin() or isDebugEnabled() then return end
	local playerObj = getSpecificPlayer(player);
	local x = playerObj:getX()
	local y = playerObj:getY()
	local safehouse = SafeHouse.hasSafehouse(playerObj)
	local sqObj = getCell():getOrCreateGridSquare(x,y,0)

	if SafeHouse.getSafeHouse(sqObj) then
		if safehouse then
			local x1 = safehouse:getX()
			local y1 = safehouse:getY()
			local x2 = safehouse:getW() + x1
			local y2 = safehouse:getH() + y1
			
			if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				return
			end
		end
		
		local contextoptions = context:getMenuOptionNames()
		for k, v in pairs(contextoptions) do
			local sitongroundtext = getText("ContextMenu_SitGround")
			local sleeptext = getText("ContextMenu_Sleep")
			local sleepongroundtext = getText("ContextMenu_SleepOnGround") 
			
			if k ~= sitongroundtext and k ~= sleeptext and k ~= sleepongroundtext then
				context:removeOptionByName(k)
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(yeetJoypadContext);