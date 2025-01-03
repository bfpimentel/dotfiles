return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ahmedkhalf/project.nvim",
	},
	lazy = true,
	keys = {
		{ "<leader>fp", "<cmd>Telescope find_files<cr>", mode = "n", desc = "[F]ind [P]roject files", { buffer = true} },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", mode = "n", desc = "[F]ind [G]it files", { buffer = true} },
		{ "<leader>fi", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "[F]ind [I]n files", { buffer = true} },
		{ "<leader>rp", "<cmd>Telescope projects<cr>", mode = "n", desc = "Show [R]ecent [P]rojects", { buffer = true} },
	},
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern" },
			patterns = { ".git" },
		})

		local telescope = require("telescope")
		telescope.load_extension("projects")
		telescope.setup({
      defaults = {
			  path_display = { "shorten" },
      },
		})
	end,
}
