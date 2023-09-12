local bind = vim.keymap.set
local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, silent = true }
	lsp_zero.default_keymaps(opts)

	bind("n", "<leader>rn", ":Lspsaga rename<CR>", opts)
	bind("x", "gf", ":LspZeroFormat<CR>", opts)
	bind("v", "gf", ":LspZeroFormat<CR>", opts)
	bind("n", "gf", ":LspZeroFormat<CR>", opts)
	bind("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	bind("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	bind("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	-- bind('n', 'gr', ':Lspsaga finder<CR>', opts)
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"clangd", -- C-family
		"cssls",
		"docker_compose_language_service",
		"dockerls",
		"html",
		"jdtls",
		"jedi_language_server", -- Python
		"jsonls",
		"lua_ls",             -- Lua
		"perlnavigator",
		"rust_analyzer",      -- Rust
		"solargraph",         -- Ruby
		"sqlls",
		"tsserver",
		"yamlls",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

local lua_opts = lsp_zero.nvim_lua_ls()
require("lspconfig").lua_ls.setup(lua_opts)

local diagnosticsIcons = {
	error = "",
	warn = "",
	hint = "",
	info = "",
}
lsp_zero.set_sign_icons(diagnosticsIcons)

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 1,
		source = "if_many",
		prefix = "",
	},
	severity_sort = true,
	float = {
		source = true,
	},
})
