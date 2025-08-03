ShopSpriteCursor = ISBuildingObject:derive("ShopSpriteCursor")
ShopSpriteCursor.instance = nil
ShopSpriteCursor.spriteIndex = 1

local function isFreezer(sprite)
	for k,v in pairs(PlayerShop.sprites.Freezer) do
		if v == sprite then return true end
	end
	return false
end

function ShopSpriteCursor:create(x, y, z, north, sprite)
	local cell = getWorld():getCell()
	local square = cell:getGridSquare(x, y, z)
	local shop = IsoThumpable.new(cell, self.square, sprite, north, self)
	local isPlayerShop = string.find(sprite,PlayerShop.spritePrefix)
	local itemTag = "PlayerShop"
	if isPlayerShop then
		shop:setIsContainer(true);
		shop:setCanBeLockByPadlock(true)
		if isFreezer(sprite) then
			shop:getContainer():setType("freezer");
			itemTag = "PlayerShopFreezer"
		end
	end
	shop:setSprite(sprite)
	shop:setIsThumpable(false);
	square:AddSpecialObject(shop)
	shop:transmitCompleteItemToServer()
	if isPlayerShop then
		shop:getModData().owner = self.character:getUsername()
		shop:getModData().income = {}
		shop:transmitModData()
	end
	getWorld():getCell():setDrag(nil, 0);
	local playerShop = self.character:getInventory():getFirstTag(itemTag)
	self.character:getInventory():Remove(playerShop)
end

function ShopSpriteCursor:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)
end

function ShopSpriteCursor:isValid(square)
	return true
end

ShopSpriteCursor.toggleSprites = function (key)
	if ShopSpriteCursor.instance == nil then return end
	if not(key == getCore():getKey("Rotate building")) then return end
	local spriteIndex = ShopSpriteCursor.instance.spriteIndex
	if spriteIndex == 2 then
		spriteIndex = 1 
	else
		spriteIndex = 2
	end
	local nextSprite = ShopSpriteCursor.instance.sprites[spriteIndex]
	ShopSpriteCursor.instance.spriteIndex = spriteIndex
	ShopSpriteCursor.instance:setSprite(nextSprite)
	ShopSpriteCursor.instance:setNorthSprite(nextSprite)
end

function ShopSpriteCursor:new(character,sprites)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o.sprites = sprites
	o:setSprite(sprites[1])
	o:setNorthSprite(sprites[1])
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	ShopSpriteCursor.instance = o
	return o
end

Events.OnKeyPressed.Add(ShopSpriteCursor.toggleSprites)