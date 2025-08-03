function SD_deepcopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copy[k] = SD_deepcopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local sd_original_update = ISCraftAction.update
function ISCraftAction:update()
	sd_original_update(self)
	if self.recipe and self.recipe:getOriginalname() == "Transcribe Journal" and self.item:getType() == "SkillRecoveryBoundJournal" then
		local itemSRJ = self.item:getModData()["SRJ"]
		local gmdSRJ = ModData.getOrCreate(getOnlineUsername().."SRJ_SD8")
		if itemSRJ then
			gmdSRJ["SRJ"] = SD_deepcopy(itemSRJ)
		end
	end
end

function gmdSRJ(player, context, items)
	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items)
	for i=1, #items do
		item = items[i]
		if item:getFullType() == "SD.SkillRecoveryBoundJournal" then
			local gmdSRJ = ModData.getOrCreate(getOnlineUsername())
			local newJournal = item
			local iMD = newJournal:getModData()
			if iMD["isWritten"] then return end
			context:addOption("Recover Journal",	player, function()
																	--playerInv:Remove(item)
																	--local newJournal = InventoryItemFactory.CreateItem("Base.SkillRecoveryBoundJournal")
																	local gMD = ModData.getOrCreate(getOnlineUsername().."SRJ_SD8")
																	for k,v in pairs(gMD) do
																		if not v then return end
																	end
																	iMD["SRJ"] = SD_deepcopy(gMD["SRJ"])
																	newJournal:setName(getOnlineUsername() .. "'s Recovered Journal")
																	iMD["isWritten"] = true
																	--newJournal:setModule("Base")
																	--playerInv:AddItem(newJournal)
																end)
			break
		end
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(gmdSRJ)


--[[function SRJRecovery(item)
	if not item then return end
	local player = getSpecificPlayer(0)
	if not player then return end
	local playerInv = player:getInventory()
	if not playerInv then return end
	Events.OnPlayerUpdate.Add(removeTempSRJ)
end

function removeTempSRJ(player)
	local playerInv = player:getInventory()
	playerInv:RemoveOneOf("SD.SkillRecoveryBoundJournal")
	Events.OnPlayerUpdate.Remove(removeTempSRJ)
	
	local gMD = ModData.getOrCreate(getOnlineUsername().."SRJ_SD8")
	for k,v in pairs(gMD) do
		if not v then return end
	end
	
	local newJournal = InventoryItemFactory.CreateItem("Base.SkillRecoveryBoundJournal")
	playerInv:AddItem(newJournal)
	local iMD = newJournal:getModData()
	iMD["SRJ"] = SD_deepcopy(gMD["SRJ"])
	newJournal:setName(getOnlineUsername() .. "'s Journal")
	Events.OnPlayerUpdate.Remove(removeTempSRJ)
end]]