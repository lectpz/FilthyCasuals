if isServer() then return end

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "

local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "

local white = " <RGB:1,1,1> "

local function setOwner(item)
    local owner = item:getModData()["_O"]
    local currentUser = getOnlineUsername()
    if owner == currentUser then return end
    item:getModData()["_O"] = currentUser
end

local function checkContainer(item)
    if item:getModData()["_O"] == getOnlineUsername() then return end
    local container = item:getContainer()
    if container and container:isInCharacterInventory(getPlayer()) then
        setOwner(item)
    end
end

--[[local function tooltipInfo(item)
    local tooltip= nil
	local prevTooltip = item:getTooltip() or ""
    local owner = item:getModData()["_O"]
    if owner then 
        tooltip = prevTooltip ..
					gold .. "\n" .. getText("IGUI_IO_Owner")..": "..owner
    end
	local iMD = item:getModData()
	if iMD and iMD.mdzPrefix then
			
		tooltip = tooltip .. "\n" .. "Quality modifiers to weapon:\n"
		if iMD.mdzPrefix then tooltip = tooltip .. "\nWeapon Quality: " .. iMD.mdzPrefix .. "\n" end
		if iMD.mdzMinDmg then tooltip = tooltip .. "\n" .. string.format("%.2f", iMD.mdzMinDmg)  .. "x More Minimum Damage\n" end
		if iMD.mdzMaxDmg then tooltip = tooltip .. string.format("%.2f", iMD.mdzMaxDmg)  .. "x More Maximum Damage\n" end
		if iMD.mdzCriticalChance then tooltip = tooltip .. string.format("%.2f", iMD.mdzCriticalChance)  .. "x More Critical Chance\n" end
		if iMD.mdzCritDmgMultiplier then tooltip = tooltip .. string.format("%.2f", iMD.mdzCritDmgMultiplier)  .. "x More Critical Damage Multiplier\n" end
	end
    return tooltip
end

local oldRender = ISToolTipInv.render
function ISToolTipInv:render()
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        local item = self.item
        checkContainer(item)
        self.item:setTooltip(tooltipInfo(item))
        oldRender(self)
    end
end]]


local function getCustomTooltipText(item, baseTooltip)
    local newTooltipText = getText(baseTooltip) or baseTooltip
	if baseTooltip ~= "" then newTooltipText = newTooltipText .. "\n\n" end

    local iMD = item:getModData()
    local owner = iMD["_O"]

    if owner then
        newTooltipText = newTooltipText .. getText("IGUI_IO_Owner") .. ": " .. owner
    end
	
	if iMD.KillCount then
		local o_scriptItem = ScriptManager.instance:getItem(item:getFullType())
		weaponMaxCond = o_scriptItem:getConditionMax()
		weaponCondLowerChance = o_scriptItem:getConditionLowerChance()
		weaponRepairedStack = item:getHaveBeenRepaired()
		soulsRequired = math.floor(weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage())
		
		newTooltipText = newTooltipText .. "\n\n" .. "Soul Power: " .. iMD.KillCount .. "/" .. soulsRequired
	end

    if iMD and iMD.mdzPrefix then
        newTooltipText = newTooltipText .. "\n\n" .. "Quality modifiers to weapon:"
        if iMD.mdzPrefix then newTooltipText = newTooltipText .. "\n" .. "Weapon Quality: " .. iMD.mdzPrefix end
        if iMD.mdzMinDmg then newTooltipText = newTooltipText .. "\n" .. string.format("%.2f", iMD.mdzMinDmg) .. "x More Minimum Damage" end
        if iMD.mdzMaxDmg then newTooltipText = newTooltipText .. "\n" .. string.format("%.2f", iMD.mdzMaxDmg) .. "x More Maximum Damage" end
        if iMD.mdzCriticalChance then newTooltipText = newTooltipText .. "\n" .. string.format("%.2f", iMD.mdzCriticalChance) .. "x More Critical Chance" end
        if iMD.mdzCritDmgMultiplier then newTooltipText = newTooltipText .. "\n" .. string.format("%.2f", iMD.mdzCritDmgMultiplier) .. "x More Critical Damage Multiplier" end
    end

    return newTooltipText
end

local oldRender = ISToolTipInv.render
function ISToolTipInv:render()
    if self.item and (not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck) then
        local originalTooltip = self.item:getTooltip() or ""
        local newTooltip = getCustomTooltipText(self.item, originalTooltip)
        self.item:setTooltip(newTooltip)
        oldRender(self)
        self.item:setTooltip(originalTooltip)
    end
end

local oldPerfom = ISInventoryTransferAction.perform
function ISInventoryTransferAction:perform()
    setOwner(self.item)
    oldPerfom(self)
end

local dropItem = ISInventoryPaneContextMenu.dropItem
ISInventoryPaneContextMenu.dropItem = function(item, player)
    setOwner(item)
    dropItem(item,player)
end