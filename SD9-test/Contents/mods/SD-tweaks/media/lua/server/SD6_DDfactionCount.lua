local function OnReceiveGlobalModData(key, modData)
	if key == "COG" and modData and type(modData) == "table" then
		local Faction_COG = ModData.getOrCreate("Faction_COG") or {}
		local Faction_VoidWalker = ModData.getOrCreate("Faction_VoidWalker") or {}
		local Faction_Ranger = ModData.getOrCreate("Faction_Ranger") or {}
		
		for username, exists in pairs(modData) do
			if exists then 
				Faction_COG[username] = true 
				Faction_VoidWalker[username] = nil 
				Faction_Ranger[username] = nil 
			end
		end
		
		local members = 0
		for k,v in pairs(Faction_COG) do
		  members = members + 1
		end
		local COG = ModData.getOrCreate("COG_members") or {}
		COG["total"] = members
		
	elseif key == "VoidWalker" and modData and type(modData) == "table" then
		local Faction_COG = ModData.getOrCreate("Faction_COG") or {}
		local Faction_VoidWalker = ModData.getOrCreate("Faction_VoidWalker") or {}
		local Faction_Ranger = ModData.getOrCreate("Faction_Ranger") or {}
		
		for username, exists in pairs(modData) do
			if exists then 
				Faction_COG[username] = nil 
				Faction_VoidWalker[username] = true 
				Faction_Ranger[username] = nil 
			end
		end
		
		local members = 0
		for k,v in pairs(Faction_VoidWalker) do
		  members = members + 1
		end
		local VW = ModData.getOrCreate("VW_members") or {}
		VW["total"] = members
		
	elseif key == "Ranger" and modData and type(modData) == "table" then
		local Faction_COG = ModData.getOrCreate("Faction_COG") or {}
		local Faction_VoidWalker = ModData.getOrCreate("Faction_VoidWalker") or {}
		local Faction_Ranger = ModData.getOrCreate("Faction_Ranger") or {}
		
		for username, exists in pairs(modData) do
			if exists then 
				Faction_COG[username] = nil 
				Faction_VoidWalker[username] = nil 
				Faction_Ranger[username] = true 
			end
		end
		
		local members = 0
		for k,v in pairs(Faction_Ranger) do
		  members = members + 1
		end
		local Ranger = ModData.getOrCreate("Ranger_members") or {}
		Ranger["total"] = members
		
	end
	
end
Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData)