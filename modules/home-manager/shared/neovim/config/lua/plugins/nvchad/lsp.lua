return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local lspconfig = require "lspconfig"
    local nvlsp = require "nvchad.configs.lspconfig"

    local servers = { "bashls", "yamlls", "clangd", "html", "cssls" }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
      }
    end

    lspconfig.lua_ls.setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim",
              "use",
            }
          }
        }
      }
    }

    lspconfig.nil_ls.setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      settings = {
        nil_ls = { formatter = { command = "nixfmt" } },
      },
    }

    lspconfig.ts_ls.setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      settings = {
        ts_ls = { formatter = { command = "prettierd" } }
      }
    }
  end,
}
