local oldCanDestroy = ISDestroyCursor.canDestroy
function ISDestroyCursor:canDestroy(object)
	if not (isAdmin()) then
		local sprite = object:getSprite()
		if sprite then 
			local spriteName = sprite:getName()
			if spriteName then
				if(string.find(spriteName,PlayerShop.spritePrefix)) then 
					return false
				end
				if(string.find(spriteName,Shop.spritePrefix)) then 
					return false
				end
			end
		end
	end
	return oldCanDestroy(self,object)
end