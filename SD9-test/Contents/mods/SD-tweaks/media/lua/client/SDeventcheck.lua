require "SDZoneCheck"

local args = {}

local function eventCheck(character, handWeapon)

	if character ~= nil then 

		local eventenabled = SandboxVars.SDevents.enabled	
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		
		local zonetier, zonename, x, y = checkZone()
		
		local isInsideEventZone = eventenabled and x >= x1 and y >= y1 and x <= x2 and y <= y2
		
		local player = getSpecificPlayer(0)
		
		local playerModData = player:getModData()
		local eventFlag = playerModData.eventparticipant or false
		
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		if not eventFlag and isInsideEventZone then
			playerModData.eventparticipant = true
			sendClientCommand(player, 'sdLogger', 'EventEntered', args)
		elseif eventFlag and not isInsideEventZone then
			playerModData.eventparticipant = false
			sendClientCommand(player, 'sdLogger', 'EventExited', args)
		end
	end
end

--Events.OnWeaponSwing.Add(eventCheck)