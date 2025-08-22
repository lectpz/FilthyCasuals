Events.OnGameStart.Add(function()
							local transmit_steamID = ModData.getOrCreate("transmit_steamID")	
							transmit_steamID[getCurrentUserSteamID()] = true
							ModData.transmit("transmit_steamID")
						end)