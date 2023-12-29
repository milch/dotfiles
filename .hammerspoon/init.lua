local hyper = { "ctrl", "alt", "cmd" }
local shiftHyper = { "ctrl", "alt", "cmd", "shift" }
local bind = hs.hotkey.bind

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
---@generic T
---@generic U
---@param array T[]
---@param func fun(elem: T): U
---@return U[]
local function map(array, func)
	local new_array = {}
	for idx, value in ipairs(array) do
		new_array[idx] = func(value)
	end
	return new_array
end

---Returns an array with `num` elements starting at index `start`, where each value is equal to the index
---@param num number
---@param start number
---@return number[]
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
---@return tablewstring, hs.geometry[]w
local function frames(screen)
	local screenFrame = screen:frame()
	local supportedFractionCount = 8

	local middleThird = screen:frame()
	middleThird.x = screenFrame.x + (screenFrame.w / 3)
	middleThird.w = screenFrame.w / 3

	local frameSizes = {
		["Right"] = map(range(supportedFractionCount, 2), function(f)
			local frame = screen:frame()
			frame.x = round(screenFrame.x + (screenFrame.w / f * (f - 1)))
			frame.w = round(screenFrame.w / f)
			return frame
		end),
		["Left"] = map(range(supportedFractionCount, 2), function(f)
			local frame = screen:frame()
			frame.w = round(screenFrame.w / f)
			return frame
		end),
		["Up"] = map(range(3, 1), function(f)
			local frame = screen:frame()
			frame.x = screenFrame.x
			frame.y = screenFrame.y
			frame.w = round(screenFrame.w)
			frame.h = round(screenFrame.h / f)
			return frame
		end),
		["Down"] = map(range(3, 1), function(f)
			local frame = screen:frame()
			frame.x = screenFrame.x + round(screenFrame.w / 3)
			frame.y = screenFrame.y + round(screenFrame.h / f * (f - 1))
			frame.w = round(screenFrame.w / 3)
			frame.h = round(screenFrame.h / f)
			return frame
		end),
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
	bind(keys, direction, function()
		local win = hs.window.focusedWindow()

		local foundFrame = findNextFrame(win:screen(), win:frame(), direction)

		win:setFrame(foundFrame)
	end)
end

windowMovement(hyper, "Right")
windowMovement(hyper, "Left")
windowMovement(hyper, "Up")
windowMovement(hyper, "Down")

---@param screen hs.screen
---@param window hs.window
---@param direction string
local function moveFrameToEdge(screen, window, direction)
	local screenFrame = screen:frame()

	local frameAtEdges = {
		["Right"] = function()
			local frame = window:frame()
			frame.x = round(screenFrame.x + screenFrame.w - frame.w)
			return frame
		end,
		["Left"] = function()
			local frame = window:frame()
			frame.x = screenFrame.x
			return frame
		end,
		["Up"] = function()
			local frame = window:frame()
			frame.y = screenFrame.y
			return frame
		end,
		["Down"] = function()
			local frame = window:frame()
			frame.y = round(screenFrame.y + screenFrame.h - frame.h)
			return frame
		end,
	}

	return frameAtEdges[direction]()
end

-- Push the window up to the border of the screen
local function push(modifier, directionKey)
	bind(modifier, directionKey, function()
		local win = hs.window.focusedWindow()

		local foundFrame = moveFrameToEdge(win:screen(), win, directionKey)

		win:setFrame(foundFrame)
	end)
end

push(shiftHyper, "Right")
push(shiftHyper, "Left")
push(shiftHyper, "Up")
push(shiftHyper, "Down")

local function yabai(args, completion)
	return function()
		local yabai_output = ""
		local yabai_error = ""
		-- Runs in background very fast
		local yabai_task = hs.task.new("/opt/homebrew/bin/yabai", nil, function(task, stdout, stderr)
			--print("stdout:"..stdout, "stderr:"..stderr)
			if stdout ~= nil then
				yabai_output = yabai_output .. stdout
			end
			if stderr ~= nil then
				yabai_error = yabai_error .. stderr
			end
			return true
		end, args)
		if type(completion) == "function" then
			yabai_task:setCallback(function()
				completion(yabai_task:terminationStatus(), yabai_output, yabai_error)
			end)
		end
		yabai_task:start()
	end
end

local function exec(cmd)
	return function()
		local task = hs.task.new("/bin/zsh", nil, function()
			return true
		end, { "-c", cmd })
		task:start()
	end
end

local function yabai_focus(dir)
	return yabai({ "-m", "window", "--focus", dir }, function(status)
		if status ~= 0 then
			yabai({ "-m", "display", "--focus", dir })()
		end
	end)
end

bind(hyper, "h", yabai_focus("west"))
bind(hyper, "j", yabai_focus("south"))
bind(hyper, "k", yabai_focus("north"))
bind(hyper, "l", yabai_focus("east"))

local function yabai_swap(dir)
	return exec(
		"/opt/homebrew/bin/yabai -m window --swap "
		.. dir
		.. " || (/opt/homebrew/bin/yabai -m window --display "
		.. dir
		.. "; /opt/homebrew/bin/yabai -m display --focus "
		.. dir
		.. ")"
	)
end
-- swap windows
bind(shiftHyper, "h", yabai_swap("west"))
bind(shiftHyper, "j", yabai_swap("south"))
bind(shiftHyper, "k", yabai_swap("north"))
bind(shiftHyper, "l", yabai_swap("east"))

bind(hyper, "x", yabai({ "-m", "space", "--mirror", "x-axis" }))
bind(hyper, "y", yabai({ "-m", "space", "--mirror", "y-axis" }))

bind(hyper, "r", yabai({ "-m", "space", "--rotate", "270" }))
bind(shiftHyper, "r", yabai({ "-m", "config", "--space", "mouse", "layout", "bsp" }))

bind(hyper, "t", yabai({ "-m", "window", "--toggle", "float", "--grid", "4:4:1:1:2:2" }))

-- maximize a window
bind(hyper, "f", yabai({ "-m", "window", "--toggle", "zoom-fullscreen" }))
-- balance out tree of windows (resize to occupy same area)
bind(hyper, "0", yabai({ "-m", "space", "--balance" }))

-- move window to prev and next space
local function yabai_move_and_follow(dir)
	local focusedWindow = hs.window.focusedWindow()
	return yabai({ "-m", "window", "--space", dir }, function()
		if dir == "prev" then
			hs.eventtap.keyStroke({ "ctrl", "fn" }, "left")
		else
			hs.eventtap.keyStroke({ "ctrl", "fn" }, "right")
		end
		focusedWindow:focus()
	end)
end
bind(hyper, "[", yabai_move_and_follow("prev"))
bind(hyper, "]", yabai_move_and_follow("next"))

-- Workaround for macOS' weird behaviour where when "Displays have their own spaces" is on,
-- it then treats the space numbers as absolute, i.e. if display 1 has 3 spaces and
-- display 2 has 3 spaces then pressing the shortcut to switch to space 1 will always
-- go to space 1 on display 1, even if the current focus is on display 2. I just keep
-- 9 spaces on every display and then assign different modifiers to each display. The shortcuts
-- need to be mutually exclusive, otherwise it doesn't trigger correctly, and (for some reason)
-- can't contain `fn`.
local function switch_to_space(num)
	return function()
		if hs.screen.primaryScreen() == hs.screen.mainScreen() then
			hs.eventtap.keyStroke({ "ctrl", "alt" }, num)
		else
			hs.eventtap.keyStroke({ "ctrl", "cmd" }, num)
		end
	end
end

bind(hyper, "1", switch_to_space("1"))
bind(hyper, "2", switch_to_space("2"))
bind(hyper, "3", switch_to_space("3"))
bind(hyper, "4", switch_to_space("4"))
bind(hyper, "5", switch_to_space("5"))
bind(hyper, "6", switch_to_space("6"))
bind(hyper, "7", switch_to_space("7"))
bind(hyper, "8", switch_to_space("8"))
bind(hyper, "9", switch_to_space("9"))

-- # move window to space #
local function move_window(space_num)
	return function()
		local focusedWindow = hs.window.focusedWindow()
		hs.spaces.moveWindowToSpace(focusedWindow, hs.spaces.spacesForScreen()[tonumber(space_num)])
		switch_to_space(space_num)
		focusedWindow:focus()
	end
end

bind(shiftHyper, "1", move_window("1"))
bind(shiftHyper, "2", move_window("2"))
bind(shiftHyper, "3", move_window("3"))
bind(shiftHyper, "4", move_window("4"))
bind(shiftHyper, "5", move_window("5"))
bind(shiftHyper, "6", move_window("6"))
bind(shiftHyper, "7", move_window("7"))
bind(shiftHyper, "8", move_window("8"))
bind(shiftHyper, "9", move_window("9"))

bind(hyper, "q", yabai({ "--stop-service" }))
bind(shiftHyper, "q", yabai({ "--start-service" }))

-- Toggle whether a window is split vertically or horizontally
bind(hyper, "s", yabai({ "-m", "window", "--toggle", "split" }))

-- Move window to a different screen
bind(hyper, "Tab", yabai({ "-m", "window", "--display", "next" }))
