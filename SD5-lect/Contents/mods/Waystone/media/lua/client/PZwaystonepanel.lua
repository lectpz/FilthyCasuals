require "PZwaystoneserver"
require "PZwaystoneclientcore"
require "TimedActions/ISBaseTimedAction"
require "TimedActions/sd-teleporter-action"

PZwaystone.mainpanel = ISPanel:derive("PZwaystone.mainpanel")


--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function PZwaystone.mainpanel:initialise()
	ISPanel.initialise(self);
end

function PZwaystone.mainpanel:noBackground()
	self.background = false;
end

function PZwaystone.mainpanel:close()
	self:setVisible(false);
    self:removeFromUIManager()
end



function PZwaystone.mainpanel:modal(button, backuppos,player,instance)

    if button.internal ~= "OK" then return end


    if getGameTime():getModData().PZwaystone == nil then
        getGameTime():getModData().PZwaystone = {}
    end

    local stonex = instance.stoneobject:getX()
    local stoney = instance.stoneobject:getY()
    local stonez = instance.stoneobject:getZ()
    local stringposz =  PZwaystone.getstringpos(stonex,stoney,stonez)


    local stonetable = {
        name = button.parent.entry:getText(),
        postion = {stonex,stoney,stonez},
        stringpos = stringposz
    }

    getGameTime():getModData().PZwaystone[stringposz] = stonetable

    if isClient() then
	--if isServer() then

        sendClientCommand("PZwaystone","newwaystone",{stringposz,stonetable})
		--sendServerCommand("PZwaystone","newwaystone",{stringposz,stonetable})

    end
end

function PZwaystone.mainpanel:newpoint()

    local stringnewpoint

    if self.scrolllist.selected > 0 then
        stringnewpoint = self.scrolllist.items[self.scrolllist.selected].item.name
    end
    stringnewpoint= stringnewpoint or "mynewpoint"
    
    local modal = ISTextBox:new(0, 0, 280, 180, "PointName:", stringnewpoint, nil, self.modal, nil, 1,1,self)
    modal:initialise()
    modal:addToUIManager()
end



function PZwaystone.mainpanel.PZwaystoneDialog(this,button,pos)


    -- print(this,button,pos)
    if button.internal == "YES" then



        getGameTime():getModData().PZwaystone[pos] =nil
        if isClient() then
		--if isServer() then
            sendClientCommand("PZwaystone","deletewaystone",{pos})
			--sendServerCommand("PZwaystone","deletewaystone",{pos})
        end
    end


end

function PZwaystone.mainpanel:deletepoint()
    local listitem = self.scrolllist.items[self.scrolllist.selected]

    -- print("dialog")

    local modaldialog = ISModalDialog:new(0,0, 250, 150, getText("IGUI_shifoushanchu")..listitem.item.name, true, nil, self.PZwaystoneDialog, 0,listitem.stringpos)
    modaldialog:initialise()
    modaldialog:addToUIManager()

end

function PZwaystone.mainpanel:teleport()

	
	local playerObj = self.character
	local x = playerObj:getX()
	local y = playerObj:getY()

--	local x1 = SandboxVars.PZwaystonepanel.X1coord - 3
--	local y1 = SandboxVars.PZwaystonepanel.Y1coord - 3
--	local x2 = SandboxVars.PZwaystonepanel.X1coord + 3
--	local y2 = SandboxVars.PZwaystonepanel.Y1coord + 3

	--if x >= x1 and y >= y1 and x <= x2 and y <= y2 then

		local selectd = self.scrolllist.items[self.scrolllist.selected]
		local postion = selectd.item.postion

		--[[
		playerObj:setX(postion[1])
		playerObj:setY(postion[2])
		playerObj:setZ(postion[3])
		playerObj:setLx(postion[1])
		playerObj:setLy(postion[2])
		playerObj:setLz(postion[3])
		]]--
		
		local args = {
			safehouse_x = postion[1]-3,
			safehouse_y = postion[2]-3,
			safehouse_z = postion[3],
			player_name = getOnlineUsername()
		};
		--ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'TravelToEvent', args));
		--ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'EventTPToSH', args));
		sendClientCommand(self.character, 'SDT', 'TravelToCoordinates', args);
		--sendClientCommand("PZwaystone","EventTPToSH",args)
		--playerObj:Say("Teleport()")	
	--else
	--	playerObj:Say("I need to be in CC to teleport there.")			
	--	self:close()
	--end

