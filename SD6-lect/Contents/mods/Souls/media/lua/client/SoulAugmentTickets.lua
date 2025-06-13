local meleeStats = { "MaxDmg", "MinDmg", "CriticalChance", "CritDmgMultiplier"}
-- TODO: grab quality stats for guns
-- local gunStats = {}
-- SDSoulCount_Ranged.lua has all the modifiers

local tiers = {
	T1 = 0.001,
	T2 = 0.002,
	T3 = 0.004,
	T4 = 0.008,
	T5 = 0.016
}


-- THIS IS LECT'S ORIGINAL FUCNTION FOR QUALITY MODIFIERS
local function getQualityModifier(fullItemString)
	local tierSuffix = string.match(fullItemString, "(T%d+)$")
	if not tierSuffix then return nil end
	local tierNumber = string.sub(tierSuffix, -1)
	local moduleName = string.gsub(fullItemString, "^SoulForge.", "")
	local itemQualityModifier = string.gsub(moduleName, "_Enhancer" .. tierSuffix .. "$", "")
	return itemQualityModifier, tierNumber
end

local function ticketList(player)
    local inv = player:getInventory()
    local items = inv:getItems()
	local tickets = {}

    for i = 0, items:size() - 1 do
        local itemInv = items:get(i)
        local itemName = itemInv:getFullType()
        if string.sub(itemName, 1, 10) == "SoulForge." then
			-- TODO: also check for weapon type (melee vs ranged)
			local stat, tier = getQualityModifier(itemName)
			if stat and tier then
				local tierName = "T" .. tier
				local tierBonus = tiers[tierName]
				if tierBonus then
					tickets[stat] = tickets[stat] or {}
					table.insert(tickets[stat],
						{
							item = item,
							tier = tierName,
							bonus = tierBonus
						}
					)
				end
			end
		end
    end
	return tickets
end

local function augmentContextMenu(player, context, items) -- should I not pass in the fucking weapon too?
	local ticketList = ticketList(player)

	-- only create the menu if there are valid tickets
	if not ticketList then return end

	-- grab weapon????
	-- i think you're only allowed to do it with held weapon anyways????
	-- https://projectzomboid.com/modding/zombie/characters/IsoGameCharacter.html#getPrimaryHandItem()
	local heldItem = player:getPrimaryHandItem()

	-- return if no held item
	if not heldItem then return end
	
	augmentMenu = context:addOption("Soul Augment Ticket Upgrade", item, nil, player)
	
	if heldItem:isWeapon() then
		-- create the context menu for real this time?
		for item, tier, bonus in ticketList do
			augmentMenu:addOption(item, heldItem, nil, augmentWeapon(heldItem, item, tier, bonus))
			-- TODO: Check Lect's code to find the fancy text that does the fun numbers and stuff
		end
	end

end

-- TODO: Build augmentWeapon(weapon, item, tier, bonus)
-- Probably would contain the isRanged check so I can use either melee or ranged dict/list


Events.OnFillWorldObjectContextMenu.Add(augmentContextMenu)
