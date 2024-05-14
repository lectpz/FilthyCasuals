local function PlayerDeathSD(player)
	local x = player:getX()
	local y = player:getY()
	local playername = getOnlineUsername()
	playerModData = player:getModData()
	playerHC = playerModData.HardcoreMode or nil
	playerSSF = playerModData.SSFMode or nil
	
	local args = {
		playerdeath_x = x,
		playerdeath_y = y,
		player_name = getOnlineUsername()
	};
	
	if SandboxVars.SDevents.enabled then
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			sendClientCommand(player_name, 'PlayerDeathSD', 'LogEventDeath', args);
		end
	end
	
	if playerHC and playerSSF then
		sendClientCommand(player_name, 'PlayerDeathSD', 'LogHCSSFDeath', args);
	elseif playerHC then
		sendClientCommand(player_name, 'PlayerDeathSD', 'LogHCDeath', args);
	elseif playerSSF then
		sendClientCommand(player_name, 'PlayerDeathSD', 'LogSSFDeath', args);
	end
	
end

Events.OnPlayerDeath.Add(PlayerDeathSD)