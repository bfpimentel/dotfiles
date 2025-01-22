return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- { "j-hui/fidget.nvim", opts = {} },
    { "saghen/blink.cmp" },
  },
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local telescopeBuiltIn = require("telescope.builtin")
        map("gd", telescopeBuiltIn.lsp_definitions, "[G]oto [D]efinition")
        map("gr", telescopeBuiltIn.lsp_references, "[G]oto [R]eferences")
        map("gi", telescopeBuiltIn.lsp_implementations, "[G]oto [I]mplementation")
        -- map("<leader>ds", telescopeBuiltIn.lsp_document_symbols, "[D]ocument [S]ymbols")
        -- map("<leader>ws", telescopeBuiltIn.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        -- map("<leader>D", telescopeBuiltIn.lsp_type_definitions, "Type [D]efinition")
        map("ga", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, "[T]oggle Inlay [H]ints")
        end
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
            formatter = { command = "prettierd" },
          },
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
