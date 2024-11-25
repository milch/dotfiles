local M = {}

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
	-- don't trigger on invalid buffers
	if not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	-- don't trigger on non-listed buffers
	if not vim.bo[buffer].buflisted then
		return
	end
	-- don't trigger on nofile buffers
	if vim.bo[buffer].buftype == "nofile" then
		return
	end
	for method, clients in pairs(M._supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][buffer] then
			if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
				clients[client][buffer] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					data = { client_id = client.id, buffer = buffer, method = method },
				})
			end
		end
	end
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspSupportsMethod",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end

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
		event = { "LazyFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		init = function()
			vim.opt.updatetime = 50
		end,
		opts = {
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				virtual_text = {
					source = "if_many",
				},
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
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			servers = {},
			---@type table<string, fun(server:string, opts:lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
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

			if opts.inlay_hints.enabled then
				M.on_supports_method("textDocument/inlayHint", function(_, buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if server_opts.enabled == false then
					return
				end

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local mlsp = require("mason-lspconfig")
			local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
							setup(server)
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					end
				end
			end

			mlsp.setup({
				ensure_installed = ensure_installed,
				handlers = { setup },
			})

			M.on_attach(require("keybindings").set_lsp)
			M.on_attach(M._check_methods)
		end,
	},
}
