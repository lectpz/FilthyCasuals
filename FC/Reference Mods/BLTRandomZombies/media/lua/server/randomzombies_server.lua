local Lib = BLTRandomZombies

-- -----------------------------------------------------------------------------
-- Helpers

local SPEED_SPRINTER = 1
local SPEED_FAST_SHAMBLER = 2
local SPEED_SHAMBLER = 3
-- local SPEED_RANDOM = 4

local COGNITION_SMART = 1
local COGNITION_DEFAULT = 3
local COGNITION_RANDOM = 4

function Lib.findField(o, fname)
  for i = 0, getNumClassFields(o) - 1 do
    local f = getClassField(o, i)
    if tostring(f) == fname then
      return f
    end
  end
end

local function defaultDistribution()
  local distribution = {}

  distribution.Crawler = 2
  distribution.Shambler = 15
  distribution.FastShambler = 78
  distribution.Sprinter = 5

  distribution.Fragile = 0
  distribution.NormalTough = 100
  distribution.Tough = 0

  distribution.Smart = 0

  return distribution
end

local warnModal = nil

local function dismissUserError(_button)
  if warnModal then
    warnModal:removeFromUIManager()
    warnModal = nil
  end
end

local function userError(msg)
  if warnModal then
    return
  end

  local player = getPlayer():getPlayerNum()
  local w = 380
  local h = 120
  local x = getPlayerScreenLeft(player) + (getPlayerScreenWidth(player) - w) / 2
  local y = getPlayerScreenTop(player) + (getPlayerScreenHeight(player) - h) / 2
  local text = "Random Zombies has encountered an error, falling back to default config.\nPlease check your configuration.\n\nError message:\n" .. msg

  warnModal = ISModalDialog:new(x, y, w, h, text, false, nil, dismissUserError, player)
  warnModal:initialise()
  warnModal:addToUIManager()
  warnModal:bringToTop()

  if JoypadState.players[player+1] then
    warnModal.prevFocus = JoypadState.players[player+1].focus
    setJoypadFocus(player, warnModal)
  end
end

function Lib.makeDistribution()
  if not SandboxVars.BLTRandomZombies then
    userError("Could not find BLTRandomZombies key in config.")
    return defaultDistribution()
  end

  if not (type(SandboxVars.BLTRandomZombies.Crawler) == "number" and
    type(SandboxVars.BLTRandomZombies.Shambler) == "number" and
    type(SandboxVars.BLTRandomZombies.FastShambler) == "number" and
    type(SandboxVars.BLTRandomZombies.Sprinter) == "number" and
    type(SandboxVars.BLTRandomZombies.Fragile) == "number" and
    type(SandboxVars.BLTRandomZombies.NormalTough) == "number" and
    type(SandboxVars.BLTRandomZombies.Tough) == "number" and
    type(SandboxVars.BLTRandomZombies.Smart) == "number")
  then
    userError("Config value is not a number.")
    return defaultDistribution()
  end

  if SandboxVars.BLTRandomZombies.Crawler +
    SandboxVars.BLTRandomZombies.Shambler +
    SandboxVars.BLTRandomZombies.FastShambler +
    SandboxVars.BLTRandomZombies.Sprinter
    ~= 100 then
    userError("Crawler, Shambler, FastShambler and Sprinter do not add up to 100.")
    return defaultDistribution()
  end

  if SandboxVars.BLTRandomZombies.Fragile +
    SandboxVars.BLTRandomZombies.NormalTough +
    SandboxVars.BLTRandomZombies.Tough
    ~= 100 then
    userError("Fragile, NormalTough and Tough do not add up to 100.")
    return defaultDistribution()
  end

  local distribution = {}
  distribution.Crawler = math.floor(100 * SandboxVars.BLTRandomZombies.Crawler)
  distribution.Shambler =
    distribution.Crawler + math.floor(100 * SandboxVars.BLTRandomZombies.Shambler)
  distribution.FastShambler =
    distribution.Shambler + math.floor(100 * SandboxVars.BLTRandomZombies.FastShambler)
  distribution.Sprinter =
    distribution.FastShambler + math.floor(100 * SandboxVars.BLTRandomZombies.Sprinter)

  distribution.Fragile = math.floor(100 * SandboxVars.BLTRandomZombies.Fragile)
  distribution.NormalTough =
    distribution.Fragile + math.floor(100 * SandboxVars.BLTRandomZombies.NormalTough)
  distribution.Tough =
    distribution.NormalTough + math.floor(100 * SandboxVars.BLTRandomZombies.Tough)

  distribution.Smart = math.floor(100 * SandboxVars.BLTRandomZombies.Smart)

  return distribution
