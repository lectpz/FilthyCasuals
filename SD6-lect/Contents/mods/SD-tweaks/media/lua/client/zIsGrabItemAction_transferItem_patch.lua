local args = {}

ISGrabItemAction.o_transferItem = ISGrabItemAction.transferItem
function ISGrabItemAction:transferItem(item)
	local zonetier, zonename, x, y = checkZone()
	local gotItem = item:getItem()
	local iFT = gotItem:getFullType()
	local itemID = gotItem:getID()
	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	args.player_z = getSpecificPlayer(0):getZ()
	args.zonename = zonename
	args.zonetier = zonetier
	
	local playerSQ = getCell():getOrCreateGridSquare(x,y,0)
	local SafeHouseSQ = SafeHouse.getSafeHouse(playerSQ)
	--SafeHouseSQ = true
	if SafeHouseSQ then
		local safehouse = SafeHouse.hasSafehouse(self.character)
		--safehouse = false
		if safehouse then
			local x1 = safehouse:getX()
			local y1 = safehouse:getY()
			local x2 = safehouse:getW() + x1
			local y2 = safehouse:getH() + y1
			if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				self:o_transferItem(item)
				return
			end
		end
		self.character:Say("I can't move items in someone else's SafeHouse.")
		args.SafeHouseOwner = SafehouseSQ:getOwner()
		sendClientCommand(self.character, 'sdLogger', 'ItemTransferSH', args);
	else
		self:o_transferItem(item)
	end
end