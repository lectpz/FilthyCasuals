print("[UdderlyAmmoCrafting] Assigning Recipes To Magazines..")
for i,magazine in ipairs(UdderlyAmmoCrafting.Magazines) do
	local recipes = ""
	local didAnyYet = false
	local magazineItem = ScriptManager.instance:FindItem(magazine)
	if magazineItem ~= nil then
		for _,recipe in pairs(UdderlyAmmoCrafting.RecipeAssignments[i]) do
			local recipeObject=ScriptManager.instance:getRecipe(recipe)
			if recipeObject ~= nil then
				if didAnyYet == false then
					print("[UdderlyAmmoCrafting] Adding \""..recipe.."\" to \""..magazine.."\"..")
					recipes = recipe
					didAnyYet = true
				else
					print("[UdderlyAmmoCrafting] Adding \""..recipe.."\" to \""..magazine.."\"..")
					recipes = recipes..";"..recipe
				end
			else
				print("[UdderlyAmmoCrafting] Could not find recipe \""..recipe.."\", skipping.")
			end
		end
		if recipes ~= "" then
			magazineItem:DoParam("TeachedRecipes="..recipes)
		else
			print("[UdderlyAmmoCrafting] No recipes assigned to \""..magazine.."\" at index \""..i.."\"!")
		end
	else
		print("[UdderlyAmmoCrafting] Magazine \""..magazine.."\" at index \""..i.."\" is missing!")
	end
end
