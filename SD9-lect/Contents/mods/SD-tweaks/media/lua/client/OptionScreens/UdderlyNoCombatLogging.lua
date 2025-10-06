--UdderlyNoCombatLogging by UdderlyEvelyn
--This does overwrite the original MainScreen:onConfirmQuitToDesktop without calling it, should be extremely rare that this is used by anything else though.
local quitStart = 0
local quitDelay = SandboxVars.UdderlyNoCombatLogging.QuitDelay --Default 5.
local onMenuItemMouseDownMainMenu_original = MainScreen.onMenuItemMouseDownMainMenu
local toDesktop = false

local function playerIsAdmin()
	return isAdmin() or getAccessLevel() == "admin" or getAccessLevel() == "Admin"
end

local function halo(player, msg)
	player:setHaloNote(msg, 236, 131, 190, 50)
end

local function quitNow() --Same code that game normally runs for this, chopped up and modified for our purposes.
	sendClientCommand("UdderlyNoCombatLogging", "LogDelayedLogout", {})
	setGameSpeed(1)
	pauseSoundAndMusic()
	setShowPausedMessage(true)
	if toDesktop then
		getCore():quitToDesktop()
	else
		getCore():quit()
	end
end

function startQuit(player)
	if playerIsAdmin() or isInCC or isInSafeHouse then
		quitNow()
		return --Admins don't need delay, they are admins.
	end
	quitStart = getTimestamp()
	print("[UdderlyNoCombatLogging] Begun quitting.")
	Events.OnPlayerUpdate.Add(UdderlyNoCombatLogging_OnPlayerUpdate)        
	ToggleEscapeMenu(getCore():getKey("Main Menu")) --This is what the RETURN option does.
end

local function afterDelay(player)
	Events.OnPlayerUpdate.Remove(UdderlyNoCombatLogging_OnPlayerUpdate)
	print("[UdderlyNoCombatLogging] Actually quitting.")
	quitNow()
end

function UdderlyNoCombatLogging_OnPlayerUpdate(player)
	if quitStart == 0 then --If we didn't set something then don't bother, this should not ever happen.
		print("[UdderlyNoCombatLogging] Hit OnPlayerUpdate with no quitStart, this should not happen!")
		return
	end
	local elapsedQuitDelay = getTimestamp() - quitStart
	local remainingQuitDelay = quitDelay - elapsedQuitDelay
	if remainingQuitDelay <= 0 then
		afterDelay(player)
	else
		halo(player, getText("IGUI_Halo_GameWillQuitIn", math.floor(remainingQuitDelay)))
	end
end

MainScreen.onMenuItemMouseDownMainMenu = function(item, x, y)
	if item.internal == "EXIT" then
		toDesktop = false --Just in case we did desktop then swapped.
		startQuit()
	else
		onMenuItemMouseDownMainMenu_original(item, x, y)
	end
end

MainScreen.onConfirmQuitToDesktop = function(self, button)
	if button.internal == "YES" then
		toDesktop = true
		startQuit()
	else
		MainScreen.instance.bottomPanel:setVisible(true)
		self.quitToDesktopDialog = nil
	end
end