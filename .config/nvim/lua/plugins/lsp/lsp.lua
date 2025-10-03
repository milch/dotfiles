local M = {}

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
	return vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and (not name or client.name == name) then
				return on_attach(client, buffer)
			end
		end,
	})
end

M.diagnosticsIcons = {
	error = "",
	warn = "",
	hint = "",
	info = "",
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		init = function()
			vim.opt.updatetime = 50
		end,
		opts = {
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				virtual_text = false,
				severity_sort = true,
				float = {
					source = true,
				},
				update_in_insert = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = M.diagnosticsIcons.error,
						[vim.diagnostic.severity.WARN] = M.diagnosticsIcons.warn,
						[vim.diagnostic.severity.HINT] = M.diagnosticsIcons.hint,
						[vim.diagnostic.severity.INFO] = M.diagnosticsIcons.info,
					},
				},
			},
			servers = {},
			---@type table<string, fun(server:string, opts:lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
			},
		},
		config = function(_, opts)
			if type(opts.diagnostics.signs) ~= "boolean" then
				for severity, icon in pairs(opts.diagnostics.signs.text) do
					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
					name = "DiagnosticSign" .. name
					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
				end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_blink, blink_cmp = pcall(require, "blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_blink and blink_cmp.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)

			vim.lsp.config("*", { capabilities = capabilities })

			-- get all the servers that are available through mason-lspconfig
			local mason_all = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
			local mason_exclude = {} ---@type string[]

			local function configure(server)
				local server_opts = servers[server] or { enabled = false }
				if server_opts.enabled == false or server_opts.mason == false then
					mason_exclude[#mason_exclude + 1] = server
					return
				end

				local use_mason = server_opts.mason ~= false and vim.tbl_contains(mason_all, server)
				local setup = opts.setup[server] or opts.setup["*"]
				if setup and setup(server, server_opts) then
					mason_exclude[#mason_exclude + 1] = server
				else
					vim.lsp.config(server, server_opts) -- configure the server
					if not use_mason then
						vim.lsp.enable(server)
						return false
					end
				end
				return use_mason
			end

			local ensure_installed = vim.tbl_filter(configure, vim.tbl_keys(servers))
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_enable = { exclude = mason_exclude },
			})

			M.on_attach(require("keybindings").set_lsp)
			M.on_attach(function(_, buffer)
				-- Enable inlay hints by default
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end)
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000, -- needs to be loaded in first
		opts = {
			hi = {
				background = "None",
			},
			options = {
				show_source = {
					if_many = true,
				},
				use_icons_from_diagnostic = true,
				multilines = {
					enabled = true,
					always_show = true,
				},
				show_all_diags_on_cursor_line = true,
				enable_on_insert = true,
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- Installed through nix
			servers = { nil_ls = { mason = false } },
		},
	},
}
