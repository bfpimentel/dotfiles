local P = require("utils.pack")

P.add({
  {
    src = "https://github.com/folke/sidekick.nvim",
    data = {
      init = function(_)
        ---@class sidekick.Config
        local config = {
          mux = { enabled = false },
        }

        require("sidekick").setup(config)
      end,
      keys = function()
        local SidekickCLI = require("sidekick.cli")

        return {
          -- {
          --   "<Tab>",
          --   function()
          --     vim.notify("[I] Trying to Tab")
          --
          --     if vim.lsp.inline_completion.get() then
          --       vim.notify("[I] Selected Inline Completion")
          --       return
          --     end
          --
          --     -- Fallback to normal tab
          --     vim.notify("[I] Fallback to normal <Tab>")
          --     return "<Tab>"
          --   end,
          --   mode = { "i" },
          --   { desc = "Goto/Apply Next Edit Suggestion", expr = true },
          -- },
          -- {
          --   "<Tab>",
          --   function()
          --     vim.notify("[N] Trying to Tab")
          --
          --     if require("sidekick").nes_jump_or_apply() then
          --       vim.notify("[N] Jumped/Applied NES")
          --       return
          --     end
          --
          --     vim.notify("[N] Fallback to normal <Tab>")
          --     return "<Tab>"
          --   end,
          --   mode = { "n" },
          --   { desc = "Goto/Apply Next Edit Suggestion", expr = true },
          -- },
          {
            "<C-.>",
            function() SidekickCLI.focus() end,
            mode = { "n", "x", "i", "t" },
            { desc = "Sidekick Switch Focus" },
          },
          {
            "<Leader>aa",
            function() SidekickCLI.toggle({ focus = true, name = "copilot" }) end,
            mode = { "n", "v" },
            { desc = "Sidekick Toggle CLI" },
          },
          {
            "<Leader>ap",
            function() SidekickCLI.prompt() end,
            mode = { "n", "v" },
            { desc = "Sidekick Ask Prompt" },
          },
        }
      end,
    },
  },
})
