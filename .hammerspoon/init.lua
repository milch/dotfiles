local hyper = { "ctrl", "alt", "cmd" }

-- Helper functions

---Returns `true` if the file at the given `name` exists
---@param name string
---@return boolean
local function fileExists(name)
  if type(name) ~= "string" then
    return false
  end
  return hs.fs.displayName(name) ~= nil
end

---Round `x` to the nearest integer
---@param x number
---@return number
local function round(x)
  return x + 0.5 - (x + 0.5) % 1
end

---Compares frames to check for equality
---@param lhs hs.geometry
---@param rhs hs.geometry
---@return boolean
local function framesEqual(lhs, rhs)
  local deltaX = lhs.x - rhs.x
  local deltaY = lhs.y - rhs.y
  local deltaH = lhs.h - rhs.h
  local deltaW = lhs.w - rhs.w

  local rms = (deltaX ^ 2 + deltaY ^ 2 + deltaH ^ 2 + deltaW ^ 2) ^ 0.5
  return rms <= 10.0
end

---Applies `func` to each member of the array and returns a new array with the result
---@param func any
---@param array any
---@return table
local function map(func, array)
  local new_array = {}
  for idx, value in ipairs(array) do
    new_array[idx] = func(value)
  end
  return new_array
end

---Returns an array with `num` elements starting at index `start`, where each value is equal to the index
---@param num number
---@param start number
---@return table
local function range(num, start)
  local arr = {}
  for i = start, num, 1 do
    arr[#arr + 1] = i
  end
  return arr
end

-- Auto reload config on changes
local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

local hammerspoonConfigFolder = os.getenv("HOME") .. "/dotfiles/.hammerspoon/"
local spoonsFolder = os.getenv("HOME") .. "/.hammerspoon/Spoons/"

-- Install `SpoonInstall` if it doesn't exist
if not fileExists(spoonsFolder .. "SpoonInstall.spoon") then
  local tempLocation = "/tmp/spoon_install.zip"
  os.execute(
    'curl -L "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip" -o ' .. tempLocation
  )
  os.execute('unzip "' .. tempLocation .. '" -d "' .. spoonsFolder .. '"')
end

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("EmmyLua")

hs.pathwatcher.new(hammerspoonConfigFolder, reloadConfig):start()
hs.alert.show("Config loaded")

---Returns a table of fractional window frames for the given direction, e.g. right half of screen, right quarter of screen, etc.
---@param screen hs.screen
---@return table
local function frames(screen)
  local screenFrame = screen:frame()
  local supportedFractionCount = 8

  local middleThird = screen:frame()
  middleThird.x = screenFrame.x + (screenFrame.w / 3)
  middleThird.w = screenFrame.w / 3

  local frameSizes = {
    ["Right"] = map(function(f)
      local frame = screen:frame()
      frame.x = round(screenFrame.x + (screenFrame.w / f * (f - 1)))
      frame.w = round(screenFrame.w / f)
      return frame
    end, range(supportedFractionCount, 2)),
    ["Left"] = map(function(f)
      local frame = screen:frame()
      frame.w = round(screenFrame.w / f)
      return frame
    end, range(supportedFractionCount, 2)),
    ["Up"] = map(function(f)
      local frame = screen:frame()
      frame.x = screenFrame.x
      frame.y = screenFrame.y
      frame.w = round(screenFrame.w)
      frame.h = round(screenFrame.h / f)
      return frame
    end, range(3, 1)),
    ["Down"] = map(function(f)
      local frame = screen:frame()
      frame.x = screenFrame.x + round(screenFrame.w / 3)
      frame.y = screenFrame.y + round(screenFrame.h / f * (f - 1))
      frame.w = round(screenFrame.w / 3)
      frame.h = round(screenFrame.h / f)
      return frame
    end, range(3, 1)),
  }

  return frameSizes
end

---@param screen hs.screen
---@param currentFrame hs.geometry
---@param type string
---@return hs.geometry
local function findNextFrame(screen, currentFrame, type)
  local framesOfType = frames(screen)[type]
  for idx, frame in pairs(framesOfType) do
    if framesEqual(frame, currentFrame) then
      return framesOfType[idx + 1]
    end
  end

  -- Default to the first available frame
  return framesOfType[1]
end

local function windowMovement(keys, direction)
  hs.hotkey.bind(keys, direction, function()
    local win = hs.window.focusedWindow()

    local foundFrame = findNextFrame(win:screen(), win:frame(), direction)

    win:setFrame(foundFrame)
  end)
end

windowMovement(hyper, "Right")
windowMovement(hyper, "Left")
windowMovement(hyper, "Up")
windowMovement(hyper, "Down")

-- Move window to a different screen
hs.hotkey.bind(hyper, "Tab", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()

  win:centerOnScreen(screen:next(), true)
end)
