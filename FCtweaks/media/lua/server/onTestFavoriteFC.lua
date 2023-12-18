function isFavoritedItem(sourceItem, result)
	if sourceItem:isFavorite() then 
		return false 
	else
		return true
	end
end