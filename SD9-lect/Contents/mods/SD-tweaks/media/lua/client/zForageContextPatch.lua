local function onFillSearchIconContextMenu(context, self)
	local player = getSpecificPlayer(0)
	local isOwnSafeHouse = SafeHouse.hasSafehouse(player)
	local x = player:getX()
	local y = player:getY()

	if SafeHouse.getSafeHouse(self.square) then
		
		if isOwnSafeHouse then
			local shx1 = isOwnSafeHouse:getX()
			local shy1 = isOwnSafeHouse:getY()
			local shx2 = isOwnSafeHouse:getW() + shx1
			local shy2 = isOwnSafeHouse:getH() + shy1
			
			if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
				return
			end
		end
		
		local contextoptions = context:getMenuOptionNames()
		for k, v in pairs(contextoptions) do
			context:removeOptionByName(k)
		end
	end
end

Events.onFillSearchIconContextMenu.Add(onFillSearchIconContextMenu)
