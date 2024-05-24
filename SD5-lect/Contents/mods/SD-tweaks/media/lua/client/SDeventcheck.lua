require "SDZoneCheck"

local args = {}
-- function to scale crit and min/max dmg based on zone
local function eventCheck(character, handWeapon)

	if character ~= nil then 

		local eventenabled = SandboxVars.SDevents.enabled	
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		
		local zonetier, zonename, x, y = checkZone()
		
		local charModData = character:getModData()
		local eventFlag = charModData.eventparticipant or false
		
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		if not eventFlag then
			if eventenabled and x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				charModData.eventparticipant = true
				sendClientCommand(player, 'sdLogger', 'EventEntered', args);
			end
		elseif eventFlag then
			if eventenabled and x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				return
			else
				charModData.eventparticipant = false
				sendClientCommand(player, 'sdLogger', 'EventExited', args);
			end
		end
	end
end

Events.OnWeaponSwing.Add(eventCheck)