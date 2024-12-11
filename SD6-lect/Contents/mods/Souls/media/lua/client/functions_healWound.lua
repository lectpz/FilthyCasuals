local dbgTick = 0
local function dbgWnd(player)
	if dbgTick < 50 then
		dbgTick = dbgTick + 1
		return
	end
	dbgTick = 0
	Events.OnPlayerUpdate.Remove(dbgWnd)
	local bD = player:getBodyDamage();
		
	getInfectionMortalityDuration 	= bD:getInfectionMortalityDuration();
	getInfectionTime 				= bD:getInfectionTime();
	getInfectionLevel 				= bD:getInfectionLevel();
	
	if bD:IsInfected() == true then
		player:Say("I am still infected with the zombie virus.")
		player:Say("I have " ..
					math.floor((getInfectionMortalityDuration - getInfectionLevel*getInfectionMortalityDuration/100)+0.5) ..
					" hours left to live.")
	else
		player:Say("There is no zombie infection detected.")
	end
	
	if isDebugEnabled() then player:Say("Debug: Infection Time = " .. math.floor(bD:getInfectionLevel()*100+0.5)/100 .." | Infection Mortality Duration = " .. 
									math.floor((bD:getInfectionMortalityDuration()+0.5)) .. " | Infection Level = " .. 
									math.floor(bD:getInfectionLevel()*100+0.5)/100) end
end

local function mendWound(bodyPart, player)
	local bD = player:getBodyDamage();

	if bodyPart:getStiffness() > 0 then
		bodyPart:setStiffness(0)
		player:getFitness():removeStiffnessValue(BodyPartType.ToString(bodyPart:getType()))
	end
		
	if bD:IsInfected() == true then 
		if bodyPart:IsInfected() == true then
			bodyPart:RestoreToFullHealth() 
			bodyPart:SetInfected(true)
		else
			bodyPart:RestoreToFullHealth() 
		end
		bD:setInfected(true);
		bD:setInfectionLevel(0);-- 0 will set infection level to 0, this is default in BodyDamage class when restoring to full health
		bD:setInfectionTime(-1);-- -1 will reset infection timer, this is default in BodyDamage class when restoring to full health
		bD:setInfectionMortalityDuration(-1);-- -1 will set to sandbox settings, this is default in BodyDamage class when restoring to full health
	else
		bodyPart:RestoreToFullHealth() 
	end

	Events.OnPlayerUpdate.Add(dbgWnd)
end

local woundCheck = {
	bleeding	= function(bP) return bP:getBleedingTime() > 0 end,
	bite		= function(bP) return bP:bitten() end,
	burned		= function(bP) return bP:getBurnTime() > 0 end,
	deepWound	= function(bP) return bP:getDeepWoundTime() > 0 end,
	fracture	= function(bP) return bP:getFractureTime() > 0 end,
	scratched	= function(bP) return bP:getScratchTime() > 0 end,
	cut			= function(bP) return bP:isCut() end
}

local woundHeal = {
    bite		= function(bP) bP:SetBitten(false) end,
    burned		= function(bP) bP:setBurnTime(0) end,
    deepWound	= function(bP) 
					bP:setDeepWoundTime(0)
					bP:setDeepWounded(false)
					bP:setBleedingTime(0)
					end,
    fracture	= function(bP) bP:setFractureTime(0) end,
    scratched	= function(bP) 
					bP:setScratched(false, true)
					bP:setScratchTime(0)
					end,
    cut			= function(bP) 
					bP:setCut(false)
					bP:setCutTime(0) 
					end
}

local function checkRandomWound(action, player)
    local bodyParts = player:getBodyDamage():getBodyParts()

    for i = 0, bodyParts:size() - 1 do  -- Iterate directly over indices
        local bP = bodyParts:get(i)
		local bPtype = BodyPartType.ToString(bP:getType())
		--print("action: " .. action)
		--print("bodypart: " .. bPtype)

        -- Check if the wound type matches and it needs healing
        if woundCheck[action](bP) then
			--print("action: " .. action .. " for bodypart: " .. bPtype)
			return true
        end
    end
	return false
end

local function healRandomWound(action, player)
    local bodyParts = player:getBodyDamage():getBodyParts()

    for i = 0, bodyParts:size() - 1 do  -- Iterate directly over indices
        local bP = bodyParts:get(i)

        -- Check if the wound type matches and it needs healing
        if woundCheck[action](bP) then  

            -- If specific wound setters exist, apply them
            if woundHeal[action] then
                woundHeal[action](bP)
            end

            mendWound(bP, player)
            break
        end
    end
end

function OnCanPerform_healWound_bite(recipe, player)
	local action = "bite"
	if checkRandomWound(action, player) then return true end
end

function OnCanPerform_healWound_burned(recipe, player)
	local action = "burned"
	if checkRandomWound(action, player) then return true end
end

function OnCanPerform_healWound_deepWound(recipe, player)
	local action = "deepWound"
	if checkRandomWound(action, player) then return true end
end

function OnCanPerform_healWound_fracture(recipe, player)
	local action = "fracture"
	if checkRandomWound(action, player) then return true end
end

function OnCanPerform_healWound_cut(recipe, player)
	local action = "cut"
	if checkRandomWound(action, player) then return true end
end



function OnCreate_healWound_bite(items, result, player)
	local action = "bite"
	healRandomWound(action, player)
end

function OnCreate_healWound_burned(items, result, player)
	local action = "burned"
	healRandomWound(action, player)
end

function OnCreate_healWound_deepWound(items, result, player)
	local action = "deepWound"
	healRandomWound(action, player)
end

function OnCreate_healWound_fracture(items, result, player)
	local action = "fracture"
	healRandomWound(action, player)
end

function OnCreate_healWound_cut(items, result, player)
	local action = "cut"
	healRandomWound(action, player)
end
