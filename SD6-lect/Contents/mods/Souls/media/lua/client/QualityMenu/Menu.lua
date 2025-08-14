local Menu = {}

local Tickets = require("QualityMenu/Tickets")
local Tooltip = require("QualityMenu/Tooltip")
local Utils = require("QualityMenu/Utils")
local Config = require("QualityMenu/Config")

local function resolvePlayer(player)
    if type(player) == "number" then
        local po = getSpecificPlayer(player)
        print("[Menu] resolvePlayer index ->", tostring(po ~= nil))
        return po
    elseif type(player) == "userdata" then
        print("[Menu] resolvePlayer userdata -> true")
        return player
    end
    print("[Menu] resolvePlayer -> nil")
    return nil
end

function Menu.applyQualityTicket(weapon, player, statKey, ticket, removeItem)
    if not weapon or not statKey or not ticket then
        print("[Menu] ERROR applyQualityTicket: missing weapon/statKey/ticket"); return
    end
    print("[Menu] Applying ticket:", statKey, ticket.tier, ticket.bonus)

    Tickets.applyTicket(weapon, statKey, ticket)

    local playerObj = resolvePlayer(player)
    if removeItem and playerObj and ticket.item then
        local inv = playerObj:getInventory()
        if inv then
            inv:Remove(ticket.item)
            print("[Menu] Removed ticket item instance:", tostring(ticket.item:getFullType()))
        else
            print("[Menu] WARN: no inventory; could not remove ticket")
        end
    end

    local hasHalo = type(HaloTextHelper) == "table" and type(HaloTextHelper.addTextAbovePlayer) == "function"
    local nameFunc = (Tooltip and Tooltip.getDisplayName) and Tooltip.getDisplayName or tostring
    local msg = string.format("Applied %s +%.0f%%", nameFunc(statKey), (ticket.bonus or 0) * 100)

    if hasHalo and playerObj then
        HaloTextHelper.addTextAbovePlayer(playerObj, msg, 0, 1, 0)
        print("[Menu] HaloText:", msg)
    elseif playerObj and playerObj.Say then
        playerObj:Say(msg)
        print("[Menu] Say():", msg)
    else
        print("[Menu] Feedback skipped (no Halo/Say)")
    end
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
                for _, t in ipairs(list) do
                    Menu.applyQualityTicket(weapon, player, statKey, t, true) -- removeItem=true
                end
            end)

            for _, t in ipairs(list) do
                local label = string.format("%s | %s | +%.2f%%", Tooltip.getDisplayName(statKey), t.tier, t.bonus * 100)
                local opt = child:addOption(label, weapon, Menu.applyQualityTicket, player, statKey, t, true) -- removeItem=true
                Tooltip.attachSimpleTooltip(opt, Tooltip.getDisplayName(statKey),
                    "Enhances this stat by +" .. (t.bonus * 100) .. "%")
            end
        end
    end
end

function Menu.addMenu(player, context, items)
    print("[QualityMenu] addMenu called")

    local playerObj = getSpecificPlayer(player)
    if not playerObj then
        print("[QualityMenu] No playerObj (server-side or not ready); aborting")
        return
    end

    local held = playerObj:getPrimaryHandItem()
    if held then
        print("[Debug] Currently held weapon:", held:getName(), "| FullType:", held:getFullType())
    else
        print("[Debug] No weapon currently equipped")
    end

    local weaponCtx = Utils.getForgeableWeapon(player, { module = "RMWeapons" })
    if not weaponCtx then
        print("[QualityMenu] No valid weapon in primary hand")
        return
    end

    print("[QualityMenu] Found weapon:", weaponCtx:getName())
    local tickets = Tickets.scanInventory(playerObj)
    Menu.buildQualityTicketMenu(player, context, weaponCtx, tickets or {})
end

Events.OnFillInventoryObjectContextMenu.Add(Menu.addMenu)

return Menu
