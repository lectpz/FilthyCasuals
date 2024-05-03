----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

-- function to scale crit and min/max dmg based on zone
function SDOnWeaponSwing(character, handWeapon)
	
	if character ~= nil and not handWeapon:isRanged() and character:getPrimaryHandItem() ~= nil then
		-- set tierzone 
		local tierzone = checkZone()
		-- if it's tier 1, just don't do anything
		if tierzone then
			-- save original crit rate, min dmg, and max dmg
			local playerItem = handWeapon
			local modData = playerItem:getModData()
			
			-- check weapon for moddata, if no moddata then establish moddata
			if	modData.CriticalChance		== nil and
				modData.CritDmgMultiplier	== nil and
				modData.MinDamage		== nil and
				modData.MaxDamage		== nil and
				modData.Name			== nil then
				
				-- if there are no moddata stats attached to the weapon then set moddata to weapon
				local o_critrate 	=	playerItem:getCriticalChance()
				local o_critmulti	=	playerItem:getCritDmgMultiplier()
				local o_mindmg		=	playerItem:getMinDamage()
				local o_maxdmg		=	playerItem:getMaxDamage()
				local o_name		=	character:getPrimaryHandItem():getName()
				--if character:getPrimaryHandItem() == playerItem then local o_name = character:getPrimaryHandItem():getName() end
				--local o_name		=	playerItem--:getName()
				--print(o_name " base name")
				-- set moddata in key, value pairs
				
				modData.CriticalChance		= o_critrate
				modData.CritDmgMultiplier	= o_critmulti
				modData.MinDamage		= o_mindmg
				modData.MaxDamage		= o_maxdmg
				modData.Name			= o_name
				--print:Say("mod data stored")
			else
				--print("mod data already exists, nothing needs to be done")
			end
			
			local basecritrate 	= modData.CriticalChance
			local basecritmulti	= modData.CritDmgMultiplier
			local basemindmg 	= modData.MinDamage
			local basemaxdmg 	= modData.MaxDamage
			local basename		= modData.Name
			
--			local basecritrate = playerItem:getCriticalChance()
--			local basecritmulti = playerItem:getCritDmgMultiplier()
--			local basemindmg = playerItem:getMinDamage()
--			local basemaxdmg = playerItem:getMaxDamage()
			-- debug display to make my life easier
--			character:Say("OrigCrit=" .. tostring(basecritrate) .. " OrigMinDmg=" .. tostring(basemindmg) .. " OrigMaxDmg=" .. tostring(basemaxdmg))
--			character:Say("OrigMinDmg=" .. tostring(basemindmg) .. " OrigMaxDmg=" .. tostring(basemaxdmg))-- .. "OrigCrit=" .. tostring(basecritrate) .. " OrigCritMulti=" .. tostring(basecritmulti))

			-- define local crit and dmg multipliers
			local localcrit		= 1.0
			local localdmgmulti	= 1.0

			-- define crit and dmg modifiers based on zone
			local tiercritratemod	= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier2critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier3critrate), tonumber(SandboxVars.SDOnWeaponSwing.Tier4critrate)}
			local tiercritmultimod	= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier2critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier3critmulti), tonumber(SandboxVars.SDOnWeaponSwing.Tier4critmulti)}
			local tierdmgmod	= {tonumber(SandboxVars.SDOnWeaponSwing.Tier1dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier2dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier3dmg), tonumber(SandboxVars.SDOnWeaponSwing.Tier4dmg)}

			local localdmgmulti	= tierdmgmod[tierzone]
			local localcritrate	= tiercritratemod[tierzone]
			local localcritmulti	= tiercritmultimod[tierzone]
            
			-- set weapon stats
			--print(FilthyCasual)
			playerItem:setCriticalChance(basecritrate * localcritrate)-- + (FilthyCasual * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus critrate is 0. T2=1. T3=2. T4=3. If FC=false, then FC=0 and nothing applies
			playerItem:setCritDmgMultiplier(basecritmulti * localcritmulti)-- + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus critmulti is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			playerItem:setMinDamage(basemindmg * localdmgmulti)-- + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus mindmg is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			playerItem:setMaxDamage(basemaxdmg * localdmgmulti)-- + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus maxdmg is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			--if tierzone ~= 1 then playerItem:setName(basename .. " [T" .. tostring(tierzone) .. "]") else playerItem:setName(basename) end
			playerItem:setName(basename .. " [T" .. tostring(tierzone) .. "]")
			-- debug display to make my life easier
--			character:Say("ModCrit=" .. tostring(basecritrate * localcrit) .. " ModMinDmg=" .. tostring(basemindmg * localdmgmulti) .. " ModMaxDmg=" .. tostring(basemaxdmg * localdmgmulti))
--			character:Say("ModMinDmg=" .. tostring(basemindmg * localdmgmulti) .. " ModMaxDmg=" .. tostring(basemaxdmg * localdmgmulti) .. "ModCrit=" .. tostring(basecritrate * localcritrate) .. " ModCritMulti=" .. tostring(basecritmulti * localcritmulti))

		end
	end
end

Events.OnWeaponSwing.Add(SDOnWeaponSwing)

local function KillCountSD(player)
	return player:getZombieKills()
end

function SDWeaponCheck(character, inventoryItem)
	--character:Say("SDWeaponCheck")

	if inventoryItem == nil then
		--character:Say("Inventory Item is Nil")
		--return
	elseif inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		
		local modData = inventoryItem:getModData()
	
		if	modData.CriticalChance	== nil and
			modData.CritDmgMultiplier	== nil and
			modData.MinDamage		== nil and
			modData.MaxDamage		== nil and
			modData.Name			== nil then
			
			local o_critrate 	=	inventoryItem:getCriticalChance()
			local o_critmulti	=	inventoryItem:getCritDmgMultiplier()
			local o_mindmg		=	inventoryItem:getMinDamage()
			local o_maxdmg		=	inventoryItem:getMaxDamage()
			local o_name		=	character:getPrimaryHandItem():getName()
			--print(o_name .. " base name")

			modData.CriticalChance	= o_critrate
			modData.CritDmgMultiplier	= o_critmulti
			modData.MinDamage		= o_mindmg
			modData.MaxDamage		= o_maxdmg
			modData.Name			= o_name
			--character:Say("mod data stored")
		else
			--character:Say("mod data already exists, nothing needs to be done")
		end
		--character:Say("Inventory Item exists")
		local basecritrate 	= modData.CriticalChance
		local basecritmulti = modData.CritDmgMultiplier
		local basemindmg 	= modData.MinDamage
		local basemaxdmg 	= modData.MaxDamage
		local basename		= modData.Name
		
		inventoryItem:setCriticalChance(basecritrate)
		inventoryItem:setCritDmgMultiplier(basecritmulti)
		inventoryItem:setMinDamage(basemindmg)
		inventoryItem:setMaxDamage(basemaxdmg)
		inventoryItem:setName(basename)
		
		if modData.KillCount == nil then
			modData.KillCount = 0
		end
		
		modData.PlayerKills = KillCountSD(character)
		
	end
	
end

Events.OnEquipPrimary.Add(SDWeaponCheck)
