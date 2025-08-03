local args = {}

ISDropWorldItemAction.o_perform = ISDropWorldItemAction.perform
function ISDropWorldItemAction:perform()
	
	local iFT = self.item:getFullType()
	local itemID = self.item:getID()
	local placedX = math.floor(self.sq:getX())
	local placedY = math.floor(self.sq:getY())
	local placedZ = math.floor(self.sq:getZ())
	
	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.placedX = placedX
	args.placedY = placedY
	args.placedZ = placedZ

	self:o_perform()
	sendClientCommand(self.character, 'sdLogger', 'ItemPlaced', args);
	if self.item:getType() == "SkillRecoveryBoundJournal" then
		self.character:Say("If this journal disappears because I placed it instead of properly storing it in a container, I promise I won't make a ticket about it.")
	end
end