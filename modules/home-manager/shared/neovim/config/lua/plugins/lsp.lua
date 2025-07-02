local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ source = "esmuellert/nvim-eslint" })
add({ source = "stevearc/conform.nvim" })

now(function()
  local Eslint = require("nvim-eslint")
  -- local Blink = require("blink.cmp")
  local MiniCompletion = require("mini.completion")

  local capabilities = Eslint.make_client_capabilities()
  capabilities = MiniCompletion.get_lsp_capabilities(capabilities)

  Eslint.setup({
    capabilities = capabilities,
    settings = {
      useFlatConfig = true,
      workingDirectory = { mode = "location" },
    },
  })
end)

now(function()
  local Conform = require("conform")
  Conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      nix = { "nixfmt" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },
    prettier = {
      require_cwd = true,
    },
  })

  vim.keymap.set("n", "<leader>ff", function() Conform.format({ lsp_fallback = true }) end, { desc = "Format File" })
end)

later(function()
  vim.diagnostic.config({
    virtual_lines = {
      current_line = true,
    },
    -- virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = vim.opt.winborder,
      source = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        [vim.diagnostic.severity.WARN] = "WarningMsg",
      },
    },
  })
end)
