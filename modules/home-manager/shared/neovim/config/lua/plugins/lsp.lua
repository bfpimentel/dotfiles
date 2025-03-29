return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- { "j-hui/fidget.nvim", opts = {} },
    { "saghen/blink.cmp" },
  },
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(vim.lsp.status(), "info", {
          id = "lsp_progress",
          title = "LSP Progress",
          opts = function(notif)
            notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

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
