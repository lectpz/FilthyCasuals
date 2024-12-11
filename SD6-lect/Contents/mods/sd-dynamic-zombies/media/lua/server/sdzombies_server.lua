--
require "SDZoneCheck" --lect

local Lib = SDRandomZombies

local SDZ_UPDATE_FREQUENTY = 1000
local SPEED_SPRINTER = 1
local SPEED_FAST_SHAMBLER = 2
local SPEED_SHAMBLER = 3

local COGNITION_SMART = 1
local COGNITION_DEFAULT = 3
local COGNITION_RANDOM = 4

local HEARING_PINPOINT = 1
local HEARING_NORMAL = 2

function Lib.findField(o, fname)
    for i = 0, getNumClassFields(o) - 1 do
        local f = getClassField(o, i)
        if tostring(f) == fname then
            return f
        end
    end
end

function Lib.makeDistribution()
    if not SandboxVars.SDRandomZombies then
        error("no SDRandomZombies key in config")
    end

    local distribution = {}
    distribution.Crawler = 0
    distribution.Shambler = 0
    distribution.FastShambler = 50
    -- distribution.Shambler + math.floor(100 * SandboxVars.SDRandomZombies.FastShambler)
    distribution.Sprinter = 50
    -- distribution.FastShambler + math.floor(100 * SandboxVars.SDRandomZombies.Sprinter)

    distribution.Fragile = 0
    distribution.NormalTough = 100
    distribution.Tough = 0
    distribution.Smart = 0

    return distribution
end

-- NOTE: we implement our own since
-- % operator doesn't work with big numbers, confirm with 2^37%100 and 2^38%100
local function modulo(a, b)
    return a - math.floor(a / b) * b
end

local function shiftRight(a, b)
    while a > 0 and b > 0 do
        a = math.floor(a / 2)
        b = b - 1
    end
    return a
end

local p = 16 -- we want 2^p bits
local maxValue = 2 ^ p -- OnlineID defined as a short as of 41.71
local two_32 = 2 ^ 32
local function hash(x)
    -- (x*2654435769 % 2^32) >> (32 - p)
    x = modulo(x * 2654435769, two_32)
    return shiftRight(x, 32 - p)
end

local function zombieID(zombie)
    local id = zombie:getOnlineID()
    if id < 0 then
        id = modulo(zombie:hashCode(), maxValue)
    end

    return hash(id)
end

local function hashToSlice(h)
    return math.floor((h / maxValue) * 10000)
end

-- -----------------------------------------------------------------------------
-- Perf and diagnostics

function Lib.time(tag, fn)
    local timestamp = getTimestampMs()

    fn()

    DebugLog.log(string.format("SDRandomZombies.%s: %dms", tag, getTimestampMs() - timestamp))
end

local callCounts = {};
local startMs = getTimestampMs();

function Lib.z(id)
    if id == -1 then
        DebugContextMenu.selectedZombie = nil
    elseif id then
        local zs = getCell():getZombieList()
        for i = 0, zs:size() - 1 do
            local z = zs:get(i)
            if zombieID(z) == id then
                DebugContextMenu.selectedZombie = z
            end
        end
    end

    local z = DebugContextMenu.selectedZombie
    if not z then
        return
    end

    z:dressInNamedOutfit("TutorialDad")
    z:resetModelNextFrame()

    DebugContextMenu.OnSelectedZombieWalk(getPlayer():getSquare())

    local distribution = Lib.makeDistribution()
    local cognition = Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.cognition")
    local speedType = Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.speedType")

    local zid = zombieID(z)
    local slice = hashToSlice(zid)
    local slicename
    if slice < distribution.Crawler then
        slicename = "Crawler"
    elseif slice < distribution.Shambler then
        slicename = "Shambler"
    elseif slice < distribution.FastShambler then
        slicename = "FastShambler"
    else
        slicename = "Sprinter"
    end

    local hh = hash(zid)
    local slice2 = hashToSlice(hh)
    local slice2name
    if slice2 < distribution.Smart then
        slice2name = "Smart"
    else
        slice2name = "Normal"
    end

    local hhh = hash(hh)
    local slice3 = hashToSlice(hhh)
    local slice3name
    if slice3 < distribution.Fragile then
        slice3name = "Fragile"
    elseif slice3 < distribution.NormalTough then
        slice3name = "NormalTough"
    else
        slice3name = "Tough"
    end

    local l = DebugLog.log
    local f = string.format
    l(f('zombieID: %s', tostring(zombieID(z))))
    l(f('hashCode: %s', tostring(z:hashCode())))
    l(f('onlineID: %s', tostring(z:getOnlineID())))
    l(f('isRemoteZombie: %s', tostring(z:isRemoteZombie())))
    l(f('slice: %s (%d)', slicename, slice))
    l(f('slice2: %s (%d)', slice2name, slice2))
    l(f('slice3: %s (%d)', slice3name, slice3))
    l(f('health: %.2f', z:getHealth()))
    l(f('cognition: %d', getClassFieldVal(z, cognition)))
    l(f('speedType: %d', getClassFieldVal(z, speedType)))
    l(f('isKnockedDown: %s', tostring(z:isKnockedDown())))
    l(f('wasFakeDead: %s', tostring(z:wasFakeDead())))
