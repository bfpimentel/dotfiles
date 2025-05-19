return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "saghen/blink.cmp" },
  },
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(vim.lsp.status(), 2, {
          id = "lsp_progress",
          title = "LSP Progress",
          opts = function(notif)
            notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

    local servers = {
      bashls = {},
      yamlls = {},
      clangd = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = {
                "vim",
                "use",
              }
            },
            formatter = { command = "stylua" },
          }
        },
      },
      ts_ls = {
        settings = {
          ts_ls = {
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            formatter = { command = "prettierd" },
          },
        },
      },
      tailwindcss = {
        settings = {
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
      },
      nil_ls = {
        settings = {
          nil_ls = {
            formatter = { command = "nixfmt" }
          },
        },
      }
    }

    for server_name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end
  end,
}
