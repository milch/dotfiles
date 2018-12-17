local hyper = {"ctrl", "alt", "cmd"}

function round(x)
  return x + 0.5 - (x + 0.5) % 1
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

-- Window movement - left half, right, half, etc.
hs.hotkey.bind(hyper, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h
  f.y = max.y

  local current_fraction = nil
  for fraction=2,8,1 do
      f.w = round(max.w / fraction)
      f.x = round(max.x + (max.w / fraction * (fraction - 1)))
      if win:frame() == f then
          current_fraction = fraction
          break
      end
  end

  if current_fraction then
      current_fraction = current_fraction + 1
  else
      current_fraction = 2
  end

  f.x = max.x + round(max.w / current_fraction * (current_fraction - 1))
  f.w = round(max.w / current_fraction)

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.h = max.h

  local current_fraction = nil
  for fraction=2,8,1 do
      f.w = round(max.w / fraction)
      if win:frame() == f then
          current_fraction = fraction
          break
      end
  end

  if current_fraction then
      current_fraction = current_fraction + 1
  else
      current_fraction = 2
  end

  f.w = round(max.w / current_fraction)

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 3)
  f.y = max.y
  f.w = max.w / 3
  f.h = max.h

  win:setFrame(f)
end)

-- Move window to a different screen
hs.hotkey.bind(hyper, "Tab", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()

  win:centerOnScreen(screen:next())
end)
