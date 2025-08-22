local o_update = ISMap.update
function ISMap:update()
    if not self.character:getInventory():contains(self.mapObj, true) then 
		self.editSymbolsBtn:setVisible(false)
		self.scaleBtn:setVisible(false)
		
		if not self.setMapData then
			self.setMapData = true
			self:initMapData()
			self.mapAPI:resetView()
		end
		self:updateButtons();
	else
		o_update(self)
	end
end

