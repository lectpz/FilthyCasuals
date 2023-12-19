----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"
require "OnZombieDeadFC"

-- function to scale crit and min/max dmg based on zone
function OnWeaponSwingFC(character, handWeapon)
	
	if character ~= nil and not handWeapon:isRanged() then
		-- set tierzone 
		local tierzone = checkZone()
		-- if it's tier 1, just don't do anything
		if tierzone then
			-- save original crit rate, min dmg, and max dmg
			local playerItem = handWeapon
			
			-- check weapon for moddata, if no moddata then establish moddata
			if	playerItem:getModData().CriticalChance		== nil and
				playerItem:getModData().CritDmgMultiplier	== nil and
				playerItem:getModData().MinDamage		== nil and
				playerItem:getModData().MaxDamage		== nil and
				playerItem:getModData().Name			== nil then
				
				-- if there are no moddata stats attached to the weapon then set moddata to weapon
				local o_critrate 	=	playerItem:getCriticalChance()
				local o_critmulti	=	playerItem:getCritDmgMultiplier()
				local o_mindmg		=	playerItem:getMinDamage()
				local o_maxdmg		=	playerItem:getMaxDamage()
				local o_name		=	playerItem:getName()
				print(o_name " base name")
				-- set moddata in key, value pairs
				
				playerItem:getModData().CriticalChance		= o_critrate
				playerItem:getModData().CritDmgMultiplier	= o_critmulti
				playerItem:getModData().MinDamage		= o_mindmg
				playerItem:getModData().MaxDamage		= o_maxdmg
				playerItem:getModData().Name			= o_name
				--print:Say("mod data stored")
			else
				--print("mod data already exists, nothing needs to be done")
			end
			
			local basecritrate 	= playerItem:getModData().CriticalChance
			local basecritmulti	= playerItem:getModData().CritDmgMultiplier
			local basemindmg 	= playerItem:getModData().MinDamage
			local basemaxdmg 	= playerItem:getModData().MaxDamage
			local basename		= playerItem:getModData().Name
			
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
			local tiercritratemod	= {tonumber(SandboxVars.OnWeaponSwingFC.Tier1critrate), tonumber(SandboxVars.OnWeaponSwingFC.Tier2critrate), tonumber(SandboxVars.OnWeaponSwingFC.Tier3critrate), tonumber(SandboxVars.OnWeaponSwingFC.Tier4critrate)}
			local tiercritmultimod	= {tonumber(SandboxVars.OnWeaponSwingFC.Tier1critmulti), tonumber(SandboxVars.OnWeaponSwingFC.Tier2critmulti), tonumber(SandboxVars.OnWeaponSwingFC.Tier3critmulti), tonumber(SandboxVars.OnWeaponSwingFC.Tier4critmulti)}
			local tierdmgmod	= {tonumber(SandboxVars.OnWeaponSwingFC.Tier1dmg), tonumber(SandboxVars.OnWeaponSwingFC.Tier2dmg), tonumber(SandboxVars.OnWeaponSwingFC.Tier3dmg), tonumber(SandboxVars.OnWeaponSwingFC.Tier4dmg)}

			local localdmgmulti	= tierdmgmod[tierzone]
			local localcritrate	= tiercritratemod[tierzone]
			local localcritmulti	= tiercritmultimod[tierzone]
            
			-- set weapon stats
			playerItem:setCriticalChance(basecritrate * localcritrate + (FilthyCasual * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus critrate is 0. T2=1. T3=2. T4=3. If FC=false, then FC=0 and nothing applies
			playerItem:setCritDmgMultiplier(basecritmulti * localcritmulti + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus critmulti is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			playerItem:setMinDamage(basemindmg * localdmgmulti + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus mindmg is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			playerItem:setMaxDamage(basemaxdmg * localdmgmulti + (FilthyCasual/10 * (tierzone-1))) -- if FilthyCasual is true, then FilthyCasual = 1. For T1, bonus maxdmg is 0. T2=0.1. T3=0.2. T4=0.3. If FC=false, then FC=0 and nothing applies
			playerItem:setName(basename .. " [T" .. tostring(tierzone) .. "]")
			-- debug display to make my life easier
--			character:Say("ModCrit=" .. tostring(basecritrate * localcrit) .. " ModMinDmg=" .. tostring(basemindmg * localdmgmulti) .. " ModMaxDmg=" .. tostring(basemaxdmg * localdmgmulti))
--			character:Say("ModMinDmg=" .. tostring(basemindmg * localdmgmulti) .. " ModMaxDmg=" .. tostring(basemaxdmg * localdmgmulti) .. "ModCrit=" .. tostring(basecritrate * localcritrate) .. " ModCritMulti=" .. tostring(basecritmulti * localcritmulti))

		end
	end
end

Events.OnWeaponSwing.Add(OnWeaponSwingFC)

function WeaponCheckFC(character, inventoryItem)
	--character:Say("WeaponCheckFC")

	if inventoryItem == nil then
		--character:Say("Inventory Item is Nil")
		--return
	elseif inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		if	inventoryItem:getModData().CriticalChance	== nil and
			inventoryItem:getModData().CritDmgMultiplier	== nil and
			inventoryItem:getModData().MinDamage		== nil and
			inventoryItem:getModData().MaxDamage		== nil and
			inventoryItem:getModData().Name			== nil then
			
			local o_critrate 	=	inventoryItem:getCriticalChance()
			local o_critmulti	=	inventoryItem:getCritDmgMultiplier()
			local o_mindmg		=	inventoryItem:getMinDamage()
			local o_maxdmg		=	inventoryItem:getMaxDamage()
			local o_name		=	inventoryItem:getName()
			print(o_name .. " base name")

			inventoryItem:getModData().CriticalChance	= o_critrate
			inventoryItem:getModData().CritDmgMultiplier	= o_critmulti
			inventoryItem:getModData().MinDamage		= o_mindmg
			inventoryItem:getModData().MaxDamage		= o_maxdmg
			inventoryItem:getModData().Name			= o.name
			character:Say("mod data stored")
		else
			--character:Say("mod data already exists, nothing needs to be done")
		end
		--character:Say("Inventory Item exists")
		local basecritrate 	= inventoryItem:getModData().CriticalChance
		local basecritmulti 	= inventoryItem:getModData().CritDmgMultiplier
		local basemindmg 	= inventoryItem:getModData().MinDamage
		local basemaxdmg 	= inventoryItem:getModData().MaxDamage
		local basename		= inventoryItem:getModData().Name
		
		inventoryItem:setCriticalChance(basecritrate)
		inventoryItem:setCritDmgMultiplier(basecritmulti)
		inventoryItem:setMinDamage(basemindmg)
		inventoryItem:setMaxDamage(basemaxdmg)
		inventoryItem:setName(basename)
	end
	
end

Events.OnEquipPrimary.Add(WeaponCheckFC)
