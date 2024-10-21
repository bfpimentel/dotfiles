return {
	{
		"echasnovski/mini.surround",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.indentscope",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.pairs",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini-git",
		main = "mini.git",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.diff",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.bracketed",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.move",
		lazy = false,
		version = false,
		opts = {
			options = { reindent_linewise = true },
			mappings = {
				-- Visual mode
				left = "",
				right = "",
				down = "<C-S-j>",
				up = "<C-S-k>",

				-- Normal mode
				line_left = "",
				line_right = "",
        line_down = "<C-S-j>",
				line_up = "<C-S-k>",
			},
		},
	},
	{
		"echasnovski/mini.icons",
		lazy = false,
		version = false,
		specs = { { "nvim-tree/nvim-web-devicons", enabled = false, optional = true } },
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