end

-- NOTE: we implement our own since
-- % operator doesn't work with big numbers, confirm with 2^37%100 and 2^38%100
local function modulo(a, b)
  return a - math.floor(a/b)*b
end

local function shiftRight(a, b)
  while a > 0 and b > 0 do
    a = math.floor(a / 2)
    b = b - 1
  end
  return a
end

local p = 16 -- we want 2^p bits
local maxValue = 2^p -- OnlineID defined as a short as of 41.71
local two_32 = 2^32
local function hash(x)
  -- (x*2654435769 % 2^32) >> (32 - p)
  x = modulo(x*2654435769, two_32)
  return shiftRight(x, 32-p)
end

local function zombieID(zombie)
  local id = zombie:getOnlineID()
  if id == -1 then
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

  DebugLog.log(
    string.format("BLTRandomZombies.%s: %dms", tag, getTimestampMs() - timestamp))
end

local callCounts = {};
local startMs = getTimestampMs();
function Lib.called(tag, m)
  m = m or 10
  local cnt = callCounts[tag] or 0
  cnt = cnt + 1
  callCounts[tag] = cnt

  if cnt % m == 0 then
    local diffMs = getTimestampMs() - startMs
    DebugLog.log(string.format("%s: %d/s", tag, cnt*1000 / diffMs))
  end
end

function Lib.hashCheck()
  local filename = "randomzombies-hashcheck-linear.txt"
  local fw = getFileWriter(filename, true, false)
  if not fw then
    error("could not get file writer to " .. (filename or "nil"))
  end
  local zcnt = {
    Crawler = 0,
    CrawlerSmart = 0,
    Shambler = 0,
    ShamblerSmart = 0,
    FastShambler = 0,
    FastShamblerSmart = 0,
    Sprinter = 0,
    SprinterSmart = 0,
    total = 0,
  }
  local distribution = Lib.makeDistribution()

  for i=-2^15, 2^15 do
    local h = hash(i)
    local slice = hashToSlice(h)
    local hh = hash(h)
    local slice2 = hashToSlice(hh)
    local hhh = hash(hh)
    -- local slice3 = hashToSlice(hhh)
    if slice < distribution.Crawler then
      zcnt.Crawler = zcnt.Crawler + 1
      if slice2 < distribution.Smart then
        zcnt.CrawlerSmart = zcnt.CrawlerSmart + 1
      end
    elseif slice < distribution.Shambler then
      zcnt.Shambler = zcnt.Shambler + 1
      if slice2 < distribution.Smart then
        zcnt.ShamblerSmart = zcnt.ShamblerSmart + 1
      end
    elseif slice < distribution.FastShambler then
      zcnt.FastShambler = zcnt.FastShambler + 1
      if slice2 < distribution.Smart then
        zcnt.FastShamblerSmart = zcnt.FastShamblerSmart + 1
      end
    else
      zcnt.Sprinter = zcnt.Sprinter + 1
      if slice2 < distribution.Smart then
        zcnt.SprinterSmart = zcnt.SprinterSmart + 1
      end
    end
    zcnt.total = zcnt.total + 1

    fw:write(string.format("%d -> %d -> %d -> %d -> %s\r\n", i, h, hh, hhh, tostring(slice)))
  end
  fw:write(string.format(
             "crawler:%.2f%% (%d), shambler:%.2f%%, fastshambler:%.2f%%, sprinter:%.2f%% (%d)\r\n",
             zcnt.Crawler*100/zcnt.total,
             zcnt.Crawler,
             zcnt.Shambler*100/zcnt.total,
             zcnt.FastShambler*100/zcnt.total,
             zcnt.Sprinter*100/zcnt.total,
             zcnt.Sprinter))
  fw:write(string.format(
             "[smart] crawler:%.2f%% (%d), shambler:%.2f%% (%d), fastshambler:%.2f%% (%d), sprinter:%.2f%% (%d)\r\n",
             zcnt.CrawlerSmart*100/zcnt.Crawler,
             zcnt.CrawlerSmart,
             zcnt.ShamblerSmart*100/zcnt.Shambler,
             zcnt.ShamblerSmart,
             zcnt.FastShamblerSmart*100/zcnt.FastShambler,
             zcnt.FastShamblerSmart,
             zcnt.SprinterSmart*100/zcnt.Sprinter,
             zcnt.SprinterSmart))
  fw:close()
  print("wrote to " .. filename)

  filename = "randomzombies-hashcheck-zombies.txt"
  fw = getFileWriter(filename, true, false)
  if not fw then
    error("could not get file writer to " .. (filename or "nil"))
  end
  local zs = getCell():getZombieList()
  for i=0, zs:size() - 1 do
    local zid = zombieID(zs:get(i))
    local hh = hash(zid)
    local hhh = hash(zid)
    fw:write(string.format("%d -> %d -> %d\r\n", zid, hashToSlice(zid), hashToSlice(hh), hashToSlice(hhh)))
  end
  fw:close()
  print("wrote to " .. filename)
end

function Lib.z(id)
  if id == -1 then
    DebugContextMenu.selectedZombie = nil
  elseif id then
    local zs = getCell():getZombieList()
    for i=0, zs:size() - 1 do
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
  local cognition =
    Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.cognition")
  local speedType =
    Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.speedType")

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
  -- l(f('isBecomeCrawler: %s', tostring(z:isBecomeCrawler())))
  -- l(f('isCrawling: %s', tostring(z:isCrawling())))
  -- l(f('crawlerType: %s', tostring(z:getCrawlerType())))
  -- l(f('isCanWalk: %s', tostring(z:isCanWalk())))
  l(f('isKnockedDown: %s', tostring(z:isKnockedDown())))
  -- l(f('isFakeDead: %s', tostring(z:isFakeDead())))
  l(f('wasFakeDead: %s', tostring(z:wasFakeDead())))
  -- l(f('isHitLegsWhileOnFloor: %s', tostring(z:isHitLegsWhileOnFloor())))
end

function Lib.zcheck()
  local filename = "randomzombies-zcheck.txt"
  local fw = getFileWriter(filename, true, false)
  if not fw then
    error("could not get file writer to " .. (filename or "nil"))
  end
  local l = function (s)
    DebugLog.log(s)
    fw:write(s .. "\r\n")
  end
  local f = string.format
  local zs = getCell():getZombieList()
  local distribution = Lib.makeDistribution()
  local cnt = 0
  local zcnt = {
    Crawler = 0,
    CrawlerSmart = 0,
    Shambler = 0,
    ShamblerSmart = 0,
    FastShambler = 0,
    FastShamblerSmart = 0,
    Sprinter = 0,
    SprinterSmart = 0,
    remote = 0,
    duplicateID = 0,
  }
  local zombByID = {}
  local maxOnlineID = -2^32
  local minOnlineID = 2^32

  for i=0, zs:size() - 1 do
    local z = zs:get(i)

    local id = zombieID(z)
    local slice = hashToSlice(id)
    local slice2 = hashToSlice(hash(id))
    if slice < distribution.Crawler then
      zcnt.Crawler = zcnt.Crawler + 1
      if slice2 < distribution.Smart then
        zcnt.CrawlerSmart = zcnt.CrawlerSmart + 1
      end
      if not z:isCrawling() then
        l(f('id=%s expected crawling (crawler)', id))
        cnt = cnt + 1
      end
    elseif slice < distribution.Shambler then
      zcnt.Shambler = zcnt.Shambler + 1
      if slice2 < distribution.Smart then
        zcnt.ShamblerSmart = zcnt.ShamblerSmart + 1
      end
      if z:isCrawling() then
        l(f('id=%s expected not crawling (shambler)', id))
        cnt = cnt + 1
      end
    elseif slice < distribution.FastShambler then
      zcnt.FastShambler = zcnt.FastShambler + 1
      if slice2 < distribution.Smart then
        zcnt.FastShamblerSmart = zcnt.FastShamblerSmart + 1
      end
      if z:isCrawling() then
        l(f('id=%s expected not crawling (fastshambler)', id))
        cnt = cnt + 1
      end
    else
      zcnt.Sprinter = zcnt.Sprinter + 1
      if slice2 < distribution.Smart then
        zcnt.SprinterSmart = zcnt.SprinterSmart + 1
      end
      if z:isCrawling() then
        l(f('id=%s expected not crawling (sprinter)', id))
        cnt = cnt + 1
      end
    end

    if z:isRemoteZombie() then
      zcnt.remote = zcnt.remote + 1
    end

    local onlineID = z:getOnlineID()
    if zombByID[onlineID] then
      zcnt.duplicateID = zcnt.duplicateID + 1
    else
      zombByID[onlineID] = z
    end

    if onlineID > maxOnlineID then
      maxOnlineID = onlineID
    elseif onlineID < minOnlineID then
      minOnlineID = onlineID
    end
  end

  local sz = zs:size()
  l(f("crawler:%.2f%% (%d), shambler:%.2f%%, fastshambler:%.2f%%, sprinter:%.2f%% (%d)",
      zcnt.Crawler*100/sz, zcnt.Crawler,
      zcnt.Shambler*100/sz,
      zcnt.FastShambler*100/sz,
      zcnt.Sprinter*100/sz, zcnt.Sprinter))
  l(f("[smart] crawler:%.2f%% (%d), shambler:%.2f%%, fastshambler:%.2f%%, sprinter:%.2f%% (%d)",
      zcnt.CrawlerSmart*100/zcnt.Crawler, zcnt.CrawlerSmart,
      zcnt.ShamblerSmart*100/zcnt.Shambler,
      zcnt.FastShamblerSmart*100/zcnt.FastShambler,
      zcnt.SprinterSmart*100/sz, zcnt.Sprinter))
  l(f("remote:%.2f%% (%d), duplicate ids: %d, max online id:%d, min online id:%d",
      zcnt.remote*100/sz, zcnt.remote, zcnt.duplicateID, maxOnlineID, minOnlineID))
  l(f("found %d/%d potential inconsistencies (%.2f%%)",
      cnt, sz, cnt*100/sz))

  fw:close()
  print("wrote to " .. filename)
