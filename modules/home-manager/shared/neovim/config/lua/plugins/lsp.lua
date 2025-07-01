local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ source = "esmuellert/nvim-eslint" })

now(function()
  local Eslint = require("nvim-eslint")
  local Blink = require("blink.cmp")

  local capabilities = Eslint.make_client_capabilities()
  capabilities = Blink.get_lsp_capabilities(capabilities)

  Eslint.setup({
    capabilities = capabilities,
    settings = {
      useFlatConfig = true,
      workingDirectory = { mode = "location" },
    },
  })
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
