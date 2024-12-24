return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle" },
  enable = true,
  lazy = false,
  opts = function()
    local opts = require("nvchad.configs.nvimtree")
    opts.view.side = "right"
    opts.view.width = 40
    -- opts.actions.change_dir.enable = false
    opts.renderer.icons.git_placement = "right_align"
    return opts
  end
}