end

function Lib.fullCheck()
  Lib.zcheck()
  Lib.hashCheck()

  local filename = "randomzombies-distribution.txt"
  local fw = getFileWriter(filename, true, false)
  if not fw then
    error("could not get file writer to " .. (filename or "nil"))
  end
  for k, v in pairs(BLTRandomZombies.makeDistribution()) do
    fw:write(string.format("%s -> %d\r\n", k, v))
  end
  fw:close()
  print("wrote to " .. filename)

  filename = "randomzombies-server-config.txt"
  fw = getFileWriter(filename, true, false)
  if not fw then
    error("could not get file writer to " .. (filename or "nil"))
  end
  local mods = getServerOptions():getOptionByName("Mods"):getValue()
  local workshopItems = getServerOptions():getOptionByName("WorkshopItems"):getValue()
  fw:write(string.format("Mods=%s\r\nWorkshopItems=%s", mods, workshopItems))
  fw:close()
  print("wrote to " .. filename)
end

function Lib.cycleThroughNZombies()
  local square = getPlayer():getSquare()
  local x = square:getX()
  local y = square:getY()
  local z = square:getZ()
  local count = 10000
  local radius = 30
  local crawler = false
  local isFallOnFront = false
  local isFakeDead = false
  local knockedDown = false
  local health = 1
  local outfit = nil

  SendCommandToServer(
      string.format(
        "/createhorde2 -x %d -y %d -z %d -count %d -radius %d -crawler %s -isFallOnFront %s -isFakeDead %s -knockedDown %s -health %s -outfit %s ",
        x, y, z, count, radius,
        tostring(crawler),
        tostring(isFallOnFront),
        tostring(isFakeDead),
        tostring(knockedDown),
        tostring(health),
        outfit or ""))

