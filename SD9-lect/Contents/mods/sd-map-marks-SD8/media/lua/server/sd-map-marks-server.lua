-- Broadcast to all online players strings from players if they are also online.
--
-- For example, if 'sd-player-marks.ini' has
--             Stein=corpse_x:12000|corpse_y:8000|state:3
--
-- it will be broadcast to all players as long as Stein is online.

function broadcastMapMarks()

	local online_players = getOnlinePlayers()

	if online_players
	then
        print("Broadcasting map marks...")

        -- Build a table with all online players
        local online = {}
		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);
			if player
			then
                local info = {}
                info['x'] = player:getX()
                info['y'] = player:getY()
                info['z'] = player:getZ()
                online[player:getUsername()] = info
			end
		end

        -- Read logcraft files (dead, new player)
        local marks = {}
        local file = getFileReader("sd-player-marks.ini", false)
        if file
        then
            local line = file:readLine();
            while line do
                local tokens = string.split(line, "=")
                local name = tokens[1]
                if online[name] then
                    marks[name] = online[name]
                    marks[name]['marks'] = tokens[2]
                end
                line = file:readLine();
                if not line then break end
            end
            file:close();
        end

		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);

			if player
			then
                sendServerCommand(player, 'SDT', 'MapMarks', marks);
			end
		end
	end
end

if isServer() then
    Events.EveryTenMinutes.Add(broadcastMapMarks)
end