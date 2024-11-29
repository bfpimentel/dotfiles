return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    keys = {
      { "U", "<cmd>redo<cr>" },
    },
    opts = {},
  },
  {
    "jinh0/eyeliner.nvim",
    lazy = false,
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
        dim = false,
      })
    end,
  },
}
