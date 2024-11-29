return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle" },
  lazy = false,
  opts = function()
    local opts = require("nvchad.configs.nvimtree")
    opts.view.side = "right"
    opts.view.width = 40
    opts.renderer.icons.git_placement = "right_align"
    return opts
  end
}
