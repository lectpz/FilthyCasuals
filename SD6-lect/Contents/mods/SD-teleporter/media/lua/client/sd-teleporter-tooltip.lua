-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

local callback_render = ISToolTipInv.render;

local function calculate_remaining()

    local world_age_hours = getGameTime():getWorldAgeHours();

    local cc = world_age_hours - SundayDriversGlobalContext.last_cc;
    local cc_remaining = SandboxVars.SDTeleporter.CooldownCCCategory - cc;

    local players = world_age_hours - SundayDriversGlobalContext.last_player;
    local players_remaining = SandboxVars.SDTeleporter.CooldownPlayerCategory - players;

    local safehouse = world_age_hours - SundayDriversGlobalContext.last_safehouse;
    local safehouse_remaining = SandboxVars.SDTeleporter.CooldownSafehouseCategory - safehouse;

    return cc_remaining, players_remaining, safehouse_remaining;
end

local bg = {a=1, r=1, g=0.8, b=1};
local bg_green = {a=1, r=0, g=0.8, b=0};
local bg_red = {a=1, r=0.8, g=0, b=0};

local function draw_remaining(tooltip, label, pos_y, remaining, font)

    local selected_bg = bg_green;
    local result = "ready";

    if (remaining > 0) then
        local fraction = math.floor(math.fmod(remaining,1) * 10)
        result = math.floor(remaining) .. "." .. fraction .. " hours"

        selected_bg = bg_red;
        if (remaining < 3) then selected_bg = bg end;
    end

    tooltip:drawText(label, 16, pos_y, bg.a, bg.r, bg.g, bg.b, font);

    local offset = getTextManager():MeasureStringX(font, label);
    tooltip:drawText(result, 16 + offset, pos_y, selected_bg.r, selected_bg.g, selected_bg.b, selected_bg.a, font);

end

local function drawTooltip(tooltip)
    local font = getCore():getOptionTooltipFont();
    local drawFont = UIFont.Medium;
    if font == "Large" then drawFont = UIFont.Large; elseif font == "Small" then drawFont = UIFont.Small; end;

    local toolwidth = tooltip:getWidth();
    local toolheight = tooltip:getHeight();
    local draw_height = getTextManager():MeasureStringY(drawFont, "XYZ");

    local box_height = draw_height * 4 + 16;

    tooltip:drawRect(0, toolheight - 1, toolwidth, box_height, tooltip.backgroundColor.a, tooltip.backgroundColor.r, tooltip.backgroundColor.g, tooltip.backgroundColor.b);
    tooltip:drawRectBorder(0, toolheight - 1, toolwidth, box_height, tooltip.borderColor.a, tooltip.borderColor.r, tooltip.borderColor.g, tooltip.borderColor.b);

    local pos_y = toolheight + 4;

    local remaining_cc, remaining_players, remaining_safehouse = calculate_remaining();

    tooltip:drawText("Remaining cooldowns:", 16, pos_y, 1, 1, 0.8, 1, drawFont);

    pos_y = pos_y + draw_height + 4;
    draw_remaining(tooltip, "CC: ", pos_y, remaining_cc, drawFont);

    pos_y = pos_y + draw_height;
    draw_remaining(tooltip, "Players: ", pos_y, remaining_players, drawFont);

    pos_y = pos_y + draw_height;
    draw_remaining(tooltip, "Safehouse: ", pos_y, remaining_safehouse, drawFont);

end

function ISToolTipInv:render()
	if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
		local itemObj = self.item;
		if itemObj then
			if itemObj:getType() == "Teleporter" or itemObj:getType() == "TeleporterConsumable" then
                drawTooltip(self)
            end
        end
    end

	return callback_render(self);
end