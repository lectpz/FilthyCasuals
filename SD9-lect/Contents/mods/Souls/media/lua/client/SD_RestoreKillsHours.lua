function SD_Ticket_RestoreKills(player, old_kills, add_kills)
	player:setZombieKills(old_kills + add_kills)
end

function SD_Ticket_RestoreHours(player, old_hours, add_hours)
	player:setHoursSurvived(old_hours + add_hours)
end

function RestoreKills_One(items, result, player)
	local CurrentKills = player:getZombieKills()
	SD_Ticket_RestoreKills(player, CurrentKills, 1)
end

function RestoreKills_Ten(items, result, player)
	local CurrentKills = player:getZombieKills()
	SD_Ticket_RestoreKills(player, CurrentKills, 10)
end

function RestoreKills_OneHundred(items, result, player)
	local CurrentKills = player:getZombieKills()
	SD_Ticket_RestoreKills(player, CurrentKills, 100)
end

function RestoreKills_OneThousand(items, result, player)
	local CurrentKills = player:getZombieKills()
	SD_Ticket_RestoreKills(player, CurrentKills, 1000)
end

function RestoreHours_One(items, result, player)
	local CurrentHours = player:getHoursSurvived()
	SD_Ticket_RestoreHours(player, CurrentHours, 1)
end

function RestoreHours_Ten(items, result, player)
	local CurrentHours = player:getHoursSurvived()
	SD_Ticket_RestoreHours(player, CurrentHours, 10)
end

function RestoreHours_OneHundred(items, result, player)
	local CurrentHours = player:getHoursSurvived()
	SD_Ticket_RestoreHours(player, CurrentHours, 100)
end

function RestoreHours_OneThousand(items, result, player)
	local CurrentHours = player:getHoursSurvived()
	SD_Ticket_RestoreHours(player, CurrentHours, 1000)
end