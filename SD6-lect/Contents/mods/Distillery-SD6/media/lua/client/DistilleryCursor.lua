require "DistilleryUI/DisUI"

local rGood, gGood, bGood, rBad, gBad, bBad = DistilleryMenu.getRGB()
local richGood, richBad, richNeutral = DistilleryMenu.getRGBRich()

DistilleryCursor = {}
DistilleryCursor.Type = "DistilleryCursor"

function DistilleryCursor:new(player,square)
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

function DistilleryCursor:derive(type)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type = type
    return o
end

function DistilleryCursor:rotateMouse(x,y) end
function DistilleryCursor:rotateKey(key) end
function DistilleryCursor:getSprite() end
function DistilleryCursor:isValid(square,north) end
function DistilleryCursor:render(x,y,z,square) end
function DistilleryCursor:tryBuild(x,y,z) end
function DistilleryCursor:reinit() end
function DistilleryCursor:onLoseJoypadFocus(joypadData) self:close() end
function DistilleryCursor:onGainJoypadFocus(joypadData)
    self.joyfocus = joypadData
    getCell():setDrag(self,self.player)
end
function DistilleryCursor:onJoypadDown(button, joypadData) return self:onJoypadPressButton(nil, joypadData, button) end
--function DistilleryCursor:onJoypadPressButton(joypadIndex, joypadData, button) end
function DistilleryCursor:onJoypadPressButton(joypadIndex, joypadData, button) --onPressButtonNoFocus
    if button == Joypad.AButton and self.valid then self:tryBuild() end
    if button == Joypad.BButton then self:close() end
    if button == Joypad.YButton then
        self.xJoy = self.playerObj:getCurrentSquare():getX()
        self.yJoy = self.playerObj:getCurrentSquare():getY()
    end
end
function DistilleryCursor:onJoypadDirDown(joypadData) self.yJoy = self.yJoy + 1 end
function DistilleryCursor:onJoypadDirUp(joypadData) self.yJoy = self.yJoy - 1 end
function DistilleryCursor:onJoypadDirRight(joypadData) self.xJoy = self.xJoy + 1 end
function DistilleryCursor:onJoypadDirLeft(joypadData) self.xJoy = self.xJoy - 1 end
function DistilleryCursor:getAPrompt() return self.valid and "Interact" end --text
function DistilleryCursor:getBPrompt() return getText("UI_Cancel") end
function DistilleryCursor:getYPrompt() return getText("IGUI_SetCursorToPlayerLocation") end
function DistilleryCursor:getLBPrompt() end
function DistilleryCursor:getRBPrompt() end

function DistilleryCursor:toString() return self.Type end

function DistilleryCursor:hideTooltip()
    if self.tooltip then
        self.tooltip:removeFromUIManager()
        self.tooltip:setVisible(false)
        self.tooltip = nil
    end
end

function DistilleryCursor:deactivate()
    self:hideTooltip()
    if self.joyfocus then setPrevFocusForPlayer(self.player) end
end

function DistilleryCursor:close()
    getCell():setDrag(nil,self.player)
end

function DistilleryCursor:isVisible()
    return getCell():getDrag(self.player) == DistilleryCursor.cursor
end