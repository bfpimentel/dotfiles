return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ahmedkhalf/project.nvim",
	},
	lazy = true,
	keys = {
		{ "<leader>fp", "<cmd>Telescope find_files<cr>", mode = "n", desc = "[F]ind [P]roject files" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", mode = "n", desc = "[F]ind [G]it files" },
		{ "<leader>fi", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "[F]ind [I]n files" },
		{ "<leader>rp", "<cmd>Telescope projects<cr>", mode = "n", desc = "Show [R]ecent [P]rojects" },
	},
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern" },
			patterns = { ".git" },
		})

		local telescope = require("telescope")
		telescope.load_extension("projects")
		telescope.setup({
			path_display = { "shorten" },
		})
	end,
}
