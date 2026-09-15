return {
	{
		"folke/which-key.nvim",
		opts = {
			spec = { { "<leader>D", group = "Debug" } },
		},
	},
	{
		"mfussenegger/nvim-dap",
		keys = { { "<leader>Dd", desc = "Debug controls" } },
		dependencies = {
			"nvimtools/hydra.nvim",
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
		},
		config = function()
			local dap = require("dap")
			local hint = [[
				^ ^Step^ ^ ^      ^ ^     Action
				----^-^-^-^--^-^----  ^-^-------------------
				^ ^ ^ ^ ^        ^_t_: toggle breakpoint
				^ ^ ^ ^ ^         _T_: clear breakpoints
				out _H_ ^ ^ _L_ into  _c_: continue
				^ ^ _J_ ^ ^       _x_: terminate
				^ ^over ^ ^     ^^_r_: open repl

				^ ^  _q_: exit
			]]
			require("hydra")({
				name = "Debug",
				hint = hint,
				config = {
					desc = "Debug controls",
					color = "pink",
					invoke_on_body = true,
					hint = {
						type = "window",
					},
				},
				mode = { "n" },
				body = "<leader>Dd",
				heads = {
					{ "H", dap.step_out, { desc = "step out" } },
					{ "J", dap.step_over, { desc = "step over" } },
					{ "L", dap.step_into, { desc = "step into" } },
					{ "t", dap.toggle_breakpoint, { desc = "toggle breakpoint" } },
					{ "T", dap.clear_breakpoints, { desc = "clear breakpoints" } },
					{ "c", dap.continue, { desc = "continue" } },
					{ "x", dap.terminate, { desc = "terminate" } },
					{ "r", dap.repl.open, { exit = true, desc = "open repl" } },
					{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
				},
			})
			require("dapui").setup()

			local dapui = require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			local sign = vim.fn.sign_define

			sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
			sign("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
		end,
	},
}
