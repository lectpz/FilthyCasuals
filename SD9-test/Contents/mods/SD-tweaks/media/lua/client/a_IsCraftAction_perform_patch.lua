function ISCraftAction:perform()
	if self.craftSound and self.character:getEmitter():isPlaying(self.craftSound) then
		self.character:stopOrTriggerSound(self.craftSound);
	end
	if self.container:getType() == "floor" then
		self.fromFloor = true;
	else
		self.fromFloor = false;
	end
	self.container:setDrawDirty(true);
	self.item:setJobDelta(0.0);
	
	local pMD = self.character:getModData()
	local IronChef = pMD.IronChefValue
	local IronChefPower = 1
	if IronChef and IronChef > 1 then
		IronChefPower = pMD.IronChefValue
	end
		
	local chefPower = math.max(self.character:getPerkLevel(Perks.Cooking)/4,1) * IronChefPower -- scale cooking recipes based on cook level
	
	local resultItemCreated = RecipeManager.PerformMakeItem(self.recipe, self.item, self.character, self.containers);

	local exclusionItems = 	string.contains(self.item:getDisplayName(), "Sack") 
							or string.contains(self.item:getDisplayName(), "Canned") 
							or (self.item:getOffAge() == 1000000000)
							or self.item:isAlcoholic()
							or resultItemCreated:isAlcoholic()
							or string.contains(resultItemCreated:getDisplayName(), "Jar of") 
							or resultItemCreated:getType() == "FishFillet" 
							or resultItemCreated:getType() == "Sugar"
							--or (resultItemCreated:getOnEat() or nil)

	
	if resultItemCreated and instanceof(resultItemCreated, "DrainableComboItem") and self.recipe:getResult():getDrainableCount() > 0 then
		resultItemCreated:setUsedDelta(resultItemCreated:getUseDelta() * self.recipe:getResult():getDrainableCount());
	end
	if resultItemCreated and instanceof(resultItemCreated, "Food") and instanceof(self.item, "Food") then
		-- TODO: this could be improved by checking/averaging all the items involved
		resultItemCreated:setHeat(self.item:getHeat());
		resultItemCreated:setFreezingTime(self.item:getFreezingTime());
		resultItemCreated:setFrozen(self.item:isFrozen());
	end
	if resultItemCreated and self.recipe:getResult():getCount() > 1 then
		-- FIXME: this does not call the recipe's OnCreate lua function
		local itemsAdded = self.container:AddItems(resultItemCreated:getFullType(), self.recipe:getResult():getCount());
		-- now we modify the variables of the item created, for example if you create a nailed baseball bat, it'll have the condition of the used baseball bat
		if itemsAdded and instanceof(resultItemCreated, "Food") then
			for i=0, itemsAdded:size()-1 do
				local newItem = itemsAdded:get(i);
				if resultItemCreated:isCustomName() then
					newItem:setName(resultItemCreated:getDisplayName());
					newItem:setCustomName(true);
				end
