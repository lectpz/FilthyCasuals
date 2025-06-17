ISBuildingMenuUI = ISBuildingMenuUI or {}

local isInSafeHouse = false
local isInCC = false
local isExcluded = false
local removeOptionList = {
    [getText("ContextMenu_Build")] = getText("ContextMenu_Build"),
    [getText("ContextMenu_MetalWelding")] = getText("ContextMenu_MetalWelding"),
    [getText("ContextMenu_BuildingMenu")] = getText("ContextMenu_BuildingMenu"),
}

local function getExclusionZones(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function getExclusionCoordinates(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^:]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

SDxferQOL = nil

local function canBuild()
    local player = getSpecificPlayer(0)
	if not player then return end
    local isOwnSafeHouse = SafeHouse.hasSafehouse(player)
	local tier, zone, x, y = checkZone()
    --local x = player:getX()
    --local y = player:getY()

    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX()-15
        local shy1 = isOwnSafeHouse:getY()-15
        local shx2 = isOwnSafeHouse:getW() + shx1 + 30
        local shy2 = isOwnSafeHouse:getH() + shy1 + 30

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
            isInSafeHouse = true
        else
            isInSafeHouse = false
        end
    end

    --local ccx1, ccy1, ccx2, ccy2 = 10800, 8750, 11332, 9072
    --if x >= ccx1 and y >= ccy1 and x <= ccx2 and y <= ccy2 then
	local bodyDamage = player:getBodyDamage()
	local boredom
	if bodyDamage then boredom = bodyDamage:getBoredomLevel() end
	
	if zone == "CC" then
        isInCC = true
    else
        isInCC = false
    end
	
	if isInCC or isInSafeHouse then
		SDxferQOL = true
		if bodyDamage then bodyDamage:setBoredomLevel(math.max(boredom - 5, 0)) end
	else
		SDxferQOL = nil
	end
	
	local exclusionZones = getExclusionZones(SandboxVars.SDnoBuild.exclusionZones) or {}
	if #exclusionZones > 0 then
		for i=1,#exclusionZones do
			local coords = getExclusionCoordinates(exclusionZones[i])
			if x >= tonumber(coords[1]) and y >= tonumber(coords[2]) and x <= tonumber(coords[3]) and y<= tonumber(coords[4]) then
				isExcluded = true
			else
				isExcluded = false
			end
		end
	end
end

Events.EveryTenMinutes.Add(canBuild)


local function noBuild_contextmenu(player, context, worldobjects, test)
    if isAdmin() or isDebugEnabled() then return end

    local playerObj = getSpecificPlayer(0)
    local x = playerObj:getX()
    local y = playerObj:getY()

    local ccx1, ccy1, ccx2, ccy2 = 10800, 8750, 11332, 9072
    if x >= ccx1 and y >= ccy1 and x <= ccx2 and y <= ccy2 then isInCC = true return end

    local isOwnSafeHouse = SafeHouse.hasSafehouse(playerObj)
    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX()-15
        local shy1 = isOwnSafeHouse:getY()-15
        local shx2 = isOwnSafeHouse:getW() + shx1 + 30
        local shy2 = isOwnSafeHouse:getH() + shy1 + 30

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then isInSafeHouse = true return end
    end
	
	local exclusionZones = getExclusionZones(SandboxVars.SDnoBuild.exclusionZones) or {}
	if #exclusionZones > 0 then
		for i=1,#exclusionZones do
			local coords = getExclusionCoordinates(exclusionZones[i])
			if x >= tonumber(coords[1]) and y >= tonumber(coords[2]) and x <= tonumber(coords[3]) and y<= tonumber(coords[4]) then
				isExcluded = true
				return 
			else
				isExcluded = false
			end
		end
	end

    local contextOptions = context:getMenuOptionNames()
    for k, v in pairs(contextOptions) do
        --print(k)
        if removeOptionList[k] then
            --local option = context:insertOptionAfter(k,removeOptionList[k])
			--option.notAvailable = true
			--local tooltip = ISWorldObjectContextMenu.addToolTip();
			--tooltip.description = tooltip.description .. "These options are only available inside your SafeHouse or CC."
			--option.toolTip = tooltip
			context:removeOptionByName(removeOptionList[k])
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(noBuild_contextmenu)


local originalOpenPanel = ISBuildingMenuUI.openPanel
function ISBuildingMenuUI.openPanel(playerObj)
    if isInSafeHouse or isInCC or isExcluded or isAdmin() or isDebugEnabled() then
        originalOpenPanel(playerObj)
    end
end

ISBuildingMenuUI.o_render = ISBuildingMenuUI.render
function ISBuildingMenuUI:render()
    if isInSafeHouse or isInCC or isExcluded  or isAdmin() or isDebugEnabled() then self:o_render() return end
	self:close()
end

BuildingMenuTilePickerList.o_render = BuildingMenuTilePickerList.render
function BuildingMenuTilePickerList:render()
    if isInSafeHouse or isInCC or isExcluded  or isAdmin() or isDebugEnabled() then self:o_render() return end
	self:close()
end