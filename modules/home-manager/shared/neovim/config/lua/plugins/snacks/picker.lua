return {
  "snacks.nvim",
  opts = {
    picker = {
      enabled = true,
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right"
            },
          },
        },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end,            desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n",       function() Snacks.picker.notifications() end,   desc = "Notification History" },
    { "<leader>e",       function() Snacks.explorer() end,               desc = "File Explorer" },
    -- Find
    { "<leader>fb",      function() Snacks.picker.buffers() end,         desc = "Buffers" },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File"
    },
    { "<leader>fp", function() Snacks.picker.files() end,                 desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end,             desc = "Find Git Files" },
    { "<leader>fP", function() Snacks.picker.projects() end,              desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end,                desc = "Recent" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end,          desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end,                  desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end,             desc = "Visual selection or word", mode = { "n", "x" } },
    -- Search
    { '<leader>s"', function() Snacks.picker.registers() end,             desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end,        desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end,       desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end,              desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end,                  desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end,            desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end,                 desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end,                 desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end,               desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end,                 desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end,                   desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end,                  desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end,                desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end,                  desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
    -- LSP
    { "<leader>gd", function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "<leader>gD", function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "<leader>gr", function() Snacks.picker.lsp_references() end,        desc = "References",               nowait = true },
    { "<leader>gI", function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "<leader>gy", function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
    { "<leader>gs", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>gS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