------------------------------------------------------------------------
--lect note: adding this to stop unperishable items from being crafted--
--lect note: also fix NaN bugs
------------------------------------------------------------------------
				if exclusionItems or resultItemCreated:getOnEat() then
					newItem:setCalories(resultItemCreated:getCalories());
					newItem:setLipids(resultItemCreated:getLipids());
					newItem:setProteins(resultItemCreated:getProteins());
					newItem:setCarbohydrates(resultItemCreated:getCarbohydrates());
					newItem:setAge(resultItemCreated:getAge())
				elseif resultItemCreated:getCalories() > 1  then
					local itemAge = resultItemCreated:getAge()
					if tostring(itemAge) == "nan" then 
						itemAge = 0 
					end
					newItem:setAge(itemAge)
					
					local itemGetOffAge = resultItemCreated:getOffAge()
					if itemGetOffAge == 1000000000 then
						itemGetOffAge = 6 * chefPower
					else
						itemGetOffAge = resultItemCreated:getOffAge() * chefPower
					end
					newItem:setOffAge(itemGetOffAge)
					
					local itemGetOffAgeMax = resultItemCreated:getOffAgeMax()
					if itemGetOffAgeMax == 1000000000 then
						itemGetOffAgeMax = 10 * chefPower
					else
						itemGetOffAgeMax = resultItemCreated:getOffAgeMax() * chefPower
					end
					newItem:setOffAgeMax(itemGetOffAgeMax)
					
					newItem:setCalories(resultItemCreated:getCalories());
				else
					local itemAge = resultItemCreated:getAge()
					if tostring(itemAge) == "nan" then 
						itemAge = 0 
					end
					newItem:setAge(itemAge)
					
					local itemGetOffAge = resultItemCreated:getOffAge()
					if itemGetOffAge == 1000000000 then
						itemGetOffAge = 6 * chefPower
					else
						itemGetOffAge = resultItemCreated:getOffAge() * chefPower
					end
					newItem:setOffAge(itemGetOffAge)
					
					local itemGetOffAgeMax = resultItemCreated:getOffAgeMax()
					if itemGetOffAgeMax == 1000000000 then
						itemGetOffAgeMax = 10 * chefPower
					else
						itemGetOffAgeMax = resultItemCreated:getOffAgeMax() * chefPower
					end
					newItem:setOffAgeMax(itemGetOffAgeMax)
					
					newItem:setCalories(0.1);
				end
				
				if resultItemCreated:getCarbohydrates() > 1 then
					newItem:setCarbohydrates(resultItemCreated:getCarbohydrates());
				else
					newItem:setCarbohydrates(0.1);
				end
				
				if resultItemCreated:getLipids() > 1 then
					newItem:setLipids(resultItemCreated:getLipids());
				else
					newItem:setLipids(0.1);
				end
				
				if resultItemCreated:getProteins() > 1 then
					newItem:setProteins(resultItemCreated:getProteins());
				else
					newItem:setProteins(0.1);
				end
------------------------------------------------------------------------
--lect note: adding this to stop unperishable items from being crafted--
--lect note: also fix NaN bugs
------------------------------------------------------------------------
				newItem:setCooked(resultItemCreated:isCooked());
				newItem:setRotten(resultItemCreated:isRotten());
				newItem:setBurnt(resultItemCreated:isBurnt());
--COMMENTED OUT newItem:setAge(resultItemCreated:getAge());
				newItem:setHungChange(resultItemCreated:getHungChange());
				newItem:setBaseHunger(resultItemCreated:getBaseHunger());
				newItem:setThirstChange(resultItemCreated:getThirstChangeUnmodified());
				newItem:setPoisonDetectionLevel(resultItemCreated:getPoisonDetectionLevel());
				newItem:setPoisonPower(resultItemCreated:getPoisonPower());
--COMMENTED OUT	newItem:setCarbohydrates(resultItemCreated:getCarbohydrates());
--COMMENTED OUT	newItem:setLipids(resultItemCreated:getLipids());
--COMMENTED OUT	newItem:setProteins(resultItemCreated:getProteins());
--COMMENTED OUT newItem:setCalories(resultItemCreated:getCalories());
				newItem:setTaintedWater(resultItemCreated:isTaintedWater());
				newItem:setActualWeight(resultItemCreated:getActualWeight());
				newItem:setWeight(resultItemCreated:getWeight());
				newItem:setCustomWeight(resultItemCreated:isCustomWeight());
				--set the new items heat/freezing/frozen
				newItem:setHeat(resultItemCreated:getHeat());
				newItem:setFreezingTime(resultItemCreated:getFreezingTime());
				newItem:setFrozen(resultItemCreated:isFrozen());
				newItem:setBoredomChange(resultItemCreated:getBoredomChangeUnmodified());
				newItem:setUnhappyChange(resultItemCreated:getUnhappyChangeUnmodified());
			end
		end
		if itemsAdded and instanceof(resultItemCreated, "HandWeapon") then
			for i=0, itemsAdded:size()-1 do
				local newItem = itemsAdded:get(i);
				newItem:setCondition(resultItemCreated:getCondition());
			end
		end
		if itemsAdded and self.fromFloor then
			for i=1,itemsAdded:size() do
				self.character:getCurrentSquare():AddWorldInventoryItem(itemsAdded:get(i-1),
					(self.character:getX() - math.floor(self.character:getX())) + ZombRandFloat(0.1,0.5),
					(self.character:getY() - math.floor(self.character:getY())) + ZombRandFloat(0.1,0.5),
					self.character:getZ() - math.floor(self.character:getZ()))
				-- NOTE: AddWorldInventoryItem() sets the item's container to null
				itemsAdded:get(i-1):setContainer(self.container)
			end
		end
		if itemsAdded and not self.fromFloor then
			for i=1,itemsAdded:size() do
				self:addOrDropItem(itemsAdded:get(i-1))
			end
		end
	elseif resultItemCreated then
