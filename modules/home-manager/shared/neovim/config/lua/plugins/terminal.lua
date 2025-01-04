return {
	"akinsho/toggleterm.nvim",
	version = "*",
	lazy = true,
	config = true,
	opts = {
		direction = "float",
	},
	keys = {
		{ "<c-t>", '<cmd>exe v:count1 . "ToggleTerm"<cr>' },
	},
}
