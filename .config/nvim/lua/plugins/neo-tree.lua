local very_first_call = true
local current_buffer = ""
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		keys = {
			{
				"-",
				function()
					current_buffer = vim.api.nvim_buf_get_name(0)
					require("neo-tree.command").execute({
						toggle = true,
						dir = vim.uv.cwd(),
						position = "float",
						reveal = very_first_call,
					})
					very_first_call = false
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,
		opts = {
			filesystem = {
				bind_to_cwd = false,
				hijack_netrw_behavior = "open_current", -- Fullscreen when opening as `nvim $FOLDER`
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						".git",
					},
					never_show = {
						".DS_Store",
					},
				},
			},
			window = {
				mappings = {
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
					["O"] = {
						function(state)
							require("lazy.util").open(state.tree:get_node().path, { system = true })
						end,
						desc = "Open with System Application",
					},
					["/"] = "filter_as_you_type",
					["f"] = function(state)
						require("neo-tree.sources.manager").navigate(state, vim.uv.cwd(), current_buffer)
					end,
				},
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.opt.relativenumber = true
						vim.opt.number = true
					end,
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	},
}
