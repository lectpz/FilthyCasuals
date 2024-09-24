local args = {}

local o_isForceDropHeavyItem = isForceDropHeavyItem
function isForceDropHeavyItem(item)
	local zonetier, zonename, x, y = checkZone()
	local playerObj = getSpecificPlayer(0)
    local isXferHeavyItem = playerObj:getModData().isXferHeavyItem
	if isXferHeavyItem then
		args.player_name = getOnlineUsername()
		args.player_x = math.floor(x)
		args.player_y = math.floor(y)
		args.zonename = zonename
		args.zonetier = zonetier
		sendClientCommand(playerObj, 'sdLogger', 'isXferHeavyItem', args);
		
		return false
	else
		o_isForceDropHeavyItem(item)
	end
end