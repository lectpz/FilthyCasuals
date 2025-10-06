--[[local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "

local maxFuel = 200
local maxCondition = 200

local gennieSprite = { "industry_tk_02_3", "industry_tk_02_0", "industry_tk_02_1", "industry_tk_02_2" }

local function countItems(playerObj, item)
	local inv = playerObj:getInventory()
	local items = inv:getItemsFromFullType(item, false)
	local count = 0
	for i=1,items:size() do
		local invItem = items:get(i-1)
		if not instanceof(invItem, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
			count = count + 1
		end
	end
	return count
end

local function itemToolTipMats(tooltip, material, option, quantity)
	local playerObj = getSpecificPlayer(0)
	local playerInv = playerObj:getInventory()
	local scriptItem = ScriptManager.instance:getItem(material)
	local itemdisplayname = scriptItem:getDisplayName()
	tooltip.description = tooltip.description .. " <LINE> "
	if countItems(playerObj, material) < quantity then
		count = countItems(playerObj, material)
		option.notAvailable = true;
		--tooltip = ISWorldObjectContextMenu.addToolTip();
		tooltip.description = tooltip.description .. red .. itemdisplayname .. " " .. count .. "/" .. quantity ;
	else
		--count = playerInv:getCountTypeRecurse(material)
		count = countItems(playerObj, material)
		tooltip.description = tooltip.description .. green .. itemdisplayname .. " " .. count .. "/" .. quantity ;
	end
end

local SD_ISAddFuel_perform = ISAddFuel.perform
function ISAddFuel:perform()
	local isUpgraded = self.generator:getModData().upgraded
	if not isUpgraded then
		SD_ISAddFuel_perform(self)
	else

		self.character:stopOrTriggerSound(self.sound)

		local endFuel = 0;
		while self.petrol and self.petrol:getUsedDelta() > 0 and (self.generator:getFuel() + endFuel) < maxFuel do
			self.petrol:Use();
			endFuel = endFuel + 10;
		end
		
		local totalFuel = self.generator:getFuel() + endFuel
		
		self.generator:setFuel(totalFuel)
		
		if totalFuel > 100 then
			local connected = self.generator:isConnected()
			local condition = self.generator:getCondition()
			local spriteIndex = self.generator:getModData().spriteIndex or 1
			
			local cell = getWorld():getCell()
			local square = self.generator:getSquare()

			local item = InventoryItemFactory.CreateItem("Base.Generator")
			if not item then return end

			local iMD = item:getModData()
			iMD.fuel = totalFuel
			item:setCondition(condition)
			square:transmitRemoveItemFromSquare(self.generator)
			local javaObject = IsoGenerator.new(item, cell, square)
			javaObject:setSprite(gennieSprite[spriteIndex])
			javaObject:transmitUpdatedSprite()
			javaObject:getModData().upgraded = true
			javaObject:getModData().spriteIndex = spriteIndex
			javaObject:transmitModData()
			--javaObject:transmitCompleteItemToServer()
			--square:transmitRemoveItemFromSquare(javaObject)
			javaObject:transmitCompleteItemToClients()
			if connected then javaObject:setConnected(connected) end
		end

		ISBaseTimedAction.perform(self);
	end

end

local function predicatePetrol(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getDrainableUsesInt() > 0)
end

local function predicateEmptyPetrol(item)
	return item:hasTag("EmptyPetrol") or item:getType() == "EmptyPetrolCan"
end

local function predicatePetrolNotFull(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and item:getUsedDelta() < 1 
end

local o_createMenu = ISWorldObjectContextMenu.createMenu
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)

	local context = o_createMenu(player, worldobjects, x, y, test)

	if generator and generator:getModData().upgraded then
	
		if getCore():getGameMode() == "Tutorial" then
			local context = Tutorial1.createWorldContextMenu(player, worldobjects, x ,y);
			return context;
		end
		-- if the game is paused, we don't show the world context menu
		if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
			return;
		end

		local playerObj = getSpecificPlayer(player)
		local playerInv = playerObj:getInventory()
		if playerObj:isAsleep() then return end

		--do the thing

	 -- generator interaction

		if not generator:isActivated() and generator:getFuel() < maxFuel and playerInv:containsEvalRecurse(predicatePetrol) then
			local petrolCan = playerInv:getFirstEvalRecurse(predicatePetrol);
			-- context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, ISWorldObjectContextMenu.onAddFuelGenerator, petrolCan, generator, player, context);
			ISWorldObjectContextMenu.onAddFuelGenerator(worldobjects, petrolCan, generator, player, context)
		end
		if not generator:isActivated() and generator:getCondition() < maxCondition and generator:getCondition() >= 100 then
			local option = context:addOption(getText("ContextMenu_GeneratorFix"), worldobjects, ISWorldObjectContextMenu.onFixGenerator, generator, player);
			if not playerObj:isRecipeKnown("Generator") then
				local tooltip = ISWorldObjectContextMenu.addToolTip();
				option.notAvailable = true;
				tooltip.description = getText("ContextMenu_GeneratorPlugTT");
				option.toolTip = tooltip;
			end
			if not playerInv:containsTypeRecurse("ElectronicsScrap") then
				local tooltip = ISWorldObjectContextMenu.addToolTip();
				option.notAvailable = true;
				tooltip.description = getText("ContextMenu_GeneratorFixTT");
				option.toolTip = tooltip;
			end
		end
		
		return context

	end

	return context
end

local o_doAddFuelGenerator = ISWorldObjectContextMenu.doAddFuelGenerator
ISWorldObjectContextMenu.doAddFuelGenerator = function(worldobjects, generator, fuelContainerList, fuelContainer, player)

	local isUpgraded = generator:getModData().upgraded
	
	if not isUpgraded then
		o_doAddFuelGenerator(worldobjects, generator, fuelContainerList, fuelContainer, player)
	else
		print("Size : " .. tostring(fuelContainerList))
		local playerObj = getSpecificPlayer(player)
		if not fuelContainerList then
			fuelContainerList = {};
			table.insert(fuelContainerList, fuelContainer);
		end
		if luautils.walkAdj(playerObj, generator:getSquare()) then
			for i,item in ipairs(fuelContainerList) do
				if generator:getFuel() < maxFuel then
					ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), item, true, false);
					ISTimedActionQueue.add(ISAddFuel:new(player, generator, item, 70 + (item:getUsedDelta() * 40)));
				end
			end
		end		
	end
