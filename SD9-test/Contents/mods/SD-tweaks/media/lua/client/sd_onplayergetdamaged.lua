--[[function SD_checkForInfection()
	Events.EveryOneMinute.Remove(SD_checkForInfection)
	local character = getSpecificPlayer(0)
	local pMD = character:getModData()
	if not pMD.unluckyInfection then 
		local bD = character:getBodyDamage();
			
		if bD:IsInfected() == true then 
				
			local tier = checkZone()
			local chance = ZombRand(tier)
			character:Say("Chance of getting infected: 1/"..tier)
			if chance == 0 then
			    local bodyParts = character:getBodyDamage():getBodyParts()

				for i = 0, bodyParts:size() - 1 do  -- Iterate directly over indices
					local bodyPart = bodyParts:get(i)
					if bodyPart:IsInfected() == true then
						bodyPart:SetInfected(false)
					end
				end
			
				bD:setInfected(false);
				bD:setInfectionLevel(0);-- 0 will set infection level to 0, this is default in BodyDamage class when restoring to full health
				bD:setInfectionTime(-1);-- -1 will reset infection timer, this is default in BodyDamage class when restoring to full health
				bD:setInfectionMortalityDuration(-1);-- -1 will set to sandbox settings, this is default in BodyDamage class when restoring to full health
				character:Say("I am not infected. Roll = " .. chance)
				Events.OnPlayerGetDamage.Add(SD_OnPlayerGetDamage)
			else
				pMD.unluckyInfection = true
				--character:setHaloNote("I am infected. Infection % = " .. pMD.unluckyInfection, 236, 131, 190, 1000)
				character:Say("I am infected. Roll = " .. chance)
			end

		end
	end

end


function SD_OnPlayerGetDamage(character, damageType, damage)
	Events.OnPlayerGetDamage.Remove(SD_OnPlayerGetDamage)
	Events.EveryOneMinute.Add(SD_checkForInfection)
end

local function OnCreatePlayer(playerNum, player)
    Events.OnPlayerGetDamage.Add(SD_OnPlayerGetDamage)
end
Events.OnCreatePlayer.Add(OnCreatePlayer)]]