end

function PZwaystone.mainpanel:shtp()

	local playerObj = self.character

	local x = playerObj:getX()
	local y = playerObj:getY()

	local x1event = SandboxVars.PZwaystonepanel.Xcoord
	local y1event = SandboxVars.PZwaystonepanel.Ycoord
	
	local x1 = x1event-3
	local y1 = y1event-3
	local x2 = x1event+3
	local y2 = y1event+3
	
	local playerModData = playerObj:getModData()

	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then--checks if the waystone is at the event coordinates
		local safehouse = SafeHouse.hasSafehouse(playerObj)
		--define safehouse bounds to check for moddata sh coordinates
		
		local sh_x = playerModData.SafeHouseX
		local sh_y = playerModData.SafeHouseY
		local sh_z = playerModData.SafeHouseZ or 0
		
		if safehouse then
		
			local xx1 = safehouse:getX()
			local yy1 = safehouse:getY()
			local xx2 = safehouse:getW() + xx1
			local yy2 = safehouse:getH() + yy1
		
			if sh_x ~= nil and sh_y ~= nil then--check moddata if not nil
			
				if sh_x >= xx1 and sh_y >= yy1 and sh_x <= xx2 and sh_y <= yy2 then--check if moddata is within actual sh bounds

					local args = {
						safehouse_x = math.floor(sh_x)-3,
						safehouse_y = math.floor(sh_y)-3,
						safehouse_z = sh_z,
						player_name = getOnlineUsername()
					};
					
					--ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'EventTPToSH', args));
					sendClientCommand(self.character, 'SDT', 'TravelToCoordinates', args);
					--sendClientCommand("PZwaystone","EventTPToSH",args)
					--playerObj:Say("shtp 1")

				else
					
					local args = {
						safehouse_x = safehouse:getX(),
						safehouse_y = safehouse:getY(),
						safehouse_z = 0,
						player_name = getOnlineUsername()
					};
					
					--ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'EventTPToSH', args));
					sendClientCommand(self.character, 'SDT', 'TravelToCoordinates', args);
					--sendClientCommand("PZwaystone","EventTPToSH",args)
					--playerObj:Say("shtp 2")
				end
			else
				local args = {
					safehouse_x = safehouse:getX(),
					safehouse_y = safehouse:getY(),
					safehouse_z = 0,
					player_name = getOnlineUsername()
				};
				
				--ISTimedActionQueue.add(SDTeleporterAction:new(playerObj, 'EventTPToSH', args));
				sendClientCommand(self.character, 'SDT', 'TravelToCoordinates', args);
				--sendClientCommand("PZwaystone","EventTPToSH",args)
				--playerObj:Say("shtp 3")
			end

		else
			playerObj:Say("I'm homeless. If only I had a SafeHouse to teleport to...")
			self.close()
		end			
	else
		playerObj:Say("Looks like I can only do this from from the Event End Marker.")
		self:close()
	end

end

