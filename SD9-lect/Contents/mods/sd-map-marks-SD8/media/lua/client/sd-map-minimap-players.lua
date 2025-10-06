require 'ISUI/Maps/ISWorldMap'
require 'ISUI/Maps/ISMiniMap'

local SETTINGS = { --somewhatfrog [[
    options = {
        playersOnMinimap = true,
        namesOnMinimap = true,
    },
    names = {
        playersOnMinimap = "Show players on minimap",
        namesOnMinimap = "Show names on minimap",
    },
    mod_id = "sd-map-marks-SD8",
    mod_shortname = "Sunday Drivers Map Marks",
    mod_fullname = "Sunday Drivers Map Marks",
}

if ModOptions and ModOptions.getInstance then
	local settings = ModOptions:getInstance(SETTINGS)
    --local playersOnMinimap = settings:getData("playersOnMinimap")
    --local namesOnMinimap = settings:getData("namesOnMinimap")
    --playersOnMinimap.tooltip = "Show players on minimap duh"
    --namesOnMinimap.tooltip = "Show names on minimap duh"
    function settings:OnApplyInGame() end
end --]]

local dot_size              = 3
local getPlayerFromUsername = getPlayerFromUsername
local getAllPlayers         = getOnlinePlayers
local getPlayer             = getPlayer

if getAllPlayers() == nil then
	local getSpecificPlayer = getSpecificPlayer
	local players           = {
		size = getNumActivePlayers,
		get = function(_, index)
			return getSpecificPlayer(index)
		end
	}

	getAllPlayers           = function()
		return players
	end
end


local function getPos(player)
	local vehicle = player:getVehicle()

	if vehicle then
	return vehicle:getX(), vehicle:getY(), player:getZ()
	else
	return player:getX(), player:getY(), player:getZ()
	end
end

local function getMapPos(a, x, y)
	return a.mapAPI:worldToUIX(x, y), a.mapAPI:worldToUIY(x, y)
end

local TextManager = getTextManager()
local function getTextSize(font, text)
	return TextManager:MeasureStringX(font, text)
end

local function getDistance(a, b)
	local x = (b[1] - a[1]) * (b[1] - a[1])
	local y = (b[2] - a[2]) * (b[2] - a[2])
	local z = (b[3] - a[3]) * (b[3] - a[3])

	return math.sqrt(x + y + z)
end

local function drawMiniMapPlayerDot(self, player, myX, myY, myZ)
	if player:isInvisible() and not isAdmin() then
		return
	end

	local x, y, z = getPos(player)
	local dist = getDistance({ x, y, z }, { myX, myY, myZ })
	if dist > 1000 then
		return
	end

	if not self.inner then
		return
	end

	local X, Y = getMapPos(self.inner, x, y)
	self:drawRect(X - 1, Y - 1, dot_size * 2 - 1, dot_size * 2 - 1, 1, 1, 0, 0)

	local name = player:getUsername()
	local name_sizeX = getTextSize(UIFont.Small, name)

	if SETTINGS.options.namesOnMinimap then --somewhatfrog [[]]
	   self:drawRect(X + dot_size + 4, Y - 5, name_sizeX + 1, 14, 0.7, 0.3, 0.3, 0.3)
	   self:drawText(name, X + dot_size + 5, 1 + Y - dot_size * 2, 1.0, 1.0, 1.0, 1, UIFont.Small)
	end

	-- if server_config.MiniAllowHeight and client_config.MiniShowHeight then
	-- 	local delta = myZ - z

	-- 	if delta < 0 then
	-- 		for i=-1, delta, -1 do
	-- 			self:drawText('_', X-1, Y - 9 - dot_size*2 - -1*i*2, 0, 0, 0, 1, UIFont.Small)
	-- 		end
	-- 	elseif delta > 0 then
	-- 		for i=1, delta do
	-- 			self:drawText('_', X-1, Y - 7 + i*2, 0, 0, 0, 1, UIFont.Small)
	-- 		end
	-- 	end
	-- end
end

local oldMiniMapOuterRender = ISMiniMapOuter.render
ISMiniMapOuter.render = function(self)
	oldMiniMapOuterRender(self)

	if not SETTINGS.options.playersOnMinimap then return end --somewhatfrog [[]]

	self:setStencilRect(0, 0, self:getWidth(), self:getHeight() - 15)

	local character = getPlayer()
	local myX, myY, myZ = getPos(character)

	local players = getAllPlayers()

	if players then
		for i = 1, players:size() do
			local player = players:get(i - 1)
			drawMiniMapPlayerDot(self, player, myX, myY, myZ)
		end
	end

	self:clearStencilRect()
end
