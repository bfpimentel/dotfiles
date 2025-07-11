return {
  { "echasnovski/mini.ai", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.surround", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.pairs", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.extra", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.notify", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.icons", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.bracketed", version = false, lazy = false, opts = {} },
  { "echasnovski/mini.visits", version = false, lazy = false, opts = {} },
  {
    "echasnovski/mini.indentscope",
    version = false,
    lazy = false,
    opts = {
      symbol = "│",
    },
  },
  {
    "echasnovski/mini.diff",
    version = false,
    lazy = false,
    opts = {},
    keys = function()
      local MiniDiff = require("mini.diff")
      return {
        -- stylua: ignore start
        { "<Leader>gh", MiniDiff.toggle_overlay, desc = "Toggle Diff Overlay" },
        -- stylua: ignore end
      }
    end,
  },
  {
    "echasnovski/mini.jump2d",
    version = false,
    lazy = false,
    opts = {
      view = {
        dim = true,
      },
      allowed_windows = {
        current = true,
        not_current = false,
      },
    },
  },
  {
    "echasnovski/mini.animate",
    version = false,
    lazy = false,
    opts = function()
      local MiniAnimate = require("mini.animate")

      return {
        cursor = {
          timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
      }
    end,
  },
  {
    "echasnovski/mini.animate",
    version = false,
    lazy = false,
    opts = function(_, opts)
      local MiniNotify = require("mini.notify")
      vim.notify = MiniNotify.make_notify()

      return opts
    end,
  },
  {
    "echasnovski/mini.files",
    version = false,
    lazy = false,
    opts = {
      windows = {
        max_number = 3,
        preview = true,
        width_focus = 40,
        width_nofocus = 20,
        width_preview = 50,
      },
    },
    keys = function()
      local MiniFiles = require("mini.files")

      local function toggle_files()
        local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
      end

      return {
        { "<Leader>e", toggle_files, desc = "File Explorer" },
      }
    end,
  },
  {
    "echasnovski/mini.statusline",
    version = false,
    lazy = false,
    opts = function()
      local MiniStatusline = require("mini.statusline")

      local check_macro_recording = function()
        if vim.fn.reg_recording() ~= "" then
          return "Recording @" .. vim.fn.reg_recording()
        else
          return ""
        end
      end

      -- Add it to MiniStatusline.combine_group
      local function groups()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
        local filename = vim.fn.expand("%:t")
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineModeReplace", strings = { check_macro_recording() } },
          { hl = "MiniStatuslineFilename", strings = { fileinfo } },
          { hl = mode_hl, strings = search ~= "" and { " " .. search } },
          { hl = "MiniStatuslineModeReplace", strings = { location } },
        })
      end

      return {
        content = {
          active = groups,
          inactive = nil,
        },
      }
    end,
  },
  {
    "echasnovski/mini.clue",
    version = false,
    lazy = false,
    opts = function()
      local MiniClue = require("mini.clue")

      return {
        clues = {
          MiniClue.gen_clues.g(),
          MiniClue.gen_clues.windows(),
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },
        },
      }
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    version = false,
    lazy = false,
    opts = function()
      local MiniHipatterns = require("mini.hipatterns")

      local zero_x_colors = function(_, match)
        local len = string.len(match)
        if len == 8 or len == 10 then
          local start = len == 8 and 3 or 5
          local eend = len == 8 and 8 or 10
          local hex = string.format("#%s", match:sub(start, eend))
          return MiniHipatterns.compute_hex_color_group(hex, "bg")
        end

        return false
      end

      local hex_colors = function(_, match)
        local len = string.len(match)
        if len == 7 or len == 9 then
          local hex = string.format("#%s", match:sub(2, 7))
          return MiniHipatterns.compute_hex_color_group(hex, "bg")
        end

        return false
      end

      return {
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          zero_x_colors = {
            pattern = "0x%x+",
            group = zero_x_colors,
          },
          hex_colors = {
            pattern = "#%x+",
            group = hex_colors,
          },
        },
      }
    end,
  },
  {
    "echasnovski/mini.pick",
    version = false,
    dependencies = {
      "echasnovski/mini.extra",
      "echasnovski/mini.notify",
      "echasnovski/mini.icons",
    },
    lazy = false,
    opts = function(_, opts)
      local MiniPick = require("mini.pick")

      vim.ui.select = MiniPick.ui_select

      return opts
    end,
    keys = function()
      local MiniPick = require("mini.pick")
      local MiniExtra = require("mini.extra")
      local MiniNotify = require("mini.notify")

      return {
        -- stylua: ignore start
        { "<leader>,", function() MiniPick.builtin.buffers() end, desc = "Buffers" },
        { "<leader>/", function() MiniPick.builtin.grep_live() end, desc = "Grep" },
        { "<leader>hc", function() MiniExtra.pickers.history({ scope = ":" }) end, desc = "Commands History" },
        { "<leader>hs", function() MiniExtra.pickers.history({ scope = "/" }) end, desc = "Commands History" },
        { "<leader>hn", function() MiniNotify.show_history() end, desc = "Notification History" },
        { "<leader>fc", function() MiniPick.builtin.files({ source = { cwd = vim.fn.stdpath("config") } }) end, desc = "Find Config File" },
        { "<leader>fp", function() MiniPick.builtin.files() end, desc = "Find Files" },
        { "<leader>fr", function() MiniExtra.pickers.visit_paths({ recency_weight = 1  }) end, desc = "Recent" },
        { "<leader>sh", function() MiniPick.builtin.help() end, desc = "Help Pages" },
        { '<leader>s"', function() MiniExtra.pickers.registers() end, desc = "Registers" },
        { "<leader>sb", function() MiniExtra.pickers.buf_lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() MiniExtra.pickers.commands() end, desc = "Commands" },
        { "<leader>sd", function() MiniExtra.pickers.diagnostic() end, desc = "Diagnostics" },
        { "<leader>sD", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, desc = "Buffer Diagnostics" },
        { "<leader>sH", function() MiniExtra.pickers.hl_groups() end, desc = "Highlight Groups" },
        { "<leader>sk", function() MiniExtra.pickers.keymaps() end, desc = "Keymaps" },
        { "<leader>sm", function() MiniExtra.pickers.marks() end, desc = "Marks" },
        { "<leader>sC", function() MiniExtra.pickers.colorschemes() end, desc = "Colorschemes" },
        { "<leader>gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, desc = "Declarations" },
        { "<leader>gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, desc = "Definitions" },
        { "<leader>gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, desc = "References", nowait = true },
        { "<leader>gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, desc = "Implementation" },
        { "<leader>gy", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, desc = "Type Definition" },
        { "<leader>gs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, desc = "Symbols" },
        { "<leader>gS", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, desc = "Workspace Symbols" },
        -- stylua: ignore end
      }
    end,
  },
}