function PZwaystone.mainpanel:eventreward()

	local eventx = SandboxVars.PZwaystonepanel.Xcoord
	local eventy = SandboxVars.PZwaystonepanel.Ycoord

	local x1 = eventx-3
	local y1 = eventy-3
	local x2 = eventx+3
	local y2 = eventy+3
	
	local pzplayer = getPlayer()

	local x = pzplayer:getX()
	local y = pzplayer:getY()
	
	local pzInv = pzplayer:getInventory()
	
	local eventreward1 = SandboxVars.PZwaystonepanel.eventreward1
	local eventreward2 = SandboxVars.PZwaystonepanel.eventreward2
	local eventreward3 = SandboxVars.PZwaystonepanel.eventreward3
	local eventreward4 = SandboxVars.PZwaystonepanel.eventreward4

	local ModDataSD = ModData.getOrCreate("SD5_EventReward")
	-- Try to get the value, and if it's nil, set it to false
	local claimed = ModDataSD[getCurrentUserSteamID()] or false

	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
		if not claimed then
			ModDataSD[getCurrentUserSteamID()] = true
			pzplayer:Say("Event reward claimed.")

			pzInv:AddItem(eventreward1);
			pzInv:AddItem(eventreward2);
			pzInv:AddItem(eventreward3);
			pzInv:AddItem(eventreward4);
			self:close()
		else
			pzplayer:Say("I already claimed a reward.")
		end
	else
		pzplayer:Say("The Event Reward cannot be claimed at this time.")
		self:close()
	end
	
end

function PZwaystone.mainpanel:cleareventreward()

	local playerObj = self.character
	
	local args = {}

	sendClientCommand(self.character, 'SD5_EventReward_ClientCommands', 'ResetEventReward', args);
		
	playerObj:Say("Event completion list has been wiped.")

end

function PZwaystone.mainpanel:createChildren()
	

    ISPanel.createChildren(self)

    local emptyhight = self.height/80
    local lblheighth = self.height/12
    self.lbl = ISLabel:new(6*emptyhight, emptyhight, lblheighth, getText("IGUI_WayStone_title"), 1, 1, 1, 1.0, UIFont.Large, true);
    self.lbl:initialise();
    self.lbl:instantiate();
    self:addChild(self.lbl);

    local scrollwidth = self.width*0.6
    local scrollheight = self.height - 3*emptyhight -lblheighth

    self.scrolllist = ISScrollingListBox:new(self.width - emptyhight-scrollwidth, 2*emptyhight + lblheighth, scrollwidth, scrollheight)
	self.scrolllist:initialise()
	self.scrolllist:instantiate()
	self.scrolllist.drawBorder = true
	self.scrolllist:setFont(UIFont.Large, 10)
	self.scrolllist:setOnMouseDownFunction(self, self.onMapSelected)
	self:addChild(self.scrolllist)
    


    local buttonheight = self.height/12
    local buttonwidth = self.width - 7*emptyhight - scrollwidth

    self.buttonclose = ISButton:new(3*emptyhight, self.height -emptyhight -buttonheight ,buttonwidth,buttonheight , getText("IGUI_PZwsClose"), self, self.close);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);


    local buttonnewy = 2*emptyhight + lblheighth


    self.buttonnew = ISButton:new(3*emptyhight,  buttonnewy ,buttonwidth,buttonheight , getText("IGUI_PZwsNew"), self, self.newpoint);
    self.buttonnew.anchorTop = false
    self.buttonnew.anchorBottom = false
    self.buttonnew:initialise();
    self.buttonnew:instantiate();
    self.buttonnew.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttonnew:setEnabled(false)
    self:addChild(self.buttonnew);

    buttonnewy = buttonnewy + buttonheight + emptyhight
    self.buttondelete = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , getText("IGUI_PZwsDelete"), self, self.deletepoint);
    self.buttondelete.anchorTop = false
    self.buttondelete.anchorBottom = false
    self.buttondelete:initialise();
    self.buttondelete:instantiate();
    self.buttondelete.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttondelete:setEnabled(false)
    self:addChild(self.buttondelete);

    buttonnewy = buttonnewy + buttonheight + emptyhight
    self.buttonteleport = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , getText("IGUI_PZwsteleport"), self, self.teleport);
    self.buttonteleport.anchorTop = false
    self.buttonteleport.anchorBottom = false
    self.buttonteleport:initialise();
    self.buttonteleport:instantiate();
    self.buttonteleport.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttonteleport:setEnabled(false);
    self:addChild(self.buttonteleport);
	
	buttonnewy = buttonnewy + buttonheight + emptyhight
    self.buttonshtp = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , getText("IGUI_PZwsshtp"), self, self.shtp);
    self.buttonshtp.anchorTop = false
    self.buttonshtp.anchorBottom = false
    self.buttonshtp:initialise();
    self.buttonshtp:instantiate();
    self.buttonshtp.borderColor = {r=1, g=1, b=1, a=0.5};
    --self.buttonshtp:setEnabled(false);
    self:addChild(self.buttonshtp);
	
	buttonnewy = buttonnewy + buttonheight + emptyhight
    self.buttoneventreward = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , getText("IGUI_PZwseventreward"), self, self.eventreward);
    self.buttoneventreward.anchorTop = false
    self.buttoneventreward.anchorBottom = false
    self.buttoneventreward:initialise();
    self.buttoneventreward:instantiate();
    self.buttoneventreward.borderColor = {r=1, g=1, b=1, a=0.5};
    --self.buttoneventreward:setEnabled(false);
    self:addChild(self.buttoneventreward);	

	buttonnewy = buttonnewy + buttonheight + emptyhight
    self.buttoncleareventreward = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , getText("Reset Completion"), self, self.cleareventreward);
    self.buttoncleareventreward.anchorTop = false
    self.buttoncleareventreward.anchorBottom = false
    self.buttoncleareventreward:initialise();
    self.buttoncleareventreward:instantiate();
    self.buttoncleareventreward.borderColor = {r=1, g=1, b=1, a=0.5};
    --self.buttoneventreward:setEnabled(false);
    self:addChild(self.buttoncleareventreward);	
