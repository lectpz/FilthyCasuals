local function setSafehouseData(_title, _owner, _x, _y, _w, _h)
	local playerObj = getSpecificPlayer(0);
	--playerObj:Say(_title .. _owner .. _x .. _y .. _w .. _h)
	local safeObj = SafeHouse.addSafeHouse(_x, _y, _w, _h, _owner, false);
	safeObj:setTitle(_title);
	safeObj:setOwner(_owner);
	safeObj:updateSafehouse(playerObj);
	safeObj:syncSafehouse();
end

local function splitString(sandboxvar)
	local ztable = {}
	local pattern = "[^,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

--credit goes to Vorshim92 for the mod and code. This code is updated to allow for servermsg commands for admin tools.

ServerMessageUI = ISUIElement:derive("ServerMessageUI")

function ServerMessageUI:new (x, y, width, height)
    local o = {}
    o = ISUIElement:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.width = width;
    o.height = height;
    o.servermsg = "";
    o.servermsgTimer = 0;
    ServerMessageUI.instance = o;
    return o
end

function ServerMessageUI:initialise()
    ISUIElement.initialise(self)
    self.servermsg = nil
    self.servermsgTimer = 0
    self:setVisible(false)
end

function ServerMessageUI:prerender()
    if self.servermsg then
        local x = getCore():getScreenWidth() / 2 - self:getX()
        local y = getCore():getScreenHeight() / 4 - self:getY();
        self:drawTextCentre(self.servermsg, x, y, 1, 0.1, 0.1, 1, UIFont.Title)
        self.servermsgTimer = self.servermsgTimer - UIManager.getMillisSinceLastRender()
        if self.servermsgTimer < 0 then
            self.servermsg = nil
            self.servermsgTimer = 0
            self:setVisible(false) -- we disable it when the message is over
        end
    end
end

function ServerMessageUI:setServerMessage(message)
    self:setVisible(true)
    self.servermsg = message
    self.servermsgTimer = SandboxVars.ServerAlertFix.Timer or 5000 -- Display for 5 seconds
    if self.servermsgTimer == 0 then
        self.servermsg = nil
        self:setVisible(false)
    end
end

function ServerMessageUI.getInstance()
    if not ServerMessageUI.instance then
        local ui = ServerMessageUI:new(0, 0, 0, 0)
        ui:initialise()
        ui:addToUIManager()
    end
    return ServerMessageUI.instance
end


local originalISChat_addLineInChat = ISChat.addLineInChat
function ISChat.addLineInChat(message, tabID)
	local text = message:getText()
	local isServerAlert = message:isServerAlert()
	local playerObj = getSpecificPlayer(0)
	local safehouse = SafeHouse.hasSafehouse(playerObj)

    if isServerAlert and string.find(text, "%f[%w]" .. "SD2EZ|customSafezone" .. "%f[%W]") then
		local information = splitString(text)
		--syntax is SD2EZ|customSafezone,x1,y1,x2,y2,username
		local x1, y1, x2, y2, owner = information[2], information[3], information[4], information[5], information[6]
		--playerObj:Say(_x .. "," .. _y  .. "," .. x2 .. "," .. y2)
		
		if owner == getOnlineUsername() and not safehouse then
				
			local setX = math.floor(math.min(x1, x2));
			local setY = math.floor(math.min(y1, y2));
			local setW = math.floor(math.abs(x1 - x2) + 1);
			local setH = math.floor(math.abs(y1 - y2) + 1);

			local SHname = owner.."'s zoned safehouse"
			setSafehouseData(SHname, owner, setX, setY, setW, setH)
			playerObj:Say("Safehouse Zoned: " .. x1 .. "," .. y1  .. "," .. x2 .. "," .. y2)
			local args = {}
			args.owner = owner
			args.x1 = x1
			args.y1 = y1
			args.x2 = x2
			args.y2 = y2
			sendClientCommand(playerObj, 'sdLogger', 'customSafezone', args)
		end
	elseif isServerAlert and string.find(text, "%f[%w]" .. "SD2EZ|addToExistingSafehouse" .. "%f[%W]") then
		local information = splitString(text)
		--syntax is SD2EZ|addToExistingSafehouse,owner_username,alt_username
		local _owner, _alt = information[2], information[3]
		
		if _alt == getOnlineUsername() and not safehouse then
		
			local playerSQ = playerObj:getSquare()
			local safehouse = SafeHouse.getSafeHouse(playerSQ)
			if safehouse and safehouse:getOwner() == _owner then
				safehouse:addPlayer(_alt)
				playerObj:Say("Added to " .. _owner .. "'s Safehouse")
				local args = {}
				args.owner = _owner
				args.alt = _alt
				sendClientCommand(playerObj, 'sdLogger', 'addToSafehouse', args)
			end
		end
	elseif isServerAlert and string.find(text, "%f[%w]" .. "SD2EZ" .. "%f[%W]") then
		return
	elseif isServerAlert and string.find(text, "%f[%w]" .. "sd2ez" .. "%f[%W]") then
		return
	else
		-- Chiamiamo la versione originale
		originalISChat_addLineInChat(message, tabID)

		-- Se il messaggio è un alert del server
		if isServerAlert and not string.find(text, "%f[%w]" .. "SD2EZ|customSafezone" .. "%f[%W]") then
			-- Here, we disable the server message UI vanilla
			local chat = ISChat.instance
			if chat then
				chat.servermsg = nil
				chat.servermsgTimer = 0
			end

			-- Ricaviamo autore e testo
			local author = message:isShowAuthor() and message:getAuthor() or ""
			local text   = message:getText()

			-- Componiamo il messaggio
			local fullMsg
			if author ~= "" then
				fullMsg = author .. ": " .. text
			else
				fullMsg = text
			end

			-- Mostriamo il messaggio attraverso la nostra UI personalizzata
			local myUI = ServerMessageUI.getInstance()
			myUI:setServerMessage(fullMsg)  -- durata 5 secondi (ms)
		end
	end
end