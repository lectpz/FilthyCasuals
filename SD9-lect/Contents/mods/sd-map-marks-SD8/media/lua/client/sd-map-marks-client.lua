require "ISUI/Maps/ISWorldMap"

local mapMarks = {}
local playerMessage = {}

local TextManager = getTextManager()
local function getTextSize(font, text)
    return TextManager:MeasureStringX(font, text)
end

local ISWorldMap_render = ISWorldMap.render
function ISWorldMap:render()
    local player_name = getPlayer():getUsername()
    local zombiekills = getPlayer():getZombieKills()

    local alpha = math.fmod(getTimeInMillis(), 2000) / 3000
    local fullalpha = math.fmod(getTimeInMillis(), 1500) / 1500

    ISWorldMap_render(self)
    -- local texBS = getTexture("media/ui/LootableMaps/map_skull.png")

    local dot_size = 3

    for name, v in pairs(mapMarks)
    do
        -- Draw blue dot
        local blue_x = mapMarks[name]['objective_x']
        local blue_y = mapMarks[name]['objective_y']

        if blue_x and blue_y
        then
            local rx = self.mapAPI:worldToUIX(tonumber(blue_x), tonumber(blue_y))
            local ry = self.mapAPI:worldToUIY(tonumber(blue_x), tonumber(blue_y))

            -- Rectangle size
            local size = 30 * (1.0 - fullalpha)
            local rect_alpha = math.max(0, -0.5 + fullalpha)
            self:drawRect(rx - size, ry - size, size * 2, size * 2, rect_alpha, 0.0, 0.0, 1.0)
            self:drawRect(rx - 4, ry - 4, 8, 8, 0.8, 0.0, 0.0, 1.0)
            -- self:drawRect(rx - 4, ry - 4, 8, 8, 1.0 - alpha, 0.0, 0.0, 1.0)

            local name_width = getTextSize(UIFont.Small, "Activity Detected")
            self:drawRect(rx + dot_size + 4, ry - 7, name_width + 2, 14, 0.5, 0.5, 0.5, 0.5)
            self:drawText("Activity Detected", rx + dot_size + 5, ry - dot_size * 2 - 1, 0.2, 0.2, 0.2, 1, UIFont.Small)
        end

        local corpse_x = mapMarks[name]['corpse_x']
        local corpse_y = mapMarks[name]['corpse_y']

        -- if player_name == name --or zombiekills >= 50
        if corpse_x and corpse_y
        then
            local corpse_name = "Corpse: " .. name
            local rx = self.mapAPI:worldToUIX(tonumber(corpse_x), tonumber(corpse_y))
            local ry = self.mapAPI:worldToUIY(tonumber(corpse_x), tonumber(corpse_y))
            self:drawRect(rx - 4, ry - 4, 8, 8, 1.0 - alpha, 1.0, 0.0, 0.0)

            local name_width = getTextSize(UIFont.Small, corpse_name)
            self:drawRect(rx + dot_size + 4, ry - 7, name_width + 2, 14, 0.5, 0.5, 0.5, 0.5)
            self:drawText(corpse_name, rx + dot_size + 5, ry - dot_size * 2 - 1, 0.2, 0.2, 0.2, 1, UIFont.Small)
        end
        -- end
    end
end

local function PrintStatus()
    if playerMessage
    then
        local line = 0
        for _, message in pairs(playerMessage)
        do
            getTextManager():DrawString(UIFont.Small, 163, 8 + (16 * line), message, 13, 13, 13, 0.8);
            line = line + 1
        end
    end
end

local Commands = {};
local moduleName = "SDT";

function Commands.MapMarks(args)
    -- Stein=corpse_x:12000;corpse_y:8000;message:line1/line2
    mapMarks = {}
    newPlayerMessage = {}

    local player_name = getPlayer():getUsername()

    for name, v in pairs(args)
    do
        mapMarks[name] = {}

        local marks = args[name]['marks']
        local tokens = string.split(marks, ';')
        for i = 1, #tokens
        do
            local values = string.split(tokens[i], ':')
            mapMarks[name][values[1]] = values[2]

            if values[1] == 'message' and name == player_name
            then
                newPlayerMessage = string.split(values[2], '/')
            end
        end
    end

    playerMessage = newPlayerMessage
end

local onServerCommand = function(module, command, args)
    if module == moduleName and Commands[command] then
        args = args or {}
        Commands[command](args);
    end
end
Events.OnServerCommand.Add(onServerCommand)

Events.OnGameStart.Add(function()
    Events.OnPostUIDraw.Add(PrintStatus);
end);
