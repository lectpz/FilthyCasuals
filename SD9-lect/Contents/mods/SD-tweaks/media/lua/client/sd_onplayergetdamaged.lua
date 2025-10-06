--[[local flavorTextLife = { 
	"Phew! I beat the odds!",
	"Lucky me! It's a miracle.",
	"Against all odds, I made it.",
	"I've got a second chance.",
	"Life goes on.",
}

local flavorTextDeath = { 
	"Not like this... NOT LIKE THIS!",
	"My time has come.",
	"The dead are the lucky ones...",
	"The great beyond awaits...",
	"Darkness is falling.",
}

function SD_checkForInfection()
	Events.EveryOneMinute.Remove(SD_checkForInfection)
	local character = getSpecificPlayer(0)
	local pMD = character:getModData()
	if not pMD.unluckyInfection then 
		local bD = character:getBodyDamage();
		local bodyParts = bD:getBodyParts()
		
		local tier = checkZone()
		local chance = ZombRand(tier)
		for i = 0, bodyParts:size() - 1 do  -- Iterate directly over indices
			local bodyPart = bodyParts:get(i)
			if bodyPart:bitten() and bodyPart:IsInfected() then
				if ZombRand(tier) == 0 then
					pMD.unluckyInfection = nil
					bodyPart:SetInfected(false)
					bD:setInfected(false);
					bD:setInfectionLevel(0);-- 0 will set infection level to 0, this is default in BodyDamage class when restoring to full health
					bD:setInfectionTime(-1);-- -1 will reset infection timer, this is default in BodyDamage class when restoring to full health
					bD:setInfectionMortalityDuration(-1);-- -1 will set to sandbox settings, this is default in BodyDamage class when restoring to full health
					HaloTextHelper.addText(character, string.format(flavorTextDeath[ZombRand(#flavorText)+1] .. "(%.0f%% infection avoidance chance.)", 1/tier*100), HaloTextHelper.getColorGreen())
					Events.OnPlayerGetDamage.Add(SD_OnPlayerGetDamage)
				else
					pMD.unluckyInfection = true
					break
					HaloTextHelper.addText(character, string.format(flavorTextDeath[ZombRand(#flavorText)+1] .. " (%.0f%% infection chance.)", (1-1/tier)*100), HaloTextHelper.getColorRed())
				end
			end
				
			if bodyPart:IsInfected() == true then
				bodyPart:SetInfected(false)
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