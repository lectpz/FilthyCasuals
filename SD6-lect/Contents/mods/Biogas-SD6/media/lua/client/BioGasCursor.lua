require "BioGasUI/HBGUI"

local rGood, gGood, bGood, rBad, gBad, bBad = BioGasMenu.getRGB()
local richGood, richBad, richNeutral = BioGasMenu.getRGBRich()

BioGasCursor = {}
BioGasCursor.Type = "BioGasCursor"

function BioGasCursor:new(player,square)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.playerObj = getSpecificPlayer(player)

    o.xJoypad = -1
    o.xJoy = square:getX()
    o.yJoy = square:getY()
    o.joyfocus = not wasMouseActiveMoreRecentlyThanJoypad() and JoypadState.players[player+1]
    if o.joyfocus then
        setJoypadFocus(player, o)
    else
        getCell():setDrag(o, player)
    end
    return o
end

function BioGasCursor:derive(type)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type = type
    return o
end

function BioGasCursor:rotateMouse(x,y) end
function BioGasCursor:rotateKey(key) end
function BioGasCursor:getSprite() end
function BioGasCursor:isValid(square,north) end
function BioGasCursor:render(x,y,z,square) end
function BioGasCursor:tryBuild(x,y,z) end
function BioGasCursor:reinit() end
function BioGasCursor:onLoseJoypadFocus(joypadData) self:close() end
function BioGasCursor:onGainJoypadFocus(joypadData)
    self.joyfocus = joypadData
    getCell():setDrag(self,self.player)
end
function BioGasCursor:onJoypadDown(button, joypadData) return self:onJoypadPressButton(nil, joypadData, button) end
--function BioGasCursor:onJoypadPressButton(joypadIndex, joypadData, button) end
function BioGasCursor:onJoypadPressButton(joypadIndex, joypadData, button) --onPressButtonNoFocus
    if button == Joypad.AButton and self.valid then self:tryBuild() end
    if button == Joypad.BButton then self:close() end
    if button == Joypad.YButton then
        self.xJoy = self.playerObj:getCurrentSquare():getX()
        self.yJoy = self.playerObj:getCurrentSquare():getY()
    end
end
function BioGasCursor:onJoypadDirDown(joypadData) self.yJoy = self.yJoy + 1 end
function BioGasCursor:onJoypadDirUp(joypadData) self.yJoy = self.yJoy - 1 end
function BioGasCursor:onJoypadDirRight(joypadData) self.xJoy = self.xJoy + 1 end
function BioGasCursor:onJoypadDirLeft(joypadData) self.xJoy = self.xJoy - 1 end
function BioGasCursor:getAPrompt() return self.valid and "Interact" end --text
function BioGasCursor:getBPrompt() return getText("UI_Cancel") end
function BioGasCursor:getYPrompt() return getText("IGUI_SetCursorToPlayerLocation") end
function BioGasCursor:getLBPrompt() end
function BioGasCursor:getRBPrompt() end

function BioGasCursor:toString() return self.Type end

function BioGasCursor:hideTooltip()
    if self.tooltip then
        self.tooltip:removeFromUIManager()
        self.tooltip:setVisible(false)
        self.tooltip = nil
    end
end

function BioGasCursor:deactivate()
    self:hideTooltip()
    if self.joyfocus then setPrevFocusForPlayer(self.player) end
end

function BioGasCursor:close()
    getCell():setDrag(nil,self.player)
end

function BioGasCursor:isVisible()
    return getCell():getDrag(self.player) == BioGasCursor.cursor
end