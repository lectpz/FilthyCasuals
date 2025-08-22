local ISCraftAction_o_isValid = ISCraftAction.isValid
function ISCraftAction:isValid()
	if isAdmin() or isDebugEnabled() then return ISCraftAction_o_isValid(self) end
	
	--[[local parent = self.container:getParent()
	if parent and parent:getModData().owner and not instanceof(parent, "BaseVehicle") then
		player:Say("I cannot craft out of a player shop.")
		return false
	end
	local canBeDoneFromFloor, containers = self.containers
	for i=0,containers:size()-1 do
		local container = containers:get(i)
		local containersParent = container:getParent()
		if containersParent and containersParent:getModData().owner and not instanceof(containersParent, "BaseVehicle") then
			player:Say("I cannot craft out of a player shop.")
			return false
		end
	end]]
	
	local player = self.character
	local x = player:getX()
	local y = player:getY()
	local coords = {
		11200, 8806, 11280, 8883,--east shops
		11108, 8778, 11152, 8810,--north shops
		11165, 8775, 11233, 8796,--north shops 2
		11120, 8885, 11139, 8933,--south shops 1
		11139, 8885, 11280, 8991,--south shops 2
		11247, 8771, 11327, 8994,--east shops 2
	}
	local sqObj = getCell():getOrCreateGridSquare(x,y,0);
	
	local function checkCCshopCoords(x, y, coords)
		for i=1, #coords, 4 do
			local xa, ya, xb, yb = coords[i], coords[i+1], coords[i+2], coords[i+3]
			if x >= xa and y >= ya and x <= xb and y <= yb then return true end
		end
		return false
	end

	local isOwnSafeHouse = SafeHouse.hasSafehouse(player)

	if ISTradingUI.instance and ISTradingUI.instance:isVisible() then
		player:Say("It's rude to do that during a trade.")
		return false
	elseif SafeHouse.getSafeHouse(sqObj) then
		if isOwnSafeHouse then
			local shx1 = isOwnSafeHouse:getX()
			local shy1 = isOwnSafeHouse:getY()
			local shx2 = isOwnSafeHouse:getW() + shx1
			local shy2 = isOwnSafeHouse:getH() + shy1
			
			if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
				return ISCraftAction_o_isValid(self)
			end
		end
		player:Say("I cannot perform any crafting actions while inside someone else's SafeHouse limits.")
		return false
	elseif checkCCshopCoords(x, y, coords) then
	--elseif parent and parent:getModData().owner and not instanceof(parent, "BaseVehicle") then
		--player:setHaloNote("I cannot bulk pack or unpack items while inside the CC shop area.", 236, 131, 190, 50)
		player:Say("I cannot perform any crafting actions while inside the CC shop area.")
		return false
	else
		return ISCraftAction_o_isValid(self)
	end
end
--ISTradingUI.instance and ISTradingUI.instance:isVisible()