end

-- -----------------------------------------------------------------------------
-- Globals and state

local function shouldBeStanding(z)
    -- leg break, head bash, vehicle hit: isKnockedDown
    -- randomized vehicle stories: wasFakeDead / crawlerType = 1
    -- fakeDead: wasFakeDead
    -- Kate and Baldspot: crawlerType = 1
    -- createhorde2command: isKnockedDown / crawlerType = 1
    --
    -- Note that isKnockedDown and crawlerType are not transferred on the network
    -- so not reliable when generated by server for client-owned state like knockedDown

    return not z:isKnockedDown() and z:getCrawlerType() == 0 and not z:wasFakeDead()
end

local sandboxOpts = getSandboxOptions()
local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)
    local didChange = false

    if actualSpeed ~= targetSpeed or actualHearing ~= targetHearing then
		--local sandboxOpts = getSandboxOptions()
        sandboxOpts:set("ZombieLore.Speed", targetSpeed)
        sandboxOpts:set("ZombieLore.Hearing", targetHearing)
        zombie:makeInactive(true)
        zombie:makeInactive(false)
        sandboxOpts:set("ZombieLore.Speed", SPEED_FAST_SHAMBLER)
        sandboxOpts:set("ZombieLore.Hearing", HEARING_NORMAL)
        didChange = true
    end

    return didChange
end

--lect
--link to SDZoneCheck and pull the coordinates from the global table.concat
--write the coordinates locally so we're not calling the global table thousands of times each update
local Coords = {}

for zoneName, coordinates in pairs(Zone.list) do
    Coords[zoneName] = {
        x1 = coordinates[1],
        y1 = coordinates[2],
        x2 = coordinates[3],
        y2 = coordinates[4]
    }
end

local SDzones = {
	"InsidePetro",
	"LCBunker",
	"LCDowntown",
	"LCSouth1",
	"LCSouth2",
	"RavenCreekPDMilitaryHospital",
	"RavenCreekEntrance",
	"EeriePowerPlant",
	"EerieCapitol",
	"EerieMilitaryBase",
	"EerieIrvington",
	"BigBearLakeWest",
	"LouisvillePD",
	"LouisvilleMallArea",
	"Louisville",
	"CC",
	"Muldraugh",
	"WestPointWest",
	"WestPointEast",
	"Riverside",
	"Rosewood",
	"MarchRidge",
	"Petroville",
	"LakeIvy",
	"FortRedstone",
	"RavenCreek",
	"EerieCountry",
	"BigBearLake",
	"Chestown",
	"LC",
	"Taylorsville",
	"Grapeseed",
	"OldStPaulo",
	"LVshipping",
	"LVairport",
	"OaksdaleU",
	"Nettle",
	"RosewoodX",
	"DirkerCityT5W",
	"DirkerCityT5E",
	"DirkerTownSouthT4",
	"DirkerTownSouthT3",
	"DirkerTownSouthEastT4",
	"DirkerTownSouthEastT3",
	"DirkerCityT4NW",
	"DirkerCityT4N",
	"DirkerCityT4NE",
	"DirkerCityT4W",
	"DirkerCityT4E",
	"DirkerCityT4SW",
	"DirkerCityT4S",
	"DirkerCityT4SE",
	"DirkerCityT4EE",
	"DirkerCityT3N",
	"DirkerCityT3West",
	"DirkerCityT3South",
	"DirkerTownNorthWestT4",
	"DirkerTownNorthWestT3",
	"DirkerEncampment",
	"ValleyStreamMall",
}

