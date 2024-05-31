--***********************************************************
--**                   KI5 / bikinihorst                   **
--***********************************************************
--b0.7.6

KI5 = KI5 or {};
V100 = V100 or {};

function V100.pvFixCheck()
	local vanillaEnter = ISEnterVehicle["start"];

	ISEnterVehicle["start"] = function(self)

		local vehicle = self.vehicle
			local vehicle = self.vehicle
			if 	vehicle and string.find( vehicle:getScriptName(), "67commando") then

				self.character:SetVariable("KI5vehicle", "True")
			end
		
	vanillaEnter(self);
		
		local seat = self.seat
    		if not seat then return end
				if seat == 0 then		
					self.character:SetVariable("BobIsDriver", "True")
				else		
					self.character:SetVariable("BobIsDriver", "False")
			end
	end
end

function V100.pvFixSwitch(player)
	local player = getPlayer()
	local vehicle = player:getVehicle()
		if 	vehicle and string.find( vehicle:getScriptName(), "67commando") then

			player:SetVariable("KI5vehicle", "True")

			local seat = vehicle:getSeat(player)
	    		if not seat then return end
					if seat == 0 then		
						player:SetVariable("BobIsDriver", "True")
					else		
						player:SetVariable("BobIsDriver", "False")
				end

	end
end

function V100.pvFixClear(player)

		player:SetVariable("KI5vehicle", "False")
end

Events.OnGameStart.Add(V100.pvFixCheck);
Events.OnGameStart.Add(V100.pvFixSwitch);
Events.OnExitVehicle.Add(V100.pvFixClear);
Events.OnSwitchVehicleSeat.Add(V100.pvFixSwitch);