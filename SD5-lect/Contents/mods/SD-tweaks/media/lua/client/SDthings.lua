require "SDZoneCheck"

local args = {}

local function PlayerDeathSD(player)
	local zonetier, zonename, x, y = checkZone()
	playerModData = player:getModData()
	playerHC = playerModData.HardcoreMode or nil
	playerSSF = playerModData.SSFMode or nil
	
	args = {
		playerdeath_x = x,
		playerdeath_y = y,
		player_name = getOnlineUsername(),
		zonename = zonename,
		zonetier = zonetier
	};
	
	if SandboxVars.SDevents.enabled then
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			sendClientCommand(player_name, 'sdLogger', 'LogEventDeath', args);
		end
	end
	
	if playerHC and playerSSF then
		sendClientCommand(player_name, 'sdLogger', 'LogHCSSFDeath', args);
	elseif playerHC then
		sendClientCommand(player_name, 'sdLogger', 'LogHCDeath', args);
	elseif playerSSF then
		sendClientCommand(player_name, 'sdLogger', 'LogSSFDeath', args);
	else
		sendClientCommand(player_name, 'sdLogger', 'LogNormalDeath', args);
	end

end
--Events.OnPlayerDeath.Add(PlayerDeathSD)



local counter = 0

local function login_check()
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	counter = counter + 1
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close,
		  counter = counter*5
		}
		sendClientCommand(player, 'sdLogger', 'Login', args);
		Events.EveryOneMinute.Remove(login_check)
	end
	
	--print("counter: " .. counter)
	if counter > 6 then 
		Events.EveryOneMinute.Remove(login_check)
	end
end
Events.EveryOneMinute.Add(login_check)

local function EveryTenMinutes_check()
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = x,
		  player_y = y,
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close
		}
		sendClientCommand(player, 'sdLogger', 'CheckIn', args);
	end
end
--Events.EveryTenMinutes_check.Add(EveryTenMinutes_check)

local function onItemFall(item)
	local player = getSpecificPlayer(0)
	local safehouse = SafeHouse.hasSafehouse(player)

	if safehouse then
		local x = player:getX()
		local y = player:getY()
	
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
		
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			player:Say("I threw " .. string.upper(item:getName()) .. " on the ground. It might disappear.")
		end
	end
end

--Events.onItemFall.Add(onItemFall)