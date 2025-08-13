local function tagItems()
	local items = getAllItems();
	for i = 0, items:size()-1, 1 do
		local item = items:get(i)
		local itemModule = item:getModuleName()
		--print("module name: " .. itemModule)
		if itemModule == "pkmncards" then
			iFN = item:getFullName()
			if string.sub(iFN, -4) == "card" then
				local sItem = ScriptManager.instance:getItem(iFN)
				if tonumber(string.sub(string.sub(iFN, 11), 1, 3)) >= 100 then
					if sItem then 
						sItem:DoParam("Tags = PokemonCards100_151")
					end
				elseif tonumber(string.sub(string.sub(iFN, 11), 1, 3)) >= 50 then
					if sItem then 
						sItem:DoParam("Tags = PokemonCards050_099")
					end
				else
					if sItem then 
						sItem:DoParam("Tags = PokemonCards001_049")
					end
				end
			end
		end
	end
end

tagItems()

function Recipe.GetItemTypes.PokemonCards001_049(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("PokemonCards001_049"))
end

function Recipe.GetItemTypes.PokemonCards050_099(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("PokemonCards050_099"))
end

function Recipe.GetItemTypes.PokemonCards100_151(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("PokemonCards100_151"))
end

--Events.OnInitGlobalModData.Add(Recipe.GetItemTypes.PokemonCards)

--[[
function Recipe.GetItemTypes.Tier4Weapon(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("Tier4Weapon"))
end]]