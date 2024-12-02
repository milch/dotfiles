local Buffer = require("lualine.components.buffers.buffer")

local M = require("lualine.components.buffers.init"):extend()
local Harpoon = require("plugins.ui.lualine.harpoon")

local default_options = {
	disabled_filetypes = {},
	disabled_buftypes = { "quickfix", "prompt" },
}

M.last_pos = 1

-- TODO: always draw harpoon section

function M:init(options)
	options.buffers_color = nil -- buffers_color isn't windows option.
	M.super.init(self, options)

	self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
	self.options.windows_color =
		vim.tbl_deep_extend("keep", self.options.windows_color or {}, self.options.buffers_color)
	self.options.buffers_color = nil -- this is the default value of colors generated by parent buffers component.

	self.highlights = {
		active = self:create_hl(self.options.windows_color.active, "active"),
		inactive = self:create_hl(self.options.windows_color.inactive, "inactive"),
	}
end

---@param item HarpoonItem
---@param idx number
function M:new_buffer(item, idx)
	return Harpoon:new({
		item = item,
		harpoon_index = idx,
		options = self.options,
		highlights = self.highlights,
	})
end

function M:buffers()
	local harpoons = {}
	local coordinates = {}
	local harpoon = require("harpoon")

	for b = 1, harpoon:list():length() do
		local item = harpoon:list():get(b)
		harpoons[#harpoons + 1] = self:new_buffer(item, b)
		coordinates[#coordinates + 1] = { kind = "harpoon", harpoon_index = b }
	end

	local buffers = {}
	for idx, buf in pairs(vim.api.nvim_list_bufs()) do
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
		for harpoon_idx, h in pairs(harpoons) do
			if h.full_path == vim.api.nvim_buf_get_name(buf) then
				h.bufnr = buf
				coordinates[harpoon_idx].bufnr = buf
				goto continue
			end
		end
		if vim.fn.buflisted(buf) == 1 and buftype ~= "quickfix" then
			buffers[#buffers + 1] = Buffer:new({
				bufnr = buf,
				buf_index = idx,
				options = self.options,
				highlights = self.highlights,
			})
			coordinates[#coordinates + 1] = { kind = "buffer", bufnr = buf }
		end
		::continue::
	end

	M.coordinates = coordinates
	return vim.list_extend(harpoons, buffers)
end

function M.buffer_jump(buf_pos, bang)
	if buf_pos == "$" then
		buf_pos = #M.coordinates
	else
		buf_pos = tonumber(buf_pos)
	end
	M.last_pos = buf_pos

	if buf_pos < 1 or buf_pos > #M.coordinates then
		if bang ~= "!" then
			error("Error: Unable to jump buffer position out of range")
		else
			return
		end
	end

	local coordinate = M.coordinates[buf_pos]
	local harpoon = require("harpoon")
	if coordinate.kind == "harpoon" then
		harpoon:list():select(coordinate.harpoon_index)
	elseif coordinate.kind == "buffer" then
		vim.api.nvim_set_current_buf(coordinate.bufnr)
	else
		error("Error: unknown coordinate kind " .. coordinate.kind)
	end
end

local function move_dir(dir)
	local cur_idx = M.last_pos
	local coordinate = M.coordinates[cur_idx]
	if coordinate ~= nil and coordinate.bufnr ~= vim.fn.bufnr("%") then
		for coord_idx, coord in ipairs(M.coordinates) do
			if coord.bufnr == vim.fn.bufnr("%") then
				cur_idx = coord_idx
				break
			end
		end
	end
	cur_idx = cur_idx + dir
	if cur_idx < 1 then
		cur_idx = #M.coordinates
	end
	if cur_idx > #M.coordinates then
		cur_idx = 1
	end
	M.buffer_jump(cur_idx)
end

function M.bnext()
	move_dir(1)
end
function M.bprev()
	move_dir(-1)
end

vim.cmd([[
	function! LualineSwitchHarpoon(bufnr, mouseclicks, mousebutton, modifiers)
		execute ":lua require('plugins.ui.lualine.harpoon-component').buffer_jump(" . a:bufnr . ")"
	endfunction
]])

return M