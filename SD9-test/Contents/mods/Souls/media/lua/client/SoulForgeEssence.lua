local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "
local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "
local white = " <RGB:1,1,1> "

local function countItems(playerObj, item)
	local inv = playerObj:getInventory()
	local items = inv:getItemsFromFullType(item, false)
	local count = items:size()
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

local rangedAttr = {
	"mdzMaxDmg",
	"mdzMinDmg",
	"mdzAimingTime",
	"mdzReloadTime",
	"mdzRecoilDelay",
	"mdzCritDmgMultiplier",
	"mdzCriticalChance",
}

local meleeAttr = {
	"mdzMaxDmg",
	"mdzMinDmg",
	"mdzCritDmgMultiplier",
	"mdzCriticalChance",
}

local function remove_mdz(str)
	if str and str:sub(1, 3) == "mdz" then
		return str:sub(4) -- Return the string starting from the 4th character
	else
		return str -- Return the original string if it doesn't start with "mdz"
	end
end

local function hasTierTag(str)
	if str then
		local t_values = {"T5", "T4", "T3", "T2", "T1"}
		for i=1, #t_values do
			value = t_values[i]
			if str:find(value) then
				return value
			end
		end
	end
	return nil
end

local function attrTier(attr)
	if attr > 1.09 then return 5
	elseif attr > 1.075 then return 4
	elseif attr > 1.06 then return 3
	elseif attr > 1.045 then return 2
	else return 1
	end
end

local function extractAttribute(item, playerObj, tier, attr, attrValue, itemName)
	local playerInv = getSpecificPlayer(0):getInventory()
	playerInv:Remove(item)
	for i=1, tier do
		playerInv:RemoveOneOf("SoulForge.SoulShardT"..tier)
	end
	for i=1, math.min(5,tier+1) do
		playerInv:RemoveOneOf("SoulForge.SoulShardT"..math.min(5,tier+1))
	end
	for i=1,(tier+2)^2 do
		playerInv:RemoveOneOf("Base.ScrapMetal")
	end
	local weapEssence = InventoryItemFactory.CreateItem("SoulForge.Essence")
	weapEssence:setName(itemName .. " Weapon Essence: [T" .. tier .. "] " .. attr .. " (" .. attrValue .. ")")
	weapEssence:getModData()[attr] = attrValue
	if itemName then
		weapEssence:getModData()[itemName] = true
	end
	playerInv:AddItem(weapEssence)
end

local function extractMats(attr, weaponOption, tier)
	local tooltip = ISWorldObjectContextMenu.addToolTip();
	tooltip.description = tooltip.description .. green .. " <LINE> "
	tooltip.description = tooltip.description .. " <LINE> " .. gold .. "Materials required to extract " .. attr .. ":"
	itemToolTipMats(tooltip, "Base.ScrapMetal", weaponOption, (tier+2)^2)
	itemToolTipMats(tooltip, "SoulForge.SoulShardT"..tier, weaponOption, tier)
	itemToolTipMats(tooltip, "SoulForge.SoulShardT"..tier+1, weaponOption, tier+1)
	weaponOption.toolTip = tooltip
end

local function weaponEssence(player, context, items)
    local playerObj = getSpecificPlayer(0)
    local playerInv = playerObj:getInventory()
	local _items = ISInventoryPane.getActualItems(items)
	
	for i=1, #_items do
		local item = _items[i]
		if not item:isInPlayerInventory() or item:isEquipped() or item:isFavorite() or item:getContainer():getType() ~= "none" then return end -- item must be in inventory
		if not item:IsWeapon() then return end
		local iMD = item:getModData()
		local itemName = item:getScriptItem():getDisplayName()
		
		if item:isRanged() then
			local rangedMenu = nil
			for i=1,#rangedAttr do
				local attrValue = iMD[rangedAttr[i]]
				if attrValue then
					rangedMenu = context:addOption("Extract Attributes from " .. itemName, nil)
					local submenu = ISContextMenu:getNew(context)
					context:addSubMenu(rangedMenu, submenu)
					break
				end
			end
			
			if rangedMenu then
				for i=1,#rangedAttr do
					local attrValue = iMD[rangedAttr[i]]
					if attrValue then
						local tier = attrTier(attrValue)
						local attr = remove_mdz(rangedAttr[i])
						local rangedOption = submenu:addOption("Extract Tier " .. tier .. " " .. attr .. "(" .. attrValue .. ")", item, extractAttribute, playerObj, tier, attr, attrValue, itemName)
						extractMats(attr, rangedOption, tier)
					end
				end
				break
			end
		else
			local meleeMenu = nil
			local itemTags = item:getTags()
			for k=0, itemTags:size()-1 do
				local itemTier = hasTierTag(itemTags:get(k))
				if itemTier then 
					for i=1,#meleeAttr do
						local attrValue = iMD[meleeAttr[i]]
						if attrValue then
							meleeMenu = context:addOption("Extract Attributes from " .. itemName, nil)
							local submenu = ISContextMenu:getNew(context)
							context:addSubMenu(meleeMenu, submenu)
							break
						end
					end
				end
			end
			
			if meleeMenu then
				local itemTags = item:getTags()
				for k=0, itemTags:size()-1 do
					local itemTier = hasTierTag(itemTags:get(k))
					if itemTier then 
						for i=1,#meleeAttr do
							local attrValue = iMD[meleeAttr[i]]
							if attrValue then
								local tier = attrTier(attrValue)
								local attr = remove_mdz(meleeAttr[i])
								local meleeOption = submenu:addOption("Extract Tier " .. tier .. " " .. " " .. attr .. "(" .. attrValue .. ")", item, extractAttribute, playerObj, tier, attr, attrValue, itemName)
								extractMats(attr, meleeOption, tier)
							end
						end
						break
					end
				end
			end
		end
	end
end
--Events.OnPreFillInventoryObjectContextMenu.Add(weaponEssence)