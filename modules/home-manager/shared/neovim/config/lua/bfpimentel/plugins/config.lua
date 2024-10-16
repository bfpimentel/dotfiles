return {
	-- Theme Config
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},

	-- Which Key Config
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		keys = {
			{ "U", "<cmd>redo<cr>" },
		},
		opts = {},
	},

	-- Mini Deps
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

	-- Statusline Config
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},

	-- Toggle Term Config
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		opts = {
			direction = "float",
		},
		keys = {
			{ "<c-t>", '<cmd>exe v:count1 . "ToggleTerm"<cr>' },
		},
	},

	-- File Tree Config
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					position = "right",
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
					},
					follow_current_file = {
						leave_dirs_open = true,
						enabled = true,
					},
				},
			})
		end,
		keys = {
			{
				"<leader>ns",
				":Neotree toggle=true source=filesystem action=focus<CR>",
				mode = "n",
				desc = "[N]eotree [S]how",
			},
		},
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.stylua.setup({
				capabilities = capabilities,
			})

			lspconfig.bashls.setup({
				capabilities = capabilities,
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.nil_ls.setup({
				capabilities = capabilities,
				settings = {
					nil_ls = { formatter = { command = "nixfmt" } },
				},
			})

			vim.keymap.set("n", "<leader>sh", vim.lsp.buf.hover, { desc = "[S]how [H]over Info" })
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.definition, { desc = "[G]o to [I]mplementation" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "[G]o to [R]eferences" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
		end,
	},

	-- Formatting Config
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat [F]ile",
			},
		},
		opts = {
			formatters_by_ft = {
				-- ["*"] = { "codespell", "trim_whitespace" },
				lua = { "stylua" },
				sh = { "bashls" },
				yaml = { "yamlls" },
				nix = { "nixfmt" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
			},
		},
	},

	-- Completions Config
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = false,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Git Config
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	-- Code Highlighting Config
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
				dim = false,
			})
		end,
	},

	-- Telescope Config
	{
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
	},

	-- Treesitter Config
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
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
	},
}