end

-- -----------------------------------------------------------------------------
-- Globals and state

local function shouldBeStanding(z)
  -- as of 41.71:
  -- leg break, head bash, vehicle hit: isKnockedDown
  -- randomized vehicle stories: wasFakeDead / crawlerType = 1
  -- fakeDead: wasFakeDead
  -- Kate and Baldspot: crawlerType = 1
  -- createhorde2command: isKnockedDown / crawlerType = 1
  --
  -- Note that isKnockedDown and crawlerType are not transferred on the network
  -- so not reliable when generated by server for client-owned state like knockedDown

  return not z:isKnockedDown()
    and z:getCrawlerType() == 0
    and not z:wasFakeDead()
end

local function updateSpeed(zombie, targetSpeed, actualSpeed)
  local didChange = false

  if actualSpeed ~= targetSpeed then
    getSandboxOptions():set("ZombieLore.Speed", targetSpeed)
    zombie:makeInactive(true)
    zombie:makeInactive(false)
    getSandboxOptions():set("ZombieLore.Speed", SPEED_FAST_SHAMBLER)
    didChange = true
  end

  return didChange
end

local function updateCognition(zombie, targetCognition, actualCognition, cognition)
  local didChange = false

  if targetCognition == COGNITION_SMART and actualCognition ~= COGNITION_SMART  then
    didChange = true
    getSandboxOptions():set("ZombieLore.Cognition", COGNITION_SMART)
    zombie:DoZombieStats()
    getSandboxOptions():set("ZombieLore.Cognition", COGNITION_DEFAULT)
  elseif targetCognition == COGNITION_DEFAULT and actualCognition == COGNITION_SMART then
    didChange = true
    getSandboxOptions():set("ZombieLore.Cognition", COGNITION_RANDOM)
    while getClassFieldVal(zombie, cognition) == COGNITION_SMART do
      zombie:DoZombieStats()
    end
    getSandboxOptions():set("ZombieLore.Cognition", COGNITION_DEFAULT)
  end
  return didChange
end

