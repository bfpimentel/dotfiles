_B.add({
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    src = "https://github.com/milanglacier/minuet-ai.nvim",
    data = {
      load = function()
        require("minuet").setup({
          throttle = 1000,
          debouce = 300,
          provider = "gemini",
          provider_options = {
            gemini = {
              model = "gemini-2.0-flash",
              optional = {
                generationConfig = {
                  maxOutputTokens = 256,
                  thinkingConfig = {
                    thinkingBudget = 0,
                  },
                },
              },
            },
          },
          lsp = {
            enabled_ft = { "lua", "typescript" },
          },
          -- virtualtext = {
          --   auto_trigger_ft = { "lua", "typescript" },
          -- },
        })
      end,
      keys = function()
        local MinuetVT = require("minuet.virtualtext")

        return {
          {
            "<Tab>",
            function()
              if MinuetVT.action.is_visible() then
                vim.defer_fn(MinuetVT.action.accept, 30)
                return
              end

              return "<Tab>"
            end,
            mode = { "i" },
            opts = { expr = true },
          },
        }
      end,
    },
  },
})
