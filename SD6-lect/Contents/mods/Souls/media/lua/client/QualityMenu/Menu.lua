local Menu    = {}

local Tickets = require("QualityMenu/Tickets")
local Tooltip = require("QualityMenu/Tooltip")
local Utils   = require("QualityMenu/Utils")
local Config  = require("QualityMenu/Config")

local function resolvePlayer(player)
    if type(player) == "number" then
        local po = getSpecificPlayer(player)
        print(string.format("[Menu] resolvePlayer: index=%d -> %s", player, tostring(po ~= nil)))
        return po
    elseif type(player) == "userdata" then
        print("[Menu] resolvePlayer: userdata -> true")
        return player
    end
    print("[Menu] resolvePlayer: unsupported arg -> nil")
    return nil
end

local function feedback(playerObj, msg)
    local hasHalo = type(HaloTextHelper) == "table" and type(HaloTextHelper.addTextAbovePlayer) == "function"
    if hasHalo and playerObj then
        HaloTextHelper.addTextAbovePlayer(playerObj, msg, 0, 1, 0)
        print("[Menu] HaloText:", msg)
    elseif playerObj and playerObj.Say then
        playerObj:Say(msg)
        print("[Menu] Say():", msg)
    else
        print("[Menu] Feedback skipped (no Halo/Say):", msg)
    end
end

function Menu.applyQualityTicket(weapon, player, statKey, ticket, removeItem)
    if not weapon or not statKey or not ticket then
        print("[Menu] ERROR applyQualityTicket: missing weapon/statKey/ticket")
        return
    end

    print(string.format("[Menu] applyQualityTicket: %s | tier=%s | bonus=%.4f",
        tostring(statKey), tostring(ticket.tier), ticket.bonus or 0))

    Tickets.applyTicket(weapon, statKey, ticket)

    local playerObj = resolvePlayer(player)
    if removeItem and playerObj and ticket.item then
        local inv = playerObj:getInventory()
        if inv then
            inv:Remove(ticket.item)
            print(string.format("[Menu] Removed ticket instance: %s", tostring(ticket.item:getFullType())))
        else
            print("[Menu] WARN: no inventory; could not remove ticket")
        end
    end

    local display = (Tooltip and Tooltip.getDisplayName) and Tooltip.getDisplayName(statKey) or tostring(statKey)
    local pct = (ticket.bonus or 0) * 100
    feedback(playerObj, string.format("Applied %s +%.0f%%", display, pct))
end

function Menu.buildQualityTicketMenu(player, context, weapon, tickets)
    print("[Menu] Building Quality Enhancer submenu")

    local parent  = context:addOption("Quality Enhancer Tickets", weapon)
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(parent, submenu)
    print(string.format("[Menu] Submenu created: %s", tostring(submenu ~= nil)))

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
    print("[Menu] Added Stats row")

    if weapon:isRanged() then
        print("[Menu] Ranged weapon detected; Quality Enhancers disabled")
        return
    end

    local validStats = Utils.getValidStatsFor and Utils.getValidStatsFor(weapon) or
        (Config.soulStats and Config.soulStats.Melee) or {}
    for statKey, list in pairs(tickets or {}) do
        if Utils.contains(validStats, statKey) then
            table.sort(list, function(a, b) return (a.bonus or 0) > (b.bonus or 0) end)

            local child = ISContextMenu:getNew(context)
            local head  = submenu:addOption(Tooltip.getDisplayName(statKey) .. " Tickets")
            submenu:addSubMenu(head, child)
            print(string.format("[Menu] Group '%s': %d ticket(s)", tostring(statKey), #list))

            child:addOption("Apply All Tickets", nil, function()
                print(string.format("[Menu] ApplyAll: %s x%d", tostring(statKey), #list))
                for _, t in ipairs(list) do
                    Menu.applyQualityTicket(weapon, player, statKey, t, true)
                end
            end)

            for _, t in ipairs(list) do
                local label = string.format("%s | %s | +%.2f%%", Tooltip.getDisplayName(statKey), t.tier,
                    (t.bonus or 0) * 100)
                local opt   = child:addOption(label, weapon, Menu.applyQualityTicket, player, statKey, t, true)
                Tooltip.attachSimpleTooltip(opt, Tooltip.getDisplayName(statKey),
                    string.format("Enhances this stat by +%.2f%%", (t.bonus or 0) * 100))
            end
        else
            print(string.format("[Menu] Skipping stat '%s' (not valid for this weapon type)", tostring(statKey)))
        end
    end
end

-- Entry point for PZ: Events.OnFillInventoryObjectContextMenu
function Menu.addMenu(player, context, items)
    print("[QualityMenu] addMenu start")

    local playerObj = resolvePlayer(player)
    if not playerObj then
        print("[QualityMenu] No player object; abort")
        return
    end

    local held = playerObj:getPrimaryHandItem()
    if held then
        print(string.format("[Debug] Held: %s | %s", tostring(held:getName()), tostring(held:getFullType())))
    else
        print("[Debug] No primary item equipped")
    end

    -- Prefer context items (PZ passes right-click selection here)
    local weapon = Utils.getForgeableWeapon(items)
    if not weapon and held and instanceof(held, "HandWeapon") then
        -- Fallback: check currently held weapon for mdzPrefix
        local md = held:getModData()
        if Utils.hasMdzPrefix and Utils.hasMdzPrefix(md) then
            weapon = held
            print(string.format("[QualityMenu] Fallback: using held weapon %s (mdzPrefix=%s)", held:getName(),
                tostring(md.mdzPrefix)))
        end
    end

    if not weapon then
        print("[QualityMenu] No mdz-prefixed HandWeapon found in context/hand; abort")
        return
    end

    print(string.format("[QualityMenu] Weapon selected: %s", tostring(weapon:getName())))
    local tickets = Tickets.scanInventory(playerObj) or {}
    Menu.buildQualityTicketMenu(player, context, weapon, tickets)
end

Events.OnFillInventoryObjectContextMenu.Add(Menu.addMenu)

return Menu