local function isInsideZone(zone, x, y)
  return x >= Coords[zone].x1 and y >= Coords[zone].y1 and x < Coords[zone].x2 and y < Coords[zone].y2
end

local function SDDistribution(zone)
	d_Local = 100 * SandboxVars.SDRandomZombies[zone]
	d_Hearing = 100 * SandboxVars.SDRandomZombies["Pinpoint" .. zone]
	d_Zone = zone
	return d_Local, d_Hearing, d_Zone
end
--lect

local function updateZombie(zombie, distribution, speedType, cognition, hearing)
    -- IsoZombie::Hit(Vehicle...) suggests that stagger, knockdown and crawling
    -- states are managed by client

    -- IsoZombie::hitConsequences(Vehicle...) suggests that knockdown
    -- states is managed by client && !remote

    -- see also:
    -- IsoZombie::resetForReuse/0
    -- IsoZombie::shouldBecomeCrawler/0
    -- VirtualZombieManager::createRealZombieAlways/3

    local modData = zombie:getModData()
    local speedTypeVal = getClassFieldVal(zombie, speedType)
    local cognitionVal = getClassFieldVal(zombie, cognition)
    local hearingVal = getClassFieldVal(zombie, hearing)
    local crawlingVal = zombie:isCrawling()
    local square = zombie:getCurrentSquare()
    local squareXVal = square and square:getX() or 0
    local squareYVal = square and square:getY() or 0

    -- NOTE(belette) we have to include X and Y in the check to catch zombies that have been recycled
    -- from _intended_ default state (i.e. RZ happened to assign it to default bucket) to _unintended_
    -- default state (i.e. RZ would not assign it to the default bucket, even though it's the same zombie)
    -- see IsoZombie::resetForReuse and VirtualZombieManager::createRealZombieAlways for more info
    local shouldSkip = speedTypeVal == modData.SDspeed and cognitionVal == modData.SDcog and hearingVal ==
                           modData.SDhearing and crawlingVal == modData.SDcrawl and math.abs(squareXVal - modData.SDx) <=
                           35 and math.abs(squareYVal - modData.SDy) <= 35
						   
--lect
	local zombieSprinterZoneValue = modData.SDSprinterZoneValue or nil --call the modData for sprinterzone % associated with the zombie, or nil if it doesn't exist. if it does exist, its because it was written at the end of updateZombie
	local zombieSprinterZone = modData.SDSprinterZone or nil --call the modData for sprinterzone name associated with the zombie, or nil if it doesn't exist. if it does exist, its because it was written at the end of updateZombie
	--(note) avoiding the sprinterzonecheck because it can get quite heavy to iterate ontick for each zombie. instead, log the sprinter zone name onto the zombie mod data, then check do one additional check to check if the sprinter% for that zone matches the sprinter% logged onto the zombie
--lect
    -- NOTE(belette) we check for square to avoid crash in Java engine postupdate calls later
    if shouldSkip or (not square) then
		if zombieSprinterZoneValue and zombieSprinterZone then
			if zombieSprinterZoneValue == SandboxVars.SDRandomZombies[zombieSprinterZone] then--lect
				return true
			end
		end
    end

    local zid = zombieID(zombie)
    local slice = hashToSlice(zid)

    if slice < 0 then
        slice = 0
    end
	
--lect
	local event_x1 = SandboxVars.SDevents.Xcoord1 or 1
	local event_y1 = SandboxVars.SDevents.Ycoord1 or 1
	local event_x2 = SandboxVars.SDevents.Xcoord2 or 1
	local event_y2 = SandboxVars.SDevents.Ycoord2 or 1

	if squareXVal >= event_x1 and squareYVal >= event_y1 and squareXVal < event_x2 and squareYVal < event_y2 and SandboxVars.SDevents.enabled then
		distributionLocal, distributionHearing, distributionZone = SDDistribution("EventZone")
	else
		for i=1,#SDzones+1 do
			if i <= #SDzones then
				if isInsideZone(SDzones[i], squareXVal, squareYVal) then
					distributionLocal, distributionHearing, distributionZone = SDDistribution(SDzones[i])
					break
				end
			elseif i == #SDzones+1 then
				distributionLocal, distributionHearing, distributionZone = SDDistribution("Default")
			end
		end
	end
--lect

    if distributionLocal <= 100 then distributionLocal = 0 end

    local targetSpeed = (slice < distributionLocal) and SPEED_SPRINTER or SPEED_FAST_SHAMBLER
    local targetHearing = (slice < distributionHearing) and HEARING_PINPOINT or HEARING_NORMAL

    -- local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)
    updateSpeedAndHearing(zombie, targetSpeed, speedTypeVal, targetHearing, hearingVal)

    if zombie:isCrawling() and shouldBeStanding(zombie) then
        zombie:toggleCrawling()
        zombie:setCanWalk(true);
    end

    modData.SDspeed = getClassFieldVal(zombie, speedType)
    modData.SDcog = getClassFieldVal(zombie, cognition)
    modData.SDhearing = getClassFieldVal(zombie, hearing)
    modData.SDcrawl = zombie:isCrawling()
    modData.SDx = squareXVal
    modData.SDy = squareYVal
	modData.SDSprinterZone = distributionZone--log the sprinterzone name
	modData.SDSprinterZoneValue = SandboxVars.SDRandomZombies[distributionZone]--sandbox zone sprinter %

    -- return shouldSkip
    return false
