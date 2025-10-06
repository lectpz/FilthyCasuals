--UdderlySafeLogin by UdderlyEvelyn
local safeStart = 0
local safeTime = SandboxVars.UdderlySafeLogin.SafeTime --Default 20, mind a lot of this can be eaten up trying to log in after hitting "Click To Start".
local originalX = 0
local originalY = 0
local playerMoved = false
local useInvisibility = SandboxVars.UdderlySafeLogin.UseInvisibility

local function OnInitGlobalModData(newGame)
    safeTime = SandboxVars.UdderlySafeLogin.SafeTime
	useInvisibility = SandboxVars.UdderlySafeLogin.UseInvisibility
end

Events.OnInitGlobalModData.Add(OnInitGlobalModData)

local function playerIsAdmin()
	--return false --For testing in SP uncomment this and comment the below line.
	return isAdmin() or getAccessLevel() == "admin" or getAccessLevel() == "Admin"
end

local function halo(player, msg)
	player:setHaloNote(msg, 236, 131, 190, 50)
end

function Udderly_makeSafe(player)
	if playerIsAdmin() then
		Events.OnPlayerUpdate.Remove(Udderly_makeSafe)
		return --Admins don't need safety, they log in with invis/godmode already.
	end
	originalX = player:getX()
	originalY = player:getY()
	if useInvisibility then
		player:setInvisible(true)
	else
		player:setZombiesDontAttack(true)
	end
	safeStart = getTimestamp()
	--print("[UdderlySafeLogin] Safety engaged.")
	Events.OnPlayerUpdate.Add(UdderlySafeLogin_OnPlayerUpdate)
	Events.OnPlayerUpdate.Remove(Udderly_makeSafe)
end

local function makeUnsafe(player)
	if useInvisibility then
		player:setInvisible(false)
	else
		player:setZombiesDontAttack(false)
	end
	Events.OnPlayerUpdate.Remove(UdderlySafeLogin_OnPlayerUpdate)
	halo(player, getText("IGUI_Halo_SafetyDisengaged"))
	--print("[UdderlySafeLogin] Safety disengaged.")
end

function UdderlySafeLogin_OnPlayerUpdate(player)
	if safeStart == 0 then --If we didn't set something then don't bother, means they were an admin probably.
		return
	end
	--print("safeTime Type: "..type(safeTime))
	if not playerMoved then
		if player:getX() ~= originalX or player:getY() ~= originalY then
			playerMoved = true
			safeTime = safeTime * SandboxVars.UdderlySafeLogin.MovementMultiplier --Default .5, so 10s if you move, round to keep it ints just in case it isn't.
		end
	end
	local elapsedSafeTime = getTimestamp() - safeStart
	local remainingSafeTime = safeTime - elapsedSafeTime
	if remainingSafeTime <= 0 then
		makeUnsafe(player)
	else
		halo(player, getText("IGUI_Halo_YouAreSafeFor", math.floor(remainingSafeTime)))
	end
end

--Events.OnCreatePlayer.Add(Udderly_makeSafe)
Events.OnPlayerUpdate.Add(Udderly_makeSafe)