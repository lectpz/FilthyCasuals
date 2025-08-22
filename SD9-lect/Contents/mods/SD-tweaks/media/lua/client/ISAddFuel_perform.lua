--[[local original = ISAddFuel.perform
function ISAddFuel:perform()
	
	local maxFuel = 200
	self.character:stopOrTriggerSound(self.sound)

	local endFuel = 0;
	while self.petrol and self.petrol:getUsedDelta() > 0 and self.generator:getFuel() + endFuel < maxFuel do
		self.petrol:Use();
		endFuel = endFuel + 10;
	end
	
	local totalFuel = self.generator:getFuel() + endFuel
	
	self.generator:setFuel(totalFuel)
	
	if totalFuel > 100 then
		local connected = self.generator:isConnected()
		local condition = self.generator:getCondition()
		
		local cell = getWorld():getCell()
		local square = self.generator:getSquare()

		local item = InventoryItemFactory.CreateItem("Base.Generator")
		if not item then return end

		item:getModData().fuel = totalFuel
		item:setCondition(condition)
		square:transmitRemoveItemFromSquare(self.generator)
		local javaObject = IsoGenerator.new(item, cell, square)
		javaObject:transmitCompleteItemToClients()
		if connected then javaObject:setConnected(connected) end
	end

	ISBaseTimedAction.perform(self);
end

local function predicatePetrol(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getDrainableUsesInt() > 0)
end

local function topOffGenerator(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()

	for i,v in pairs(worldobjects) do
		local generator
	    if instanceof(v, "IsoGenerator") then
			generator = v;
		end
		
		if generator then
			if not generator:isActivated() and generator:getFuel() < 200 and playerInv:containsEvalRecurse(predicatePetrol) then
				local petrolCan = playerInv:getFirstEvalRecurse(predicatePetrol);
				-- context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, ISWorldObjectContextMenu.onAddFuelGenerator, petrolCan, generator, player, context);
				ISWorldObjectContextMenu.onAddFuelGenerator(worldobjects, petrolCan, generator, player, context)
				break
			end
		end

	end

end

--Events.OnFillWorldObjectContextMenu.Add(topOffGenerator);]]