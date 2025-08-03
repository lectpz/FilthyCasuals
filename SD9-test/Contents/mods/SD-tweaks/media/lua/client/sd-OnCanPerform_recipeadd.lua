--[[
	Version 1.2

	1.0: YeetRecipes.lua Written By UdderlyEvelyn 9/9/22
	1.1: Updated To Remove Recipes From Books/Magazines 9/24/22
	1.2: Removed removal from books/magazines, affecting CanPerform instead now. ??/??/22
	1.3: Removed the Name<->Display name stuff, was leftovers. Completed switching over to original name (oops). 3/12/23

	Feel free to use this, retain credit to me please. :)

	If you only need to replace *one* recipe with a given
	name, it is more efficient to use overrides/etc.! If
	you're already using this, though, might as well
	use it for all recipes to be removed.
]]
local modName = "UdderlyAmmoCrafting"

require "SDZoneCheck"

function OnCanPerform_notAtCCshops()
	local player = getSpecificPlayer(0)
	local x = player:getX()
	local y = player:getY()
	local x1, y1 = 11280, 8778
	local x2, y2 = 11384, 8932
	
	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
		player:setHaloNote("I cannot bulk pack or unpack items while inside the CC shop area.", 236, 131, 190, 50)
		return false
	else
		return true
	end
end

local function OnCanPerform_addtorecipe()
    local modified = 0
    local startTime = Calendar.getInstance():getTimeInMillis()
    local recipes = getScriptManager():getAllRecipes()

    -- Function to check if a word exists within a string (case-insensitive)
    local function containsWord(str, word)
        return string.find(str:lower(), word:lower()) ~= nil
    end

    local packWords = {"pack", "unpack", "put together", "split in", "rope", "unrope"}
    local excludedWords = {"packet", "package", "pack of", "booster pack", "into a pack", "backpack", "from pack", "fanny pack"}  

    for i = 1, recipes:size() do
        local recipe = recipes:get(i - 1)
        local name = recipe:getOriginalname()

        for _, word in ipairs(packWords) do
            if containsWord(name, word) then
                local shouldExclude = false
                for _, excludedWord in ipairs(excludedWords) do
                    if containsWord(name, excludedWord) then
                        shouldExclude = true
                        break
                    end
                end

                if not shouldExclude then -- Only modify if not excluded
					if not recipe:getCanPerform() then
						recipe:setCanPerform("OnCanPerform_notAtCCshops")
						modified = modified + 1
						--print("Restricted OnCanPerform for \"" .. name .. "\".")
					end
                end
                break  -- Break inner loop since a pack word was found
            end
        end
    end

    local endTime = Calendar.getInstance():getTimeInMillis()
    print("Modified " .. modified .. " recipes to restrict OnCanPerform in " .. (endTime - startTime) .. "ms!")
end

--Events.OnGameStart.Add(OnCanPerform_addtorecipe)