end


--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--





function PZwaystone.mainpanel:prerender()

    if not self.stoneobject or not self.character then
        self:close()
    end
	if self.background then
		self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
		self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end

    local dist = PZwaystone.getposdist({self.stoneobject:getX(),self.stoneobject:getY()},{self.character:getX(),self.character:getY()})
    local stringpos = PZwaystone.getstringpos(self.stoneobject:getX(),self.stoneobject:getY(),self.stoneobject:getZ())

    
    local listselect  = self.scrolllist.selected
    

    local stringposselect

--	
	local eventx = SandboxVars.PZwaystonepanel.Xcoord
	local eventy = SandboxVars.PZwaystonepanel.Ycoord

	local x1 = eventx-3
	local y1 = eventy-3
	local x2 = eventx+3
	local y2 = eventy+3
	
	local player = getSpecificPlayer(0)

	local x = player:getX()
	local y = player:getY()
--

	local stonex = self.stoneobject:getX()
    local stoney = self.stoneobject:getY()
    local stonez = self.stoneobject:getZ()
	
	if listselect > 0  and isClient() and isAdmin() then
        local listitems = self.scrolllist.items[self.scrolllist.selected]
        if listitems then
            stringposselect = listitems.stringpos
            -- self.buttondelete:setEnabled(true)
            self.buttondelete:setVisible(true)
            -- self.scrolllist.items[listselect].tooltip = 
		else
			self.buttonnew:setVisible(true)
		end
	else
        if isClient() and isAdmin() then
			self.buttonnew:setVisible(true)
		else
			--self.buttonnew:setEnabled(false)
			self.buttonnew:setVisible(false)			
		end
		--self.buttondelete:setEnabled(false)
        self.buttondelete:setVisible(false)
    end

    if self.scrolllist.selected > 0 and  stringposselect~= stringpos then
--		if Safehouse.isSafeHouse(instance.stoneobject:IsoGridSquare.getGridSquare(stonex, stoney, stonez)) then
			-- self.buttonteleport:setEnabled(true)
			self.buttonteleport:setVisible(true)
			--self.buttonshtp:setEnabled(false)
			--self.buttonshtp:setVisible(true)