end

local o_ISTakeGenerator_perform = ISTakeGenerator.perform
function ISTakeGenerator:perform()
	
	if self.generator:getModData().upgraded then
		self.character:Say("I need to remove the Extended Fuel Tank first.")
		--self.character:getInventory():AddItem("SD.FuelExtender")
		--self.generator:getModData().upgraded = nil
	else
		o_ISTakeGenerator_perform(self)
	end
end

local o_ISFixGenerator_isValid = ISFixGenerator.isValid
function ISFixGenerator:isValid()
	local isUpgraded = self.generator:getModData().upgraded
	if not isUpgraded then
		return o_ISFixGenerator_isValid(self)
	else
		return self.generator:getObjectIndex() ~= -1 and
			not self.generator:isActivated() and
			self.generator:getCondition() < maxCondition and
			self.character:getInventory():containsTypeRecurse("ElectronicsScrap")
	end
end

local o_ISFixGenerator_perform = ISFixGenerator.perform
function ISFixGenerator:perform()
	local isUpgraded = self.generator:getModData().upgraded
	
	if not isUpgraded or self.generator:getCondition() < 100 then
		o_ISFixGenerator_perform(self)
	elseif isUpgraded and self.generator:getCondition() < maxCondition and self.generator:getCondition() >= 100 then
		self.character:stopOrTriggerSound(self.sound)

		local scrapItem = self.character:getInventory():getFirstTypeRecurse("ElectronicsScrap");

		if not scrapItem then return; end;
		self.character:removeFromHands(scrapItem);
		
		local scrapItems = countItems(self.character, "Base.ElectronicsScrap")
		--self.character:Say("number of scrap electronics: " .. scrapItems)
		local currentCondition = self.generator:getCondition()
		--self.character:Say("original condition: " .. currentCondition)
		
		local deltaCondition = maxCondition - currentCondition
		
		local repairDelta = 4 + (1*(self.character:getPerkLevel(Perks.Electricity))/2)
		
		local scrapRequired = math.max(math.min(math.ceil( (deltaCondition/repairDelta) + 0.5 ),scrapItems),1)
		
		for i=1,scrapRequired do
			self.character:getInventory():RemoveOneOf("Base.ElectronicsScrap");
			currentCondition = currentCondition + repairDelta
		end
		
		local repairCondition = math.min(maxCondition, currentCondition)
		
		--self.character:Say("repair condition: " .. repairCondition)
		
		local connected = self.generator:isConnected()
		local spriteIndex = self.generator:getModData().spriteIndex or 1
		
		local cell = getWorld():getCell()
		local square = generator:getSquare()

		local item = InventoryItemFactory.CreateItem("Base.Generator")
		if not item then return end

		local iMD = item:getModData()
		iMD.fuel = self.generator:getFuel()
		item:setCondition(repairCondition)
		square:transmitRemoveItemFromSquare(self.generator)
		local javaObject = IsoGenerator.new(item, cell, square)
		javaObject:getModData().upgraded = true
		javaObject:getModData().spriteIndex = spriteIndex
		javaObject:transmitModData()
		javaObject:setSprite(gennieSprite[spriteIndex])
		javaObject:transmitUpdatedSprite()
		javaObject:transmitCompleteItemToClients()
		if connected then javaObject:setConnected(connected) end
	end
