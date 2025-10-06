local args = {}
local xferTable = {}

ISInventoryTransferAction.o_isValid = ISInventoryTransferAction.isValid;
function ISInventoryTransferAction:isValid()
	local zonetier, zonename, x, y, tier, nested, sprinter, pinpoint, cognition, base_health, event = checkZone()
	
	local iFT = self.item:getFullType()
	local itemID = self.item:getID()
	local iMD = self.item:getModData()
	
	local sourceContainer = self.srcContainer:getType()
	local destinationContainer = self.destContainer:getType()
	
	if sourceContainer == "none" then 
		sourceContainer = "Player Inventory" 
	end
	
	if destinationContainer == "none" then 
		destinationContainer = "Player Inventory" 
	end

	local player = getSpecificPlayer(0)

	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	args.player_z = player:getZ()
	args.zonename = zonename
	args.zonetier = zonetier
	args.srcContainer = sourceContainer
	args.destContainer = destinationContainer
	
	args.prevOwner = iMD["_O"]
	
	if event and args.prevOwner and args.prevOwner ~= args.player_name then
		player:Say("This item does not belong to me")
		return false
	end
	
	if args.prevOwner and args.prevOwner ~= args.player_name then
		if args.srcContainer == "inventorymale" or args.srcContainer == "inventoryfemale" then
			if iMD.SoulBuffs and #iMD.SoulBuffs > 0 and iMD.Tier then
				args.SoulBuff = ""
				
				for i=1,#iMD.SoulBuffs do
					local comma = ","
					if i == #iMD.SoulBuffs then comma = "" end
					args.SoulBuff = args.SoulBuff .. iMD.SoulBuffs[i] .. comma
				end
				
				args.Tier = iMD.Tier
				if not xferTable.itemID then
					sendClientCommand(player, 'sdLogger', 'prevOwnerSFJTransfer', args);
					xferTable.itemID = true
				end
			else
				if not xferTable.itemID then
					sendClientCommand(player, 'sdLogger', 'prevOwnerItemTransfer', args);
					xferTable.itemID = true
				end
			end
		end
	end
	return self:o_isValid()
end

local function clear_xferTable()
	xferTable = {}
end
Events.EveryTenMinutes.Add(clear_xferTable)