require "SDZoneCheck"

local args = {}

local function PlayerDeathSD(player)
	local zonetier, zonename, x, y = checkZone()
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	local playerModData = player:getModData()
	local playerHC = playerModData.HardcoreMode or nil
	local playerSSF = playerModData.SSFMode or nil
	local playerKillCount = player:getZombieKills()
	local playerSurvived = player:getHoursSurvived()
	
	args = {
		player_x = math.floor(x),
		player_y = math.floor(y),
		player_name = getOnlineUsername(),
		player_kc = playerKillCount,
		player_hrs = playerSurvived,
		zonename = zonename,
		zonetier = zonetier,
		z_vis = z_vis,
		z_chase = z_chase,
		z_close = z_close,
	};
	
	if SandboxVars.SDevents.enabled then
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			sendClientCommand(player, 'sdLogger', 'LogEventDeath', args);
			return
		end
	end
	
	if playerHC and playerSSF then
		sendClientCommand(player, 'sdLogger', 'LogHCSSFDeath', args);
	elseif playerHC then
		sendClientCommand(player, 'sdLogger', 'LogHCDeath', args);
	elseif playerSSF then
		sendClientCommand(player, 'sdLogger', 'LogSSFDeath', args);
	else
		sendClientCommand(player, 'sdLogger', 'LogNormalDeath', args);
	end

end
Events.OnPlayerDeath.Add(PlayerDeathSD)



local counter = 0

local function login_check()
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	counter = counter + 1
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close,
		  counter = counter*5
		}
		sendClientCommand(player, 'sdLogger', 'Login', args);
		Events.EveryOneMinute.Remove(login_check)
	end
	
	--print("counter: " .. counter)
	if counter > 6 then 
		Events.EveryOneMinute.Remove(login_check)
	end
end
Events.EveryOneMinute.Add(login_check)

local function EveryTenMinutes_check()
	local player = getSpecificPlayer(0)
	local z_vis = player:getStats():getNumVisibleZombies() or 0
	local z_chase = player:getStats():getNumChasingZombies() or 0
	local z_close = player:getStats():getNumVeryCloseZombies() or 0
	
	local zonetier, zonename, x, y = checkZone()
	
	if z_vis > 0 or z_chase > 0 or z_close > 0 then
		args = {
		  player_name = getOnlineUsername(),
		  player_x = x,
		  player_y = y,
		  zonename = zonename,
		  zonetier = zonetier,
		  z_vis = z_vis,
		  z_chase = z_chase,
		  z_close = z_close
		}
		sendClientCommand(player, 'sdLogger', 'CheckIn', args);
	end
end
--Events.EveryTenMinutes_check.Add(EveryTenMinutes_check)

local function onItemFall(item)
	local player = getSpecificPlayer(0)
	local zonetier, zonename, x, y = checkZone()
	
	local iFT = item:getFullType()
	local itemID = item:getID()
	
	args.player_name = getOnlineUsername()
	args.item = iFT
	args.itemID = itemID
	args.player_x = math.floor(x)
	args.player_y = math.floor(y)
	args.player_z = getSpecificPlayer(0):getZ()
	args.zonename = zonename
	args.zonetier = zonetier
	
	player:Say("I dropped " .. item:getName() .. "! Better pick it up later before it disappears!")
	sendClientCommand(player, 'sdLogger', 'onItemFall', args);
end

Events.onItemFall.Add(onItemFall)

require "DAMN_Armor_Shared";

DAMN = DAMN or {};
DAMN.Armor = DAMN.Armor or {};

DAMN.Armor["partUpdateInterval"] = 2000;
--[[
local maintXPswing
local isHittingZombie = true
local function OnWeaponSwing(character, handWeapon)
	if not isHittingZombie then
		if handWeapon:getType() == "BareHands" then
			maintXPswing = character:getXp():getXP(Perks.Maintenance);
			--print("maintXPswing: " .. tostring(maintXPswing))
		end
	end
end
Events.OnWeaponSwing.Add(OnWeaponSwing)

local function OnPlayerAttackFinished(character, handWeapon)
	if not isHittingZombie then
		local perk = Perks.Maintenance
	
		if handWeapon:getType() == "BareHands" then
			local maintXPnew = character:getXp():getXP(perk);
			--print("maintXPnew: " .. tostring(maintXPnew))
			local maintXPdelta = maintXPswing - maintXPnew
			--print("maintXPdelta: " .. tostring(maintXPdelta))
			
			local maintmulti = character:getXp():getPerkBoost(perk)/2; --+2 maint, this is 100% so 4x, +1maint would be 75% so 3x
			if maintmulti > 3.5 then maintmulti = 3.5 end
			local maint_var = ((3-maintmulti)*2+2)/3
			
			local maint_experience = maintXPdelta / 0.25 / (maintmulti/0.25* maint_var )
			
			if not type(maint_experience) == "number" then maint_experience = -10 end
			
			character:getXp():AddXP( perk, maint_experience );--0.25 = 4x more xp removed, 100% = 16xp removed
			--local maintXP = character:getXp():getXP(perk);
			--print("resetXP: " .. tostring(maintXP))
		end
		
		local info = character:getPerkInfo(perk);
		if info then
			local level = info:getLevel()
			if level >= 1 and level <= 10 and character:getXp():getXP(perk) < PerkFactory.getPerk(perk):getTotalXpForLevel(level) then
				character:LoseLevel(perk);
			end
		end
	end
	isHittingZombie = false
end
Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)

local function OnWeaponHitXp(player, handWeapon, character, damageSplit)
	isHittingZombie = true
end
Events.OnWeaponHitXp.Add(OnWeaponHitXp)]]