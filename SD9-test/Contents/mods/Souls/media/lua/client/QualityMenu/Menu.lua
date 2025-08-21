local Menu    = {}

local Tickets = require("QualityMenu/Tickets")
local Tooltip = require("QualityMenu/Tooltip")
local Utils   = require("QualityMenu/Utils")
local Config  = require("QualityMenu/Config")

local function resolvePlayer(player)
    if type(player) == "number" then
        local po = getSpecificPlayer(player)
        return po
    elseif type(player) == "userdata" then
        return player
    end
    return nil
end

local function feedback(playerObj, msg)
    local hasHalo = type(HaloTextHelper) == "table" and type(HaloTextHelper.addTextAbovePlayer) == "function"
    if hasHalo and playerObj then
        HaloTextHelper.addTextAbovePlayer(playerObj, msg, 0, 1, 0)
    elseif playerObj and playerObj.Say then
        playerObj:Say(msg)
    end
end

function Menu.applyQualityTicket(weapon, player, statKey, ticket, removeItem)
    if not weapon or not statKey or not ticket then
        return
    end

    local applyTicket = Tickets.applyTicket(weapon, statKey, ticket)
	if not applyTicket then return end

    local playerObj = resolvePlayer(player)
    if removeItem and playerObj and ticket.item then
        local inv = playerObj:getInventory()
        if inv then
            inv:Remove(ticket.item)
        end
    end

    local display = (Tooltip and Tooltip.getDisplayName) and Tooltip.getDisplayName(statKey) or tostring(statKey)
    local pct = (ticket.bonus or 0) * 100
    feedback(playerObj, string.format("Applied %s +%.0f%%", display, pct))
end

function Menu.buildQualityTicketMenu(player, context, weapon, tickets)

    local parent  = context:addOption("Quality Enhancer Tickets", weapon)
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(parent, submenu)

    local md = weapon:getModData() or {}
    local statSummary, count = "", 0
    for statKey, _ in pairs(Config.statMap) do
        local label = Tooltip.getDisplayName(statKey)
        local bonus = Utils.formatEnhancerBonus(md, statKey)
        statSummary = statSummary .. label .. ": " .. bonus .. " <LINE> "
        count = count + 1
    end
    if count == 0 then statSummary = "No enhancer multipliers found." end

    local statOpt = submenu:addOption("Stats", weapon, nil)
    statOpt.notAvailable = true
    Tooltip.attachSimpleTooltip(statOpt, "Current Enhancer Multipliers", statSummary)


    local validStats = Utils.getValidStatsFor and Utils.getValidStatsFor(weapon) or
        (Config.soulStats and Config.soulStats.Melee) or {}
    for statKey, list in pairs(tickets or {}) do
        if Utils.contains(validStats, statKey) then
            table.sort(list, function(a, b) return (a.bonus or 0) > (b.bonus or 0) end)

            local child = ISContextMenu:getNew(context)
            local head  = submenu:addOption(Tooltip.getDisplayName(statKey) .. " Tickets")
            submenu:addSubMenu(head, child)

            child:addOption("Apply All Tickets", nil, function()
				for i=1,#list do
					local t = list[i]
                    Menu.applyQualityTicket(weapon, player, statKey, t, true)
                end
            end)

			for i=1,#list do
				local t = list[i]
                local label = string.format("%s | %s | +%.2f%%", Tooltip.getDisplayName(statKey), t.tier,
                    (t.bonus or 0) * 100)
                local opt   = child:addOption(label, weapon, Menu.applyQualityTicket, player, statKey, t, true)
                Tooltip.attachSimpleTooltip(opt, Tooltip.getDisplayName(statKey),
                    string.format("Enhances this stat by +%.2f%%", (t.bonus or 0) * 100))
            end
        end
    end
end

-- Entry point for PZ: Events.OnFillInventoryObjectContextMenu
function Menu.addMenu(player, context, _items)
	local playerObj = getSpecificPlayer(player)
	local items = ISInventoryPane.getActualItems(_items)
	for i=1, #items do
		item = items[i]
		if not item:IsWeapon() then return end
		if not item:isInPlayerInventory() then return end
		local iMD = item:getModData()
		if not iMD.mdzPrefix then return end
		local tickets = Tickets.scanInventory(playerObj) or {}
		Menu.buildQualityTicketMenu(player, context, item, tickets)
		break
	end
end

Events.OnFillInventoryObjectContextMenu.Add(Menu.addMenu)

return Menu
