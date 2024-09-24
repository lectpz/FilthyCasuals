local McCraes = {
    "Stealing a Car Battery Charger? We're afraid the only steals here are the deals... at McCrae's!",
    "Five finger discount? How about a high five and some low prices... at McCrae's!",
    "Need a charge? Get a full charge... at no charge... at McCrae's!",
    "Lost your battery charger?  Well, now you have found bargains... at McCrae's!",
    "In the market for criminal intent? The only things criminal here... are the low prices... at McCrae's!",
}

ISTakeCarBatteryChargerAction.o_perform = ISTakeCarBatteryChargerAction.perform
function ISTakeCarBatteryChargerAction:perform()
	if getOnlineUsername() == "McCrae" or isAdmin() or isDebugEnabled() then self:o_perform() return end

	local sq = self.charger:getSquare()
	local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
	
	local x1 = SandboxVars.McCraes.X-1
	local y1 = SandboxVars.McCraes.Y-1
	local x2 = SandboxVars.McCraes.X+1
	local y2 = SandboxVars.McCraes.Y+1
	
	if args.x >= x1 and args.y >= y1 and args.x <= x2 and args.y <= y2 then
		processGeneralMessage(McCraes[ZombRand(#McCraes)+1])
		return
	end
	self:o_perform()
end

local function McCrae_battery_context(player, context, items)
	--if getOnlineUsername() ~= "McCrae" then return end

	local playerObj = getSpecificPlayer(player)
	local args = { x = playerObj:getX(), y = playerObj:getY(), z = playerObj:getZ() }
	
	local x1 = SandboxVars.McCraes.X-1
	local y1 = SandboxVars.McCraes.Y-1
	local x2 = SandboxVars.McCraes.X+1
	local y2 = SandboxVars.McCraes.Y+1
	
	if args.x >= x1 and args.y >= y1 and args.x <= x2 and args.y <= y2 then
		items = ISInventoryPane.getActualItems(items)
		for _, item in ipairs(items) do
			if (item:getFullType() == 'Base.CarBatteryCharger') and item:isInPlayerInventory() then
				context:removeOptionByName(getText("ContextMenu_CarBatteryCharger_Place"))
				context:addOptionOnTop("Place your Car Battery Charger... at McCrae's!", playerObj, ISInventoryPaneContextMenu.onPlaceCarBatteryCharger, item)
				break
			end
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(McCrae_battery_context)

--[[
	getSoundManager():PlayWorldSound("teleporter", false, self.character:getCurrentSquare(), 30, 3, 10, false) ;

	local soundRadius = 4
	local volume = 8
	addSound(self.character,
				self.character:getX(),
				self.character:getY(),
				self.character:getZ(),
				soundRadius,
				volume)
]]
