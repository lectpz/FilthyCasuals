local function SDI_disable()
	if (SDIGetOption("SDIEnabled") == 0) then
		Events.OnPlayerUpdate.Remove(SDI.Update)
		Events.OnZombieUpdate.Remove(SDI.ZUpdate)
		print("Removed SDI Zombie Update for client")
	end
end

--Events.OnGameStart.Add(SDI_disable)