local Menu = {}

local Tickets = require("QualityMenu/Tickets")
local Tooltip = require("QualityMenu/Tooltip")
local Utils = require("QualityMenu/Utils")
local Config = require("QualityMenu/Config")

function Menu.applyQualityTicket(weapon, statKey, ticket)
    if not statKey or not ticket then
        print("[Menu] Error: Missing statKey or ticket", statKey, ticket)
        return
    end

    print("[Menu] Applying ticket:", statKey, ticket.tier, ticket.bonus)
    Tickets.applyTicket(weapon, statKey, ticket)
    HaloTextHelper.addTextAbovePlayer(getPlayer(),
        "Applied " .. Tooltip.getDisplayName(statKey) .. " +" .. (ticket.bonus * 100) .. "%", 0, 1, 0)
end

function Menu.buildQualityTicketMenu(player, context, weapon, tickets)
    print("[Menu] Building quality ticket submenu")

    local parent = context:addOption("Quality Augment Menu", weapon)
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(parent, submenu)
    print("[Menu] Parent added:", tostring(parent ~= nil), "submenu created:", tostring(submenu ~= nil))

    local md = weapon:getModData() or {}
    local statSummary, count = "", 0
    for statKey, _ in pairs(Config.statMap) do
        local label = Tooltip.getDisplayName(statKey)
        local bonus = Utils.formatEnhancerBonus(md, statKey)
        statSummary = statSummary .. label .. ": " .. bonus .. " <LINE> "
        count = count + 1
    end
    if count == 0 then statSummary = "No enhancer multipliers found." end

    local statOpt = submenu:addOption("Stats", weapon, function() print("[Menu] Stats hovered") end)
    statOpt.notAvailable = true
    Tooltip.attachSimpleTooltip(statOpt, "Current Enhancer Multipliers", statSummary)
    print("[Menu] Added 'Stats' row; submenu options now:", #submenu.options)

    if weapon:isRanged() then
        print("[Menu] Ranged weapon; returning after Stats")
        return
    end

    local valid = Config.soulStats and Config.soulStats.Melee or {}
    for statKey, list in pairs(tickets or {}) do
        if Utils.contains(valid, statKey) then
            table.sort(list, function(a, b) return a.bonus > b.bonus end)
            local child = ISContextMenu:getNew(context)
            local head = submenu:addOption(Tooltip.getDisplayName(statKey) .. " Tickets")
            submenu:addSubMenu(head, child)
            print(string.format("[Menu] Added '%s Tickets' with %d items", statKey, #list))

            child:addOption("Apply All Tickets", nil, function()
                print(string.format("[Menu] ApplyAll %s x%d", statKey, #list))
                local p = getSpecificPlayer(player)
                for _, t in ipairs(list) do
                    Menu.applyQualityTicket(weapon, statKey, t)
                    if p then p:getInventory():Remove(t.item) end
                end
            end)

            for _, t in ipairs(list) do
                local label = string.format("%s | %s | +%.2f%%", Tooltip.getDisplayName(statKey), t.tier, t.bonus * 100)
                local opt = child:addOption(label, weapon, Menu.applyQualityTicket, weapon, statKey, t)
                Tooltip.attachSimpleTooltip(opt, Tooltip.getDisplayName(statKey),
                    "Enhances this stat by +" .. (t.bonus * 100) .. "%")
            end
        end
    end
end

function Menu.addMenu(player, context, items)
    print("[QualityMenu] addMenu called")

    local playerObj = getSpecificPlayer(player)
    local held = playerObj and playerObj:getPrimaryHandItem()
    if held then
        print("[Debug] Currently held weapon:", held:getName(), "| FullType:", held:getFullType())
    else
        print("[Debug] No weapon currently equipped")
    end

    local weaponCtx = Utils.getForgeableWeapon(items, { module = "RMWeapons" })
    if not weaponCtx then
        print("[QualityMenu] No valid weapon in context")
        return
    end

    print("[QualityMenu] Found weapon:", weaponCtx:getName())
    for k, v in pairs(weaponCtx:getModData() or {}) do print("  ", k, v) end

    local tickets = Tickets.scanInventory(playerObj)
    local ok, err = pcall(function()
        Menu.buildQualityTicketMenu(player, context, weaponCtx, tickets or {})
    end)
    if not ok then
        print("[QualityMenu] ERROR in buildQualityTicketMenu:", tostring(err))
        print(debug and debug.traceback and debug.traceback() or "[traceback unavailable]")
    end
end

Events.OnFillInventoryObjectContextMenu.Add(Menu.addMenu)

return Menu
