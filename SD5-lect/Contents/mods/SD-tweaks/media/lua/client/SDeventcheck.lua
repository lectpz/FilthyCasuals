require "SDZoneCheck"

local args = {}
<<<<<<< HEAD

=======
-- function to scale crit and min/max dmg based on zone
>>>>>>> 08a3ee505703ffe5f8115b56e066db775091aef4
local function eventCheck(character, handWeapon)

	if character ~= nil then 

		local eventenabled = SandboxVars.SDevents.enabled	
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		
		local zonetier, zonename, x, y = checkZone()
		
<<<<<<< HEAD
		local isInsideEventZone = eventenabled and x >= x1 and y >= y1 and x <= x2 and y <= y2
		
		local player = getSpecificPlayer(0)
		
		local playerModData = player:getModData()
		local eventFlag = playerModData.eventparticipant or false
=======
		local charModData = character:getModData()
		local eventFlag = charModData.eventparticipant or false
>>>>>>> 08a3ee505703ffe5f8115b56e066db775091aef4
		
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
<<<<<<< HEAD
		if not eventFlag and isInsideEventZone then
			playerModData.eventparticipant = true
			sendClientCommand(player, 'sdLogger', 'EventEntered', args)
		elseif eventFlag and not isInsideEventZone then
			playerModData.eventparticipant = false
			sendClientCommand(player, 'sdLogger', 'EventExited', args)
=======
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
>>>>>>> 08a3ee505703ffe5f8115b56e066db775091aef4
		end
	end
end

Events.OnWeaponSwing.Add(eventCheck)