local function updateZombie(zombie, distribution, speedType, cognition)
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
  local crawlingVal = zombie:isCrawling()
  local square = zombie:getCurrentSquare()
  local squareXVal = square and square:getX() or 0
  local squareYVal = square and square:getY() or 0

  -- NOTE(belette) we have to include X and Y in the check to catch zombies that have been recycled
  -- from _intended_ default state (i.e. RZ happened to assign it to default bucket) to _unintended_
  -- default state (i.e. RZ would not assign it to the default bucket, even though it's the same zombie)
  -- see IsoZombie::resetForReuse and VirtualZombieManager::createRealZombieAlways for more info
  local shouldSkip = speedTypeVal == modData.BLTspeed and
      cognitionVal == modData.BLTcog and
      crawlingVal == modData.BLTcrawl and
      math.abs(squareXVal - modData.BLTx) <= 20 and
      math.abs(squareYVal - modData.BLTy) <= 20

  -- NOTE(belette) we check for square to avoid crash in Java engine postupdate calls later
  if shouldSkip or (not square) then
    return true
  end

  local zid = zombieID(zombie)

  -- local function check(result)
  --   if shouldSkip and result then
  --     print(debugstacktrace(),
  --           crawlingVal, modData.BLTcrawl,
  --           speedTypeVal, modData.BLTspeed,
  --           cognitionVal, modData.BLTcog,
  --           squareXVal, modData.BLTx,
  --           squareYVal, modData.BLTy,
  --           hashToSlice(zid), hashToSlice(hash(zid)))
  --   end
  -- end

  local slice = hashToSlice(zid)

  -- update speeds
  if slice < distribution.Crawler then
    if not zombie:isCrawling() then
      -- go to crawl (calls DoZombieStats() internally)
      zombie:toggleCrawling()
      -- from ZombieOnGroundState:execute/1
      zombie:setCanWalk(false);
      -- on your belly, sir
      zombie:setFallOnFront(true)
    end
  elseif slice < distribution.Shambler then
    updateSpeed(zombie, SPEED_SHAMBLER, speedTypeVal)
    if zombie:isCrawling() and shouldBeStanding(zombie) then
      zombie:toggleCrawling()
      zombie:setCanWalk(true);
    end
  elseif slice < distribution.FastShambler then
    updateSpeed(zombie, SPEED_FAST_SHAMBLER, speedTypeVal)
    if zombie:isCrawling() and shouldBeStanding(zombie) then
      zombie:toggleCrawling()
      zombie:setCanWalk(true);
    end
  else
    updateSpeed(zombie, SPEED_SPRINTER, speedTypeVal)
    if zombie:isCrawling() and shouldBeStanding(zombie) then
      zombie:toggleCrawling()
      zombie:setCanWalk(true);
    end
  end

  -- update cognition
  if distribution.Smart > 0 then
    zid = hash(zid)
    local slice2 = hashToSlice(zid)
    if slice2 < distribution.Smart then
      updateCognition(zombie, COGNITION_SMART, cognitionVal, cognition)
    else
      updateCognition(zombie, COGNITION_DEFAULT, cognitionVal, cognition)
    end
  end

  -- update toughness
  if distribution.NormalTough ~= 100 then
    if not zombie:getAttackedBy() then
      zid = hash(zid)
      local slice3 = hashToSlice(zid)
      local health = 0.1 * ZombRand(4)
      if slice3 < distribution.Fragile  then
        health = health + 0.5
      elseif slice3 < distribution.NormalTough then
        health = health + 1.5
      else
        health = health + 3.5
      end
      zombie:setHealth(health)
    end
  end

  modData.BLTspeed = getClassFieldVal(zombie, speedType)
  modData.BLTcog = getClassFieldVal(zombie, cognition)
  modData.BLTcrawl = zombie:isCrawling()
  modData.BLTx = squareXVal
  modData.BLTy = squareYVal

  -- return shouldSkip
  return false
end

local tickFrequency = 10
local lastTicks = {16, 16, 16, 16, 16}
local lastTicksIdx = 1
local last = getTimestampMs()
local tickCount = 0
local function updateAllZombies()
  tickCount = tickCount + 1
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
  tickFrequency = math.max(2, math.ceil(SandboxVars.BLTRandomZombies.Frequency / avgTickMs))

  -- if getDebug() then
  --   local tickString = ""
  --   local first = true
  --   for _, v in pairs(lastTicks)  do
  --     if first then
  --       first = false
  --     else
  --       tickString = tickString .. ", "
  --     end
  --     tickString = string.format("%s%.2f", tickString, v)
  --   end
  --   DebugLog.log(
  --     string.format("BLTRandomZombies.diff: %.2fms", diff))
  --   DebugLog.log(
  --     string.format("BLTRandomZombies.tick_time: %.2fms", tickMs))
  --   DebugLog.log(
  --     string.format("BLTRandomZombies.tick_last_times: %s", tickString))
  --   DebugLog.log(
  --     string.format("BLTRandomZombies.tick_avg_time: %.2fms", avgTickMs))
  --   DebugLog.log(
  --     string.format("BLTRandomZombies.tick_freq: %d", tickFrequency))
  -- end

  local zs = getCell():getZombieList()
  local sz = zs:size()

  -- Lib.time("update_" .. sz, function ()
  local distribution = Lib.makeDistribution()
  local bob = IsoZombie.new(nil)
  local cognition =
    Lib.findField(bob, "public int zombie.characters.IsoZombie.cognition")
  local speedType =
    Lib.findField(bob, "public int zombie.characters.IsoZombie.speedType")
  local client = isClient()
  for i = 0, sz - 1 do
    local z = zs:get(i)
    if not (client and z:isRemoteZombie()) then
      updateZombie(z, distribution, speedType, cognition)
    end
  end
  -- end)
end

function Lib.enable()
  local prevTickMs = lastTicks[((lastTicksIdx + 3) % 5) + 1]
  last = getTimestampMs() - prevTickMs*tickCount
  Events.OnTick.Add(updateAllZombies)
end

function Lib.disable()
  Events.OnTick.Remove(updateAllZombies)
end

Lib.enable()
