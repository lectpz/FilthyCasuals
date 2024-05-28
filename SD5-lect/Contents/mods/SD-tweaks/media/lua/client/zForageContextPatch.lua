--triggerEvent("onFillSearchIconContextMenu", contextMenu, self);
--[[
local function onFillSearchIconContextMenu(context, self)
	local player = getSpecificPlayer(0)
	local playerSQ = player:getSquare()
	local playerUSERNAME = player:getUsername()
	local safehouse = SafeHouse.hasSafehouse(player)
	local x = player:getX()
	local y = player:getY()
	
	if safehouse then
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
		
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			return
		end
	end
	
	function printTable(tbl)
		for k, v in pairs(tbl) do
			print(k, v)
		end
	end
	printTable(context:getMenuOptionNames())
	
	if SafeHouse.isSafeHouse(self.square, playerUSERNAME, true) then
		
		--local menuOptionNames = context:getMenuOptionNames()
		--local numOptions = #menuOptionNames

		--for i = numOptions, 1, -1 do
			--context:removeLastOption()
		--end
		



		local contextoptions = context:getMenuOptionNames()
		for k, v in pairs(contextoptions) do
			context:removeOptionByName(k)
		end

	end
end

Events.onFillSearchIconContextMenu.Add(onFillSearchIconContextMenu)
]]--