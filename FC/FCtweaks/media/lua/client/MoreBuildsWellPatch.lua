local function RemoveMoreBuildsToolTip()
	Events.DoSpecialTooltip.Remove(DoSpecialWellTooltip)
end

Events.OnGameStart.Add(RemoveMoreBuildsToolTip)

local function DoSpecialWellTooltipFC(tooltipUI, square)
	local playerObj = getSpecificPlayer(0)
	if not playerObj or playerObj:getPerkLevel(Perks.Woodwork) < 4 or playerObj:getZ() ~= square:getZ() or
			playerObj:DistToSquared(square:getX() + 0.5, square:getY() + 0.5) > 2 * 2 then
		return
	end
	
	local waterwell = ISWaterWell.findObject(square)
	if not waterwell then--or not waterwell:getModData()["waterMax"] then 
		return 
	else
		local smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
		tooltipUI:setHeight(6 + smallFontHgt + 6 + smallFontHgt + 12)

		local textX = 12
		local textY = 6 + smallFontHgt + 6
		tooltipUI:DrawTextureScaledColor(nil, 0, 0, tooltipUI:getWidth(), tooltipUI:getHeight(), 0, 0, 0, 0.75)
		tooltipUI:DrawTextCentre(getText("ContextMenu_NaturalWaterSource"), tooltipUI:getWidth() / 2, 6, 1, 1, 1, 1)
		tooltipUI:DrawText(getText('ContextMenu_ItemWaterCapacity', waterwell:getWaterAmount()), textX, textY, 1, 1, 1, 1)	
	end

end

Events.DoSpecialTooltip.Add(DoSpecialWellTooltipFC)
