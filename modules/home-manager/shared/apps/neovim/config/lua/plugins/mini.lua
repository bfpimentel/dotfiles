local P = require("utils.pack")

P.add({
  {
    src = "https://github.com/nvim-mini/mini.nvim",
    version = nil,
    data = {
      init = function(_)
        require("mini.ai").setup()
        require("mini.surround").setup()
        require("mini.icons").setup()
        require("mini.visits").setup()
        require("mini.diff").setup()

        local MiniFiles = require("mini.files")
        local MiniClue = require("mini.clue")
        local MiniStatusline = require("mini.statusline")
        local MiniHipatterns = require("mini.hipatterns")
        local MiniIndentScope = require("mini.indentscope")
        local Mini2D = require("mini.jump2d")
        local MiniNotify = require("mini.notify")
        local MiniPick = require("mini.pick")
        local MiniCompletion = require("mini.completion")

        MiniNotify.setup()
        vim.notify = MiniNotify.make_notify()

        MiniPick.setup()
        vim.ui.select = MiniPick.ui_select

        MiniFiles.setup({
          windows = {
            max_number = 3,
            preview = true,
            width_focus = 40,
            width_nofocus = 20,
            width_preview = 50,
          },
        })

        MiniIndentScope.setup({
          symbol = "│",
        })

        Mini2D.setup({
          view = {
            dim = true,
          },
          allowed_windows = {
            current = true,
            not_current = false,
          },
        })

        MiniCompletion.setup({
          delay = { completion = 100, info = 100, signature = 50 },
          source = {
            nvim_lsp = true,
            buffer = true,
            path = true,
            luasnip = true,
          },
        })

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

        MiniHipatterns.setup({
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
        })

        MiniClue.setup({
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
        })

        local check_macro_recording = function()
          if vim.fn.reg_recording() ~= "" then
            return "Recording @" .. vim.fn.reg_recording()
          else
            return ""
          end
        end

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

        MiniStatusline.setup({
          content = {
            active = groups,
            inactive = nil,
          },
        })
      end,
      keys = function()
        local MiniPick = require("mini.pick")
        local MiniExtra = require("mini.extra")
        local MiniNotify = require("mini.notify")
        local MiniFiles = require("mini.files")
        local MiniDiff = require("mini.diff")

        local function toggle_files()
          local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
        end

        local function filter_visits(path_data)
          local is_folder = vim.fn.isdirectory(path_data.path) == 1
          local is_current_buffer = path_data.path == vim.api.nvim_buf_get_name(0)
          return not is_folder and not is_current_buffer
        end

        return {
          -- stylua: ignore start
          { "<Leader>,",  function() MiniPick.builtin.buffers() end, opts = { desc = "Buffers" } },
          { "<Leader>/",  function() MiniPick.builtin.grep_live() end, opts = { desc = "Grep" } },
          -- History
          { "<Leader>hc", function() MiniExtra.pickers.history({ scope = ":" }) end, opts = { desc = "Commands History" } },
          { "<Leader>hs", function() MiniExtra.pickers.history({ scope = "/" }) end, opts = { desc = "Search History" } },
          { "<Leader>hn", function() MiniNotify.show_history() end, opts = { desc = "Notification History" } },
          -- Files
          { "<Leader>fp", function() MiniPick.builtin.files() end, opts = { desc = "Files" } },
          { "<Leader>fc", function() MiniPick.builtin.files({ source = { cwd = vim.fn.stdpath("config") } }) end, opts = { desc = "Config Files" } },
          { "<Leader>fr", function() MiniExtra.pickers.visit_paths({ cwd = nil, recency_weight = 1, filter = filter_visits }) end, opts = { desc = "Recent Files" } },
          -- Search
          { "<Leader>sh", function() MiniPick.builtin.help() end, opts = { desc = "Help Pages" } },
          { '<Leader>s"', function() MiniExtra.pickers.registers() end, opts = { desc = "Registers" } },
          { "<Leader>sb", function() MiniExtra.pickers.buf_lines() end, opts = { desc = "Buffer Lines" } },
          { "<Leader>sc", function() MiniExtra.pickers.commands() end, opts = { desc = "Commands" } },
          { "<Leader>sd", function() MiniExtra.pickers.diagnostic() end, opts = { desc = "Diagnostics" } },
          { "<Leader>sD", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, opts = { desc = "Buffer Diagnostics" } },
          { "<Leader>sH", function() MiniExtra.pickers.hl_groups() end, opts = { desc = "Highlight Groups" } },
          { "<Leader>sk", function() MiniExtra.pickers.keymaps() end, opts = { desc = "Keymaps" } },
          { "<Leader>sm", function() MiniExtra.pickers.marks() end, opts = { desc = "Marks" } },
          { "<Leader>sC", function() MiniExtra.pickers.colorschemes() end, opts = { desc = "Colorschemes" } },
          -- LSP
          { "<Leader>gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, opts = { desc = "Declarations" } },
          { "<Leader>gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, opts = { desc = "Definitions" } },
          { "<Leader>gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, opts = { desc = "References" } },
          { "<Leader>gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, opts = { desc = "Implementation" } },
          { "<Leader>gy", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, opts = { desc = "Type Definition" } },
          { "<Leader>gs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, opts = { desc = "Symbols" } },
          { "<Leader>gS", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, opts = { desc = "Workspace Symbols" } },
          { "<Leader>gh", function() MiniDiff.toggle_overlay(0) end, opts = { desc = "Show Diff" } },
          -- Explorer
          { "<Leader>e",  function() toggle_files() end, opts = { desc = "File Explorer" } },
          -- stylua: ignore end
        }
      end,
    },
  },
})
