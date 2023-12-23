local builtin = require("statuscol.builtin")

require("statuscol").setup({
	relculright = true,
	segments = {
		-- Fold
		{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
		-- Sign
		{ text = { "%s" }, click = "v:lua.ScSa" },
		-- Line numbers
		{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
	},
})
