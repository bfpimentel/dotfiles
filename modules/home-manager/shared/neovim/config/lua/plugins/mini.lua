local now = MiniDeps.now

now(function()
  require("mini.ai").setup()
  require("mini.surround").setup()
  require("mini.pairs").setup()
  require("mini.pick").setup()
  require("mini.icons").setup()
  require("mini.bracketed").setup()
  require("mini.visits").setup()
end)

now(function()
  local MiniIndentScope = require("mini.indentscope")
  MiniIndentScope.setup({
    symbol = "│",
  })
end)

now(function()
  local MiniSnippets = require("mini.snippets")
  local MiniCompletion = require("mini.completion")
  local gen_loader = MiniSnippets.gen_loader

  MiniSnippets.setup({
    snippets = { gen_loader.from_lang() },
  })

  MiniCompletion.setup({
    window = {
      info = { border = "single" },
      signature = { border = "single" },
    },
  })
end)

now(function()
  local MiniDiff = require("mini.diff")
  MiniDiff.setup()

  vim.keymap.set("n", "<leader>gh", MiniDiff.toggle_overlay)
end)

now(function()
  local MiniJump2D = require("mini.jump2d")
  MiniJump2D.setup({
    view = {
      dim = true,
    },
    allowed_windows = {
      current = true,
      not_current = false,
    },
  })
end)

now(function()
  local MiniAnimate = require("mini.animate")
  MiniAnimate.setup({
    cursor = {
      timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
    },
    scroll = {
      timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
    },
  })
end)

now(function()
  local MiniNotify = require("mini.notify")
  MiniNotify.setup()

  vim.notify = MiniNotify.make_notify()
end)

now(function()
  local MiniFiles = require("mini.files")
  MiniFiles.setup({
    windows = {
      max_number = 3,
      preview = true,
      width_focus = 40,
      width_nofocus = 20,
      width_preview = 50,
    },
  })

  vim.keymap.set("n", "<leader>e", function()
    local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
  end, { desc = "File Explorer" })
end)

now(function()
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

  MiniStatusline.setup({
    content = {
      active = groups,
      inactive = nil,
    },
  })
end)

now(function()
  local MiniClue = require("mini.clue")

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
end)

now(function()
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
      local start = len == 7 and 2 or 4
      local eend = len == 7 and 7 or 9
      local hex = string.format("#%s", match:sub(start, eend))
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
end)

now(function()
  local MiniPick = require("mini.pick")
  local MiniExtra = require("mini.extra")
  local MiniNotify = require("mini.notify")

  vim.ui.select = MiniPick.ui_select

  local map = vim.keymap.set
  -- stylua: ignore start
  map( "n", "<leader>,", function() MiniPick.builtin.buffers() end, { desc = "Buffers" } )
  map( "n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Grep" } )
  -- History
  map( "n", "<leader>hc", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "Commands History" } )
  map( "n", "<leader>hs", function() MiniExtra.pickers.history({ scope = "/" }) end, { desc = "Commands History" } )
  map( "n", "<leader>hn", function() MiniNotify.show_history() end, { desc = "Notification History" } )
  -- Find
  map( "n", "<leader>fc", function() MiniPick.builtin.files({ source = { cwd = vim.fn.stdpath("config") } }) end, { desc = "Find Config File" } )
  map( "n", "<leader>fp", function() MiniPick.builtin.files() end, { desc = "Find Files" } )
  map( "n", "<leader>fr", function() MiniExtra.pickers.visit_paths({ recency_weight = 1  }) end, { desc = "Recent" } )
  -- Search
  map( "n", "<leader>sh", function() MiniPick.builtin.help() end, { desc = "Help Pages" } )
  map( "n", '<leader>s"', function() MiniExtra.pickers.registers() end, { desc = "Registers" } )
  map( "n", "<leader>sb", function() MiniExtra.pickers.buf_lines() end, { desc = "Buffer Lines" } )
  map( "n", "<leader>sc", function() MiniExtra.pickers.commands() end, { desc = "Commands" } )
  map( "n", "<leader>sd", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics" } )
  map( "n", "<leader>sD", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, { desc = "Buffer Diagnostics" } )
  map( "n", "<leader>sH", function() MiniExtra.pickers.hl_groups() end, { desc = "Highlight Groups" } )
  map( "n", "<leader>sk", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" } )
  map( "n", "<leader>sm", function() MiniExtra.pickers.marks() end, { desc = "Marks" } )
  map( "n", "<leader>sC", function() MiniExtra.pickers.colorschemes() end, { desc = "Colorschemes" } )
  -- LSP
  map( "n", "<leader>gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, { desc = "Declarations" } )
  map( "n", "<leader>gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, { desc = "Definitions" } )
  map( "n", "<leader>gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, { desc = "References", nowait = true } )
  map( "n", "<leader>gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, { desc = "Implementation" } )
  map( "n", "<leader>gy", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, { desc = "Type Definition" } )
  map( "n", "<leader>gs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, { desc = "Symbols" } )
  map( "n", "<leader>gS", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, { desc = "Workspace Symbols" } )
  -- stylua: ignore end
end)
