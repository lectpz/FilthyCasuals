function ISMap:update()
    --[[ISPanelJoypad.update(self);
    if not self.character:getInventory():contains(self.mapObj, true) then
		self.wrap:close()
		return
	end]]

	if not self.setMapData then
		self.setMapData = true
		self:initMapData()
		self.mapAPI:resetView()
	end
    
    if not self.character:getInventory():contains(self.mapObj, true) then 
		self.editSymbolsBtn:setVisible(false)
		self.scaleBtn:setVisible(false)
	end

    self:updateButtons();
end