end

local zCounter = 0

local function addEventUpdate()
	Events.EveryOneMinute.Add(updateAllZombies)
	--print("Events.EveryOneMinute.Add(updateAllZombies) executed!")
end

local function removeEventUpdate()
	Events.EveryOneMinute.Remove(updateAllZombies)
	--print("Events.EveryOneMinute.Remove(updateAllZombies) executed!")
end

--[[
local tickFrequency = 10
local lastTicks = {16, 16, 16, 16, 16}
local lastTicksIdx = 1
local last = getTimestampMs()
local tickCount = 0]]
local function updateAllZombies()
--[[tickCount = tickCount + 1
    if tickCount % tickFrequency ~= 1 then
        return
    end
    tickCount = 1

    local now = getTimestampMs()
    local diff = now - last
    last = now

    local tickMs = diff / tickFrequency
    lastTicks[lastTicksIdx] = tickMs
    lastTicksIdx = (lastTicksIdx % 5) + 1
    local totalTicks = 0
    local sumTicks = 0
    for _, v in ipairs(lastTicks) do
        sumTicks = sumTicks + v
        totalTicks = totalTicks + 1
    end

    local avgTickMs = sumTicks / totalTicks
    -- NOTE: needs to be at least 2 for modulo check to pass
    tickFrequency = math.max(2, math.ceil(SDZ_UPDATE_FREQUENTY / avgTickMs))
]]
	zCounter = zCounter + 1
	sandboxOpts = getSandboxOptions()
	--print("update zombie counter... " .. zCounter*5 .. " seconds passed!")
	if zCounter >=1 then
		removeEventUpdate() -- lect -- remove the event update, dont want this overlapping
		--local startTime = getTimestampMs()
		local zs = getCell():getZombieList()
		local sz = zs:size()

		-- Lib.time("update_" .. sz, function ()
		local distribution = Lib.makeDistribution()
		local bob = IsoZombie.new(nil)
		local cognition = Lib.findField(bob, "public int zombie.characters.IsoZombie.cognition")
		local speedType = Lib.findField(bob, "public int zombie.characters.IsoZombie.speedType")
		local hearing = Lib.findField(bob, "public int zombie.characters.IsoZombie.hearing")
		local client = isClient()
		for i = 0, sz - 1 do
			local z = zs:get(i)
			if not (client and z:isRemoteZombie()) then
				updateZombie(z, distribution, speedType, cognition, hearing)
			end
		end
		-- end)
		--print("zombies updated! total zombies updated: " .. sz)
		addEventUpdate() -- lect -- re-add event update after all zombies have been updated.
		--local timeElapsed = getTimestampMs() - startTime
		--print("It took " .. timeElapsed .. "ms to complete zombie update!")
		zCounter = 0
	end
end

function Lib.enable()
    --local prevTickMs = lastTicks[((lastTicksIdx + 3) % 5) + 1]
    --last = getTimestampMs() - prevTickMs * tickCount
    --Events.OnTick.Add(updateAllZombies)
end

function Lib.disable()
    Events.OnTick.Remove(updateAllZombies)
end

--Lib.enable()
Events.EveryOneMinute.Add(updateAllZombies)