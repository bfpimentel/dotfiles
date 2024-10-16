return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = true,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"typescript",
				"c",
				"lua",
				"nix",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",
			},
			sync_install = false,
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
		})
	end,
}
