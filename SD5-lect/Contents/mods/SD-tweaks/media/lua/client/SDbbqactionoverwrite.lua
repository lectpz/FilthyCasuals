--local function yeetbbqpropane(player, context, worldobjects, _)
--	for _,v in ipairs(worldobjects) do
--		if instanceof(v, "IsoBarbecue") then
--			context:removeOptionByName(getText("ContextMenu_Insert_Propane_Tank"))
--			context:removeOptionByName(getText("ContextMenu_Remove_Propane_Tank"))
--			break;
--		end
--	end
--end

--Events.OnFillWorldObjectContextMenu.Add(yeetbbqpropane);

require "TimedActions/ISBaseTimedAction"

function ISBBQRemovePropaneTank:perform()
	self.character:stopOrTriggerSound(self.sound)

	local bbq = self.bbq
	local args = { x = bbq:getX(), y = bbq:getY(), z = bbq:getZ() }
	sendClientCommand('SDbbq', 'removePropaneTank', args)
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISBBQInsertPropaneTank:perform()
	self.character:stopOrTriggerSound(self.sound)

	local tank = self.tank
	if instanceof(self.tank, "IsoWorldInventoryObject") then
		tank = self.tank:getItem()
		self.tank:getSquare():transmitRemoveItemFromSquare(self.tank)
	else
		self.character:removeFromHands(self.tank)
		self.character:getInventory():Remove(self.tank) -- TODO: server controls inventory
	end
	local bbq = self.bbq
	local args = { x = bbq:getX(), y = bbq:getY(), z = bbq:getZ(), delta = tank:getUsedDelta() }
	sendClientCommand('SDbbq', 'insertPropaneTank', args)
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end