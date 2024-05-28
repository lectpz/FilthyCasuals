local function mendWound(bodyPart, player)
	bodyPart:RestoreToFullHealth()

	if bodyPart:getStiffness() > 0 then
		bodyPart:setStiffness(0)
		player:getFitness():removeStiffnessValue(BodyPartType.ToString(bodyPart:getType()))
	end
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
