local hyper = {"ctrl", "alt", "cmd"}

-- Helper functions
function round(x)
  return x + 0.5 - (x + 0.5) % 1
end

function compareFrame(lhs, rhs)
  local deltaX = lhs.x - rhs.x
  local deltaY = lhs.y - rhs.y
  local deltaH = lhs.h - rhs.h
  local deltaW = lhs.w - rhs.w

  local rms = (deltaX^2 + deltaY^2 + deltaH^2 + deltaW^2)^0.5
  return rms <= 5.0
end

function map(func, array)
  local new_array = {}
  for idx, value in ipairs(array) do
    new_array[idx] = func(value)
  end
  return new_array
end

function range(num, start)
  local arr = {}
  for i=start,num,1 do
    arr[#arr+1] = i
  end
  return arr
end

-- Auto reload config on changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

function frames()
  local screenFrame = hs.screen.mainScreen():frame()
  local supportedFractionCount = 8

  local middleThird = hs.screen.mainScreen():frame()
  middleThird.x = screenFrame.x + (screenFrame.w / 3)
  middleThird.w = screenFrame.w / 3

  local frames = {
    ["Right"] = map(
        function(f)
          frame = hs.screen.mainScreen():frame()
          frame.x = round(screenFrame.x + (screenFrame.w / f * (f - 1)))
          frame.w = round(screenFrame.w / f)
          return frame
        end,
      range(supportedFractionCount, 2)),
    ["Left"] = map(
        function(f)
          frame = hs.screen.mainScreen():frame()
          frame.w = round(screenFrame.w / f)
          return frame
        end,
      range(supportedFractionCount, 2)),
    ["Up"] = { screenFrame },
    ["Down"] = { middleThird }
  }

  return frames
end

function findNextFrame(currentFrame, type)
  local framesOfType = frames()[type]
  for idx, frame in pairs(framesOfType) do
    if compareFrame(frame, currentFrame) then
      return framesOfType[idx + 1]
    end
  end

  -- Default to the first available frame
  return framesOfType[1]
end

function windowMovement(keys, direction)
  hs.hotkey.bind(keys, direction, function()
    local win = hs.window.focusedWindow()

    local foundFrame = findNextFrame(win:frame(), direction)

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
  local f = win:frame()
  local screen = win:screen()

  win:centerOnScreen(screen:next())
end)
