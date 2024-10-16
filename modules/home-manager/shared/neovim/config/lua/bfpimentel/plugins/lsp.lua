return {
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
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()

			vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "[R]e[n]ame" })
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

}
