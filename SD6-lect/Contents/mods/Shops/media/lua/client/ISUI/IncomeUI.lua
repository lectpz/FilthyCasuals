IncomeUI = ISCollapsableWindow:derive("IncomeUI");
IncomeUI.instance = nil;
IncomeUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
IncomeUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
IncomeUI.removeButtonX = 300
IncomeUI.transferInProgress = false
IncomeUI.ticketsCache = {}

local width = 280
local height = 400
local total = 0
local totalSpecial = 0

function IncomeUI:show(player,shop)
    if IncomeUI.instance==nil then
        IncomeUI.instance = IncomeUI:new (0, 0, width, height, player);
        IncomeUI.instance.shop = shop
        IncomeUI.instance:initialise();
        IncomeUI.instance:instantiate();
    end
    IncomeUI.instance.pinButton:setVisible(false)
    IncomeUI.instance.collapseButton:setVisible(false)
    IncomeUI.instance:addToUIManager();
    IncomeUI.instance:setVisible(true);
    return IncomeUI.instance;
end

function IncomeUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    self.tickets.items = self.ticketsCache 
    filterText = string.lower(filterText)
    local tickets = self.tickets.items
    self.tickets:clear()
    for k,v in ipairs(tickets) do
        if string.contains(string.lower(v.item.buyer), filterText) then
            self.tickets:addItem(v.item.buyer,v.item);
        end
    end
end

function IncomeUI:onFilterChange()
    IncomeUI.instance:filter()
end

function IncomeUI:doDrawItem(y, item, alt)
    local baseItemDY = 0
    if item.item.b then
        baseItemDY = self.SMALL_FONT_HGT
        item.height = self.itemheight + baseItemDY
    end

    if y + self:getYScroll() >= self.height then return y + item.height end
    if y + item.height + self:getYScroll() <= 0 then return y + item.height end

    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), item.height - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15);
    end

    self:drawText(item.item.b, 10, y + 12, 1, 1, 1, a, UIFont.Small);

    local coinImg = Currency.CoinsTexture.Coin
    if item.item.t.tl then
        local fixedY = 4
        if not Currency.UseSpecialCoin then fixedY = 12 end
        self:drawTextureScaledAspect(coinImg.texture, 120, y + fixedY, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
        local totalFormatted = Currency.format(item.item.t.tl)
        self:drawText(""..totalFormatted, 140, y + fixedY-2, 1, 1, 1, a, UIFont.Small);
    end

    if Currency.UseSpecialCoin then
        coinImg = Currency.CoinsTexture.SpecialCoin
        if item.item.t.tls then
            local totalSpecialFormatted = Currency.format(item.item.t.tls)
            self:drawTextureScaledAspect(coinImg.texture, 120, y + 22, coinImg.scale, coinImg.scale, 1, 1, 1, 1)
            self:drawText(""..totalSpecialFormatted, 140, y + 20, 1, 1, 1, a, UIFont.Small);
        end
    end

    return y + item.height;
end

function IncomeUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 40
    local y = 45

    self.filterLabel = ISLabel:new(x, y+3, 1,UIText.Search,1,1,1,1,UIFont.Small, true);
    self:addChild(self.filterLabel);

    self.filterEntry = ISTextEntryBox:new("", x+40, y-8, 150, 1);
    self.filterEntry.font = UIFont.Medium
    self.filterEntry:initialise();
    self.filterEntry:instantiate();
    self.filterEntry:setText("");
    self.filterEntry:setClearButton(true);
    self.filterEntry.onTextChange = IncomeUI.onFilterChange
    self:addChild(self.filterEntry);
    self.lastText = self.filterEntry:getInternalText();

    self.tickets = ISScrollingListBox:new(x, y+30, 200, 180);
    self.tickets:initialise();
    self.tickets:instantiate();
    self.tickets:setAnchorRight(false)
    self.tickets:setAnchorBottom(true)
    self.tickets.font = UIFont.NewSmall;
    self.tickets.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.tickets.selected = 1;
    self.tickets.joypadParent = self;
    self.tickets.drawBorder = false;
    self.tickets.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.tickets.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self.tickets.doDrawItem = IncomeUI.doDrawItem;
    self:addChild(self.tickets);

    total = 0
    totalSpecial = 0
    local income = IncomeUI.instance.shop:getModData().income
    for k,v in pairs(income) do
        self.tickets:addItem(v.buyer,v)
        total = total + v.t.tl
        totalSpecial = totalSpecial + v.t.tls
    end
    self.ticketsCache = self.tickets.items

    self.getButton = ISButton:new(x+70, 350, 60,25,UIText.Get,self, IncomeUI.getBtn);
    self.getButton:initialise()
    self.getButton.enable = false    
    self:addChild(self.getButton);

    if total > 0 or totalSpecial > 0 then
        self.getButton.enable = true  
    end

    self.totalLabel = ISLabel:new(x, 280, ShopUI.SMALL_FONT_HGT, UIText.Total, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalLabel);

    local coinImg = Currency.CoinsTexture.Coin
    self.totalCoinTex = ISImage:new(x+60, 280, 0, 0, coinImg.texture);
    self.totalCoinTex.scaledWidth = coinImg.scale+5
    self.totalCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.totalCoinTex);

    self.totalCoinLabel = ISLabel:new(x+85, 280, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalCoinLabel);

    coinImg = Currency.CoinsTexture.SpecialCoin
    self.totalSpecialCoinTex = ISImage:new(x+60, 305, 0, 0, coinImg.texture);
    self.totalSpecialCoinTex.scaledWidth = coinImg.scale+5
    self.totalSpecialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.totalSpecialCoinTex);

    self.totalSpecialCoinLabel = ISLabel:new(x+85, 305, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.totalSpecialCoinLabel);

    local totalFormatted = Currency.format(total)
    self.totalCoinLabel:setName(""..totalFormatted)
    local totalSpecialFormatted = Currency.format(totalSpecial)
    self.totalSpecialCoinLabel:setName(""..totalSpecialFormatted)

    if not Currency.UseSpecialCoin then
        self.totalSpecialCoinTex:setVisible(false)
        self.totalSpecialCoinLabel:setVisible(false)
    end
end

function IncomeUI:getBtn()
    local account =  Balance.getUserAccount(self.character:getUsername())
    if account then
        sendClientCommand("BS", "Deposit", {total,totalSpecial})
        IncomeUI.instance.shop:getModData().income = {}
        IncomeUI.instance.shop:transmitModData()
        self.character:playSound("CashRegister")
    else
        self.character:setHaloNote(UIText.AccountNeeded, 255,255,255,400);
    end
    self:close()
end

function IncomeUI:close()
	ISCollapsableWindow.close(self);
    IncomeUI.instance:removeFromUIManager()
    IncomeUI.instance = nil
    self:removeFromUIManager()
end

function IncomeUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.character = getPlayer(player)
    o.title = UIText.Income;
    o.player = player
    o.recipient = nil
    o.resizable = false;
    return o
end