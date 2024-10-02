return {
	"tpope/vim-projectionist",
	config = function()
		vim.g.projectionist_heuristics = {
			["rails-root/Rakefile"] = {
				["rails-root/spec/*_spec.rb"] = { alternate = "rails-root/{}.rb" },
				["rails-root/*.rb"] = { alternate = "rails-root/spec/{}_spec.rb" },
			},
			Rakefile = {
				["spec/*_spec.rb"] = { alternate = "lib/{}.rb" },
				["lib/*.rb"] = { alternate = "spec/{}_spec.rb" },
			},
			["package.json"] = {
				["lib/*.ts"] = { alternate = "test/{}.test.ts" },
				["test/*.test.ts"] = { alternate = "lib/{}.ts" },
				["src/*.ts"] = { alternate = "tests/{}.test.ts" },
				["tests/*.test.ts"] = { alternate = "src/{}.ts" },
			},
			["src/*/main.go"] = {
				["*.go"] = { alternate = "{}_test.go" },
				["*_test.go"] = { alternate = "{}.go" },
			},
			["go.mod"] = {
				["*.go"] = { alternate = "{}_test.go" },
				["*_test.go"] = { alternate = "{}.go" },
			},
		}
	end,
	keys = {
		{ "<leader>so", "<cmd>Alternate<CR>", silent = true, desc = "[S]witch to [O]ther file" },
	},
}
