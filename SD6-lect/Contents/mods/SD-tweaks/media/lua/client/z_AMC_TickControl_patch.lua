local function z_AMCTickControl_patch()
	if isClient() then
		local playerLocal = getPlayer()
		local plLocX = playerLocal:getX()
		local plLocY = playerLocal:getY()
		local playersWithAnim = ModData.getOrCreate("tsaranimations")
		local vehicle = playerLocal:getVehicle()
		if vehicle and vehicle:getPartById("AMCConfig") then
			local vehicleInfo = vehicle:getPartById("AMCConfig"):getTable("AMCConfig")
			if vehicleInfo then
				if vehicle:isDriver(playerLocal) and vehicleInfo.fallDelta then
					AMCTickControl.fallControl(playerLocal, vehicle, tonumber(vehicleInfo.fallDelta))
				end
				AMCTickControl.setLocalVariables(playerLocal, vehicle, vehicleInfo)
			end
		end
		-- print(playersWithAnim)
		for playerId, _ in pairs(playersWithAnim) do
			player = getPlayerByOnlineID(playerId)
			if player and not player:isLocalPlayer() and not player:isDead() then
				local vehicle = player:getVehicle()
				if vehicle and vehicle:getPartById("AMCConfig") then
					local vehicleInfo = vehicle:getPartById("AMCConfig"):getTable("AMCConfig")
					if vehicleInfo then
						local x = player:getX()
						local y = player:getY()
						if ((plLocX >= x - 60 and plLocX <= x + 60 and
								plLocY >= y - 60 and plLocY <= y + 60)) then
							AMCTickControl.setAvatarVariables(player, vehicle, vehicleInfo)
						end
					end
				end
				
			end
		end
	else
		local playersSum = getNumActivePlayers()
		for playerNum = 0, playersSum - 1 do
			-- print(playerNum)
			local playerObj = getSpecificPlayer(playerNum)
			if playerObj then
				local vehicle = playerObj:getVehicle()
				if vehicle and vehicle:getPartById("AMCConfig") then
					local vehicleInfo = vehicle:getPartById("AMCConfig"):getTable("AMCConfig")
					if vehicleInfo then
						if vehicleInfo.fallDelta then
							AMCTickControl.fallControl(playerObj, vehicle, tonumber(vehicleInfo.fallDelta))
						end
						AMCTickControl.setLocalVariables(playerObj, vehicle, vehicleInfo)
					elseif playerObj:getModData()["mototsar"] and playerObj:getModData()["mototsar"].health then
						playerObj:getModData()["mototsar"].health = nil
					end
				end
			end
		end
	end
end

Events.OnTick.Remove(AMCTickControl.main)
Events.EveryTenMinutes.Add(z_AMCTickControl_patch)