--		end
    else
        --self.buttonteleport:setEnabled(false)
		self.buttonteleport:setVisible(false)
        --if stonex = "10000" and stoney = "10000" and stonez = "0" then
			--self.buttonshtp:setVisible(true)
			--self.buttonshtp:setEnabled(true)
		--end
    end
	
    if dist > 3 then self:close() end
	
	local ModDataSD = ModData.getOrCreate("SD5_EventReward")
	-- Try to get the value, and if it's nil, set it to false
	local claimed = ModDataSD[getCurrentUserSteamID()] or false
	
	if not (x >= x1 and y >= y1 and x <= x2 and y <= y2) then
		self.buttoneventreward:setVisible(false)
		self.buttonshtp:setVisible(false)
	elseif not claimed then
		if SandboxVars.PZwaystonepanel.allowreward then
			self.buttoneventreward:setVisible(true)
		else
			self.buttoneventreward:setVisible(false)
		end
		self.buttonshtp:setVisible(false)
	elseif claimed then
		self.buttoneventreward:setVisible(false)
		if SandboxVars.PZwaystonepanel.allowshtp then
			local safehouse = SafeHouse.hasSafehouse(player)
			if safehouse then self.buttonshtp:setVisible(true) else self.buttonshtp:setVisible(false) end
		else
			self.buttonshtp:setVisible(false)
		end
	end
	
	if isAdmin() then
		self.buttoncleareventreward:setVisible(true)
	else
		self.buttoncleareventreward:setVisible(false)
	end

    if getGameTime():getModData().PZwaystone == nil then
        getGameTime():getModData().PZwaystone = {}
    end

    local l_conut = 0
    local l_items = {}



    for k,v in pairs(getGameTime():getModData().PZwaystone) do
        local i={}


        local dist = PZwaystone.getposdist(v.postion,{self.stoneobject:getX(),self.stoneobject:getY()})

        i.water = dist/55000
        i.hunger = dist/55000
        i.text=v.name .. "         "..getText("IGUI_jvli")..tostring(math.floor(dist))
        i.item=v
        i.tooltip = getText("IGUI_zuobiao")..tostring(v.postion[1])..","..tostring(v.postion[2])..","..tostring(v.postion[3]) .."\n"..getText("IGUI_xiaohaoshiwu")..math.floor(i.hunger*100).."\n" ..getText("IGUI_shuixiaohao")..math.floor(i.water*100)
        i.itemindex = l_conut+1
        l_conut = l_conut+1
        i.height = self.scrolllist.itemheight
        i.stringpos = k
        table.insert(l_items, i);
    end
    self.scrolllist.items = l_items
    
    -- print(self.scrolllist.selected)

end

function PZwaystone.mainpanel:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function PZwaystone.mainpanel:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function PZwaystone.mainpanel:onMouseDown(x, y)
    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return;
    end
    if not self:isMouseOver() then
        return -- this happens with setCapture(true)
    end
    
    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function PZwaystone.mainpanel:onMouseMoveOutside(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = false;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
    end
end

function PZwaystone.mainpanel:onMouseMove(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = true;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
        --ISMouseDrag.dragView = self;
    end
end

--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function PZwaystone.mainpanel:new (x, y, width, height,object,character)
	local o = {}
	--o.data = {}
	local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
	o.background = true;
	o.backgroundColor = {r=0, g=0, b=0, a=0.5};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
	o.height = height;
	o.anchorLeft = false;
	o.anchorRight = false;
	o.anchorTop = false;
	o.anchorBottom = false;
    o.moveWithMouse = true;
    o.stoneobject = object;
    o.character = character;
   return o
end

-- asdasd  =PZwaystone.mainpanel:new(0,0,200,200);
-- asdasd:initialise();
-- asdasd:addToUIManager() ;

--SD5 on server command functions to remove mod data


local function SD5_EventReward_onServerCommand(module, command, args)
	if module == "SD5_EventReward_ServerCommands" then
		if command == "ResetEventReward" then
			ModData.getOrCreate("SD5_EventReward")
			ModData.remove("SD5_EventReward")
		end
	end
end

Events.OnServerCommand.Add(SD5_EventReward_onServerCommand)