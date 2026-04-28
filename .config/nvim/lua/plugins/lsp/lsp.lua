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

vim.lsp.enable("nil_ls")

return {
	{
		-- lspconfig provides base configs (cmd, filetypes, root_markers) for servers
		"neovim/nvim-lspconfig",
	},
	{
		-- Global LSP settings: diagnostics, capabilities, keybindings
		name = "lsp",
		dir = vim.fn.stdpath("config"),
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
		config = function()
			vim.opt.updatetime = 50

			vim.diagnostic.config({
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
			})

			local has_blink, blink_cmp = pcall(require, "blink.cmp")
			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					{},
					vim.lsp.protocol.make_client_capabilities(),
					has_blink and blink_cmp.get_lsp_capabilities() or {}
				),
			})

			M.on_attach(require("keybindings").set_lsp)
			M.on_attach(function(_, buffer)
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end)
			---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
			local progress = vim.defaulttable()
			vim.api.nvim_create_autocmd("LspProgress", {
				---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
					if not client or type(value) ~= "table" then
						return
					end
					local p = progress[client.id]

					for i = 1, #p + 1 do
						if i == #p + 1 or p[i].token == ev.data.params.token then
							p[i] = {
								token = ev.data.params.token,
								msg = ("[%3d%%] %s%s"):format(
									value.kind == "end" and 100 or value.percentage or 100,
									value.title or "",
									value.message and (" **%s**"):format(value.message) or ""
								),
								done = value.kind == "end",
							}
							break
						end
					end

					local msg = {} ---@type string[]
					progress[client.id] = vim.tbl_filter(function(v)
						return table.insert(msg, v.msg) or not v.done
					end, p)

					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(table.concat(msg, "\n"), "info", {
						id = "lsp_progress",
						title = client.name,
						opts = function(notif)
							notif.icon = #progress[client.id] == 0 and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			})
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
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
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		event = "LspAttach",
		opts = {
			backend = "delta",
			picker = {
				"buffer",
				opts = {
					hotkeys = true,
					auto_preview = true,
					auto_accept = true,
					hotkeys_mode = function(titles)
						local t = {}
						for i = 1, #titles do
							t[i] = tostring(i)
						end
						return t
					end,
				},
			},
		},
		init = function()
			M.on_attach(function(_, buffer)
				local opts = { buf = buffer, silent = true }
				vim.keymap.set({ "n", "x" }, "<leader>ca", function()
					require("tiny-code-action").code_action({})
				end, opts)
			end)
		end,
	},
}
