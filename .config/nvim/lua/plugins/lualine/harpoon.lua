local M = require("lualine.components.buffers.buffer"):extend()

---initialize a new buffer from opts
---@param opts { item: HarpoonItem, harpoon_index: number, bufnr: number }
function M:init(opts)
	opts.bufnr = 0
	self.item = opts.item
	self.harpoon_index = opts.harpoon_index
	self.full_path = self.item and vim.fs.joinpath(vim.uv.cwd(), self.item.value) or ""

	M.super.init(self, opts)
end

function M:name()
	local basename = vim.fs.basename(self.item.value)
	return basename:gsub("([^%.])%.[^%.]*$", "%1")
end

function M:get_props()
	-- No buffer loaded for this yet
	if self.bufnr == 0 then
		self.file = ""
		self.buftype = ""
		self.filetype = ""
		self.modified_icon = ""
		self.alternate_file_icon = ""
		self.icon = require("mini.icons").get("file", self.full_path) .. " "
	else
		M.super.get_props(self)
	end
end

function M:render()
	if not self.item then
		self.len = 0
		return " "
	end
	return M.super.render(self)
end

function M:is_current()
	if not self.item then
		return true
	end
	return vim.api.nvim_buf_get_name(0) == self.full_path
end

local pin = "􀽋 "
local superscript = {
	"¹",
	"²",
	"³",
	"⁴",
	"⁵",
	"⁶",
	"⁷",
	"⁸",
	"⁹",
}
function M:apply_mode(name)
	-- 0: Shows buffer name
	-- 1: Shows buffer index
	-- 2: Shows buffer name + buffer index
	-- 3: Shows buffer number
	-- 4: Shows buffer name + buffer number
	local idx_key = superscript[self.harpoon_index]
	if self.options.mode == 0 then
		return string.format("%s%s %s%s%s", pin, idx_key, self.icon, name, self.modified_icon)
	end

	if self.options.mode == 1 then
		return string.format("%s %s%s", self.harpoon_index, self.icon, self.modified_icon)
	end

	return string.format("%s %s%s%s", self.harpoon_index, self.icon, name, self.modified_icon)
end

function M:configure_mouse_click(name)
	return string.format("%%%s@LualineSwitchHarpoon@%s%%T", self.harpoon_index, name)
end

return M
