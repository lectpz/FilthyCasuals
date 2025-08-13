TransferUI = ISCollapsableWindow:derive("TransferUI");
TransferUI.instance = nil;
TransferUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
TransferUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
TransferUI.removeButtonX = 300
TransferUI.transferInProgress = false
TransferUI.accountsCache = {}

local width = 280
local height = 300

function TransferUI:show(player)
    if TransferUI.instance==nil then
        TransferUI.instance = TransferUI:new (0, 0, width, height, player);
        TransferUI.instance:initialise();
        TransferUI.instance:instantiate();
    end
    TransferUI.instance.pinButton:setVisible(false)
    TransferUI.instance.collapseButton:setVisible(false)
    TransferUI.instance:addToUIManager();
    TransferUI.instance:setVisible(true);
    return TransferUI.instance;
end

function TransferUI:update()
    local username = self.player:getUsername()    
    local coin,specialCoin = Balance.getUserBalance(username)
    local coinFormatted = Currency.format(coin)
    self.balanceCoinLabel:setName(""..coinFormatted)
    local specialCoinFormatted = Currency.format(specialCoin)
    self.balanceSpecialCoinLabel:setName(""..specialCoinFormatted)

    if self.transferInProgress then return end
    local transferCoin = tonumber(self.transferCoin:getInternalText())
    if transferCoin == nil then transferCoin = 0 end
    local transferSpecialCoin = tonumber(self.transferSpecialCoin:getInternalText())
    if transferSpecialCoin == nil then transferSpecialCoin = 0 end
    if (transferCoin <= 0 and transferSpecialCoin <=0)
     or not self.recipient 
     or (transferCoin > coin or transferSpecialCoin > specialCoin) 
    then
        self.sendButton.enable = false
        self.sendButton:setVisible(true)
        self.cancelButton.enable = false
        self.cancelButton:setVisible(false)
        return 
    end
    if coin >= transferCoin and specialCoin >= transferSpecialCoin and self.recipient then
        self.sendButton.enable = true
        self.sendButton:setVisible(true)
        self.cancelButton.enable = false
        self.cancelButton:setVisible(false)
    end
end

function TransferUI:onMouseDownAccountItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
    if not self.selected then return end
    local selectedRow = self.items[self.selected]
	if selectedRow then
        local accountName = selectedRow.text
        TransferUI.recipient = accountName
        TransferUI.instance.toLabel:setName(UIText.TransferTo..": "..accountName)
    end
end

function TransferUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    self.accountItems.items = self.accountsCache 
    filterText = string.lower(filterText)
    local accountItems = self.accountItems.items
    self.accountItems:clear()
    for k,v in ipairs(accountItems) do
        if string.contains(string.lower(v.text), filterText) then
            self.accountItems:addItem(v.text);
        end
    end
end

function TransferUI:onFilterChange()
    TransferUI.instance:filter()
end

local function twoDecimal(self)
    local quantity = self:getInternalText()
    local isNumber = tonumber(quantity)
	if not isNumber then return end
    local curPos = self:getCursorPos()
    if string.find(quantity,"%.") then
        self:setText(string.format('%.02f', quantity))
        self:setCursorPos(curPos)
    end
end

function TransferUI:onCoinChange()
    twoDecimal(self)
end

function TransferUI:onSpecialCoinChange()
    twoDecimal(self)
end

function TransferUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 40
    local y = 85
    
    self.balanceLabel = ISLabel:new(x, 20, ShopUI.SMALL_FONT_HGT, UIText.Balance, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceLabel);

    local coinImg = Currency.CoinsTexture.Coin
    self.balanceCoinTex = ISImage:new(x+60, 20, 0, 0, coinImg.texture);
    self.balanceCoinTex.scaledWidth = coinImg.scale+5
    self.balanceCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceCoinTex);

    self.balanceCoinLabel = ISLabel:new(x+85, 20, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceCoinLabel);

    self.transferCoinTex = ISImage:new(x, 240, 0, 0, coinImg.texture);
    self.transferCoinTex.scaledWidth = coinImg.scale+5
    self.transferCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.transferCoinTex);

    self.transferCoin = ISTextEntryBox:new("0", x+30, 238, 100, 20);
    self.transferCoin.font = UIFont.Medium
	self.transferCoin:initialise();
	self.transferCoin:instantiate();
	self.transferCoin:setOnlyNumbers(true);
    self.transferCoin.onTextChange = TransferUI.onCoinChange
	self:addChild(self.transferCoin);

    coinImg = Currency.CoinsTexture.SpecialCoin
    self.balanceSpecialCoinTex = ISImage:new(x+60, 45, 0, 0, coinImg.texture);
    self.balanceSpecialCoinTex.scaledWidth = coinImg.scale+5
    self.balanceSpecialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.balanceSpecialCoinTex);

    self.balanceSpecialCoinLabel = ISLabel:new(x+85, 45, ShopUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceSpecialCoinLabel);

    self.transferSpecialCoinTex = ISImage:new(x, 270, 0, 0, coinImg.texture);
    self.transferSpecialCoinTex.scaledWidth = coinImg.scale+5
    self.transferSpecialCoinTex.scaledHeight = coinImg.scale+5
    self:addChild(self.transferSpecialCoinTex);
    
    self.transferSpecialCoin = ISTextEntryBox:new("0", x+30, 268, 100, 20);
    self.transferSpecialCoin.font = UIFont.Medium
	self.transferSpecialCoin:initialise();
	self.transferSpecialCoin:instantiate();
    self.transferSpecialCoin.onTextChange = TransferUI.onSpecialCoinChange
	self.transferSpecialCoin:setOnlyNumbers(true);
	self:addChild(self.transferSpecialCoin);

    self.filterLabel = ISLabel:new(x, y+3, 1,UIText.Search,1,1,1,1,UIFont.Small, true);
    self:addChild(self.filterLabel);

    self.filterEntry = ISTextEntryBox:new("", x+40, y-8, 150, 1);
    self.filterEntry.font = UIFont.Medium
    self.filterEntry:initialise();
    self.filterEntry:instantiate();
    self.filterEntry:setText("");
    self.filterEntry:setClearButton(true);
    self.filterEntry.onTextChange = TransferUI.onFilterChange
    self:addChild(self.filterEntry);
    self.lastText = self.filterEntry:getInternalText();

    self.accountItems = ISScrollingListBox:new(x, y+20, 200, 100);
    self.accountItems:initialise();
    self.accountItems:instantiate();
    self.accountItems:setAnchorRight(false)
    self.accountItems:setAnchorBottom(true)
    self.accountItems.font = UIFont.NewSmall;
    self.accountItems.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.accountItems.selected = 1;
    self.accountItems.joypadParent = self;
    self.accountItems.drawBorder = false;
    self.accountItems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.accountItems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self.accountItems.onMouseDown = TransferUI.onMouseDownAccountItem;
    self:addChild(self.accountItems);

    local accounts = Balance.getAccountsList()
    local username = self.player:getUsername()
    for k,v in pairs(accounts) do
        if not (username == v) then
            self.accountItems:addItem(v)
        end
    end
    self.accountsCache = self.accountItems.items

    self.toLabel = ISLabel:new(x, 215, ShopUI.SMALL_FONT_HGT, UIText.TransferTo, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.toLabel);

    self.sendButton = ISButton:new(x+150, 253, 60,25,UIText.Send,self, TransferUI.sendBtn);
    self.sendButton:initialise()
    self.sendButton.enable = false
    self:addChild(self.sendButton);

    self.cancelButton = ISButton:new(x+150, 253, 60,25,UIText.Cancel,self, TransferUI.cancelBtn);
    self.cancelButton:initialise()
    self.cancelButton.enable = false
    self.cancelButton:setVisible(false)
    self:addChild(self.cancelButton);

    if not Currency.UseSpecialCoin then
        self.balanceSpecialCoinTex:setVisible(false)
        self.balanceSpecialCoinLabel:setVisible(false)
        self.transferSpecialCoin:setVisible(false)
        self.transferSpecialCoinTex:setVisible(false)
    end
end

function TransferUI:clearAfterTransfer()
    TransferUI.recipient = nil
    self.toLabel:setName(UIText.TransferTo)
    self.transferCoin:setText("0");
    self.transferSpecialCoin:setText("0");
end

function TransferUI:cancelBtn()
    self.sendButton.enable = true
    self.sendButton:setVisible(true)
    self.cancelButton.enable = false
    self.cancelButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "SendTransferAction") then return end
    currentAction.action:forceStop()
end

function TransferUI:sendBtn()
    self.transferInProgress = true
    local transfer = {}
    transfer.coin = tonumber(self.transferCoin:getInternalText())
    if transfer.coin == nil then transfer.coin = 0 end
    transfer.specialCoin = tonumber(self.transferSpecialCoin:getInternalText())
    if transfer.specialCoin == nil then transfer.specialCoin = 0 end
    transfer.recipient = self.recipient
    transfer.coin = math.abs(transfer.coin)
    transfer.specialCoin = math.abs(transfer.specialCoin)
    self.sendButton.enable = false
    self.sendButton:setVisible(false)
    self.cancelButton.enable = true
    self.cancelButton:setVisible(true)
    local action = SendTransferAction:new(self.player,self,transfer);
    ISTimedActionQueue.add(action);
end

function TransferUI:render()
    ISCollapsableWindow.render(self);
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then self.transferInProgress = false return end
    if not (currentAction.Type == "SendTransferAction") then self.transferInProgress = false return end
    self:drawProgressBar(185, 240, 70, 10, currentAction.action:getJobDelta(), self.fgBar)
end

function TransferUI:close()
	ISCollapsableWindow.close(self);
    TransferUI.recipient = nil
    TransferUI.instance:removeFromUIManager()
    TransferUI.instance = nil
    self:removeFromUIManager()
end

function TransferUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.title = UIText.TransferUITitle;
    o.player = player
    o.recipient = nil
    o.resizable = false;
    return o
end