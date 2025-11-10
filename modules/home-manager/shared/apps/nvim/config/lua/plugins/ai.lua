local P = require("utils.pack")

local notify_for_debug = false

P.add({
  {
    src = "https://github.com/folke/sidekick.nvim",
    data = {
      init = function(_)
        ---@class sidekick.Config
        local config = {
          nes = { enabled = false },
          cli = { mux = { enabled = true, backend = "zellij" } },
        }

        require("sidekick").setup(config)
      end,
      keys = function()
        local SidekickCLI = require("sidekick.cli")

        return {
          {
            "<Tab>",
            function()
              if notify_for_debug then vim.notify("[I/N] Trying to Tab") end

              if require("sidekick").nes_jump_or_apply() then
                if notify_for_debug then vim.notify("[N] Jumped/Applied NES") end
                return
              end

              if not vim.lsp.inline_completion.get() then
                if notify_for_debug then vim.notify("[I/N] Fallback to normal <Tab>") end
                return "<Tab>"
              end
            end,
            mode = { "i", "n" },
            { expr = true, desc = "Goto/Apply Next Edit Suggestion" },
          },
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
