local P = require("utils.pack")

P.add({
  -- {
  --   src = "https://github.com/NickvanDyke/opencode.nvim",
  --   data = {
  --     init = function(_)
  --       ---@type opencode.Opts
  --       require("opencode").setup({})
  --     end,
  --     keys = function()
  --       local Opencode = require("opencode")
  --
  --       return {
  --         -- stylua: ignore start
  --         { "oA", function() Opencode.ask() end, { desc = "Ask opencode" } },
  --         { "oa", function() Opencode.ask("@cursor: ") end, { desc = "Ask opencode about this" } },
  --         { "oa", function() Opencode.ask("@selection: ") end, mode = "v", { desc = "Ask opencode about selection }" } },
  --         { "ot", function() Opencode.toggle() end, { desc = "Toggle embedded opencode" } },
  --         { "on", function() Opencode.command("session_new") end, { desc = "New session" } },
  --         { "oy", function() Opencode.command("messages_copy") end, { desc = "Copy last message" } },
  --         -- { "<S-M-u>", function() require("opencode").command("messages_half_page_up") end, { desc = "Scroll messages up" } },
  --         -- { "<S-M-d>", function() require("opencode").command("messages_half_page_down") end, { desc = "Scroll messages down" } },
  --         -- stylua: ignore end
  --       }
  --     end,
  --   },
  -- },
  -- {
  --   src = "https://github.com/github/copilot.vim",
  --   data = {
  --     init = function(_) vim.g.copilot_no_tab_map = true end,
  --   },
  -- },
  {
    src = "https://github.com/folke/sidekick.nvim",
    data = {
      init = function(_) require("sidekick").setup() end,
      keys = function()
        local SidekickCLI = require("sidekick.cli")

        return {
          {
            "<tab>",
            function()
              if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end
            end,
            remove_leader = true,
            { desc = "Goto/Apply Next Edit Suggestion", expr = true },
          },
          {
            "<c-.>",
            function() SidekickCLI.focus() end,
            mode = { "n", "x", "i", "t" },
            remove_leader = true,
            { desc = "Sidekick Switch Focus" },
          },
          {
            "aa",
            function() SidekickCLI.toggle({ focus = true }) end,
            mode = { "n", "v" },
            { desc = "Sidekick Toggle CLI" },
          },
          {
            "ap",
            function() SidekickCLI.select_prompt() end,
            mode = { "n", "v" },
            { desc = "Sidekick Ask Prompt" },
          },
        }
      end,
    },
  },
})
