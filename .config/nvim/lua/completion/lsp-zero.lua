local bind = vim.keymap.set
local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, silent = true }
	lsp_zero.default_keymaps(opts)

	bind("x", "gf", ":LspZeroFormat<CR>", opts)
	bind("v", "gf", ":LspZeroFormat<CR>", opts)
	bind("n", "gf", ":LspZeroFormat<CR>", opts)

	bind("n", "<leader>rn", ":Lspsaga rename<CR>", opts)
	bind("n", "gd", ":Lspsaga goto_definition<CR>", opts)
	bind("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	bind("n", "[n", ":Lspsaga diagnostic_jump_next<CR>", opts)
	bind("n", "[p", ":Lspsaga diagnostic_jump_prev<CR>", opts)
	bind("n", "<leader>a", ":Lspsaga code_action<CR>", opts)
	bind("n", "K", ":Lspsaga hover_doc<CR>", opts)
	bind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	bind("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	bind("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"clangd", -- C-family
		"cssls",
		"docker_compose_language_service",
		"dockerls",
		"gopls",
		"html",
		"jdtls",
		"jedi_language_server", -- Python
		"jsonls",
		"smithy_ls",
		"lua_ls", -- Lua
		"perlnavigator",
		"rust_analyzer", -- Rust
		"solargraph", -- Ruby
		"sqlls",
		"tailwindcss",
		"tsserver",
		"yamlls",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

local lua_opts = lsp_zero.nvim_lua_ls()
require("lspconfig").lua_ls.setup(lua_opts)
require("lspconfig").tailwindcss.setup({
	init_options = {
		userLanguages = {
			-- Support completions in hugo html templates
			htmlhugo = "html",
			-- Defaults: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss
			eelixir = "html-eex",
			eruby = "erb",
		},
	},
})

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

-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({ capabilities = capabilities })
