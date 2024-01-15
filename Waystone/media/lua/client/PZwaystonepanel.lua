require "PZwaystoneclientcore"

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

	
	local pzplayer = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(pzplayer)
	if safehouse	
	then

		local x = pzplayer:getX()
		local y = pzplayer:getY()

		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then

			local playerObj = self.character
			local selectd = self.scrolllist.items[self.scrolllist.selected]
			local postion = selectd.item.postion

			--SendCommandToServer("/teleportto " .. postion[1] .. "," .. postion[2] .. "," .. postion[3]);
			playerObj:setX(postion[1])
			playerObj:setY(postion[2])
			playerObj:setZ(postion[3])
			playerObj:setLx(postion[1])
			playerObj:setLy(postion[2])
			playerObj:setLz(postion[3])

			playerObj:getStats():setHunger(playerObj:getStats():getHunger()+selectd.hunger)
			playerObj:getStats():setThirst(playerObj:getStats():getThirst()+selectd.water)			
		else
			pzplayer:Say("I need to be in my SafeHouse.")			
			self:close()
		end
	end

end

function PZwaystone.mainpanel:shtp()

	local pzplayer = getPlayer()

	local x = pzplayer:getX()
	local y = pzplayer:getY()

	local x1cc = SandboxVars.PZwaystonepanel.X1coord
	local y1cc = SandboxVars.PZwaystonepanel.Y1coord
	
	local x1 = x1cc-3
	local y1 = y1cc-3
	local x2 = x1cc+3
	local y2 = y1cc+3

	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then--checks if the waystone is at the community center
		local pzplayer = getPlayer()
		local safehouse = SafeHouse.hasSafehouse(pzplayer)
		--define safehouse bounds to check for moddata sh coordinates
		local xx1 = safehouse:getX()
		local yy1 = safehouse:getY()
		local xx2 = safehouse:getW() + xx1
		local yy2 = safehouse:getH() + yy1
		
		if safehouse then
		
			local sh_x = pzplayer:getModData().SafeHouseX
			local sh_y = pzplayer:getModData().SafeHouseY
			
			if sh_x ~= nil and sh_y ~= nil then--check moddata if not nil
			
				if sh_x >= xx1 and sh_y >= yy1 and sh_x <= xx2 and sh_y <= yy2 then--check if moddata is within actual sh bounds
					--SendCommandToServer("/teleportto " .. sh_x .. "," .. sh_y .. ",0");
					self.character:setX(sh_x) -- teleport to pre-defined safehouse moddata coordinates
					self.character:setY(sh_y)
					self.character:setLx(sh_x)
					self.character:setLy(sh_yY)
				else
					--SendCommandToServer("/teleportto " .. xx1 .. "," .. yy1 .. ",0");
					self.character:setX(safehouse:getX())
					self.character:setY(safehouse:getY())
					self.character:setLx(safehouse:getX())
					self.character:setLy(safehouse:getY())
				end
			else
				--SendCommandToServer("/teleportto " .. xx1 .. "," .. yy1 .. ",0");
				self.character:setX(safehouse:getX())
				self.character:setY(safehouse:getY())
				self.character:setLx(safehouse:getX())
				self.character:setLy(safehouse:getY())
			end
		else
			pzplayer:Say("I'm homeless. If only I had a SafeHouse to teleport to...")
			self.close()
		end			
	else
		pzplayer:Say("Looks like I can only do this from the Community Center.")
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

	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
	
		local pzplayer = getPlayer()
		
		local x1cc = SandboxVars.PZwaystonepanel.X1coord
		local y1cc = SandboxVars.PZwaystonepanel.Y1coord
		local z1cc = SandboxVars.PZwaystonepanel.Z1coord
		
		--SendCommandToServer("/teleportto " .. x1cc .. "," .. y1cc .. "," .. z1cc);
		self.character:setX(x1cc)
		self.character:setY(y1cc)
		self.character:setZ(z1cc)
		self.character:setLx(x1cc)
		self.character:setLy(y1cc)
		self.character:setLz(z1cc)
		
		pzplayer:getInventory():AddItem(SandboxVars.PZwaystonepanel.eventreward1);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward2, ZombRand(SandboxVars.PZwaystonepanel.eventreward2chance1)+SandboxVars.PZwaystonepanel.eventreward2chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward3, ZombRand(SandboxVars.PZwaystonepanel.eventreward3chance1)+SandboxVars.PZwaystonepanel.eventreward3chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward4, ZombRand(SandboxVars.PZwaystonepanel.eventreward4chance1)+SandboxVars.PZwaystonepanel.eventreward4chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward5, ZombRand(SandboxVars.PZwaystonepanel.eventreward5chance1)+SandboxVars.PZwaystonepanel.eventreward5chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward6, ZombRand(SandboxVars.PZwaystonepanel.eventreward6chance1)+SandboxVars.PZwaystonepanel.eventreward6chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward7, ZombRand(SandboxVars.PZwaystonepanel.eventreward7chance1)+SandboxVars.PZwaystonepanel.eventreward7chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward8, ZombRand(SandboxVars.PZwaystonepanel.eventreward8chance1)+SandboxVars.PZwaystonepanel.eventreward8chance2);
		pzplayer:getInventory():AddItems(SandboxVars.PZwaystonepanel.eventreward9, ZombRand(SandboxVars.PZwaystonepanel.eventreward9chance1)+SandboxVars.PZwaystonepanel.eventreward9chance2);

	else
		pzplayer:Say("This option is not available.")
		self:close()
		--playerObj:Say("This option is not available.")
		
	end
	
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
	
	local player = getPlayer()

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
	
	if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
	
		self.buttoneventreward:setVisible(true)
		
	else

		self.buttoneventreward:setVisible(false)
		
	end
	
	local safehouse = SafeHouse.hasSafehouse(player)
	if safehouse then
		self.buttonshtp:setVisible(true)
	else
		self.buttonshtp:setVisible(false)
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