------------------------------------------------------------------------
--lect note: adding this to stop unperishable items from being crafted--
--lect note: also fix NaN bugs
------------------------------------------------------------------------
		if instanceof(resultItemCreated, "Food") then
			if exclusionItems or resultItemCreated:getOnEat() then
				resultItemCreated:setCalories(resultItemCreated:getCalories());
				resultItemCreated:setAge(resultItemCreated:getAge())
			elseif resultItemCreated:getCalories() > 1  then
				local itemAge = resultItemCreated:getAge()
				if tostring(itemAge) == "nan" then 
					itemAge = 0 
				end
				resultItemCreated:setAge(itemAge)
				
				local itemGetOffAge = resultItemCreated:getOffAge()
				if itemGetOffAge == 1000000000 then
					itemGetOffAge = 6 * chefPower
				else
					itemGetOffAge = resultItemCreated:getOffAge() * chefPower
				end
				resultItemCreated:setOffAge(itemGetOffAge)
				
				local itemGetOffAgeMax = resultItemCreated:getOffAgeMax()
				if itemGetOffAgeMax == 1000000000 then
					itemGetOffAgeMax = 10 * chefPower
				else
					itemGetOffAgeMax = resultItemCreated:getOffAgeMax() * chefPower
				end
				resultItemCreated:setOffAgeMax(itemGetOffAgeMax)

			else
				local itemAge = resultItemCreated:getAge()
				if tostring(itemAge) == "nan" then 
					itemAge = 0 
				end
				resultItemCreated:setAge(itemAge)
				
				local itemGetOffAge = resultItemCreated:getOffAge()
				if itemGetOffAge == 1000000000 then
					itemGetOffAge = 6 * chefPower
				else
					itemGetOffAge = resultItemCreated:getOffAge() * chefPower
				end
				resultItemCreated:setOffAge(itemGetOffAge)
				
				local itemGetOffAgeMax = resultItemCreated:getOffAgeMax()
				if itemGetOffAgeMax == 1000000000 then
					itemGetOffAgeMax = 10 * chefPower
				else
					itemGetOffAgeMax = resultItemCreated:getOffAgeMax() * chefPower
				end
				resultItemCreated:setCalories(1);
			end
			
			if resultItemCreated:getCarbohydrates() > 1 then
				resultItemCreated:setCarbohydrates(resultItemCreated:getCarbohydrates());
			else
				resultItemCreated:setCarbohydrates(0.1);
			end
			
			if resultItemCreated:getLipids() > 1 then
				resultItemCreated:setLipids(resultItemCreated:getLipids());
			else
				resultItemCreated:setLipids(0.1);
			end
			
			if resultItemCreated:getProteins() > 1 then
				resultItemCreated:setProteins(resultItemCreated:getProteins());
			else
				resultItemCreated:setProteins(0.1);
			end
		end
------------------------------------------------------------------------
--lect note: adding this to stop unperishable items from being crafted--
--lect note: also fix NaN bugs
------------------------------------------------------------------------
		if self.fromFloor then
			self.character:getCurrentSquare():AddWorldInventoryItem(resultItemCreated,
				self.character:getX() - math.floor(self.character:getX()) + ZombRandFloat(0.1,0.5),
				self.character:getY() - math.floor(self.character:getY()) + ZombRandFloat(0.1,0.5),
				self.character:getZ() - math.floor(self.character:getZ()))
			self.container:AddItem(resultItemCreated)
		else
			self:addOrDropItem(resultItemCreated)
		end
	end

	ISInventoryPage.dirtyUI()

	if self.onCompleteFunc then
		local args = self.onCompleteArgs
		self.onCompleteFunc(args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end