end

local function upgradeGenerator(generator, player)
	local playerObj = getSpecificPlayer(player)
	if countItems(playerObj, "SD.FuelExtender") == 0 then return end
	local playerInv = playerObj:getInventory()
	playerInv:RemoveOneOf("SD.FuelExtender")
	generator:getModData().upgraded = true
	generator:getModData().spriteIndex = 1
	--print(generator:getModData().spriteIndex)
	generator:transmitModData()
	generator:setSprite(gennieSprite[generator:getModData().spriteIndex])
	generator:transmitUpdatedSprite()
	generator:transmitCompleteItemToClients()
end

local function downgradeGenerator(generator, player)
	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	playerInv:AddItem("SD.FuelExtender")
	
	local connected = generator:isConnected()
	local condition = generator:getCondition()
	
	local cell = getWorld():getCell()
	local square = generator:getSquare()

	local item = InventoryItemFactory.CreateItem("Base.Generator")
	if not item then return end

	local iMD = item:getModData()
	iMD.fuel = math.min(generator:getFuel(),100)
	item:setCondition(condition)
	square:transmitRemoveItemFromSquare(generator)
	local javaObject = IsoGenerator.new(item, cell, square)
	javaObject:transmitCompleteItemToClients()
	if connected then javaObject:setConnected(connected) end
end

local function rotateGenerator(generator, player)
	local connected = generator:isConnected()
	local condition = generator:getCondition()
	local genModData = generator:getModData()
	
	local cell = getWorld():getCell()
	local square = generator:getSquare()

	local item = InventoryItemFactory.CreateItem("Base.Generator")
	if not item then return end

	local iMD = item:getModData()
	iMD.fuel = generator:getFuel()
	item:setCondition(condition)
	
	if not genModData.spriteIndex then genModData.spriteIndex = 1 end
	
	local spriteIndex = (genModData.spriteIndex + 1)
	
	square:transmitRemoveItemFromSquare(generator)
	local javaObject = IsoGenerator.new(item, cell, square)
	javaObject:getModData().upgraded = true

	if spriteIndex > 4 then
		spriteIndex = 1
	end

	javaObject:getModData().spriteIndex = spriteIndex
	javaObject:transmitModData()
	javaObject:setSprite(gennieSprite[spriteIndex])
	javaObject:transmitUpdatedSprite()
	javaObject:transmitCompleteItemToClients()
	if connected then javaObject:setConnected(connected) end
end

local function upgradeGeneratorContext(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()

	for i,v in pairs(worldobjects) do
		local generator
	    if instanceof(v, "IsoGenerator") then
			generator = v;
		end
		
		if generator and not generator:isActivated() then
			local isUpgraded = generator:getModData().upgraded
			if isUpgraded then 
				local generatorContext = context:addOption("Remove Extended Fuel Tank", generator, downgradeGenerator, player);
				local generatorContext = context:addOption("Rotate Generator", generator, rotateGenerator, player);
				break
			else
				local itemCount = countItems(playerObj, "SD.FuelExtender")
				local generatorContext = context:addOption("Add Extended Fuel Tank", generator, upgradeGenerator, player)

				local generatortooltip = ISWorldObjectContextMenu.addToolTip();
				generatortooltip.description = generatortooltip.description .. "Upgrade your Generator:"
				itemToolTipMats(generatortooltip, "SD.FuelExtender", generatorContext, 1)
				generatorContext.toolTip = generatortooltip
				
				break
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(upgradeGeneratorContext);]]