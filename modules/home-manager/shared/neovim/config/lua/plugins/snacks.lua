local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ source = "folke/snacks.nvim" })

now(function()
  local Snacks = require("snacks")
  Snacks.setup({
    bigfile = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },

    -- Disable everything else
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    git = { enabled = false },
    quickfile = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false },
  })
end)

now(function()
  local Snacks = require("snacks")

  local map = vim.keymap.set
  -- stylua: ignore start
  map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  map("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
  map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Show Notification History" })
  map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<leader>rN", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  map("n", "<C-t>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
  -- stylua: ignore end
end)

later(function()
  local Snacks = require("snacks")

  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...) Snacks.debug.inspect(...) end
      _G.bt = function() Snacks.debug.backtrace() end
      vim.print = _G.dd -- Override print to use snacks for `:=` command

      -- Create some toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
      Snacks.toggle.inlay_hints():map("<leader>uh")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.dim():map("<leader>uD")
    end,
  })
end)

now(function()
  local Snacks = require("snacks")

  Snacks.opts = {
    ---@class snacks.lazygit.Config
    lazygit = {
      configure = true,
    },
  }
end)

now(function()
  local Snacks = require("snacks")

  Snacks.opts = {
    ---@class snacks.notification.Config
    notification = {},
    styles = {
      notification = {
        border = "single",
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 5,
          wrap = true,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "snacks_notif" },
      },
    },
  }
end)

now(function()
  local Snacks = require("snacks")

  Snacks.opts = {
    ---@class snacks.picker.Config
    picker = {
      enabled = true,
      layout = {
        layout = {
          backdrop = false,
          width = 0.7,
          min_width = 40,
          height = 0.8,
          box = "vertical",
          border = "single",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", border = "bottom", height = 1 },
          { win = "list", border = "none", height = 0.3 },
          { win = "preview", border = "top", title = "{preview}" },
        },
      },
      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
            preview = "main",
            layout = {
              box = "vertical",
              border = "none",
              width = 40,
              position = "right",
              { win = "input", border = "bottom", height = 1 },
              { win = "list", border = "none" },
            },
          },
        },
      },
    },
  }

  local map = vim.keymap.set
  -- stylua: ignore start
  map( "n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" } )
  map( "n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" } )
  map( "n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" } )
  map( "n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" } )
  -- Find
  map( "n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" } )
  map( "n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" } )
  map( "n", "<leader>fp", function() Snacks.picker.files() end, { desc = "Find Files" } )
  map( "n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" } )
  map( "n", "<leader>fP", function() Snacks.picker.projects() end, { desc = "Projects" } )
  map( "n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" } )
  map( "n", "<leader>fC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" } )
  -- Grep
  map( "n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" } )
  map( "n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" } )
  -- Search
  map( "n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" } )
  map( "n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" } )
  map( "n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" } )
  map( "n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" } )
  map( "n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" } )
  map( "n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" } )
  map( "n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" } )
  map( "n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" } )
  map( "n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" } )
  map( "n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" } )
  map( "n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" } )
  map( "n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" } )
  map( "n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" } )
  map( "n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" } )
  map( "n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" } )
  -- LSP
  map( "n", "<leader>gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" } )
  map( "n", "<leader>gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" } )
  map( "n", "<leader>gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true } )
  map( "n", "<leader>gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" } )
  map( "n", "<leader>gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" } )
  map( "n", "<leader>gs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" } )
  map( "n", "<leader>gS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" } )
  -- stylua: ignore end
end)
